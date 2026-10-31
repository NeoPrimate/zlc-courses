#import "@preview/lilaq:0.6.0" as lq
#import "@local/tystats:0.1.0": norm, uniform

#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)

#let result(content) = box(stroke: blue, fill: blue.transparentize(75%), inset: 0.5em, radius: 0.25em)[#content]

#let r(d, digits: 3) = calc.round(d, digits: digits)

#h(1fr) Vladimir Borel

= Problem 1

#let D = 200
#let s = 120
#let L = 2 // weeks

#let R = 600
#let Q = 1000

#let D_L = D * L
#let s_L = s * calc.sqrt(L)

#let n(R) = {
  let z = (R - D_L) / s_L
  let loss = norm.pdf(z) - z * (1 - norm.cdf(z))
  s_L * loss
}

#let z = (R - D_L) / s_L

*(a)*

#let e_short = n(R)

#let SS = R - D_L + e_short

$
  z &= (R - D_L) / sigma_L
$

$
  E["short"] 
  &= n(R) \ 
  &= sigma_L L(z) \
$
$
  "SS" 
  &= R - D_L + E["short"] \
  &= #result[#r(SS)] 
$

*(b)*

#let p_instock = norm.cdf(z)

$
  P("instock") 
  &= Phi(z) \
  &= #result[#r(p_instock)]
$

*(c)*

#let FR = 1 - e_short / Q

$
  "FR" 
  &= 1 - E["short"] / Q \
  &= #result[#r(FR)]
$

*(d)*

#let Rs = (600, 500, 400, 300, 200, 100)

#let rows = ()
#for R in Rs {

  let z = (R - D_L) / s_L
  let p_instock = norm.cdf(z)

  let e_short = n(R)
  let FR = 1 - e_short / Q
  rows.push((R, p_instock, FR))
}

#table(
  columns: 3,
  inset: 1em,
  [*R*], [*$P("InStock")$ (CSL)*], [*FR*],
  ..rows.map(
    ((R, p_instock, FR)) => ([#r(R)], [#r(p_instock)], [#r(FR)])
  ).flatten()
)

- CSL and FR decrease as R decreases
- CSL falls faster
- CSL changes faster with R because it tells us whether a stockout happens at all
- FR tells us how many units are short (compared with Q), grows more slowly

*(e)*

- $"CSL" = P(D_L lt.eq R)$, the probability that there is no stockout in a cycle 
- A cycle that is short by a single unit counts as a complete failure
- $"FR" = 1 - E[(D_L - R)^+] / Q$, is the share of demand filled from stock
- A stockout can still fill almost all of its demand and only the units short at the end of the cycle count as lost

$"FR" > "CSL"$:

$
  E[(D_L - R)⁺] = P(D_L > R) · E[D_L - R | D_L > R]
$

Then:

- $1 - "CSL" = P(D_L > R)$
- $1 - "FR" = P(D_L > R) · E[D_L - R | D_L > R] / Q$

So $"FR" > "CSL"$ when: 

$
  E[D_L - R | D_L > R] < Q
$

- FR is greater than CSL whenever the average shortage in a stockout cycle is smaller than the order quantity (about one cycle's demand)
- Generally a cycle runs short by a small number at its end

*(f)*

#table(
  columns: 4,
  inset: 1em,
  [*Cycle*], [*Demand*], [*Filled*], [*Stockout?*],
  [1], [10], [10], [no], 
  [2], [10], [10], [no], 
  [3], [10], [10], [no], 
  [4], [100], [10], [yes], 
)

$
  "CSL" = 3 / 4 = #(3 / 4) \
  "FR" = 40 / 130 = #r(40 / 130)
$

Infrequent but large stockouts lead to $"CSL" > "FR"$

*(g)*

#let CSL = 0.95
#let z = norm.ppf(CSL)

#let R = D_L + z * s_L

$
  Phi^(-1)("CSL") = #r(z) \
$

$
  R
  & = D_L + z (sigma_L) \
  & = #result[#r(R)] \
  
$

*(h)*

#let e_short = n(R)

#let SS = R - D_L + e_short

$
  E["short"] 
  &= n(R) \
  &= #r(e_short) \
$

$
  "SS" 
  &= R - D_L + E["short"] \
  &= #result[#r(SS)]
$

*(i)*

#let L_mean = 2
#let L_sd = 1.1

#let mu_L = D * L
#let s_L = calc.sqrt(L * calc.pow(s, 2) + calc.pow(D, 2) * calc.pow(L_sd, 2))

#let SS = norm.ppf(CSL) * s_L

$
  L_mu 
  &= D L \ 
  &= #L_mean \
  L_sigma 
  &= sqrt(L sigma^2 + D^2 L_sigma^2) \
  &= #L_sd \
$

$
  "SS" 
  &= Phi^(-1)("CSL") sigma_L \
  &= #result[#r(SS)] \
$

*(j)*

#let T = 1
#let L = 2
#let D_TL = D * (T + L)
#let s_TL = s * calc.sqrt(T + L)
#let S = D_TL + norm.ppf(CSL) * s_TL

#let z = norm.ppf(CSL)

#let S = D_TL + z * s_TL

$
  L = #L \
  D_(L + 1) = D (L + 1) = #D_TL \
  sigma_(L + 1) = sigma sqrt(L + 1) = #r(s_TL) \
  z = Phi^(-1)("CSL") = #r(z) \
$

$
  S = D_(L + 1) + z (sigma_(L + 1)) = #result[#r(S)]
$

*(k)*

#let e_short = 0

#let SS = S - D_TL + e_short

$
  "SS" = S - D_(L + 1) = #result[#r(SS)]
$

*(l)*

- Periodic review covers demand over $T + L = 3$ weeks
- Continuous review cover $L = 2$ weeks

#[
  = Problem 2

  #let D = 178            // gal/day
  #let s = 45             // gal/day
  #let S = 58             // $/order
  #let L = 0              // days
  #let CSL = 0.999

  #let days_per_week = 5
  #let weeks_per_year = 52
  #let days_per_year = days_per_week * weeks_per_year   // 260

  #let H = 0.80 * weeks_per_year   // $/gal/year = 41.6

  #let policy(T) = {
    let D_TL = D * (T + L)
    let s_TL = s * calc.sqrt(T + L)
    let z = norm.ppf(CSL)
    let OUT = D_TL + z * s_TL
    let SS = OUT - D_TL                    // E[back] ≈ 0
    let c_ord = S * days_per_year / T
    let c_hold = H * (D * T / 2 + SS)
    (z: z, s_TL: s_TL, OUT: OUT, SS: SS,
    c_ord: c_ord, c_hold: c_hold, total: c_ord + c_hold)
  }

  #let p1 = policy(5)    // weekly
  #let p2 = policy(10)   // every two weeks

  *(a)*

  $
    z &= Phi^(-1)(#CSL) = #r(p1.z) \
    sigma_(T+L) &= sigma sqrt(T + L) = #r(p1.s_TL) \
    "SS" &= z sigma_(T+L) = #result[#r(p1.SS)]
  $

  *(b)*

  $
    C_"order" &= S dot 52 = #result[#r(p1.c_ord)] \
    C_"hold" &= H (D T / 2 + "SS") = #result[#r(p1.c_hold)]
  $

  *(c)*

  #table(
    columns: 3,
    inset: 1em,
    [], [*Weekly*], [*Every 2 weeks*],
    [SS], [#r(p1.SS)], [#r(p2.SS)],
    [OUT], [#r(p1.OUT)], [#r(p2.OUT)],
    [Ordering], [#r(p1.c_ord)], [#r(p2.c_ord)],
    [Holding], [#r(p1.c_hold)], [#r(p2.c_hold)],
    [Total], [#r(p1.total)], [#r(p2.total)],
  )

  #let EOQ = calc.sqrt(2 * D * days_per_year * S / H)

  - They should not switch
  - Ordering $T = 2$ 
    - #r(p1.c_ord - p2.c_ord) is saved on ordering costs
    - adds #r(p2.c_hold - p1.c_hold) to holding costs

  // - Holding cost dominates: $"EOQ" = sqrt(2 D S / H) approx #r(EOQ)$ gal, about #r(EOQ / D, digits: 1) days of demand, so Cyber should order *more* often than weekly, not less
]

#[

  = Problem 3

  #let D = 2400  // units/year
  #let S = 25    // $/order
  #let H = 2     // $/unit/year
  #let b = 5     // $/unit short
  #let L = 2     // weeks

  #let DLmin = 0
  #let DLmax = 200

  #let unif_ppf(p) = DLmin + p * (DLmax - DLmin)
  #let unif_loss(R) = calc.pow(DLmax - R, 2) / (2 * (DLmax - DLmin))

  #let RQ(Q0, lost: false, max_iter: 50, threshold: 0.005) = {
    let Q = Q0
    let R = 0
    for i in range(max_iter) {
      let p_short = if lost { Q * H / (Q * H + b * D) } else { Q * H / (b * D) }
      R = unif_ppf(1 - p_short)
      let Q_new = calc.sqrt(2 * D * (S + b * unif_loss(R)) / H)
      let delta = calc.abs(Q_new - Q)
      Q = Q_new
      if delta <= threshold { break }
    }
    (R: R, Q: Q)
  }

  #let Q_EOQ = calc.sqrt(2 * D * S / H)
  #let back = RQ(Q_EOQ)
  #let lost = RQ(Q_EOQ, lost: true)

  $
    Q_0 = "EOQ" = sqrt((2 D S) / H) = #r(Q_EOQ)
  $

  *Backorders:* $P(D_L > R) = (Q H) / (b D)$

  *Lost sales:* $P(D_L > R) = (Q H) / (Q H + b D)$

  $
    Q = sqrt((2 D (S + b n(R))) / H), quad n(R) = (200 - R)^2 / 400
  $

  #table(
    columns: 3,
    inset: 1em,
    [], [*Q*], [*R*],
    [Backorder], [#result[#r(back.Q)]], [#result[#r(back.R)]],
    [Lost sales], [#result[#r(lost.Q)]], [#result[#r(lost.R)]],
  )

  - R and Q are almost the same in both cases
  - 

]

