#import "@preview/lilaq:0.6.0" as lq
#import "@local/tystats:0.1.0": norm, uniform
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)
#set table(stroke: 0.5pt + gray, inset: 5pt)
#show table.cell.where(y: 0): strong

#let result(content) = box(stroke: blue, fill: blue.transparentize(75%), inset: 0.5em, radius: 0.25em)[#content]

#let r(d, digits: 3) = calc.round(d, digits: digits)

#let mean(X) = X.sum() / X.len()

#let sd(X) = {
  let m = mean(X)
  calc.sqrt(X.map(x => calc.pow(x - m, 2)).sum() / (X.len() - 1))
}

#let r(x, d: 1) = {
  let parts = str(calc.round(calc.abs(x), digits: d)).split(".")
  let int = parts.at(0)
  let frac = if parts.len() > 1 { parts.at(1) } else { "" }
  let n = int.len()
  let grouped = int.clusters().enumerate()
    .map(((i, ch)) => if i > 0 and calc.rem(n - i, 3) == 0 { "," + ch } else { ch })
    .join()
  let sign = if x < 0 { "-" } else { "" }
  if d > 0 { sign + grouped + "." + frac + "0" * (d - frac.len()) } else { sign + grouped }
}

#let money(x) = [\$#r(x)]

#h(1fr) Vladimir Borel

= Problem 1: Location Pooling

#let markets = ("Atlanta", "Boston", "Chicago", "Dallas", "LA")
#let inbound = (Atlanta: 12, Boston: 11.5, Chicago: 11, Dallas: 9, LA: 7)

#let central-out = (
  Atlanta: (13, 14, 14, 15, 17),
  Boston:  (14, 13,  8, 15, 17),
  Chicago: (14,  8, 13, 15, 16),
  Dallas:  (15, 15, 15, 13,  8),
  LA:      (17, 17, 16,  8, 13),
)

#let hub = "LA"

#let plant-style = (fill: rgb("#dbe7f5"), stroke: rgb("#2f5d8a"), corner-radius: 3pt)
#let wh-style    = (fill: rgb("#fdf1d6"), stroke: rgb("#b07d12"), corner-radius: 3pt)
#let mkt-style   = (fill: rgb("#e6f2e2"), stroke: rgb("#3c7a32"), shape: fletcher.shapes.pill)
#let money(x) = text(fill: rgb("#555"))[\$#r(x)]

#align(center)[
  #diagram(
    spacing: (22mm, 7mm),
    node-inset: 5pt,
    node((0, 2), align(center)[*Plant*\ San Jose, CA], name: <plant>, ..plant-style),
    ..markets.enumerate().map(((i, m)) => (
      node((1, i), [WH #m], name: label("wh" + str(i)), ..wh-style),
      node((2, i), [Market #m], name: label("m" + str(i)), ..mkt-style),
      edge(<plant>, label("wh" + str(i)), "-|>", money(inbound.at(m)), label-side: center, label-pos: 0.5),
      edge(label("wh" + str(i)), label("m" + str(i)), "-|>", money(13), label-side: center, label-pos: 0.5),
    )).flatten(),
    node(enclose: ((1, 0), (1, 4)), stroke: (dash: "dashed", paint: luma(150)), inset: 1em, corner-radius: 4pt),
  )


  #let row = central-out.at(hub)
  #diagram(
    spacing: (22mm, 7mm),
    node-inset: 5pt,
    node((0, 2), align(center)[*Plant*\ San Jose, CA], name: <plant>, ..plant-style),
    node((1, 2), align(center)[*Central WH*\ #hub], name: <hub>, ..(wh-style + (stroke: 1.2pt + rgb("#b07d12")))),
    edge(<plant>, <hub>, "-|>", money(inbound.at(hub)), stroke: 1.2pt, label-side: center, label-pos: 0.5),
    ..markets.enumerate().map(((i, m)) => (
      node((2, i), [Market #m], name: label("m" + str(i)), ..mkt-style),
      edge(<hub>, label("m" + str(i)), "-|>", money(row.at(i)), label-side: center, label-pos: 0.5),
    )).flatten(),
  )
]

// ########################################################
// ########################################################

#let S = 5500     // ordering cost per order
#let H = 1.25     // holding cost per unit per week
#let L = 2        // lead time (weeks)
#let CSL-D = 0.90 // current service level
#let CSL-C = 0.97 // target service level

#let D = (
  Atlanta: (33, 45, 37, 38, 55, 30, 18, 58, 47, 37, 23, 55),
  Boston:  (26, 35, 41, 40, 46, 48, 55, 18, 62, 44, 30, 45),
  Chicago: (44, 34, 22, 55, 48, 72, 62, 28, 27, 95, 35, 45),
  Dallas:  (27, 42, 35, 40, 51, 64, 70, 65, 55, 43, 38, 47),
  LA:      (32, 43, 54, 40, 46, 74, 40, 35, 45, 38, 48, 56),
)

// Table 2: (inbound, outbound) per unit, current system
#let T-cur = (
  Atlanta: (12, 13), Boston: (11.5, 13), Chicago: (11, 13), Dallas: (9, 13), LA: (7, 13),
)

// Table 3: outbound per unit from central WH (row) to market (column, same order as D)
#let T-cen = (
  Atlanta: (13, 14, 14, 15, 17),
  Boston:  (14, 13,  8, 15, 17),
  Chicago: (14,  8, 13, 15, 16),
  Dallas:  (15, 15, 15, 13,  8),
  LA:      (17, 17, 16,  8, 13),
)

// ########################################################
// ########################################################

#let cities = D.keys()
#let mus = D.values().map(mean)
#let sds = D.values().map(sd)
#let z-D = norm.ppf(CSL-D)
#let z-C = norm.ppf(CSL-C)

#let eoq(mu) = calc.sqrt(2 * mu * S / H)

// Weekly cost of one warehouse
#let cost(mu, sigma, z, transport) = {
  let Q = eoq(mu)
  let SS = z * calc.sqrt(L) * sigma
  let order = S * mu / Q
  let hold = H * (Q / 2 + SS)
  (Q: Q, SS: SS, order: order, hold: hold, transport: transport,
   total: order + hold + transport)
}

// Decentralized: one warehouse per market
#let dec = cities.zip(mus, sds).map(((w, m, s)) => {
  let (inb, out) = T-cur.at(w)
  (name: w, ..cost(m, s, z-D, (inb + out) * m))
})
#let dec-sum(key) = dec.map(c => c.at(key)).sum()

// Centralized: pooled demand (independent)
#let mu-C = mus.sum()
#let sigma-C = calc.sqrt(sds.map(s => s * s).sum())

#let cen = cities.map(w => {
  let inb = T-cur.at(w).at(0) * mu-C
  let out = T-cen.at(w).zip(mus).map(((t, m)) => t * m).sum()
  (name: w, inb: inb, out: out, ..cost(mu-C, sigma-C, z-C, inb + out))
}).sorted(key: c => c.total)

#let best = cen.first()

// ########################################################
// ########################################################

== (a) Effect of correlated demand

$ sigma^C = sqrt(sum_i sigma_i^2 + sum_(i != j) rho_(i j) sigma_i sigma_j) $

- Demands move together $=>$ $rho_(i j) > 0$.
- Positive $rho$ makes $sigma^C$ larger
- Highs and lows no longer cancel out $=>$ less risk pooling
- Smaller safety-stock savings $=>$ centralization less attractive
- Extreme case $rho = 1$: $sigma^C = sum_i sigma_i$, no safety-stock benefit

== (b) Centralized vs. decentralized for Product A

=== Demand per market

- Normal, independent demand

#table(
  columns: 3,
  align: (left, right, right),
  [Market], [$mu_i$ (units/week)], [$sigma_i$],
  ..cities.zip(mus, sds).map(((w, m, s)) => ([#w], [#r(m, d: 2)], [#r(s, d: 2)])).flatten(),
  table.hline(),
  [*Total*], [*#r(mu-C, d: 2)*], [],
)

=== Continuous review (weekly)

$ Q^* = sqrt((2 mu S) / H) wide
  "SS" = z sqrt(L) sigma wide
  "Cost" = underbrace(S mu / Q^*, "ordering")
         + underbrace(H (Q^* / 2 + "SS"), "holding")
         + underbrace(sum "units" times "rate", "transport") $

- $S = \$#r(S, d: 0)$
- $H = \$#r(H, d: 2)$/unit/week
- $L = #L$ week
- Current: CSL $= #(CSL-D * 100)%$ $=> z = #r(z-D, d: 3)$
- Central: CSL $= #(CSL-C * 100)%$ $=> z = #r(z-C, d: 3)$

=== Decentralized (current system)

- Each market served by its own warehouse
- Transport = (inbound + outbound) $times mu_i$

#table(
  columns: 7,
  align: (left,) + (right,) * 6,
  [Warehouse], [$Q^*$], [SS], [Ordering], [Holding], [Transport], [Total],
  ..dec.map(c => (
    [#c.name], [#r(c.Q)], [#r(c.SS)],
    money(c.order), money(c.hold), money(c.transport), money(c.total),
  )).flatten(),
  table.hline(),
  [*Total*], [], [*#r(dec-sum("SS"))*],
  [*#money(dec-sum("order"))*], [*#money(dec-sum("hold"))*],
  [*#money(dec-sum("transport"))*], [*#money(dec-sum("total"))*],
)

=== Centralized (pooled demand)

$ 
  mu^C = sum_i mu_i = #r(mu-C, d: 2) wide sigma^C = sqrt(sum_i sigma_i^2) = #r(sigma-C, d: 2) 
$

- Independent demand $=>$ no covariance term
- $Q^C = #r(best.Q)$, $"SS"^C = #r(best.SS)$ (vs. #r(dec-sum("SS")) decentralized)
- Ordering and holding are the same for every location

=== Centralized cost by location

- Inbound = Table 2 inbound rate $times mu^C$
- Outbound = $sum_i$ Table 3 rate $times mu_i$

#table(
  columns: 7,
  align: (left,) + (right,) * 6,
  [Central WH], [Ordering], [Holding], [Inbound], [Outbound], [Total], [Savings],
  ..cen.map(c => {
    let hl(x) = if c.name == best.name [*#x*] else [#x]
    (
      hl(c.name), money(c.order), money(c.hold), money(c.inb), money(c.out),
      hl(money(c.total)), money(dec-sum("total") - c.total),
    )
  }).flatten(),
  table.hline(),
  [_Decentralized_], money(dec-sum("order")), money(dec-sum("hold")),
  table.cell(colspan: 2, align: center)[#money(dec-sum("transport"))],
  money(dec-sum("total")), [—],
)

=== Recommendation

- *Centralize at #best.name*: #money(best.total)/week vs. #money(dec-sum("total"))/week
- Saves #money(dec-sum("total") - best.total)/week
  (#r(100 * (1 - best.total / dec-sum("total")))%), even at the higher 97% CSL
- Every central option beats the current system
- #best.name wins on inbound cost (closest to San Jose)

#[

= Problem 2: Delayed Differentiation

#let D = 100
#let sd = 65
#let L = 2 // weeks
#let T = 1 // weeks
#let n = 2

== *(a)*

#let CSL = 0.97

#let D_LT = D * (L + T)
#let sd_LT = sd * calc.sqrt(L + T)

#let z = norm.ppf(CSL)
#let S = D_LT + z * sd_LT

#r(S)

#let loss = norm.pdf(z) - z * (1 - norm.cdf(z))
#let e_backorders = sd_LT * loss

#let SS = S - D_LT + e_backorders

#r(SS)

== *(b)*

#let CSL = 0.97

- Without postponement

#let SS_np = n * norm.ppf(CSL) * calc.sqrt(L) * sd

#r(SS_np)

- With postponement

#let sd_pooled = calc.sqrt(2 * sd)
#let SS_p = norm.ppf(CSL) * calc.sqrt(L) * sd_pooled

#r(SS_p)

== *(c)*

  
]

#[

= Problem 2: Delayed Differentiation

#let mean = 100   // weekly demand per color
#let sd = 65
#let L = 2      // lead time (weeks)
#let T = 1
#let CSL = 0.97
#let z = norm.ppf(CSL)

// standard normal loss function
#let loss(z) = norm.pdf(z) - z * (1 - norm.cdf(z))

// Order-up-to model, weekly review: protection period = L + 1
#let oh(mu, sigma) = {
  let mu-p = mu * (L + 1)
  let sd-p = sigma * calc.sqrt(L + 1)
  let S = mu-p + z * sd-p
  let EB = sd-p * loss(z)
  (mu-p: mu-p, sd-p: sd-p, S: S, EB: EB, OH: S - mu-p + EB)
}

$ 
  S = mu_(L+1) + z sigma_(L+1) wide \
  E["on-hand"] = S - mu_(L+1) + sigma_(L+1) L(z) 
$

- $T = #T$
- $L = #L$  
- $L + T = #(L + T)$
- $z = #r(z, d: 3)$
- $L(z) = #r(loss(z), d: 4)$

== (a) Assembled desks

#let c = oh(mean, sd)

- Per color: 
  - $mu_(L+1) = #r(c.mu-p, d: 0)$
  - $sigma_(L+1) = 65 sqrt(3) = #r(c.sd-p, d: 2)$
- $S = #r(c.S, d: 2)$
- $E["back"] = sigma_(L+T) L(z) = #r(c.EB, d: 2)$
- $E["on-hand"] = S - mu_(L+T) + E["backorders"] = #r(c.OH, d: 2)$ per color

$ 
  E["on-hand all tops"] 
  &= 2 times E["onhand"] \
  &= 2 times #r(c.OH, d: 2) \
  &= #result[#r(2 * c.OH, d: 2)] 
$

== (b) Black tops

$
  E["on-hand black tops"] 
  &= E["onhand"] \
  &= #result[#r(c.OH, d: 2)]
$

== (c) Gray bases

#let b = oh(2 * mean, calc.sqrt(2) * sd)

- Pooled demand for bases for both colors
- $mu = 2 times 100 = 200$/week
- $sigma = sqrt(2) times 65 = #r(calc.sqrt(2) * sd, d: 2)$ (independent)
- $mu_(L+1) = #r(b.mu-p, d: 0)$
- $sigma_(L+1) = #r(b.sd-p, d: 2)$
- $S = #r(b.S, d: 2)$
- $E["on-hand bases"] = #r(b.OH, d: 2)$
- Original system: one base for every desk ($#r(2 * c.OH, d: 2)$ bases)


Reduction: 

- $#r(2 * c.OH, d: 2) - #r(b.OH, d: 2) = #result[#r(2 * c.OH - b.OH, d: 2)]$ 
- (#r(100 * (1 - b.OH / (2 * c.OH)))% less)

Safety stock scales with $sigma$, and pooling cuts it by a factor of $1 / sqrt(2)$

]
