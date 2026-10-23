// #import "/lib/imports.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set text(font: "Helvetica", size: 8pt)

#let mc(x) = text(fill: red, x)

#let example(..args) = {
  let pos = args.pos()
  let (title, content) = if pos.len() >= 2 {
    (pos.at(0), pos.at(1))
  } else {
    (none, pos.at(0))
  }

  block(width: 100%, stroke: 0.5pt, inset: 8pt)[
    #if title != none [
      *#title*
      #v(4pt, weak: true)
    ]
    #content
  ]
}

= Analytical Methods

- Demand
- Capacity
- Lead Time
- Yield
- Multiple Products
- Bundling
- Discounts

#let y-offset = 0.5
#let tint(c) = (stroke: c, fill: rgb(..c.components().slice(0,3), 5%), inset: 8pt)

#diagram(
	node-corner-radius: 4pt,

	node((0,y-offset * 1), $a$, name: <a>),
	node((0,y-offset * 2), $b$, name: <b>),
	node((0,y-offset * 3), $c$, name: <c>),
	node((0,y-offset * 4), $d$, name: <d>),
	
  node((1,y-offset * 1), $1$, name: <1>),
  node((1,y-offset * 2), $2$, name: <2>),
  node((1,y-offset * 3), $3$, name: <3>),
  node((1,y-offset * 4), $4$, name: <4>),

  node(enclose: (<a>, <b>, <c>, <d>), align(top + left)[$X$], ..tint(teal), name: <X>),
  node(enclose: (<1>, <2>, <3>, <4>), align(top + right)[$Y$], ..tint(teal), name: <Y>),

  edge(<a>, <1>, "-|>"),
  edge(<b>, <2>, "-|>"),
  edge(<c>, <3>, "-|>"),
)



Exercise 1.

$
  max quad &z = (80 - 20) a + (100 - 25) b \
  s.t. quad 
  &0.2 a + 0.5 b lt.eq 60 \
  &a lt.eq 200 \
  &b lt.eq 110 \
  &a gt.eq 0  \
  &b gt.eq 0  \
$

Constraints

$
  0.2 a + 0.5 b lt.eq 60
  \ \
  a = 0 arrow.double 0.5 b = 60 arrow.double b = 120
  \ \
  b = 0 arrow.double 0.2 a = 60 arrow.double a = 300
$

Objective function

$
  60 a + 75 b
  \ \
  a = 0 arrow.double
  \ \
  b = 0 arrow.double
$

1. Define decision variables
2. Define objective function
3. Define constraints

Assumptions:
- Linearity
- Divisibility (fractional $eq.not$ whole number)
- Certainty (parameters non stochastic)
- Non-negativity

== Diet Problem

Value ($a_i$)
#table(
  columns: 5,
  [], [Vitamine], [Protein], [Calcium], [Fat], 
  [Corn], [8], [5], [6], [8], 
  [Beef], [2], [5], [10], [8], 
  [Soy], [6], [12], [6], [4], 
  [Fish], [8], [18], [6], [5], 
)

Bounds ($L_j, U_j$)
- Vitamine:
  - Min: 60
  - Max: N.A
- Protein:
  - Min: 300
  - Max: N.A
- Calcium:
  - Min: 70
  - Max: N.A
- Fat:
  - Min: 40
  - Max: 200

Availability ($s_i$):
- Corn: 10
- Beef: 6
- Soy: 4
- Fish: 5

Cost ($c_i$)
- Corn: 60 c
- Beef: 400c
- Soy 75 c
- Fish: 350 c

Notation

- Ingredients: $i in I$
- Nutrients: $j in J$

Decision variables

- $x_i$: kgs of ingredient $i$ in the meal


$
  min quad & sum_(i in I) c_i x_i  \
  s.t. quad
  & x_i lt.eq s_i &quad quad forall i in I\
  & sum_(i in I) a_(i j) x_i gt.eq L_j &quad quad forall j in J \
  & sum_(i in I) a_(i j) x_i lt.eq U_j &quad quad forall j in J \
  & x_i gt.eq 0 &quad quad forall i in I \
$

== Scheduling Problem

Requirements 

- 12-4: 5
- 4-8: 7
- 8-12: 15
- 12-4: 8
- 4-8: 12
- 8-12: 8

8 Consecutive hours

Minimum number of officers to cover all shifts

Shifts:

- 1: 12-8
- 2: 4-12
- 3: 8-4
- 4: 12-8
- 5: 4-12
- 6: 8-4

$x_i$: number of employees assigned to shift $i$

$
  min quad &z = sum_(i = 1)^6 x_i \
  s.t. quad
  & x_i gt.eq s_i \
  & x_1 + x_6 gt.eq 5 \
  & x_1 + x_2 gt.eq 7 \
  & x_2 + x_3 gt.eq 15 \
  & x_3 + x_4 gt.eq 8 \
  & x_4 + x_5 gt.eq 12 \
  & x_5 + x_6 gt.eq 9 \
  &x_i gt.eq 0, quad forall i in {1, 2, dots, 6} \
$

=== Compact Form

- $L_j$: \# of peple needed during time period $j$ ($j = 1, dots, 6$)

$
  L = vec(5, 7, 18, 8, 12, 9)
$

- $T_(i j) = cases(
  1 quad "if work shift" i "covers period" j,
  0 quad "otherwise"
)$

$
  T = mat(
    0, 1, 0, 0, 0, 1;
    1, 1, 0, 0, 0, 0;
    0, 1, 1, 0, 0, 0;
    0, 0, 1, 1, 0, 0;
    0, 0, 0, 1, 1, 0;
    0, 0, 0, 0, 1, 1;
  )
$

$
  min quad 
  &z = sum_(i=1)^6 x_i \
  s.t. quad
  &sum_(i=1)^6 T_(i j) dot x_i gt.eq L_j quad forall j in {1, dots, 6} \
  &x_i gt.eq 0, quad forall i in {1, dots, 6}
$

== Dynamic Pricing

#table(
  columns: 6,
  [Price Levels ($p$)], [60], [54], [48], [36], [25], 
  [Demand Multiplier], [1], [1.5], [1.75], [2], [inf],
  [Weekly Demand ($d$)], [100], [150], [175], [200], [inf], 
)

- $x_i$: \# of weeks during which I charge a price level $i$
  - $x_60$: \# of weeks during which I charge a price level \$$60$
  - $x_54$: \# of weeks during which I charge a price level \$$54$
  - $x_48$: \# of weeks during which I charge a price level \$$48$
  - $x_36$: \# of weeks during which I charge a price level \$$36$
  - $x_s$: \# of units salvaged
- $p_i$: Price
- $d_i$: Demand associated with price $i$
- $D$: Total demand (2500)
- $W$: \# of weeks (15)

$
  max quad 
  &z = sum_(i=1)^4 underbrace(p_i, "price") dot underbrace(x_i dot d_i, "sales") + underbrace(x_s dot s, "salvage") \
  s.t. quad
  &sum_(i=1)^5 x_i lt.eq W \
  &sum_(i=1)^5 d_i x_i lt.eq D \
  &x_i gt.eq 0 quad forall i in {1, dots, 5} \
$

== Network Flow Problems

=== Transportation

Data:
- Price
- Shipping cost
- Demand
- Route capacity

Decision Variables: units sent from node $i$ to node $j$

Objective: Max profit / Min Cost

Constraint: Supply, demand, route capacity

#table(
  columns: 4,
  inset: 1em,
  [], [*DC1*], [*DC2*], [*DC3*],
  [*Factory A*], [4], [6], [4],
  [*Factory B*], [6], [5], [2],
)

D.V.: $x_(i j)$: number of units shipped from plant $i$ to DC $j$

Params: $c_(i j)$: unit cost of shipment from $i$ to $j$

Constraints:
- Supply ($S$): 70
- Demand ($D$): 40
- Route capacity ($U_(i j)$): route capacity on link $i$ to $j$

$
  min quad 
  &z = sum_(i=1)^(m) sum_(j=1)^(n) c_(i j) x_(i j) \
  s.t. quad
  &sum_(j=1)^(n) x_(i j) lt.eq s_i quad forall i in {1, dots, m} \
  &sum_(i=1)^(m) x_(i j) gt.eq d_i quad forall j in {1, dots, n } \
  &x_(i j) lt.eq U_(i j) \
  &x_(i j) gt.eq 0, quad forall i in {1, 2} and j in {1, 2, 3}
  & 
$

Feasibility check

$S_"total" > D_"total"$

Balanced transportation problem:

$
  sum_(i=1)^m s_i = sum_(j=1)^n d_j
$

Therefore:

$
  min quad 
  &z = sum_(i=1)^(m) sum_(j=1)^(n) c_(i j) x_(i j) \
  s.t. quad
  &sum_(j=1)^(n) x_(i j) = s_i quad forall i in {1, dots, m} \
  &sum_(i=1)^(m) x_(i j) = d_i quad forall j in {1, dots, n } \
  &x_(i j) lt.eq U_(i j) \
  &x_(i j) gt.eq 0, quad forall i in {1, 2} and j in {1, 2, 3}
$

Transforming Unbalanced to Balanced: Dummy node

=== Assignment

Special Case of Transportation Problem

Supply and Demand = 1

Time requirement to setup each machine for completing each job:

#table(
  columns: 5,
  [], [Job 1], [Job 2], [Job 3], [Job 4], 
  [Machine 1], [14], [5], [8], [7], 
  [Machine 2], [2], [12], [6], [5], 
  [Machine 3], [7], [8], [3], [9], 
  [Machine 4], [2], [4], [6], [10], 
)

Decision variable: 
$
  x_(i j) = cases(
    1 quad "if machine" i "does job" j,
    0 quad "otherwise"
  )
$

- $m$: number of jobs
- $n$: number of machines

$
  min quad 
  &z = sum_(i=1)^n sum_(j=1)^m t_(i j) x_(i j) \
  s.t. quad
  &sum_(j=1)^m x_(i j) = 1 quad forall i in {1, dots, n} \
  &sum_(i=1)^n x_(i j) = 1 quad forall j in {1, dots, m} \
  &x_(i j) gt.eq 0 quad forall i in {1, dots, n} and j in {1, dots, m} \
$

#example[

  #let swimmers = ("ca", "ch", "da", "ke") // Carl, Chris, David, Ken
  #let strokes  = ("ba", "br", "bu", "fr") // back, breast, butterfly, free

  #let times = (
    (37.7, 43.3, 33.3, 29.2),
    (32.9, 33.1, 28.5, 26.4),
    (33.8, 42.2, 38.9, 29.6),
    (34.4, 41.8, 33.6, 31.1),
  )

  = Swimmer assignment problem

  Each swimmer swims exactly one stroke, and each stroke is swum by exactly one
  swimmer. We want to minimise the total relay time.

  == Data

  $
    t = mat(..#times.map(row => row.map(t => [#t]))) \
    "rows: " "ca", "ch", "da", "ke" \
    "cols: " "ba", "br", "bu", "fr" \
  $

  == Decision variables

  $
    x_(i j) = cases(
      1 quad "if swimmer" i "does stroke" j,
      0 quad "otherwise"
    )
  $

  - $i = 1, dots, n$: swimmers ($n = 4$)
  - $j = 1, dots, m$: strokes ($m = 4$)

  == General model

  $
    min quad
    &z = sum_(i=1)^n sum_(j=1)^m t_(i j) x_(i j) \
    s.t. quad
    &sum_(j=1)^m x_(i j) = 1 quad forall i in {1, dots, n}
      && "(each swimmer does one stroke)" \
    &sum_(i=1)^n x_(i j) = 1 quad forall j in {1, dots, m}
      && "(each stroke gets one swimmer)" \
    &x_(i j) gt.eq 0 quad forall i in {1, dots, n}, j in {1, dots, m}
  $

  *Note:* $x_(i j) in {0, 1}$ can be relaxed to $x_(i j) >= 0$. The constraint
  matrix is the incidence matrix of a bipartite graph, so it is *totally
  unimodular*. Every vertex of the feasible region is therefore integral, and the
  simplex method returns a 0/1 solution. The constraints $x_(i j) <= 1$ are also
  implied by the equalities.

  #v(5em)

  == Expanded model

  $
    min quad
    z = &37.7 x_("ca","ba") + 43.3 x_("ca","br") + 33.3 x_("ca","bu") + 29.2 x_("ca","fr") \
      + &32.9 x_("ch","ba") + 33.1 x_("ch","br") + 28.5 x_("ch","bu") + 26.4 x_("ch","fr") \
      + &33.8 x_("da","ba") + 42.2 x_("da","br") + 38.9 x_("da","bu") + 29.6 x_("da","fr") \
      + &34.4 x_("ke","ba") + 41.8 x_("ke","br") + 33.6 x_("ke","bu") + 31.1 x_("ke","fr")
  $

  $
    s.t. quad
    // one stroke per swimmer (rows)
    &x_("ca","ba") + x_("ca","br") + x_("ca","bu") + x_("ca","fr") = 1 \
    &x_("ch","ba") + x_("ch","br") + x_("ch","bu") + x_("ch","fr") = 1 \
    &x_("da","ba") + x_("da","br") + x_("da","bu") + x_("da","fr") = 1 \
    &x_("ke","ba") + x_("ke","br") + x_("ke","bu") + x_("ke","fr") = 1 \
    \
    // one swimmer per stroke (columns)
    &x_("ca","ba") + x_("ch","ba") + x_("da","ba") + x_("ke","ba") = 1 \
    &x_("ca","br") + x_("ch","br") + x_("da","br") + x_("ke","br") = 1 \
    &x_("ca","bu") + x_("ch","bu") + x_("da","bu") + x_("ke","bu") = 1 \
    &x_("ca","fr") + x_("ch","fr") + x_("da","fr") + x_("ke","fr") = 1 \
    \
    &x_(i j) gt.eq 0 quad forall i in {"ca","ch","da","ke"}, j in {"ba","br","bu","fr"}
  $

  - $n dot m = 16$ variables
  - $n + m = 8$ equality constraints, of which only $n + m - 1 = 7$ are
    independent (the row sums and the column sums both add up to $n$)

  == Optimal solution

  $
    x^* = mat(
      0, 0, 0, 1;
      0, 1, 0, 0;
      1, 0, 0, 0;
      0, 0, 1, 0;
    )
    quad
    cases(
      "Carl" &-> "freestyle" &(29.2),
      "Chris" &-> "breaststroke" &(33.1),
      "David" &-> "backstroke" &(33.8),
      "Ken" &-> "butterfly" &(33.6),
    )
  $

  $
    z^* = 29.2 + 33.1 + 33.8 + 33.6 = 129.7 "s"
  $

  *Intuition:* breaststroke carries the biggest penalty. Chris is about 9 s faster
  than everyone else at it (33.1 vs ≥ 41.8), so he is placed there, even though
  freestyle and butterfly are his fastest strokes in absolute terms.
]

#example([Separable Programming])[

  $
    D = vec(4, 7, 6)
  $

  #table(
    columns: 3,
    inset: 1em,
    [Plant 1], [[0, 6] Tons\ \$10], [[6, 10] Tons\ \$25], 
    [Plant 2], [[0, 5] Tons\ \$8], [[5, 11] Tons\ \$28], 
  )


  - $x_(1 1)$: production quantity at plant 1 at operation level 1 (0 - 6 tons)
  - $x_(1 2)$: production quantity at plant 1 at operation level 2 (6 - 10 tons)
  - $x_(2 1)$: production quantity at plant 2 at operation level 1 (0 - 5 tons)
  - $x_(2 2)$: production quantity at plant 2 at operation level 2 (5 - 11 tons)

  - $y_(1 1)$: plant 1 $arrow$ DC 1
  - $y_(1 2)$: plant 1 $arrow$ DC 2
  ...

  - $c_(i j)$ cost of shipping from $i$ to $j$
  - $x_(i j)$ production quantity in plant $i$ at level $j$
  - $y_(i j)$ quantity shipped from $i$ to $j$

  $
    min quad 
    &10x_(1 1) + 25 x_(1 2) + 8 x_(2 1) + 28 x_(2 2) + sum_(i=1) sum_(j=1) c_(i j) y_(i j) \
    s.t. quad
    &x_(1 1) + x_(1 2) + x_(2 1) + x_(2 2) = 17 \
    &x_(1 1) lt.eq 6 \
    &x_(1 2) lt.eq 4 \
    &x_(2 1) lt.eq 5 \
    &x_(2 2) lt.eq 6 \

    &y_(1 1) + y_(2 1) = 4 \
    &y_(1 2) + y_(2 2) = 7 \
    &y_(1 3) + y_(2 3) = 6 \

    &x_(1 1) + x_(1 2) = y_(1 1) + y_(1 2) + y_(1 3) \
    &x_(2 1) + x_(2 2) = y_(2 1) + y_(2 2) + y_(2 3) \

    &x_1, dots, x_4 gt.eq 0 \
  $
]

=== Transhipment

Same as *Transportation* problem but with *Transhipment* nodes

- $i$: supplier node
- $j$: transhipment node
- $k$: demand node

D.V.

- $x_(i j)$: inbound (supplier node $arrow$ transhipment node)
- $y_(i j)$: outbound (transhipment node $arrow$ demand node)

Constraints

- Demand constraints

$
  sum_j y_(j k) = d_k quad forall k in K
$

- Supply constraints

$
  sum_i x_(j k) = s_i quad forall k in K
$

- Flow conservation constraints

$
  sum_i x_(i j) = sum_k y_(j k)
$

#example([Montperlier Ski Company])[
  
  - Initial inventory: 200
  - Ending inventory: 1200
  - Regular time (50%) 
  - Overtime (50%)
  - Holding cost: 3%

  #table(
    columns: 5,
    inset: 1em,
    [Month], [Demand],  [Capacity],  [Regular Time\ Production Cost],  [Overtime\ Production Cost],
    [July], [400],  [1000],  [25],  [30],
    [August], [600],  [800],  [26],  [32],
    [September], [1000],  [400],  [29],  [37],
  )

  - $i in I$: Month (July, August, September)
  - $j in J$: Production modes (Regular, Overtime)
  - $x_(i j)$: Production on month $i$ at cost $j$ (regular or overtime)

  Customers:
  - $J$: 
    - Demand: 400
    - Net Demand: 400 - 200 = 200
  - $A$: 
    - Demand: 600
    - Net Demand: 600
  - $S$: 
    - Demand: 1000
    - Net Demand: 1000 + 1200 = 2200
  - $"Dummy"$:
    - Demand: Total Supply - Total Demand = 300

  Total Demand: 3000

  Suppliers:
  - $"JR"$: 1000
  - $"JO"$: 500
  - $"AR"$: 800
  - $"AO"$: 400
  - $"SR"$: 400
  - $"SO"$: 200

  Total Supply: 3300

  $
    min quad &sum_(i in I) sum_(j in J) x_(i j) c_(i j) \
    s.t. quad 
    &sum_(i) x_(i j) = (or lt.eq) d_j, quad forall j in J \
    &sum_(j) x_(i j) = (or lt.eq) s_j, quad forall i in I \
    &x_(i j) gt.eq 0, quad forall i in I and j in J
  $

  $
    c_(1 3) = 25 + (3% times 24) times 2
  $

  Cost + 3% Cost for 2 months (produce in July sold in September)

  Making Produced in september sold in july impossible (use $M$)


  #let nodes = ("A", "B", "C", "D", "E", "F", "G")
  #let edges = (
    (3, 2),
    (4, 1),
    (1, 4),
    (0, 4),
    (3, 0),
    (5, 6),
    (6, 5),
  )

  #diagram({
    node((0, 1), [JR], stroke: 0.5pt, name: <JR>)
    node((0, 2), [JO], stroke: 0.5pt, name: <JO>)
    node((0, 3), [AR], stroke: 0.5pt, name: <AR>)
    node((0, 4), [AO], stroke: 0.5pt, name: <AO>)
    node((0, 5), [SR], stroke: 0.5pt, name: <SR>)
    node((0, 6), [SO], stroke: 0.5pt, name: <SO>)

    node((-1, 1), [1000], stroke: none, name: <JRp>)
    node((-1, 2), [500], stroke: none, name: <JOp>)
    node((-1, 3), [800], stroke: none, name: <ARp>)
    node((-1, 4), [400], stroke: none, name: <AOp>)
    node((-1, 5), [400], stroke: none, name: <SRp>)
    node((-1, 6), [200], stroke: none, name: <SOp>)
    
    node((3, 1), [J], stroke: 0.5pt, name: <J>)
    node((3, 2), [A], stroke: 0.5pt, name: <A>)
    node((3, 3), [S], stroke: 0.5pt, name: <S>)
    node((3, 4), [Dummy], stroke: 0.5pt, name: <D>)

    node((4, 1), [400 - 200 = 200], stroke: none, name: <Jp>)
    node((4, 2), [600], stroke: none, name: <Ap>)
    node((4, 3), [1000 + 1200 = 2200], stroke: none, name: <Sp>)
    node((4, 4), [TS - TD = 300], stroke: none, name: <Dp>)


    edge(<JR>, <A>, "-|>", [])
    
    edge(<JR>, <D>, "-|>", [])
    
    edge(<SR>, <J>, "-|>", [])
  })
]

#example([Sailco Inventory])[

  - Regular capacity: 40
  - Regular cost: 400
  - Overtime capacity: infinity
  - Overtime cost: 450 
  - $h$: 20
  - Beginning inventory: 10

  #diagram({
    node((0, 1), [Q1], stroke: 0.5pt, name: <Q1S>)
    node((0, 2), [Q2], stroke: 0.5pt, name: <Q2S>)
    node((0, 3), [Q3], stroke: 0.5pt, name: <Q3S>)
    node((0, 4), [Q4], stroke: 0.5pt, name: <Q4S>)

    node((-1, 1), [500], stroke: none, name: <Q1Sp>)
    node((-1, 2), [800], stroke: none, name: <Q2Sp>)
    node((-1, 3), [400], stroke: none, name: <Q3Sp>)
    node((-1, 4), [400], stroke: none, name: <Q4Sp>)
    
    node((3, 1), [Q1], stroke: 0.5pt, name: <Q1D>)
    node((3, 2), [Q2], stroke: 0.5pt, name: <Q2D>)
    node((3, 3), [Q3], stroke: 0.5pt, name: <Q3D>)
    node((3, 4), [Q4], stroke: 0.5pt, name: <Q4D>)

    node((4, 1), [40 - 10 = 30], stroke: none, name: <Q1Dp>)
    node((4, 2), [60], stroke: none, name: <Q2Dp>)
    node((4, 3), [75], stroke: none, name: <Q3Dp>)
    node((4, 4), [25], stroke: none, name: <Q4Dp>)

    edge(<Q1S>, <Q2D>, "-|>", [])

    edge(<Q1S>, <Q4D>, "-|>", [])
    
    edge(<Q4S>, <Q1D>, "-|>", [])
  })

  Since holding cost is constant (unlike Montperlier Ski Company example), we don't need transportation formulation.

  - $x_t$: number of boars producted in quarter $t$ using regular time
  - $y_t$: number of boars producted in quarter $t$ using overtime
  - $i_t$: ending inventory for quarter $t$

  $
    min quad &sum_(t=1)^4 (400 x_t + 450 y_t) + sum_(t=1)^4 20 dot i_t quad "production cost" + "holding cost" \
    s.t. quad
    &x_t lt.eq 40 quad forall t = 1, dots, 4 \
    &i_t = i_(t-1) + x_t + y_t - d_t quad forall t = 1, dots, 4 \
    &x_t, y_t gt.eq 0 quad forall t = 1, dots, 4 \
    &i_t gt.eq 0 quad forall i = 1, dots, 4 quad "no backorders"\ 
  $

  Adding backorder penalty:

  $b = 100$

  2 new variables:

  $
    i_t^+ &= "# onhand" \
    i_t^- &= "# backorders" \
    i_t &= i_t^+ - i_t^-
  $
  
  $
    min quad &sum_(t=1)^4 (400 x_t + 450 y_t) + sum_(t=1)^4 20 dot i_t quad "production cost" + "holding cost" \
    s.t. quad
    &x_t lt.eq 40 quad forall t = 1, dots, 4 \
    &mc(i_t^+ - i_t^-) = mc(i_(t-1)^+ - i_(t-1)^-) + x_t + y_t - d_t quad forall t = 1, dots, 4 \
    &x_t, y_t gt.eq 0 quad forall t = 1, dots, 4 \
    &mc(i_t^+) gt.eq 0 quad forall i = 1, dots, 4 \ 
    &mc(i_t^-) gt.eq 0 quad forall i = 1, dots, 4 \ 
  $

]

#example([Product Mix])[
  
  $
    "bom" = mat(
      2, 1;
      2, 2
    )
    \
    "capacity" = vec(
      6, 
      8,
    )
    \
    "price" = vec(
      20.00,
      15.00,
    )
  $

  ```py
  import gurobipy as gp
  from gurobipy import GRB
  import numpy as np

  products = ["table", "chair"]
  bom = np.array([[2, 1],
                  [2, 2]])
  capacity = np.array([6, 8])
  price = np.array([20.00, 15.00])

  m = gp.Model("product_mix")
  x = m.addMVar(shape=price.size, lb=0.0, name=products)

  m.setObjective(price @ x, GRB.MAXIMIZE)
  cap = m.addConstr(bom @ x <= capacity, name="capacity")

  m.optimize()

  if m.Status == GRB.OPTIMAL:
      obj = x.Obj
      inc = x.SAObjUp - obj
      dec = obj - x.SAObjLow

      print(f"Objective = {m.ObjVal:.2f}\n")

      print(f"{'Var':6} {'Value':>7} {'Obj':>7} {'Inc':>7} {'Dec':>7} {'RC':>7}")
      for row in zip(x.VarName, x.X, obj, inc, dec, x.RC):
          print(f"{row[0]:6} " + " ".join(f"{v:7.2f}" for v in row[1:]))

      print(f"\n{'Constr':12} {'Slack':>7} {'Dual':>7} {'RHS lo':>7} {'RHS hi':>7}")
      for row in zip(cap.ConstrName, cap.Slack, cap.Pi, cap.SARHSLow, cap.SARHSUp):
          print(f"{row[0]:12} " + " ".join(f"{v:7.2f}" for v in row[1:]))
  ```
]

== Sensitivity Analysis

- How does the solution change
  - If the RHS of constraint change?
  - If an objective coefficient changes?
- What is the range of optimality and feasibility?
  - Allowable change in the objective function coefficient
  - Allowable change in the RHS

#example([Ice Cream])[

]

- Check allowable Increase / Decrease
- If in range:
  - New Obj Value = New Obj Value + (Decrease) $times$ Shadow Price

100% rule
- Simultaneous change in objective function
- Simultaneous change in coefficients

abs(New value - Old value) / allowable value + abs(New value - Old value) / allowable value <= 1 (100%)

if >= 100% cannot use shadow price to calculate new profit

= Integer Programming

== Knapsack Problem

#example([TBA Airlines])[
  $
    max quad 
    &S + 5L \
    s.t. quad 
    &5S + 50L \
    &S lt.eq 2 \
    &S, L gt.eq 0 \
    &S, L in {0, 1} \
  $
]

$
  "LP" gt.eq "IP" quad (max) \
  "LP" lt.eq "IP" quad (min) \
$

#example([Distribution Channel Restructuring])[
  Warehouse ($m = 5$):
  
  SEA, DEN, STL, ATL, PHI
  
  Market ($n = 6$):
  
  NW, SW, UMW, LMW, NE, SE

  Operating cost:
  $
    c_o = vec(

    )
  $
  
  Capacity: 
  $
    k = vec(

    )

  $

  Demand:
  $
    D = vec(

    ) 
  $
  
  Transportation cost:
  $
    c_T = mat(

    )
  $

  Decision variables:
  - $x_(i j)$: \# of units shipped from WH $i$ to customer $j$
  - $c_(i j)$: unit cost of a shipment from WH $i$ to customer $j$
  - $s_i$: capacity of WG $i$
  - #mc($y_i$): open or close WH $i$

    $
      cases(
        1 quad "if WH" i "open",
        0 quad "otherwise"
      )
    $

  - #mc($k_i$): operational cost of WH $i$

  $
    min quad
    &sum_(i=1)^5 sum_(j=1)^6 c_(i j) x_(i j)
    mc(+ sum_(i=1)^5 k_i y_i)
    \
    s.t. quad 
    &sum_(j=1)^6 x_(i j) lt.eq s_i mc(y_i), quad forall i = 1, dots, 5 \
    &sum_(i=1)^5 x_(i j) gt.eq d_j, quad forall j = 1, dots, 6 \
    &mc(sum_(j=1)^6 x_(i j) lt.eq s_i y_i quad forall i = 1\, dots\, 5) \
    &x_(i j) gt.eq 0 quad forall i, j \
    &mc(y_i in {0, 1})
  $
  
]

#example([Capital Budgeting])[
  $
    y_i = cases(
      1 quad "if project" i "is chosen",
      0 quad "otherwise",
    )
  $

  $
    max quad
    &35 y_1 + 18 y_2 + 24 y_3 + 16 y_4 \
    s.t. quad
    &10 y_1 + 8 y_2 + 6 y_3 + 12 y_4 lt.eq 30 \
    &8 y_1 + 5 y_2 + 4 y_3 + 0 y_4 lt.eq 15 \
    &8 y_1 + 0 y_2 + 6 y_3 + 0 y_4 lt.eq 12 \
    &y_i in {0, 1} quad forall i
  $

  If budget saved in one year can be used in subsequent years:

  $
    max quad
    &35 y_1 + 18 y_2 + 24 y_3 + 16 y_4 \
    s.t. quad
    &10 y_1 + 8 y_2 + 6 y_3 + 12 y_4 lt.eq 30 \
    &8 y_1 + 5 y_2 + 4 y_3 + 0 y_4 lt.eq 15 mc(+ (30 - 10 y_1 + 8 y_2 + 6 y_3 + 12 y_4)) \
    &8 y_1 + 0 y_2 + 6 y_3 + 0 y_4 lt.eq 12 mc(+ (15 + 30 - 10 y_1 + 8 y_2 + 6 y_3 + 12 y_4) - (8 y_1 + 5 y_2 + 4 y_3 + 0 y_4)) \
    &y_i in {0, 1} quad forall i
  $

]

At least on project:
$
  y_1 + y_2 + y_3 gt.eq 1 \
$

Sequence (4 needs to be done before 3):
$
  y_3 lt.eq y_4 \
$

Either 1 or 2, but not both:
$
  y_1 + y_2 = 1 \
$

No more than 2 projects:
$
  y_1 + y_2 + y_3 + y_4 lt.eq 2 \
$

#example([Set Covering Problem])[
  $
    y_i = cases(
      1 quad "if team in country" i,
      0 quad "otherwise"
    )
  $

  Adjacency matrix:
  $
    A = mat(

    ) 
    \
    a_(i j) = cases(
      1 "if county" i "is adjacent to county" j,
      0 "otherwise",
    )
  $

  $
    min quad 
    &sum_(i=1)^37 y_i \
    s.t. quad 
    &sum_(j=1)^37 a_(i j) y_i gt.eq 1 quad forall i = 1, dots, 37 \
    &y_i in {0, 1} quad forall i, dots, 37
  $
]

#example([Olympic Gymnastic Team])[
  *Sets*

  

  *Indices*

  *Parameters*

  - $B$: 
  - $F$: 

  *Decision variables*

  - $x_i = cases(
    1 "if gymnast" i "does BB only",
    0 "otherwise",
  )$

  - $y_i = cases(
    1 "if gymnast" i "does FE only",
    0 "otherwise",
  )$
  
  - $w_i = cases(
    1 "if gymnast" i "does both",
    0 "otherwise",
  )$

  - $"bb"_i$: score of gymnist $i$ for BB
  - $"fe"_i$: score of gymnist $i$ for FE

  *Model*

  $
    max quad 
    &sum_(i in) ([x_i + w_i] "bb"_i + [y_i + w_i] "fe"_i) \
    s.t. quad
    &sum_(i in) w_i = 3 \
    &sum_(i in) (x_i + w_i) = 4 \
    &sum_(i in) (y_i + w_i) = 4 \
    &x_i + y_i + w_i lt.eq 1 quad forall i in  \ 
    &x_i, y_i, w_i gt.eq 0
  $
  
]

#example([Euing Gas])[
  
  - $x$: amount of oil 1 (extra) to be purchased 
  - $x_(i j)$: amount of oil $i$ used to product gas $j$

  $
    max quad 
    & \
    s.t. quad
    & \
    & \
    & \
  $
]

#example([Scheduling Problem])[

  #v(1em)

  - $x_(i k) = cases(
      1 "if customer" i "is assigned to position" k,
      0 "otherwise"
    )
  $

  - $t_k$: tardiness of the $k^"th"$ job in sequence

  - $d$: due date
  - $p$: processing time

  $
    min quad 
    &z = sum_(k in K) t_k \
    s.t. quad
    &sum_(k in K) x_(i k) = 1 quad && forall i in I \
    &sum_(i in I) x_(i k) = 1 quad &&  forall k in K \
    &sum_(i in I) p_i sum_u^k x_(i u) - sum_(i in I) d_i x_(i k) lt.eq t_k quad && forall k \
    &t_k gt.eq 0 \
    &x_(i k) = {1, 0}
  $

  Cumulative sum $p$ of the previous customer orders minus the due date ($d$) of the current task

  $
    t_1 = (p_3 - d_3)^+
  $

  Due date of the $k^"th"$ job in the sequence:

  $
    sum_(i in I) x_(i k) d_i
  $

  Completion time:

  $
    sum_(i in I) p_i sum_u^k x_(i u)
  $

  This is non linear:

  $
    t_k = (sum_(i in I) p_i sum_u^k x_(i u) - sum_(i in I) x_(i k) d_i)^+
  $

  So we replace it with:

  $
    &sum_(i in I) p_i sum_u^k x_(i u) - sum_(i in I) d_i x_(i k) lt.eq t_k \
    &t_k gt.eq 0   
  $
]

#example([Sequence-dependent setup time production problem])[

  TSP Problem

  - $x_(i k) = cases(
    1 "if gasoline" i "is assigned to position" k,
    0 "otherwise"
  )$
  - $t_(i j)$: transition time between gasoline $i$ and $j$
  
  $
    min quad 
    &sum_(k in K) t_k \
    s.t. quad 
    & \
    & \
    & \
  $

  Solution:
  - LFR $arrow$ LFP $arrow$ LP $arrow$ LR $arrow$ LFR
  - 330 minutes
]

TSP

- $x_(i j) = cases(
    1 "if vertex" j "is visited immediately after vertex" i,
    0 "otherwise"
  )$

$
  min quad
  &sum_(i in I) sum_(j in J) c_(i j) x_(i j) \
  s.t. quad
  &sum_i x_(i j) = 1 quad &&forall j quad &&("in") \
  &sum_i x_(i j) = 1 quad &&forall i quad &&("out") \
  &sum_((i,j) in S) x_(i j) lt.eq abs(S) - 1 quad &&forall S subset V, abs(S) gt 1 quad &&("prevent subtours")
$

Alternative:

$
  min quad
  &sum_(i in I) sum_(j in J) c_(i j) x_(i j) \
  s.t. quad
  &sum_i x_(i j) = 1 quad &&forall j quad &&("in") \
  &sum_i x_(i j) = 1 quad &&forall i quad &&("out") \
  &mc(u_1 = 1) \
  &mc(2 lt.eq u_i lt.eq n quad && forall i gt.eq 2) \
  &mc(u_i - u_j + 1 lt.eq (n - 1)(1 - x_(i j)) quad && forall i\, j eq.not 1) \
$

#pagebreak()



// =====================================================================
//  MZ 510 · Analytical Methods — Taxonomy of optimization models
//  Pure Typst (no packages). Edit the `nodes` and `edges` arrays below
//  to add models; coordinates are in cm on the diagram canvas.
// =====================================================================

#set document(title: "Taxonomy of Optimization Models")
#set page(paper: "a4", flipped: true, margin: (x: 1.4cm, y: 1.2cm),
  footer: context [
    #set text(7pt, fill: luma(130))
    MZ 510 · Analytical Methods — model taxonomy #h(1fr) #counter(page).display()
  ])
#set text(size: 9pt)
#set par(justify: false)

// ---------- palette ---------------------------------------------------
#let fam = (
  root: (fill: luma(235),            stroke: luma(90)),
  lp:   (fill: rgb("#dbe8f7"),       stroke: rgb("#2f6db3")),
  net:  (fill: rgb("#dcf0e2"),       stroke: rgb("#2e8b57")),
  ip:   (fill: rgb("#fbe5d3"),       stroke: rgb("#c0602a")),
)
#let ink = luma(60)

// ---------- edge styles -----------------------------------------------
//  ext  = extension      (adds variables / constraints)     solid
//  spec = special case   (restricts structure or data)      dashed
//  ref  = reformulation  (same problem, recast)              dotted
#let edge-stroke(kind) = {
  if kind == "ext"  { (paint: ink, thickness: 0.9pt) }
  else if kind == "spec" { (paint: ink, thickness: 0.9pt, dash: "dashed") }
  else { (paint: ink, thickness: 1.1pt, dash: "dotted") }
}

// ---------- nodes: id: (x, y, w, h, family, title, subtitle) ----------
#let nodes = (
  lp:     (10.5, 0.4, 3.6, 1.0, "root", "Linear Program", "min cᵀx, Ax ≤ b, x ≥ 0"),

  gen:    (4.0, 2.9, 5.0, 1.3, "lp",  "General LP",
           "≤ resource allocation: product mix, Lego\n≥ covering: diet, security shifts"),
  trans:  (16.5, 2.9, 4.2, 1.3, "net", "Transshipment",
           "min-cost flow · out − in = supply"),

  tp:     (10.6, 5.6, 3.2, 1.1, "net", "Transportation", "plants → DCs"),
  sp:     (14.3, 5.6, 3.0, 1.1, "net", "Shortest path", "1 unit, s → t"),
  mf:     (17.8, 5.6, 3.0, 1.1, "net", "Max flow", "Sunco Oil"),
  mp:     (24.0, 5.6, 3.4, 1.1, "net", "Multi-period inventory", "Sailco"),

  asg:    (8.4, 8.2, 3.0, 1.1, "net", "Assignment", "swimmers, inspection"),
  unb:    (11.9, 8.2, 3.2, 1.1, "net", "Unbalanced transp.", "Montpelier Ski"),
  eq:     (15.6, 8.2, 3.7, 1.1, "net", "Equipment replacement", "nodes = years"),
  bk:     (24.0, 8.2, 3.4, 1.1, "net", "Inventory w/ backlog", "Sailco (backorders)"),

  eul:    (1.8, 11.4, 3.2, 1.1, "ip", "Piecewise cost IP", "Euling Gas"),
  ms:     (5.2, 11.4, 3.2, 1.1, "ip", "Machine scheduling", "single machine, due dates"),
  tsp:    (8.4, 11.4, 2.8, 1.1, "ip", "TSP", "subtour / MTZ"),
  loc:    (20.6, 11.4, 4.0, 1.1, "ip", "Plant & warehouse location",
           "multi-echelon + open/close"),

  vrp:    (8.4, 14.0, 2.8, 1.1, "ip", "VRP", "several vehicles"),
  cons:   (14.6, 14.0, 4.2, 1.1, "ip", "Shipment consolidation",
           "Oxximet · route-days"),
)

// ---------- edges: (from, to, kind, label, via-points, label-offset) --
//  via: list of (x, y) bend points; lab: (dx, dy) shift of the label
#let edges = (
  (from: "lp",    to: "gen",  kind: "spec", label: "no special structure"),
  (from: "lp",    to: "trans",kind: "spec", label: "node–arc matrix"),

  (from: "trans", to: "tp",   kind: "spec", label: "no intermediate nodes", lab: (-0.6, -0.1)),
  (from: "trans", to: "sp",   kind: "spec", label: "1 unit s→t", lab: (-0.15, 0.05)),
  (from: "trans", to: "mf",   kind: "spec", label: "max throughput", lab: (0.55, 0.0)),
  (from: "trans", to: "mp",   kind: "ext",  label: "+ time index"),
  (from: "trans", to: "loc",  kind: "ext",  label: "+ binaries y,  x ≤ K·y",
     via: ((20.6, 5.0),), lab: (0.4, 0.4)),

  (from: "tp",    to: "asg",  kind: "spec", label: "s = d = 1"),
  (from: "tp",    to: "unb",  kind: "ext",  label: "+ dummy node"),
  (from: "sp",    to: "eq",   kind: "ref",  label: "recast as path"),
  (from: "mp",    to: "bk",   kind: "ext",  label: "+ backorder vars"),

  (from: "gen",   to: "eul",  kind: "ext",  label: "+ binaries", lab: (-0.35, 0.0)),
  (from: "gen",   to: "ms",   kind: "ext",  label: "+ either-or, big-M", lab: (0.45, 0.0)),
  (from: "asg",   to: "tsp",  kind: "ext",  label: "+ subtour elimination", lab: (0.0, 0.45)),
  (from: "tsp",   to: "vrp",  kind: "ext",  label: "+ k vehicles, capacity"),
  (from: "asg",   to: "cons", kind: "ext",  label: "+ route binaries, capacity, time windows",
     lab: (1.0, -0.2)),
  (from: "vrp",   to: "cons", kind: "ref",  label: "routes pre-enumerated", lab: (0.0, -0.32)),
)

// ---------- geometry helpers -----------------------------------------
#let ctr(id) = { let n = nodes.at(id); (n.at(0), n.at(1)) }
// point on node boundary in direction of (tx, ty)
#let clip(id, tx, ty) = {
  let n = nodes.at(id)
  let (cx, cy, w, h) = (n.at(0), n.at(1), n.at(2), n.at(3))
  let dx = tx - cx
  let dy = ty - cy
  let tX = if dx == 0 { 1e9 } else { (w / 2 + 0.06) / calc.abs(dx) }
  let tY = if dy == 0 { 1e9 } else { (h / 2 + 0.06) / calc.abs(dy) }
  let t = calc.min(tX, tY)
  (cx + t * dx, cy + t * dy)
}
#let P(p) = (p.at(0) * 1cm, p.at(1) * 1cm)

#let draw-edge(e) = {
  let via = e.at("via", default: ())
  let a = ctr(e.from)
  let b = ctr(e.to)
  let first = if via.len() > 0 { via.first() } else { b }
  let last  = if via.len() > 0 { via.last()  } else { a }
  let pts = (clip(e.from, ..first),) + via + (clip(e.to, ..last),)
  let st = edge-stroke(e.kind)
  for i in range(pts.len() - 1) {
    place(top + left, line(start: P(pts.at(i)), end: P(pts.at(i + 1)), stroke: st))
  }
  // arrow head
  let (p, q) = (pts.at(-2), pts.at(-1))
  let (dx, dy) = (q.at(0) - p.at(0), q.at(1) - p.at(1))
  let L = calc.sqrt(dx * dx + dy * dy)
  let (ux, uy) = (dx / L, dy / L)
  let (s, wd) = (0.24, 0.10)
  let base = (q.at(0) - s * ux, q.at(1) - s * uy)
  place(top + left, polygon(fill: ink, stroke: none,
    P(q),
    P((base.at(0) + wd * uy, base.at(1) - wd * ux)),
    P((base.at(0) - wd * uy, base.at(1) + wd * ux))))
  // label at midpoint of the longest segment (+ offset)
  let m = ((pts.first().at(0) + pts.last().at(0)) / 2,
           (pts.first().at(1) + pts.last().at(1)) / 2)
  let off = e.at("lab", default: (0, 0))
  let (mx, my) = (m.at(0) + off.at(0), m.at(1) + off.at(1))
  place(top + left, dx: (mx - 3) * 1cm, dy: (my - 0.5) * 1cm,
    box(width: 6cm, height: 1cm, align(center + horizon,
      box(fill: white, inset: (x: 2pt, y: 1.2pt), radius: 2pt,
        text(6.4pt, fill: ink, style: "italic", e.label)))))
}

#let draw-node(id) = {
  let n = nodes.at(id)
  let (x, y, w, h, f, title, sub) = n
  let c = fam.at(f)
  place(top + left, dx: (x - w / 2) * 1cm, dy: (y - h / 2) * 1cm,
    box(width: w * 1cm, height: h * 1cm, fill: c.fill,
        stroke: 0.9pt + c.stroke, radius: 4pt, inset: 3pt,
      align(center + horizon, {
        text(8pt, weight: "bold", fill: c.stroke.darken(25%), title)
        if sub != "" { linebreak(); text(6.4pt, fill: luma(70), sub) }
      })))
}

// =====================================================================
//  PAGE 1 — dependency DAG
// =====================================================================
#align(center, text(15pt, weight: "bold")[Taxonomy of optimization models])
#v(-6pt)
#align(center, text(8.5pt, fill: luma(90))[
  Arrows run from simpler to richer models. A model can have several parents, so this is a DAG rather than a tree.])
#v(2pt)

#block(width: 26.5cm, height: 15.0cm, {
  // integrality boundary
  let yb = 9.75
  place(top + left, dx: 0cm, dy: yb * 1cm,
    line(length: 26.5cm, stroke: (paint: rgb("#c0602a"), thickness: 0.8pt, dash: "dash-dotted")))
  place(top + left, dx: 11.3cm, dy: (yb - 0.55) * 1cm,
    text(7pt, fill: rgb("#c0602a"), weight: "bold")[▲ totally unimodular: the LP already gives integer answers])
  place(top + left, dx: 11.3cm, dy: (yb + 0.16) * 1cm,
    text(7pt, fill: rgb("#c0602a"), weight: "bold")[▼ binaries or side constraints: true integer programming needed])

  for e in edges { draw-edge(e) }
  for id in nodes.keys() { draw-node(id) }

  // legend
  place(top + left, dx: 20.3cm, dy: 12.7cm, box(
    width: 6.1cm, inset: 6pt, radius: 4pt, stroke: 0.6pt + luma(170), fill: white, {
      set text(7pt)
      let sw(k) = box(width: 1.1cm, height: 6pt, align(horizon,
        line(length: 1.1cm, stroke: edge-stroke(k))))
      let chip(f) = box(width: 9pt, height: 7pt, fill: fam.at(f).fill,
        stroke: 0.7pt + fam.at(f).stroke, radius: 1.5pt)
      grid(columns: (auto, 1fr), column-gutter: 5pt, row-gutter: 3.5pt,
        sw("ext"),  [*extension*: adds variables or constraints],
        sw("spec"), [*special case*: restricts structure or data],
        sw("ref"),  [*reformulation*: same problem, recast],
      )
      v(3pt)
      chip("lp"); [ General LP #h(5pt)]; chip("net"); [ Network flow #h(5pt)]; chip("ip"); [ Integer]
    }))
})

#pagebreak()

// =====================================================================
//  MZ 510 · Analytical Methods — LP & IP model taxonomy
//  Pure Typst (no packages). Edit `nodes` / `edges` below; coordinates
//  are in cm on the diagram canvas (page 1 is A3 landscape).
//
//  Evidence levels (from the course PDF, whose slides are mostly images):
//    "f" = formulation or data readable in the slide text
//    "t" = slide title only (content is an image)
//    "i" = inferred (not in the readable text; based on the cited textbook)
// =====================================================================

#set document(title: "LP & IP Model Taxonomy")
#set page(paper: "a4", flipped: true, margin: (x: 1.4cm, y: 1.2cm),
  footer: context [
    #set text(7pt, fill: luma(130))
    MZ 510 · Analytical Methods — LP & IP model taxonomy #h(1fr) #counter(page).display()
  ])
#set text(size: 9pt)
#set par(justify: false)

// ---------- palette ---------------------------------------------------
#let fam = (
  root: (fill: luma(235),      stroke: luma(90)),
  lp:   (fill: rgb("#dbe8f7"), stroke: rgb("#2f6db3")),
  net:  (fill: rgb("#dcf0e2"), stroke: rgb("#2e8b57")),
  ip:   (fill: rgb("#fbe5d3"), stroke: rgb("#c0602a")),
)
#let ink = luma(60)

// ---------- evidence markers ------------------------------------------
#let ev-mark(s, col) = {
  if s == "f" { circle(radius: 2.6pt, fill: col, stroke: none) }
  else if s == "t" { circle(radius: 2.3pt, fill: white, stroke: 1pt + col) }
  else { circle(radius: 2.3pt, fill: white, stroke: (paint: col, thickness: 0.8pt, dash: "densely-dotted")) }
}
#let ev(s) = box(baseline: 1pt, ev-mark(s, ink))

// ---------- edge styles -----------------------------------------------
//  ext  = extension      (adds variables / constraints)     solid
//  spec = special case   (restricts structure or data)      dashed
//  ref  = reformulation  (same problem, recast)              dotted
#let edge-stroke(kind) = {
  if kind == "ext"  { (paint: ink, thickness: 0.9pt) }
  else if kind == "spec" { (paint: ink, thickness: 0.9pt, dash: "dashed") }
  else { (paint: ink, thickness: 1.1pt, dash: "dotted") }
}

// ---------- nodes: id: (x, y, w, h, family, evidence, title, subtitle) -
#let nodes = (
  lp:    (19.0, 0.6, 4.0, 1.1, "root", "f", "Linear Program", "min cᵀx  s.t.  Ax ≤ b,  x ≥ 0"),

  // general LP family
  gen:   (8.6, 3.3, 5.0, 1.2, "lp", "f", "General LP", "no special matrix structure"),
  pm:    (2.4, 6.4, 3.6, 1.35, "lp", "f", "Product mix (≤)",
          "Ex. 1–2 · graphical A/B · Lego"),
  diet:  (6.3, 6.4, 3.4, 1.35, "lp", "f", "Diet / blending (≥)", "Prison diet"),
  shift: (10.5, 6.4, 3.6, 1.35, "lp", "f", "Shift scheduling (≥)",
          "Security force · integer staff"),
  sail:  (15.0, 6.4, 3.6, 1.35, "lp", "t", "Multi-period inventory",
          "Sailco · inventory balance"),
  back:  (15.0, 9.3, 3.9, 1.2, "lp", "t", "Inventory with backlog", "Sailco · I⁺ − I⁻"),

  // network family
  trans: (29.0, 3.3, 4.6, 1.2, "net", "i", "Min-cost flow / transshipment",
          "conceptual root · out − in = b"),
  tp:    (21.3, 6.4, 3.8, 1.35, "net", "f", "Transportation",
          "Montpelier Ski · Distribution"),
  sp:    (25.9, 6.4, 3.4, 1.35, "net", "f", "Shortest path", "LP: 1 unit node 1 → 6"),
  mf:    (30.3, 6.4, 3.6, 1.35, "net", "t", "Max flow",
          "Sunco Oil · artificial arc t→s"),
  asg:   (19.4, 9.3, 3.6, 1.35, "net", "f", "Assignment",
          "lines → inspection · swimmers"),
  unb:   (23.4, 9.3, 3.4, 1.2, "net", "t", "Unbalanced transp.", "Montpelier · dummy node"),
  eq:    (27.7, 9.3, 4.1, 1.2, "net", "t", "Equipment replacement", "nodes = years"),

  // integer programs
  fc:    (1.6, 13.4, 3.0, 1.35, "ip", "i", "Fixed charge", "setup cost · x ≤ M·y"),
  eul:   (5.0, 13.4, 3.4, 1.35, "ip", "t", "Piecewise cost", "Euling Gas"),
  knap:  (8.6, 13.4, 3.3, 1.35, "ip", "i", "Knapsack",
          "capital budget · loading"),
  ms:    (12.85, 13.4, 3.6, 1.35, "ip", "f", "Single-machine sched.",
          "4 jobs · min total delay"),
  tsp:   (19.4, 13.4, 3.2, 1.35, "ip", "f", "TSP", "DFJ subtours · MTZ"),
  loc:   (35.4, 13.4, 4.2, 1.35, "ip", "f", "Plant & warehouse location",
          "suppliers → plants → WH → mkts"),

  scov:  (10.5, 16.6, 3.4, 1.35, "ip", "i", "Set covering", "binary sites / shifts"),
  vrp:   (19.4, 16.6, 3.2, 1.35, "ip", "t", "VRP", "vehicles · capacity"),
  cons:  (26.2, 16.6, 4.4, 1.35, "ip", "f", "Shipment consolidation",
          "Oxximet · trucks vs. LTL"),
)

// ---------- edges ----------------------------------------------------
#let edges = (
  (from: "lp",    to: "gen",   kind: "spec", label: "no special structure"),
  (from: "lp",    to: "trans", kind: "spec", label: "node–arc incidence matrix"),

  (from: "gen",   to: "pm",    kind: "spec", label: "≤ rows, max profit", lab: (-0.4, 0)),
  (from: "gen",   to: "diet",  kind: "spec", label: "≥ rows, min cost", lab: (-0.1, 0.15)),
  (from: "gen",   to: "shift", kind: "spec", label: "≥ per period", lab: (0.25, 0.1)),
  (from: "gen",   to: "sail",  kind: "ext",  label: "+ time index", lab: (1.1, -0.35)),
  (from: "sail",  to: "back",  kind: "ext",  label: "+ backorder vars"),
  (from: "trans", to: "sail",  kind: "ref",  label: "= time-expanded network", lab: (0.3, -0.35)),

  (from: "trans", to: "tp",    kind: "spec", label: "no transshipment nodes", lab: (-0.4, -0.1)),
  (from: "trans", to: "sp",    kind: "spec", label: "1 unit s→t", lab: (-0.15, 0.05)),
  (from: "trans", to: "mf",    kind: "spec", label: "max throughput", lab: (0.55, 0.0)),
  (from: "trans", to: "loc",   kind: "ext",  label: "+ binaries y,  x ≤ K·y, multi-echelon",
     via: ((35.4, 4.6),), lab: (0.3, 1.8)),

  (from: "tp",    to: "asg",   kind: "spec", label: "s = d = 1"),
  (from: "tp",    to: "unb",   kind: "ext",  label: "+ dummy node"),
  (from: "sp",    to: "eq",    kind: "ref",  label: "recast as path"),

  (from: "pm",    to: "fc",    kind: "ext",  label: "+ setup binaries", lab: (-0.45, 0)),
  (from: "pm",    to: "eul",   kind: "ext",  label: "+ piecewise binaries", lab: (0.25, 0.3)),
  (from: "pm",    to: "knap",  kind: "ext",  label: "+ x ∈ {0,1}", lab: (0.6, 0.5)),
  (from: "gen",   to: "ms",    kind: "ext",  label: "+ either-or, big-M",
     via: ((12.85, 4.8),), lab: (1.85, 2.4)),
  (from: "asg",   to: "ms",    kind: "ext",  label: [\+ positions $u$, tardiness $t_k$], lab: (0.5, -0.55)),
  (from: "shift", to: "scov",  kind: "ext",  label: "+ binary choices", via: ((10.5, 12.2),), lab: (-1.25, 3.3)),

  (from: "asg",   to: "tsp",   kind: "ext",  label: "+ subtour elimination", lab: (0.0, 0.5)),
  (from: "tsp",   to: "vrp",   kind: "ext",  label: "+ k vehicles, capacity"),
  (from: "asg",   to: "cons",  kind: "ext",  label: "+ route-day binaries, capacity, time windows",
     lab: (1.9, 0.6)),
  (from: "vrp",   to: "cons",  kind: "ref",  label: "routes pre-enumerated", lab: (0.0, -0.32)),
)

// ---------- geometry helpers -----------------------------------------
#let ctr(id) = { let n = nodes.at(id); (n.at(0), n.at(1)) }
#let clip(id, tx, ty) = {
  let n = nodes.at(id)
  let (cx, cy, w, h) = (n.at(0), n.at(1), n.at(2), n.at(3))
  let dx = tx - cx
  let dy = ty - cy
  let tX = if dx == 0 { 1e9 } else { (w / 2 + 0.06) / calc.abs(dx) }
  let tY = if dy == 0 { 1e9 } else { (h / 2 + 0.06) / calc.abs(dy) }
  let t = calc.min(tX, tY)
  (cx + t * dx, cy + t * dy)
}
#let P(p) = (p.at(0) * 1cm, p.at(1) * 1cm)

#let draw-edge(e) = {
  let via = e.at("via", default: ())
  let a = ctr(e.from)
  let b = ctr(e.to)
  let first = if via.len() > 0 { via.first() } else { b }
  let last  = if via.len() > 0 { via.last()  } else { a }
  let pts = (clip(e.from, ..first),) + via + (clip(e.to, ..last),)
  let st = edge-stroke(e.kind)
  for i in range(pts.len() - 1) {
    place(top + left, line(start: P(pts.at(i)), end: P(pts.at(i + 1)), stroke: st))
  }
  let (p, q) = (pts.at(-2), pts.at(-1))
  let (dx, dy) = (q.at(0) - p.at(0), q.at(1) - p.at(1))
  let L = calc.sqrt(dx * dx + dy * dy)
  let (ux, uy) = (dx / L, dy / L)
  let (s, wd) = (0.26, 0.11)
  let base = (q.at(0) - s * ux, q.at(1) - s * uy)
  place(top + left, polygon(fill: ink, stroke: none,
    P(q),
    P((base.at(0) + wd * uy, base.at(1) - wd * ux)),
    P((base.at(0) - wd * uy, base.at(1) + wd * ux))))
  let m = ((pts.first().at(0) + pts.last().at(0)) / 2,
           (pts.first().at(1) + pts.last().at(1)) / 2)
  let off = e.at("lab", default: (0, 0))
  let (mx, my) = (m.at(0) + off.at(0), m.at(1) + off.at(1))
  place(top + left, dx: (mx - 4) * 1cm, dy: (my - 0.5) * 1cm,
    box(width: 8cm, height: 1cm, align(center + horizon,
      box(fill: white, inset: (x: 2pt, y: 1.2pt), radius: 2pt,
        text(7pt, fill: ink, style: "italic", e.label)))))
}

#let draw-node(id) = {
  let (x, y, w, h, f, s, title, sub) = nodes.at(id)
  let c = fam.at(f)
  let st = if s == "i" { (paint: c.stroke, thickness: 1pt, dash: "dashed") } else { 1pt + c.stroke }
  place(top + left, dx: (x - w / 2) * 1cm, dy: (y - h / 2) * 1cm,
    box(width: w * 1cm, height: h * 1cm, fill: c.fill, stroke: st, radius: 4pt, inset: 3pt, {
      place(top + right, dx: 1pt, dy: -1pt, ev-mark(s, c.stroke))
      align(center + horizon, {
        text(9pt, weight: "bold", fill: c.stroke.darken(25%), title)
        if sub != "" { linebreak(); text(7pt, fill: luma(70), sub) }
      })
    }))
}

// =====================================================================
//  PAGE 1 (A3) — dependency DAG
// =====================================================================
#page(paper: "a3", flipped: true, margin: (x: 1.5cm, y: 1.3cm))[
#align(center, text(19pt, weight: "bold")[Linear & integer programming models in MZ 510])
#v(-8pt)
#align(center, text(10pt, fill: luma(90))[
  Arrows run from simpler to richer models. A model can have several parents, so this is a DAG, not a tree.])
#v(6pt)

#block(width: 39cm, height: 19.2cm, {
  let yb = 11.35
  place(top + left, dx: 0cm, dy: yb * 1cm,
    line(length: 39cm, stroke: (paint: rgb("#c0602a"), thickness: 0.9pt, dash: "dash-dotted")))
  place(top + left, dx: 27.0cm, dy: (yb - 0.55) * 1cm,
    text(8pt, fill: rgb("#c0602a"), weight: "bold")[▲ totally unimodular: the LP already gives integer answers])
  place(top + left, dx: 27.0cm, dy: (yb + 0.15) * 1cm,
    text(8pt, fill: rgb("#c0602a"), weight: "bold")[▼ integer programs: binaries, logical, side constraints])

  for e in edges { draw-edge(e) }
  for id in nodes.keys() { draw-node(id) }

  // legend
  place(top + left, dx: 29.6cm, dy: 15.2cm, box(
    width: 9.3cm, inset: 7pt, radius: 4pt, stroke: 0.6pt + luma(170), fill: white, {
      set text(8pt)
      let sw(k) = box(width: 1.2cm, height: 6pt, align(horizon,
        line(length: 1.2cm, stroke: edge-stroke(k))))
      let chip(f) = box(width: 10pt, height: 8pt, fill: fam.at(f).fill,
        stroke: 0.7pt + fam.at(f).stroke, radius: 1.5pt)
      grid(columns: (auto, 1fr), column-gutter: 6pt, row-gutter: 4pt,
        sw("ext"),  [*extension*: adds variables or constraints],
        sw("spec"), [*special case*: restricts structure or data],
        sw("ref"),  [*reformulation*: same problem, recast],
        ev("f"), [formulation / data readable in the slide text],
        ev("t"), [slide title only (content is an image)],
        ev("i"), [inferred from the cited textbook (dashed border)],
      )
      v(3pt)
      chip("lp"); [ General LP #h(6pt)]; chip("net"); [ Network flow #h(6pt)]; chip("ip"); [ Integer program]
    }))
})
]

// =====================================================================
//  PAGE 2 — catalogue of every LP / IP item in the slides
// =====================================================================
#text(13pt, weight: "bold")[Catalogue: every LP / IP item in the slides]
#h(8pt) #text(8pt, fill: luma(90))[#ev("f") readable  #ev("t") title only  #ev("i") inferred]
#v(2pt)

#let sec(t, n: 5) = table.cell(colspan: n, fill: luma(232), text(weight: "bold", t))
#set table(stroke: 0.5pt + luma(190), inset: 4pt)
#[
#set text(8pt)
#set table(inset: 3pt)
#table(
  columns: (0.6cm, 7.4cm, 4.4cm, 1fr, 0.9cm),
  table.header([*\#*], [*Model / example*], [*Graph node*], [*What it adds / key feature*], [*Ev.*]),
  sec[LP Part 1: formulation & graphical solution],
  [1], [Exercise 1: products A, B on one bottleneck machine], [Product mix], [60 h machine (≤), demand caps x ≤ D], ev("f"),
  [2], [Exercise 2: products A, B, C, machine + labour hours], [Product mix], [second resource row (10 labour h)], ev("f"),
  [3], [Graphical solution: A/B with labour, parts, freight], [Product mix], [feasible region, isoprofit line, corner point Z\* = 52,000 at (100, 40)], ev("f"),
  [4], [Introductory formulation slides (Dr. J. Xu)], [—], [content is images; likely LP terminology and assumptions], ev("i"),
  sec[LP Part 2: network & multi-period models],
  [5], [Assignment: 5 assembly lines → 5 inspection areas], [Assignment], [network representation, S#sub[i] = D#sub[j] = 1], ev("f"),
  [6], [Montpelier Ski: balanced transportation (formulation + solution)], [Transportation], [supply = demand], ev("t"),
  [7], [Montpelier Ski: unbalanced transportation], [Unbalanced transp.], [dummy demand/supply point or ≤ supply rows], ev("t"),
  [8], [Sailco inventory, no backlogging (Winston Ch. 3)], [Multi-period inventory], [I#sub[t] = I#sub[t−1] + x#sub[t] − d#sub[t]; regular vs. overtime production], ev("t"),
  [9], [Sailco with backlogging], [Inventory with backlog], [I#sub[t] = I#super[+]#sub[t] − I#super[−]#sub[t], backorder cost], ev("t"),
  [10], ["Formulate an LP and check your solution"], [—], [exercise; content not readable], ev("t"),
  [11], [Sunco Oil maximum flow (+ alternative without artificial arc)], [Max flow], [arc capacities; max flow on artificial arc t → s, or max net outflow of s], ev("t"),
  [12], [Shortest path LP (Dr. J. Goentzel): 6 nodes, 7 arcs], [Shortest path], [flow conservation (+1 / 0 / −1); x#sub[j] ∈ {0,1} relaxes to x#sub[j] ≥ 0], ev("f"),
  [13], [Equipment replacement (3 slides)], [Equipment replacement], [nodes = years, arc (i, j) = buy at i, sell at j], ev("t"),
  sec[LP Part 3: Excel Solver & sensitivity],
  [14], [Lego production: tables & chairs], [Product mix], [bill of materials, large/small bricks], ev("f"),
  [15], [Prison diet: milk, beans, oranges], [Diet / blending], [min cost, ≥ niacin, thiamin, vitamin C], ev("f"),
  [16], [Security force scheduling: 6 overlapping 8-h shifts], [Shift scheduling], [each 4-h period ≥ requirement; integer officers (32)], ev("f"),
  [17], [Distribution problem: 2 plants → 3 DCs], [Transportation], [supply ≤, demand ≥, cost \$450], ev("f"),
  [18], [Swimmers → medley-relay strokes], [Assignment], [unbalanced: 5 swimmers ≤ 1, 4 strokes = 1], ev("f"),
  [19], [Sensitivity report], [(method)], [final value, reduced cost, shadow price, allowable ± ; range of optimality / feasibility], ev("f"),
  sec[Integer Programming],
  [20], [IP introduction (Dr. P. Yadav), ~30 image slides], [Fixed charge · Knapsack · Set covering], [likely: binaries, capital budgeting, fixed charge, set covering, either-or / if-then, LP relaxation, branch & bound], ev("i"),
  [21], [Truck-loading image ("loads")], [Knapsack], [loading/packing motivation], ev("i"),
  [22], [Euling Gas (Winston Ch. 9)], [Piecewise cost], ["c(x) is nonlinear" → transformed into an IP], ev("t"),
  [23], [Plant & warehouse location], [Plant & warehouse location], [binaries y#sub[i], y#sub[e]; supplier, plant & WH capacities; flow balance at plants & WH], ev("f"),
  [24], [Single-machine scheduling with due dates (Winston Ch. 9)], [Single-machine sched.], [4 jobs, min total delay; either-or (big-M) or positional formulation], ev("f"),
  [25], [Shipment consolidation & dispatching (Ghiani et al.): Oxximet], [Shipment consolidation], [route-day binaries y#sub[rt], x#sub[krt]; LTL option v#sub[k]; capacity q#sub[r]; release r#sub[k] / deadline d#sub[k]], ev("f"),
  [26], [Travelling salesman (Paolucci)], [TSP], [degree constraints + subtour elimination (DFJ) or MTZ u#sub[i]], ev("f"),
  [27], [Vehicle routing problem (2 title slides + images)], [VRP], [multiple vehicles, capacity], ev("t"),
)
]

#pagebreak()

// =====================================================================
//  PAGE 3 — modelling devices (variables & constraints)
// =====================================================================
#text(13pt, weight: "bold")[Modelling devices: the "added constraints and variables"]
#v(2pt)
#table(
  columns: (4.3cm, 7.6cm, 1fr, 0.9cm),
  table.header([*Device*], [*Typical form*], [*Where it appears*], [*Ev.*]),
  sec(n: 4)[Continuous LP devices],
  [Resource capacity], [$sum_j a_(i j) x_j <= b_i$], [product mix, Lego], ev("f"),
  [Demand bound], [$x_j <= D_j$], [Exercises 1–2], ev("f"),
  [Covering requirement], [$sum_j a_(i j) x_j >= r_i$], [diet, security shifts], ev("f"),
  [Supply / demand rows], [$sum_j x_(i j) <= s_i$,  $sum_i x_(i j) >= d_j$], [transportation, distribution], ev("f"),
  [Dummy node], [extra column/row with zero cost absorbs imbalance], [unbalanced Montpelier], ev("t"),
  [Flow conservation], [$sum_("out") x - sum_("in") x = b_v$  (+1 / 0 / −1)], [shortest path, max flow, location], ev("f"),
  [Arc capacity], [$0 <= x_(i j) <= u_(i j)$], [Sunco Oil], ev("t"),
  [Artificial return arc], [arc $t -> s$, maximise its flow], [Sunco Oil], ev("t"),
  [Inventory balance], [$I_t = I_(t-1) + x_t - d_t$], [Sailco], ev("t"),
  [Backlogging], [$I_t = I_t^+ - I_t^-$, cost on $I_t^-$], [Sailco with backlog], ev("t"),
  sec(n: 4)[Integer devices],
  [Integrality], [$x in ZZ_(>=0)$], [security officers, IP section], ev("f"),
  [Binary decision], [$y in {0,1}$: open / select / do], [location, routes, scheduling], ev("f"),
  [Linking (fixed charge)], [$x <= M y$  or  $x <= K_i y_i$], [plant & warehouse location], ev("f"),
  [Piecewise-linear cost], [segment binaries, or $x = sum lambda_k b_k$], [Euling Gas], ev("t"),
  [Either-or (disjunctive)], [$S_i + p_i <= S_j + M(1 - y_(i j))$, and the reverse], [single-machine scheduling], ev("f"),
  [If-then / k-of-n], [$g(x) <= M y$, $f(x) <= M(1 - y)$; $sum y <= k$], [IP introduction], ev("i"),
  [Assignment rows], [$sum_j x_(i j) = 1$,  $sum_i x_(i j) = 1$], [assignment, TSP, positional scheduling], ev("f"),
  [Positional completion time], [$sum_i p_i sum_(u=1)^k x_(i u)$], [positional scheduling], ev("f"),
  [Tardiness linearisation], [$t_k >= C_k - d_k$, $t_k >= 0$  (= max(0, ·))], [single-machine scheduling], ev("f"),
  [Subtour elimination (DFJ)], [$sum_(i, j in S) x_(i j) <= |S| - 1$, for all $S subset V$, $2 <= |S| <= n-1$], [TSP], ev("f"),
  [MTZ ordering], [$u_i - u_j + n x_(i j) <= n - 1$,  $2 <= u_i <= n$], [TSP], ev("f"),
  [Vehicle / route capacity], [$sum_k w_k x_(k r t) <= q_r y_(r t)$], [consolidation, VRP], ev("f"),
  [Time windows], [order $k$ may use day $t$ only if $r_k <= t$ and $t + tau_(k r) <= d_k$], [shipment consolidation], ev("f"),
  [Mode choice], [$sum_(r, t) x_(k r t) + v_k = 1$], [consolidation (truck vs. LTL)], ev("f"),
  [Pre-enumerated routes], [variables per route $r in R$ instead of per arc], [consolidation], ev("f"),
)

#pagebreak()

// =====================================================================
//  PAGE 4 — base × modifier grid  +  solution methods
// =====================================================================
#text(13pt, weight: "bold")[Base structure × modifier]
#h(8pt) #text(8pt, fill: luma(90))[
  ★ = in the slides · grey = valid combination you can formulate yourself · — = adds nothing new]
#v(2pt)

#let star(body) = [★ #body]
#let open(body) = text(fill: luma(125), style: "italic", body)
#let na = align(center, text(fill: luma(170))[—])
#let hdr(t, s) = align(center, [#text(weight: "bold", t) \ #text(6.8pt, fill: luma(80), s)])
#let rowh(t, f, s) = [#text(weight: "bold", fill: fam.at(f).stroke.darken(25%), t) \ #text(6.8pt, fill: luma(80), s)]

#table(
  columns: (3.3cm, 1fr, 1fr, 1fr, 1fr, 1fr),
  inset: 5pt,
  fill: (x, y) => if y == 0 { luma(238) } else if x == 0 { luma(248) },
  align: left + horizon,
  table.header(
    [],
    hdr[Time index][x#sub[t], balance across periods],
    hdr[Binaries / fixed charge][y ∈ {0,1}, x ≤ M·y],
    hdr[Logical (big-M)][either-or, if-then],
    hdr[Piecewise / nonlinear][segment binaries],
    hdr[Subtour elimination][DFJ cuts or MTZ u#sub[i]],
  ),
  rowh("General LP", "lp", "≤ / ≥ rows"),
    star[Sailco (± backlog)],
    [#star[Knapsack / capital budget (inferred)] \ #star[Fixed charge (inferred)]],
    star[Single-machine scheduling (either-or)],
    star[Euling Gas],
    na,
  rowh("Covering", "lp", "≥ rows"),
    open[Multi-week rostering],
    star[Set covering (inferred)],
    open[Min-shift-length rules],
    open[Overtime cost tiers],
    na,
  rowh("Transportation", "net", "bipartite supply → demand"),
    open[Production planning as transportation],
    open[Fixed-charge transportation],
    open[Min-shipment-or-zero],
    open[Quantity-discount freight],
    na,
  rowh("Assignment", "net", "s = d = 1"),
    [#star[Positional machine scheduling] \ #star[Shipment consolidation]],
    text(fill: luma(125))[already integral (TU)],
    open[Conflict / precedence pairs],
    na,
    star[TSP → VRP],
  rowh("Transshipment", "net", "min-cost flow"),
    star[Sailco as time-expanded network],
    star[Plant & warehouse location],
    open[Single-sourcing per customer],
    open[Concave arc costs],
    na,
  rowh("Shortest path", "net", "1 unit s → t"),
    star[Equipment replacement],
    text(fill: luma(125))[already integral (TU)],
    open[Resource-constrained SP],
    na, na,
  rowh("Max flow", "net", "max throughput"),
    open[Dynamic (time-expanded) flow],
    open[Network interdiction],
    na, na, na,
)

#v(6pt)
#text(11pt, weight: "bold")[Solution methods covered alongside the models]
#v(2pt)
#table(columns: (4.3cm, 1fr, 0.9cm),
  fill: (x, y) => if y == 0 { luma(238) },
  [*Method*], [*Use*], [*Ev.*],
  [Graphical solution], [2-variable LPs: feasible region, isoprofit line, optimal corner point], ev("f"),
  [Excel Solver], [Spreadsheet models of product mix, diet, scheduling, transportation, assignment], ev("f"),
  [Sensitivity analysis], [Shadow prices, reduced costs, range of optimality (cost coeff.), range of feasibility (RHS)], ev("f"),
  [Total unimodularity], [Why network LPs give integer solutions: shortest-path integrality relaxed to x ≥ 0], ev("f"),
  [LP relaxation, branch & bound], [Standard IP solution method in Winston Ch. 9], ev("i"),
)

#v(6pt)
#block(fill: luma(246), inset: 7pt, radius: 4pt, width: 100%)[
  *Classifying a new model.* (1) Flow conservation at nodes? If yes, start in the network family; if not, general LP.
  (2) Which devices (page 3) were added? If any of them is integer, it sits below the TU line.
  "Scheduling" appears three times: *shift* scheduling (covering LP), *machine* scheduling (sequencing IP),
  and *dispatch* scheduling (shipment consolidation).
]