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



