import numpy as np
import gurobipy as gp
from gurobipy import GRB
import math
import os
import tomli_w

H = np.array([
    [400, 500],
    [440, 550],
    [484, 605],
])
C = np.array([
    [8000, 10000],
    [8800, 11000],
    [9680, 12100],
])
D = np.array([
    [1200, 380],
    [2500, 1500],
    [1800, 1200]
])
K = np.array([
    4000,
    3500,
    2000,
])
E = np.array([
    300,
    200,
])
Y0 = np.array([100, 80])

m = gp.Model("steel_path")

x = m.addMVar(C.shape, name="x")
y = m.addMVar(H.shape, name="y")

m.setObjective((C * x + H * y).sum(), GRB.MINIMIZE)

m.addConstr(y[0] == Y0 + x[0] - D[0], name="balance_0")
m.addConstr(y[1:] == y[:-1] + x[1:] - D[1:], name="balance")
m.addConstr(x.sum(axis=1) <= K, name="capacity")
m.addConstr(y[-1] >= E, name="end_inventory")

m.optimize()

##########################################################################################
##########################################################################################

# Y0 = np.array([100, 80])
# H = np.array([
#     [400, 500],
#     [440, 550],
#     [484, 605],
# ])
# C = np.array([
#     [8000, 10000],
#     [8800, 11000],
#     [9680, 12100],
# ])
# D = np.array([
#     [1200, 380],
#     [2500, 1500],
#     [1800, 1200]
# ])
# K = np.array([
#     4000,
#     3500,
#     2000,
# ])
# E = np.array([
#     300,
#     200,
# ])

# m = gp.Model("steel_paths")
# m.Params.OutputFlag = 0

# x = m.addMVar(C.shape, name="x")
# y = m.addMVar(C.shape, name="y")

# m.setObjective((C * x + H * y).sum(), GRB.MINIMIZE)
# m.addConstr(y[0, :] == Y0 + x[0, :] - D[0, :], name="balance_q1")
# m.addConstr(y[1:, :] == y[:-1, :] + x[1:, :] - D[1:, :], name="balance")
# m.addConstr(x.sum(axis=1) <= K, name="capacity")
# m.addConstr(y[-1, :] >= E, name="end_inventory")

# m.optimize()
# assert m.Status == GRB.OPTIMAL


# def clean(v, ndigits=4):
#     """Map Gurobi's ±1e100 to ±inf and round finite values."""
#     v = float(v)
#     if abs(v) >= 1e30:
#         return math.copysign(math.inf, v)
#     v = round(v, ndigits)
#     return 0.0 if v == 0 else v   # turns -0.0 into 0.0


# SENSE = {GRB.LESS_EQUAL: "<=", GRB.GREATER_EQUAL: ">=", GRB.EQUAL: "=="}

# variables = []
# for v in m.getVars():
#     obj, up, low = v.Obj, clean(v.SAObjUp), clean(v.SAObjLow)
#     variables.append({
#         "name": v.VarName,                     # x[i,j]
#         "value": clean(v.X),
#         "reduced_cost": clean(v.RC),
#         "obj_coef": obj,
#         "allow_increase": clean(up - obj),
#         "allow_decrease": clean(obj - low),
#     })

# constraints = []
# for con in m.getConstrs():
#     rhs, slack = con.RHS, con.Slack            # Slack = RHS - LHS
#     up, low = clean(con.SARHSUp), clean(con.SARHSLow)
#     constraints.append({
#         "name": con.ConstrName,                # supply[i] / demand[j]
#         "sense": SENSE[con.Sense],
#         "value": clean(rhs - slack),
#         "shadow_price": clean(con.Pi),
#         "rhs": rhs,
#         "slack": clean(abs(slack)),
#         "allow_increase": clean(up - rhs),
#         "allow_decrease": clean(rhs - low),
#     })
    
# mat = lambda A: [[clean(v) for v in r] for r in A]

# out = {
#     "summary": {
#         "objective": clean(m.ObjVal),
#         "status": "optimal",
#         "C_jm": C.tolist(),                 # rows = quarters, cols = A21, B32
#         "H_jm": H.tolist(),
#         "production_jm": mat(x.X),
#         "inventory_jm": mat(y.X),
#         "total_production_j": [clean(v) for v in x.X.sum(axis=1)],
#     },
#     "variables": variables,
#     "constraints": constraints,
# }


# os.makedirs("./results", exist_ok=True)
# with open("./results/problem_5.toml", "wb") as f:
#     tomli_w.dump(out, f)