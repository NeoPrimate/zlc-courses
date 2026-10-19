#import "/lib/imports.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set text(font: "Helvetica", size: 8pt)

#let mc(x) = text(fill: red, x)

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