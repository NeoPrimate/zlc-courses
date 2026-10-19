#set heading(numbering: "1.1.")
#set text(font: "Helvetica")

#import "@preview/lilaq:0.6.0" as lq
#import "@preview/tiptoe:0.4.0"

= EOQ

#let D = 100
#let h = 0.15
#let c = 10
#let S = 10
#let H = c + (c * h)
#let L = 0.095

#let purchase_cost = c * D
#let total_holding_cost(Q) = H * (Q / 2)
#let total_setup_cost(Q) = S * (D / Q)

#let TVC(Q) = total_setup_cost(Q) + total_holding_cost(Q)
#let TC(Q) = total_cost + TVC(Q)

#let eoq(D, S, H) = calc.sqrt((2 * D * S) / H)
#let Q = eoq(D, S, H)

#let tvc_star(D, S, H) = calc.sqrt(2 * D * S * H)

#let cycle_time(D, S, H) = eoq(D, S, H) / D
#let T = cycle_time(D, S, H)

#let order_frequancy(D, S, H) = D / eoq(D, S, H)

#let R = D * L

== Base

Parameters

#table(
  columns: 3,
  stroke: none,
  inset: (x: 1em),
  [$D$], [Demand rate], [items / time],
  [$h$], [Holding cost (rate)], [% / item / time],
  [$H$], [Holding cost], [\$ / item / time],
  [$c$], [Cost], [\$ / item],
  [$S$], [Setup cost], [\$ / order],
  [$L$], [Lead time], [time],
)


Assumptions

- Demand $D$ is *known* and *constant*
- Lead time $L$ is *known* and *constant*
- Replenishment is *instantaneous*
- Setup costs $S$ is *constant*
- Unit cost $c$ is *constant*
- Holding cost $H$ is a *constant*
- No stockouts or backorders allowed

#line(length: 100%)

Start with:

$
  "TC"(Q) = c D + S D / Q + H Q / 2
$

The $c D$ term is not a function of $Q$ so:

$
  "TVC"(Q) = S D / Q + H Q / 2
$

#align(center)[
  #let x = lq.linspace(5, 25, num: 200)
  #let y-s = x.map(total_setup_cost)
  #let y-h = x.map(total_holding_cost)
  #let y-tvc = x.map(TVC)

  #lq.diagram(
    width: 25em,
    height: 20em,
    xaxis: (ticks: ((Q, $Q^*$),), subticks: none),
    yaxis: (ticks: ((TVC(Q), $"TVC"(Q^*)$),), subticks: none),
    xlabel: [$Q$],
    ylabel: [$"TVC"(Q)$],
    lq.plot(x, y-s, mark: none, stroke: 1.5pt, label: [Total Setup Cost]),
    lq.plot(x, y-h, mark: none, stroke: 1.5pt, label: [Total Holding Cost]),
    lq.plot(x, y-tvc, mark: none, stroke: 1.5pt, label: [TVC])
  )
]

Take the derivative of $"TVC"(Q)$:

$
  (dif "TVC"(Q)) / (dif Q) = - (S D) / Q^2 + H / 2
$

Confirm it is a minimum rather than a maximum:

$
  (dif^2 "TVC") / (dif Q^2) = (2 S D) / Q^3 gt 0 "for"  Q gt 0
$

Set it to $0$ to get the minimum (optimal order quantity / batch size):

$
  - (S D) / Q^2 + H / 2 &= 0 \
  Q^* &= sqrt((2 D S) / H)
$

Backfill $Q^*$ into the $"TVC"(Q)$ to get the optimal Total Variable cost corresponding to the $Q^*$:

$
  "TVC"(Q^*) 
  &= S D / Q^* + H Q^* / 2 \
  &= sqrt(2 D S H)
$

$
  "TC"(Q^*) 
  &= c D + "TVC"(Q^*) \
  &= c D + sqrt(2 D S H) \
$

#align(center)[
  #let n-cycles = 3
  #let T = cycle_time(D, S, H)
  #let Q = eoq(D, S, H)
  #let R = D * L

  #let ts = range(n-cycles).map(i => (i * T, (i + 1) * T)).flatten()
  #let is = range(n-cycles).map(i => (Q, 0)).flatten()

  #lq.diagram(
    width: 25em,
    height: 14em,
    xlim: (0, T * n-cycles),
    ylim: (0, Q + (0.1 * Q)),
    xaxis: (
      ticks: (
        (T - L, text(size: 5pt)[Place\ Order]),
        (T, text(size: 5pt)[Receive\ Order]),
        (T * 2 - L, []),
        (T * 2, []),
      ), 
      subticks: none
    ),
    yaxis: (
      ticks: (
        (R, $R$),
        (Q / 2, $Q^* / 2$),
        (Q, $Q^*$),
      ), 
      subticks: none
    ),
    xlabel: [$t$],
    ylabel: [Inventory],
    lq.plot(ts, is, mark: none, stroke: 1.5pt),

    lq.line(
      (T - L, 0), (T, 0),
      tip: tiptoe.triangle, toe: tiptoe.triangle,
      stroke: (paint: black, thickness: 1pt),
      clip: false,
    ),
    lq.place((T - L + T) / 2, -0.5, align: top, $L$),

    lq.line(
      (2 * T, 0), (3 * T, 0),
      tip: tiptoe.triangle, toe: tiptoe.triangle,
      stroke: (paint: black, thickness: 1pt),
      clip: false,
    ),
    lq.place((2 * T + 3 * T) / 2, -0.5, align: top, $T^*$),
  )
]

#line(length: 100%)

== Optimal Cycle Time $t^*$

$
  t^* 
  &= Q^* / D \
  &= sqrt((2 D S) / H) / D \
  &= 1 / D sqrt((2 D S) / H) \
  &= sqrt((2 S) / (D H))
$

$
  t^* = 1 / N^*
$

#line(length: 100%)

== Optimal Order Frequency $N^*$

$
  N^* 
  &= D / Q^* \
  &= D / sqrt((2 D S) / H) \
  &= sqrt((D H) / (2 S))
$

$
  N^* = 1 / t^*
$

#line(length: 100%)

== Cycle Inventory

Cycle inventory is the average amount of stock you're carrying purely because you order in batches instead of receiving supply continuously, one unit at a time, exactly as it's consumed.

$
  Q^* / 2
$

#line(length: 100%)

== Sensitivity

$
  x = Q / Q^*
$

Recall that:

$
  - (S D) / Q^(*2) + H / 2 = 0 quad arrow.long.double quad (S D) / Q^(*2) = H / 2
$

Multiply both sides by $Q^*$:

$
  (S D) / Q^* = (H Q^*) / 2
$

Since the two terms are equal to each other:

$
  "TVC"(Q^*) = 2 dot S D / Q^*, quad "so" S D / Q^* = "TCV"(Q^*) / 2
$

Similarly:

$
  "TVC"(Q^*) = 2 dot H Q^* / 2, quad "so" H Q^* / 2 = "TCV"(Q^*) / 2
$


Therefore:

$
  S D / Q^* = H Q^* / 2 = "TVC"(Q^*)/2
$

Substitute $Q = x Q^*$ into $"TVC"(Q) = (S D)/Q + (H Q)/2$:

$
  "TVC"(x Q^*) 
  &= (S D)/(x Q^*) + (H x Q^*)/2 \
  &= 1/x dot (S D)/Q^* + x dot (H Q^*)/2
$

Simplifying, using the identity above:

$
  "TVC"(x Q^*) 
  &= 1/x dot "TVC"(Q^*)/2 + x dot "TVC"(Q^*)/2 \
  &= "TVC"(Q^*)/2 (x + 1/x)
$

Dividing both sides by $"TVC"(Q^*)$:

$
  "TVC"(Q) / "TVC"(Q^*) = 1/2 (x + 1/x)
$

#line(length: 100%)

== Lead Time $L$

$
  R = d L
$

#line(length: 100%)

== Power of 2 $2^k$

Recall the sensitivity formula:

$
  1 / 2 (x + 1 / x) quad "where" x = Q / Q^*
$

Plugging in $x = Q / Q^* = sqrt(2)$:

$
  1 / 2 (sqrt(2) + 1 / sqrt(2)) = 1 / 2 dot (3 sqrt(2)) / 2 = (3 sqrt(2)) / 4 approx 1.0607
$

Cycle time obtained by picking the best integer $k$

$
  "TVC"(2^k^*) / "TVC"(T^*) lt.eq 1.06
$

#line(length: 100%)

== EPQ

Parameters

#table(
  columns: 3,
  stroke: none,
  inset: (x: 1em),
  fill: (x, y) => if y in (1, 7, 8, 9) { red.transparentize(75%) },
  [$D$], [Demand rate], [items / time],
  [$P$], [Production rate], [items / time],
  [$h$], [Holding cost (rate)], [% / item / time],
  [$H$], [Holding cost], [\$ / item / time],
  [$c$], [Cost], [\$ / item],
  [$S$], [Setup cost], [\$ / order],
  [$L$], [Lead time], [time],
  [$T_p$], [Product time per cycle], [],
  [$T_d$], [Down time per cycle], [],
  [$I_max$], [Maximum inventory], [items],
)

$
  P gt.double D
$

Assumptions

- Demand $D$ is *known* and *constant*
- Lead time $L$ is *known* and *constant*
- #text(fill: red)[Replenishment is *instantaneous*]
- Setup costs $S$ is *constant*
- Unit cost $c$ is *constant*
- Holding cost $H$ is a *constant*
- No stockouts or backorders allowed

$
  T = Q / D
$

$
  T_p = Q / P
$

$
  T_d = T - T_p = Q / D - Q / P
$

$
  I_max = T_p (P - D) = Q (1 - D / P)
$

$
  T_d = I_max / D = Q / D (1 - D / P)
$

$
  1 - D / P = T_d D / Q quad (D H_i("cycles / year")
$

$
  T = T_p + T_d = Q / D
$

$
  macron(I)_max = I_max / 2
$

$
  "TVC"(Q) = S D / Q + H Q / 2 (1 - D / P)
$

$
  "EPQ" = Q^* = sqrt((2 D S) / (H (1 - D / P)))
$

$
  "TVC"(Q) = sqrt(2 D S H (1 - D / P))
$

If $P gt.double D$ then $(1 - D / P) arrow 1$ meaning we have EOQ.

We scale the holding cost $H$

#align(center)[
  #let D = 10
  #let P = 50
  #let h = 0.05
  #let c = 5
  #let H = c * h
  #let S = 15

  #let epq(D, S, H, P) = calc.sqrt((2 * D * S) / (H * (1 - D / P)))
  #let Q = epq(D, S, H, P)

  #let Tp = Q / P
  #let Imax = (P - D) * Tp
  #let Td = Imax / D
  #let T = Tp + Td

  #lq.diagram(
    width: 25em,
    height: 14em,
    xlim: (0, T),
    ylim: (0, Imax * 1.1),
    xaxis: (ticks: ((Tp, []),), subticks: none),
    yaxis: (ticks: ((Imax, $I_"max"$),), subticks: none),
    ylabel: [Inventory Level],

    lq.plot((0, Tp, T), (0, Imax, 0), mark: none, stroke: 1.5pt),

    lq.line((0, 0), (Tp, 0), tip: tiptoe.triangle, toe: tiptoe.triangle,
      stroke: (paint: black, thickness: 1pt), clip: false),
    lq.place(Tp / 2, 0 - 0.5, align: top, $T_p$),

    lq.line((Tp, 0), (T, 0), tip: tiptoe.triangle, toe: tiptoe.triangle,
      stroke: (paint: black, thickness: 1pt), clip: false),
    lq.place((Tp + T) / 2, 0 - 0.5, align: top, $T_d$),

    lq.line((0, -0.15 * Imax), (T, -0.15 * Imax), tip: tiptoe.triangle, toe: tiptoe.triangle,
      stroke: (paint: black, thickness: 1pt), clip: false),
    lq.place(T / 2, -0.15 * Imax - 0.5, align: top, $T$),
  )
]

== Quantity Discounts (All Unit Discount)

Assumptions

- Demand $D$ is *known* and *constant*
- Lead time $L$ is *known* and *constant*
- Replenishment is *instantaneous*
- Setup costs $S$ is *constant*
- #text(fill: red)[Unit cost $c$ is *constant*]
- Holding cost $H$ is a *constant*
- No stockouts or backorders allowed

Breakpoints: $q_0, q_1, dots, q_m$

If order $Q$ is between $q_i$ and $q_(i + 1)$, each unit is obtained at cost $c_i$

The cost decreases as the quantity ordered increases: $c_0 gt.eq c_1 gt.eq dots gt.eq c_(m-1)$

Minimize sum of *purchase*, order, holding costs

*TVC now includes purchase cost*

$
  "TVC"_i (Q) = D c_i + D / Q S + Q / 2 h c_i, quad "for" q_i lt.eq Q lt.eq q_(i+1)
$

$
  (dif "TVC") / (dif Q) = - (S D) / Q^2 + (h c_i) / 2
$

$
  Q^*_i = sqrt((2 D S) / (h c_i))
$

#align(center)[
  #let D = 2000
  #let S = 75
  #let h = 0.20

  #let q = (1000, 2000)
  #let c = (5.00, 4.85, 4.75)

  #let TVC(Q, c) = D * c + D / Q * S + Q / 2 * h * c

  #let Qstar(ci) = calc.sqrt((2 * D * S) / (h * ci))

  #let palette = (rgb("#2a78d6"), rgb("#eb6834"), rgb("#1baf7a"))
  #let breaks = (200,) + q + (3000,)

  #lq.diagram(
    width: 25em,
    height: 20em,
    xaxis: (
      ticks: (
        ..q.enumerate().map(v => (v.at(1), $q_#(v.at(0) + 1)$)),
        // ..c.enumerate().map(v => (Qstar(v.at(1)), $Q^*_#(v.at(0) + 1)$)),
      ),
      subticks: none
    ),
    yaxis: (ticks: none, subticks: none),
    xlabel: [$Q$],
    ylabel: [$"TVC"(Q)$],

    ..c.enumerate().map(v => {
      let i = v.at(0)
      let ci = v.at(1)
      let xs = lq.linspace(breaks.at(i), breaks.at(i + 1), num: 100)
      lq.plot(xs, xs.map(Q => TVC(Q, ci)), mark: none,
        stroke: (thickness: 2pt), label: [$c = #ci$])
    }),
    
    ..c.enumerate().map(v => {
      let x = lq.linspace(200, 3000, num: 200)
      lq.plot(x, x.map(Q => TVC(Q, v.at(1))), mark: none,
        stroke: (dash: "dashed", thickness: 1pt, paint: gray))
    }),
  )
]

- Step 1: Calculate the EOQ for the lowest price. If it is feasible (i.e.,
this order quantity is within the range for that price), then stop.
This is the optimal lot size. Calculate total variable cost (TVC) for
this lot size.
- Step 2: If the EOQ is not feasible, calculate the TVC for this price
and the smallest quantity for that price.
- Step 3: Calculate the EOQ for the next lowest price. If it is feasible,
stop and calculate the TVC for that quantity and price.
- Step 4: Compare the TVC for Steps 2 and 3. Choose the quantity
corresponding to the lowest TVC.
- Step 5: If the EOQ in Step 3 is not feasible, repeat Steps 2, 3, and 4
until a feasible EOQ is found.

Start from lowes price, evaluate EOQ for each $c_i$:
- Case 1: If $q_i lt.eq Q_i lt q_(i+1)$, then $Q_i$ is feasible and

$
  "TVC"_i = D / Q_i S + Q_i / 2 h c_i + D c_i
$

- Case 2: If $Q_i lt q_i$, then choose $q_i$ and

$
  "TVC"_i = D / q_i S + q_i / 2 h c_i + D c_i
$

Select $Q^*$ with the lowest TVC

== Quantity Discounts (Marginal Unit Discount)



== Aggregation

Parameters

#table(
  columns: 3,
  stroke: none,
  inset: (x: 1em),
  fill: (x, y) => if y in (1, 7, 8, 9) { red.transparentize(75%) },
  [$D_i$], [Demand rate], [items / time],
  [$P$], [Production rate], [items / time],
  [$h$], [Holding cost (rate)], [% / item / time],
  [$H$], [Holding cost], [\$ / item / time],
  [$c$], [Cost], [\$ / item],
  [$S$], [Setup cost], [\$ / order],
  [$L$], [Lead time], [time],
  [$T_p$], [Product time per cycle], [],
  [$T_d$], [Down time per cycle], [],
  [$I_max$], [Maximum inventory], [items],
)