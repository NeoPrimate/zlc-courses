import numpy as np
import gurobipy as gp

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

m.addConstr((S @ x).sum() == 5)
m.addConstr(x.sum(axis=0) == 1)

m.optimize()

