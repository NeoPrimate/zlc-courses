#set text(font: "Helvetica", size: 8pt)

#show table: it => align(center, it)

#set math.mat(delim: "[")
#set math.vec(delim: "[")

#let mc(x) = text(fill: red, x)

- Sensitivity analysis
- 100% rule
- Diseconomies of scale

= P1

- $P = {1, 2, 3}$ // plants
- $S = {L, M, S}$ // product size

- $pi_s = (420, 360, 300)$ // profit ($ / unit)

- $k_p = (750, 900, 450)$ // capacity (units / day)
- $s_s = (20, 15, 12)$ // product size (sq ft)

- $h_p = (13000, 12000, 5000)$ // storage (sq ft)

- $d_s = (900, 1200, 750)$ // product demand (unit / day)

- $x_(s p)$: how much of product of size $s$ is produced in plant $p$
- $y$: % of excess capacity used to produce 
- $z_s$: unmet demand for product $s$

$
  max quad 
  &sum_(p in P) sum_(s in S) pi_(s) x_(s p) \
  "s.t." quad
  &sum_(s in S) x_(s p) <= k_p quad &&forall p in P \
  &sum_(s in S) s_s x_(s p) <= h_p quad &&forall p in P \
  // &sum_(p in P) x_(s p) mc(+ z_s =) d_s quad &&forall s in S \
  &sum_(p in P) x_(s p) mc(<=) d_s quad &&forall s in S \
  &mc((sum_(s in S) x_(s p)) / k_p = y quad &&forall p in P) \
  & \
  &x_(s p) gt.eq 0 quad &&forall s in S, p in P \
  &y gt.eq 0 \
  &z_(s) gt.eq 0 quad &&forall s in S \
$

- Demand direction: “would sell up to” means $<=$, and “must deliver” means $>=$
- Slack variables: a non-negative slack that doesn't appear in the objective is just an inequality written another way
- “Same proportion” rules: a shared variable turns them into linear equalities

= P2

- $P = {1, 2, 3, 4, 5}$
- $W = {1, 2, 3}$
- $C = {1, 2, 3, 4}$

- $k_p = [300, 200, 300, 200, 400]$

- $c^(P W)_(p w) = mat(
  800, 1000, 1200;
  700, 500, 700;
  800, 600, 500;
  500, 600, 700;
  700, 600, 500;
)$

- $c^(W C)_(w c) = mat(
  40, 80, 90, 50;
  70, 40, 60, 80;
  80, 30, 50, 60;
)$

- $d_c = [200, 300, 150, 250]$

- $f^P_p = [35000, 45000, 40000, 42000, 40000]$
- $f^W_w = [30000, 40000, 30000]$

- $n = 4$: number of plants open

- $M = sum_(c in C) d_c$

- $x^(P W)_(p w)$: number of tons sent from plant $p$ to warehouse $w$
- $x^(W C)_(w c)$: number of tons sent from warehouse $w$ to customer $c$
- $o^P_p$: 1 if plant $p$ is open, 0 otherwise
- $o^W_w$: 1 if WH $w$ is open, 0 otherwise

$
  min quad 
  &sum_(p in P) sum_(w in W) c^(P W)_(p w) x^(P W)_(p w) + \
  &sum_(w in W) sum_(c in C) c^(W C)_(w c) x^(W C)_(w c) + \
  &sum_(p in P) f^P_p o^P_p + \
  &sum_(w in W) f^W_w o^W_w \
  "s.t."
  & \
  &sum_(w in W) x^(P W)_(p w) <= k_p mc(o^P_p) quad &&forall p in P \
  &mc(sum_(c in C) x^(W C)_(w c) <= M o^W_w quad &&forall w in W) \
  &sum_(w in W) x^(W C)_(w c) >= d_c quad &&forall c in C \
  &sum_(p in P) o^P_p <= n \
  &mc(sum_(p in P) x^(P W)_(p w) = sum_(c in C) x^(W C)_(w c) quad &&forall w in W) \
  &x^(P W)_(p w) >= 0 quad &&forall p in P, w in W \
  &x^(W C)_(w c) >= 0 quad &&forall w in W, c in C \
  &o^P_p in {0, 1} quad &&forall p in P \
  &o^W_w in {0, 1} quad &&forall w in W \
$

- Linking constraints: “can't use X unless it's open” means flow $<=$ capacity $times$ binary. When there's no real capacity, use a big-$M$ that can never be exceeded.
- Flow conservation: at a transfer point like a warehouse, what comes in equals what goes out.



#pagebreak()

= Vestel

*Sets*

- $N = {1, 2, 3, 4}$: nodes (node 1 is the depot)
- $A = {(i, j) in N times N : i != j}$: arcs
- $P = {1, 2}$: products
- $T = {"LO", "HI"}$: truck types

*Parameters*

- $m_(i j)$: distance from node $i$ to node $j$

$
  M = mat(
    0, 5, 3, 3;
    5, 0, 3, 7;
    3, 3, 0, 5;
    3, 7, 5, 0;
  )
$

- $q_t$: capacity of a truck of type $t$ 

$
  Q = vec(10, 18)
$

- $c_t$: cost per unit distance of a truck of type $t$

$
  C = vec(6, 10)
$

- $d_(n p)$: demand of node $n$ for product $p$

$
  D = mat(
    0, 0;
    2, 8;
    4, 4;
    8, 2;
  )
$

*Decision variables*

- $x_(i j p) >= 0$: amount of product $p$ shipped on arc $(i, j)$
- $y_(i j t) in bb(Z)_(>= 0)$: number of trucks of type $t$ used on arc $(i, j)$

*Model*

$
  min quad & sum_((i, j) in A) sum_(t in T) c_t m_(i j) y_(i j t) \
  "s.t." quad
  & sum_(i : (i, j) in A) x_(i j p) - sum_(k : (j, k) in A) x_(j k p) = d_(j p)
    && quad forall j in N without {1}, p in P \
  & sum_(p in P) x_(i j p) <= sum_(t in T) q_t y_(i j t)
    && quad forall (i, j) in A \
  & x_(i j p) >= 0
    && quad forall (i, j) in A, p in P \
  & y_(i j t) in bb(Z)_(>= 0)
    && quad forall (i, j) in A, t in T
$


= Company Scalers

*Decision Variable*

- $$: number of products
- $$: capacities
- $$: markets

// - $C = {S, P}$
// - $P = {A, B, G}$

// - $pi(p) = [10, 8, 6]$: profit for product $p$
// - $f = 50$: fixed fee for entering product to market 
// - $k^0 = 500$: current capacity

// - increments = 100
// - $"budget" = 1000$
// - each product requires one unit in capacity


// // - no more than 250 in entering fees
// // - send out at least 500

// // - Demand alpha spain <= 200
// // - total alpha produced equally dist spain & portugal
// // - at least 50 units of each product to portugal

- $d_i$: quantity of "\$100 investment done" that yield a marginal increased capacity $i$, $i in I = {50, 30, 20}$
- $x_(p c)$: quantity of products $p$ sent to country $c$
- $y_(p c)$: 1 if product $p$ is introduced to country $c$, 0 otherwise

- $p in P = {alpha, beta, gamma}$
- $c in C = {S, P}$

$
  max quad
  &sum_(p in P) sum_(c in C) pi_(p) x_(p c) mc(- 50 sum_(p in P) sum_(c in C) y_(p c) - 100 sum_(i) d_i) \
  "s.t." quad
  & \
  & \
  &x_(alpha "spain") = x_(alpha "portugal") \
  & \
  &x_(alpha "spain") <= 200 \
  & \
  &x_(alpha "portugal") >= 50 \
  &x_(beta "portugal") >= 50 \
  &x_(gamma "portugal") >= 50 \
  & \
  &sum_(p in P) sum_(c in C) x_(p c) >= 500 \
  & \
  &y_(p c) f +  <= 1000 \
  & \
  &y_(p c) f <= 250 \
  & \
  &k <=  \

  x_(p c) <= M y_(p c)
$

- $w_i$ = 1 if I choose capacity level $i$, 0 otherwise
- $"co"_i$: cost of investment

$
  sum_(p in P) sum_(c in C) x_(p c) <= sum_(i in I) "cap"_i w_i
$

Obj (add term):

$
  sum_(i in I) k_i w_i  
$

