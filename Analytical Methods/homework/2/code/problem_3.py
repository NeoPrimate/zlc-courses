import numpy as np
import gurobipy as gp
import tomli_w

CITIES = ["New York", "Los Angeles", "Chicago", "Atlanta"]
REGIONS = ["Region 1", "Region 2", "Region 3"]

K = np.array([
    100,
    100,
    100,
    100,
])

C = np.array([
    400,
    500,
    300,
    150,
])

T = np.array([
    [20, 40, 50],
    [48, 15, 26],
    [26, 35, 18],
    [24, 50, 35],
])

D = np.array([
    80,
    70,
    40,
])

m = gp.Model("wh")

x = m.addMVar(T.shape, name="x")
y = m.addMVar(K.shape, vtype=gp.GRB.BINARY, name="y")

m.setObjective((T * x).sum() + (C * y).sum(), sense=gp.GRB.MINIMIZE)

m.addConstr(x.sum(axis=0) >= D, name="demand")
m.addConstr(x.sum(axis=1) <= K * y, name="capacity")
m.addConstr(y[0] <= y[1], name="ny_implies_la")
m.addConstr(y.sum() <= 2, name="max_two")
m.addConstr(y[1] + y[3] >= 1, name="atl_or_la")

m.optimize()

# ---------------------------------------------------------------- export
yv = np.rint(y.X).astype(int)
xv = x.X
xv = np.where(np.abs(xv) < 1e-9, 0.0, xv)  # clean -0.0 / round-off
shipped = xv.sum(axis=1)
received = xv.sum(axis=0)
ship_cost = float((T * xv).sum())
fixed_cost = float((C * yv).sum())

out = {
    "model": {
        "name": m.ModelName,
        "status": "OPTIMAL" if m.Status == gp.GRB.OPTIMAL else str(m.Status),
        "objective": float(m.ObjVal),
        "fixed_cost": fixed_cost,
        "shipping_cost": ship_cost,
        "n_open": int(yv.sum()),
    },
    "regions": REGIONS,
    "y": yv.tolist(),
    # x[i][j] = units shipped per week from warehouse i to region j
    "x": xv.tolist(),
    "unit_cost": T.tolist(),
    "warehouses": [
        {
            "city": CITIES[i],
            "open": bool(yv[i]),
            "fixed_cost": int(C[i]),
            "capacity": int(K[i]),
            "shipped": float(shipped[i]),
            "shipping_cost": float(T[i] @ xv[i]),
        }
        for i in range(len(CITIES))
    ],
    "demand": [
        {"region": REGIONS[j], "required": int(D[j]), "received": float(received[j])}
        for j in range(len(REGIONS))
    ],
    "logic": {
        "ny_implies_la": bool(yv[0] <= yv[1]),
        "max_two": bool(yv.sum() <= 2),
        "atl_or_la": bool(yv[1] + yv[3] >= 1),
    },
}

with open("./results/p3_results.toml", "wb") as f:
    tomli_w.dump(out, f)