= (R, Q)

- Continuous review
- Demand: stochastic, stationary
  - $D$: mean
  - $sigma$: standard deviation
- Lead time: constant
- Backorders (unmet demand)
- Cost params:
  - $S$: setup cost
  - $h$: holding cost
  - $b$: backorder

Definitions:
- On-order (pipeline)
- On-hand
- Backorders
- Inventory level
- Inventory position

Decision variables:
- $Q$: order quantity
- $R$: reorder point

Policy:
When inventory position hits $R$, order $Q$

Objective:
Choose $R$ and $Q$ to minimize TC

Difference with OUT:

#table(
  columns: 3,
  inset: 1em,
  [], [$(R, Q)$], [OUT], 
  [$T$], [$Q / D$], [Fixed], 
  [$Q$], [Fixed], [$E[D_t]$], 
  [$L$], [$L$], [$L + T$], 
  [$n$], [$Q / D$], [$$], 

)

Where:
- $T$: period

$
  Q = "EOQ" \
  R = mu_L + sigma_L z(alpha) \
  P(D_L lt.eq R) = "CSL" \
$

With:

$
  alpha = b / (b + h)
$

== Derivation

$
  C(Q, R) = S D / Q + H (Q / 2 + R - mu_L) + b D / Q dot n(R)
$

- Ordering 
- Holding
- Backorder

$
  n(R) = E["BO"] = E[(D_L - R)^+]  = integral_R^infinity (D_L - R) dot f(D_L) dif D_L = n(R)
$

$
  (partial C(Q, R)) / (partial Q) &= (- S D) / Q^2 + h / 2 - b n(R) dot D / Q^2 = 0 quad &&arrow.double quad Q^* = sqrt((2 D [S + 2 b n(R)] D) / h)
  \
  (partial C(Q, R)) / (partial R) &= h + (b D) / Q dot (-1) P(D_L gt R) = 0 quad &&arrow.double quad R^* = (b D - h Q) / (b D)
$

$
  P(D_L gt R) = 1 - P(D_L lt.eq R) = 1 - F_(D_L) (R)
$

$
  h - (b D) / Q + (b D) / Q F(R) quad arrow.double quad F(R) = ((b D) / Q - h) / ((b D) / Q) quad arrow.double quad F(R) = 1 - (h Q) / (b D) = (b D - h Q) / (b D)
$

Expected setup cost

$
  (S D) / Q
$

$dots$



$
  z = (R - mu_L) / sigma_L
$

- E[Back]

$
  sigma_L L(z)
$

- E[SS]

$
  R - mu_L + E["Short"]
$

- FR

$
  1 - E["short"] / Q
$

- E[Short]

== Stochastic Lead Time

$
  mu_L = D dot L
$

Law of total variance

$
  sigma_L = sqrt(L dot sigma^2 + D^2 dot s_L^2)
$

