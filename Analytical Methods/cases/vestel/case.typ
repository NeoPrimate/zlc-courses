= Vesel

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

= Bosch



