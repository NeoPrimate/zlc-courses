
$
  L = 0 \
  D tilde N(20, 4) \
$

Excess Demand $arrow.long$ Backorders

Products
- Wrench
- Paint
- Salt

Holding Cost (weekly)

$
  H = 0.07
$

Ordering Cost

$
  S = 6.3
$

Stockout Penalty (event)

$
  20
$

#let H = 0.07
#let S = 6.3
#let mu_D = 20
#let sigma_D = 8

#line(length: 100%)

#let Q = calc.sqrt((2 * mu_D * S) / H)

Q = #Q

#let z = 2
#let T = Q / mu_D


Q = #(Q + 3 * sigma_D)

#let L = 1

#(mu_D * L)

T = #T

#let TVC(Q) = S * (mu_D / Q) + H * (Q / 2)

#let ROP = T * mu_D

ROP = #ROP

#line(length: 100%)

#let H = 0.07
#let S = 6.3
#let mu_D = 20
#let sigma_D = 8
#let L = 1          // lead time, same units as mu_D
#let z = 2          // ≈ 97.7% cycle service level

#let Q = calc.sqrt((2 * mu_D * S) / H)
#let T = Q / mu_D
#let TVC(Q) = S * (mu_D / Q) + H * (Q / 2)

#let LTD = mu_D * L
#let SS = z * sigma_D * calc.sqrt(L)
#let ROP = LTD + SS

Q = #Q \
T = #T \
TVC(Q) = #TVC(Q) \
Lead-time demand = #LTD \
Safety stock = #SS \
ROP = #ROP


