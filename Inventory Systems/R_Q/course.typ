#import "@local/tystats:0.1.0": norm, poisson, expon

#let r(v, digits: 2) = calc.round(v, digits: digits)

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

#line(length: 100%)

#table(
  columns: (1fr, 1fr),
  inset: 1em,
  [
    == Newsvendor

    - Single period, no reorders
    - $F(Q^*) = c_u / (c_u + c_o)$
  ],
  [
    == Order-up-to

    - Periodic review, protection period $L + 1$
    - $alpha = 0.99$
    - $F_(L+1)(S) = alpha$
    - $S = mu_(L+1) + z sigma_(L+1), quad z = Phi^(-1)(alpha)$
  ],
  table.cell(
    colspan: 2,
    [
      == $(R, Q)$

      - Continuous review, protection period $L$
      - Order size (EOQ): $Q = sqrt((2 D K) / h)$
      - Service-level reorder point: $F_L (R) = alpha, quad R = mu_L + z sigma_L$
      - Cost-based reorder point: $F_L (R) = 1 - (h Q) / (b D)$
    ]
  )
)


#[
  1. *Basic* (cycle service level). Find $Q$ (EOQ) and $R$ for a 95% cycle service level $alpha$. How much safety stock is that?

  #let D = 10000 // units / year
  #let K = 200 // $ / order
  #let H = 4 // $ / unit / year
  #let mu_L = 400 // days
  #let sigma_L = 60 // days

  #let a = 0.95 // %

  #let Q = calc.sqrt((2 * D * K) / H)

  #let z = norm.ppf(a)
  #let R = mu_L + z * sigma_L

  #let SS = sigma_L * z

  #r(Q)

  #r(R)

  #r(SS)
]

#[
  2. Daily data, so you *build the lead-time distribution* yourself. Daily demand $~ N(50, 12)$, independent across days, 360 days/yr, $L$ = 9 days, $K$ = €90, $h$ = €2.50. Find $Q$ and $R$ for $alpha = 99%$.

  #let days_per_year = 360
  #let mu_D = 50 // units / day
  #let sigma_D = 12 // units / day
  #let L = 9 // days
  #let K = 90 // $ / order
  #let H = 2.50 / days_per_year // $ / day
  #let alpha = 0.99 // %

  #let Q = calc.sqrt((2 * mu_D * K) / H)

  #let mu_L = mu_D * L
  #let sigma_L = sigma_D * calc.sqrt(L)

  #let z = norm.ppf(alpha)
  #let R = mu_L + z * sigma_L

  #r(Q)

  #r(R)
]

#[
  3. *Cost-based* R (backorder penalty). Use the shared data. Each backordered unit costs $b = €25$. With $Q$ from Ex. 1, find the optimal $R$ using $F(R) = 1 - (h Q) / (b D)$.

  #let D = 10000 // units / year
  #let K = 200 // $ / order
  #let H = 4 // $ / unit / year
  #let mu_L = 400 // days
  #let sigma_L = 60 // days
  
  #let b = 25 // $ / order

  #let Q = calc.sqrt((2 * D * K) / H)

  #let alpha = 1 - (H * Q) / (b * D)

  #let z = norm.ppf(alpha)

  #let R = mu_L + z * sigma_L

  #r(Q)

  #r(R)
]

#[
  4. *Fill-rate target* (Type 2 service). Use the shared data with $Q = 1,000$. Find $R$ so that 99% of demand is met from stock (fill rate $beta = 0.99$). Hint: expected shortage per cycle $= sigma_L dot L(z) = (1 - beta)Q$, where $L(z)$ is the standard normal loss function. Compare your answer with Ex. 1.

  #let D = 10000 // units / year
  #let K = 200 // $ / order
  #let H = 4 // $ / unit / year
  #let mu_L = 400 // days
  #let sigma_L = 60 // days

  #let Q = 1000
  #let beta = 0.99

  #let Lz = (1 - beta) * Q / sigma_L
  #let L(z) = norm.pdf(z) - z * (1 - norm.cdf(z))

  #let lo = -6
  #let hi = 6
  #for _ in range(60) {
    let mid = (lo + hi) / 2
    if L(mid) > Lz { lo = mid } else { hi = mid }
  }
  #let z = ((lo + hi) / 2)

  #let R = mu_L + z * sigma_L

  #r(R)

]

#[
  5. *Random lead time*. Same data as Ex. 2, but now the lead time is random: mean 9 days, sd 2 days. Find $R$ for $alpha = 95%$. Compare the safety stock with fixed L = 9 at the same $alpha$.

  #let days_per_year = 360
  #let mu_D = 50 // units / day
  #let sigma_D = 12 // units / day
  #let mu_L = 9 // days
  #let sigma_L = 2 // days
  #let K = 90 // $ / order
  #let H = 2.50 / days_per_year // $ / day
  #let alpha = 0.99 // %

  #let Q = calc.sqrt((2 * mu_D * K) / H)

  #let mu_DL = mu_D * mu_L
  #let sigma_DL = calc.sqrt(mu_L * calc.pow(sigma_D, 2) + calc.pow(mu_D, 2) * calc.pow(sigma_L, 2))

  #let z = norm.ppf(alpha)

  #let R = mu_DL + z * sigma_DL

  #r(Q)
  
  #r(R)
]

#[
  6. Reverse problem (evaluate a given policy). A firm uses R = 460 and Q = 1,000 with the shared data. Find (a) the cycle service level, (b) expected stockout cycles per year, (c) the fill rate, and (d) the annual ordering + holding cost.

  #let days_per_year = 360
  #let mu_D = 50 // units / day
  #let sigma_D = 12 // units / day
  #let mu_L = 9 // days
  #let sigma_L = 2 // days
  #let K = 90 // $ / order
  #let H = 2.50 / days_per_year // $ / day

  #let R = 460
  #let Q = 1000

  #let mu_DL = mu_D * mu_L
  #let sigma_DL = calc.sqrt(mu_L * calc.pow(sigma_D, 2) + calc.pow(mu_D, 2) * calc.pow(sigma_L, 2))

  #let z = (R - mu_DL) / sigma_DL

  #let CSL = norm.cdf(z)

  #r(CSL)
 
  #let loss = norm.pdf(z) - z * (1 - norm.cdf(z))
  #let n_stockouts = 1 - norm.cdf(z)
  #let e_stockout = n_stockouts * mu_D / Q * days_per_year

  #r(e_stockout)

  #let FR = 1 - sigma_DL * loss / Q // beta

  #r(FR)

  #let SS = R - mu_DL
  #let holding_cost = H * (Q / 2 + SS) * days_per_year
  #let ordering_cost = K * mu_D / Q * days_per_year

  #r(ordering_cost)
  #r(holding_cost)

]

#[
  7. Sensitivity. In Ex. 2, the supplier's lead time doubles to 18 days. What happens to $Q$, $R$ and safety stock?

  #let days_per_year = 360
  #let mu_D = 50 // units / day
  #let sigma_D = 12 // units / day
  #let L = 18 // days
  #let K = 90 // $ / order
  #let H = 2.50 / days_per_year // $ / day
  #let alpha = 0.99 // %

  #let Q = calc.sqrt((2 * mu_D * K) / H)


  #let mu_DL = mu_D * L
  #let sigma_DL = sigma_D * calc.sqrt(L)

  #let z = norm.ppf(alpha)

  #let R = mu_DL + z * sigma_DL

  #let SS = R - mu_DL

  #r(Q)

  #r(R)

  #r(SS)

  $Q = #r(Q)$ (unchanged, $L$ is not in EOQ)

  $R = #r(R) quad (#r((R - 533.75) / 533.75 * 100)%)$

  $"SS" = #r(SS) quad (#r((SS - 83.75) / 83.75 * 100)%)$

]

#[
  8. Slow mover (discrete demand). A spare part has Poisson lead-time demand with mean 3. Find the smallest integer R with $alpha >= 95%$.

  #let mu_D = 3
  #let alpha = 0.95

  #let R = poisson.ppf(alpha, mu_D)

  #r(R)
]

#[
  9. Conceptual check. With $R = 499$ and $Q = 1,000$, you have 300 units on hand, one order of 1,000 in transit, and no backorders. Do you place an order?

  #let R = 499
  #let Q = 1000
  #let OH = 300
  #let pipeline = 1000
  #let BO = 0

  #let IP = OH + pipeline - BO
  
  #r(IP)

  #if IP <= R [Order Q (#Q)] else [Do not order Q (#Q)]

]

#[
  1. Full iteration. D = 2,400 units/yr, K = €100, h = €6/unit/yr, p = €30/unit short, lead-time demand ~ N(200, 40). Run the algorithm until Q and R converge (to the nearest unit). Report Q, R, the safety stock and the implied cycle service level F(R).

  #let D = 2400
  #let K = 100
  #let H = 6
  #let p = 30
  #let mu-L = 200
  #let sigma-L = 40

  #let Q = calc.sqrt((2 * D * K) / H)
  #let R = none
  #let z = none
  #let n-R = none
  #let tol = 0.0001
  #let iter-max = 50

  #for i in range(iter-max) {
    let p-stockout = (Q * H) / (p * D)
    z = norm.sf(p-stockout)          // upper tail!
    R = mu-L + z * sigma-L
    let loss = norm.pdf(z) - z * norm.sf(z)
    n-R = sigma-L * loss
    let Q-new = calc.sqrt((2 * D * (K + p * n-R)) / H)
    let done = calc.abs(Q-new - Q) < tol
    Q = Q-new
    if done { break }
  }

  #let SS = R - mu-L
  #let CSL = norm.cdf(z)

  - $Q approx #calc.round(Q, digits: 1)$
  - $R approx #calc.round(R, digits: 1)$
  - $n(R) approx #calc.round(n-R, digits: 3)$
  - $"SS" approx #calc.round(SS, digits: 1)$
  - $"CSL" approx #calc.round(CSL * 100, digits: 1) %$

]

#[
  2. Low shortage cost. Use the shared data (D = 10,000, K = €200, h = €4, N(400, 60)), but now p = €2.
  (a) Run the algorithm. How much do Q and R change from iteration 0 to the converged answer?
  (b) Total annual cost is TC(Q, R) = K·D/Q + h·(Q/2 + R − μ_L) + p·n(R)·D/Q. Compare TC at iteration 0 (the shortcut) with TC at the converged answer. What does this tell you about when the iteration is worth the effort?

]

#[
  3. Edge case. Use the shared data with p = €0.30. Try step 2 of the algorithm. What goes wrong, and what does it mean in business terms?

]

= (s, S)

- $mu_D$: mean demand
- $sigma_D$: std. dev. dmeand
- $L$: lead time (in periods)
- $R$: review interval
- $K$: fixed ordering cost
- $H$: holding cost per unit per period
- Service target:
  - CSL: 95% $arrow$ $z = 1.645$
  - Shortage cost ($p$): critical ratio $p / (p + h) quad arrow quad z$

#let days_per_month = 30

#let mu_D = 100              // units / month
#let sigma_D = 30            // units / month
#let L = 1 / days_per_month  // months
#let R = 1                   // month
#let K = 200                 // € / order
#let h = 2                   // € / unit / month

// Service target: pick one
#let mode = "csl"            // "csl" or "cost"
#let CSL = 0.95
#let p = 45                  // € / unit short / month

#let target = if mode == "csl" { CSL } else { p / (p + h) }
#let z = norm.ppf(target)

// Order quantity
#let Q = calc.sqrt(2 * mu_D * K / h)

// Protection period R + L
#let mu_RL = mu_D * (R + L)
#let sigma_RL = sigma_D * calc.sqrt(R + L)

// Policy
#let s = calc.ceil(mu_RL + z * sigma_RL)
#let S = calc.ceil(s + Q)

// Review
#let OH = 400  // on hand
#let OO = 0    // on order
#let BO = 0    // backorders
#let IP = OH + OO - BO

$z = #calc.round(z, digits: 3)$, $Q = #calc.round(Q, digits: 1)$

$(s, S) = (#s, #S)$

#if IP < s [Order #(S - IP) units] else [Do nothing (IP = #IP ≥ s)]

== Simulation

#[
  #let mode = "csl"            // "csl" or "cost"

  #let I0 = 0
  #let demands = ()

  #let mu_D = 20              // units / month
  #let sigma_D = 10            // units / month
  #let L = 1 / days_per_month  // months
  #let R = 1                   // month
  #let K = 200                 // € / order
  #let h = 2                   // € / unit / month

  // Service target: pick one
  #let CSL = 0.95
  #let p = 90                  // € / unit short / month

  #let target = if mode == "csl" { CSL } else { p / (p + h) }
  #let z = norm.ppf(target)

  // Policy
  #let Q = calc.sqrt(2 * mu_D * K / h)
  #let mu_RL = mu_D * (R + L)
  #let sigma_RL = sigma_D * calc.sqrt(R + L)
  #let s = calc.ceil(mu_RL + z * sigma_RL)
  #let S = calc.ceil(s + Q)

  // Lead time in whole review periods.
  // 0 = arrives before this month's demand (your L = 1/30 case)
  #let Lp = calc.floor(L / R)

  #let NI = I0          // net inventory = OH − BO
  #let pipeline = ()    // outstanding orders: (arrival month, qty)
  #let rows = ()
  #let cost = 0
  #let n_orders = 0

  #for (t, d) in demands.enumerate() {
    let m = t + 1

    // 1. Receive orders due this month
    NI += pipeline.filter(o => o.at(0) == m).map(o => o.at(1)).sum(default: 0)
    pipeline = pipeline.filter(o => o.at(0) != m)

    // 2. Review
    let OH = calc.max(NI, 0)
    let BO = calc.max(-NI, 0)
    let OO = pipeline.map(o => o.at(1)).sum(default: 0)
    let IP = NI + OO
    let q = if IP < s { S - IP } else { 0 }
    if q > 0 {
      n_orders += 1
      cost += K
      if Lp == 0 { NI += q } else { pipeline.push((m + Lp, q)) }
    }

    // 3. Demand
    NI -= d
    cost += h * calc.max(NI, 0) + p * calc.max(-NI, 0)
    rows.push((m, OH, OO, BO, IP, q, IP + q, d, NI))
  }

  // Next decision (receiving doesn't change IP, it just moves OO → OH)
  #let next_IP = NI + pipeline.map(o => o.at(1)).sum(default: 0)
  #let next_q = if next_IP < s { S - next_IP } else { 0 }

  #table(
    columns: 9,
    [*Month*], [*OH*], [*OO*], [*BO*], [*IP*], [*Order*], [*IP after*], [*Demand*], [*End NI*],
    ..rows.flatten().map(x => [#x]),
    [*#(demands.len() + 1)*], [], [], [], [*#next_IP*], [*#next_q*], [*#(next_IP + next_q)*], [?], [?],
  )

  Orders: #n_orders · Cost: €#calc.round(cost, digits: 2)
]

== Simulation

#[
  // ── Inputs ──────────────────────────────────────────
  #let mu_D = 20     // units / period
  #let sigma_D = 10  // units / period
  #let K = 6.3       // $ / order
  #let h = 0.07      // $ / unit / period
  #let b = 20           // $ per stockout OCCASION

  #let I0 = 30
  // #let demands = (21, 31, 13, 22, 10, 18, 33, 27, 11, 12, 11)     // append each period's realized demand
  #let demands = ()     // append each period's realized demand

  // ── Critical ratio ──────────────────────────────────
  // Cu, Co are per UNIT. The game's penalty is per OCCASION,
  // so how you set Cu is your modelling decision.
  #let Cu = b           // ← decide
  #let Co = h
  #let CR = Cu / (Cu + Co)
  #let z = norm.ppf(CR)

  // ── Policy (slide 8) ────────────────────────────────
  // s: newsvendor on one period of demand
  #let s = calc.ceil(mu_D + z * sigma_D)

  // S: order-up-to over the periods covered by EOQ
  #let EOQ = calc.sqrt(2 * mu_D * K / h)
  #let n = EOQ / mu_D   // periods of coverage
  #let S = calc.ceil(n * mu_D + z * sigma_D * calc.sqrt(n))

  CR = #calc.round(CR, digits: 3) · z = #calc.round(z, digits: 3) ·
  EOQ = #calc.round(EOQ, digits: 1) · n = #calc.round(n, digits: 2) ·
  *(s, S) = (#s, #S)*
  #if S <= s [ #text(red)[S ≤ s: EOQ covers less than one period, so use OUT instead] ]

  // ── Simulation (no lead time: orders arrive before demand) ──
  #let I = I0           // net inventory (negative = backorders)
  #let rows = ()
  #let cost = 0
  #let n_orders = 0
  #let n_stockouts = 0

  #for (t, d) in demands.enumerate() {
    let q = if t == 0 { 0 } else if I < s { S - I } else { 0 }
    let after = I + q
    let inv_end = after - d
    if q > 0 { n_orders += 1; cost += K }
    if inv_end < 0 { n_stockouts += 1; cost += b }
    cost += h * calc.max(inv_end, 0)
    rows.push((t + 1, I, q, after, d, inv_end))
    I = inv_end
  }

  #let next_q = if I < s { S - I } else { 0 }

  #table(
    columns: 6,
    [*Period*], [*IP at review*], [*Order*], [*After order*], [*Demand*], [*End inv*],
    ..rows.flatten().map(x => [#x]),
    [*#(demands.len() + 1)*], [*#I*], [*#next_q*], [*#(I + next_q)*], [?], [?],
  )

  Orders: #n_orders · Stockouts: #n_stockouts · Est. cost: \$#calc.round(cost, digits: 2)

  Total cost: \$78.68
]

1) b

2) a

3) c

4) b

= Risk Pooling

= Demand Forecasting





