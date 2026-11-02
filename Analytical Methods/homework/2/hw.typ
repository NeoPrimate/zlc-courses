#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set text(font: "Helvetica", size: 8pt)

#show table: it => align(center, it)

#set math.mat(delim: "[")
#set math.vec(delim: "[")

#show raw.where(block: true): it => block(
  width: 100%,
  fill: luma(248),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: (x: 10pt, y: 8pt),
)[
  #show raw.line: line => {
    box(width: 1.5em, align(right, text(fill: luma(150))[#line.number]))
    h(1em)
    line.body
  }
  #it
]

#let mc(x) = text(fill: red, x)

#let fmt(x, digits: 0) = {
  let r = calc.round(x, digits: digits)
  let neg = r < 0
  let s = str(calc.abs(r))
  let parts = s.split(".")
  let int = parts.at(0)
  let n = int.len()
  let out = ""
  for (k, ch) in int.clusters().enumerate() {
    if k > 0 and calc.rem(n - k, 3) == 0 { out += "," }
    out += ch
  }
  if digits > 0 {
    let frac = if parts.len() > 1 { parts.at(1) } else { "" }
    while frac.len() < digits { frac += "0" }
    out += "." + frac
  }
  if neg { "-" + out } else { out }
}

#h(1fr) Maria \
#h(1fr) Vladimir Borel \

= Problem 1

*Sets*

- $L = {1, dots, 9}$: set of *delivery locations*
- $R = {1, dots, 10}$: set of *routes*

*Indices*

- $l in L$
- $r in R$

*Parameters*

- $t_r$: total duration of route $r$

$
  T = vec(
    6,
    4,
    7,
    5,
    4,
    6,
    5,
    3,
    7,
    6,
  )
$

- $p_(l r) = cases(
  1 #[if location $l$ is covered by route $r$],
  0 #[otherwise]
)$

$
  P = mat(
    1, 0, 0, 0, 1, 0, 0, 0, 1, 0; 
    0, 1, 0, 1, 0, 1, 0, 0, 1, 1; 
    0, 0, 1, 1, 0, 0, 1, 0, 1, 0; 
    1, 0, 0, 0, 0, 1, 0, 1, 0, 0; 
    0, 0, 1, 1, 0, 1, 0, 0, 0, 0; 
    0, 1, 0, 0, 1, 0, 0, 0, 0, 0; 
    1, 0, 0, 0, 0, 0, 1, 1, 0, 1; 
    0, 0, 1, 0, 1, 0, 0, 0, 0, 1; 
    0, 1, 0, 1, 0, 0, 1, 0, 0, 0; 
  )
$

*Decision Variables*

- $x_r = cases(
  1 #[if route $r$ is selected],
  0 #[otherwise]
)$

*Model*

$
  min quad 
  &sum_(r in R) t_r x_r \
  "s.t." quad
  &sum_(r in R) p_(l r) x_(r) = 1 quad &&forall l in L \
  &sum_(r in R) x_r = 3 \
  &x_r in {0, 1} quad &&forall r in R \
$

*Solution*

#let res = toml("./code/results/p1_results.toml")
#let mdl = res.model

#let chosen = res.routes.filter(r => r.selected)

Choosing #mdl.trucks of the #mdl.n_routes candidate routes so that each of the #mdl.n_locations locations is visited exactly once gives a minimum total time of #mdl.objective_hours hours.
 
#figure(
  caption: [Selected routes (one per truck)],
  table(
    columns: (auto, auto, 1fr, auto),
    align: (center, center, left, right),
    table.header[*Truck*][*Route*][*Delivery sequence*][*Time (h)*],
    ..chosen.enumerate().map(((k, r)) => (
      [#(k + 1)],
      [#r.id],
      r.stops.join(sym.arrow.r),
      [#r.time],
    )).flatten(),
    table.hline(),
    table.cell(colspan: 3, align: right)[*Total*],
    [*#mdl.objective_hours*],
  ),
)
 
#figure(
  caption: [All candidate routes and decision variables $x_j$ (selected rows shaded)],
  table(
    columns: (auto, 1fr, auto, auto),
    align: (center, left, right, center),
    fill: (_, y) => if y > 0 and res.routes.at(y - 1).selected { luma(225) },
    table.header[*Route $j$*][*Delivery sequence*][*Time $t_j$ (h)*][*$x_j$*],
    ..res.routes.map(r => (
      [#r.id],
      r.stops.join(sym.arrow.r),
      [#r.time],
      [#int(r.selected)],
    )).flatten(),
  ),
)
 
#figure(
  caption: [Coverage check: each location served exactly once],
  table(
    columns: res.locations.len() + 1,
    align: center,
    [*Location*], ..res.locations.map(l => [*#l.name*]),
    [*Route*], ..res.locations.map(l => [#l.route]),
    [*Visits*], ..res.locations.map(l => [#l.covered]),
  ),
)

= Problem 2

*Sets*

- $S = {0, 1, 2, 3}$: number of *spots*
- $P = {1, 2, 3}$: *products*

*Indices*

- $s in S$
- $p in P$

*Parameters*

- $r_(s p)$: profit (in \$M) from giving product $p$ exactly $s$ spots

$
  R = mat(
    0, 0, 0;
    1, 0, -1;
    3, 2, 2;
    3, 3, 4;
  )
$

*Decision Variables*

- $x_(s p) = cases(
  1 #[if product $p$ is shown in $s$ spots],
  0 #[otherwise],
)$

*Model*

$
  max quad 
  &sum_(p in P) sum_(s in S) r_(s p) x_(s p) \
  "s.t." quad
  &sum_(p in P) sum_(s in S) s x_(s p) = 5 \
  &sum_(s in S) x_(s p) = 1 quad &&forall p in P \
  &x_(s p) in {0, 1} quad &&forall s in S, p in P \
$

*Solution*

#let res = toml("./code/results/p2_results.toml")
#let mdl = res.model

Allocating #mdl.total_spots spots across #mdl.n_products products (at most #mdl.max_spots_per_product each) gives a maximum total profit of \$#mdl.objective_millions million.

#figure(
  caption: [Optimal allocation],
  table(
    columns: (1fr, auto, auto),
    align: (left, center, right),
    table.header[*Product*][*TV spots*][*Profit (\$M)*],
    ..res.products.map(p => ([Product #p.id], [#p.spots], fmt(p.profit))).flatten(),
    table.hline(),
    [*Total*],
    [*#res.products.map(p => p.spots).sum()*],
    [*#mdl.objective_millions*],
  ),
)
 
#figure(
  caption: [Profit table with chosen levels shaded ($x_(s p) = 1$)],
  table(
    columns: (auto,) + (1fr,) * mdl.n_products,
    align: center,
    fill: (x, y) => if x > 0 and y > 0 and res.x.at(y - 1).at(x - 1) == 1 { luma(215) },
    table.header(
      [*Spots $s$*], ..range(mdl.n_products).map(p => [*Product #(p + 1)*]),
    ),
    ..res.profit_table.enumerate().map(((s, row)) => ([#s], ..row.map(fmt))).flatten(),
  ),
)
 
#figure(
  caption: [Decision variables $x_(s p)$],
  table(
    columns: (auto,) + (1fr,) * mdl.n_products,
    align: center,
    table.header(
      [*Spots $s$*], ..range(mdl.n_products).map(p => [*$x_(s #(p + 1))$*]),
    ),
    ..res.x.enumerate().map(((s, row)) => ([#s], ..row.map(v => [#v]))).flatten(),
    table.hline(),
    [*$sum_s x_(s p)$*],
    ..range(mdl.n_products).map(p => [#res.x.map(r => r.at(p)).sum()]),
  ),
)

= Problem 3

*Sets*

- $W = {1, 2, 3, 4}$: 
- $R = {1, 2, 3}$: 

*Indices*

- $w in W$: 
- $r in R$: 

*Parameters*

- $k_w$: capacity of WH $w$

$
  K = vec(
    100,
    100,
    100,
    100,
  )
$

- $c_w$: fixed cost for WH $w$

$
  C = vec(
    400,
    500,
    300,
    150,
  )
$

$t_(w r)$: shipping cost from WH $w$ to region $r$

$
  T = mat(
    20, 40, 50;
    48, 15, 26;
    26, 35, 18;
    24, 50, 35;
  )
$

- $d_r$: demand for region $r$

$
  D = vec(
    80,
    70,
    40,
  )
$

*Decision Variables*

- $x_(w r)$: quantity shipped from WH $w$ to region $r$

- $y_w = cases(
  1 #[if WH $w$ is opened],
  0 #[otherwise]
)$

*Model*

$
  min quad 
  &sum_(w in W) sum_(r in R) t_(w r) x_(w r) mc(+ sum_(w in W) c_w y_w) \
  "s.t." quad
  &sum_(w in W) x_(w r) gt.eq d_r quad &&forall r in R \
  &sum_(r in R) x_(w r) lt.eq k_w mc(y_w) quad &&forall w in W  \
  &y_1 lt.eq y_2 \
  &sum_(w in W) y_w lt.eq 2 \
  &y_2 + y_4 mc(gt.eq) 1 \
  &x_(w r) gt.eq 0 quad &&forall w in W, r in R \
  &y_w in {0, 1} quad &&forall w in W \
$

*Solution*

#let res = toml("./code/results/p3_results.toml")
#let mdl = res.model
#let wh = res.warehouses
#let num(v) = str(calc.round(v, digits: 2))
#let usd(v) = [\$#num(v)]
#let ok(b) = if b [✓] else [✗]

Opening #wh.filter(w => w.open).map(w => w.city).join(" and ") meets all weekly demand at a
minimum cost of #usd(mdl.objective) per week (#usd(mdl.fixed_cost) fixed + #usd(mdl.shipping_cost) shipping).

#figure(
  caption: [Warehouse decisions $y_i$ and weekly cost by warehouse (open rows shaded)],
  table(
    columns: (1fr, auto, auto, auto, auto, auto),
    align: (left, center, right, right, right, right),
    fill: (_, y) => if y > 0 and y <= wh.len() and wh.at(y - 1).open { luma(225) },
    table.header[*Warehouse*][*$y_i$*][*Shipped / cap.*][*Fixed*][*Shipping*][*Total*],
    ..wh.map(w => (
      [#w.city],
      [#int(w.open)],
      [#num(w.shipped) / #w.capacity],
      if w.open { usd(w.fixed_cost) } else [—],
      usd(w.shipping_cost),
      usd(w.fixed_cost * int(w.open) + w.shipping_cost),
    )).flatten(),
    table.hline(),
    table.cell(colspan: 3, align: right)[*Total*],
    [*#usd(mdl.fixed_cost)*], [*#usd(mdl.shipping_cost)*], [*#usd(mdl.objective)*],
  ),
)
 
#figure(
  caption: [Weekly shipments $x_(i j)$ in units (unit cost in brackets)],
  table(
    columns: (1fr,) + (auto,) * res.regions.len() + (auto,),
    align: (left,) + (right,) * (res.regions.len() + 1),
    table.header([*From \\ To*], ..res.regions.map(r => [*#r*]), [*Shipped*]),
    ..wh.enumerate().map(((i, w)) => (
      [#w.city],
      ..res.x.at(i).zip(res.unit_cost.at(i)).map(((q, c)) =>
        if q > 0 [*#num(q)* (\$#c)] else { text(fill: luma(140))[0 (\$#c)] }),
      [#num(w.shipped)],
    )).flatten(),
    table.hline(),
    [*Received*], ..res.demand.map(d => [#num(d.received)]), [],
    [*Required*], ..res.demand.map(d => [#d.required]), [],
  ),
)
 
#figure(
  caption: [Logical restrictions],
  table(
    columns: (1fr, auto, auto),
    align: (left, left, center),
    table.header[*Restriction*][*Constraint*][*Holds*],
    [If New York is opened, Los Angeles must be opened], [$y_"NY" <= y_"LA"$], ok(res.logic.ny_implies_la),
    [At most two warehouses can be opened], [$sum_i y_i <= 2$], ok(res.logic.max_two),
    [Either Atlanta or Los Angeles must be opened], [$y_"LA" + y_"ATL" >= 1$], ok(res.logic.atl_or_la),
  ),
)

= Problem 4

*Sets*

- $M = {1, dots, m}$: manufacturing plants
- $C = {1, dots, n}$: customers
- $P = {1, dots, p}$: distribution centers

*Indices*

- $i in M$
- $k in C$
- $j in P$

*Parameters*

- $S_i$: annual productive capacity of manufacturing plant $i$

- $D_j$: annual demand of customer $j$

- $r$: number of distribution centers opened

- $c_(i k j)$: shipping cost per unit from Plant $i$ to Demand Area $j$ through Distribution Center $k$

- $F_k$: fixed operating cost for operating Distribution Center $k$, if selected

- $f_k$: variable cost per unit shipped through Distribution Center $k$

*Decision Variables*

- $x_(i k j)$: units shipped from Plant $i$ to Demand Area $j$ through Distribution Center $k$

- $y_k = cases(
  1 #[if Distribution Center $k$ is open],
  0 #[otherwise],
)$

- $z_(k j) = cases(
  1 #[if Distribution Center $k$ serves customer $j$],
  0 #[otherwise],
)$

*Model*

$
  min quad
  &sum_(i in I) sum_(k in K) sum_(j in J) (c_(i k j) + f_k) x_(i k j) + sum_(k in K) F_k y_k \
  "s.t." quad
  &sum_(k in K) sum_(j in J) x_(i k j) lt.eq S_i && forall i in I quad && #[plant capacity] \
  &sum_(i in I) x_(i k j) = D_j z_(k j) && forall k in K, j in J quad && #[demand met via assigned DC] \
  &sum_(k in K) y_k = r && quad && #[open exactly $r$ DCs] \
  &sum_(k in K) z_(k j) = 1 && forall j in J quad && #[single sourcing] \
  &z_(k j) lt.eq y_k && forall k in K, j in J quad && #[assign only to open DCs] \
  &x_(i k j) gt.eq 0 && forall i, k, j \
  &y_k in {0, 1} && forall k in K \
  &z_(k j) in {0, 1} && forall k in K, j in J
$

= Problem 5

*Sets*

- $I = {A, B, M, P, S}$: cities (demand and possible Domes locations)
- $K = {40, 20}$: container types

*Indices*

- $i, j in I$: cities
- $k in K$: container type

*Parameters*

- $d_i$: monthly demand in city $i$

$
  d = vec(420, 870, 1250, 930, 1310)
$

- $p_i$: Domes unit production cost in city $i$

$
  p = vec(450, 480, 505, 490, 515)
$

- $p^0 = 440$: Ovis unit purchase price (DDP)

- $f_(i k)$: sea freight per type-$k$ container from Ovis to city $i$ (columns: 40', 20')

$
  f = mat(
    2000, 1200;
    1600, 1000;
    1800, 1100;
    1200,  700;
    1650, 1050;
  )
$

- $g_i$: LCL sea freight per unit from Ovis to city $i$

$
  g = vec(25, 20, 23, 15, 22)
$

- $q_k$: capacity of a type-$k$ container (units)

$
  q = vec(200, 100)
$

- $tau_i$: sea lead time from Ovis to city $i$ (days)

$
  tau = vec(30, 21, 28, 18, 25)
$

- $c_(i j)$: road transport cost per unit from city $i$ to city $j$

$
  c = mat(
    0, 35, 10, 35, 25;
    35, 0, 25, 70, 15;
    10, 25, 0, 45, 15;
    35, 70, 45, 0, 55;
    25, 15, 15, 55, 0;
  )
$

- $h = 0.15$: annual interest rate for inventory holding
- $U = 500$: monthly Domes production (fixed commitment)

*Decision Variables*

- $x_(i k) in ZZ_(>=0)$: type-$k$ containers shipped from Ovis to city $i$

- $y_i in ZZ_(>=0)$: units shipped by LCL from Ovis to city $i$

- $z_(i j) in ZZ_(>=0)$: units moved by road from city $i$ to city $j$

- $w_i in {0, 1}$: 1 if Domes produces in city $i$, 0 otherwise

- $v_i >= 0$: units Domes produces in city $i$

*Models*

1. Current practice: ship directly from Ovis (Q1)

$
  min quad
  &sum_(i in I) sum_(k in K) q_k x_(i k) p^0 + && quad &&#[*purchase* cost (*container*)] \
  &sum_(i in I) sum_(k in K) f_(i k) x_(i k) + && quad &&#[*freight* cost (*container*)] \
  &sum_(i in I) p^0 y_i + && quad &&#[*purchase* cost (*LCL*)] \
  &sum_(i in I) g_i y_i + && quad &&#[*freight* cost (*LCL*)] \
  &sum_(i in I) sum_(k in K) h / 365 p^0 tau_i x_(i k) q_k + && quad &&#[*holding* cost (*container*)] \
  &sum_(i in I) h / 365 p^0 tau_i y_i && quad &&#[*holding* cost (*LCL*)] \
  "s.t." quad
  &sum_(k in K) x_(i k) q_k + y_i >= d_i quad &&forall i in I quad &&#[demand] \
  &x_(i k) in ZZ_(>=0) quad &&forall i in I, k in K \
  &y_i in ZZ_(>=0) quad &&forall i in I \
$

2. Ovis with road rebalancing, no Domes (Q2)

$
  min quad
  &sum_(i in I) sum_(k in K) q_k x_(i k) p^0 + && quad &&#[*purchase* cost (*container*)] \
  &sum_(i in I) sum_(k in K) f_(i k) x_(i k) + && quad &&#[*freight* cost (*container*)] \
  &sum_(i in I) p^0 y_i + && quad &&#[*purchase* cost (*LCL*)] \
  &sum_(i in I) g_i y_i + && quad &&#[*freight* cost (*LCL*)] \
  &sum_(i in I) sum_(k in K) h / 365 p^0 tau_i x_(i k) q_k + && quad &&#[*holding* cost (*container*)] \
  &sum_(i in I) h / 365 p^0 tau_i y_i + && quad &&#[*holding* cost (*LCL*)] \
  &mc(sum_(i in I) sum_(j in I) c_(i j) z_(i j) quad && &&#[transportation cost (road)]) \
  "s.t." quad
  &mc(sum_(k in K) q_k x_(i k) + y_i + sum_(j in I) z_(j i)
  >= d_i + sum_(j in I) z_(i j) quad &&forall i in I quad &&#[flow balance]) \
  &x_(i k) in ZZ_(>=0) quad &&forall i in I, k in K \
  &y_i in ZZ_(>=0) quad &&forall i in I \
  &mc(z_(i j) in ZZ_(>=0) quad &&forall i\, j in I) \
$

3. Ovis with road rebalancing and Domes (Q3, Q4)

$
  min quad
  &sum_(i in I) sum_(k in K) q_k x_(i k) p^0 + && quad &&#[*purchase* cost (*container*)] \
  &sum_(i in I) sum_(k in K) f_(i k) x_(i k) + && quad &&#[*freight* cost (*container*)] \
  &sum_(i in I) p^0 y_i + && quad &&#[*purchase* cost (*LCL*)] \
  &sum_(i in I) g_i y_i + && quad &&#[*freight* cost (*LCL*)] \
  &sum_(i in I) sum_(k in K) h / 365 p^0 tau_i x_(i k) q_k + && quad &&#[*holding* cost (*container*)] \
  &sum_(i in I) h / 365 p^0 tau_i y_i + && quad &&#[*holding* cost (*LCL*)] \
  &sum_(i in I) sum_(j in I) c_(i j) z_(i j) + quad && &&#[transportation cost (road)] \
  &mc(sum_(i in I) p_i v_i quad && &&#[production cost]) \
  "s.t." quad
  &mc(sum_(k in K) q_k x_(i k) + y_i + v_i + sum_(j in I) z_(j i)
  >= d_i + sum_(j in I) z_(i j) quad &&forall i in I quad &&#[flow balance]) \
  &mc(sum_(i in I) w_i = 1 && quad &&#[only one Domes site]) \
  &mc(v_i = U w_i quad &&forall i in I quad &&#[produce exactly $U$ at the open site]) \
  &x_(i k) in ZZ_(>=0) quad &&forall i in I, k in K \
  &y_i in ZZ_(>=0) quad &&forall i in I \
  &z_(i j) in ZZ_(>=0) quad &&forall i\, j in I \
  &mc(w_i in {0, 1} quad &&forall i in I) \
  &mc(v_i >= 0 quad &&forall i in I) \
$

#let m1 = toml("./code/results/Oz_Ovis.toml")
#let m2 = toml("./code/results/Oz_Ovis_Road.toml")
#let m3 = toml("./code/results/Oz_Ovis_Road_Domes.toml")

#let save-road  = m1.summary.objective - m2.summary.objective
#let save-domes = m2.summary.objective - m3.summary.objective
#let save-total = m1.summary.objective - m3.summary.objective

= Cost comparison (monthly, \$)

#let rows = ("purchase", "freight", "holding", "road", "domes")

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr),
    align: (left, right, right, right, right),
    table.header(
      [*Cost*], [*(1) Direct*], [*(2) + Road*], [*(3) + Domes*], [*(3) − (2)*],
    ),
    ..rows.map(k => (
      k,
      fmt(m1.summary.at(k)),
      fmt(m2.summary.at(k)),
      fmt(m3.summary.at(k)),
      fmt(m3.summary.at(k) - m2.summary.at(k)),
    )).flatten(),
    table.hline(),
    [*Total*],
    [*#fmt(m1.summary.objective)*],
    [*#fmt(m2.summary.objective)*],
    [*#fmt(m3.summary.objective)*],
    [*#fmt(m3.summary.objective - m2.summary.objective)*],
  ),
  caption: [Summary],
)

1. Shipping everything directly from Ovis to each city costs Oz Sourcing
  #fmt(m1.summary.objective) per month.

2. No. Without Domes, it is cheaper to ship a 20' container to Brisbane
  instead of LCL and move the surplus by road. This costs
  #fmt(m2.summary.objective) per month, which saves #fmt(save-road)
  compared with the current practice.

3. Oz Sourcing should ask Domes to manufacture in *#m3.summary.domes_site*
  (#m3.summary.units_domes units per month).

4. Engaging Domes saves #fmt(save-total) per month compared with the current
  practice. Of this, #fmt(save-road) comes from road rebalancing alone, so the
  saving attributable to Domes is #fmt(save-domes) per month.

#let city-table(m, caption) = figure(
  table(
    columns: 9,
    align: (left,) + (right,) * 8,
    table.header(
      [*City*], [*Demand*], [*40'*], [*20'*], [*LCL*],
      [*Domes*], [*In*], [*Out*], [*\$/unit*],
    ),
    ..m.city.map(c => (
      c.name, str(c.demand), str(c.x40), str(c.x20), str(c.lcl),
      str(c.domes), str(c.road_in), str(c.road_out),
      fmt(c.unit_cost, digits: 2),
    )).flatten(),
  ),
  caption: caption,
)

#let road-table(m, caption) = figure(
  table(
    columns: 3,
    align: (left, left, right),
    table.header([*From*], [*To*], [*Units*]),
    ..m.road.map(r => (r.from, r.to, str(r.units))).flatten(),
  ),
  caption: caption,
)

#city-table(m1, [Per-city plan, (1) direct from Ovis])
#city-table(m2, [Per-city plan, (2) Ovis + road])
#city-table(m3, [Per-city plan, (3) Ovis + road + Domes])

#road-table(m2, [Road transfers, (2) Ovis + road])
#road-table(m3, [Road transfers, (3) Ovis + road + Domes])

= Appendix

== Problem 1

```py
import numpy as np
import gurobipy as gp

P = np.array([
    [1, 0, 0, 0, 1, 0, 0, 0, 1, 0],
    [0, 1, 0, 1, 0, 1, 0, 0, 1, 1],
    [0, 0, 1, 1, 0, 0, 1, 0, 1, 0],
    [1, 0, 0, 0, 0, 1, 0, 1, 0, 0],
    [0, 0, 1, 1, 0, 1, 0, 0, 0, 0],
    [0, 1, 0, 0, 1, 0, 0, 0, 0, 0],
    [1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
    [0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
    [0, 1, 0, 1, 0, 0, 1, 0, 0, 0],
])

T = np.array([
    6,
    4,
    7,
    5,
    4,
    6,
    5,
    3,
    7,
    6,
])

MAX = 3

m = gp.Model("speedy")

x = m.addMVar(T.shape, vtype=gp.GRB.BINARY, name="x")

m.setObjective((T * x).sum())

m.addConstr(P @ x == 1, name="")
m.addConstr(x.sum() == MAX, name="")

m.optimize()
```

#image("code/excel/p1.jpeg")

== Problem 2

```py
import numpy as np
import gurobipy as gp

R = np.array([
    [0, 0, 0],
    [1, 0, -1],
    [3, 2, 2],
    [3, 3, 4],
])

S, P = R.shape

S = np.arange(S)

m = gp.Model("supersuds")

x = m.addMVar(R.shape, vtype=gp.GRB.BINARY, name="x")

m.setObjective((R * x).sum(), sense=gp.GRB.MAXIMIZE)

m.addConstr((S @ x).sum() == 5)
m.addConstr(x.sum(axis=0) == 1)

m.optimize()

```

#image("code/excel/p2.jpeg")

== Problem 3

```py
import numpy as np
import gurobipy as gp

K = np.array([
    100,
    100,
    100,
    100,
])

C = np.array([
    400,
    500,
    300,
    150,
])

T = np.array([
    [20, 40, 50],
    [48, 15, 26],
    [26, 35, 18],
    [24, 50, 35],
])

D = np.array([
    80,
    70,
    40,
])

m = gp.Model("wh")

x = m.addMVar(T.shape, name="x")
y = m.addMVar(K.shape, vtype=gp.GRB.BINARY, name="y")

m.setObjective((T * x).sum() + (C * y).sum(), sense=gp.GRB.MINIMIZE)

m.addConstr(x.sum(axis=0) >= D, name="demand")
m.addConstr(x.sum(axis=1) <= K * y, name="capacity")
m.addConstr(y[0] <= y[1], name="ny_implies_la")
m.addConstr(y.sum() <= 2, name="max_two")
m.addConstr(y[1] + y[3] >= 1, name="atl_or_la")

m.optimize()
```

#image("code/excel/p3.jpeg")

== Problem 5

```py
from pathlib import Path

import gurobipy as gp
import numpy as np
import tomli_w

# ----------------------------------------------------------------------------
# Data
# ----------------------------------------------------------------------------
cities = ["Adelaide", "Brisbane", "Melbourne", "Perth", "Sydney"]

d   = np.array([420, 870, 1250, 930, 1310])        # monthly demand
p   = np.array([450, 480, 505, 490, 515])          # Domes unit cost by site
p0  = 440                                          # Ovis delivered unit cost
f   = np.array([                                   # $/container [40', 20']
    [2000, 1200],
    [1600, 1000],
    [1800, 1100],
    [1200,  700],
    [1650, 1050],
])
g   = np.array([25, 20, 23, 15, 22])               # $/LCL unit
q   = np.array([200, 100])                         # container capacity
tau = np.array([30, 21, 28, 18, 25])               # sea lead time (days)
c   = np.array([                                   # road $/unit, origin x dest
    [ 0, 35, 10, 35, 25],
    [35,  0, 25, 70, 15],
    [10, 25,  0, 45, 15],
    [35, 70, 45,  0, 55],
    [25, 15, 15, 55,  0],
])
h = 0.15                                           # annual interest rate
U = 500                                            # Domes units per month

I, K = f.shape
hc = h / 365 * p0 * tau                            # in-transit holding $/unit

# True  -> Domes produces exactly U units ("commission 500 units every month")
# False -> Domes produces up to U units
DOMES_EXACT = False

RESULTS = Path("./results")
RESULTS.mkdir(exist_ok=True)


# ----------------------------------------------------------------------------
# Model
# ----------------------------------------------------------------------------
def build(name, road=False, domes=False, exact=DOMES_EXACT):
    """Single formulation; Q1/Q2/Q3 just switch road and Domes on or off."""
    m = gp.Model(name)
    m.Params.OutputFlag = 0
    m.Params.MIPGap = 0          # default 1e-4 (~$216 here) can hide the answer

    x = m.addMVar((I, K), vtype=gp.GRB.INTEGER, name="x")   # full containers
    y = m.addMVar(I, vtype=gp.GRB.INTEGER, name="y")        # LCL units
    z = m.addMVar((I, I), vtype=gp.GRB.INTEGER, name="z")   # road i -> j
    v = m.addMVar(I, name="v")                              # Domes units
    w = m.addMVar(I, vtype=gp.GRB.BINARY, name="w")         # Domes site

    ovis = x @ q + y                                        # units landed

    purchase = p0 * ovis.sum()
    freight  = (f * x).sum() + g @ y
    holding  = hc @ ovis
    roadcost = (c * z).sum()
    domescost = p @ v

    m.setObjective(purchase + freight + holding + roadcost + domescost,
                   gp.GRB.MINIMIZE)

    # supply + road in - road out >= demand
    m.addConstr(ovis + v + z.sum(axis=0) - z.sum(axis=1) >= d, name="flow")

    # no shipping a city to itself
    m.addConstr(z[np.arange(I), np.arange(I)] == 0, name="no_self")

    if not road:
        m.addConstr(z == 0, name="no_road")

    if domes:
        m.addConstr(w.sum() == 1, name="one_site")
        if exact:
            m.addConstr(v == U * w, name="domes_cap")
        else:
            m.addConstr(v <= U * w, name="domes_cap")
    else:
        m.addConstr(v == 0, name="no_domes")
        m.addConstr(w == 0, name="no_site")

    m.optimize()
    if m.Status != gp.GRB.OPTIMAL:
        raise RuntimeError(f"{name}: status {m.Status}")

    sol = {k: np.round(var.X) if k != "v" else var.X
           for k, var in dict(x=x, y=y, z=z, v=v).items()}
    return m, sol

```

#image("code/excel/p5_0.jpeg")

#image("code/excel/p5.jpeg")