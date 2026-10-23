= (s, S)

Newsvendor Expected Profit

- $K$: setup cost


$
  pi(y) = E[underbrace(p dot min(y, D)) + underbrace(u dot (u - D)^+) - underbrace(g dot (D - y)^+) - underbrace(c dot y)]
$

$
  F(S) = c_u / (c_u + c_o)
$

#let H = 0.07
#let K = 6.3        // setup cost (was S)
#let mu_D = 20
#let sigma_D = 8
#let L = 1          // lead time
#let R = 0          // review period (0 = continuous)
#let z = 2

#let Q = calc.sqrt((2 * mu_D * K) / H)
#let P = R + L      // protection interval

#let s = mu_D * P + z * sigma_D * calc.sqrt(P)
#let S_up = s + Q

#let I0 = 0
#let first_order = if I0 <= s { S_up - I0 } else { 0 }

Initial order = #calc.ceil(first_order)

s = #calc.round(s, digits: 2) \
S = #calc.round(S_up, digits: 2) \
Order when IP ≤ s, quantity = S - IP

== Heuristic (s, S)

+ s

  $
    F(s) = c_u / (c_u + c_o)
  $

  For *one-period* demand

+ S

  EOQ

  $
    F(S) = c_u / (c_u + c_o)
  $

  $
    D_3 = (20 times 3, 8 times sqrt(3)) \
    "cr" = c_u / (c_u + c_o) \
    z("cr") \
    S = mu 3 + z sigma sqrt(3)
  $


  == Game

  $
    D tilde N(20, 10)
  $