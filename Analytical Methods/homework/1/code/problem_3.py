import math
from pathlib import Path
import gurobipy as gp
from gurobipy import GRB
import tomli_w

# Data
M = [1500, 1700, 1300, 2700]
P = [88, 15, 105, 95]
k = 12000
r = 600
e0 = 600          # initial stock e_0 -- set to your problem's value

Iset = range(1, len(M) + 1)
Mp = {i: M[i - 1] for i in Iset}
Pp = {i: P[i - 1] for i in Iset}

m = gp.Model("refineries")
m.Params.OutputFlag = 0

x = m.addVars(Iset, name="x")
s = m.addVars(Iset, name="s")
e = m.addVars(Iset, name="e")

def prev_end(i):
    return e0 if i == 1 else e[i - 1]

m.setObjective(x.prod(Pp), GRB.MINIMIZE)

m.addConstrs((s[i] == prev_end(i) + x[i] for i in Iset), name="balance")
m.addConstrs((s[i] - e[i] == Mp[i] * (1 + (s[i] + e[i]) / 4000) for i in Iset), name="consumption")
m.addConstrs((s[i] <= k for i in Iset), name="capacity")
m.addConstrs((e[i] >= r for i in Iset), name="reserve")

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
        "slack": clean(abs(slack)),
        "allow_increase": clean(up - rhs),
        "allow_decrease": clean(rhs - low),
    })

out = {
    "summary": {
        "objective": clean(m.ObjVal),
        "status": "optimal",
        "M": Mp and {str(i): Mp[i] for i in Iset},
        "P": {str(i): Pp[i] for i in Iset},
        "k": k,
        "r": r,
        "e0": e0,
    },
    "variables": variables,
    "constraints": constraints,
}

Path("results").mkdir(exist_ok=True)
with open("results/problem_3.toml", "wb") as f:
    tomli_w.dump(out, f)