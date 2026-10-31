import gurobipy as gp
from gurobipy import GRB

N = [1, 2, 3, 4]
P = [1, 2]
T = ["LO", "HI"]

M = [[0, 5, 3, 3],
     [5, 0, 3, 7],
     [3, 3, 0, 5],
     [3, 7, 5, 0]]

arcs, dist = gp.multidict({
    (i, j): M[i - 1][j - 1]
    for i in N for j in N if i != j
})

q = {"LO": 10, "HI": 18}
c = {"LO": 6, "HI": 10}
d = {(2, 1): 2, (2, 2): 8, (3, 1): 4, (3, 2): 4, (4, 1): 8, (4, 2): 2}

m = gp.Model("vesel")
x = m.addVars(arcs, P, lb=0, name="x")
y = m.addVars(arcs, T, vtype=GRB.INTEGER, name="y")

m.setObjective(
    gp.quicksum(c[t] * dist[i, j] * y[i, j, t] for i, j in arcs for t in T),
    GRB.MINIMIZE,
)

m.addConstrs(
    (x.sum("*", j, p) - x.sum(j, "*", p) == d[j, p]
     for j in N if j != 1 for p in P),
    name="flow",
)

m.addConstrs(
    (x.sum(i, j, "*") <= gp.quicksum(q[t] * y[i, j, t] for t in T)
     for i, j in arcs),
    name="cap",
)

m.optimize()


