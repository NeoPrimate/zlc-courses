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
    node((-0.5, (dy * 2)), [7], stroke: none, name: <R3s>)
    
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
      &c sum_((i, j) in A) x_(i j) mc(+ p sum_(j in J^S) s_j) \
      "s.t." quad
      &sum_(j: (i, j) in A) x_(i j) <= S_i quad &&forall i in I quad quad &&"capacity" \
      &sum_(i: (i, j) in A) x_(i j) mc(+ s_j [j in J^S]) = D_j quad &&forall j in J quad quad &&"demand" \
      &x_(i j) >= 0 quad &&forall (i, j) in A \
      &s_j >= 0 quad &&forall j in J^S
    $
  ],
  [
    $
      min quad
      &c (x_(1 1) + x_(1 2) + x_(1 3) + x_(2 1) + x_(2 2) + x_(2 3) + x_(3 1) + x_(3 2) + x_(3 3))\ 
      &mc(+ p (s_2 + s_3)) \
      "s.t." quad
      &cases(
        reverse: #true, gap: #0.75em,
        x_(1 1) + x_(1 2) + x_(1 3) &<= S_1,
        x_(2 1) + x_(2 2) + x_(2 3) &<= S_2,
        x_(3 1) + x_(3 2) + x_(3 3) &<= S_3,
      ) quad "capacity" 
      \
      &cases(
        reverse: #true, gap: #0.75em,
        x_(1 1) + x_(2 1) + x_(3 1) &= D_1,
        x_(1 2) + x_(2 2) + x_(3 2) mc(+ s_2) &= D_2,
        x_(1 3) + x_(2 3) + x_(3 3) mc(+ s_3) &= D_3,
      ) quad "demand" 
      \
      &x_(1 1), x_(1 2), x_(1 3), x_(2 1), x_(2 2), x_(2 3), x_(3 1), x_(3 2), x_(3 3) >= 0 \
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
  fill: (x, y) => if x == 0 and y == 0 { luma(210) },
  [Objective], [#objective],
)

#figure(
  table(
    columns: 6,
    fill: (x, y) => if y == 0 { luma(210) },
    table.header([*Variable*], [*Value*], [*Reduced\ Cost*], [*Objective\ Coef*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.variables.map(row => row.values().map(val => [#val])).flatten(),
  ),
  caption: [Variables]
)

#figure(
  table(
    columns: 7,
    fill: (x, y) => if y == 0 { luma(210) },
    table.header([*Name*], [*Value*], [*Shadow\ Price*], [*RHS*], [*Slack*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.constraints.map(row => row.values().map(val => [#val])).flatten()
  ),
  caption: [Constraints]
)

#figure(
  table(
    columns: 2,
    fill: (x, y) => if y == 0 { luma(210) },
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
- $x_(i j)$: how many *parts* $j$ are produced in *department* $i$

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
      "s.t." quad
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
  fill: (x, y) => if x == 0 and y == 0 { luma(210) },
  [Objective], [#objective],
)

#figure(
  table(
    columns: 6,
    fill: (x, y) => if y == 0 { luma(210) },
    table.header([*Variable*], [*Value*], [*Reduced\ Cost*], [*Objective\ Coef*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.variables.map(row => row.values().map(val => [#val])).flatten(),
  ),
  caption: [Variables]
)

#figure(
  table(
    columns: 7,
    fill: (x, y) => if y == 0 { luma(210) },
    table.header([*Name*], [*Value*], [*Shadow\ Price*], [*RHS*], [*Slack*], [*Allowable\ Increase*], [*Allowable\ Decrease*]),
    ..results.constraints.map(row => row.values().map(val => [#val])).flatten()
  ),
  caption: [Constraints]
)

= Problem 3

*Sets*



*Indices*



*Parameters*



*Decision Variables*



*Model*



*Code*



*Code*

See `problem_3.py`.

*Solution*


= Problem 4

*Sets*



*Indices*



*Parameters*



*Decision Variables*



*Model*



*Code*



*Code*

See `problem_4.py`.

*Solution*


= Problem 5

*Sets*



*Indices*



*Parameters*



*Decision Variables*



*Model*



*Code*



*Code*

See `problem_5.py`.

*Solution*


= Problem 6

#align(center)[
  #let dx = 6
  #let dy = 3

  #diagram(
    node-shape: circle,
    node-stroke: 0.5pt,
    {
      let e(a, b, c, p) = edge(a, b, "-|>", text(size: 8pt, str(c)), label-pos: p, label-side: center, label-fill: white)

      // Five R rows span 0..4dy; W and P (three rows each) are centred on 2dy
      let row(i) = (i + 1) * dy        // W/P rows: dy, 2dy, 3dy
      let rrow(j) = j * dy             // R rows: 0 .. 4dy

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
      e(<P1>, <R3>, 5.13, 0.25)
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

- $i in I$: 
- $j in J$: 
- $k in K$: 

*Parameters*

- $c_(i j)$: cost of transport from well $i$ to pump $j$

$
  C^(I J) = mat(

  )
$

- $c_(j k)$: cost of transport from well $j$ to pump $k$

$
  C^(J K) = mat(
    
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
- $y_(j k)$: quantity flowing from pump $j$ to pump $k$

*Model*

#grid(
  columns: 2,
  column-gutter: 3em,
  align: center + horizon,
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

  ]
)

*Code*

See `problem_6.py`.

*Solution*


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

- $D_k$: demand of sink node $i$

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
      &sum_(i in I) sum_(j in J) c_(i j) x_(i j) + sum_(j in J) sum_(k in K) c_(j k) x_(j k) \
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
      "s.t." quad
      &x_(13) + x_(14) + x_(15) lt.eq S_1 \
      &x_(23) + x_(24) + x_(25) lt.eq S_2 \
      \
      &y_(36) + y_(46) + y_(56) gt.eq D_6 \
      &y_(37) + y_(47) + y_(57) gt.eq D_7 \
      &y_(38) + y_(48) + y_(58) gt.eq D_8 \
      \
      &x_(13) + x_(23) = y_(36) + y_(37) + y_(38) \
      &x_(14) + x_(24) = y_(46) + y_(47) + y_(48) \
      &x_(15) + x_(25) = y_(56) + y_(57) + y_(58) \
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
      &x_(i j k) gt.eq 0 &&forall i in I, j in J, k in K quad &&"non-negativity"
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
      &x_(136) + x_(137) + x_(138) + x_(146) + x_(147) + x_(148) + x_(156) + x_(157) + x_(158) lt.eq S_1 \
      &x_(236) + x_(237) + x_(238) + x_(246) + x_(247) + x_(248) + x_(256) + x_(257) + x_(258) lt.eq S_2 \
      \
      &x_(136) + x_(146) + x_(156) + x_(236) + x_(246) + x_(256) gt.eq D_6 \
      &x_(137) + x_(147) + x_(157) + x_(237) + x_(247) + x_(257) gt.eq D_7 \
      &x_(138) + x_(148) + x_(158) + x_(238) + x_(248) + x_(258) gt.eq D_8 \
      \
      &x_(136), x_(137), x_(138), x_(146), x_(147), x_(148), x_(156), x_(157), x_(158), \
      &x_(236), x_(237), x_(238), x_(246), x_(247), x_(248), x_(256), x_(257), x_(258) gt.eq 0 
    $
  ]
)

*Code*

See `problem_7.py`.

*Solution*


