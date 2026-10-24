import math
import numpy as np
import gurobipy as gp
from gurobipy import GRB
import tomli_w

I, J = 3, 3
S = [6, 5, 6]
D = [4, 8, 7]
A = [(1, 1), (1, 2), (2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (3, 3)]
M = np.array([
    [120, 180, np.nan],
    [300, 100, 80],
    [200, 250, 120],
])

# Sets
Iset = range(1, I + 1)                       # I
Jset = range(1, J + 1)                       # J
JS = [2, 3]                                  # J^S
A = gp.tuplelist(A)                          # A

# Parameters
Sp = {i: S[i - 1] for i in Iset}                               # S_i (Mgal)
Dp = {j: D[j - 1] for j in Jset}                               # D_j (Mgal)
mp = {(i, j): float(M[i - 1, j - 1]) for (i, j) in A}          # m_ij (miles)
c = {(i, j): 10 * mp[i, j] for (i, j) in A}                    # c_ij (k$/Mgal)
p = 5_000                                                      # p (k$/Mgal)

m = gp.Model("refineries")
m.Params.OutputFlag = 0

# Decision variables (lb=0 by default)
x = m.addVars(A, name="x")    # x_ij (Mgal)
s = m.addVars(JS, name="s")   # s_j  (Mgal)

# Objective
m.setObjective(x.prod(c) + p * s.sum(), GRB.MINIMIZE)

# Constraints
m.addConstrs((x.sum(i, "*") <= Sp[i] for i in Iset), name="capacity")
m.addConstrs(
    (x.sum("*", j) + (s[j] if j in JS else 0) == Dp[j] for j in Jset),
    name="demand",
)

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
        "allow_increase": up - obj,
        "allow_decrease": obj - low,
    })

constraints = []
for con in m.getConstrs():
    rhs, slack = con.RHS, con.Slack   # Slack = RHS - LHS
    up, low = clean(con.SARHSUp), clean(con.SARHSLow)
    constraints.append({
        "name": con.ConstrName,
        "value": rhs - slack,
        "shadow_price": con.Pi,
        "rhs": rhs,
        "slack": abs(slack),
        "allow_increase": up - rhs,
        "allow_decrease": rhs - low,
    })

out = {
    "summary": {
        "objective": m.ObjVal,
        "status": "optimal",
        "p": p,
        "c": {f"{i},{j}": c[i, j] for (i, j) in A},
    },
    "variables": variables,
    "constraints": constraints,
}

with open("./results/problem_1.toml", "wb") as f:
    tomli_w.dump(out, f)