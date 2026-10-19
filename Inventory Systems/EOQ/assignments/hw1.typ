#import "@preview/lilaq:0.6.0" as lq
#import "@preview/tiptoe:0.4.0"

#set heading(numbering: "1.a.")
#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)


#set page(
  header: [Assigment 1 #h(1fr) Vladimir Borel],
  numbering: "1"
)

#let result(content) = box(stroke: blue, fill: blue.transparentize(75%), inset: 0.5em, radius: 0.25em)[
  #content
]

#align(center)[
  #text(
    size: 32pt,
    [Assignement 1]
  )
]

= Finite Production
 
_Hyundai's SUV division is selling only one product and is running an independent, fully
automated facility with a production rate of 150 cars per month. The company needs 3 days
of setup period to warm up the facility, and \$1,000 is incurred daily for this task. It is facing a stable customer demand of 1,200 cars per year. The unit production cost is \$15,000 and the selling price is \$25,000. The company is applying an annual unit holding cost of 15% of product cost._

#v(2em)
 
#let D = 1200
 
#let days-in-year = 365
#let months-per-year = 12
#let P_month = 150
#let P = P_month * months-per-year
 
#let S-days = 3
#let S-daily-cost = 1000
#let S = S-days * S-daily-cost
 
#let c = 15000
#let p = 25000
 
#let h = 0.15
#let H = h * c
 
#let epq(D, S, H, P) = calc.sqrt((2 * D * S) / (H * (1 - D / P)))
 
#let q-star = epq(D, S, H, P)
#let q-star = calc.round(q-star, digits: 2)
 
#let purchase-cost = c * D
#let ordering-cost(Q) = S * (D / Q)
#let holding-cost(Q) = H * (Q / 2) * (1 - D / P)
 
#let TC(Q) = purchase-cost + ordering-cost(Q) + holding-cost(Q)
#let TVC(Q) = ordering-cost(Q) + holding-cost(Q)
 
#let total-revenue = p * D
#let TP(Q) = total-revenue - TC(Q)
 
#let cum-ordering-cost(Q) = purchase-cost + ordering-cost(Q)
#let cum-holding-cost(Q) = purchase-cost + holding-cost(Q)
 
#let days-per-year = 365
#let idle-fraction = 1 - D / P
#let idle-days = idle-fraction * days-per-year

#let Imax = q-star * (1 - D / P)
#let Imax = calc.round(Imax, digits: 2)

#let Ibar = Imax / 2
#let Ibar = calc.round(Ibar, digits: 2)

#let Td = (Imax / D) * days-per-year
#let Td = calc.round(Td, digits: 2)

#let Tp = (q-star / P) * days-per-year
#let Tp = calc.round(Tp, digits: 2)
 
#let avg-inventory = q-star * (1 - D / P) / 2
 
- Demand ($D$) = $#D$ units / year
- Sell Price (p) = $#p$ \$ / unit
- Cost (c) = $#c$ \$ / unit
- Setup Cost (S) = $#S$ \$ / batch
- Production rate ($P_"month"$) = $#P_month$ units / month
- Production rate ($P_"year"$) = $#P$ units / year
- Holding cost rate (h) = $#(h * 100)$ % / unit / year
- Holding cost (H) = $#H$ \$ / unit / year
 
#v(2em)
 
*(a)* _How many cars shall Hyundai produce whenever it starts the facility to maximize the total profit in the long run? (5 points)_
 
The total profit is given by the function:
 
$
  "TP"(Q)
  &= "TR" - "TC"(Q) \
  &= underbrace(p D, "Total\nRevenue") - underbrace(c D, "Purchasing\nCost") quad - quad underbrace(S D / Q, "Ordering\nCost") quad - quad underbrace(H / 2 (1 - D / P) Q, "Holding\nCost")
$
 
Maximize the total profit w.r. to $Q$:
 
$
  Q^* = op(arg max, limits: #true)_Q "TP"(Q)
$
 
Taking the derivative:
 
$
  (dif "TP") / (dif Q)
  &= dif / (dif Q) [p D - c D - S D / Q - H / 2 (1 - D / P) Q] \
  &= dif / (dif Q) [p D] - dif / (dif Q) [c D] - dif / (dif Q) [S D / Q] - H/2 (1 - D/P) dif / (dif Q) [Q] \
  &= 0 - 0 - dif / (dif Q) [S D dot Q^(-1)] - H/2 (1 - D/P) dot 1 \
  &= - S D dot dif / (dif Q) [Q^(-1)] - H/2 (1 - D/P) \
  &= - S D dot (-1) Q^(-2) - H/2 (1 - D/P) \
  &= S D / Q^2 - H/2 (1 - D/P)
$
 
Setting the derivative equal to zero to find the critical point:
 
$
  S D / Q^2 - H/2 (1 - D/P) &= 0 \
  H/2 (1 - D/P) &= (D S) / Q^2 \
  Q^2 &= (2 D S) / (H (1 - D/P)) \
  Q &= sqrt((2 D S) / (H (1 - D/P)))
$
 
To confirm this critical point is a maximum rather than a minimum, check the second derivative:
 
$
  (dif^2 "TP") / (dif Q^2)
  &= (dif) / (dif Q) [(D S) / Q^2 - H/2 (1 - D/P)] \ \
  &= (dif) / (dif Q) [D S Q^(-2)] - 0 \ \
  &= D S dot (dif) / (dif Q) [Q^(-2)] \ \
  &= D S dot (-2) Q^(-3) \ \
  &= -(2 D S) / Q^3
$
 
Since $D, S, Q > 0$, $(dif^2 "TP")/(dif Q^2) < 0$ for all $Q > 0$, confirming $"TP"(Q)$ is concave and the critical point $Q^* = sqrt((2 D S) / (H (1 - D/P)))$ is a maximum.
 
Using the formula we derived:
 
$
  Q^*
  &= sqrt((2 D S) / (H (1 - D / P))) \
  &= sqrt((2 (#D) (#S)) / (#H * (1 - #D / #P))) \
  &= #result([#q-star])
$
 


Therefore, the total profit:
 
$
  "TP"(Q^*)
  &= p D - c D - S D / Q^* - H/2 (1 - D/P) Q^* \
  &= (#p)(#D) - (#c)(#D) - #S (#D) / (#q-star) - (#H)/2 (1 - #D/#P) (#q-star) \
  &= #calc.round(TP(q-star), digits: 2)
$
 
 
#align(center)[
  #let x = lq.linspace(10, 150, num: 200)
  #let y-tp = x.map(TP)
  // #let y-tc = x.map(TC)
  // #let y-holding-cost = x.map(cum-holding-cost)
 
  #lq.diagram(
    width: 10cm,
    height: 8cm,
    xlabel: [$Q$],
    ylabel: [$"TP"(Q)$],
    lq.plot(x, y-tp, mark: none, stroke: 1.5pt, label: [TP]),
    // lq.plot(x, y-tc, mark: none, stroke: green + 1.5pt, label: [Holding Cost]),
    // lq.plot(x, y-cum-holding-cost, mark: none, stroke: blue + 1.5pt, label: [Ordering Cost]),
    lq.vlines(q-star, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
    lq.hlines(TP(q-star), stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
  )
]
 
#v(2em)
 
*(b)* _How many cars shall the company produce whenever it starts the facility to minimize the total cost in the long run? (5 points)_
 
The total cost is given by the function:
 
$
  "TC"(Q)
  &= underbrace(c D, "Purchasing\nCost") quad + quad underbrace(S D / Q, "Ordering\nCost") quad + quad underbrace(H / 2 (1 - D / P) Q, "Holding\nCost")
$
$
  "TVC"(Q)
  &= underbrace(S D / Q, "Ordering\nCost") quad + quad underbrace(H / 2 (1 - D / P) Q, "Holding\nCost")
$
 
Minimize the total cost w.r. to $Q$:
 
$
  Q^* = op(arg min, limits: #true)_Q "TVC"(Q)
$
 
Find the first derivative of the total variable cost function:
 
$
  (dif "TVC") / (dif Q)
    &= (dif) / (dif Q) [ S D/Q + H/2 (1 - D/P) Q ] \ \
    &= (dif) / (dif Q) (D S Q^(-1)) + H/2 (1 - D/P) dot (dif) / (dif Q) (Q) \ \
    &= D S dot (dif) / (dif Q) (Q^(-1)) + H/2 (1 - D/P) dot 1 \ \
    &= D S dot (-1) Q^(-2) + H/2 (1 - D/P) \ \
    &= -(D S) / Q^2 + H/2 (1 - D/P)
$
 
Setting the derivative equal to zero to find the critical point:
 
$
  -(D S) / Q^2 + H/2 (1 - D/P) &= 0 \ \
  H/2 (1 - D/P) &= (D S) / Q^2 \ \
  Q^2 &= (2 D S) / (H (1 - D/P)) \ \
  Q^* &= sqrt((2 D S) / (H (1 - D/P)))
$
 
To confirm this critical point is a minimum rather than a maximum, check the second derivative:
 
$
  (dif^2 "TVC") / (dif Q^2)
    &= (dif) / (dif Q) [-(D S) / Q^2 + H/2 (1 - D/P)] \ \
    &= (dif) / (dif Q) [-D S Q^(-2)] + 0 \ \
    &= -D S dot (dif) / (dif Q) [Q^(-2)] \ \
    &= -D S dot (-2) Q^(-3) \ \
    &= (2 D S) / Q^3
$
 
Since $D, S, Q > 0$, $(dif^2 "TVC")/(dif Q^2) > 0$ for all $Q > 0$, confirming $"TVC"(Q)$ is convex and the critical point $Q^* = sqrt((2 D S) / (H (1 - D/P)))$ is a minimum.
 
Using the formula we derived:
 
$
  Q^*
  &= sqrt((2 D S) / (H (1 - D/P))) \
  &= sqrt((2 (#D) (#S)) / (#H * (1 - #D/#P))) \
  &= #result([#q-star])
$
 
Therefore, the total cost:
 
$
  "TC"(Q^*)
  &= c D + S D / Q^* + H/2 (1 - D/P) Q^* \
  &= (#c)(#D) + #S (#D) / (#q-star) + (#H)/2 (1 - #D/#P) (#q-star) \
  &= #calc.round(TC(q-star), digits: 2)
$
 
#align(center)[
  #let x = lq.linspace(10, 150, num: 200)
  #let y-tc = x.map(TC)
  #let y-cum-ordering-cost = x.map(cum-ordering-cost)
  #let y-cum-holding-cost = x.map(cum-holding-cost)
 
  #lq.diagram(
    width: 10cm,
    height: 8cm,
    xlabel: [$Q$],
    ylabel: [$"TC"(Q)$],
    lq.plot(x, y-tc, mark: none, stroke: 1.5pt, label: [TC]),
    lq.plot(x, y-cum-ordering-cost, mark: none, stroke: 1.5pt, label: [Ordering Cost]),
    lq.plot(x, y-cum-holding-cost, mark: none, stroke: 1.5pt, label: [Holding Cost]),
    lq.vlines(q-star, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
    lq.hlines(TC(q-star), stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
  )
]
 
And total variable cost:
 
$
  "TVC"(Q^*)
  &= sqrt(2 D S H (1 - D / P)) \
  &= sqrt(2 (#D) (#S) (#H) (1 - #D / #P)) \
  &= #calc.round(TVC(q-star), digits: 2)
$
 
#align(center)[
  #let x = lq.linspace(10, 150, num: 200)
  #let y-tvc = x.map(TVC)
  #let y-holding-cost = x.map(holding-cost)
  #let y-ordering-cost = x.map(ordering-cost)
 
  #lq.diagram(
    width: 10cm,
    height: 8cm,
    xlabel: [$Q$],
    ylabel: [$"TVC"(Q)$],
    // xaxis: (ticks: (q-star,)),
    // yaxis: (ticks: (TVC(q-star),)),
    lq.plot(x, y-tvc, mark: none, stroke: 1.5pt, label: [TVC]),
    lq.plot(x, y-ordering-cost, mark: none, stroke: 1.5pt, label: [Ordering Cost]),
    lq.plot(x, y-holding-cost, mark: none, stroke: 1.5pt, label: [Holding Cost]),
    lq.vlines(q-star, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
    lq.hlines(TVC(q-star), stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
  )
]
 
#v(2em)
 
*(c)* _How many days per year shall the facility be idle for (b) above? (5 points)_

#let N = D / q-star
#let N = calc.round(N, digits: 2)

#let p = P / days-per-year
#let p = calc.round(p, digits: 2)

#let yearly-production-time = D / p
#let yearly-production-time = calc.round(yearly-production-time, digits: 2)

#let total-setup-days = N * S-days

#let total-idle-days = days-per-year - yearly-production-time - total-setup-days

*Assuming idle days do not include setup*

$
  T_c = T_s + T_p + T_i
$

Where:
- $T_c$: Cycle time
- $T_s$: Setup time
- $T_p$: Production time
- $T_i$: Idle time

$
  T_p = Q / P
$

Number of production runs a year:

$
  N = D / Q^* = #D / #q-star = #N
$

Daily production:

$
  p = #P / #days-per-year = #p
$

Running (production) time per year

$
  D / p = #D / #p = #yearly-production-time
$

Each of the approximately #N runs requires a 3 day setup:

$
  N times 3 = #N times 2 = #total-setup-days
$

Idle time per year = Total days - running days - setup days


$
  #days-per-year - #yearly-production-time - #total-setup-days = #result[#total-idle-days]
$

*Assuming idle days include setup*



$
  T_c = T_p + T_i
$

Where:
- $T_c$: Cycle time
- $T_p$: Production time
- $T_i$: Idle time

#let T = q-star / D

$
  T_p 
  &= Q / P \
  &= #q-star / #P \
  &= #Tp
$

$
  N 
  &= D / Q^* \
  &= #D / #q-star \
  &= #N \
$

#let idle = days-in-year - Tp * N
#let idle = calc.round(idle, digits: 2)

$
  T_i = 365 - N times T_p = #result[#idle]
$

Equivalently,

$
  T_p 
  &= Q / P \
  &= #q-star / #P \
  &= #Tp
$

$
  T 
  &= Q^* / D \
  &= #q-star / #D \
  &= #T
$

$
  T_d 
  &= T - T_p \
  &= #T - Tp \
  &= #Td
$

$
  N 
  &= D / Q^* \
  &= #D / #q-star \
  &= #N \
$

#let idle = Td * N
#let idle = calc.round(idle, digits: 2)

$
  #result([#idle])
$
 
*(d)* _What is the average inventory level for (b) above in the long run? (5 points)_
 
Average inventory over the cycle is half of the peak:
 
$
  I_"max" 
  &= Q^* (1 - D/P) \
  &= (#q-star)(1 - (#D)/(#P)) \
  &= Imax \
  \ \ \
  macron(I) 
  &= I_max / 2 \
  &= #Imax / 2 \
  &= #result([#Ibar])
$

#let epq(D, S, H, P) = calc.sqrt((2 * D * S) / (H * (1 - D / P)))
#let Q = epq(D, S, H, P)

// #let Tp = Q / P
// #let Imax = (P - D) * Tp
// #let Td = Imax / D
#let T = Tp + Td

#align(center)[

  #lq.diagram(
    width: 10cm,
    height: 8cm,
    xlim: (0, T),
    ylim: (0, Imax * 1.1),
    xaxis: (ticks: ((Tp, []),), subticks: none),
    yaxis: (
      ticks: (
        (Imax, $I_"max" = #Imax$),
        (Ibar, $macron(I) = #Ibar$),
      ), 
      subticks: none
    ),
    ylabel: [Inventory Level],

    lq.plot((0, Tp, T), (0, Imax, 0), mark: none, stroke: 1.5pt),

    lq.line((0, 0), (Tp, 0), tip: tiptoe.triangle, toe: tiptoe.triangle,
      stroke: (paint: black, thickness: 1pt), clip: false),
    lq.place(Tp / 2, 0 - 0.5, align: top, $T_p = #Tp$),

    lq.line((Tp, 0), (T, 0), tip: tiptoe.triangle, toe: tiptoe.triangle,
      stroke: (paint: black, thickness: 1pt), clip: false),
    lq.place((Tp + T) / 2, 0 - 0.5, align: top, $T_d = Td$),

    lq.line((0, -0.15 * Imax), (T, -0.15 * Imax), tip: tiptoe.triangle, toe: tiptoe.triangle,
      stroke: (paint: black, thickness: 1pt), clip: false),
    lq.place(T / 2, -0.15 * Imax - 0.5, align: top, $T = #T$),
  )
]

*(e)* _How much is the average total profit per year in the long run? (5 points)_
 
$
  "TP"(Q^*)
  &= "TR" - "TC"(Q^*) \
  &= underbrace(p D, "Total\nRevenue") - underbrace(c D, "Purchasing\nCost") quad - quad underbrace(S D / Q^*, "Ordering\nCost") quad - quad underbrace(H/2 (1 - D/P) Q^*, "Holding\nCost") \
  &= (#p)(#D) - (#c)(#D) - #S (#D) / (#q-star) - (#H)/2 (1 - #D/#P) (#q-star) \
  &= #result([#calc.round(TP(q-star), digits: 2)])
$
 
*(f)* _Now the company has a new constraint on the production batch size and the production quantity should be a multiple of 40, i.e., 40 - 80 - 120 - 160 - ..., whenever it runs the facility. How much is the optimal production quantity to minimize the long-run cost? (5 points)_
 
The constrained optimum must be one of the two feasible batch sizes bracketing $Q^*$: $Q = 80$ or $Q = 120$:
 
#let Q1 = 80
#let Q2 = 120
 
$
  "TC"(#Q1) &= c D + S D / #Q1 + H/2 (1 - D/P) #Q1 = #result[#calc.round(TC(Q1), digits: 2)] \
  "TC"(#Q2) &= c D + S D / #Q2 + H/2 (1 - D/P) #Q2 = #result[#calc.round(TC(Q2), digits: 2)] \
$
 
Both 

$Q = #result([80])$ 

and 

$Q = #result([120])$ 

are optimal, tied at:
 
$
  "TC"_min = #calc.round(TC(Q1), digits: 2)
$
 
which is $#calc.round(TC(Q1) - TC(q-star), digits: 2)$ \$ higher per year than the unconstrained
minimum of $#calc.round(TC(q-star), digits: 2)$ \$.
 
#align(center)[
  #let x = lq.linspace(10, 200, num: 200)
  #let y-tc = x.map(TC)
 
  #lq.diagram(
    width: 10cm,
    height: 8cm,
    xlabel: [$Q$],
    ylabel: [$"TC"(Q)$],
    lq.plot(x, y-tc, mark: none, stroke: 1.5pt, label: [TC]),
    lq.vlines(q-star, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
    lq.vlines(Q1, Q2, stroke: (paint: blue, dash: "dashed", thickness: 1.5pt)),
    lq.hlines(TC(Q1), stroke: (paint: blue, dash: "dashed", thickness: 1.5pt)),
  )
]

= All unit and marginal unit discounts (Max Points 30)

_Ericson's mobile communications division, a smartphone manufacturer, uses 20,000 memory
chips per month. Their transportation service provider charges Ericson \$300 per shipment,
independently of the quantity purchased. The manufacturer offers an all unit quantity
discount with a price of \$1 per memory chip for orders up to 18,000 units, \$0.96 per chip for
orders between 18,000 and 36,000 units, and \$0.92 per chip for orders larger than 36,000
units. Ericson incurs an annual unit holding cost of 15% of product cost._

#v(1em)

#let months-per-year = 12
#let D-monthly = 20000
#let D = D-monthly * months-per-year
#let S = 300
#let q = (18000, 36000)
#let p = (1, 0.96, 0.92)
#let h = 0.15

- Demand $D$ = $#D$ units/year
- Setup cost $S$ = \$$#S$/order
- Holding cost rate $h$ = $#(h*100)%$ of unit cost
- Break points: $q_1 = 18000$, $q_2 = 36000$
- Price $c_i$ (\$/unit): $c_1 = 1$, $c_2 = 0.96$, $c_3 = 0.92$

#v(1em)

*(a)* _What is the optimal lot size for Ericson? (5 points)_

The total annual cost for bracket $i$ is:

$
  "TVC"_i (Q) = D c_i + D / Q S + Q / 2 h c_i
$

which is minimized at

$
  (dif "TVC"_i (Q)) / (dif Q) = - (D S) / Q^2 + (h c_i) / 2 = 0 quad arrow.double quad Q^*_i = sqrt((2 D S) / (h c_i))
$

#let Qstar(c) = calc.sqrt((2 * D * S) / (h * c))
#let TVC(Q, c) = D * c + D / Q * S + Q / 2 * h * c

#let Qstar-1 = calc.round(Qstar(p.at(0)), digits: 2)
#let Qstar-2 = calc.round(Qstar(p.at(1)), digits: 2)
#let Qstar-3 = calc.round(Qstar(p.at(2)), digits: 2)

#let tvc-1 = calc.round(TVC(18000, p.at(0)), digits: 2)
#let tvc-2 = calc.round(TVC(Qstar(p.at(1)), p.at(1)), digits: 2)
#let tvc-3 = calc.round(TVC(36000, p.at(2)), digits: 2)


#table(
  columns: 7,
  inset: 0.8em,
  align: center + horizon,
  [*Bracket*], [*Range*], [*Price*], [*Unconstrained $Q^*_i$*], [*Feasible?*], [*Best $Q$ in bracket*], [*$"TVC"_i$*],
  [1], [$0 lt.eq Q lt.eq 18000$], [1], [#Qstar-1], [No (too large)], [18,000], [#tvc-1],
  [2], [$18000 lt.eq Q lt.eq 36000$], [0.96], [#Qstar-2], [Yes], [#Qstar-2], [#tvc-2],
  [3], [$Q gt.eq 36000$], [0.92], [#Qstar-3], [No (too small)], [36,000], [#tvc-3],
)

#align(center)[
  #let breaks = (200,) + q + (70000,)

  #lq.diagram(
    width: 10cm,
    height: 8cm,
    ylim: (220000, 260000),
    xaxis: (
      ticks: q.enumerate().map(v => (v.at(1), $q_#(v.at(0) + 1)$)),
      subticks: none,
    ),
    xlabel: [$Q$],
    ylabel: [$"TVC"(Q)$],

    ..p.enumerate().map(v => {
      let i = v.at(0)
      let ci = v.at(1)
      let xs = lq.linspace(breaks.at(i), breaks.at(i + 1), num: 100)
      lq.plot(xs, xs.map(Q => TVC(Q, ci)), mark: none,
        stroke: (thickness: 2pt), label: [$c = #ci$])
    }),

    ..p.enumerate().map(v => {
      let x = lq.linspace(200, breaks.last(), num: 200)
      lq.plot(x, x.map(Q => TVC(Q, v.at(1))), mark: none,
        stroke: (dash: "dashed", thickness: 1pt, paint: gray))
    }),

    lq.scatter((36000,), (tvc-3,), size: 10pt, color: black),
  )
]

$
  Q^* = #result([36,000])
$

*(b)* _What is the annual cost of such a policy? (5 points)_

$
  "TVC"(Q^*) = "TVC"(36000) = D(0.92) + D/36000 (300) + 36000/2 (0.15)(0.92) = #result([#tvc-3])
$

*(c)* _What is the cycle inventory of memory chips at Ericson? (5 points)_

$
  Q^* / 2 = 36000 / 2 = #result([18,000])
$

#v(1em)

*[(d)-(e)]* _The manufacturer now offers a "marginal" unit quantity discount for the chips. The
first 18,000 chips of any order are sold at \$1 per unit, the next 18,000 units are sold at \$0.96
and any quantity over 36,000 chips is sold for \$0.92 per unit._

*(d)* _What is the optimal lot size for Ericson given this pricing structure, what is the
resulting cost, and how does it compare with that in (a) and (b)? (10 points)_
 
$
  C_1 (Q) &= Q &&"for " 0 lt.eq Q lt.eq 18000 \
  C_2 (Q) &= 18000 + 0.96 (Q - 18000) quad quad &&"for " 18000 lt.eq Q lt.eq 36000 \
  C_3 (Q) &= 35280 + 0.92 (Q - 36000) &&"for " Q gt.eq 36000
$
 
$
  "TVC"_i (Q) = D / Q (S + C_i (Q)) + h / 2 C_i (Q)
$
 
$
  (dif "TVC"_i) / (dif Q) = - (D (S + R_i)) / Q^2 + (h p_i) / 2 = 0
  quad arrow.double quad
  Q^*_i = sqrt((2 D (S + R_i)) / (h p_i))
$
 
#let R = (0, 720.0, 2160.0)
#let Qstar-marg(i) = calc.round(calc.sqrt((2 * D * (S + R.at(i))) / (h * p.at(i))), digits: 2)
#let TVC-marg(Q, i) = {
  let C = R.at(i) + p.at(i) * Q
  D / Q * (S + C) + h / 2 * C
}
 
#let qm-1 = Qstar-marg(0)
#let qm-2 = Qstar-marg(1)
#let qm-3 = Qstar-marg(2)
 
#let tvcm-1 = calc.round(TVC-marg(18000, 0), digits: 2)
#let tvcm-2 = calc.round(TVC-marg(36000, 1), digits: 2)
#let tvcm-3 = calc.round(TVC-marg(qm-3, 2), digits: 2)
 
#align(center)[
  #table(
    columns: 7,
    inset: 0.8em,
    align: center + horizon,
    [*Bracket*], [*Range*], [*Price $p_i$*], [*$R_i$*], [*Unconstrained $Q^*_i$*], [*Feasible?*], [*$"TVC"_i$*],
    [1], [$0 lt.eq Q lt.eq 18000$], [1], [0], [#qm-1], [No (too large)], [#tvcm-1],
    [2], [$18000 lt.eq Q lt.eq 36000$], [0.96], [720], [#qm-2], [No (too large)], [#tvcm-2],
    [3], [$Q gt.eq 36000$], [0.92], [2160], [#qm-3], [*Yes*], [#tvcm-3],
  )
]
  
#align(center)[
  #let plot-domain = (500,) + q + (130000,)
 
  #lq.diagram(
    width: 13cm,
    height: 10cm,
    ylim: (225000, 260000),
    xaxis: (
      ticks: q.enumerate().map(v => (v.at(1), $q_#(v.at(0) + 1)$)),
      subticks: none,
    ),
    xlabel: [$Q$],
    ylabel: [$"TVC"(Q)$],
 
    ..p.enumerate().map(v => {
      let i = v.at(0)
      let xs = lq.linspace(plot-domain.at(i), plot-domain.at(i + 1), num: 100)
      lq.plot(xs, xs.map(Q => TVC-marg(Q, i)), mark: none,
        stroke: (thickness: 2pt), label: [$p_#(i + 1) = #v.at(1)$])
    }),
 
    ..p.enumerate().map(v => {
      let i = v.at(0)
      let xs = lq.linspace(plot-domain.first(), plot-domain.last(), num: 200)
      lq.plot(xs, xs.map(Q => TVC-marg(Q, i)), mark: none,
        stroke: (dash: "dashed", thickness: 1pt, paint: gray))
    }),
 
    lq.scatter((qm-3,), (tvcm-3,), size: 6pt, color: black),
  )
]
 
$
  Q^*_"marginal" = #result([#qm-3])
$
 
(compare to the bracket boundaries $18000$ and $36000$)
 
$
  "TVC"(Q^*_"marginal") = #result([#tvcm-3])
$

Comparison: the marginal-discount optimum requires ordering more than twice
as much per shipment (#qm-3 vs. 36,000) to reach a comparable cost level, and even so the
resulting annual cost, \$#tvcm-3, is higher than the all-units discount's \$#tvc-3.
 
*(e)* _What is the cycle inventory of memory chips at Ericson given the ordering policy? (5 points)_
 
$
  Q^*_"marginal" / 2 = #qm-3 / 2 = #result([#calc.round(qm-3 / 2, digits: 2)])
$

= Shipment aggregation (Max Points 20)

_LG, a refiner in Barcelona, serves three customers near Zaragoza, and maintains consignment
inventory (owned by LG) at each location. Demand at the large customer is 48 tons a year,
demand at the medium customer is 24 tons per year, and demand at the small customer is 12
tons per year. Product cost for LG is \$80,000 per ton and the annual unit holding cost has been
estimated to 15% of product cost. Currently, LG uses full-truckload transportation to deliver
separately to each customer. Truck capacity is 12 tons and each delivery costs \$700 plus \$150
per stop (thus, delivering to each customer separately costs \$850 per truck). LG is considering
aggregating deliveries to Zaragoza on a single truck._

#v(2em)

#let Dl = 48
#let Dm = 24
#let Ds = 12
#let C = 80000
#let h = 0.15
#let capacity = 12
#let S = 700
#let stop-cost = 150
#let H = C * h
#let n-cust = 3

#let Sl = S + stop-cost
#let Sm = S + stop-cost
#let Ss = S + stop-cost

- Demand
  - Large ($D_l$) = #Dl tons / year
  - Medium ($D_m$) = #Dm tons / year
  - Small ($D_s$) = #Ds tons / year
- Unit cost ($C$) = #C \$ / ton
- Holding cost rate ($h$) = #(h * 100) %
- Holding cost ($H = C h$) = #H \$ / ton / year
- Truck capacity ($M$) = #capacity tons / truck
- Major delivery cost ($S$) = #S \$ / delivery
- Minor stop cost ($s_i$) = #stop-cost \$ / stop
- Cost of a solo delivery ($S_i = S + s_i$) = #Sl \$ / truck

#v(2em)

*(a)* _What is the annual transportation and holding cost if LG ships a full truckload each time
a customer is running out of stock? How many days of inventory are carried at each customer
under this policy? (5 points)_

#let Qa = capacity

#let n-a-l = Dl / Qa
#let n-a-m = Dm / Qa
#let n-a-s = Ds / Qa

#let tr-a-l = n-a-l * Sl
#let tr-a-m = n-a-m * Sm
#let tr-a-s = n-a-s * Ss

#let h-a-l = (Qa / 2) * H
#let h-a-m = (Qa / 2) * H
#let h-a-s = (Qa / 2) * H

#let tc-a-l = tr-a-l + h-a-l
#let tc-a-m = tr-a-m + h-a-m
#let tc-a-s = tr-a-s + h-a-s
#let tc-a-total = tc-a-l + tc-a-m + tc-a-s

#let days-a-l = 365 * Qa / (2 * Dl)
#let days-a-m = 365 * Qa / (2 * Dm)
#let days-a-s = 365 * Qa / (2 * Ds)

Since every truck is full (#Qa tons):

- #calc.round(n-a-l, digits: 2) trips/year to the large customer
- #calc.round(n-a-m, digits: 2) trips/year to the medium customer
- #calc.round(n-a-s, digits: 2) trips/year to the small customer

#table(
  columns: 5,
  [*Customer*], [*Deliveries/yr*], [*Transport cost*], [*Holding cost*], [*Total cost*],
  [Large], [#calc.round(n-a-l, digits: 2)], [\$#calc.round(tr-a-l, digits: 0)], [\$#calc.round(h-a-l, digits: 0)], [\$#calc.round(tc-a-l, digits: 0)],
  [Medium], [#calc.round(n-a-m, digits: 2)], [\$#calc.round(tr-a-m, digits: 0)], [\$#calc.round(h-a-m, digits: 0)], [\$#calc.round(tc-a-m, digits: 0)],
  [Small], [#calc.round(n-a-s, digits: 2)], [\$#calc.round(tr-a-s, digits: 0)], [\$#calc.round(h-a-s, digits: 0)], [\$#calc.round(tc-a-s, digits: 0)],
)

Total annual cost = #result([\$#calc.round(tc-a-total, digits: 0)])
- Transportation #result([\$#calc.round(tr-a-l + tr-a-m + tr-a-s, digits: 0)])
- Holding #result([\$#calc.round(h-a-l + h-a-m+ h-a-s, digits: 0)])

Days of inventory carried (average inventory ÷ average daily demand, $= 365 Q\/(2D)$: 
- large = #result([#calc.round(days-a-l, digits: 1) days])
- medium = #result([#calc.round(days-a-m, digits: 1) days])
- small = #result([#calc.round(days-a-s, digits: 1) days.])

#v(2em)

*(b)* _What is the optimal delivery policy to each customer if LG ships separately (not
necessarily full truckloads) to each of them? What is the annual transportation and holding
cost? How many days of inventory are carried at each customer under this policy? (5 points)_

#let Ql = calc.sqrt(2 * Dl * Sl / H)
#let Qm = calc.sqrt(2 * Dm * Sm / H)
#let Qs = calc.sqrt(2 * Ds * Ss / H)

#let TCl = calc.sqrt(2 * Dl * Sl * H)
#let TCm = calc.sqrt(2 * Dm * Sm * H)
#let TCs = calc.sqrt(2 * Ds * Ss * H)
#let TC_nonagg = TCl + TCm + TCs

#let n-b-l = Dl / Ql
#let n-b-m = Dm / Qm
#let n-b-s = Ds / Qs

#let days-b-l = 365 * Ql / (2 * Dl)
#let days-b-m = 365 * Qm / (2 * Dm)
#let days-b-s = 365 * Qs / (2 * Ds)

Each customer order its own lot size

$
  Q_i^* = sqrt((2 D_i S_i) / H)
$ 

#table(
  columns: 5,
  [*Customer*], [*$Q^*$ (tons)*], [*Orders/yr*], [*Days of inventory*], [*Annual cost*],
  [Large], [#calc.round(Ql, digits: 2)], [#calc.round(n-b-l, digits: 2)], [#calc.round(days-b-l, digits: 1)], [\$#calc.round(TCl, digits: 0)],
  [Medium], [#calc.round(Qm, digits: 2)], [#calc.round(n-b-m, digits: 2)], [#calc.round(days-b-m, digits: 1)], [\$#calc.round(TCm, digits: 0)],
  [Small], [#calc.round(Qs, digits: 2)], [#calc.round(n-b-s, digits: 2)], [#calc.round(days-b-s, digits: 1)], [\$#calc.round(TCs, digits: 0)],
)

Total annual (transportation + holding) cost = #result([\$#calc.round(TC_nonagg, digits: 0)])

#v(2em)

*(c)* _What is the optimal delivery policy to each customer if LG aggregates shipments to each
of the three customers on every truck that goes to Zaragoza? What is the annual
transportation and holding cost? How many days of inventory are carried at each customer
under this policy? (10 points)_

#let S-agg = S + n-cust * stop-cost
#let D-agg = Dl + Dm + Ds

#let Q-agg = calc.sqrt(2 * D-agg * S-agg / H)
#let TC-agg = calc.sqrt(2 * D-agg * S-agg * H)
#let n-agg = D-agg / Q-agg

#let t-agg = Q-agg / D-agg
#let t-agg-days = t-agg * 365
#let days-agg = 365 * t-agg / 2

#let q-c-l = t-agg * Dl
#let q-c-m = t-agg * Dm
#let q-c-s = t-agg * Ds

Truck makes one route to all #n-cust customers per trip, so the fixed cost becomes:

$
  S_"agg" = S + n s_i = #S + (#n-cust) #stop-cost = #S-agg
$ 

over the combined demand $D_"agg" = $ #D-agg tons/year

$ 
  Q_"agg"^* = sqrt((2 D_"agg" S_"agg") / H) = #calc.round(Q-agg, digits: 2) "tons per trip" 
$

#table(
  columns: 3,
  [*Customer*], [*Shipment size per trip (tons)*], [*Days of inventory*],
  [Large], [#calc.round(q-c-l, digits: 2)], [#calc.round(days-agg, digits: 1)],
  [Medium], [#calc.round(q-c-m, digits: 2)], [#calc.round(days-agg, digits: 1)],
  [Small], [#calc.round(q-c-s, digits: 2)], [#calc.round(days-agg, digits: 1)],
)

They all carry the *same* number of days of inventory (#calc.round(days-agg, digits: 1) days)

Total annual (transportation + holding) cost = #result([\$#calc.round(TC-agg, digits: 0)]), versus
\$#calc.round(TC_nonagg, digits: 0) under separate optimal delivery 

A saving of \$#calc.round(TC_nonagg - TC-agg, digits: 0) (≈ #calc.round((TC_nonagg - TC-agg) / TC_nonagg * 100, digits: 1)%), and \$#calc.round(tc-a-total - TC-agg, digits: 0) versus the original full-truckload policy.

#v(2em)

= Power of two policies (Max Points 20)

_EasyWash is a washing machine manufacturer operating in Europe. One of its best-selling
models is produced in the firm's manufacturing site in Zaragoza and consists of three core
subassemblies: rotor, cylinder, and frame. While the rotor is manufactured in-house, the other
two subassemblies (cylinder and frame) are sourced from Asia. The cost for placing an order
with the cylinder supplier is 2,500\$, while the same cost for the frame is 600\$. Also, the annual
cost of holding one unit of inventory is equal to 75\$ for the cylinder and 50\$ for the frame.
The annual demand for the particular model is equal to 1,200 units (each machine consists of
one rotor, one cylinder, and one frame)._

_Assuming that availability of rotor is not an issue, the firm would like to coordinate the
procurement of the other two subassemblies (cylinder and frame) for logistics planning
purposes, by using “power of two” policies. What would be the optimal policies for the two
subassemblies, considering that the firm's planning team uses one week as the base planning
period (TB)? For each subassembly separately, please evaluate your policy's performance
(cost-wise) compared to the optimal one._

#let weeks-in-year = 52

#let TB = 1

#let D = 1200

#let Sc = 2500
#let Sf = 600

#let Hc = 75
#let Hf = 50

#let Qc = calc.sqrt((2 * D * Sc) / Hc)
#let Qf = calc.sqrt((2 * D * Sf) / Hf)

#let TCc = calc.sqrt(2 * D * Sc * Hc)
#let TCf = calc.sqrt(2 * D * Sf * Hf)

#let Tc = calc.sqrt((2 * Sc) / (D * Hc))
#let Tc = calc.round(Tc, digits: 2)

#let Tf = calc.sqrt((2 * Sf) / (D * Hf))
#let Tf = calc.round(Tf, digits: 2)

#let TVC-t(T, S, H) = S / T + (H * D) / 2 * T
#let TVC-t-weeks(T, S, H) = TVC-t(T / weeks-in-year, S, H)

#let x = lq.linspace(4, 16, num: 200)
#let y-c = x.map(x => TVC-t-weeks(x, Sc, Hc))
#let y-f = x.map(x => TVC-t-weeks(x, Sf, Hf))

Base period ($T_B$) = 1 week
$
  2^0 dot T_B = 1 "week" \
  2^1 dot T_B = 2 "week" \
  2^2 dot T_B = 4 "week" \
  2^3 dot T_B = 8 "week" \
  dots.v \
$

Since:

$
  Q = D T
$

Substitute $Q = D T$ into $"TVC"(Q)$:

$
  "TVC"(Q) = (S D) / Q + (H Q) / 2
$

Ordering term becomes:

$
  (S D) / Q = (S D) / (D T) = S / T
$

Holding term becomes:

$
  (H Q) / 2 = (H (D T)) / 2 = (H D) / 2 T
$

Therefore:

$
  "TVC"(T) = S / T + (H D) / 2 T
$

Taking the derivative:

$
  (dif "TVC"(T)) / (dif T) = -S / T^2 + (H D) / 2 = 0 quad arrow.double quad T^* = sqrt((2 S) / (H D))
$

#let t-opt-c = calc.sqrt((2 * Sc) / (Hc * D))
#let t-opt-c = calc.round(t-opt-c, digits: 2)
#let t-opt-c-week = t-opt-c * weeks-in-year
#let t-opt-c-week = calc.round(t-opt-c-week, digits: 2)

#let t-opt-f = calc.sqrt((2 * Sf) / (Hf * D))
#let t-opt-f = calc.round(t-opt-f, digits: 2)
#let t-opt-f-week = t-opt-f * weeks-in-year
#let t-opt-f-week = calc.round(t-opt-f-week, digits: 2)

#let tvc-opt-f = TVC-t-weeks(t-opt-f-week, Sf, Hf)
#let tvc-opt-f = calc.round(tvc-opt-f, digits: 2)
#let tvc-opt-c = TVC-t-weeks(t-opt-c-week, Sc, Hc)
#let tvc-opt-c = calc.round(tvc-opt-c, digits: 2)

Our optimal cycle time ($T^*$) for _cylinders_ is:

$
  T^*_c 
  &= sqrt((2 (#Sc)) / ((#Hc) #D)) \
  &= #t-opt-c
$

Convert from years to weeks: 

$
  T^*_c times #weeks-in-year
  &= #t-opt-c times #weeks-in-year \
  &= #t-opt-c-week \
$

Similarly for _frames_:

$
  T^*_f 
  &= sqrt((2 (#Sf)) / ((#Hf) #D)) \
  &= #t-opt-f
$

From years to weeks:

$ 
  T^*_f times #weeks-in-year
  &= #t-opt-f times #weeks-in-year \
  &= #t-opt-f-week \
$

#let x-ticks = (t-opt-c-week, t-opt-f-week, 4, 8, 16)
#let x-ticks = x-ticks.sorted()
#let x-ticks = x-ticks.map(t => (t, text(size: 8pt)[$#t$]))

#let y-ticks = (tvc-opt-f, tvc-opt-c)
#let y-ticks = y-ticks.sorted()
#let y-ticks = y-ticks.map(t => (t, text(size: 8pt)[$#t$]))

#align(center)[
  #lq.diagram(
    width: 10cm,
    height: 8cm,
    xlabel: [$T$],
    ylabel: [$"TVC"(T)$],
    xaxis: (
      ticks: x-ticks,
      subticks: none,
    ),
    yaxis: (
      ticks: y-ticks,
      subticks: none,
    ),
    lq.plot(x, y-c, mark: none, stroke: blue + 1.5pt, label: [Cylinder]),
    lq.plot(x, y-f, mark: none, stroke: orange + 1.5pt, label: [Frame]),
    lq.vlines(t-opt-c-week, max: TVC-t-weeks(t-opt-c-week, Sc, Hc), stroke: (paint: blue, thickness: 1pt, dash: "dashed")),
    lq.vlines(t-opt-f-week, max: TVC-t-weeks(t-opt-f-week, Sf, Hf), stroke: (paint: orange, thickness: 1pt, dash: "dashed")),
    lq.hlines(tvc-opt-f, max: t-opt-f-week, stroke: (paint: orange, thickness: 1pt, dash: "dashed")),
    lq.hlines(tvc-opt-c, max: t-opt-c-week, stroke: (paint: blue, thickness: 1pt, dash: "dashed")),
  )
]

We now want to find the power of 2 that braket $T^*$:

$
  2^k T_B lt.eq T^* lt.eq 2^(k+1) T_B
$

For _cylinder_:

$ 
  2^3 T_B lt.eq T^*_c lt.eq 2^4 T_B 
$

Since $T^*_c$ is closer to 16, we order every 16 weeks.

For _frame_:

$ 
  2^2 T_B lt.eq T^*_f lt.eq 2^3 T_B 
$

Since $T^*_f$ is closer to 8, we order every 8 weeks.

Thus,

#align(center)[
  #result[
    $
      T_c = 16 "weeks" \
    $
  ]

  #result[
    $
      T_f = 8 "weeks" \
    $
  ]
]


To compare the optimal with our new constrained schedule:

#let Tc = 16
#let Tf = 8

#let tvc-c = TVC-t-weeks(Tc, Sc, Hc)
#let tvc-f = TVC-t-weeks(Tf, Sf, Hf)


#let delta-t-c = tvc-c / tvc-opt-c - 1
#let delta-t-c = calc.round(delta-t-c, digits: 3)

#let delta-t-f = tvc-f / tvc-opt-f - 1
#let delta-t-f = calc.round(delta-t-f, digits: 3)
$
  "TVC"(T^*_c) = #tvc-opt-c \
  "TVC"(T_c) = #tvc-c \
  Delta = #delta-t-c lt 0.06
$

And

$
  "TVC"(T^*_f) = #tvc-opt-f \
  "TVC"(T_f) = #tvc-f \
  Delta = #delta-t-f lt 0.06
$

#align(center)[
  #text(size: 20pt, weight: "semibold")[Quiz Problems]
]

= Batches Production (Max Points 10)

_In the Economic Production Quantity (EPQ) model, we have assumed that output immediately
becomes available to meet demand. Therefore, we can wait until inventory drops to zero
before beginning production. In many cases, however, the finished product cannot be used
until an entire batch is complete, perhaps because the batch must be moved to a warehouse,
or because some finishing operation (e.g., cooling) is required. Let $D$ = demand rate, $P$ =
production rate $(P gt D)$, $S$ = setup cost, $H$ = unit holding cost, and $Q$ = production quantity per production run._

*(a)* _Show that the average inventory, optimal production quantity, and total variable cost
are respectively equal to:_

$
  macron(I) = 1/2 (1 + D / P), quad Q^* = sqrt((2 D S) / (H (1 + D / P))), quad "TCV"(Q^*) = sqrt(2 D S H (1 + D / P))
$

_(Hint: consider, to avoid running out of stock, what are the maximum and minimum inventory
values for this system). (7 points)_

#v(2em)

A production run makes $Q$ units at rate $P$, so it takes $t_1 = Q / P$ time to finish one run. Once it's finished, the whole batch $Q$ drops into usable inventory at once. Demand keeps draining stock at rate $D$ the whole time, in both phases. Since exactly $Q$ units are consumed per cycle at rate $D$, a full cycle takes $T = Q / D$

1. Finished-goods stock behaves like ordinary EOQ

Usable (finished) inventory jumps up by $Q$ the instant a batch finishes, then drains at rate $D$ until the next batch finishes, $T = Q / D$ later. That's just a plain sawtooth from $Q$ down to 0 (production rate $P$ doesn't distort its shape, because nothing is added gradually). So:

$
  "average finished-goods stock" = Q / 2
$

2. But the batch being made also sits around and ties up cost

While a run is in progress ($t_1 = Q / P$ out of every cycle $T$), there's a pile of work-in-process building up in the factory. It starts at 0, grows linearly to $Q$ by the end of the run, then disappears (converts to finished goods) for the rest of the cycle. That's a triangle of height $Q$ over a width $t_1$, sitting inside a cycle of length $T$. Its time-average over the whole cycle is:

$
  (1/2 dot Q dot t_1) / T = Q / 2 dot t_1 / T = Q / 2 dot (Q \/ P) / (Q \/ D) = Q / 2 dot D / P
$

This work-in-process still costs money to hold even though it can't be sold yet. That's what delayed-availability costs.

3. Add them up


$
  macron(I) = Q / 2  + Q / 2 dot D / P = #result[$Q / 2 (1 + D / P)$]
$

4. Optimal $Q$

Total variable cost per unit time is holding cost plus setup cost:

$
  "TVC"(Q) = H macron(I) + S D / Q = H / 2 (1 + D / P) Q + (S D) / Q
$

Take the derivative and set it to zero:

$
  (dif "TVC"(Q)) / (dif Q) = H / 2 (1 + D / P) - (S D) / Q^2 = 0 quad arrow.double quad #result[$Q^* = sqrt((2 D S) / (H (1 + D / P)))$]
$

5. Optimal cost

This is the standard $"TVC"(Q) = a Q + b / Q$ shape, whose minimum value is $2 sqrt(a b)$. Here $a = H / 2 (1 + D / P)$ and $b = S D$, so:

$
  "TVC"(Q^*) = 2 sqrt(a b) = #result[$sqrt(2 D S H (1 + D / P))$]
$

*(b)* _Notice that when output is immediate available, the total variable cost is increasing in
the production rate, while in this case (i.e., when the finished product cannot be used until an
entire batch is complete), the total variable cost is decreasing in the production rate. Explain
the possible reason. (3 points)_

#v(2em)

- *Immediate-use model* (cost rises with $P$)

while a batch is being made, units are sold off as fast as they're produced, so the pile never grows to the full size $Q$ — it only reaches $Q (1 - D / P)$, because selling at rate $D$ "thins it out" the whole time it's being built. A slow production rate gives demand more time to eat into the pile during the run, keeping average inventory low. As $P$ increases, the run gets shorter and there's less time for that thinning effect, so the peak — and the cost — creeps up toward the plain-EOQ value.

- *Delayed-availability model* (cost falls with $P$)

here nothing gets sold off while it's being made, so demand during the run has to be covered by stock (or WIP) held in reserve for exactly that window, of length $t_1 = Q / P$. A slow production rate means a long blackout window, which means a bigger reserve has to sit around the whole time — extra cost. As $P$ increases, the run gets shorter, the blackout shrinks, and less reserve is needed, so cost falls toward the plain-EOQ value.

*Conclusion*

A finite production rate helps you when output is usable immediately (you get to sell while you build), but hurts you when output is stuck in limbo until the batch is done (you have to cover demand out of reserves for the whole build time) — which is exactly the sign flip between $(1 - D / P)$ and $(1 + D / P)$.

= Quiz Problem 2.  EOQ with Backorders (Max Points 10) 

#v(2em)

*The Atlantic Coast Tire Corporation Problem*

The Atlantic Coast Tire Corporation (ACT) is the east coast distributor of Eversafe tires supplying 1500 retail stores and service stations. Currently, ACT follows a simple policy for replenishing its inventory. When the inventory level of a particular size tire gets low, ACT places a large order with Eversafe to replenish its stock. Shipments arrive by truck 9 working days after the placement of the order.

The following are data for tire R13:
- These tires sell at a regular rate of about 500 per month; that is, 6,000 items per year.
- The current policy has been to order 1,000 tires as needed every couple months.
- The order is placed just in time to have the delivery arrive as inventory runs out.

Inventory Cost Components for R13:
- The purchasing cost for ATC is \$20 per tire.
- The cost for placing an order is \$115, which includes:
  - Cost per shipment of tires (consider this as independent of the number of tires in each shipment;
  - Administrative cost for initiating and processing the purchase order.
- The annual cost of holding inventory is \$4.20 per tire, which includes:
  - The cost of capital tied up in inventory (estimated at 15% of unit cost per annum);
  - The cost of leasing warehouse space;
  - The cost of insurance against loss by fire, theft, etc.;
  - The cost of inventory personnel;
  - Taxes that are based on the value of inventory.
- The cost of being out of stock is \$7.50 per tire short per year, based on these consequences:
  - Customer dissatisfaction;
  - Potential price drop to placate a customer due to late deliveries;
  - Delayed revenue;
  - The cost of additional record keeping required for out-of-stock tires.

#let months-per-year = 12

#let D = 6000
#let S = 115
#let H = 4.20
#let L = 9
#let c = 20
#let P = 7.50

#let Q0 = 1000

#let Qstar = calc.round(calc.sqrt((2 * D * S) / H), digits: 2)

#let TC(Q) = c * D + S * D / Q + H * Q / 2
#let TVC(Q) = S * D / Q + H * Q / 2

#let tc0 = calc.round(TC(Q0), digits: 2)
#let tvc0 = calc.round(TVC(Q0), digits: 2)
#let tcstar = calc.round(TC(Qstar), digits: 2)
#let tvcstar = calc.round(TVC(Qstar), digits: 2)

#v(2em)

- Demand ($D$): #D units / year
- Lead Time ($L$): #L days
- Cost ($c$): #c \$ / unit
- Setup Cost ($S$): #S \$ / order
- Holding Cost ($H$): #H \$ / unit / year
- Stockout (Penalty) Cost ($P$): #P \$ / unit

#v(2em)

*(a)* What is the total annual cost of the current policy for ACT?

$
  "TC"(Q_0) 
  &= c D + S D / Q_0 + H Q_0 / 2 \
  &= #tc0
$

#v(2em)

*(b)* What is the annual variable cost of the current policy for ACT?

$
  "TVC"(Q_0) 
  &= S D / Q_0 + H Q_0 / 2 \
  &= #tvc0
$


#v(2em)

*(c)* Is the policy followed optimal? If not, how we could derive the optimal policy?

$
  Q^* 
  &= sqrt((2 D S) / H) \
  &= #Qstar
$

$
  "TC"(Q^*) 
  &= c D + S D / Q^* + H Q^* / 2 \
  &= #tcstar
$

$
  "TVC"(Q^*) 
  &= S D / Q^* + H Q^* / 2 \
  &= #tvcstar
$

#let qs = range(100, 2001, step: 10)

#align(center)[
  #lq.diagram(
    width: 11cm,
    height: 7cm,

    xlabel: [$Q$],
    ylabel: [Cost (\$)],
    legend: (position: top + right),

    xaxis: (
      ticks: (
        (Qstar, $Q^* = Qstar$),
        (Q0, $Q_0 = Q0$),
      ),
      subticks: none,
    ),
    yaxis: (
      ticks: none,
      subticks: none,
    ),

    lq.plot(qs, q => S * D / q, mark: none, label: [Ordering cost]),
    lq.plot(qs, q => H * q / 2, mark: none, label: [Holding cost]),
    lq.plot(qs, q => TVC(q), mark: none, label: [Total variable cost]), 
  )
]

#let d-month = 500
#let L-months = 9 / 20

#let R = d-month * L-months

#let T0 = Q0 / d-month
#let Tstar = Qstar / d-month

#let sawtooth(Q, T, horizon) = {
  let cycles = calc.ceil(horizon / T)
  let ts = (0,)
  let inv = (Q,)
  for k in range(0, cycles) {
    ts.push((k + 1) * T)
    inv.push(0)
    if k < cycles - 1 {
      ts.push((k + 1) * T)
      inv.push(Q)
    }
  }
  (ts, inv)
}

#let reorder-times(T, horizon) = {
  let cycles = calc.ceil(horizon / T)
  range(0, cycles).map(k => {
    let R = (k + 1) * T - L-months
    (R, $R_#k = #R$)
  })
}

#let horizon = 3

#let (ts0, inv0) = sawtooth(Q0, T0, horizon)
#let (tsstar, invstar) = sawtooth(Qstar, Tstar, horizon)

#align(center)[
  #lq.diagram(
    width: 11cm, height: 6cm,
    xlabel: [Time],
    ylabel: [Inventory],
    xlim: (0, horizon),
    ylim: (0, Qstar * 1.1),
    xaxis: (
      ticks: (
        ..reorder-times(Tstar, horizon)
      ),
      subticks: none,
    ),
    yaxis: (
      ticks: (
        (Qstar, $Q^* = #Qstar$),
        (R, $R = #R$),
        (0, $0$),
      ),
      subticks: none,
    ),
    legend: (position: top + right),

    lq.plot(tsstar, invstar, stroke: 1pt, mark: none),
  )
]

#v(2em)

_In the Atlantic Coast Tire Corporation (ACT) problem that we discussed during our first lecture 
on EOQ, we ignored the cost of being out of stock (\$7.50 per tire short). Consider the penalty 
associated with stocking out as cost per unit short per year (i.e., the stockout cost penalizes 
also the duration of the stockout situation; hence it shall be treated as the holding cost).  
Assuming that all demand that is not satisfied on time is backordered (i.e., it is served, usually 
first, during the next batch delivery):_

#let Qbo = calc.round(calc.sqrt(2 * S * D / H) * calc.sqrt((H + P) / P), digits: 2)
#let bbo = calc.round(calc.sqrt(2 * S * D * H / (P * (H + P))), digits: 2)
#let Imbo = calc.round(Qbo - bbo, digits: 2)


#let TVCbo(Q, b) = S * D / Q + H * calc.pow(Q - b, 2) / (2 * Q) + P * calc.pow(b, 2) / (2 * Q)

#let dTVCbo-db(Q, b) = (-H * (Q - b) + P * b) / Q
#let dTVCbo-dQ(Q, b) = -S * D / calc.pow(Q, 2) + H / 2 - (H + P) * calc.pow(b, 2) / (2 * calc.pow(Q, 2))

#let tvcbo-star = calc.round(TVCbo(Qbo, bbo), digits: 2)

#let check-db = calc.round(dTVCbo-db(Qbo, bbo), digits: 4)
#let check-dQ = calc.round(dTVCbo-dQ(Qbo, bbo), digits: 4)

#let Tbo = Qbo / d-month
#let t1bo = Imbo / d-month
#let t2bo = bbo / d-month

#v(2em)

2 decision variables:
- $Q$: order quantity (same as before)
- $b$: the maximum backorder level ($0 lt.eq b lt.eq Q$)

In the classical EOQ:

$
  "TVC"(Q) = underbrace(S D/Q, "ordering cost") + underbrace(H Q/2, "holding cost on avg inventory")
$

But in the backorder EOQ, when the shipment of size $Q$ arrives, it doesn't all become shelf stock, the first $b$ units go to pay down whatever was backordered. So the peak on-hand level right after delivery is not $Q$ anymore:

$
  I_max = Q - b
$

The cycle splits into two triangles instead of one:

$
  t_1 &= I_m / D quad ("draining" I_m arrow.r 0) \
  t_2 &= b / D quad ("accumulating backorders," 0 arrow.r b)
$

Full cycle:

$
  t_1 + t_2 = (I_max + b) / D = Q / D = T
$

Calculate two average-inventory terms area of the relevant triangle, divided by the whole cycle $T$:

- Positive Inventory

$
  overline(I) = (I_m^2 / (2D)) / (Q/D) = I_m^2 / (2Q)
$

- Negative Inventory

$
  overline(b) = (b^2 / (2D)) / (Q / D) = b^2/(2Q)
$

Assemble the cost function
- Ordering cost: untouched
- Holding cost $H$ now applies only to the on-hand average $macron(I)$ 
- Penalty cost $P$ (new) applies to the average backorder level $macron(b)$

$
  "TVC"(Q,b) 
  &= S D/Q + H overline(I) + P overline(b) \
  &= S D/Q + H (Q-b)^2/(2Q) + P b^2/(2Q) \
$

Check: set $b = 0$ (no backorders allowed). Then $I_max = Q$ and the formula collapses to:

$
  "TVC"(Q,0)
  &= S D/Q + H Q^2/(2Q) + 0 \
  &= S D/Q + H Q/2 \
$

Take gradient (partial derivatives) and set to 0:

$
  (partial"TVC") / (partial b) 
  = (-H (Q - b) + P b) / Q 
  = 0\
$

$
  (partial"TVC") / (partial Q) 
  = - (S D) / Q^2 + H / 2 - ((H + P) b^2) / (2 Q^2) 
  = 0 \
$

Solve $(partial"TVC") / (partial b) = 0$ for $b$:

$
  b^*= (H Q / (H + P))
$

Plug $b$ into $(partial"TVC") / (partial Q)$ to solve for $Q^*$ alone:

$
  Q^* &= sqrt((2 S D) / H) dot sqrt((H + P) / P)
$

As $P arrow infinity$, we get the normal EOQ (disallow backorders) ($P$ is infinitely expensive)

Plug this $Q^*$ into $b^*$:

$
  b^* &= sqrt((2 S D H) / (P (H + P))) \
$

#v(2em)

*(a)* _What is the EOQ for ACT in this case? Please show the steps you followed in deriving 
this quantity. (7 points)_

_Hint: Set B the quantity backordered. Make a graph of how the policy will look like if 
backorders are allowed. Compute the time lengths T1 (demand is fully met) and T2 (demand 
is backordered) as functions of D, Q, and B. Compute average inventory and average 
backorders and construct the cost function (which is now a function of both Q and B). You can 
assume that the cost function is jointly convex to Q and B (i.e., you don't need to show second 
order derivative calculations). Then, take the partial derivatives of the cost function over Q 
and B. This will result to a system of two equations with two unknowns. By solving this system, 
you can obtain the optimal Q and B._ 

- Optimal order quantity: $Q^* = #result[#Qbo]$ 

- Optimal backorder level: $b^* = #result[#bbo]$ 

- Peak on-hand inventory: $I_m^* = Q^* - b^* = #result[#Imbo]$ 

- Minimum annual variable cost: $"TVC"(Q^*, b^*) = #result[\$#tvcbo-star]$

*(b)* _Do you expect the new EOQ to be different (smaller or larger) from the classical EOQ 
derived in class? Please explain why. (3 points)_  

#table(
  columns: 3,
  align: center,
  [*Policy*], [*Q*], [*Annual variable cost*],
  [Classical EOQ (no backorders)], result[$#Qstar$], [#result[\$#tvcstar]],
  [EOQ with backorders], result[$#Qbo$], [#result[\$#tvcbo-star]],
)


#let sawtooth-backorder(Im, b, T, horizon) = {
  let cycles = calc.ceil(horizon / T)
  let ts = (0,)
  let inv = (Im,)
  for k in range(0, cycles) {
    ts.push((k + 1) * T)
    inv.push(-b)
    if k < cycles - 1 {
      ts.push((k + 1) * T)
      inv.push(Im)
    }
  }
  (ts, inv)
}

#let order-arrival-times(T, horizon) = {
  let cycles = calc.ceil(horizon / T)
  range(1, cycles + 1).map(k => (k * T, $k T$))
}

#let stockout-start-times(T, t1, horizon) = {
  let cycles = calc.ceil(horizon / T)
  range(0, cycles).map(k => (k * T + t1, $t_1$))
}

#let horizon = 3

#let (tsbo, invbo) = sawtooth-backorder(Imbo, bbo, Tbo, horizon)

#lq.diagram(
  width: 11cm, height: 6cm,
  xlabel: [Time],
  ylabel: [Inventory position],
  xlim: (0, horizon),
  ylim: (-bbo * 1.3, Imbo * 1.15),
  xaxis: (
    ticks: (
      ..order-arrival-times(Tbo, horizon),
      ..stockout-start-times(Tbo, t1bo, horizon),
    ),
    subticks: none,
  ),
  yaxis: (
    ticks: (
      (Imbo, $I_m = #Imbo$),
      (0, $0$),
      (-bbo, $-b^* = #(-bbo)$),
    ),
    subticks: none,
  ),
  legend: (position: top + right),

  lq.plot(tsbo, invbo, stroke: 1pt, mark: none),
)
