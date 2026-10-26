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

#h(1fr) Carmen Carrera \
#h(1fr) Divya Bhojane \
#h(1fr) Vladimir Borel \

= Problem 1

#align(center)[

  #let dx = 4
  #let dy = 2

  #diagram({
    node((0, (dy * 0)), [$R_1$], stroke: 0.5pt, name: <R1>)
    node((0, (dy * 1)), [$R_2$], stroke: 0.5pt, name: <R2>)
    node((0, (dy * 2)), [$R_3$], stroke: 0.5pt, name: <R3>)

    node((-0.5, (dy * 0)), [6], stroke: none, name: <R1s>)
    node((-0.5, (dy * 1)), [5], stroke: none, name: <R2s>)
    node((-0.5, (dy * 2)), [6], stroke: none, name: <R3s>)
    
    node((dx, (dy * 0)), [$D_1$], stroke: 0.5pt, name: <D1>)
    node((dx, (dy * 1)), [$D_2$], stroke: 0.5pt, name: <D2>)
    node((dx, (dy * 2)), [$D_3$], stroke: 0.5pt, name: <D3>)

    node((dx+0.5, (dy * 0)), [4], stroke: none, name: <D1d>)
    node((dx+0.5, (dy * 1)), [8], stroke: none, name: <D2d>)
    node((dx+0.5, (dy * 2)), [7], stroke: none, name: <D3d>)

    edge(<R1>, <D1>, "-|>", [120], label-pos: 0.5, label-side: center)
    edge(<R1>, <D2>, "-|>", [180], label-pos: 0.3, label-side: center)
    edge(<R2>, <D1>, "-|>", [300], label-pos: 0.3, label-side: center)
    edge(<R2>, <D2>, "-|>", [100], label-pos: 0.3, label-side: center)
    edge(<R2>, <D3>, "-|>", [80], label-pos: 0.8, label-side: center)
    edge(<R3>, <D1>, "-|>", [200], label-pos: 0.2, label-side: center)
    edge(<R3>, <D2>, "-|>", [250], label-pos: 0.7, label-side: center)
    edge(<R3>, <D3>, "-|>", [120], label-pos: 0.5, label-side: center)
  })
]

#let mc(x) = text(fill: red, x)

*Sets*
- $I = {1, 2, 3}$: set of *refineries* (source nodes)
- $J = {1, 2, 3}$: set of *distribution areas* (sink nodes)
- $J^S = {2, 3} subset J$: areas where a *shortage is allowed* (penalized by $p$)
- $A = I times J without {(1, 3)}$: set of exisiting *pipelines* (arcs)

*Indices*
- $i in I$: *refinery*
- $j in J$: *distribution area*

*Parameters*
- $S_i$: *supply* capacity of refinery $i$ (Mgal)
  $
    S = vec(
      6,
      5,
      6,
    ) 
  $
- $D_j$: *demand* of area $j$ (Mgal)
  $
    D = vec(
      4, 
      8, 
      7,
    )
  $
- $m_(i j)$: *distance* from refinery $i$ to area $j$ (miles)
  $
    M = mat(
      120, 180, -;
      300, 100, 80;
      200, 250, 120;
    )
  $
- $c = 10 m_(i j)$: unit transportation *cost* (k\$/Mgal) (\$1 / 100 gal / mile)
- $p = 5000$: shortage *penalty* (k\$/Mgal) (\$5 per gal)

*Decision variables*
- $x_(i j) >= 0 quad forall (i, j) in A$: *quantity* of oil shipped from refinery $i$ to area $j$ (Mgal)
- $s_j >= 0 quad forall j in J^S$: *shortage* at area $j$ (Mgal)

*Model*

#grid(
  columns: 2,
  align: center + top,
  // inset: 2em,
  column-gutter: 1fr,
  [
    $
      min quad
      &sum_(i in I) sum_(j in J) c_(i j) x_(i j) mc(+ p sum_(j in J^S) s_j) \
      "s.t." quad
      &sum_(j in J) x_(i j) <= S_i quad &&forall i in I quad quad &&"capacity" \
      &sum_(i in I) x_(i j) mc(+ s_j [j in J^S]) = D_j quad &&forall j in J quad quad &&"demand" \
      &x_(i j) >= 0 quad &&forall (i, j) in A \
      &s_j >= 0 quad &&forall j in J^S
    $
  ],
  [
    $
      min quad
      &c (x_(1 1) + x_(1 2) + x_(2 1) + x_(2 2) + x_(2 3) + x_(3 1) + x_(3 2) + x_(3 3))\ 
      &mc(+ p (s_2 + s_3)) \
      "s.t."
      \
      &cases(
        reverse: #true, gap: #0.75em,
        x_(1 1) + x_(1 2) &<= S_1,
        x_(2 1) + x_(2 2) + x_(2 3) &<= S_2,
        x_(3 1) + x_(3 2) + x_(3 3) &<= S_3,
      ) quad "capacity" 
      \
      &cases(
        reverse: #true, gap: #0.75em,
        x_(1 1) + x_(2 1) + x_(3 1) &= D_1,
        x_(1 2) + x_(2 2) + x_(3 2) mc(+ s_2) &= D_2,
        x_(2 3) + x_(3 3) mc(+ s_3) &= D_3,
      ) quad "demand" 
      \
      &x_(1 1), x_(1 2), x_(2 1), x_(2 2), x_(2 3), x_(3 1), x_(3 2), x_(3 3) >= 0 \
      &s_2, s_3 >= 0
    $

  ]
)

*Code*

See `problem_1.py`.

*Solution*

#let results = toml("code/results/problem_1.toml")

#let objective = results.summary.objective

#table(
  columns: 2,
  fill: (x, y) => if x == 0 and y == 0 { luma(222) },
  [Objective], [#objective],
)

#figure(
  table(
    columns: 6,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Variable*], [*Value*], [*Reduced\ Cost*], [*Objective\ Coef*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.variables.map(row => row.values().map(val => [#val])).flatten(),
  ),
  caption: [Variables]
)

#figure(
  table(
    columns: 7,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Name*], [*Value*], [*Shadow\ Price*], [*RHS*], [*Slack*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.constraints.map(row => row.values().map(val => [#val])).flatten()
  ),
  caption: [Constraints]
)

#figure(
  table(
    columns: 2,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Edge*], [*Cost*]),
    ..results.summary.c.pairs().flatten().map(v => [#v]),
  ),
  caption: [Cost]
)

= Problem 2


#align(center)[
  #grid(
    columns: 2,
    column-gutter: 3em,
    align: center + horizon,
    [
      #let dx = 4
      #let dy = 2

      #diagram({
        node((0, 0), [Product], stroke: 0.5pt, name: <p>)
        
        node((-1, 2), [Part 1], stroke: 0.5pt, name: <p1>)
        node((0, 2), [Part 2], stroke: 0.5pt, name: <p2>)
        node((1, 2), [Part 3], stroke: 0.5pt, name: <p3>)

        edge(<p>, <p1>, "-|>", [3], label-pos: 0.5, label-side: center)
        edge(<p>, <p2>, "-|>", [1], label-pos: 0.5, label-side: center)
        edge(<p>, <p3>, "-|>", [2], label-pos: 0.5, label-side: center)
      })
    ],
    [
      #let dx = 3
      #let dy = 1.5
      #let mid = dy / 2
      #let gap = 2

      #diagram({
        node((0, mid - gap), [$P_1$], stroke: 0.5pt, name: <P1>)
        node((0, mid),       [$P_2$], stroke: 0.5pt, name: <P2>)
        node((0, mid + gap), [$P_3$], stroke: 0.5pt, name: <P3>)

        node((dx, 0),  [$D_A$], stroke: 0.5pt, name: <DA>)
        node((dx, dy), [$D_B$], stroke: 0.5pt, name: <DB>)

        node((dx + 0.5, 0),  [150], stroke: none, name: <DAs>)
        node((dx + 0.5, dy), [150], stroke: none, name: <DBs>)

        edge(<P1>, <DA>, "-|>", [0.8], label-pos: 0.5,  label-side: center)
        edge(<P2>, <DA>, "-|>", [0.3], label-pos: 0.25, label-side: center)
        edge(<P3>, <DA>, "-|>", [0.5], label-pos: 0.25, label-side: center)
        edge(<P1>, <DB>, "-|>", [0.6], label-pos: 0.25, label-side: center)
        edge(<P2>, <DB>, "-|>", [0.4], label-pos: 0.25, label-side: center)
        edge(<P3>, <DB>, "-|>", [0.6], label-pos: 0.5,  label-side: center)
      })
    ]
  )
]

*Sets*

- $I = {1, 2, 3}$: set of *parts*
- $J = {A, B}$: set of *departments*
- $A = I times J$

*Indices*

- $i in I$: *parts*
- $j in J$: *departments*

*Parameters*

- $t_(i j)$: time it takes to produce *part* $i$ in *departement* $j$

$
  T = mat(
    0.8, 0.6;
    0.3, 0.4;
    0.5, 0.6;
  )
$

- $S_i$: available production time in *departement* $i$

$
  S = vec(
    150,
    150,
  )
$

- $r_i$: amount of *part* $i$ it takes to create a product

$
  R = vec(
    3,
    1,
    2,
  )
$

*Decision variables*

- $y$: number of *products* produced
- $x_(i j)$: how many *parts* $i$ are produced in *department* $j$

*Model*

#grid(
  columns: 2,
  align: center + top,
  column-gutter: 1fr,
  [
    $
      max quad & y \
      "s.t." quad
      & sum_(j in J) x_(i j) gt.eq r_i y quad && forall i in I quad "requirements" \
      & sum_(i in I) t_(i j) x_(i j) lt.eq S_j quad && forall j in J quad "capacity" \
      & x_(i j) gt.eq 0 quad && forall i in I, j in J \
      & y gt.eq 0
    $
  ],
  [
    $
      max quad & y \
      "s.t."
      \
      &cases(
        reverse: #true, gap: #0.75em,
        x_(1 A) + x_(1 B) gt.eq 3 y,
        x_(2 A) + x_(2 B) gt.eq y,
        x_(3 A) + x_(3 B) gt.eq 2 y,
      ) quad "requirements"
      \
      &cases(
        reverse: #true, gap: #0.75em,
        0.8 x_(1 A) + 0.3 x_(2 A) + 0.5 x_(3 A) lt.eq 150,
        0.6 x_(1 B) + 0.4 x_(2 B) + 0.6 x_(3 B) lt.eq 150,
      ) quad "capacity"
      \
      & x_(1 A), x_(1 B), x_(2 A), x_(2 B), x_(3 A), x_(3 B) gt.eq 0 \
      & y gt.eq 0
    $
  ]
)

*Code*

See `problem_2.py`.

*Solution*

#let results = toml("code/results/problem_2.toml")

#let objective = results.summary.objective

#table(
  columns: 2,
  fill: (x, y) => if x == 0 and y == 0 { luma(222) },
  [Objective], [#objective],
)

#figure(
  table(
    columns: 6,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Variable*], [*Value*], [*Reduced\ Cost*], [*Objective\ Coef*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.variables.map(row => row.values().map(val => [#val])).flatten(),
  ),
  caption: [Variables]
)

#figure(
  table(
    columns: 7,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Name*], [*Value*], [*Shadow\ Price*], [*RHS*], [*Slack*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.constraints.map(row => row.values().map(val => [#val])).flatten()
  ),
  caption: [Constraints]
)

= Problem 3

#align(center)[
  #diagram(
    node-shape: circle,
    spacing: (7.5em, 2em),
    {
      node((0, 0), [LA], stroke: 0.5pt, name: <LA>)
      node((1, 0), [HO], stroke: 0.5pt, name: <HO>)
      node((2, 0), [NY], stroke: 0.5pt, name: <NY>)
      node((3, 0), [MI], stroke: 0.5pt, name: <MI>)

      node((0, -0.75), [88], stroke: none, name: <LAp>)
      node((1, -0.75), [15], stroke: none, name: <HOp>)
      node((2, -0.75), [105], stroke: none, name: <NYp>)
      node((3, -0.75), [95], stroke: none, name: <MIp>)

      edge(<LA>, <HO>, "-|>", [1500], label-pos: 0.5,  label-side: center)
      edge(<HO>, <NY>, "-|>", [1700], label-pos: 0.5,  label-side: center)
      edge(<NY>, <MI>, "-|>", [1300], label-pos: 0.5,  label-side: center)
      edge(<MI>, <LA>, "-|>", [2700], label-pos: 0.5,  label-side: center, bend: 35deg)
    }
  )
]

*Sets*

- $I = {1, 2, 3, 4}$

*Indices*

- $i in I$: *airports*

Indices cyclic ($i = 5 equiv 1$, $i = 0 equiv 4$)

*Parameters*

- $m_i$: distance between city $i$ and city $i + 1$ (miles)

$
  M = vec(
    1500,
    1700,
    1300,
    2700,
  )
$

- $p_i$: *price* per gallon ($cent$/gal)

$
  P = vec(
    88,
    15,
    105,
    95,
  )
$

- $k = 12000$: plane fuel *capacity* (gallons)
- $r = 600$: fuel *reserve* (gallons)

*Decision Variables*

- $x_i gt.eq 0$: how much fuel to put into the plane at airport $i$ (gallons)
- $s_i gt.eq 0$: fuel level at start of leg $i$, after refuelling at airport $i$ (gallons)
- $e_i gt.eq 0$: fuel level at end of leg $i$, on arrival at airport $i + 1$ before refuelling (gallons)

*Fuel-burn relation*

$
  s_i - e_i = m_i (1 + ((s_i + e_i) \/ 2) / 2000)
$

*Model*

#grid(
  columns: 2,
  align: center + top,
  column-gutter: 1fr,
  [
    $
      min quad 
      &sum_(i in I) p_i x_i \
      "s.t." quad
      &s_i = e_(i-1) + x_i quad &&forall i in I quad "balance" \
      &s_i - e_i = m_i (1 + (s_i + e_i) / 4000) quad &&forall i in I quad "consumption" \
      &s_i lt.eq k quad &&forall i in I quad "capacity" \
      &e_i gt.eq r quad &&forall i in I quad "reserve" \
      &x_i gt.eq 0 quad &&forall i in I \
      &s_i gt.eq 0 quad &&forall i in I \
      &e_i gt.eq 0 quad &&forall i in I 
    $
  ],
  [
    $
      min quad 
      &p_1 x_1 + p_2 x_2 + p_3 x_3 + p_4 x_4  \
      "s.t."
      \
      &cases(
        reverse: #true, gap: #0.75em,
        s_2 = e_1 + x_2,
        s_3 = e_2 + x_3,
        s_4 = e_3 + x_4,
        s_1 = e_4 + x_1,
      ) quad "balance"
      \
      &cases(
        reverse: #true, gap: #0.75em,
        s_1 - e_1 = m_1 (1 + (s_1 + e_1) / 4000),
        s_2 - e_2 = m_2 (1 + (s_2 + e_2) / 4000),
        s_3 - e_3 = m_3 (1 + (s_3 + e_3) / 4000),
        s_4 - e_4 = m_4 (1 + (s_4 + e_4) / 4000),
      ) quad "consumption"
      \
      &cases(
        reverse: #true, gap: #0.75em,
        s_1 lt.eq k,
        s_2 lt.eq k,
        s_3 lt.eq k,
        s_4 lt.eq k,
      ) quad "capacity"
      \
      &cases(
        reverse: #true, gap: #0.75em,
        e_1 gt.eq r,
        e_2 gt.eq r,
        e_3 gt.eq r,
        e_4 gt.eq r,
      ) quad "reserve"
      \
      &x_1, x_2, x_3, x_4 gt.eq 0 \
      \
      &s_1, s_2, s_3, s_4 gt.eq 0 \
      \
      &e_1, e_2, e_3, e_4 gt.eq 0 
    $
  ]
)

*Code*

See `problem_3.py`.

*Solution*

#let results = toml("code/results/problem_3.toml")

#let objective = results.summary.objective

#table(
  columns: 2,
  fill: (x, y) => if x == 0 and y == 0 { luma(222) },
  [Objective], [#objective],
)

#figure(
  table(
    columns: 6,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Variable*], [*Value*], [*Reduced\ Cost*], [*Objective\ Coef*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.variables.map(row => row.values().map(val => [#val])).flatten(),
  ),
  caption: [Variables]
)

#figure(
  table(
    columns: 7,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Name*], [*Value*], [*Shadow\ Price*], [*RHS*], [*Slack*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.constraints.map(row => row.values().map(val => [#val])).flatten()
  ),
  caption: [Constraints]
)

- The model takes advantage of the low fuel price in Houston (\$0.15/gal) by filling the tank completely (12,000 gallons). Even though the plane burns more fuel on the Houston-NYC leg because it is heavier, it is still cheaper than buying fuel elsewhere.
- No fuel is bought in NYC, the most expensive airport, since the fuel from Houston is enough to reach Miami.
- In LA and Miami the plane only buys the fuel needed to arrive at the next airport with the minimum 600 gallons, because carrying extra fuel increases consumption.
- The total fuel cost per round trip is \$14,451.64.

= Problem 4

#align(center)[
  #let dx = 4
  #let dy = 2

  #diagram({
    let off = dy * (4 - 3) / 2

    node((0, (dy * 0)), [$A$], stroke: 0.5pt, name: <A>)
    node((0, (dy * 1)), [$B$], stroke: 0.5pt, name: <B>)
    node((0, (dy * 2)), [$C$], stroke: 0.5pt, name: <C>)
    node((0, (dy * 3)), [$D$], stroke: 0.5pt, name: <D>)

    node((-0.5, (dy * 0)), [90], stroke: none, name: <As>)
    node((-0.5, (dy * 1)), [50], stroke: none, name: <Bs>)
    node((-0.5, (dy * 2)), [80], stroke: none, name: <Cs>)
    node((-0.5, (dy * 3)), [60], stroke: none, name: <Ds>)

    node((dx, off + (dy * 0)), [$1$], stroke: 0.5pt, name: <D1>)
    node((dx, off + (dy * 1)), [$2$], stroke: 0.5pt, name: <D2>)
    node((dx, off + (dy * 2)), [$3$], stroke: 0.5pt, name: <D3>)

    node((dx + 0.5, off + (dy * 0)), [120], stroke: none, name: <D1d>)
    node((dx + 0.5, off + (dy * 1)), [100], stroke: none, name: <D2d>)
    node((dx + 0.5, off + (dy * 2)), [110], stroke: none, name: <D3d>)

    edge(<A>, <D1>, "-|>", [70], label-pos: 0.5, label-side: center)
    edge(<A>, <D2>, "-|>", [100], label-pos: 0.85, label-side: center)
    edge(<A>, <D3>, "-|>", [50], label-pos: 0.15, label-side: center)

    edge(<B>, <D1>, "-|>", [120], label-pos: 0.75, label-side: center)
    edge(<B>, <D2>, "-|>", [90], label-pos: 0.15, label-side: center)
    edge(<B>, <D3>, "-|>", [40], label-pos: 0.15, label-side: center)

    edge(<C>, <D1>, "-|>", [70], label-pos: 0.15, label-side: center)
    edge(<C>, <D2>, "-|>", [30], label-pos: 0.15, label-side: center)
    edge(<C>, <D3>, "-|>", [110], label-pos: 0.15, label-side: center)

    edge(<D>, <D1>, "-|>", [90], label-pos: 0.25, label-side: center)
    edge(<D>, <D2>, "-|>", [50], label-pos: 0.25, label-side: center)
    edge(<D>, <D3>, "-|>", [70], label-pos: 0.5, label-side: center)
  })
]

*Sets*

- $I = {1, 2, 3, 4}$: set of *supply* nodes
- $J = {1, 2, 3}$: set of *demand* nodes

*Indices*

- $i in I$: *supply* nodes
- $j in J$: *demand* nodes

*Parameters*

- $k_i$: *capacity* at supply node $i$

$
  K = vec(
    90,
    50,
    80,
    60,
  )
$

- $d_j$: *demand* at demand node $j$


$
  D = vec(
    120,
    100,
    110,
  )
$

- $c_(i j)$: unit *cost* of transporting a product from supply node $i$ to demand node $j$

$
  C = mat(
    70, 100, 50;
    120, 90, 40;
    70, 30, 110;
    90, 50, 70;
  )
$

*Decision Variables*

- $x_(i j)$: number of units sent from *supply node* $i$ to *demand node* $j$

*Model*

#grid(
  columns: 2,
  align: center + top,
  column-gutter: 1fr,
  [
    $
      min quad 
      &sum_(i in I) sum_(j in J) c_(i j) x_(i j) \
      "s.t." quad
      &sum_(j in J) x_(i j) mc(=) k_i    &&forall i in I quad &&"supply" \
      &sum_(i in I) x_(i j) mc(lt.eq) d_j &&forall j in J quad &&"demand" \
      &x_(i j) gt.eq 0 forall i in I, j in J \
    $
  ],
  [
    $
      min quad 
      &c_(1 1) x_(1 1) + c_(1 2) x_(1 2) + c_(1 3) x_(1 3) + \
      &c_(2 1) x_(2 1) + c_(2 2) x_(2 2) + c_(2 3) x_(2 3) + \
      &c_(3 1) x_(3 1) + c_(3 2) x_(3 2) + c_(3 3) x_(3 3) + \
      &c_(4 1) x_(4 1) + c_(4 2) x_(4 2) + c_(4 3) x_(4 3) \
      \
      "s.t." 
      \
      &cases(
        reverse: #true, gap: #0.75em,
        &x_(1 1) + x_(1 2) + x_(1 3) mc(=) k_1,
        &x_(2 1) + x_(2 2) + x_(2 3) mc(=) k_2,
        &x_(3 1) + x_(3 2) + x_(3 3) mc(=) k_3,
        &x_(4 1) + x_(4 2) + x_(4 3) mc(=) k_4,
      ) quad "supply"
      \
      &cases(
        reverse: #true, gap: #0.75em,
        &x_(1 1) + x_(2 1) + x_(3 1) + x_(4 1) mc(lt.eq) d_1,
        &x_(1 2) + x_(2 2) + x_(3 2) + x_(4 2) mc(lt.eq) d_2,
        &x_(1 3) + x_(2 3) + x_(3 3) + x_(4 3) mc(lt.eq) d_3,
      ) quad "demand"
      \
      &x_(1 1), x_(1 2), x_(1 3), \ 
      &x_(2 1), x_(2 2), x_(2 3), \ 
      &x_(3 1), x_(3 2), x_(3 3), \ 
      &x_(4 1), x_(4 2), x_(4 3) gt.eq 0 \ 
    $
  ]
)

*Code*

See `problem_4.py`.

*Solution*

#let results = toml("code/results/problem_4.toml")

#let objective = results.summary.objective

#table(
  columns: 2,
  fill: (x, y) => if x == 0 and y == 0 { luma(222) },
  [Objective], [#objective],
)

#figure(
  table(
    columns: 6,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Variable*], [*Value*], [*Reduced\ Cost*], [*Objective\ Coef*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.variables.map(row => row.values().map(val => [#val])).flatten(),
  ),
  caption: [Variables]
)

#figure(
  table(
    columns: 8,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Name*], [*Sense*], [*Value*], [*Shadow\ Price*], [*RHS*], [*Slack*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.constraints.map(row => row.values().map(val => [#val])).flatten()
  ),
  caption: [Constraints]
)

#figure(
  table(
    columns: 2,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Edge*], [*Cost*]),
    ..results.summary.c.pairs().flatten().map(v => [#v]),
  ),
  caption: [Cost]
)

2. 

Check the allowable range. The change is -10 and the allowable decrease is 20. Since 10 ≤ 20, the current basis stays optimal. Use the shadow price to get the cost change. The shadow price of -20 means each extra ton of Durham demand lowers total cost by \$20. That happens because each ton Durham takes can be shipped there cheaply instead of somewhere more expensive. Going the other way, removing 10 tons raises cost:

$
  Delta "Cost" = (-20) x (-10) = 200
$

The routes and basis don't change, but the shipment amounts and the cost do. New total cost (\$14,300) and the new shipments (Charlotte → Richmond 80, Charlotte → Durham 10).

3. 

Lexington's shadow price is \$70 and holds for up to 20 extra tons, so each added ton serves one more ton of Richmond's unmet demand at \$70 of extra shipping cost. Raleigh is cheaper at \$60 per ton (also up to 20 tons), and Charlotte matches Lexington at \$70 but holds for 50 tons, enough to cover Richmond's whole shortfall. So the numbers argue against the board's choice: add capacity at Raleigh first, then Charlotte, and avoid Danville at \$90.

= Problem 5

#align(center)[
  #let dx = 3
  #let dy = 1.5

  #let C  = ((8000, 10000), (8800, 11000), (9680, 12100))
  #let H  = ((400, 500), (440, 550), (484, 605))
  #let D  = ((1200, 380), (2500, 1500), (1800, 1200))
  #let K  = (4000, 3500, 2000)
  #let Y0 = (100, 80)
  #let E  = (300, 200)

  #diagram(
    node-shape: circle,
    node-stroke: 0.5pt,
    {
      let e(a, b, c, p: 0.5) = edge(a, b, "-|>", text(size: 8pt, str(c)), label-pos: p, label-side: center, label-fill: white)
      let t(s) = text(size: 8pt, s)

      for (m, name) in ("A", "B").enumerate() {
        let r = m * 2 * dy
        let off = if m == 0 { -0.8 } else { 0.8 }

        node((0, r), t(str(Y0.at(m))), stroke: none, name: label(name + "0"))
        node((4 * dx, r), t[$gt.eq$ #E.at(m)], stroke: none, name: label(name + "E"))
        edge(label(name + "0"), label(name + "1"), "-|>")

        for j in range(3) {
          let n = label(name + str(j + 1))
          node(((j + 1) * dx, r), $#(name)_#(j + 1)$, name: n)
          node(((j + 1) * dx, r + off), t(str(D.at(j).at(m))), stroke: none, name: label("d" + name + str(j + 1)))
          edge(n, label("d" + name + str(j + 1)), "-|>")
          let to = if j < 2 { label(name + str(j + 2)) } else { label(name + "E") }
          e(n, to, H.at(j).at(m))
        }
      }

      for j in range(3) {
        let p = label("P" + str(j + 1))
        node(((j + 1) * dx, dy), $P_#(j + 1)$, name: p)
        node(((j + 1) * dx - 0.8, dy), t(str(K.at(j))), stroke: none)
        e(p, label("A" + str(j + 1)), C.at(j).at(0))
        e(p, label("B" + str(j + 1)), C.at(j).at(1))
      }
    },
  )
]

#table(
  columns: 8,
  inset: 0.5em,
  fill: (x, y) => if y == 0 { luma(222) },
  [*Quarter*], [*Production cost\ A21*], [*Production cost\ B32*], [*Holding cost\ A21*], [*Holding cost\ B32*], [*Demand\ A21*], [*Demand\ B32*], [*Capacity*], 
  [1], [8000], [10000], [400], [500], [1200], [380], [4000], 
  [2], [8800], [11000], [440], [550], [2500], [1500], [3500], 
  [3], [9680], [12100], [484], [605], [1800], [1200], [2000], 
)

*Sets*

- $I = {1, 2}$: set of *boat models*
- $J = {1, 2, 3}$: set of *quarters*

*Indices*

- $i in I$
- $j in J$

*Parameters*

$y^0_i$: *starting inventory* of model $i$

$
  Y_0 = vec(
    100,
    80,
  )
$

- $h_(i j)$: *holding cost* of model $i$ produced in *quarter* $j$

$
  H = mat(
    400, 500;
    440, 550;
    484, 605;
  )
$

- $c_(i j)$: production *cost* of model $i$ produced in *quarter* $j$

$
  C = mat(
    8000, 10000;
    8800, 11000;
    9680, 12100;
  )
$

- $d_(i j)$: *demand* for model $i$ in *quarter* $j$

$
  D = mat(
    1200, 380;
    2500, 1500;
    1800, 1200;
  )
$

- $k_j$: production *capacity* in quarter $j$

$
  K = vec(
    4000,
    3500,
    2000,
  )
$

- $e_i$: end inventory for model $i$

$
  E = vec(
    300,
    200,
  )
$

*Decision Variables*

- $x_(i j)$: number of units of *boat model* $i$ to produce in *quarter* $j$
- $y_(i j)$: *inventory* of boats $i$ at the end of *quarter* $j$

*Model*

#grid(
  columns: 2,
  align: center + top,
  column-gutter: 1fr,
  [
    $
      min quad & sum_(i in I) sum_(j in J) (c_(i j) x_(i j) + mc(h_(i j) y_(i j))) \
      "s.t." quad
      & y_(i j) = y_(i, j-1) + x_(i j) - d_(i j) quad && forall i in I, j in J quad && "balance" \
      & sum_(i in I) x_(i j) lt.eq k_j quad && forall j in J quad && "capacity" \
      & y_(i 3) gt.eq e_i quad && forall i in I quad && "end inventory" \
      & y_(i 0) = y^0_i quad && forall i in I quad && "initial inventory" \
      & x_(i j), y_(i j) gt.eq 0 quad && forall i in I, j in J
    $
  ],
  [
    $
      min quad
      &x_(1 1) c_(1 1) + x_(1 2) c_(1 2) + x_(1 3) c_(1 3) + \
      &x_(2 1) c_(2 1) + x_(2 2) c_(2 2) + x_(2 3) c_(2 3) + \
      mc(
        &y_(1 1) h_(1 1) + y_(1 2) h_(1 2) + y_(1 3) h_(1 3) + \
        &y_(2 1) h_(2 1) + y_(2 2) h_(2 2) + y_(2 3) h_(2 3) \
      )
      "s.t." quad
      \
      &cases(
        reverse: #true, gap: #0.75em,
        y_(1 1) = y^0_1 + x_(1 1) - d_(1 1),
        y_(1 2) = y_(1 1) + x_(1 2) - d_(1 2),
        y_(1 3) = y_(1 2) + x_(1 3) - d_(1 3),
        ,
        y_(2 1) = y^0_2 + x_(2 1) - d_(2 1),
        y_(2 2) = y_(2 1) + x_(2 2) - d_(2 2),
        y_(2 3) = y_(2 2) + x_(2 3) - d_(2 3),
      ) quad "balance" 
      \
      &cases(
        reverse: #true, gap: #0.75em,
        x_(1 1) + x_(2 1) lt.eq k_1,
        x_(1 2) + x_(2 2) lt.eq k_2,
        x_(1 3) + x_(2 3) lt.eq k_3,
      ) quad "capacity" 
      \
      &cases(
        reverse: #true, gap: #0.75em,
        y_(1 2) + x_(1 3) - d_(1 3) gt.eq e_1,
        y_(2 2) + x_(2 3) - d_(2 3) gt.eq e_2,
      ) quad "end inventory"
      \
      \
      &x_(1 1), x_(1 2), x_(1 3), \
      &x_(2 1), x_(2 2), x_(2 3) gt.eq 0
      \
      &y_(1 1), y_(1 2), y_(1 3), \
      &y_(2 1), y_(2 2), y_(2 3) gt.eq 0
    $
  ]
)

*Code*

See `problem_5.py`.

*Solution*

#let results = toml("code/results/problem_5.toml")

#let objective = results.summary.objective

#table(
  columns: 2,
  fill: (x, y) => if x == 0 and y == 0 { luma(222) },
  [Objective], [#objective],
)

#figure(
  table(
    columns: 6,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Variable*], [*Value*], [*Reduced\ Cost*], [*Objective\ Coef*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.variables.map(row => row.values().map(val => [#val])).flatten(),
  ),
  caption: [Variables]
)

#figure(
  table(
    columns: 8,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Name*], [*Sense*], [*Value*], [*Shadow\ Price*], [*RHS*], [*Slack*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.constraints.map(row => row.values().map(val => [#val])).flatten()
  ),
  caption: [Constraints]
)

#let s = results.summary
#let by-quarter(M) = M.enumerate().map(((j, r)) => ([Q#(j + 1)], ..r.map(v => [#v]))).flatten()

#figure(
  table(
    columns: 3,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Quarter*], [*A21*], [*B32*]),
    ..by-quarter(s.C_jm),
  ),
  caption: [Production cost],
)

#figure(
  table(
    columns: 5,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Quarter*], [*Produce A21*], [*Produce B32*], [*Inventory A21*], [*Inventory B32*]),
    ..s.production_jm.zip(s.inventory_jm).enumerate().map(((j, (p, y))) =>
      ([Q#(j + 1)], ..(p + y).map(v => [#v]))).flatten(),
  ),
  caption: [Production plan],
)

= Problem 6

#align(center)[
  #let dx = 6
  #let dy = 3

  #diagram(
    node-shape: circle,
    node-stroke: 0.5pt,
    {
      let e(a, b, c, p) = edge(a, b, "-|>", text(size: 8pt, str(c)), label-pos: p, label-side: center, label-fill: white)

      let row(i) = (i + 1) * dy
      let rrow(j) = j * dy

      for (i, s) in ("93", "88", "95").enumerate() {
        node((0, row(i)), $W_#(i + 1)$, name: label("W" + str(i + 1)))
        node((-0.7, row(i)), s, stroke: none)
        node((dx, row(i)), $P_#(i + 1)$, name: label("P" + str(i + 1)))
      }

      for (j, s) in ("30", "57", "48", "91", "48").enumerate() {
        node((2 * dx, rrow(j)), $R_#(j + 1)$, name: label("R" + str(j + 1)))
        node((2 * dx+0.7, rrow(j)), s, stroke: none)
      }

      e(<W1>, <P1>, 1.52, 0.5)
      e(<W1>, <P2>, 1.60, 0.25)
      e(<W1>, <P3>, 1.40, 0.25)

      e(<W2>, <P1>, 1.70, 0.75)
      e(<W2>, <P2>, 1.63, 0.25)
      e(<W2>, <P3>, 1.55, 0.75)

      e(<W3>, <P1>, 1.45, 0.25)
      e(<W3>, <P2>, 1.57, 0.25)
      e(<W3>, <P3>, 1.30, 0.5)

      e(<P1>, <R1>, 5.15, 0.5)
      e(<P1>, <R2>, 5.69, 0.25)
      e(<P1>, <R3>, 6.13, 0.25)
      e(<P1>, <R4>, 5.63, 0.75)
      e(<P1>, <R5>, 5.80, 0.75)

      e(<P2>, <R1>, 5.12, 0.75)
      e(<P2>, <R2>, 5.47, 0.75)
      e(<P2>, <R3>, 6.05, 0.75)
      e(<P2>, <R4>, 6.12, 0.75)
      e(<P2>, <R5>, 5.71, 0.75)

      e(<P3>, <R1>, 5.32, 0.75)
      e(<P3>, <R2>, 6.16, 0.75)
      e(<P3>, <R3>, 6.25, 0.25)
      e(<P3>, <R4>, 6.17, 0.25)
      e(<P3>, <R5>, 5.87, 0.5)
    },
  )
]

*Sets*

- $I = {1, 2, 3}$
- $J = {1, 2, 3}$
- $K = {1, 2, 3, 4, 5}$

*Indices*

- $i in I$: set of *wells*
- $j in J$: set of *pumps*
- $k in K$: set of *refineries*

*Parameters*

- $c_(i j)$: cost of transport from well $i$ to pump $j$

$
  C^(I J) = mat(
    1.52, 1.60, 1.40;
    1.70, 1.63, 1.55;
    1.45, 1.57, 1.30;
  )
$

- $c_(j k)$: cost of transport from pump $j$ to refineries $k$

$
  C^(J K) = mat(
    5.15, 5.69, 6.13, 5.63, 5.80;
    5.12, 5.47, 6.05, 6.12, 5.71;
    5.32, 6.16, 6.25, 6.17, 5.87;
  )
$

- $S_i$: supply at well $i$

$
  S = vec(
    93,
    88,
    95,
  )
$

$
  D = vec(
    30,
    57,
    48,
    91,
    48,
  )
$

*Decision Variables*

- $x_(i j)$: quantity flowing from well $i$ to pump $j$
- $y_(j k)$: quantity flowing from pump $j$ to refinery $k$

*Model*

#grid(
  columns: 2,
  column-gutter: 3em,
  align: center,
  [
    $
      min quad 
      &sum_(i in I) sum_(j in J) c_(i j) x_(i j) + sum_(j in J) sum_(k in K) c_(j k) y_(j k) \
      "s.t." quad 
      &sum_(j in J) x_(i j) lt.eq S_i &&forall i in I quad &&"supply" \
      &sum_(j in J) y_(j k) = D_k &&forall k in K quad &&"demand" \
      &sum_(i in I) x_(i j) = sum_(k in K) y_(j k) &&forall j in J quad &&"conservation" \
      &x_(i j) gt.eq 0 \
      &y_(j k) gt.eq 0 \
    $
  ],
  [
    $
      min quad 
      &c_(1 1) x_(1 1) + c_(1 2) x_(1 2) + \
      &c_(2 1) x_(2 1) + c_(2 2) x_(2 2) + \
      &c_(3 1) x_(3 1) + c_(3 2) x_(3 2) + \
      &c_(1 1) y_(1 1) + c_(1 2) y_(1 2) + c_(1 3) y_(1 3) + \
      &c_(2 1) y_(2 1) + c_(2 2) y_(2 2) + c_(2 3) y_(2 3) \
      \
      "s.t."
      \
      &cases(
        reverse: #true, gap: #0.75em,
        &x_(1 1) + x_(1 2) lt.eq S_1,
        &x_(2 1) + x_(2 2) lt.eq S_2,
        &x_(3 1) + x_(3 2) lt.eq S_3,
      ) quad "supply"
      \
      &cases(
        reverse: #true, gap: #0.75em,
        &y_(1 1) + y_(2 1) = D_1,
        &y_(1 2) + y_(2 2) = D_2,
        &y_(1 3) + y_(2 3) = D_3,
      ) quad "demand"
      \
      &cases(
        reverse: #true, gap: #0.75em,
        &x_(1 1) + x_(2 1) + x_(3 1) = y_(1 1) + y_(1 2) + y_(1 3),
        &x_(1 2) + x_(2 2) + x_(3 2) = y_(2 1) + y_(2 2) + y_(2 3),
      ) quad "conservation"
      \
      &x_(1 1), x_(1 2), \
      &x_(2 1), x_(2 2), \
      &x_(3 1), x_(3 2) gt.eq 0 \
      \
      &y_(1 1), y_(1 2), y_(1 3), \
      &y_(2 1), y_(2 2), y_(2 3) gt.eq 0 \
    $
  ]
)

*Code*

See `problem_6.py`.

*Solution*

#let results = toml("code/results/problem_6.toml")

#let objective = results.summary.objective

#table(
  columns: 2,
  fill: (x, y) => if x == 0 and y == 0 { luma(222) },
  [Objective], [#objective],
)

#figure(
  table(
    columns: 6,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Variable*], [*Value*], [*Reduced\ Cost*], [*Objective\ Coef*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.variables.map(row => row.values().map(val => [#val])).flatten(),
  ),
  caption: [Variables]
)

#figure(
  table(
    columns: 7,
    table.header([*Name*], [*Value*], [*Shadow\ Price*], [*RHS*], [*Slack*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.constraints.map(c => (
      c.name, c.value, c.shadow_price, c.rhs, c.slack, c.allow_increase, c.allow_decrease,
    ).map(v => [#v])).flatten()
  ),
  caption: [Constraints]
)

#figure(
  table(
    columns: 2,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Edge*], [*Cost*]),
    ..results.summary.C_ij.enumerate().map(((i, row)) =>
      row.enumerate().map(((j, v)) => ([x[#i,#j]], [#v]))
    ).flatten(),
    ..results.summary.C_jk.enumerate().map(((j, row)) =>
      row.enumerate().map(((k, v)) => ([y[#j,#k]], [#v]))
    ).flatten(),
  ),
  caption: [Cost]
)

Add the capacity to Well 3. Each extra TBD there replaces more expensive oil from Well 2 with cheaper oil from Well 3.

How much it's worth investing:

- Up to \$0.13 per TBD of new capacity, in the same cost units as the tariffs.
- That rate holds for up to 29 TBD of extra capacity (the allowable increase), so Well 3 can go up to 124 TBD.
- At most, that adds up to 29 x \$0.13 = \$3.77 in total savings. That is the most we should pay, in the same per-day units as the tariffs.

= Problem 7

#align(center)[
  #let dx = 4
  #let dy = 2
  #let gap = 0.6

  #diagram(
    node-shape: circle,
    node-stroke: 0.5pt,
    {
      let e(a, b, c, p) = edge(a, b, "-|>", text(size: 8pt, str(c)), label-pos: p, label-side: center, label-fill: white)

      node((0, dy * 0.5), [1], name: <N1>)
      node((0, dy * 1.5), [2], name: <N2>)

      node((dx, 0),      [3], name: <N3>)
      node((dx, dy),     [4], name: <N4>)
      node((dx, 2 * dy), [5], name: <N5>)
      
      node((2 * dx, 0),      [6], name: <N6>)
      node((2 * dx, dy),     [7], name: <N7>)
      node((2 * dx, 2 * dy), [8], name: <N8>)

      node((-0.7, dy * 0.5), [300], stroke: none)
      node((-0.7, dy * 1.5), [300], stroke: none)
      node((2 * dx + 0.7, 0),      [200], stroke: none)
      node((2 * dx + 0.7, dy),     [100], stroke: none)
      node((2 * dx + 0.7, 2 * dy), [300], stroke: none)

      e(<N1>, <N3>, 16, 0.3)
      e(<N1>, <N4>, 10, 0.3)
      e(<N1>, <N5>, 12, 0.7)
      e(<N2>, <N3>, 15, 0.7)
      e(<N2>, <N4>, 14, 0.3)
      e(<N2>, <N5>, 17, 0.3)

      e(<N3>, <N6>, 6,  0.5)
      e(<N3>, <N7>, 8,  0.3)
      e(<N3>, <N8>, 10, 0.2)
      e(<N4>, <N6>, 7,  0.75)
      e(<N4>, <N7>, 11, 0.75)
      e(<N4>, <N8>, 11, 0.75)
      e(<N5>, <N6>, 4,  0.2)
      e(<N5>, <N7>, 5,  0.3)
      e(<N5>, <N8>, 12, 0.5)
    },
  )
]


*Sets*

- $I = {1, 2}$
- $J = {3, 4, 5}$
- $K = {6, 7, 8}$

*Indices*

- $i in I$
- $j in J$
- $k in K$

*Parameters*

- $c_(i j k) = c_(i j) + c_(j k)$: unit cost of shipping from supplier $i$ through transshipment node $j$ to demand node $k$

$
  C^(I J) = mat(
    16, 10, 12;
    15, 14, 17
  )
  quad
  C^(J K) = mat(
    6, 8, 10;
    7, 11, 11;
    4, 5, 12
  )
$

- $S_i$: supply of source node $i$

$
  S = vec(
    300,
    300
  )
$

- $D_k$: demand of sink node $k$

$
  D = vec(
    200,
    100,
    300,
  )
$

*Decision Variables*

- $x_(i j k)$: quantity from supplier $i$ to $k$ going through $j$

*Model*

#grid(
  columns: 2,
  align: center + top,
  column-gutter: 1fr,
  row-gutter: 5em,
  grid.cell(colspan: 2, [*Old Model* ($x_(i j), y_(j k)$)]),
    [
    $
      min quad
      &sum_(i in I) sum_(j in J) c_(i j) x_(i j) + sum_(j in J) sum_(k in K) c_(j k) y_(j k) \
      "s.t." quad
      &sum_(j in J) x_(i j) lt.eq S_i quad &&forall i in I quad &&"supply" \
      &sum_(j in J) y_(j k) gt.eq D_k quad &&forall k in K quad &&"demand" \
      &sum_(i in I) x_(i j) = sum_(k in K) y_(j k) &&forall j in J quad &&"conservation" \
      &x_(i j) gt.eq 0 &&forall i in I, j in J quad &&"non-negativity" \
      &y_(j k) gt.eq 0 &&forall j in J, k in K quad &&"non-negativity" \
    $
  ],
  [
    $
      min quad
      &c_(13) x_(13) + c_(14) x_(14) + c_(15) x_(15) + \
      &c_(23) x_(23) + c_(24) x_(24) + c_(25) x_(25) + \
      &c_(36) x_(36) + c_(37) x_(37) + c_(38) x_(38) + \
      &c_(46) x_(46) + c_(47) x_(47) + c_(48) x_(48) + \
      &c_(56) x_(56) + c_(57) x_(57) + c_(58) x_(58) \
      \
      "s.t."
      \
      &cases(
        reverse: #true, gap: #0.75em,
        x_(13) + x_(14) + x_(15) lt.eq S_1,
        x_(23) + x_(24) + x_(25) lt.eq S_2,
      ) quad "supply"
      \
      &cases(
        reverse: #true, gap: #0.75em,
        y_(36) + y_(46) + y_(56) gt.eq D_6,
        y_(37) + y_(47) + y_(57) gt.eq D_7,
        y_(38) + y_(48) + y_(58) gt.eq D_8,
      ) quad "demand"
      \
      &cases(
        reverse: #true, gap: #0.75em,
        x_(13) + x_(23) = y_(36) + y_(37) + y_(38),
        x_(14) + x_(24) = y_(46) + y_(47) + y_(48),
        x_(15) + x_(25) = y_(56) + y_(57) + y_(58),
      ) quad "conservation"
      \
      &x_(13), x_(14), x_(15), x_(23), x_(24), x_(25) gt.eq 0 \
      \
      &y_(36), y_(37), y_(38), y_(46), y_(47), y_(48), y_(56), y_(57), y_(58) gt.eq 0
    $
  ],
  grid.cell(colspan: 2, [*New Model* ($x_(i j k)$)]),
  [
    $
      min quad
      &sum_(i in I) sum_(j in J) sum_(k in K) (c_(i j) + c_(j k)&&) x_(i j k) \
      "s.t." quad
      &sum_(j in J) sum_(k in K) x_(i j k) lt.eq S_i quad &&forall i in I quad &&"supply" \
      &sum_(i in I) sum_(j in J) x_(i j k) gt.eq D_k quad &&forall k in K quad &&"demand" \
      &x_(i j k) gt.eq 0 &&forall i in I, j in J, k in K
    $
  ],
  [
    $
      min quad
      &(c_(13) + c_(36)) x_(136) + (c_(13) + c_(37)) x_(137) + (c_(13) + c_(38)) x_(138) + \
      &(c_(14) + c_(46)) x_(146) + (c_(14) + c_(47)) x_(147) + (c_(14) + c_(48)) x_(148) + \
      &(c_(15) + c_(56)) x_(156) + (c_(15) + c_(57)) x_(157) + (c_(15) + c_(58)) x_(158) + \
      &(c_(23) + c_(36)) x_(236) + (c_(23) + c_(37)) x_(237) + (c_(23) + c_(38)) x_(238) + \
      &(c_(24) + c_(46)) x_(246) + (c_(24) + c_(47)) x_(247) + (c_(24) + c_(48)) x_(248) + \
      &(c_(25) + c_(56)) x_(256) + (c_(25) + c_(57)) x_(257) + (c_(25) + c_(58)) x_(258) \
      \
      "s.t." quad
      \
      &cases(
        reverse: #true, gap: #0.75em,
        &x_(136) + x_(137) + x_(138) + x_(146) + x_(147) +, 
        &x_(148) + x_(156) + x_(157) + x_(158) lt.eq S_1,
        &x_(236) + x_(237) + x_(238) + x_(246) + x_(247) +,
        &x_(248) + x_(256) + x_(257) + x_(258) lt.eq S_2,
      ) quad "supply"
      \
      &cases(
        reverse: #true, gap: #0.75em,
        x_(136) + x_(146) + x_(156) + x_(236) + x_(246) + x_(256) gt.eq D_6,
        x_(137) + x_(147) + x_(157) + x_(237) + x_(247) + x_(257) gt.eq D_7,
        x_(138) + x_(148) + x_(158) + x_(238) + x_(248) + x_(258) gt.eq D_8,
      ) quad "demand"
      \
      &x_(136), x_(137), x_(138), x_(146), x_(147), x_(148), x_(156), x_(157), x_(158), \
      &x_(236), x_(237), x_(238), x_(246), x_(247), x_(248), x_(256), x_(257), x_(258) gt.eq 0 
    $
  ]
)

*Code*

See `problem_7.py`.

*Solution*


#let results = toml("code/results/problem_7.toml")

#let objective = results.summary.objective

#table(
  columns: 2,
  fill: (x, y) => if x == 0 and y == 0 { luma(222) },
  [Objective], [#objective],
)

#figure(
  table(
    columns: 6,
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Variable*], [*Value*], [*Reduced\ Cost*], [*Objective\ Coef*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.variables.map(row => row.values().map(val => [#val])).flatten(),
  ),
  caption: [Variables]
)

#figure(
  table(
    columns: 7,
    table.header([*Name*], [*Value*], [*Shadow\ Price*], [*RHS*], [*Slack*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.constraints.map(c => (
      c.name, c.value, c.shadow_price, c.rhs, c.slack, c.allow_increase, c.allow_decrease,
    ).map(v => [#v])).flatten()
  ),
  caption: [Constraints]
)

#figure(
  table(
    columns: 4,
    align: (left, right, right, right),
    fill: (x, y) => if y == 0 { luma(222) },
    table.header([*Path*], [$k=0$], [$k=1$], [$k=2$]),
    ..results.summary.C_ijk.enumerate().map(((i, M)) =>
      M.enumerate().map(((j, row)) =>
        ([x[#i,#j,·]], ..row.map(v => [#v]))
      )
    ).flatten(),
  ),
  caption: [Path costs $c_(i j k)$],
)

= Appendix

== Problem 1

```py
import numpy as np
import gurobipy as gp
from gurobipy import GRB

S = np.array([6, 5, 6])
D = np.array([4, 8, 7])
M = np.array([
    [120, 180, 0],
    [300, 100, 80],
    [200, 250, 120],
])
C = 10
P = 5000

m = gp.Model("refineries")

x = m.addMVar(M.shape, lb=0, name="x")
s = m.addMVar(D.shape, name="s")

m.setObjective((C * M * x).sum() + (P * s).sum(), GRB.MINIMIZE)

m.addConstr(x.sum(axis=1) <= S, name="capacity")
m.addConstr(x.sum(axis=0) + s == D, name="demand")
m.addConstr(s[0] == 0, name="no_shortage_1")
m.addConstr(x[0, 2] == 0, name="no_arc_1_3")

m.optimize()
```

#align(center)[
  #image("./excel/p1.png", width: 80%)
]

== Problem 2

```py
import numpy as np
import gurobipy as gp
from gurobipy import GRB

S = np.array([150, 150])
R = np.array([3, 1, 2])
T = np.array([
    [0.8, 0.6],
    [0.3, 0.4],
    [0.5, 0.6],
])

m = gp.Model("products")

x = m.addMVar(T.shape, name="x")
y = m.addVar(name="y")

m.setObjective(y, GRB.MAXIMIZE)

m.addConstr(x.sum(axis=1) >= R * y, name="requirements")
m.addConstr((T * x).sum(axis=0) <= S, name="capacity")

m.optimize()
```

#align(center)[
  #image("./excel/p2.png", width: 80%)
]

== Problem 3

```py
import numpy as np
import gurobipy as gp
from gurobipy import GRB

M = np.array([1500, 1700, 1300, 2700])
P = np.array([88, 15, 105, 95])
K = 12000
E0 = 600

m = gp.Model("plane")

x = m.addMVar(M.shape, name="x")
s = m.addMVar(M.shape, name="s")
e = m.addMVar(M.shape, name="e")

m.setObjective((P * x).sum(axis=0), GRB.MINIMIZE)

m.addConstr(s[0] == e[-1] + x[0], name="balance_0")
m.addConstr(s[1:] == e[:-1] + x[1:], name="balance")
m.addConstr(s - e == M * (1 + (s + e) / 4000), name="consumption")
m.addConstr(s <= K, name="capacity")
m.addConstr(e >= E0, name="reserve")

m.optimize()
```

#align(center)[
  #image("./excel/p3.png", width: 80%)
]

== Problem 4

```py
import numpy as np
import gurobipy as gp
from gurobipy import GRB

K = np.array([90, 50, 80, 60])
D = np.array([120, 100, 110])
C = np.array([
    [70, 100, 50],
    [120, 90, 40],
    [70, 30, 110],
    [90, 50, 70],
])

m = gp.Model("steel")

m = gp.Model("steel")

x = m.addMVar(C.shape, name="x")

m.setObjective((C * x).sum(), GRB.MINIMIZE)

m.addConstr(x.sum(axis=1) == K, name="supply")
m.addConstr(x.sum(axis=0) <= D, name="demand")

m.optimize()
```

#align(center)[
  #image("./excel/p4.png", width: 80%)
]

== Problem 5

```py
import numpy as np
import gurobipy as gp
from gurobipy import GRB

H = np.array([
    [400, 500],
    [440, 550],
    [484, 605],
])
C = np.array([
    [8000, 10000],
    [8800, 11000],
    [9680, 12100],
])
D = np.array([
    [1200, 380],
    [2500, 1500],
    [1800, 1200]
])
K = np.array([
    4000,
    3500,
    2000,
])
E = np.array([
    300,
    200,
])
Y0 = np.array([100, 80])

m = gp.Model("steel_path")

x = m.addMVar(C.shape, name="x")
y = m.addMVar(H.shape, name="y")

m.setObjective((C * x + H * y).sum(), GRB.MINIMIZE)

m.addConstr(y[0] == Y0 + x[0] - D[0], name="balance_0")
m.addConstr(y[1:] == y[:-1] + x[1:] - D[1:], name="balance")
m.addConstr(x.sum(axis=1) <= K, name="capacity")
m.addConstr(y[-1] >= E, name="end_inventory")

m.optimize()
```

#align(center)[
  #image("./excel/p5.png", width: 80%)
]

== Problem 6

```py
import numpy as np
import gurobipy as gp
from gurobipy import GRB

S = np.array([93, 88, 95])
D = np.array([30, 57, 48, 91, 48])
C_ij = np.array([
    [1.52, 1.60, 1.40],
    [1.70, 1.63, 1.55],
    [1.45, 1.57, 1.30],
])
C_jk = np.array([
    [5.15, 5.69, 6.13, 5.63, 5.80],
    [5.12, 5.47, 6.05, 6.12, 5.71],
    [5.32, 6.16, 6.25, 6.17, 5.87],
])

m = gp.Model("steel")

x = m.addMVar(C_ij.shape, name="x")
y = m.addMVar(C_jk.shape, name="y")

m.setObjective((C_ij * x).sum() + (C_jk * y).sum(), GRB.MINIMIZE)

m.addConstr(x.sum(axis=1) <= S, name="supply")
m.addConstr(y.sum(axis=0) == D, name="demand")
m.addConstr(x.sum(axis=0) == y.sum(axis=1), name="balance")

m.optimize()
```

#align(center)[
  #image("./excel/p6.png", width: 80%)
]

== Problem 7

```py
import numpy as np
import gurobipy as gp
from gurobipy import GRB

S = np.array([300, 300])
D = np.array([200, 100, 300])
C_ij = np.array([
    [16, 10, 12],
    [15, 14, 17],
])
C_jk = np.array([
    [6, 8, 10],
    [7, 11, 11],
    [4, 5, 12],
])

C = C_ij[:, :, None] + C_jk[None, :, :]

m = gp.Model("steel_paths")

m.Params.OutputFlag = 0

x = m.addMVar(C.shape, name="x")

m.setObjective((C * x).sum(), GRB.MINIMIZE)

supply = m.addConstr(x.sum(axis=2).sum(axis=1) <= S, name="supply")
demand = m.addConstr(x.sum(axis=0).sum(axis=0) == D, name="demand")

m.optimize()
```

#align(center)[
  #image("./excel/p7.png", width: 80%)
]