#set heading(numbering: "1.1.")
#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)
#import "@local/tystats:0.1.0": norm, expon, poisson, uniform

#import "@preview/lilaq:0.6.0" as lq
#import "@preview/tiptoe:0.4.0"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// #import "../../../../lib/imports.typ": example

= Risk Pooling

Variations in demand across

== Product Pooling

*Example*

$
  mu = \
  sigma = \
$

$
  "cr" = \
$

$
  Q^* = \
$

$
  E["profit"]
$

- $mu$ increases linearly
- $sigma$ increases with the $sqrt(x)$

$
  &mu dot 2 \
  &sigma dot sqrt(2)
$

Pooling of *Negatively correlated* or *uncorrelated* assets

$
  "cov"(X, Y) = E[X - E[X]](Y - E[Y]) - E[X Y] - E[X]E[Y]
$

$
  rho(X, Y) = "cov"(X, Y) / sqrt("var"(X) "var"(Y)) quad arrow quad rho in [-1, 1]
$

$
  "var"(X + Y) = "var"(X) + "var"(Y) + 2 "cov"(X, Y)
$

$
  "var"(sum_(i=1)^n X_i) = sum_(i=1)^n "var"(X_i) + sum_((i,j) | i eq.not j)^n "cov"(X_i, X_j)
$

$
  = sigma sqrt(2 dot (1 + rho))
$

If $rho = 1$:
- $sigma 2$ (no gain)
If $rho = -1$:
- $sigma sqrt(2)$ (gain)

1. *Manufacture*-driven substitution

2. *Customer*-driven substitution

Pooling: Same *service level* with reduced *inventory*

== Location

Single location stores used by several 

$
  SS^C / SS^D = 1 / sqrt(n)
$

Where:
- $SS^C$: *Centralized* safety stock
- $SS^D$: *Decentralized* safety stock

== Capacity

Trade-off:
- Capacity
- Flexibility

== Lead time

=== Delayed Differentiation (Postponement)



#table(
  columns: (auto, 1fr, 1fr, 1fr),
  align: (left, left, left, left),
  [], [Newsvendor], [Order-up-to (OUT)], [$(Q, R)$ continuous review],

  [Setting],
  [One period, no reorder],
  [Periodic review every $T$ (here $T = 1$)],
  [Monitor continuously; order $Q$ when inventory position hits $R$],

  [Decision],
  [Order quantity $Q$],
  [Order-up-to level $S$],
  [Reorder point $R$, order quantity $Q$],

  [Protection period],
  [The single season],
  [$L + T = L + 1$],
  [$L$],

  [$z$ from],
  [Critical ratio $C_u / (C_u + C_o)$],
  [Target in-stock probability],
  [Target CSL],

  [Decision formula],
  [$Q^* = mu + z sigma$],
  [$S = mu_(L+1) + z sigma sqrt(L+1)$],
  [$R = mu L + z sigma sqrt(L)$, #h(0.3em) $Q^* = sqrt((2 mu S) / H)$],

  [Safety stock],
  [$z sigma$],
  [$z sigma sqrt(L+1)$],
  [$z sigma sqrt(L)$],

  [Avg. inventory],
  [$E["leftover"] = Q - mu + E["lost sales"]$],
  [$S - mu_(L+1) + E["back"]$],
  [$Q / 2 + "SS"$],

  [Expected shortage],
  [$E["lost sales"] = sigma L(z)$],
  [$E["back"] = sigma sqrt(L+1) L(z)$],
  [Per cycle: $sigma sqrt(L) L(z)$],

  [Pooled $sigma$],
  table.cell(colspan: 3, align: center)[
    $sigma^C = sqrt(sum_i sigma_i^2 + 2 sum_(i < j) rho_(i j) sigma_i sigma_j)$
    #h(1em) (independent: $sqrt(sum_i sigma_i^2)$)
  ],

  [What pooling saves],
  [Mismatch cost (leftovers + lost sales)],
  [Safety stock and backorders],
  [Safety stock, plus cycle stock through the EOQ scale effect ($Q prop sqrt(mu)$)],

  [Course example],
  [—],
  [Problem 2: $sigma = sqrt(2) dot 65$],
  [Problem 1: $sigma = sqrt(sum_i sigma_i^2)$],
)

#text(size: 7pt)[$L(z)$: standard normal loss function.]