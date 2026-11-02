import numpy as np
import gurobipy as gp
import tomli_w


P = np.array([
    [1, 0, 0, 0, 1, 0, 0, 0, 1, 0],
    [0, 1, 0, 1, 0, 1, 0, 0, 1, 1],
    [0, 0, 1, 1, 0, 0, 1, 0, 1, 0],
    [1, 0, 0, 0, 0, 1, 0, 1, 0, 0],
    [0, 0, 1, 1, 0, 1, 0, 0, 0, 0],
    [0, 1, 0, 0, 1, 0, 0, 0, 0, 0],
    [1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
    [0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
    [0, 1, 0, 1, 0, 0, 1, 0, 0, 0],
])

T = np.array([
    6,
    4,
    7,
    5,
    4,
    6,
    5,
    3,
    7,
    6,
])

MAX = 3

m = gp.Model("speedy")

x = m.addMVar(T.shape, vtype=gp.GRB.BINARY, name="x")

m.setObjective((T * x).sum())

m.addConstr(P @ x == 1, name="")
m.addConstr(x.sum() == MAX, name="")

m.optimize()

# ---------------------------------------------------------------- export
LOCATIONS = list("ABCDEFGHI")

ORDER = np.array([
    [1, 0, 0, 0, 1, 0, 0, 0, 1, 0],  # A
    [0, 2, 0, 1, 0, 2, 0, 0, 2, 2],  # B
    [0, 0, 3, 3, 0, 0, 3, 0, 3, 0],  # C
    [2, 0, 0, 0, 0, 1, 0, 1, 0, 0],  # D
    [0, 0, 2, 2, 0, 3, 0, 0, 0, 0],  # E
    [0, 1, 0, 0, 2, 0, 0, 0, 0, 0],  # F
    [3, 0, 0, 0, 0, 0, 1, 2, 0, 3],  # G
    [0, 0, 1, 0, 3, 0, 0, 0, 0, 1],  # H
    [0, 3, 0, 4, 0, 0, 2, 0, 0, 0],  # I
])

xv = np.rint(x.X).astype(int)
covered = P @ xv 
 
def stops(j):
    """Locations on route j, in delivery order."""
    idx = [i for i in range(len(LOCATIONS)) if ORDER[i, j] > 0]
    return [LOCATIONS[i] for i in sorted(idx, key=lambda i: ORDER[i, j])]
 
 
out = {
    "model": {
        "name": m.ModelName,
        "status": "OPTIMAL" if m.Status == gp.GRB.OPTIMAL else str(m.Status),
        "objective_hours": float(m.ObjVal),
        "trucks": MAX,
        "n_routes": int(T.size),
        "n_locations": len(LOCATIONS),
    },
    "x": xv.tolist(),
    "routes": [
        {
            "id": j + 1,
            "time": int(T[j]),
            "selected": bool(xv[j]),
            "stops": stops(j),
        }
        for j in range(T.size)
    ],
    "locations": [
        {
            "name": LOCATIONS[i],
            "covered": int(covered[i]),
            "route": int(np.flatnonzero(P[i] * xv)[0] + 1),
        }
        for i in range(len(LOCATIONS))
    ],
}
 
with open("./results/p1_results.toml", "wb") as f:
    tomli_w.dump(out, f)