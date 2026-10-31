#import "@local/tystats:0.1.0": norm, poisson, expon

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

*Policy*:
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

#line(length: 100%)

- $L$: lead time
- $D$: average demand / unit time
- $sigma$: standard deviation of demand / unit time
- $mu_L$: mean demand during lead time
- $sigma_L$: demand standard deviation during lead time
- $"CLS"$: cycle service level
- $"SS"$: safety inventory
- $R$: reorder point
- $S$: setup cost per order
- $h$: holding cost per unit / unit time
- $b$: backorder cost per unit backordered

*Stockout Probability*

$
  P("StockOut") = P(D_L > R) = integral_R^infinity f(D_L) dif D_L = 1 - F(R)
$

At $R^*$:

$
  P("StockOut") = 1 - F(R) = (h Q) / (b D)
$

*InStock Probability*

$
  P("InStock") = P(D_L lt.eq R) = 1 - P("StockOut")
$

*Safety Stock*

$
  "SS" = R - mu_L + E["BackOrder"]
$

*Backorders*

$
  E["BackOrder"] 
  &= E[(D_L - R)^+] = integral_R^infinity (D_L - R) f(D_L) dif D_L \
  &= n(R) \
$

$
  n(R) = sigma_L L(z) \
  z = (R - mu_L) / sigma_L \
  L(z) = phi(z) - z (1 - Phi(z)) \
$

*Fill Rate*

$
  "FR" = 1 - E["Short"] / Q
$


== Derivation

$
  C(Q, R) = underbrace(S D / Q, "setup") + underbrace(h (Q / 2 + R - mu_L), "holding") + underbrace(b D / Q n(R), "backorder") +
  underbrace(c D, "purchase")
$

$
  (partial C(Q, R)) / (partial Q) &= (- S D) / Q^2 + h / 2 - b n(R) dot D / Q^2 = 0 quad &&arrow.double quad Q^* = sqrt((2 D [S + 2 b n(R)] D) / h)
  \
  (partial C(Q, R)) / (partial R) &= h + (b D) / Q dot (-1) P(D_L gt R) = 0 quad &&arrow.double quad F(R^*) = (b D - h Q) / (b D)
$

== Steps

+ Compute EOQ

  $
    Q = sqrt((2 D S) / H)
  $
+ Substitute $Q$ into eq. (2) to compute $R$

  $
    F(R) = (b D - h Q) / (b D)
  $

+ Use $R$ to compute $n(R)$

  $
    n(R) = integral_R^infinity (D_L - R) f(D_L) dif D_L
  $

+ Solve for $Q$ in eq. (1)

  $
    Q = sqrt((2 D (S + b dot n(R))) / h)
  $

+ Repeat from step 2 until convergence

#[
  #let D = 12000 // year
  #let s = 1000 // year
  #let L = 1 // month

  #let S = 70
  #let H = 0.5 // unit / year
  #let b = 10

  #let months_in_year = 12
  #let D_L = D / months_in_year * L
  #let s_L = s / calc.sqrt(months_in_year) * calc.sqrt(L)

  #let max-iter = 20
  #let tol = 0.05

  #let Q = calc.sqrt(2 * D * S / H) // start from EOQ
  #let rows = ()
  #for i in range(max-iter) {
    let F_R = (b * D - H * Q) / (b * D)
    let z = norm.ppf(F_R)
    let R = D_L + z * s_L
    let loss = norm.pdf(z) - z * (1 - norm.cdf(z))
    let n_R = s_L * loss
    let Q2 = calc.sqrt(2 * D * (S + b * n_R) / H)
    rows.push((i + 1, Q, R, z, n_R, Q2))
    if calc.abs(Q2 - Q) < tol { break }
    Q = Q2
  }

  #let fmt(x, d) = str(calc.round(x, digits: d))

  #table(
    columns: 6,
    [*Iter*], [*Q*], [*R*], [*z*], [*n(R)*], [*Q new*],
    ..rows.map(((i, Q, R, z, n, Q2)) => (
      str(i), fmt(Q, 1), fmt(R, 1), fmt(z, 4), fmt(n, 4), fmt(Q2, 1),
    )).flatten()
  )

  #let last = rows.last()
  *Result:* $Q^* = #fmt(last.at(5), 1)$, $R^* = #fmt(last.at(2), 1)$
]

