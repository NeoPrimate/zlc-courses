# import numpy as np
# import pyomo.environ as pyo
# from itertools import product

# P, S, F = 2, 6, 7

# # a_ijr: unit transport cost plant i -> silo j -> farm r, shape (I, J, R)
# A = np.array([
#     [  # Plant 1
#         [4.56, 5.16, 4.68, 4.92, 5.28, 4.44, 3.48],  # Silo 1
#         [5.52, 5.16, 5.04, 5.76, 4.32, 5.16, 5.40],  # Silo 2
#         [5.40, 4.32, 4.20, 4.56, 4.92, 3.24, 4.32],  # Silo 3
#         [4.56, 5.40, 3.72, 6.36, 5.16, 5.40, 3.84],  # Silo 4
#         [5.52, 4.20, 3.96, 4.08, 3.00, 3.84, 3.96],  # Silo 5
#         [5.16, 5.04, 6.48, 5.52, 5.64, 5.16, 3.96],  # Silo 6
#     ],
#     [  # Plant 2
#         [4.44, 5.04, 4.56, 4.80, 5.16, 4.32, 3.36],  # Silo 1
#         [5.16, 4.80, 4.68, 5.40, 3.96, 4.80, 5.04],  # Silo 2
#         [6.24, 5.16, 5.04, 5.40, 5.76, 4.08, 5.16],  # Silo 3
#         [5.28, 6.12, 4.44, 7.08, 5.88, 6.12, 4.56],  # Silo 4
#         [6.60, 5.28, 5.04, 5.16, 4.08, 4.92, 5.04],  # Silo 5
#         [4.68, 4.56, 6.00, 5.04, 5.16, 4.68, 3.48],  # Silo 6
#     ],
# ], dtype=float)

# # Silo parameters (j ∈ V2)
# Q = np.array([80, 90, 110, 120, 100, 120], dtype=float)        # capacity q_j
# C = np.array([220, 240, 260, 275, 240, 230], dtype=float)      # fixed cost f_j
# G = np.array([0.15, 0.18, 0.20, 0.18, 0.15, 0.17])             # marginal cost g_j

# # Farm parameters (r ∈ V3)
# D  = np.array([36, 42, 34, 50, 27, 30, 43], dtype=float)       # demand d_r
# SC = np.full(F, 7.0)                                           # shortage cost SC_r

# # Plant parameters (i ∈ V1)
# O  = np.array([120, 150], dtype=float)                         # supply o_i
# IC = np.array([4.0, 3.0])                                      # inventory cost IC_i

# assert A.shape == (P, S, F)
# assert Q.shape == C.shape == G.shape == (S,)
# assert D.shape == SC.shape == (F,)
# assert O.shape == IC.shape == (P,)
# print(f"supply={O.sum()}, demand={D.sum()}, silo capacity={Q.sum()}")

# m = pyo.ConcreteModel()

# # SETS
# m.P = pyo.RangeSet(1, P)
# m.S = pyo.RangeSet(1, S)
# m.F = pyo.RangeSet(1, F)

# # VARS
# m.A = pyo.Param(m.P, m.S, m.F, initialize=dict(zip(product(m.P, m.S, m.F), A.ravel().tolist())))
# m.s     = pyo.Var(m.P, m.S, m.F, domain=pyo.NonNegativeReals)  # s_ijr
# m.y     = pyo.Var(m.S, domain=pyo.Binary)                        # y_j
# m.s_pos = pyo.Var(m.P, domain=pyo.NonNegativeReals)              # s_i^+  (unshipped supply)
# m.s_neg = pyo.Var(m.F, domain=pyo.NonNegativeReals)              # s_r^-  (unmet demand)

# def throughput(m, j):
#     return sum(m.s[i, j, r] for i in m.V1 for r in m.V3)

# @m.Objective(sense=pyo.minimize)
# def objective(m):
#     transport  = sum(m.A[i, j, r] * m.s[i, j, r] for i in m.P for j in m.S for r in m.F)
#     facilities = sum(F[j] * m.y[j] + G[j] * throughput(m, j) for j in m.S)
#     inventory  = sum(IC[i] * m.s_pos[i] for i in m.P)
#     shortage   = sum(SC[r] * m.s_neg[r] for r in m.F)
#     return transport + facilities + inventory + shortage

# # @m.Constraint(m.V1)
# # def supply_rule(m, i):
# #     return sum(m.s[i, j, r] for j in m.V2 for r in m.V3) + m.s_pos[i] == O[i]

# # @m.Constraint(m.V3)
# # def demand_rule(m, r):
# #     return sum(m.s[i, j, r] for i in m.V1 for j in m.V2) + m.s_neg[r] == D[r]


# # def open_rule(m, j):
# #     return throughput(m, j) <= Q[j] * m.y[j]
# # m.open = pyo.Constraint(m.V2, rule=open_rule)


# # solver = pyo.SolverFactory("gurobi")   # or "gurobi", "cbc", "glpk"
# # result = solver.solve(m, tee=False)

# # if result.solver.termination_condition == pyo.TerminationCondition.optimal:
# #     print("\nOpen silos:", [j + 1 for j in m.V2 if pyo.value(m.y[j]) > 0.5])
# #     print("\nFlows (plant -> silo -> farm):")
# #     for i in m.V1:
# #         for j in m.V2:
# #             for r in m.V3:
# #                 v = pyo.value(m.s[i, j, r])
# #                 if v > 1e-6:
# #                     print(f"  P{i+1} -> S{j+1} -> F{r+1}: {v:.1f}")
# #     print("\nUnshipped supply:", {f"P{i+1}": round(pyo.value(m.s_pos[i]), 1) for i in m.V1})
# #     print("Shortage:        ", {f"F{r+1}": round(pyo.value(m.s_neg[r]), 1) for r in m.V3})
# #     print(f"\nTotal cost: {pyo.value(m.objective):.2f}")
# # else:
# #     print("Solver status:", result.solver.termination_condition)


# # # plants = [f"P{i+1}" for i in range(I)]
# # # silos  = [f"S{j+1}" for j in range(J)]
# # # farms  = [f"F{r+1}" for r in range(R)]

# # # m = pyo.ConcreteModel()

# # # # SETS
# # # m.P = pyo.Set(initialize=plants, ordered=True)
# # # m.S = pyo.Set(initialize=silos,  ordered=True)
# # # m.F = pyo.Set(initialize=farms,  ordered=True)

# # # m.A = pyo.Param(m.V1, m.V2, m.V3, initialize={
# # #     (p, s, f): float(A[m.P.ord(p) - 1, m.S.ord(s) - 1, m.F.ord(f) - 1])
# # #     for p in m.P
# # #     for s in m.S
# # #     for f in m.F
# # # })

# # print(A.ravel().tolist())


import numpy as np
import gurobipy as gp
from gurobipy import GRB

P, S, F = 2, 6, 7  # plants, silos, farms

# a_ijr: unit transport cost plant i -> silo j -> farm r, shape (P, S, F)
A = np.array([
    [  # Plant 1
        [4.56, 5.16, 4.68, 4.92, 5.28, 4.44, 3.48],  # Silo 1
        [5.52, 5.16, 5.04, 5.76, 4.32, 5.16, 5.40],  # Silo 2
        [5.40, 4.32, 4.20, 4.56, 4.92, 3.24, 4.32],  # Silo 3
        [4.56, 5.40, 3.72, 6.36, 5.16, 5.40, 3.84],  # Silo 4
        [5.52, 4.20, 3.96, 4.08, 3.00, 3.84, 3.96],  # Silo 5
        [5.16, 5.04, 6.48, 5.52, 5.64, 5.16, 3.96],  # Silo 6
    ],
    [  # Plant 2
        [4.44, 5.04, 4.56, 4.80, 5.16, 4.32, 3.36],  # Silo 1
        [5.16, 4.80, 4.68, 5.40, 3.96, 4.80, 5.04],  # Silo 2
        [6.24, 5.16, 5.04, 5.40, 5.76, 4.08, 5.16],  # Silo 3
        [5.28, 6.12, 4.44, 7.08, 5.88, 6.12, 4.56],  # Silo 4
        [6.60, 5.28, 5.04, 5.16, 4.08, 4.92, 5.04],  # Silo 5
        [4.68, 4.56, 6.00, 5.04, 5.16, 4.68, 3.48],  # Silo 6
    ],
], dtype=float)

# Silo parameters (j)
Q = np.array([80, 90, 110, 120, 100, 120], dtype=float)    # capacity q_j
C = np.array([220, 240, 260, 275, 240, 230], dtype=float)  # fixed cost f_j
G = np.array([0.15, 0.18, 0.20, 0.18, 0.15, 0.17])         # marginal cost g_j

# Farm parameters (r)
D  = np.array([36, 42, 34, 50, 27, 30, 43], dtype=float)   # demand d_r
SC = np.full(F, 7.0)                                       # shortage cost SC_r

# Plant parameters (i)
O  = np.array([120, 150], dtype=float)                     # supply o_i
IC = np.array([4.0, 3.0])                                  # inventory cost IC_i

assert A.shape == (P, S, F)
assert Q.shape == C.shape == G.shape == (S,)
assert D.shape == SC.shape == (F,)
assert O.shape == IC.shape == (P,)
print(f"supply={O.sum()}, demand={D.sum()}, silo capacity={Q.sum()}")

m = gp.Model("silo_location")

# VARS  (axis 0 = plant i, axis 1 = silo j, axis 2 = farm r)
s     = m.addMVar((P, S, F), lb=0, name="s")       # s_ijr
y     = m.addMVar(S, vtype=GRB.BINARY, name="y")   # y_j
s_pos = m.addMVar(P, lb=0, name="s_pos")           # s_i^+  (unshipped supply)
s_neg = m.addMVar(F, lb=0, name="s_neg")           # s_r^-  (unmet demand)

throughput = s.sum(axis=(0, 2))                    # sum_{i,r} s_ijr, shape (S,)

# def throughput(m, j):
#     return sum(m.s[i, j, r] for i in m.P for r in m.F)

# OBJECTIVE
transport  = (A * s).sum()
facilities = C @ y + G @ throughput
inventory  = IC @ s_pos
shortage   = SC @ s_neg 
m.setObjective(transport + facilities + inventory + shortage, GRB.MINIMIZE)

# CONSTRAINTS
m.addConstr(s.sum(axis=(1, 2)) + s_pos == O, name="supply")  # ∀ i
m.addConstr(s.sum(axis=(0, 1)) + s_neg == D, name="demand")  # ∀ r
m.addConstr(throughput <= Q * y,             name="open")    # ∀ j

m.Params.OutputFlag = 0
m.optimize()

if m.Status == GRB.OPTIMAL:
    print("\nOpen silos:", [j + 1 for j in range(S) if y.X[j] > 0.5])
    print("\nFlows (plant -> silo -> farm):")
    for i, j, r in zip(*np.nonzero(s.X > 1e-6)):
        print(f"  P{i+1} -> S{j+1} -> F{r+1}: {s.X[i, j, r]:.1f}")
    print("\nUnshipped supply:", {f"P{i+1}": round(float(v), 1) for i, v in enumerate(s_pos.X)})
    print("Shortage:        ", {f"F{r+1}": round(float(v), 1) for r, v in enumerate(s_neg.X)})
    print(f"\nTotal cost: {m.ObjVal:.2f}")
else:
    print("Solver status:", m.Status)