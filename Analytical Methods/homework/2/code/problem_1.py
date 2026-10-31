import numpy as np
import gurobipy as gp

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