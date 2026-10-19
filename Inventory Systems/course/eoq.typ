#import "/lib/imports.typ": *
#import "/lib/formatting.typ": *
#show: formatting

Inventory managemnt:
- Supply: batch size
- Demand: Economies of scale

== Economic Order Quantity (EOQ)

$
  "EOQ" = sqrt((2 D S) / H)
$

Fundemental tradeoff:
- Ordering cost
- Carrying (holding) cost

EOQ: What should be my *batch size*?

Assumptions:
- Constant, known demand
- Fixed, known lead time
- No quantity discounts
- Instantaneous full-batch delivery
- No stockouts allowed

=== Total Cost

$
  "TC"(Q) = underbrace((D / Q) S, "annual\nordering\ncost") quad + quad underbrace((Q/2)H, "annual\nholding\ncost")
$

Where:
- $D$: Demand (units / unit time)

- $Q$: Quantity (units)

- $S$: Ordering cost (\$ / order)

- $H$: Holding cost (\$ / unit / unit time)

- $D/Q$: Number of orders (orders / unit time)

- $Q/2$: Average inventory (units)

- $(D/Q) S$: Number of orders $times$ Ordering cost

- $(Q/2) H$: Average inventory $times$ Holding cost

=== Deriving EOQ from TC

$
  (dif "TC") / (dif Q)
    &= (dif) / (dif Q) [ (D/Q) S + (Q/2) H ] \ \
    &= (dif) / (dif Q) (D S Q^(-1)) + (dif) / (dif Q) (H/2 Q) \ \
    &= D S dot (dif) / (dif Q) (Q^(-1)) + H/2 dot (dif) / (dif Q) (Q) \ \
    &= D S dot (-1) Q^(-2) + H/2 dot 1 \ \
    &= -(D S) / Q^2 + H/2
$

Setting the derivative equal to zero to find the critical point:

$
  -(D S) / Q^2 + H/2 &= 0 \ \
  H/2 &= (D S) / Q^2 \ \
  Q^2 &= (2 D S) / H \ \
  Q &= sqrt((2 D S) / H)
$

To confirm this critical point is a minimum rather than a maximum, check the second derivative:

$
  (dif^2 "TC") / (dif Q^2)
    &= (dif) / (dif Q) (-(D S) / Q^2 + H/2) \ \
    &= (dif) / (dif Q) (-D S Q^(-2)) + (dif) / (dif Q) (H/2) \ \
    &= -D S dot (dif) / (dif Q) (Q^(-2)) + 0 \ \
    &= -D S dot (-2) Q^(-3) \ \
    &= (2 D S) / Q^3
$

Since $D, S, Q > 0$, $(dif^2 "TC")/(dif Q^2) > 0$ for all $Q > 0$, confirming $"TC"(Q)$ is convex and the critical point $Q^* = sqrt((2 D S) / H)$ is indeed a minimum.

```py
import math

Q = math.sqrt((2 * D * S) / H)
```

#example[
  #let D = 20
  #let S = 20
  #let H = 20

  #let TC(Q) = (D / Q) * S + (Q / 2) * H

  #let EOQ = calc.sqrt((2 * D * S) / H)
  #let EOQ-display = calc.round(EOQ, digits: 2)

  #let Q-values = lq.linspace(1, 20, num: 1000)
  #let tc-values = Q-values.map(TC)

  #let minimum-cost = TC(EOQ)
  #let minimum-cost-display = calc.round(minimum-cost, digits: 2)

  - $D = #D$
  - $S = #S$
  - $H = #H$

  $
    Q^*
    &= sqrt((2 D S) / H) \
    &= sqrt((2 (#D) (#S)) / #H) \
    &= #EOQ-display
  $

  $
    "TC"(Q^*)
    &= (D/Q) S + (Q/2) H \
    &= (#D / #EOQ-display) #S + (#EOQ-display / 2) #H \
    &= #minimum-cost-display
  $

  #lq.diagram(
    width: 25em,
    height: 20em,
    xlabel: [$Q$],
    ylabel: [$"TC"(Q)$],
    xaxis: (ticks: (EOQ-display,)),
    yaxis: (ticks: (minimum-cost-display,)),
    lq.plot(Q-values, tc-values, mark: none, stroke: blue),
    lq.vlines(EOQ, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
    lq.hlines(minimum-cost, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
  )
]

Closed-form optimal cost

$
  "TC"(Q^*) = sqrt(2 D S H)
$

== Sensitivity Analysis

The ratio of actual cost to optimal cost depends only on $r = Q\/Q^*$:

$
  "TC"(Q) / "TC"(Q^*) = 1/2 (r + 1/r)
$

How much does it actually cost you to get $Q$ wrong? $"TC"(Q)$ is quite flat
near $Q^*$ --- being off by 20% on your order quantity typically costs only
a percent or two more in total cost.

#example[
  #let tolerance = 1.05
  #let sqrt-disc = calc.sqrt(calc.pow(tolerance, 2) - 1)
  #let r-low = tolerance - sqrt-disc
  #let r-high = tolerance + sqrt-disc

  #let r-low-display = calc.round(r-low, digits: 2)
  #let r-high-display = calc.round(r-high, digits: 2)

  #let cost-ratio(r) = (r + 1 / r) / 2
  #let r-values = lq.linspace(0.4, 2.5, num: 1000)
  #let ratio-values = r-values.map(cost-ratio)

  A #calc.round((tolerance - 1) * 100, digits: 0)% cost tolerance permits ordering
  anywhere between #r-low-display and #r-high-display times $Q^*$.

  #lq.diagram(
    width: 25em,
    height: 20em,
    xlabel: [$r = Q\/Q^*$],
    ylabel: [$"TC"(Q) \/ "TC"(Q^*)$],
    xaxis: (ticks: (r-low-display, 1, r-high-display).sorted()),
    yaxis: (ticks: (1, tolerance).sorted()),
    lq.plot(r-values, ratio-values, mark: none, stroke: blue),
    lq.vlines(1, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
    lq.hlines(tolerance, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
    lq.vlines(r-low, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
    lq.vlines(r-high, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
  )
]

=== Derivation of the cost-ratio formula

Start with the total cost function:

$
  "TC"(Q) = (D/Q) S + (Q/2) H
$

Recall from the EOQ derivation that

$
  (Q^*)^2 = (2 D S) / H,
$

which rearranges to

$
  D S = (H (Q^*)^2) / 2.
$

Substituting into $"TC"(Q)$:

$
  "TC"(Q)
  &= (D / Q) S + (Q / 2) H \
  &= (D S) / Q + (Q H) / 2 \
  &= (H (Q^*)^2) / (2 Q) + (Q H) / 2 \
  &= H / 2 ((Q^*)^2 / Q + Q)
$

Plugging in $Q = Q^*$ gives

$
  "TC"(Q^*)
  &= H / 2 (Q^* + Q^*) \
  &= H / 2 Q^* + H / 2 Q^* \
  &= H Q^*
$

and since $Q^* = sqrt((2 D S) \/ H)$,

$
  H Q^*
  &= H sqrt((2 D S) / H) \
  &= sqrt(H^2 dot (2 D S) / H) \
  &= sqrt(2 D S H),
$

which matches the familiar

$
  "TC"(Q^*) = sqrt(2 D S H).
$

Now form the ratio of actual to optimal cost:

$
  "TC"(Q) / "TC"(Q^*)
  &= (H/2 ((Q^*)^2 / Q + Q)) / (H Q^*) \
  &= 1/2 (Q^* / Q + Q / Q^*)
$

Letting $r = Q \/ Q^*$ (the fraction of the optimal order size you actually
used) gives the clean result:

$
  "TC"(Q) / "TC"(Q^*) = 1/2 (r + 1/r)
$

This ratio depends only on how far off (proportionally) you are from $Q^*$
--- not on $D$, $S$, or $H$ individually.

== Reorder Point (ROP)

Inventory level at which you should place a new order so that the replacement stock arrives just as your existing stock runs out

$
  "ROP" = d L
$

Where:
- $d$: Demand rate (units / unit time), expressed in the same time unit as $L$

- $L$: Lead time (unit time)

- $"ROP"$: Reorder point (units)

#example([Atlantic Coast Tire Corporation])[
  
  - Lead time (L): 9 days
  - Demand (D): 500 units / month
  - Purchasing cost (c): 20 \$ / unit
  - Ordering (setup) cost (S): 115 \$ / order
  - Holding cost (H): 4.20 \$ / unit / year
  - Stockout (penalty) cost (p): 7.50 \$ / unit
  - Ordering quantity (Q) 
  - Order period (T)


  Current policity:
  - When? Every 2 months
  - How much? 1000 units

  Total anual cost (TAC) of current policy 

  $
    "TAC"(Q = 1000) 
    &= "purchasing" + "order" + "holding" (+ "stockout") \
    &= (500 times 12) times 20 + 6 times 115 + (1000 / 2) times 4.20\

  $

  #((500 * 12) * 20 + 6 * 115 + (1000 / 2) * 4.20)

  Total anual cost (TAC) of new policy 

  - D: 6000 / year

  $
    "TAC"(Q^*) 
    &= "purchasing" + "order" + "holding" (+ "stockout") \
    &= c dot D + S (D / Q) + H (Q / 2) \
  $



  // #let D = 500
  // #let S = 115
  // #let H = 4.20
  // #let L = 9

  // #let EOQ = calc.sqrt((2 * D * S) / H)
  // #let EOQ-display = calc.round(EOQ, digits: 2)

  // #let T = EOQ / D
  // #let T-display = calc.round(T, digits: 3)
  // #let two-T-display = calc.round(2 * T, digits: 3)

  // #let ROP = D * L
  // #let ROP-display = calc.round(ROP, digits: 2)

  // #let t1 = (EOQ - ROP) / D
  // #let t1-display = calc.round(t1, digits: 3)

  // #let inventory-cycle1(t) = EOQ - D * t
  // #let inventory-cycle2(t) = EOQ - D * (t - T)

  // #let cycle1-t = lq.linspace(0, T, num: 200)
  // #let cycle1-inv = cycle1-t.map(inventory-cycle1)

  // #let cycle2-t = lq.linspace(T, 2 * T, num: 200)
  // #let cycle2-inv = cycle2-t.map(inventory-cycle2)

  // #lq.diagram(
  //   width: 25em,
  //   height: 20em,
  //   xlabel: [Time $t$ (years)],
  //   ylabel: [Inventory position (units)],
  //   xaxis: (ticks: (0, t1-display, T-display, two-T-display)),
  //   yaxis: (ticks: (0, ROP-display, EOQ-display)),
  //   lq.plot(cycle1-t, cycle1-inv, mark: none, stroke: blue),
  //   lq.plot(cycle2-t, cycle2-inv, mark: none, stroke: blue),
  //   lq.hlines(ROP, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
  //   lq.vlines(t1, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
  //   lq.vlines(T, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
  // )
  // 
  // #let D = 20
  // #let S = 20
  // #let H = 20

  // #let TC(Q) = (D / Q) * S + (Q / 2) * H

  // #let EOQ = calc.sqrt((2 * D * S) / H)
  // #let EOQ-display = calc.round(EOQ, digits: 2)

  // #let Q-values = lq.linspace(1, 20, num: 1000)
  // #let tc-values = Q-values.map(TC)

  // #let minimum-cost = TC(EOQ)
  // #let minimum-cost-display = calc.round(minimum-cost, digits: 2)

  // - $D = #D$
  // - $S = #S$
  // - $H = #H$

  // $
  //   Q^*
  //   &= sqrt((2 D S) / H) \
  //   &= sqrt((2 (#D) (#S)) / #H) \
  //   &= #EOQ-display
  // $

  // $
  //   "TC"(Q^*)
  //   &= (D/Q) S + (Q/2) H \
  //   &= (#D / #EOQ-display) #S + (#EOQ-display / 2) #H \
  //   &= #minimum-cost-display
  // $

  // #lq.diagram(
  //   width: 25em,
  //   height: 20em,
  //   xlabel: [$Q$],
  //   ylabel: [$"TC"(Q)$],
  //   xaxis: (ticks: (EOQ-display,)),
  //   yaxis: (ticks: (minimum-cost-display,)),
  //   lq.plot(Q-values, tc-values, mark: none, stroke: blue),
  //   lq.vlines(EOQ, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
  //   lq.hlines(minimum-cost, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
  // )



]

=== Why $"ROP" = d L$

During the lead time $L$ between placing an order and receiving it, $d L$ units of demand will be consumed. To avoid a stockout, the next order must be placed exactly when the on-hand inventory equals this lead-time demand — i.e. when inventory falls to $"ROP" = d L$ — so that inventory reaches zero at the exact moment the new order arrives.

Note that $d$ and $L$ must share the same time unit for this to be dimensionally valid: $D$ from the EOQ derivation is often quoted as an annual rate, while $L$ is commonly measured in days or weeks. Using $D$ directly without converting it to match $L$'s time unit (e.g. $d = D/365$ for a daily rate when $L$ is in days) is a common source of ROP errors in practice.

=== Accounting for Demand Variability

The formula above assumes both demand and lead time are known with certainty — the same idealized assumption EOQ relies on. In practice, demand during the lead time varies, so a safety stock buffer $"SS"$ is added:

$
  "ROP" = d L + "SS"
$

A common choice, assuming demand during lead time is approximately normally distributed, is $"SS" = z sigma_(d L)$, where $sigma_(d L)$ is the standard deviation of demand over the lead time and $z$ is chosen from a target service level (e.g. $z approx 1.645$ for a 95% service level). This brings in real statistical machinery — happy to derive it fully in its own section if useful.

#example[
  #let D = 20
  #let S = 20
  #let H = 20
  #let L = 0.1

  #let EOQ = calc.sqrt((2 * D * S) / H)
  #let EOQ-display = calc.round(EOQ, digits: 2)

  #let T = EOQ / D
  #let T-display = calc.round(T, digits: 3)
  #let two-T-display = calc.round(2 * T, digits: 3)

  #let ROP = D * L
  #let ROP-display = calc.round(ROP, digits: 2)

  #let t1 = (EOQ - ROP) / D
  #let t1-display = calc.round(t1, digits: 3)

  - $D = #D$ units/year
  - $L = #L$ years
  - $Q^* = #EOQ-display$ units, giving a cycle time $T = Q^* / D = #T-display$ years

  $
    "ROP" &= D L \
    &= (#D)(#L) \
    &= #ROP-display
  $

  Solving for the time $t_1$ at which the inventory position depletes to $"ROP"$, starting each cycle at $Q^*$ and falling at rate $D$:

  $
    Q^* - D t_1 &= "ROP" \ \
    D t_1 &= Q^* - "ROP" \ \
    t_1 &= (Q^* - "ROP") / D \ \
    &= (#EOQ-display - #ROP-display) / #D \ \
    &= #t1-display "years"
  $

  Checking consistency: the order placed at $t_1$ should arrive exactly $L$ later, at the moment inventory hits zero, i.e. $t_1 + L = T$:

  $
    t_1 + L &= #t1-display + #L \ \
    &approx #T-display \ \
    &= T
  $

  #let inventory-cycle1(t) = EOQ - D * t
  #let inventory-cycle2(t) = EOQ - D * (t - T)

  #let cycle1-t = lq.linspace(0, T, num: 200)
  #let cycle1-inv = cycle1-t.map(inventory-cycle1)

  #let cycle2-t = lq.linspace(T, 2 * T, num: 200)
  #let cycle2-inv = cycle2-t.map(inventory-cycle2)

  #lq.diagram(
    width: 25em,
    height: 20em,
    xlabel: [Time $t$ (years)],
    ylabel: [Inventory position (units)],
    xaxis: (ticks: (0, t1-display, T-display, two-T-display)),
    yaxis: (ticks: (0, ROP-display, EOQ-display)),
    lq.plot(cycle1-t, cycle1-inv, mark: none, stroke: blue),
    lq.plot(cycle2-t, cycle2-inv, mark: none, stroke: blue),
    lq.hlines(ROP, stroke: (paint: red, dash: "dashed", thickness: 1.5pt)),
    lq.vlines(t1, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
    lq.vlines(T, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
  )
]

```py
import math
from typing import Optional, Tuple


def eoq(
    D: float,
    S: float,
    H: float,
    L: float = 0.0,
    Q: Optional[float] = None,
    cost_tolerance: float = 0.05,
) -> Tuple[float, float, float]:
    """
    D: annual demand
    S: fixed cost per order
    H: holding cost per unit per year
    L: lead time in days (0 = instantaneous delivery)
    Q: candidate order quantity to evaluate against the optimum, if any
    cost_tolerance: max acceptable fractional cost penalty for using Q instead of Q*

    Returns (Q_star, reorder_point, cost_penalty).
    Raises ValueError if Q's cost penalty exceeds cost_tolerance.
    """
    if D <= 0 or S <= 0 or H <= 0:
        raise ValueError("D, S, and H must be positive")
    if L < 0:
        raise ValueError("L cannot be negative")

    Q_star = math.sqrt((2 * D * S) / H)

    d = D / 365
    rop = d * L

    penalty = 0.0
    if Q is not None:
        if Q <= 0:
            raise ValueError("Q must be positive")
        r = Q / Q_star
        penalty = 0.5 * (r + 1 / r) - 1
        if penalty > cost_tolerance:
            raise ValueError(
                f"Q={Q} incurs a {penalty:.1%} cost penalty vs. optimal "
                f"{Q_star:.2f}, exceeding tolerance {cost_tolerance:.1%}"
            )

    return Q_star, rop, penalty
```


= EOQ Extensions

== Relaxation: Receipt of inventory is not instantaneous ($L > 0$)

- $D$: demand rate
- $P$: production rate

$
  P gt D
$

- $H$: holding cost \$ / unit / time
- $S$: setup cost \$ / setup
- $Q$: batch size

== Quantity Discount

== Aggregation