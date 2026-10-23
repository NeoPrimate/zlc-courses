import math
import numpy as np
import gurobipy as gp
from gurobipy import GRB
import tomli_w

I, J = 3, 2
S = [150, 150]
R = [3, 1, 2]
A = [(1, 1), (1, 2), (2, 1), (2, 2), (3, 1), (3, 2)]
T = np.array([
    [0.8, 0.6],
    [0.3, 0.4],
    [0.5, 0.6],
])

# Sets
Iset = range(1, I + 1)                       # I
Jset = range(1, J + 1)                       # J
A = gp.tuplelist(A)                          # A

# Parameters
Tp = {(i, j): float(T[i - 1, j - 1]) for (i, j) in A}          # m_ij (time)
Sp = {j: S[j - 1] for j in Jset}                               # 
Rp = {i: R[i - 1] for i in Iset}                               # 

m = gp.Model("products")
m.Params.OutputFlag = 0

# Decision variables (lb=0 by default)
x = m.addVars(A, lb=0, name="x")    # x_ij (Mgal)
y = m.addVar(lb=0, name="y")       # s_j  (Mgal)

# Objective
m.setObjective(y, GRB.MAXIMIZE)

# Constraints
m.addConstrs((x.sum(i, "*") >= Rp[i] * y for i in Iset), name="requirements")
m.addConstrs((gp.quicksum(Tp[i, j] * x[i, j] for i in Iset) <= Sp[j] for j in Jset), name="capacity")

m.optimize()
assert m.Status == GRB.OPTIMAL

def clean(v, ndigits=4):
    """Map Gurobi's ±1e100 to ±inf and round finite values."""
    v = float(v)
    if abs(v) >= 1e30:
        return math.copysign(math.inf, v)
    v = round(v, ndigits)
    return 0.0 if v == 0 else v   # turns -0.0 into 0.0


variables = []
for v in m.getVars():
    obj, up, low = v.Obj, clean(v.SAObjUp), clean(v.SAObjLow)
    variables.append({
        "name": v.VarName,
        "value": clean(v.X),
        "reduced_cost": clean(v.RC),
        "obj_coef": obj,
        "allow_increase": clean(up - obj),
        "allow_decrease": clean(obj - low),
    })

constraints = []
for con in m.getConstrs():
    rhs, slack = con.RHS, con.Slack   # Slack = RHS - LHS
    up, low = clean(con.SARHSUp), clean(con.SARHSLow)
    constraints.append({
        "name": con.ConstrName,
        "value": clean(rhs - slack),
        "shadow_price": clean(con.Pi),
        "rhs": rhs,
        "slack": abs(slack),
        "allow_increase": clean(up - rhs),
        "allow_decrease": clean(rhs - low),
    })

out = {
    "summary": {
        "objective": clean(m.ObjVal),
        "status": "optimal",
    },
    "variables": variables,
    "constraints": constraints,
}

with open("./results/problem_2.toml", "wb") as f:
    tomli_w.dump(out, f)