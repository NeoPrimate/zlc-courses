import numpy as np
import gurobipy as gp
import tomli_w

TOTAL_SPOTS = 5

# R[s, p] = profit ($M) of giving s spots to product p
R = np.array([
    [0, 0, 0],
    [1, 0, -1],
    [3, 2, 2],
    [3, 3, 4],
])

S, P = R.shape

S = np.arange(S)

m = gp.Model("supersuds")

x = m.addMVar(R.shape, vtype=gp.GRB.BINARY, name="x")

m.setObjective((R * x).sum(), sense=gp.GRB.MAXIMIZE)

m.addConstr((S @ x).sum() == TOTAL_SPOTS, name="spots")
m.addConstr(x.sum(axis=0) == 1, name="one_level")

m.optimize()

# ---------------------------------------------------------------- export
xv = np.rint(x.X).astype(int)
spots = S @ xv                  # spots allocated to each product
profit = (R * xv).sum(axis=0)   # profit earned by each product

out = {
    "model": {
        "name": m.ModelName,
        "status": "OPTIMAL" if m.Status == gp.GRB.OPTIMAL else str(m.Status),
        "objective_millions": float(m.ObjVal),
        "total_spots": TOTAL_SPOTS,
        "max_spots_per_product": int(S.max()),
        "n_products": int(P),
    },
    # x[s][p] = 1 if product p+1 receives exactly s spots
    "x": xv.tolist(),
    "profit_table": R.tolist(),
    "products": [
        {
            "id": p + 1,
            "spots": int(spots[p]),
            "profit": int(profit[p]),
        }
        for p in range(P)
    ],
}

with open("./results/p2_results.toml", "wb") as f:
    tomli_w.dump(out, f)