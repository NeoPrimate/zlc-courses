import numpy as np
import gurobipy as gp

n = 40
rng = np.random.default_rng(7)
Cij = rng.integers(1, 20, size=(n, n))
np.fill_diagonal(Cij, 20)

N, _ = Cij.shape

m = gp.Model("tsp")

Xij = m.addMVar((N, N), vtype=gp.GRB.BINARY, ub=1 - np.eye(N), name="x")
Yi = m.addMVar((N,), lb=1, ub=N - 1, name="y")

m.setObjective((Cij * Xij).sum())

m.addConstr(Xij.sum(0) == 1, name="in")
m.addConstr(Xij.sum(1) == 1, name="out")

Y = Yi[1:]
m.addConstr(Y[:, None] - Y[None, :] + N * Xij[1:, 1:] <= N - 1, name="mtz")

m.optimize()