import numpy as np
import gurobipy as gp
import tomli_w

d = np.array([420, 870, 1250, 930, 1310])

p = np.array([450, 480, 505, 490, 515])

p0 = 440

f = np.array([
    [2000, 1200],
    [1600, 1000],
    [1800, 1100],
    [1200,  700],
    [1650, 1050],
])

g = np.array([25, 20, 23, 15, 22])

q = np.array([200, 100])

tau = np.array([30, 21, 28, 18, 25])

c = np.array([
    [0, 35, 10, 35, 25],
    [35, 0, 25, 70, 15],
    [10, 25, 0, 45, 15],
    [35, 70, 45, 0, 55],
    [25, 15, 15, 55, 0],
])

h = 0.15
U = 500

I, K = f.shape

############################################################
############################################################

cities = ["Adelaide", "Brisbane", "Melbourne", "Perth", "Sydney"]

def export(model, X, Y, Z=None, V=None):
    """Write model results to <model.ModelName>.toml.
 
    X, Y, Z, V are numpy arrays of solution values (x.X, y.X, ...).
    Z and V default to zeros, for models without road or Domes.
    """
    if model.Status != gp.GRB.OPTIMAL:
        raise RuntimeError(f"{model.ModelName}: status {model.Status}")
 
    Z = np.zeros((I, I)) if Z is None else Z
    V = np.zeros(I) if V is None else V
 
    ovis      = X @ q + Y                         # units landed from Ovis
    road_in   = Z.sum(axis=0)
    road_out  = Z.sum(axis=1)
 
    # per-city costs (road charged to the origin city)
    c_purchase = p0 * ovis
    c_freight  = (f * X).sum(axis=1) + g * Y
    c_holding  = h / 365 * p0 * tau * ovis
    c_road     = (c * Z).sum(axis=1)
    c_domes    = p * V
    c_total    = c_purchase + c_freight + c_holding + c_road + c_domes
 
    site = [cities[i] for i in range(I) if V[i] > 1e-6]
 
    out = {
        "summary": {
            "model":      model.ModelName,
            "objective":  float(model.ObjVal),
            "purchase":   float(c_purchase.sum()),
            "freight":    float(c_freight.sum()),
            "holding":    float(c_holding.sum()),
            "road":       float(c_road.sum()),
            "domes":      float(c_domes.sum()),
            "domes_site": site[0] if site else "none",
            "units_ovis": int(round(ovis.sum())),
            "units_domes": int(round(V.sum())),
        },
        "city": [
            {
                "name":      cities[i],
                "demand":    int(d[i]),
                "x40":       int(round(X[i, 0])),
                "x20":       int(round(X[i, 1])),
                "lcl":       int(round(Y[i])),
                "ovis":      int(round(ovis[i])),
                "domes":     int(round(V[i])),
                "road_in":   int(round(road_in[i])),
                "road_out":  int(round(road_out[i])),
                "purchase":  float(c_purchase[i]),
                "freight":   float(c_freight[i]),
                "holding":   float(c_holding[i]),
                "road":      float(c_road[i]),
                "domes_cost": float(c_domes[i]),
                "total":     float(c_total[i]),
                "unit_cost": float(c_total[i] / d[i]),
            }
            for i in range(I)
        ],
        "road": [
            {"from": cities[i], "to": cities[j], "units": int(round(Z[i, j]))}
            for i in range(I) for j in range(I)
            if i != j and Z[i, j] > 1e-6
        ],
    }
 
    with open(f"./results/{model.ModelName}.toml", "wb") as fh:
        tomli_w.dump(out, fh)
 

############################################################
############################################################

m1 = gp.Model("Oz_Ovis")

x = m1.addMVar(f.shape, vtype=gp.GRB.INTEGER, name="x")
y = m1.addMVar(d.shape, name="y")

purchase = (x @ q * p0).sum() + (p0 * y).sum()
freight  = (f * x).sum() + g @ y
holding  = (h / 365 * p0 * tau * (x @ q)).sum() + (h / 365 * p0 * tau * y).sum()

m1.setObjective(
    (
        purchase +
        freight +
        holding
    ), 
sense=gp.GRB.MINIMIZE)

m1.addConstr(x @ q + y >= d, name="demand")

m1.optimize()

export(m1, x.X, y.X)


############################################################
############################################################

m2 = gp.Model("Oz_Ovis_Dome")

x = m2.addMVar(f.shape, vtype=gp.GRB.INTEGER, name="x")
y = m2.addMVar(d.shape, name="y")
z = m2.addMVar(c.shape, name="z")
w = m2.addMVar(d.shape, vtype=gp.GRB.BINARY, name="w")
v = m2.addMVar(d.shape, name="v")

purchase = (x @ q * p0).sum() + (p0 * y).sum()
freight  = (f * x).sum() + g @ y
holding  = (h / 365 * p0 * tau * (x @ q)).sum() + (h / 365 * p0 * tau * y).sum()
road     = (c * z).sum()
domes    = p @ v

m2.setObjective(purchase + freight + holding + road + domes, gp.GRB.MINIMIZE)


m2.addConstr(x @ q + y + v + z.sum(axis=0) >= d + z.sum(axis=1), name="flow")
m2.addConstr(w.sum() == 1, name="")
m2.addConstr(v <= U * w, name="")

m2.optimize()

export(m2, x.X, y.X, z.X, v.X)