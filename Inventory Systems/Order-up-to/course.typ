#set heading(numbering: "1.1.")
#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)
#import "@local/tystats:0.1.0": norm, expon, poisson, uniform

#import "@preview/lilaq:0.6.0" as lq
#import "@preview/tiptoe:0.4.0"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#import "../../../../lib/imports.typ": example

#let gap = 8pt
#show math.underbrace: it => {
  if it.body.func() == box { return it }
  math.underbrace(box(inset: (bottom: gap), $it.body$), it.annotation)
}

= Order-up-to

- Period: (e.g., 1 day, 1 week, etc.)
- Sequence of events
  + Replenishment order is placed beginning of period
  + Inventory (from previous period) is received
  + Random demand occurs
- Lead time ($L$) 
  - Assumption: assume multiple of review period

Stationary demand:

$
  D tilde N(mu, sigma)
$

- $T$: Period
- Lead time $L$ (multiple of $T$)
- On-order (pipeline) inventory
- On-hand inventory
- Backorder (no lost sales)
- Inventory levels (on-hand inventory - backorders)
- Inventory position = on-hand + pipeline - backorder
- Order-up-to level ($S$) (base-stock level) (*target inventory position*)
  - Maximum inventory position we allow

Order quantity = S - inventory position

- Inventory position = on-hand + pipeline - backorder
  - Negative value: 
    - On-hand = 0
    - pipeline < backorder

Order quantity period $t_1$ = demand of period $t_(-1)$

Order up to level $S$ (base-stock level)
- Tha maximum inventory position we allow

#example[
  - Period: 1 week
  - Lead time: $L$ weeks
  - 1 Month = 4 Weeks
  - Demand $D tilde N(mu, sigma)$

  Weekly demand
  - $"mean" = mu / 4$
  - $s.d. = sigma / sqrt(4)$

  L+1 demand
  - $"mean" = mu / 4 (L + 1)$
  - $s.d. = sigma / sqrt(4) sqrt(L + 1)$

  Target in-stock probability (99.9%)
  - $P(D "over" L + 1 lt.eq S) = 0.999$

  $F(3.08) = 0.999$

  Choose $z = 3.08$

  $S = mu_(L+1) + z sigma_(L + 1)$

  $mu$ and $sigma$ are params of the normal distribution that describe the demand over $L+1$ periods

]

Performance Measures
- In-stock probability

$
  P(D_(L+1) lt.eq S)
$

- Stockout probability

$
  1 - P(D_(L+1) lt.eq S)
$

- E[Backorder]

$
  z = (S - mu_(L+1)) / sigma_(L+1)
$

Lookup $L(z)$ (standard normal loss function)

$
  E["Backorder"] = sigma_(L+1) L(z)
$

If the order-up-to is $S$, then on average ...


- E[Onhand] (E[Safety], E[Leftover])

$
  E["OnHand"] = S - E[D_(L+1)] + E["backorder"]
$

- E[OnOrder]

$
  E["OnOrder"] = L dot E["Demand in one period"]
$

- Pipeline (On-Order) Inventory

$
  L dot E[D]
$

- E[CycleInventory]

$
  E["CycleInventory"] = mu / 2
$

- Fillrate

$
  E["Fillrate"] = 1 - E["Backorder"] / mu
$

- Safety Stock

$
  sqrt(L+1) dot sigma dot L(z)
$

- Days of Supply

$
  sqrt(L+1) dot sigma / mu dot (phi(z) + z Phi(z))
$

Lead time, Variability of Demand, ...



Tradeoff:

- $h$: holding cost per unit period
- $b$: penalty per unit backorder

#example[
  Supposed S = 4

  - If a period begins with inventory position = -3

  ...
]

$
  D tilde N(mu, sigma) quad arrow.double quad D_(L+1) tilde (mu (L+1), sigma sqrt(L+1))
$

#example([Medtronic's InSync pacemaker])[

]


Choosing S to meet target in-stock (Normal distribution)

$
  alpha = 0.999
$

$
  F(z) = 0.999 \
  z = 3.08 \
$

Justifying Service Level via Cost Minimization

- $h$: holding cost per unit per period
- $b$: penalty per unit backorder 

- $S$ too high, holding cost, $c_o = h$
- $S$ too low, backorders, $c_u = b$

$
  P(D_(L+1) lt.eq S) = 
$

General case ($L+1 quad arrow quad L+T$)

$
  L + T
$

$
  S = mu_(L+T) + z dot sigma_(L+T)
$

== T 

Increasing period length leads to larger  less frequent orders:

$
  T^* = 
$


