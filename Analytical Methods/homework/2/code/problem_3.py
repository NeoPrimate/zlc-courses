import numpy as np
import gurobipy as gp

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