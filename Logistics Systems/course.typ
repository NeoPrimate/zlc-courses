#set text(
  font: "Helvetica", 
  size: 8pt
)

#show math.overbrace: it => {
  if it.body.func() == math.equation { return it }
  let strut = box(height: 2.4em, width: 0pt)
  math.overbrace($strut #it.body$, it.annotation)
}

#let mc(x) = text(fill: red, x)

= Logistics Systems

Warehouse as buffers:
- Economies of scale
  - Aggregation
- Fixed costs (stop start factory) v. Holding cost (use warehouse as buffer for holding)

Defining a problem:
- Sets
- Indices 

= Defining the problem

*Sets*

- $V_1$: set of origins (supply nodes)
- $V_2$: set of potential facilities (intermediate nodes)
- $V_3$: set of destinations (demand nodes)

*Indices*

- $i in V_1$: origin
- $j in V_2$: potential facility
- $r in V_3$: destination

*Parameters*

- $a_(i j r)$: unit transport cost from $i$ to $r$ through $j$
- $f_j$: fixed cost of opening facility $j$
- $g_j$: marginal (per-unit) handling cost at facility $j$
- $q_j$: capacity of facility $j$
- $o_i$: supply available at origin $i$
- $d_r$: demand at destination $r$
- $"IC"_i$: unit cost of supply left unused at origin $i$ (inventory)
- $"SC"_r$: unit cost of demand left unmet at destination $r$ (shortage)

*Decision variables*

- $y_j = cases(
    1 "if facility" j "is activated",
    0 "otherwise"
  )$
- $s_(i j r) >= 0$: quantity flowing from $i$ to $r$ through $j$
- $s_i^+ >= 0$: supply left unused at origin $i$
- $s_r^- >= 0$: demand left unmet at destination $r$

*Model*

$
  min quad
  & overbrace(sum_(i in V_1) sum_(j in V_2) sum_(r in V_3) a_(i j r) s_(i j r), "transport")
  + overbrace(sum_(j in V_2) (f_j y_j + g_j sum_(i in V_1) sum_(r in V_3) s_(i j r)), "facilities")
  + overbrace(sum_(i in V_1) "IC"_i s_i^+, "inventory")
  + overbrace(sum_(r in V_3) "SC"_r s_r^-, "shortage") \

  "s.t." quad
  & sum_(j in V_2) sum_(r in V_3) s_(i j r) + mc(s_i^+) = o_i, quad quad && forall i in V_1 \
  & sum_(i in V_1) sum_(j in V_2) s_(i j r) + mc(s_r^-) = d_r, quad quad && forall r in V_3 \
  & sum_(i in V_1) sum_(r in V_3) s_(i j r) <= q_j y_j, quad quad && forall j in V_2 \
  & y_j in {0, 1}, quad quad && forall j in V_2 \
  & s_(i j r), s_i^+, s_r^- >= 0, quad quad && forall i in V_1, j in V_2, r in V_3
$

= Defining the problem

*Sets*

- $V_1$: Number of potential silos

- $V_2$: Number of farms to be served

- $V_3$: Time periods within the planning horizon

*Indices*

- $j in V_1$

- $r in V_2$

- $t, w in V_3$

*Parameters*

- $A_(j r t)$: (variable) *transportation cost* (per quintal) from silo $j$ to farm $r$, in period $t$

- $"CLC"_(j r)$: (fixed) *cost low capacity* for silo $j$ in period $t$

- $"CHC"_(j r)$: (fixed) *cost high capacity* for silo $j$ in period $t$

- $Q^L_(j t)$: capacity (*quintals*, *low* level) of silo $j$ in period $t$

- $Q^H_(j t)$: capacity (*quintals*, *high* level) of silo $j$ in period $t$

- $D_(r t)$: *demand* of farm $r$ within period $t$

- $"FSP"_t$: forage *selling price* in period $t$

- $"CCF"_(j t)$: *closing cost* of silo $j$ in period $t$

- $"SV"_(j t)$: *salvage value* of silo $j$ in period $t$

- $G_(j t)$: average *marginal cost* of processing one quintal in the silo $j$, in period $t$

*Decision Variables*

- $"IA"_(j t) = cases(
  1 "if silo" j "is initially activated in period" t,
  0 "otherwise"
)$ 

- $"FC"_(j r) = cases(
  1 "if silo" j "is closes in period" t,
  0 "otherwise"
)$ 

- $Y_(j t) = cases(
  1 "if silo" j "is active in period" t,
  0 "otherwise"
)$

- $"LC"_(j t) = cases(
  1 "if silo" j "operates at low capacity in period" t,
  0 "otherwise"
)$ 

- $"HC"_(j t) = cases(
  1 "if silo" j "operates at high capacity in period" t,
  0 "otherwise"
)$ 

- $S_(j r t)$: material flow (quintals) from silo $j$ to farm $r$ in period $t$

*Model*

$
  max quad 
  & \
  "s.t." quad
  & \
  & \
  & \
$