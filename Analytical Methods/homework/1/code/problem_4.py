import numpy as np
import gurobipy as gp
from gurobipy import GRB
import math
import os
import tomli_w

K = np.array([90, 50, 80, 60])
D = np.array([120, 100, 110])
C = np.array([
    [70, 100, 50],
    [120, 90, 40],
    [70, 30, 110],
    [90, 50, 70],
])

m = gp.Model("steel")
m.Params.OutputFlag = 0

x = m.addMVar(C.shape, name="x")
m.setObjective((C * x).sum(), GRB.MINIMIZE)
supply = m.addConstr(x.sum(axis=1) == K, name="supply")
demand = m.addConstr(x.sum(axis=0) <= D, name="demand")

m.optimize()
assert m.Status == GRB.OPTIMAL

def clean(v, ndigits=4):
    """Map Gurobi's ±1e100 to ±inf and round finite values."""
    v = float(v)
    if abs(v) >= 1e30:
        return math.copysign(math.inf, v)
    v = round(v, ndigits)
    return 0.0 if v == 0 else v   # turns -0.0 into 0.0


SENSE = {GRB.LESS_EQUAL: "<=", GRB.GREATER_EQUAL: ">=", GRB.EQUAL: "=="}

variables = []
for v in m.getVars():
    obj, up, low = v.Obj, clean(v.SAObjUp), clean(v.SAObjLow)
    variables.append({
        "name": v.VarName,                     # x[i,j]
        "value": clean(v.X),
        "reduced_cost": clean(v.RC),
        "obj_coef": obj,
        "allow_increase": clean(up - obj),
        "allow_decrease": clean(obj - low),
    })

constraints = []
for con in m.getConstrs():
    rhs, slack = con.RHS, con.Slack            # Slack = RHS - LHS
    up, low = clean(con.SARHSUp), clean(con.SARHSLow)
    constraints.append({
        "name": con.ConstrName,                # supply[i] / demand[j]
        "sense": SENSE[con.Sense],
        "value": clean(rhs - slack),
        "shadow_price": clean(con.Pi),
        "rhs": rhs,
        "slack": clean(abs(slack)),
        "allow_increase": clean(up - rhs),
        "allow_decrease": clean(rhs - low),
    })

n_s, n_d = C.shape
out = {
    "summary": {
        "objective": clean(m.ObjVal),
        "status": "optimal",
        "K": K.tolist(),
        "D": D.tolist(),
        "c": {f"{i},{j}": int(C[i, j]) for i in range(n_s) for j in range(n_d)},
        "flow": [[clean(val) for val in row] for row in x.X],
    },
    "variables": variables,
    "constraints": constraints,
}

os.makedirs("./results", exist_ok=True)
with open("./results/problem_4.toml", "wb") as f:
    tomli_w.dump(out, f)