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

- $y_i >= 0$: units shipped by LCL from Ovis to city $i$

- $z_(i j) >= 0$: units moved by road from city $i$ to city $j$

- $w_i in {0, 1}$: 1 if Domes produces in city $i$, 0 otherwise

- $v_i >= 0$: units Domes produces in city $i$

*Models*

1. 

$
  min quad 
  &sum_(i in I) sum_(k in K) q_k x_(i k) p^0 + && quad &&#[*purchase* cost (*container*)] \
  &sum_(i in I) sum_(k in K) f_(i k) x_(i k) + && quad &&#[*freight* cost (*container*)] \
  &sum_(i in I) p^0 y_i + && quad &&#[*purchase* cost (*LCL*)]  \
  &sum_(i in I) g_i y_i + && quad &&#[*freight* cost (*LCL*)]  \
  &sum_(i in I) sum_(k in K) h / 365 p^0 tau_i x_(i k) q_k + && quad &&#[*holding* cost (*container*)]\
  &sum_(i in I) h / 365 p^0 tau_i y_i && quad &&#[*holding* cost (*LCL*)]\
  "s.t." quad
  &sum_(k in K) x_(i k) q_k + y_i >= d_i quad &&forall i in I quad &&#[demand] \
  &x_(i k) in ZZ_(>=0) quad &&forall i in I, k in K \
  &y_i gt.eq 0 quad &&forall i in I \
$

2.



$
  min quad 
  &sum_(i in I) sum_(k in K) q_k x_(i k) p^0 + && quad &&#[*purchase* cost (*container*)] \
  &sum_(i in I) sum_(k in K) f_(i k) x_(i k) + && quad &&#[*freight* cost (*container*)] \
  &sum_(i in I) p^0 y_i + && quad &&#[*purchase* cost (*LCL*)]  \
  &sum_(i in I) g_i y_i + && quad &&#[*freight* cost (*LCL*)]  \
  &sum_(i in I) sum_(k in K) h / 365 p^0 tau_i x_(i k) q_k + && quad &&#[*holding* cost (*container*)] \
  &sum_(i in I) h / 365 p^0 tau_i y_i + && quad &&#[*holding* cost (*LCL*)] \
  &mc(sum_(i in I) sum_(j in I) c_(i j) z_(i j) + quad && &&#[transportation cost (road)]) \
  &mc(sum_(i in I) p_i v_i quad && &&#[production cost]) \

  "s.t." quad

  &mc(sum_(k in K) q_k x_(i k) + y_i + v_i + sum_(j in I) z_(j i)
  >= d_i + sum_(j in I) z_(i j) quad &&forall i in I quad &&#[flow balance]) \


  &mc(sum_(i in I) w_i = 1 && quad &&#[only one Dome]) \
  &mc(v_i <= U w_i quad &&forall i in I quad &&#[only produce when open]) \
  &x_(i k) in ZZ_(>=0) quad &&forall i in I, k in K \
  &y_i gt.eq 0 quad &&forall i in I \
  &mc(w_i in {0, 1} quad &&forall i in I)\ 
  &mc(v_i >= 0) quad &&forall i in I \
  &mc(z_(i j) >= 0 quad &&forall i\, j in I) \
$

#let m1 = toml("./code/results/Oz_Ovis.toml")
#let m2 = toml("./code/results/Oz_Ovis_Dome.toml")

= Cost comparison (monthly, \$)

#let rows = ("purchase", "freight", "holding", "road", "domes")

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    align: (left, right, right, right),
    table.header([*Cost*], [*Ovis only*], [*Ovis + Domes*], [*Difference*]),
    ..rows.map(k => (
      k,
      fmt(m1.summary.at(k)),
      fmt(m2.summary.at(k)),
      fmt(m2.summary.at(k) - m1.summary.at(k)),
    )).flatten(),
    table.hline(),
    [*Total*],
    [*#fmt(m1.summary.objective)*],
    [*#fmt(m2.summary.objective)*],
    [*#fmt(m2.summary.objective - m1.summary.objective)*],
  ),
  caption: [Summary]
)

1. Oz pays #fmt(m1.summary.objective) to ship directly from Ovis to each city.

2. If Oz Sourcing does not engage Domes, the current shipping practice is the best for Ovis.

3. Domes site: *#m2.summary.domes_site*

4. Oz Sourcin would save #fmt(calc.abs(m2.summary.objective - m1.summary.objective))

#figure(
  table(
    columns: 9,
    align: (left,) + (right,) * 8,
    table.header(
      [*City*], [*Demand*], [*40'*], [*20'*], [*LCL*],
      [*Domes*], [*In*], [*Out*], [*\$/unit*],
    ),
    ..m1.city.map(c => (
      c.name, str(c.demand), str(c.x40), str(c.x20), str(c.lcl),
      str(c.domes), str(c.road_in), str(c.road_out),
      fmt(c.unit_cost, digits: 2),
    )).flatten(),
  ),
  caption: [Per-city (Ovis only)]
)

#figure(
  table(
    columns: 9,
    align: (left,) + (right,) * 8,
    table.header(
      [*City*], [*Demand*], [*40'*], [*20'*], [*LCL*],
      [*Domes*], [*In*], [*Out*], [*\$/unit*],
    ),
    ..m2.city.map(c => (
      c.name, str(c.demand), str(c.x40), str(c.x20), str(c.lcl),
      str(c.domes), str(c.road_in), str(c.road_out),
      fmt(c.unit_cost, digits: 2),
    )).flatten(),
  ),
  caption: [Per-city (Ovis + Domes)]
)

#figure(
  table(
    columns: 3,
    align: (left, left, right),
    table.header([*From*], [*To*], [*Units*]),
    ..m2.road.map(r => (r.from, r.to, str(r.units))).flatten(),
  ),
  caption: [Road transfers (Ovis + Domes)]
)

