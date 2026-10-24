import numpy as np
import gurobipy as gp
from gurobipy import GRB
import math
import os
import tomli_w

S = np.array([93, 88, 95])
D = np.array([30, 57, 48, 91, 48])
C_ij = np.array([
    [1.52, 1.60, 1.40],
    [1.70, 1.63, 1.55],
    [1.45, 1.57, 1.30],
])
C_jk = np.array([
    [5.15, 5.69, 6.13, 5.63, 5.80],
    [5.12, 5.47, 6.05, 6.12, 5.71],
    [5.32, 6.16, 6.25, 6.17, 5.87],
])

m = gp.Model("steel")
m.Params.OutputFlag = 0

x = m.addMVar(C_ij.shape, name="x")
y = m.addMVar(C_jk.shape, name="y")

m.setObjective((C_ij * x).sum() + (C_jk * y).sum(), GRB.MINIMIZE)
supply  = m.addConstr(x.sum(axis=1) <= S, name="supply")
demand  = m.addConstr(y.sum(axis=0) == D, name="demand")
balance = m.addConstr(x.sum(axis=0) == y.sum(axis=1), name="balance")

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
    
out = {
    "summary": {
        "objective": clean(m.ObjVal), "status": "optimal",
        "S": S.tolist(), "D": D.tolist(),
        "C_ij": C_ij.tolist(), "C_jk": C_jk.tolist(),
        "flow_well_pump":     [[clean(v) for v in r] for r in x.X],
        "flow_pump_refinery": [[clean(v) for v in r] for r in y.X],
    },
    "variables": variables,
    "constraints": constraints,
}

os.makedirs("./results", exist_ok=True)
with open("./results/problem_6.toml", "wb") as f:
    tomli_w.dump(out, f)