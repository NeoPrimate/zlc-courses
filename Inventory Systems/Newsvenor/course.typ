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

= Newsvendor

- Demand is random
- Single period

How much should be produced every day?

Too much v. Too little

Demand uncertainty: 
- Demande is a *random variable*
- We don't know the *realization*

#let p = 2.50 // revenue per unit
#let c = 1.00 // cost per unit
#let s = 0 // salvage value
#let g = 0.50 // goodwill

#let T = 100
#let mu_D = 30
#let sigma_D = 6
#let D = norm.rvs(mean: mu_D, std_dev: sigma_D, size: T)
#let t = range(0, T)

#let mean_D = D.sum() / D.len()

#let cr(cu, co) = cu / (cu + co)

$
  D tilde N(mu, sigma)
$

#figure(
  lq.diagram(
    width: 8cm,
    height: 6cm,
    lq.plot(t, D),
    lq.hlines(mean_D, stroke: red)
  ),
  caption: [Random Demand]
)



#let pdf(x) = norm.pdf(x, mean: mean_D, std_dev: sigma_D)
#let cdf(x) = norm.cdf(x, mean: mean_D, std_dev: sigma_D)

#let x = lq.linspace(mu_D - 3 * sigma_D, mu_D + 3 * sigma_D, num: 200)

#let y_pdf = x.map(pdf)
#let y_cdf = x.map(cdf)

#let n-bins = 25
#let lo = calc.min(..D)
#let hi = calc.max(..D)
#let width = (hi - lo) / n-bins

#let bin-index(x) = calc.min(n-bins - 1, int(calc.floor((x - lo) / width)))
#let counts = (0,) * n-bins
#for x in D {
  let i = bin-index(x)
  counts.at(i) += 1
}

#let counts = counts.map(c => c / D.len())
#let centers = range(n-bins).map(i => lo + (i + 0.5) * width)

#let counts-cdf = range(counts.len()).map(i => counts.slice(0, i + 1).sum())
#let y_cdf = x.map(xi => norm.cdf(xi, mean: mu_D, std_dev: sigma_D))

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  [
    #lq.diagram(
      title: [PDF\ Empirical & Theoretical],
      lq.bar(
        centers,
        counts,
        width: 100%,
      ),
      lq.plot(x, y_pdf, mark: none, stroke: 1.5pt)
    )
  ],
  [
    #lq.diagram(
      title: [CDF\ Empirical & Theoretical],
      lq.bar(
        centers,
        counts-cdf,
        width: 100%,
      ),
      lq.plot(x, y_cdf, mark: none, stroke: 1.5pt)
    )
  ]
)

#let Q = 35

  #let x_Q_l = lq.linspace(mu_D - 3 * sigma_D, Q, num: 200)
  #let y_Q_l = x_Q_l.map(pdf)
  #let x_Q_r = lq.linspace(Q, mu_D + 3 * sigma_D, num: 200)
  #let y_Q_r = x_Q_r.map(pdf)

  #figure(
    lq.diagram(
      width: 12cm,
      height: 8cm,
      xaxis: (ticks: ((Q, $Q$),), subticks: none),
      yaxis: (ticks: none, subticks: none),
      title: [Expected Overage & Underage],
      lq.plot(x, y_pdf, mark: none, stroke: 1.5pt),
      lq.fill-between(x_Q_l, y_Q_l, fill: blue.transparentize(75%)),
      lq.fill-between(x_Q_r, y_Q_r, fill: orange.transparentize(75%)),
      lq.vlines(Q, stroke: red + 1.5pt),
    )
  )

#[
  #grid(
    columns: (1fr, 1fr),
    inset: 1em,
    [Expected overage (marginal)], [Expected underage (marginal)],
    [
      $
        c_o dot F(Q)
      $
    ],
    [
      $
        c_u dot (1 - F(Q))
      $
    ]
  )

  #let mean_D = 30
  #let sd_D = 6
  #let co = 1
  #let cu = 1.5
  #let Q = lq.linspace(0, 100, num: 200)
  #let co_marginal = Q.map(Q => co * norm.cdf(Q, mean: mean_D, std_dev: sd_D))
  #let cu_marginal = Q.map(Q => cu * (1 - norm.cdf(Q, mean: mean_D, std_dev: sd_D)))

  #let cr = cu / (cu + co)

  #lq.diagram(
    title: [CDF],
    width: 12cm,
    height: 8cm,
    xlabel: [Q],
    ylabel: [Marginal Loss / Gain],
    yaxis: (
      ticks: ((cr, [$"cr" = cr$]), ),
      subticks: none,
    ),
    xaxis: (
      ticks: none,
      subticks: none,
    ),
    lq.plot(Q, co_marginal, mark: none, stroke: 1.5pt, label: [$E["Overage"] = c_o dot F(Q)$]),
    lq.plot(Q, cu_marginal, mark: none, stroke: 1.5pt, label: [$E["Underage"] = c_u dot (1 - F(Q))$]),
    lq.hlines(cr, stroke: 1.5pt + red)
  )
]

Optimal production quantity:

$
  c_o dot F(Q^*) &= c_u dot (1 - F(Q^*)) \
  F(Q^*) &= c_u / (c_u + c_o)
$

Type I service level ($a$): probability of *not* stocking out. 

The cost-optimal $Q^*$ corresponds to $a = c_u / (c_u + c_o)$.

$
  F(Q^*) &= a \
  Q^* &= F^(-1)(a) = mu + z(a) sigma quad "if" D tilde N(mu, sigma^2)
$

where $z(a) = Phi^(-1)(a)$ is the inverse of the standard normal CDF.

```py
from scipy.stats import norm

a = norm.cdf(Q, loc=mu, scale=sigma)    # Q -> service level
Q = mu + norm.ppf(a) * sigma            # service level -> Q
Q = norm.ppf(a, loc=mu, scale=sigma)    # equivalently
```

#[

  - $D$: demand
  - $Q$: order quantity
  - $p$: unit revenue
  - $c$: unit cost
  - $s$: salvage vaue per unit leftover
  - $g$: goodwill cost per unit short

  #let hl(body) = text(fill: red, weight: "bold", body)
  
  #let event(x, side, body) = {
    let (y0, y1, anchor) = if side == top { (1.2, 0.08, bottom) } else { (-1.2, -0.08, top) }
    (
      lq.line((x, y0), (x, y1), tip: tiptoe.stealth),
      lq.place(x, y0, pad(4pt, align(center, body)), align: anchor),
    )
  }
  
  #lq.diagram(
    width: 12cm, height: 5cm,
    xlim: (-0.3, 10), ylim: (-2.6, 2.6),
    xaxis: none, yaxis: none, grid: none,
  
    // time axis with start/end bars
    lq.line((0, 0), (9.5, 0), stroke: 1.5pt, tip: tiptoe.stealth),
    lq.line((0, -0.25), (0, 0.25), stroke: 2pt),
    lq.line((8.8, -0.25), (8.8, 0.25), stroke: 2pt),
    lq.place(0, -0.35, [0], align: top),
    lq.place(8.8, -0.35, [$T$], align: top),
    lq.place(9.6, 0, [time], align: left),
  
    // events
    ..event(0.4, top,    [Firm decides \ order quantity $Q$]),
    ..event(1.6, bottom, [Pays #hl[$c dot Q$]]),
    ..event(4.0, top,    [Demand $D$ \ is realized]),
    ..event(5.0, bottom, [Receives revenue \ #hl[$p dot min(Q, D)$]]),
    ..event(7.8, top,    [Excess inventory \ is salvaged \ #hl[$s dot (Q - D)^+$]]),
    ..event(7.8, bottom, [Penalty for lost \ sales is paid \ #hl[$g dot (D - Q)^+$]]),
  )
]

Objective function

$
  pi (Q) = E\[underbrace(p dot min(Q, D), "sold") + underbrace(s dot (Q - D)^+, "salvage") - underbrace(g dot (D - Q)^+, "short") - underbrace(c dot Q, "purchasing")\]
$ 

Rewrite:

#grid(
  columns: 2,
  inset: 1em,
  align: center + horizon,
  [
    $
      min(D, Q) = D - (D - Q)^+
    $
  ], 
  [
    - $D gt Q arrow Q$
    - $D lt Q arrow D$
  ],
  [
    $
      Q = D - (D - Q)^+ + (Q - D)^+
    $
  ], 
  [
    - $D gt Q arrow Q$
    - $D lt Q arrow Q$
  ],
)

We get:

$
  pi(Q) = underbrace((p - c) E[D], "Profit\n (Perfect Demand\n Information)") - E\[underbrace((p + g -c), "Underage") dot (D - Q)^+ + underbrace((c - s), "Overage") dot (Q - D)^+\]
$
The profit maximization problem is equivalent to minimizing of:

$
  C(Q) = E[c_u dot (D - Q)^+ + c_o dot (Q - D)^+]
$

Where:
- $c_u  = p + g - c$
- $c_o  = c - s$

$
  (dif C(Q)) / (dif Q) = c_o F(Q) - c_u (1 - F(Q)) = 0
$

$
  F(Q^*) = P(D lt.eq Q^*) = c_u / (c_u + c_o) = (p - c + g) / (p - s + g) = alpha
$

Minimize the expected total cost of underage and overage, choose $Q$ such that the probability that we don't have lost sales (i.e., demand is $Q$ or lower) equals the critical ratio.

#example([O'Neill's Hammer 3/2 Wetsuit])[
  #let mean_D = 3192
  #let sd_D = 1181
  #let p = 190
  #let c = 110
  #let s = 90
  #let g = 0

  - Demand mean ($mu_D$): #mean_D units / period
  - Demand std ($sigma_D$): #sd_D units / period
  - Price ($p$): #p \$ / unit sold
  - Cost ($c$): #c \$ / unit bought
  - Salvage ($s$): #s \$ / unit leftover
  - Goodwill ($g$): #g \$ / unit short

  #let cu = p - c + g
  #let co = c - s
  #let cr = cu / (cu + co)

  $
    "cr" = #cu / (#cu + #co) = #cr
  $

  #let z = norm.ppf(cr)
  
  $
    z = #calc.round(z, digits: 2)
  $
  
  #let Q = mean_D + z * sd_D

  #let Q = norm.ppf(cr, mean: mean_D, std_dev: sd_D)

  $
    Q 
    &= mu + z(alpha) dot sigma \
    &= #mean_D + #calc.round(z, digits: 2) dot #sd_D \
    &= #calc.round(Q, digits: 2)
  $
]

== Performance Measures

=== In-stock Probability (Type I - Service Level)

Probability all demand is satisfied

$
  D lt.eq Q
$

$
  F(Q) = Phi(z)
$

```py
from scipy.stats import norm

z = (Q - mu) / sigma
instock = norm.cdf(z)
```

Choose $Q$ subject to a minimum in-stock probability

```py
from scipy.stats import norm

p_instock = 0.99

z = norm.ppf(p_instock)
Q = mu + z * sigma
Q = norm.ppf(p_instock, loc=mu, scale=sigma)
```

=== Stockout Probability

$
  P("Stockout") = P(D > Q) = 1 - F(Q) = 1 - Phi(z), quad z = (Q - mu) / sigma
$

The complement of the Type I service level: $P("Stockout") = 1 - a$.
At the cost-optimal $Q^*$: 

$
  P("Stockout") = 1 - c_u / (c_u + c_o) = c_o / (c_u + c_o)
$

```py
from scipy.stats import norm

z = (Q - mu) / sigma
p_stockout = norm.sf(z)
p_stockout = norm.sf(Q, loc=mu, scale=sigma)
```

=== Fill Rate (Type II - Service Level)

$
  E["Fillrate"] = E["Sales"] / mu = 1 - E["Short"] / mu
$

=== Expected Lost Sales (Shortage)

$
  E["Short"] = E[(D - Q^+)] = integral_Q^infinity (D - Q) f(D) dif D
$

$
  L(z) = phi(z) - z (1 - Phi(z))
$

```py
from scipy.stats import norm

z = (Q - mu) / sigma
L = norm.pdf(z) - z * (1 - norm.cdf(z))
e_short = sigma * L
e_short = sigma * (norm.pdf(z) - z * norm.sf(z))
```

#[

  #let mean_D = 3192
  #let sd_D = 1181
  #let p = 190
  #let c = 110
  #let s = 90
  #let g = 0

  #let e_lost(Q) = {
    let z = (Q - mean_D) / sd_D
    let L = norm.pdf(z) - z * (1 - norm.cdf(z))
    sd_D * L
  }

  #let x = lq.linspace(0, 5000, num: 200)
  #let y = x.map(e_lost)

  #lq.diagram(
    width: 12cm,
    height: 8cm,
    xlabel: [Q],
    ylabel: [E[Lost]],
    lq.plot(x, y, mark: none, stroke: 1.5pt),
  )
]

=== Expected Sales

$
  E["Sold"] = E[min(D, Q)] = E[D - (D - Q)^+] = mu - E["Short"]
$

```py
z = (Q - mu) / sigma
e_short = sigma * (norm.pdf(z) - z * norm.sf(z))
e_sales = mu - e_short
```

=== Expected Leftover

$
  E["Leftover"] = Q - E["Sales"] = Q - mu + E["Short"]
$

```py
z = (Q - mu) / sigma
e_short = sigma * (norm.pdf(z) - z * norm.sf(z))
e_sales = mu - e_short
e_leftover Q - e_sales
```

#[
  #let mean_D = 29
  #let sd_D = 5
  #let Q = 31
  
  #let z = (Q - mean_D) / sd_D
  #let e-short = sd_D * (norm.pdf(z) - z * (1 - norm.cdf(z)))
  #let e-sales = mean_D - e-short
  #let e-left = Q - e-sales
  #let fmt(v) = str(calc.round(v, digits: 2))
  
  #let blue = rgb("#2a6fdb")
  #let red = rgb("#d6453d")
  #let green = rgb("#2e9e5b")
  
  #let xs = lq.linspace(0, 50, num: 201)
  #let Qs = xs.map(_ => Q)
  #let sold = xs.map(d => calc.min(d, Q))
  
  #lq.diagram(
    width: 14cm, height: 10cm,
    title: [Per outcome $D$],
    xlabel: $D$, ylabel: [units],
    xlim: (0, 50), ylim: (0, 50),
    legend: (position: top + left),
  
    lq.fill-between(xs, sold, fill: blue.transparentize(65%), label: [sold $min(D, Q)$]),
    lq.fill-between(xs, sold, y2: Qs, fill: green.transparentize(55%), label: [leftover $(Q - D)^+$]),
    lq.fill-between(xs, sold, y2: xs, fill: red.transparentize(65%), label: [short $(D - Q)^+$]),
    lq.plot(xs, xs, mark: none, stroke: (paint: gray.darken(20%), dash: "dashed")),
    lq.plot(xs, Qs, mark: none, stroke: (paint: gray.darken(20%), dash: "dashed")),
    lq.plot(xs, sold, mark: none, stroke: 1.5pt + blue),
    lq.vlines(Q, stroke: (paint: black, dash: "dotted")),
    lq.place(Q, 2, pad(2pt)[$Q$], align: left + bottom),
    lq.place(46, 46, pad(3pt)[$y = D$], align: right + bottom),
    lq.place(49, Q, pad(1em)[$y = Q$], align: right + bottom),
  )
  
  #let S(x) = 1 - norm.cdf((x - mean_D) / sd_D)
  #let xl = lq.linspace(0, Q, num: 120)
  #let xr = lq.linspace(Q, 50, num: 120)
  
  #lq.diagram(
    width: 14cm, height: 10cm,
    title: [In expectation: areas around $1 - F$],
    xlabel: $x$, ylabel: $P(D > x)$,
    xlim: (0, 50), ylim: (0, 1.05),
    legend: (position: top + right),
  
    lq.fill-between(xl, xl.map(S), fill: blue.transparentize(65%), label: [$E["Sales"]$ = #fmt(e-sales)]),
    lq.fill-between(xl, xl.map(S), y2: xl.map(_ => 1), fill: green.transparentize(55%), label: [$E["Leftover"]$ = #fmt(e-left)]),
    lq.fill-between(xr, xr.map(S), fill: red.transparentize(65%), label: [$E["Short"]$ = #fmt(e-short)]),
    lq.plot(xs, xs.map(S), mark: none, stroke: 1.5pt + black),
    lq.plot((0, Q, Q), (1, 1, 0), mark: none, stroke: 0.8pt + green.darken(20%)),
    lq.place(Q, 0.02, pad(2pt)[$Q$], align: left + bottom),
  )
  
  #v(2mm)
  #align(center, grid(
    columns: 3, column-gutter: 1.2em, row-gutter: 0.7em, align: (right, center, left),
    [blue + red],   [$=$], [total area under $1 - F$ $= mu$  #h(1em) $arrow.r.double$ $E["Sales"] = mu - E["Short"]$],
    [blue + green], [$=$], [rectangle $Q times 1$ $= Q$ #h(1em) $arrow.r.double$ $E["Leftover"] = Q - E["Sales"] = Q - mu + E["Short"]$],
  ))
]

=== Expected Profit

$
  E["Profit"] = pi (Q) = p E["Sales"] + s E["Leftover"] - g E["Short"] - c Q
$

#example[
  Expected profit if we order 4196 units of Hammer 3/2s

  #let Q = 4196
  
  #let mean_D = 3192
  #let sd_D = 1181
  #let p = 190
  #let c = 110
  #let s = 90
  #let g = 0

  - Order quantity ($Q$): #Q units
  - Demand mean ($mu_D$): #mean_D units / period
  - Demand std ($sigma_D$): #sd_D units / period
  - Price ($p$): #p \$ / unit sold
  - Cost ($c$): #c \$ / unit bought
  - Salvage ($s$): #s \$ / unit leftover
  - Goodwill ($g$): #g \$ / unit short

  #let z = (Q - mean_D) / sd_D
  #let L = norm.pdf(z) - z * (1 - norm.cdf(z))
  #let e_short = sd_D * L

  $
    z = (Q - mu) / sigma = (#Q - #mean_D) / #sd_D = #calc.round(z, digits: 2)
  $

  $
    L(z) = phi(z) - z (1 - Phi(z)) = #calc.round(L, digits: 2)
  $

  $
    E["Short"] = sigma L = #calc.round(e_short, digits: 2)
  $

  #let e_sales = mean_D - e_short

  $
    E["Sales"] = mu - E["Short"] = #calc.round(e_sales, digits: 2)
  $

  #let e_leftover = Q - e_sales

  $
    E["Leftover"] = Q - E["Sales"] = #calc.round(e_leftover, digits: 2)
  $

  #let e_profit = p * e_sales + s * e_leftover - g * e_short - c * Q

  $
    E["Profit"] 
    &= p E["Sales"] + s E["Leftover"] - g E["Short"] - c Q \
    &= #calc.round(e_profit, digits: 2)
  $

  #let e_fill = e_sales / mean_D

  $
    E["Fill"] = E["Sales"] / mu = #calc.round(e_fill, digits: 2)
  $

  #let e_instock = norm.cdf(z)

  $
    E["InStock"] = Phi(z) = #calc.round(e_instock, digits: 2)
  $

  #let e_stockout = 1 - norm.cdf(z)

  $
    E["Stockout"] = 1 - Phi(z) = #calc.round(e_stockout, digits: 2)
  $
]

== Poisson Distribution

PMF

$
  P(D = x) = (lambda^x e^(-lambda)) / x!
$

CDF

$
  F(Q) = P(D lt.eq Q) = sum_(x=0)^Q P(x) = sum_(x=0)^Q (lambda^x e^(-lambda)) / x!
$

$
  E["Lost"] = lambda - lambda F(Q - 1) - Q (1 - F(Q))
$

#example([Tea World])[
  #let p = 80
  #let c = 35
  #let s = 20
  #let g = 0
  #let lam = 4.5


  #let co = c - s
  #let cu = p + g - c
  #let cr = cu / (cu + co)

  #let Q = poisson.ppf(cr, lam)

  #Q

  #let e_lost = lam - lam * poisson.cdf(Q - 1, lam) - Q * (1 - poisson.cdf(Q, lam))

  #e_lost
]

== Double Marginalization: Buyback Contract



#table(
  columns: (auto, auto, 1fr),
  inset: 1em,
  align: left + horizon,
  table.header([*What's given*], [*What you do*], [*Formula*]),

  [$w$], [Solve for $b$],
  [$b = p + r - (p - w) dot (p - s)/(p - c)$],

  [$b$], [Solve for $w$],
  [$w = p - (p - b + r) dot (p - c)/(p - s)$],

  [Neither: "for which $w$ does it work?"], [Give the feasible range],
  [$c < w < p - r (p - c)/(c - s)$],

  [Neither: "which $w$ would both accept?"], [Give the win-win range],
  [$w_0 + (Pi_S^0 - Pi_S (w_0))/m <= w <= w_0 + (Pi_R (w_0) - Pi_R^0)/m$ \
   with $m = Q^* - L (p - s)/(p - c)$],
)

#let box-node(pos, label, name) = node(
  pos, label,
  width: 25mm, height: 10mm,
  fill: gray.lighten(60%),
  stroke: 1pt + gray.darken(20%),
  corner-radius: 5pt,
  name: name,
)

#let step(n) = box(
  inset: 0.25em, stroke: black, radius: 100%,
  fill: white, text(size: 8pt, weight: "bold")[#n],
)

#let uses(..n) = text(size: 8pt, fill: gray.darken(30%))[
  uses #n.pos().map(str).join(", ")
]

1, 3 and 4 need only the given data

2 needs 1
5 needs 4
6 needs 3

#table(
  columns: (1fr, 1fr),
  inset: 0.8em,
  align: center + top,
  table.cell(
    colspan: 2,
    [
      #diagram(
        spacing: (8mm, 5mm),
        node((-1, 0), [$c$], name: <Cost>),
        box-node((0, 0), [Supplier], <S>),
        box-node((6, 0), [Retail], <R>),
        node((7, 0), [$p$ \ $s$], name: <Mkt>),

        edge(<S>, <R>, "-|>", [$w$], bend: 15deg),
        edge(<S>, <R>, "<|-", [$b$ (retailer pays $h$)], bend: -15deg, label-side: right),
      )
    ]
  ),
  table.cell(
    colspan: 2,
    align: left,
    text(size: 8pt)[
      - $c$ production cost
      - $w$ wholesale price
      - $p$ retail price
      - $s$ retailer salvage
      - $b$ buyback price
      - $h$ return cost per unit
      - $v$ supplier salvage on returns
      - $b - h$: what the retailer nets for each return
    ],
  ),
  table.cell(fill: gray.lighten(80%))[*Supplier*],
  table.cell(fill: gray.lighten(80%))[*Retail*],
  [
    #text(size: 9pt)[Wholesale #step(1)]
    $ E[pi_S] = (w - c) Q $
  ],
  [
    #text(size: 9pt)[Wholesale #step(1)]
    $
        c_u &= p - w \
        c_o &= w - s \
        "cr" &= c_u / (c_u + c_o) \
        Q^* &= F^(-1)("cr") \
        z &= (Q^* - mu) / sigma \
        L(z) &= phi(z) - z (1 - Phi(z)) \
        E["Short"] &= sigma L(z) \
        E["Sales"] &= mu - E["Short"] \
        E["Leftover"] &= Q^* - S \
        E[pi_R] &= p E["Sales"] + s E["Leftover"] - w Q^*
    $
  ],
  [
    #text(size: 9pt)[Buyback]
    $ E[pi_S] = (w - c) Q - (b - v) E["Leftover"] $
  ],
  [
    #text(size: 9pt)[Buyback (1)]
    $
      c_u = p - w \
      c_o = w - (b - h) \
      E[pi_R] = p E["Sales"] + (b - h) E["Leftover"] - w Q
    $
  ],

  // Supply chain
  table.cell(
    colspan: 2,
    [
      #text(size: 9pt)[*Supply Chain* #step(1)]
      $
        c_u = p - c \
        c_o = c - s \
        E[pi_"SC"] = p E["Sales"] + s E["Leftover"] - c Q
      $

      #text(size: 9pt)[Coordinating buyback: set $"cr"_R = "cr"_"SC"$]
      
      $
        (p - w) / (p - (b - h)) = (p - c) / (p - s)
        quad quad => quad quad
        b^* = p + h - ((p - w)(p - s)) / (p - c)
      $
    ]
  ),
)

#table(
  columns: (auto, auto),
  inset: 1em,
  align: left + horizon,
  [E[Shortage]], [$phi(z) - z dot (1 i Phi(z))$],
  [E[Leftovers]], [$z dot Phi(z) + phi(z)$],
)

#line(length: 100%)

#let c = 100
#let w = 175
#let p = 250
#let s = 75
#let r = 5

#let mean_D = 1000
#let sd_D = 300

// Superscripts: BB = buyback contract, W = wholesale-only contract (no buyback)

*Step 1.* Find the best order quantity for the whole chain

#let cu = p - c
#let co = c - s
#let cr = cu / (cu + co)
#let z = norm.ppf(cr)
#let Q = mean_D + z * sd_D

- $c_u = p - c = #cu, quad c_o = c - s = #co$
- $"CR" = c_u / (c_u + c_o) = #calc.round(cr, digits: 3)$
- $z = Phi^(-1)("CR") = #calc.round(z, digits: 3)$
- $Q^* = mu + z sigma = #calc.round(Q)$

*Step 2.* Find the buyback price $b$ for the given $w$

Choose $b$ so that SkiPro's critical ratio equals the chain's:

#let b = p + r - (p - w) * (p - s) / (p - c)

$
  (p - w) / (p - b + r) = (p - c) / (p - s)
  quad arrow.double quad
  b = p + r - (p - w) (p - s) / (p - c) = #calc.round(b, digits: 2)
$

With this $b$, SkiPro's own critical ratio is #calc.round(cr, digits: 3), so it orders $Q^* approx #calc.round(Q)$.

*Step 3.* Check the conditions

#let w_max = p - r * (p - c) / (c - s)

- $s + r < b < w$: $#(s + r) < #calc.round(b, digits: 2) < #w$ #if s + r < b and b < w [✓] else [✗]
- Holds for any $w$ with $c < w < p - r (p - c) / (c - s)$, i.e. $#c < w < #calc.round(w_max, digits: 1)$

*Step 4.* Calculate each firm's expected profit with the buyback

#let leftovers_buyback = sd_D * (z * norm.cdf(z) + norm.pdf(z))
#let sales_buyback = Q - leftovers_buyback

- $I = E["leftovers"] = sigma [z Phi(z) + phi(z)] = #calc.round(leftovers_buyback)$
- $S = E["sales"] = Q^* - I = #calc.round(sales_buyback)$

#let profit_r_buyback = p * sales_buyback + (b - r) * leftovers_buyback - w * Q
#let profit_s_buyback = (w - c) * Q - (b - s) * leftovers_buyback
#let profit_total_buyback = profit_r_buyback + profit_s_buyback

#table(
  columns: 3,
  inset: 1em,
  align: left + horizon,
  table.header([], [*Formula*], [*Value*]),
  [SkiPro], [$Pi_R^"BB" = p S + (b - r) I - w Q^*$], [#calc.round(profit_r_buyback)],
  [Obermeyer], [$Pi_S^"BB" = (w - c) Q^* - (b - s) I$], [#calc.round(profit_s_buyback)],
  [Total], [$Pi_R^"BB" + Pi_S^"BB"$], [#calc.round(profit_total_buyback)],
)

*Step 5.* Calculate each firm's profit without the buyback

Wholesale-only contract: SkiPro salvages its own leftovers.

#let cu_wholesale = p - w
#let co_wholesale = w - s
#let cr_wholesale = cu_wholesale / (cu_wholesale + co_wholesale)
#let z_wholesale = norm.ppf(cr_wholesale)
#let Q_wholesale = mean_D + z_wholesale * sd_D
#let leftovers_wholesale = sd_D * (z_wholesale * norm.cdf(z_wholesale) + norm.pdf(z_wholesale))
#let sales_wholesale = Q_wholesale - leftovers_wholesale

- $c_u = p - w = #cu_wholesale, quad c_o = w - s = #co_wholesale$
- $"CR"^W = c_u / (c_u + c_o) = #calc.round(cr_wholesale, digits: 3)$
- $z^W = Phi^(-1)("CR"^W) = #calc.round(z_wholesale, digits: 3)$
- $Q^W = mu + z^W sigma = #calc.round(Q_wholesale)$
- $I^W = sigma [z^W Phi(z^W) + phi(z^W)] = #calc.round(leftovers_wholesale)$
- $S^W = Q^W - I^W = #calc.round(sales_wholesale)$

#let profit_r_wholesale = p * sales_wholesale + s * leftovers_wholesale - w * Q_wholesale
#let profit_s_wholesale = (w - c) * Q_wholesale
#let profit_total_wholesale = profit_r_wholesale + profit_s_wholesale

#table(
  columns: 3,
  inset: 1em,
  align: left + horizon,
  table.header([], [*Formula*], [*Value*]),
  [SkiPro], [$Pi_R^W = p S^W + s I^W - w Q^W$], [#calc.round(profit_r_wholesale)],
  [Obermeyer], [$Pi_S^W = (w - c) Q^W$], [#calc.round(profit_s_wholesale)],
  [Total], [$Pi_R^W + Pi_S^W$], [#calc.round(profit_total_wholesale)],
)

*Step 6.* Compare the two contracts

#table(
  columns: 4,
  inset: 1em,
  align: (left, right, right, right),
  table.header([], [*Wholesale*], [*Buyback*], [*Change*]),
  [SkiPro], [#calc.round(profit_r_wholesale)], [#calc.round(profit_r_buyback)], [#calc.round(profit_r_buyback - profit_r_wholesale)],
  [Obermeyer], [#calc.round(profit_s_wholesale)], [#calc.round(profit_s_buyback)], [#calc.round(profit_s_buyback - profit_s_wholesale)],
  [Total], [#calc.round(profit_total_wholesale)], [#calc.round(profit_total_buyback)], [#calc.round(profit_total_buyback - profit_total_wholesale)],
)

#if profit_s_buyback < profit_s_wholesale [
  The total goes up, but at $w = #w$ Obermeyer is worse off than without the buyback, so it wouldn't offer this deal.
] else if profit_r_buyback < profit_r_wholesale [
  The total goes up, but at $w = #w$ SkiPro is worse off than without the buyback, so it wouldn't accept this deal.
] else [
  Both firms gain at $w = #w$.
]

*Step 7.* Find the win-win range for $w$

Raising $w$ by 1 (with $b$ from Step 2) moves $m$ from SkiPro to Obermeyer:

#let m = Q - leftovers_buyback * (p - s) / (p - c)
#let w_lo = w + (profit_s_wholesale - profit_s_buyback) / m
#let w_hi = w + (profit_r_buyback - profit_r_wholesale) / m
#let w_mid = (w_lo + w_hi) / 2
#let b_lo = p + r - (p - w_lo) * (p - s) / (p - c)
#let b_hi = p + r - (p - w_hi) * (p - s) / (p - c)
#let b_mid = p + r - (p - w_mid) * (p - s) / (p - c)

$
  m = Q^* - I (p - s) / (p - c) = #calc.round(m)
$

$
  w_"lo" = w + (Pi_S^W - Pi_S^"BB") / m = #calc.round(w_lo, digits: 1)
  quad quad
  w_"hi" = w + (Pi_R^"BB" - Pi_R^W) / m = #calc.round(w_hi, digits: 1)
$

#table(
  columns: 3,
  inset: 1em,
  align: (left, right, right),
  table.header([], [$w$], [$b$]),
  [Win-win range], [#calc.round(w_lo, digits: 1) – #calc.round(w_hi, digits: 1)], [#calc.round(b_lo, digits: 1) – #calc.round(b_hi, digits: 1)],
  [Fair split (midpoint)], [#calc.round(w_mid, digits: 1)], [#calc.round(b_mid, digits: 1)],
)

At the midpoint each firm gains #calc.round((profit_total_buyback - profit_total_wholesale) / 2) over the wholesale contract.

// Profits are straight lines in w, so two points (the feasible range ends) are enough
#let ws = (c, w_max)

#lq.diagram(
  width: 14cm, height: 7cm,
  xlabel: [Wholesale price $w$ (with matching $b$)],
  ylabel: [Expected profit],
  legend: (position: left + bottom),
  lq.fill-between(
    (w_lo, w_hi), (0, 0), y2: (profit_total_buyback, profit_total_buyback),
    fill: gray.transparentize(80%), stroke: none, label: [Win-win range],
  ),
  lq.plot(ws, ws.map(x => profit_r_buyback - m * (x - w)), mark: none, color: blue, label: [SkiPro]),
  lq.plot(ws, ws.map(x => profit_s_buyback + m * (x - w)), mark: none, color: red, label: [Obermeyer]),
  lq.plot(ws, ws.map(_ => profit_total_buyback), mark: none, color: green.darken(20%), label: [Total]),
  lq.hlines(profit_r_wholesale, stroke: (paint: blue, dash: "dashed")),
  lq.hlines(profit_s_wholesale, stroke: (paint: red, dash: "dashed")),
)

#line(length: 100%)

== Revenue Management with Capacity Controls

Fixed Supply, Adjust Demand

Capacity:
- Perishable (cannot be stored) 
- Limited (all customers cannot be served)

Parameters:
- $D$: random demand high fare rooms
- Maximize expected revenues by controlling the number of low fare rooms you sell




#line(length: 100%)

== SC Contracting

Double Marginalization Problem: Each firm makes decisions based on their own margin, not the supply chain's margin

#example([Sports Obermeyer])[

  *Wholesale contract*

  #let c = 100
  #let w = 175
  #let p = 250
  #let s = 75
  #let g = 0

  #let mean_D = 1000
  #let sd_D = 300
  
  Obermeyer:
  - Production cost ($c$): #c
  - Revenue ($w$): #w
  SkiPro
  - Retail price ($p$): #p
  - Slavage value ($s$): #s

  Demand: $D tilde N(#mean_D, #sd_D)$

  SKI PRO orders the optimal (profit maximizing) quantity:

  #let cu = p - w
  #let co = w + g - s
  #let cr = cu / (cu + co)

  $
    c_u = #cu \
    c_o = #co \
    "cr" = #calc.round(cr, digits: 4)
  $

  #let Q = norm.ppf(cr, mean: mean_D, std_dev: sd_D)

  #let z = (Q - mean_D) / sd_D
  #let L = norm.pdf(z) - z * (1 - norm.cdf(z))
  #let e_short = sd_D * L
  #let e_sales = mean_D - e_short
  #let e_leftover = Q - e_sales
  #let e_fill = e_sales / mean_D
  #let e_instock = norm.cdf(z)
  #let e_stockout = 1 - norm.cdf(z)

  $
    Q = #calc.round(Q, digits: 2)
  $

  SKI PRO's Expected Profit:
  
  #let e_profit_retailer = p * e_sales + s * e_leftover - g * e_short - w * Q

  $
    pi_R (Q; w) = p E["Sold"] + s E["Left"] - g E["Short"] - w Q = #calc.round(e_profit_retailer, digits: 2)
  $

  Obermeyer's profit:

  #let e_profit_supplier = (w - c) * Q

  $
    pi_S (w; Q(w)) = (w - c) Q = #calc.round(e_profit_supplier, digits: 2)
  $

  Supply Chain expected profit:

  #let e_profit_sc = e_profit_supplier + e_profit_retailer

  $
    pi_"SC" = (w, Q) = pi_R + pi_S = #calc.round(e_profit_sc, digits: 2)
  $

  *Coordinated Supply Chain*

  Optimal quantity

  #let cu = p - c + g
  #let co = c - s
  #let cr = cu / (cu + co)
  #let Q = norm.ppf(cr, mean: mean_D, std_dev: sd_D)

  #let z = (Q - mean_D) / sd_D
  #let L = norm.pdf(z) - z * (1 - norm.cdf(z))
  #let e_short = sd_D * L
  #let e_sales = mean_D - e_short
  #let e_leftover = Q - e_sales

  $
    c_u = p - c + g = #cu \
    c_o = c - s = #co \
    "cr" = #calc.round(cr, digits: 2) \
    Q^* = #calc.round(Q, digits: 2) \
  $

  #let e_profit_sc = p * e_sales + s * e_leftover - g * e_short - c * Q

  $
    pi_"SC" (Q; w) = p E["Sold"] + s E["Left"] - g E["Short"] - c Q = #calc.round(e_profit_sc, digits: 2)
  $
]

*Solution to Double Marginalization*

#let mu_D = 1000
#let sigma_D = 300

#let p = 250
#let w = 175
#let s = 75
#let r = 5
#let c = 100

- $p$: sell price
- $w$: wholesale price
- $b$: buyback price
- $s$: salvage value
- $r$: return cost

Share Risk / Buyback Contract

Obermeyer buys back unslod at $\$b$ / unit

SkiPro incurs cost $r$ to ship jackets back

Conditions:
- $b lt w$ so that returning doesn't make a profit
- $b gt s + r$ so that return is preferable to salvage

Assume Obermeyer sets $w = 175$, what is $b$?

#diagram(
  node(
    (0,0), 
    [Manufacturer], 
    width: 25mm,
    height: 10mm,
    fill: gray.lighten(60%),
    stroke: 1pt + gray.darken(20%),
    corner-radius: 5pt,
    radius: 2em,
    name: <M>,
  ),
  node(
    (2,0), 
    [Manufacturer\ DC], 
    width: 25mm,
    height: 10mm,
    fill: gray.lighten(60%),
    stroke: 1pt + gray.darken(20%),
    corner-radius: 5pt,
    radius: 2em,
    name: <MDC>,
  ),
  node(
    (4,-.75), 
    [$w$], 
    radius: 2em,
    name: <Inv2>,
  ),
  node(
    (4,0), 
    [Retail\ DC], 
    width: 25mm,
    height: 10mm,
    fill: gray.lighten(60%),
    stroke: 1pt + gray.darken(20%),
    corner-radius: 5pt,
    radius: 2em,
    name: <RDC>,
  ),
  node(
    (4,0.75), 
    [$b$], 
    radius: 2em,
    name: <Inv2>,
  ),
  node(
    (6,0), 
    [Retail\ Store], 
    width: 25mm,
    height: 10mm,
    fill: gray.lighten(60%),
    stroke: 1pt + gray.darken(20%),
    corner-radius: 5pt,
    radius: 2em,
    name: <RS>,
  ),
  node(
    (6.75,0), 
    [
      - $p$
      - $s$
      - $r$
    ], 
    corner-radius: 5pt,
    radius: 2em,
    name: <Inv>,
  ),

  edge(<M>, <MDC>, "-|>"),
  edge(<MDC>, <RDC>, "-|>", [], bend: 20deg),
  edge(<MDC>, <RDC>, "<|-", [], bend: -20deg),
  
  edge(<RDC>, <RS>, "-|>", [], bend: 20deg),
  edge(<RDC>, <RS>, "<|-", [], bend: -20deg),
)

#let cu = p - w
#let co(b) = w - b + r

Obermeyer chooses $b$ to make SkiPro's critical ratio equal to the integrated supply chain's critical ratio

#let b = p + r - (p - w) * (p - s) / (p - c)

$
  (p - w) / (p - b + r) = (p - c) / (p - s) quad arrow.double quad b = p + r - (p - w) (p - s) / (p - c) = #calc.round(b, digits: 2)
$

#let z = norm.ppf((p - c) / (p - s))
#let Q = mu_D + z * sigma_D
#let L = sigma_D * (z * norm.cdf(z) + norm.pdf(z))
#let S = Q - L

#let buyback(w) = p + r - (p - w) * (p - s) / (p - c)
#let sc-profit = (p - c) * Q - (p - s) * L
#let retailer(w) = p * S - w * Q + (buyback(w) - r) * L
#let supplier(w) = sc-profit - retailer(w)

#let k = (p - s) / (p - c)
#let w-lo-feasible = c
#let w-hi-feasible = p - r / (k - 1)

#let w0 = 175
#let z0 = norm.ppf((p - w0) / (p - s))
#let Q0 = mu_D + z0 * sigma_D
#let L0 = sigma_D * (z0 * norm.cdf(z0) + norm.pdf(z0))
#let R0 = p * (Q0 - L0) - w0 * Q0 + s * L0
#let U0 = (w0 - c) * Q0

#let w-lo = p - (p - c) * (sc-profit - U0) / sc-profit
#let w-hi = p - (p - c) * R0 / sc-profit

#let w-mid = (w-lo + w-hi) / 2
#let gain = sc-profit - R0 - U0
#let fmt(x) = str(calc.round(x, digits: 1))

#let ws = range(100, 221, step: 15)

// #lq.diagram(
//   width: 14cm, height: 8cm,
//   xlabel: [Wholesale price $w$],
//   ylabel: [Expected profit],
//   ylim: (0, 160000),
//   xaxis: (ticks: ws),
//   legend: (position: left + bottom),

//   lq.fill-between(
//     (w-lo, w-hi), (0, 0), y2: (160000, 160000),
//     fill: gray.transparentize(80%)
    
// #let w-mid = (w-lo + w-hi) / 2
// #let gain = sc-profit - R0 - U0
// #let fmt(x) = str(calc.round(x, digits: 1))

// #let ws = range(100, 221, step: 15)

// #lq.diagram(
//   width: 14cm, height: 8cm,
//   title: [Buyback contract: coordination and win-win range],
//   xlabel: [Wholesale price $w$],
//   ylabel: [Expected profit],
//   ylim: (0, 160000),
//   xaxis: (ticks: ws),
//   legend: (position: left + bottom),

//   // Win-win range (drawn first, so it sits behind the lines)
//   lq.fill-between(
//     (w-lo, w-hi), (0, 0), y2: (160000, 160000),
//     fill: gray.transparentize(80%), stroke: none,
//     label: [Win-win range],
//   ),

//   // Coordinated contract
//   lq.plot(ws, ws.map(retailer), mark: none, color: blue, stroke: 1.5pt, label: [Retailer]),
//   lq.plot(ws, ws.map(supplier), mark: none, color: red, stroke: 1.5pt, label: [Supplier]),
//   lq.plot(ws, ws.map(_ => sc-profit), mark: none, color: green.darken(20%), stroke: 1.5pt, label: [Supply chain]),

//   // Baseline profits without buyback (at w0)
//   lq.hlines(R0, stroke: (paint: blue, dash: "dashed"), label: [Retailer, no buyback]),
//   lq.hlines(U0, stroke: (paint: red, dash: "dashed"), label: [Supplier, no buyback]),

//   // Fair split point
//   lq.scatter((w-mid, w-mid), (retailer(w-mid), supplier(w-mid)), mark: "o", color: black),

//   // Secondary x-axis showing the matching buyback price b
//   lq.xaxis(
//     position: top,
//     label: [Matching buyback price $b$],
//     functions: (buyback, b => p - (p - b + r) * (p - c) / (p - s)),
//   ),
// )

// #table(
//   columns: 3,
//   align: (left, right, right),
//   table.header([], [$w$], [$b$]),
//   [Feasible range], [#fmt(w-lo-feasible) – #fmt(w-hi-feasible)], [#fmt(buyback(w-lo-feasible)) – #fmt(buyback(w-hi-feasible))],
//   [Win-win range], [#fmt(w-lo) – #fmt(w-hi)], [#fmt(buyback(w-lo)) – #fmt(buyback(w-hi))],
//   [Fair split (midpoint)], [#fmt(w-mid)], [#fmt(buyback(w-mid))],
// )

// Total gain from coordination: #calc.round(gain) (#calc.round(gain / 2) each at the midpoint).%), stroke: none,
//     label: [Win-win range],
//   ),

//   lq.plot(ws, ws.map(retailer), mark: none, color: blue, stroke: 1.5pt, label: [Retailer]),
//   lq.plot(ws, ws.map(supplier), mark: none, color: red, stroke: 1.5pt, label: [Supplier]),
//   lq.plot(ws, ws.map(_ => sc-profit), mark: none, color: green.darken(20%), stroke: 1.5pt, label: [Supply chain]),

//   lq.hlines(R0, stroke: (paint: blue, dash: "dashed"), label: [Retailer, no buyback]),
//   lq.hlines(U0, stroke: (paint: red, dash: "dashed"), label: [Supplier, no buyback]),

//   lq.scatter((w-mid, w-mid), (retailer(w-mid), supplier(w-mid)), mark: "o", color: black),

//   lq.xaxis(
//     position: top,
//     label: [Matching buyback price $b$],
//     functions: (buyback, b => p - (p - b + r) * (p - c) / (p - s)),
//   ),
// )

#table(
  columns: 3,
  align: (left, right, right),
  table.header([], [$w$], [$b$]),
  [Feasible range], [#fmt(w-lo-feasible) - #fmt(w-hi-feasible)], [#fmt(buyback(w-lo-feasible)) - #fmt(buyback(w-hi-feasible))],
  [Win-win range], [#fmt(w-lo) - #fmt(w-hi)], [#fmt(buyback(w-lo)) - #fmt(buyback(w-hi))],
  [Fair split (midpoint)], [#fmt(w-mid)], [#fmt(buyback(w-mid))],
)

Total gain from coordination: #calc.round(gain) (#calc.round(gain / 2) each at the midpoint).




#line(length: 100%)



$
  pi(Q) = underbrace((p - c) mu, "Perfect Information") - underbrace(E[(p + g - c) (D - Q)^+ + (c - s) (Q - D)^+], "Cost of Uncertainty (C(Q)")
$

$
  C(Q) = A(c_u, c_o) dot sigma
$

$c_u$ and $c_o$ are given, only $sigma$ can be affected (increasing forecast accuracy)

$
  min C(Q) = E[c_u (D - Q)^+ + c_o (Q - D)^+]
$

$
  (dif C(Q)) / (dif Q) 
  &= c_u (-1) Pr(D gt Q) + c_o (+1) Pr(D lt.eq Q) = 0 \
  &= -c_u (1 - Pr(D lt.eq Q)) + c_o Pr(D lt.eq Q) = 0 
  quad arrow.double quad
  Pr(D lt.eq Q^*) = c_u / (c_u + c_o)

$

#let D = 30
#let Q = 20
#let x = lq.linspace(0, 50)

#let dq(Q) = calc.max(0, (D - Q))
#let qd(Q) = calc.max(0, (Q - D))

#let y_dq = x.map(dq)
#let y_qd = x.map(qd)

#lq.diagram(
  width: 8cm,
  height: 6cm,
  xlabel: [$Q$],
  lq.plot(x, y_dq, mark: none, stroke: 1.5pt, label: [$(D - Q)^+$]),
  lq.plot(x, y_qd, mark: none, stroke: 1.5pt, label: [$(Q - D)^+$]),
  lq.vlines(D, stroke: red + 1.5pt, label: [$D$])
)

*Uniform Dist*

#let p = 2
#let c = 1
#let s = 0.5
#let g = 0
#let mean_D = 0
#let sd_D = 100

#let cu = p + g - c
#let co = c - s

#let cr = cu / (cu + co)

#let Q = uniform.ppf(cr, min: 0, max: 100)

$
  Pr(D lt.eq Q^*) = #calc.round(cr, digits: 2) = "cr"
$

$
  F(Q^*) = (Q^* - a) / (b - a) = "cr" quad quad D tilde U[0, 100]
$

$
  Q^* = #calc.round(Q, digits: 0)
$

*Normal*

#let mean_D = 100
#let sd_D = 20
#let cr = 0.4

#let z = norm.ppf(cr)
#let Q = norm.ppf(cr, mean: mean_D, std_dev: sd_D)

$
  P(D lt.eq Q^*) = 0.4
$

#let z = (Q - mean_D) / sd_D
#let Q = mean_D + z * sd_D

#let L = norm.pdf(z) - z * (1 - norm.cdf(z))
#let e_short = sd_D * L
#let e_sales = mean_D - e_short
#let e_fill = e_sales / mean_D
#let e_leftover = Q - e_sales

$
  z = (Q - mu) / sigma = #calc.round(z, digits: 2)
$

$
  Q = mu + z("cr") dot sigma = #calc.round(Q, digits: 2)
$

$
  L(z) = #calc.round(L, digits: 2)
$

#let e_profit = p * e_sales + s * e_leftover - g * e_short - c * Q

$
  E["Short"] &= sigma L = #calc.round(e_short, digits: 2) \
  E["Sales"] &= mu - E["Short"] = #calc.round(e_sales, digits: 2) \
  E["Fill"] &= E["Sales"] / mu = #calc.round(e_fill, digits: 4) \
  E["Profit"] 
  &= p E["Sold"] + s E["Leftover"] - g E["Short"] - c Q \
  &= #calc.round(e_profit, digits: 2) \
$

*If fill-rate target is given ($F^b$), what is the Q?*

*Poisson*

#table(
  columns: 4,
  inset: 1em,
  [$x$], [$f(x)$], [$F(x)$], [$E["Loss"]$], 
)

$
  E["Loss"] = lambda (1 - F(Q - 1)) - Q (1 - F(Q))
$


#line(length: 100%)

CDF:
- Look at y axis for critical ratios
- Look at corresponding x axis quantity
- That is the optimal Q

CR Plot:
- Qth unit ordered v. Expected Gain / Loss plot
- Expected Gain & Expected loss 
- intersection is the CR

Critical Ratio
- $c$: cost per unit
- $p$: price per unit
- $s$: salvage price per unit leftover 
- $g$: goodwill (penalty) per unit short
- $c_u$: Underage

$
  c_u = p + g - c
$

- $c_o$: Overage

$
  c_o = c - s
$

- $"cr"$: Critical Ratio

$
  "cr" = c_u / (c_u + c_o)
$

$
  Pi (Q) = E[p dot min(D, Q) + s (Q - D)^+ - g (D - Q)^+] - c Q
$

Where:
- $(a)^+ = max(0, a)$
- $E$: expectation because $D$ is a random variable


$
  Pi (Q) 
  &= E[p dot D - p (D - Q)^+ + s(Q - D)^+ - g(D - Q)^+ - c D + c (D - Q)^+ - c (Q - D)^+] \
  &= E[(p - c) D - {(p + g - c) (D - Q)^+ + (c - s) (Q - D)^+}] \
  &= (p - c) mu - E[(p + g - c) (D - Q)^+ + (c - s) (Q - D)^+}]
$

$
  underbrace((p - c) mu, "profit with\nperfect information") = underbrace(E \[overbrace((p + g - c), c_u) (D - Q)^+ + overbrace((c - s), c_o) (Q - D)^+], "cost of\nuncertainty")
$

$
  min C(Q) = E[c_u (D - Q)^+ + c_o (Q - D)^+]
$

$
  (dif C(Q)) / (dif Q) 
  &= c_u (-1) Pr(D gt Q) + c_o (+1) Pr(D lt.eq Q) \
  &= - c_u (1 - Pr(D lt.eq Q)) + c_o Pr(D lt.eq Q)) \
$

Where:
- $Pr(D lt.eq Q) = F(x)$ (CDF)

$
  - c_u (1 - Pr(D lt.eq Q)) + c_o Pr(D lt.eq Q)) = 0 quad arrow.double quad Pr(D lt.eq Q^*) = c_u / (c_u + c_o)
$

 Plot:
 - Production quantity v. Marginal loss/gain
 - 2 curves:
  - Expected overage (marginal)
  - Expected underage (marginal)
- Their crossing is the optimal production quantity

$
  Pi(Q) = p E["sold"] + s E["leftover"] - g E["short"] - c Q
$



*Example*: Oneil's Hammer 3/2 Economics 

#let mu_D = 3192
#let sigma_D = 1181

$
  D tilde N(#mu_D, #sigma_D)
$


#let p = 190
#let c = 110
#let s = 90

#let cu = p - c
#let co = c - s

#let cr = cu / (cu + co)

- $p$: #p
- $c$: #c
- $s$: #s

- $c_u$: $p - c = #cu$
- $c_o$: $c - s = #co$

$
  "cr" = c_u / (c_u + c_o)
$

$
  "cr" = Pr(D lt.eq Q^*) = #cr
$

```py
from scipy.stats import norm

mu = 3192
sigma = 1181

Q = norm.ppf(cr, loc=mu, scale=sigma)
```


Slide 13:
$
  c_o times F(Q) = c_u times (1 - F(Q)) \
  F(Q^*) = Pr(D lt.eq Q^*) = c_u / (c_u + c_o) = () / ()
$

$
  Q^* = mu + z(alpha) dot sigma
$

Slide 17

1. In-stock Probability (Type I - service Level)
Probability all demand is satisfied

What is the in stock probability if the order is $Q$

$
  z = (Q - mu) / sigma \
  Pr(z)
$

We want 99% in-stock, what order quantity?

$
  
$

2. Expected Loss Sales (Shortage)

Slide 24

$
  E["short"] = E[(D - Q)^+] = integral
$

Normal Loss Function (Slide 25)

$
  E["short"] = sigma dot L(z)
$

$
  E["sales"] = E[min(D, Q)] = E[D - (D - Q)^+] = mu - E["short"]
$

$
  E["leftover"] = Q - E["sales"] = Q - mu + E["short"]
$

$
  Pi(Q) = p E["sold"] + s E["leftover"] - g E["short"] - c Q
$

3. Fill Rate (Type II - Service Level)

Fraction of demand that is fulfilled

$
  "Fill Rate" = E["sales"] / mu = 1 - E["short"] / mu
$

Poisson

#table(
  columns: 4,
  [$x$], [$P(D = x)$], [$"CDF"$], [$E["Lost"]$], 
  [], [], [], [], 
)


E["Lost"] = E["Short"] ?


- Demand random
- Single selling season
- Single opportunity to procure at the start of the season

== *Double Marginalization* Problem

Each firm makes descision based on their own margin, not supply chain margin

Supplier:
- c: cost
- w: transfer price
Margin_s = w - c


Retailer:
- w: transfer price
- r: unit revenue
Margin_r = r - w

=== Case Study: Ski Jacket

#let c = 100
#let w = 175

#let p = 250
#let s = 75

#let g = 0

#let mu_D = 1000
#let sigma_D = 300

- Cost $c$: #c
- Transfer Price $w$: #w
- Sell price $p$: #p
- Salvage value $s$: #s
- Goodwill $g$: #g
- Demand: $N tilde (#mu_D, #sigma_D)$

#let cu = p - w + g
#let co = w - s
#let cr = cu / (cu + co)
#let cr = calc.round(cr, digits: 4)

#let Q = norm.ppf(cr, mean: mu_D, std_dev: sigma_D)
#let Q = calc.round(Q, digits: 2)

$
  c_u = p - w = #cu \
  c_o = w - s = #co \
$

$
  "cr" = c_u / (c_u - c_o) = #cr
$

$
  Q^* = F^(-1)(#cr) = #Q
$

SkiPro E[Profit]

$
  pi_r(Q; w) = p E["Sold"] + s E["Left"] + g E["Short"] - c Q = 
$

Obermeyer E[Profit]

$
  pi_s (w; Q(w)) = (w - c) Q = 
$

Supply Chain E[Profit]

$
  pi_"sc" = pi_r + pi_s = 
$

But if we integrate (coordinated SC):

$
  c_u = p - c + g = 250 - 100 = 150 \
  c_o = c - s = 100 - 75 \
  cr = 150 / 175 = 0.8571 \
  Q = F^(-1)(0.8571) = 1320 quad (39.5% "increase") \
  pi_"SC" = 138154 quad (10.22% "increase")
$

Pie chart (Integrated SC v. double marginalization impact)

==== Buyback contract $r$

$
  b - r gt s \
  b lt w
$

$
  c_u - p - w = 250 - 175 = 75 \
  c_o = w - b + r = 180 - b \
$

$
  (p - w) / (p - b + r) = (p - c) /  (p - s) ("integrated SC") quad arrow.double quad b = p + r - (p - w) (p - s) / (p - c) = 167.5
$

==== Revenue Management with Capacity Controls

Matching supply to demand when supply is fixed

- Adjusting supply is not possible
- Customers can be segmented 
- Number of ...

- $Q$: Protection level
- $D lt Q$: protect too many rooms (over protect) Rooms are empty which could have been sold to low fare travellers.
- $D gt Q$: protect too few rooms (under protect). Some rooms could have been sold at the high fare instead of low fare.

== Safety Factor

The safety factor $k$ (often written $z$) is how many standard deviations of lead-time demand your reorder point sits above the expected lead-time demand.

$
  k = (s - mu_L) / sigma_L
$

Rearrange:

$
  s = mu_L + underbrace(k sigma_L, "safety stock")
$