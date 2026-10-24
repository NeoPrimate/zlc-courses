import numpy as np
import gurobipy as gp
from gurobipy import GRB
import math
import os
import tomli_w

S = np.array([300, 300])
D = np.array([200, 100, 300])
C_ij = np.array([
    [16, 10, 12],
    [15, 14, 17],
])
C_jk = np.array([
    [6, 8, 10],
    [7, 11, 11],
    [4, 5, 12],
])

C = C_ij[:, :, None] + C_jk[None, :, :]

m = gp.Model("steel_paths")
m.Params.OutputFlag = 0

x = m.addMVar(C.shape, name="x")

m.setObjective((C * x).sum(), GRB.MINIMIZE)
supply = m.addConstr(x.sum(axis=2).sum(axis=1) <= S, name="supply")
demand = m.addConstr(x.sum(axis=0).sum(axis=0) == D, name="demand")

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

X = x.X
out = {
    "summary": {
        "objective": clean(m.ObjVal), 
        "status": "optimal",
        "C_ijk": C.tolist(),
        "flow_ijk":   [[[clean(v) for v in r] for r in M] for M in X],
        "flow_in_ij": [[clean(v) for v in r] for r in X.sum(axis=2)],   # supplier→hub
        "flow_out_jk":[[clean(v) for v in r] for r in X.sum(axis=0)],   # hub→market
    },
    "variables": variables,
    "constraints": constraints,
}


os.makedirs("./results", exist_ok=True)
with open("./results/problem_7.toml", "wb") as f:
    tomli_w.dump(out, f)