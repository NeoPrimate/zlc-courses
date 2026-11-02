"""Oz Sourcing case (Wu 2020): Ovis sea freight, road rebalancing, Domes site.

Q1  Current practice: ship directly from Ovis to each city (no road).
Q2  Best plan without Domes: Ovis + road transport between cities.
Q3  Best Domes site: Ovis + road + Domes (one city, 500 units).
Q4  Monthly savings from engaging Domes (vs. the best plan without Domes).
"""

from pathlib import Path

import gurobipy as gp
import numpy as np
import tomli_w

# ----------------------------------------------------------------------------
# Data
# ----------------------------------------------------------------------------
cities = ["Adelaide", "Brisbane", "Melbourne", "Perth", "Sydney"]

d   = np.array([420, 870, 1250, 930, 1310])        # monthly demand
p   = np.array([450, 480, 505, 490, 515])          # Domes unit cost by site
p0  = 440                                          # Ovis delivered unit cost
f   = np.array([                                   # $/container [40', 20']
    [2000, 1200],
    [1600, 1000],
    [1800, 1100],
    [1200,  700],
    [1650, 1050],
])
g   = np.array([25, 20, 23, 15, 22])               # $/LCL unit
q   = np.array([200, 100])                         # container capacity
tau = np.array([30, 21, 28, 18, 25])               # sea lead time (days)
c   = np.array([                                   # road $/unit, origin x dest
    [ 0, 35, 10, 35, 25],
    [35,  0, 25, 70, 15],
    [10, 25,  0, 45, 15],
    [35, 70, 45,  0, 55],
    [25, 15, 15, 55,  0],
])
h = 0.15                                           # annual interest rate
U = 500                                            # Domes units per month

I, K = f.shape
hc = h / 365 * p0 * tau                            # in-transit holding $/unit

# True  -> Domes produces exactly U units ("commission 500 units every month")
# False -> Domes produces up to U units
DOMES_EXACT = False

RESULTS = Path("./results")
RESULTS.mkdir(exist_ok=True)


# ----------------------------------------------------------------------------
# Model
# ----------------------------------------------------------------------------
def build(name, road=False, domes=False, exact=DOMES_EXACT):
    """Single formulation; Q1/Q2/Q3 just switch road and Domes on or off."""
    m = gp.Model(name)
    m.Params.OutputFlag = 0
    m.Params.MIPGap = 0          # default 1e-4 (~$216 here) can hide the answer

    x = m.addMVar((I, K), vtype=gp.GRB.INTEGER, name="x")   # full containers
    y = m.addMVar(I, vtype=gp.GRB.INTEGER, name="y")        # LCL units
    z = m.addMVar((I, I), vtype=gp.GRB.INTEGER, name="z")   # road i -> j
    v = m.addMVar(I, name="v")                              # Domes units
    w = m.addMVar(I, vtype=gp.GRB.BINARY, name="w")         # Domes site

    ovis = x @ q + y                                        # units landed

    purchase = p0 * ovis.sum()
    freight  = (f * x).sum() + g @ y
    holding  = hc @ ovis
    roadcost = (c * z).sum()
    domescost = p @ v

    m.setObjective(purchase + freight + holding + roadcost + domescost,
                   gp.GRB.MINIMIZE)

    # supply + road in - road out >= demand
    m.addConstr(ovis + v + z.sum(axis=0) - z.sum(axis=1) >= d, name="flow")

    # no shipping a city to itself
    m.addConstr(z[np.arange(I), np.arange(I)] == 0, name="no_self")

    if not road:
        m.addConstr(z == 0, name="no_road")

    if domes:
        m.addConstr(w.sum() == 1, name="one_site")
        if exact:
            m.addConstr(v == U * w, name="domes_cap")
        else:
            m.addConstr(v <= U * w, name="domes_cap")
    else:
        m.addConstr(v == 0, name="no_domes")
        m.addConstr(w == 0, name="no_site")

    m.optimize()
    if m.Status != gp.GRB.OPTIMAL:
        raise RuntimeError(f"{name}: status {m.Status}")

    sol = {k: np.round(var.X) if k != "v" else var.X
           for k, var in dict(x=x, y=y, z=z, v=v).items()}
    return m, sol


# ----------------------------------------------------------------------------
# Export
# ----------------------------------------------------------------------------
def export(model, X, Y, Z, V):
    """Write model results to ./results/<model.ModelName>.toml."""
    ovis     = X @ q + Y
    road_in  = Z.sum(axis=0)
    road_out = Z.sum(axis=1)

    # per-city costs (road charged to the origin city)
    c_purchase = p0 * ovis
    c_freight  = (f * X).sum(axis=1) + g * Y
    c_holding  = hc * ovis
    c_road     = (c * Z).sum(axis=1)
    c_domes    = p * V
    c_total    = c_purchase + c_freight + c_holding + c_road + c_domes

    site = [cities[i] for i in range(I) if V[i] > 1e-6]

    out = {
        "summary": {
            "model":       model.ModelName,
            "objective":   float(model.ObjVal),
            "purchase":    float(c_purchase.sum()),
            "freight":     float(c_freight.sum()),
            "holding":     float(c_holding.sum()),
            "road":        float(c_road.sum()),
            "domes":       float(c_domes.sum()),
            "domes_site":  site[0] if site else "none",
            "units_ovis":  int(round(ovis.sum())),
            "units_domes": int(round(V.sum())),
        },
        "city": [
            {
                "name":       cities[i],
                "demand":     int(d[i]),
                "x40":        int(X[i, 0]),
                "x20":        int(X[i, 1]),
                "lcl":        int(Y[i]),
                "ovis":       int(ovis[i]),
                "domes":      int(round(V[i])),
                "road_in":    int(road_in[i]),
                "road_out":   int(road_out[i]),
                "purchase":   float(c_purchase[i]),
                "freight":    float(c_freight[i]),
                "holding":    float(c_holding[i]),
                "road":       float(c_road[i]),
                "domes_cost": float(c_domes[i]),
                "total":      float(c_total[i]),
                "unit_cost":  float(c_total[i] / d[i]),
            }
            for i in range(I)
        ],
        "road": [
            {"from": cities[i], "to": cities[j], "units": int(Z[i, j])}
            for i in range(I) for j in range(I)
            if i != j and Z[i, j] > 0
        ],
    }

    with open(RESULTS / f"{model.ModelName}.toml", "wb") as fh:
        tomli_w.dump(out, fh)


# ----------------------------------------------------------------------------
# Run
# ----------------------------------------------------------------------------
if __name__ == "__main__":
    m1, s1 = build("Oz_Ovis")                              # Q1
    m2, s2 = build("Oz_Ovis_Road", road=True)              # Q2
    m3, s3 = build("Oz_Ovis_Road_Domes", road=True, domes=True)  # Q3

    for m, s in [(m1, s1), (m2, s2), (m3, s3)]:
        export(m, s["x"], s["y"], s["z"], s["v"])

    site = cities[int(np.argmax(s3["v"]))]

    print(f"Q1  Current practice (direct):      ${m1.ObjVal:,.2f}")
    print(f"Q2  Best without Domes (with road): ${m2.ObjVal:,.2f}"
          f"  -> saves ${m1.ObjVal - m2.ObjVal:,.2f}; "
          f"current practice best? {'YES' if m1.ObjVal - m2.ObjVal < 0.005 else 'NO'}")
    print(f"Q3  Domes site: {site} ({s3['v'].sum():.0f} units"
          f", {'exactly' if DOMES_EXACT else 'up to'} {U})  ${m3.ObjVal:,.2f}")
    print(f"Q4  Savings from Domes vs Q2 best:  ${m2.ObjVal - m3.ObjVal:,.2f}/month"
          f"  (vs current practice: ${m1.ObjVal - m3.ObjVal:,.2f})")