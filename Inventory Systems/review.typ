#import "@local/tystats:0.1.0": norm, expon, poisson, uniform
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(
  margin: (
  x: 0.1cm,
  y: 0.1cm,
  )
)

#set par(
  leading: 0.5em
)

#set text(
  font: "Helvetica", 
  size: 8pt
)

#let mc(content, color: red) = text(fill: color, content)

Q_new / Q_old = √(2D·4S/H) / √(2DS/H) = √4 = 2

So Q* doubles. TVC* = √(2DSH) has S in the same place, so it also multiplies by √4 = 2.

The general rule is: take the factor the parameter changed by, then apply the square root. If the parameter is in the numerator under the root, multiply by that. If it's in the denominator, divide by it.


if any input is off by a factor k, the penalty is ½(√k + 1/√k)


#line(length: 100%)

#[
  #set text(size: 7pt)
  #table(
    columns: 4,
    align: left + horizon,
    [], [*Definition*], [*EOQ*], [*EPQ*],
    [$ H $], [Annual holding cost per unit ($i$ = annual holding rate, $c$ = unit cost)],
    table.cell(
      colspan: 2,
      $
        i c
      $
    ),
    [$ "TVC"(Q) $], [Total annual variable cost (setup/ordering + holding)],
    [
      $
        S D / Q + H Q / 2
      $
    ],
    [
      $
        S D / Q + H Q / 2 mc((1 - D / P))
      $
    ],
    [$ "TC"(Q) $], [Total annual cost (purchase/production + TVC)],
    [
      $
        c D + S D / Q + H Q / 2
      $
    ],
    [
      $
        c D + S D / Q + H Q / 2 mc((1 - D / P))
      $
    ],
    [$ (dif "TVC") / (dif Q) $], [First-order condition that gives the optimal lot size $Q^*$],
    [
      $
        - (S D) / Q^2 + H / 2 = 0
      $
    ],
    [
      $
        - (S D) / Q^2 + H / 2 mc((1 - D / P)) = 0
      $
    ],
    [$ Q^* $], [Optimal lot size (minimizes TVC)],
    [
      $
        sqrt((2 D S) / H)
      $
    ],
    [
      $
        sqrt((2 D S) / (H mc((1 - D / P))))
      $
    ],
    [$ "TVC"(Q^*) $], [Minimum annual variable cost (at $Q^*$, ordering cost = holding cost)],
    [
      $
        sqrt(2 D S H)
      $
    ],
    [
      $
        sqrt(2 D S H mc((1 - D / P)))
      $
    ],
    [$ "TC"(Q^*) $], [Minimum total annual cost (purchase/production + $"TVC"(Q^*)$)],
    [
      $
        c D + sqrt(2 D S H)
      $
    ],
    [
      $
        c D + sqrt(2 D S H mc((1 - D / P)))
      $
    ],
    [$ I_max $], [Maximum inventory level in a cycle],
    [
      $
        Q
      $
    ],
    [
      $
        T_p (P - D) = Q (1 - D / P)
      $
    ],
    [$ macron(I) $], [Average inventory level],
    [
      $
        Q / 2
      $
    ],
    [
      $
        I_max / 2
      $
    ],
    [$ T_p $], [Production time (uptime): inventory builds up at rate $P - D$],
    [
      $
        0
      $
    ],
    [
      $
        Q / P
      $
    ],
    [$ T_d $], [Depletion time (downtime): no production, inventory falls at rate $D$],
    [
      $
        T = Q / D
      $
    ],
    [
      $
        I_max / D = Q / D (1 - D / P)
      $
    ],
    [$ T $], [Cycle length: time between consecutive orders or runs],
    [
      $
        Q / D
      $
    ],
    [
      $
        T_p + T_d = Q / D
      $
    ],
    [$ n $], [Number of orders or runs per year],
    table.cell(
      colspan: 2,
      $
        1 / T = D / Q
      $
    ),
    [$ T^* $], [Optimal cycle length: time between orders or runs at $Q^*$],
    [
      $
        Q^* / D = sqrt((2 S) / (H D))
      $
    ],
    [
      $
        Q^* / D = sqrt((2 S) / (D H mc((1 - D / P))))
      $
    ],
    [$ n^* $], [Optimal number of orders or runs per year],
    [
      $
        1 / T^* = sqrt((D H) / (2 S))
      $
    ],
    [
      $
        1 / T^* = sqrt((D H mc((1 - D / P))) / (2 S))
      $
    ],
    [$ rho $], [Utilization: fraction of each cycle spent producing. Requires $D < P$, otherwise EPQ is infeasible],
    [
      $
        0
      $
    ],
    [
      $
        D / P = T_p / T
      $
    ],
    [$ "ROP"_(L <= T) $], [Reorder point when the lead time is at most one cycle. On-hand stock equals inventory position, so you reorder when on-hand reaches $D L$. For EPQ this holds only if $L <= T_d$; otherwise on-hand is $(P - D)(T - L)$],
    table.cell(
      colspan: 2,
      $
        D L
      $
    ),
    [$ "ROP"_(L > T) $], [Reorder point when the lead time is longer than a cycle. $D L$ is still the trigger for inventory position (on-hand plus on-order), but $floor(L / T)$ orders are already in transit, so the on-hand trigger is lower],
    table.cell(
      colspan: 2,
      $
        D L - floor(L / T) Q = D L - floor((D L) / Q) Q
      $
    ),
    [
      Sensitivity \
      $ r $ 

    ], 
    [
      1. Calculate $Q^*$
      2. Another $Q$ is given or computed
      3. Compute ratio $r$
      4. $%$ cost (TVC) increase = $(r - 1) times 100$
    ], 
    table.cell(
      colspan: 2,
      $
        "TVC"(Q) / "TVC"(Q^*) = 1/2 (Q^* / Q + Q / Q^*)
      $
    ),
    
    [
      Power of 2
    ], 
    [
      1. Calculate interval $T$ (time between orders)
      2. Calculate range
      3. Check where $T^*$ falls
      4. Calculate cost ratio
      5. $%$ cost (TVC) increase = $(r - 1) times 100$
    ], 
    table.cell(
      colspan: 2,
      $
        T^* = Q^* / D \
        [T^* / sqrt(2), T^* sqrt(2)] \
        r = 1/2 (T^* / T + T / T^*) \
      $
    ),
    
  )
]


== Power of 2

1. Calculate interval $T^*$ (time between orders)

$
  T^* = Q^* / D
$

2. Calculate range

$
  [T^* / sqrt(2), T^* sqrt(2)]
$

3. Check where $T^*$ falls

#table(
  columns: 3,
  inset: (x: 1em, y: 0.75em),
  table.header([$k$], [$T = 2^k$], [In $[T^* / sqrt(2), T^* sqrt(2)]$?]),
  [0], [1], [no],
  [1], [2], [no],
  [2], [4], [no],
  [3], [8], [*yes*],
  [4], [16], [no],
)

4. Calculate cost ratio

$
  r = 1/2 (T^* / T + T / T^*)
$

5. $%$ cost (TVC) increase = $(r - 1) times 100$


= Quantity Discounts

- Break points: $q_0, q_1, dots,q_m$ ($q_0 = 0$ and $q_m = infinity$)
- If the order $Q$ is between $q_i$ and $q_(i+1)$, each unit (in the entire order) is obtained at a cost $C_i$
- $C_0 gt.eq C_1 gt.eq dots gt.eq C_(m-1)$

$
  "TVC"_i (Q) = D / Q S + Q / 2 h C_i + D C_i quad "for" q_i lt.eq Q lt q_(i+1)
$

1. Calculate the EOQ for the lowest price. If it is feasible, then stop. This is the optimal lot size. Calculate total variable cost (TVC) for this lot size
2. If the EOQ is not feasible, calculate the TVC for this price and the smallest quantity for that price (breakpoint)
3. Calculate the EOQ for the next lowest price.  If it is feasible, stop and calculate the TVC for that quantity and price
4. Compare the TVC for Steps 2 and 3.  Choose the quantity corresponding to the lowest TVC
5. If the EOQ in Step 3 is not feasible, repeat Steps 2, 3, and 4 until a feasible EOQ is found

Starting from the lowest price, evaluate the EOQ for each $C_i$:

$
  Q_i = sqrt((2 D S) / (h C_i))
$

Case 1: $q_i lt.eq Q_i lt q_(i+1)$, then $Q_i$ is feasible and:

$
  "TVC"_i = D / Q_i S + Q_i / 2 h C_i + D C_i
$

Case 2: $Q_i lt q_i$, then choose $q_i$ and:

$
  "TVC"_i = D / q_i S + q_i / 2 h C_i + D C_i
$

Select $Q^*$ with lowest TVC

== Aggregation

- $m$ products
  - $D_i$: demand of product $i$
  - $C_i$: unit cost of product $i$
  - $h$: holding rate of product $i$
- S is the common order cost (paid once per order)
- $s_i$: product-specific order cost (paid each time product $i$ is included)
- $n$: number of orders per year

#let S = 2000
#let capacity = 3000

#let DA = 10000
#let DB = 4000
#let DC = 500

#let cA = 50
#let cB = 100
#let cC = 200

#let iA = 0.20
#let iB = 0.25
#let iC = 0.30

#let sA = 500
#let sB = 800
#let sC = 1200

#let SpA = S + sA
#let SpB = S + sB
#let SpC = S + sC



#let hA = iA * cA
#let hB = iB * cB
#let hC = iC * cC

#let EOQ(D, Sp, H) = calc.sqrt((2 * D * Sp) / H)
#let TVC(D, Sp, H, Q) = Sp * D / Q + H * Q / 2

$
  H_i = c_i i_i
$

*No Aggregation*


$
  S'_i = S + s_i
$

#let QA = EOQ(DA, SpA, hA)
#let QB = EOQ(DB, SpB, hB)
#let QC = EOQ(DC, SpC, hC)

$
  Q^*_i = sqrt((2 D_i S'_i) / H_i)
$

#let nA = DA / QA
#let nB = DB / QB
#let nC = DC / QC

$
  n^*_i = D_i / Q^*_i = sqrt((D_i H_i) / (2 S'_i))
$

#let TVC_no = TVC(DA, SpA, hA, QA) + TVC(DB, SpB, hB, QB) + TVC(DC, SpC, hC, QC)

$
  "TVC"_"no" = sum_i sqrt(2 D_i S'_i H_i)
$

*Aggregation*

#let Sp = S + sA + sB + sC

$
  S' = S + sum_i s_i
$

$
  n = D_1 / Q_1 = D_2 / Q_2 = dots = D_m / Q_m
$

#let n_agg = calc.sqrt((DA * hA + DB * hB + DC * hC) / (2 * Sp))

$
  n^* = sqrt((sum_i D_i H_i) / (2 S'))
$

#let QA_agg = DA / n_agg
#let QB_agg = DB / n_agg
#let QC_agg = DC / n_agg

$
  Q^*_i = D_i / n^*
$

#let TVC_agg = n_agg * Sp + (hA * DA + hB * DB + hC * DC) / (2 * n_agg)

$
  "TVC"_"agg" = n^* S' + (sum_i (H_i D_i)) / (2 n^*) = sqrt(2 S' sum_i D_i H_i) = 2 n^* S'
$

$
  "Savings" = (1 - "TVC"_"agg" / "TVC"_"no") times 100 %
$

// ---- Compare ----

#let r(x, d: 2) = calc.round(x, digits: d)

#table(
  columns: 5,
  align: (left, right, right, right, right),
  table.header(
    [], table.cell(colspan: 2, align: center)[*No aggregation*],
        table.cell(colspan: 2, align: center)[*Complete aggregation*],
    [*Product*], [$n_i$], [$Q_i$], [$n^*$], [$Q_i$],
  ),
  [A], [#r(nA)], [#r(QA)], table.cell(rowspan: 3, align: horizon)[#r(n_agg, d: 3)], [#r(QA_agg)],
  [B], [#r(nB)], [#r(QB)], [#r(QB_agg)],
  [C], [#r(nC)], [#r(QC)], [#r(QC_agg)],
  table.hline(),
  [*TVC*], table.cell(colspan: 2)[#r(TVC_no)], table.cell(colspan: 2)[#r(TVC_agg)],
  [*Savings*], table.cell(colspan: 4, align: center)[#r(TVC_no - TVC_agg) (#r((1 - TVC_agg / TVC_no) * 100, d: 1)%)],
)

// ---- Capacity Check ----

#let load = QA_agg + QB_agg + QC_agg

#line(length: 100%)

= Newsvendor

- $D$: demand 
- $Q$: order quantity
- $p$: unit revenue 
- $c$: unit cost 
- $s$: salvage value per unit leftover
- $g$: goodwill cost per unit short

#let mu_D = 3192
#let sigma_D = 1181
#let p = 190
#let c = 110
#let s = 90
#let g = 0

#let cu = p - c + g
#let co = c - s

#let CR = cu / (cu + co)

#let z = norm.ppf(CR)

#let Q = mu_D + z * sigma_D

#[
  #set text(size: 7pt)
  #table(
    columns: 4,
    inset: 1em,
    [
      $
        c_u
      $
    ],
    [

    ],
    [
      $
        p - c + g
      $
    ],
    [

    ],
    [
      $
        c_o
      $
    ],
    [

    ],
    [
      $
        c - s
      $
    ],
    [

    ],
    [
      $
        "CR" \
        P(D lt.eq Q^*) \
        alpha
      $
    ],
    [

    ],
    [
      $
        c_u / (c_u + c_o)
      $
    ],
    [

    ],
    [
      Standardize Q \
      $z$-statistic
    ],
    [
      First step for every measure below, for any Q. At $Q^*$, $z = z^*$
    ],
    [
      $
        z = (Q - mu_D) / sigma_D
      $
    ],
    [
    ```py
    z = (Q - mu_D) / sigma_D
    z = norm.cdf(Q, loc=mu_D, scale=sigma_D)
    ```
    ],
    [Optimal order quantity $Q^*$],
    [
      Maximizes expected profit: balances underage vs. overage cost
    ],
    [
      $
        c_u = p - c + g, quad c_o = c - s \
        "CR" = c_u / (c_u + c_o) \
        z^* = Phi^(-1)("CR")\
        Q^* = mu_D + z^* sigma_D
      $
    ],
   [
      ```py
      cu = p - c + g 
      co = c - s
      cr = cu / (cu + co)
      z = norm.ppf(cr)
      Q = mu_D + z * sigma_D
      ```
    ],
    [
      In-stock probability\ 
      Type I - service level
    ], 
    [
      Probability all demand is satisfied
    ], 
    [
      $
        Phi(z)
      $
    ],
    [
      ```py
      norm.cdf(z)
      ```
    ],

    [
      $Q$ for a target in-stock probability
    ],
    [

    ],
    [
      $
        Q = μ + Φ⁻¹(alpha) sigma
      $
    ],
    [
      ```py
      alpha = 0.99
      Q = mu_D + norm.ppf(alpha) * sigma
      ```
    ],

    [
      P(Stockout)
    ], 
    [
      Probability some demand is lost
    ], 
    [
      $
        P(D > Q) 
        &= 1 - F(Q) \
        &= 1 - Phi(z) \
      $
    ],
    [
      ```py
      norm.sf(z)
      ```
    ],

    [
      E[Lost] \
      E[Short]
      
    ], 
    [
      The expected number of units by which demand will exceed the order quantity
    ], 
    [
      $
        L(z) = phi(z) - z (1 - Phi(z)) \
        E["Short"] = sigma L
      $
    ],
    [
      ```py
      L = norm.pdf(z) - z * (1 - norm.cdf(z))
      E_short = sigma_D * L
      ```
    ], 
    [
      E[sales] 
    ], 
    [
      The expected number of units sold
    ],
    [
      $
        E["Sales"] 
        &= mu_D - E["Short"] \
        &= mu_D - sigma_D L(z)
      $
    ],
    [
      ```py
      E_sales = mu_D - E_short
      ```
    ], 
    [
      Fill rate \
      Type II - service level
    ], 
    [
      The fraction of demand that is filled
    ],
    [
      $
        E["Fillrate"] 
        &= E["Sales"] / mu_D \
        &= 1 - E["Short"] / mu_D
      $
    ],
    [
      ```py
      fill_rate = E_sales / mu_D
      fill_rate = 1 - E_short / mu_D
      ```
    ],
    [
      E[Leftover]
    ],
    [
      The expected number of units left over after demand is realized
    ],
    [
      $
        E["Leftover"] 
        &= Q - E["Sales"] \ 
        &= sigma_D (z + L(z))
      $
    ],
    [
      ```py
      E_leftover = Q - mu_D + E_short
      E_leftover = Q - E_sales
      ```
    ],
    [
      E[Profit]
    ],
    [
      Expected revenue + salvage - purchase cost - goodwill penalty
    ],
    [
      $
        E["Profit"] 
        &= p E["Sales"] \
        &+ s E["Leftover"] \
        &- g E["Short"] \
        &- c Q \
      $
    ],
    [
      ```py
      E_profit = p * E_sales + s * E_leftover - c * Q - g * E_short
      E_profit = (p - s) * E_sales - (c - s) * Q - g * E_short
      ```
    ],
  )
]


E[Fill]

E[InStock]

E[Stockout]



// #let inp = (fill: luma(235), stroke: none)
// #let key = (fill: rgb("#dbe8ff"), stroke: 0.6pt + rgb("#4a6fb5"))
// #let out = (fill: rgb("#e3f4e1"), stroke: 0.6pt + rgb("#3d8a3a"), inset: 1em)
// #let tint(c) = (stroke: c, fill: rgb(..c.components().slice(0,3), 5%), inset: 0.25em)

// #figure(
//   diagram(
//     spacing: (12mm, 9mm),
//     node-corner-radius: 3pt,
//     node-inset: 5pt,
//     edge-stroke: 0.6pt,

//     // inputs
//     node((0, 0), $p$, name: <p>),
//     node((0.5, 0), $g$, name: <g>),
//     node((1, 0), $c$, name: <c>),
//     node((1.5, 0), $s$, name: <s>),
//     node(enclose: (<p>, <c>, <s>, <g>), name: <inputs>, ..tint(teal)),
    
//     node((2, 0), $mu_D$, name: <mu>),
//     node((2.5, 0), $sigma_D$, name: <sigma>),
//     node(enclose: (<mu>, <sigma>), ..tint(teal)),

//     node((0.75, 2), 
//       [
//         $
//           c_o &= c - s \
//           c_u &= p - c + g \
//           "CR" &= c_u / (c_u + c_o)
//         $
//       ], name: <cr>, ..tint(teal)
//     ),

//     node((3.6, 2), [target $alpha$], name: <a>, ..inp),
//     node((2.5, 3), $z = Phi^(-1)(dot)$, name: <z>, ..key),

//     edge(<inputs>, <cr>, "-|>"),

//     node((5, 3), $Q = mu + z sigma$, name: <q>, ..out),
    
//     node((3.2, 4), $L(z) = phi(z) - z(1 - Phi(z))$, name: <L>),
//     node((5, 3), $E["Short"] = L sigma$, name: <q>, ..out),

//     // node((0.3, 4), $P("in") = Phi(z)$, name: <pin>, ..out),
//     // node((1.4, 5), $P("out") = 1 - Phi(z)$, name: <pout>, ..out),
//     node((3.2, 6), $E["Sales"] = mu - E["Short"]$, name: <sa>),
//     node((1.4, 7), $"Fillrate" = E["Sales"] / mu$, name: <fr>, ..out),
//     node((5, 7), $E["Leftover"] = Q - E["Sales"]$, name: <lo>),
//     node((3.2, 8), $E["Profit"] = p E["Sales"] + s E["Left"] - c Q - g E["Short"]$, name: <pr>, ..out),
    
//     node((3.2, 10), $P("Stockout") = 1 - c_u / (c_u + c_o) = c_o / (c_u + c_o)$, name: <pr>, ..out),

    

//     // edge(<ms>, <q>, "-|>"),
//     // edge(<z>, <q>, "-|>"),
//     // edge(<z>, <pin>, "-|>"),
//     // edge(<pin>, <pout>, "-|>"),
//     // edge(<z>, <L>, "-|>"),
//     // edge(<L>, <sh>, "-|>"),
//     // edge(<sh>, <sa>, "-|>"),
//     // edge(<sa>, <fr>, "-|>"),
//     // edge(<sa>, <lo>, "-|>"),
//     // edge(<q>, <lo>, "-|>"),
//     // edge(<sa>, <pr>, "-|>"),
//     // edge(<lo>, <pr>, "-|>"),
//     // edge(<sh>, <pr>, "-|>", bend: -40deg),
//     // edge(<q>, <pr>, "-|>", bend: 35deg),
//   ),
//   caption: [Newsvendor dependency graph (normal demand). Gray: inputs · blue: key steps · green: answers.],
// )

== Double Marginalization

#let box-node(pos, label, name) = node(
  pos, label,
  width: 25mm, height: 10mm,
  fill: gray.lighten(60%),
  stroke: 1pt + gray.darken(20%),
  corner-radius: 5pt,
  name: name,
)

#let step(n) = box(
  inset: 0.25em, stroke: black, radius: 100%,
  fill: white, text(size: 8pt, weight: "bold")[#n],
)

#let uses(..n) = text(size: 8pt, fill: gray.darken(30%))[
  uses #n.pos().map(str).join(", ")
]


#table(
  columns: (1fr, 1fr),
  inset: 0.8em,
  align: center + top,
  table.cell(
    colspan: 2,
    [
      #diagram(
        spacing: (8mm, 5mm),
        node((-1, 0), [$c$], name: <Cost>),
        box-node((0, 0), [Supplier], <S>),
        box-node((6, 0), [Retail], <R>),
        node((7, 0), [$p$ \ $s$], name: <Mkt>),

        edge(<S>, <R>, "-|>", [$w$], bend: 15deg),
        edge(<S>, <R>, "<|-", [$b$ (retailer pays $r$)], bend: -15deg, label-side: right),
      )
    ]
  ),
  table.cell(
    colspan: 2,
    align: left,
    text(size: 8pt)[
      - $c$ production cost
      - $w$ wholesale price
      - $p$ retail price
      - $s$ retailer salvage
      - $b$ buyback price
      - $r$ return cost per unit
      - $v$ supplier salvage on returns
      - $b - r$: what the retailer nets for each return
    ],
  ),
  table.cell(fill: gray.lighten(80%))[*Supplier*],
  table.cell(fill: gray.lighten(80%))[*Retail*],
  [
    #text(size: 9pt)[Wholesale #step(2)]
    $ E[pi_S] = (w - c) Q^* $
    #text(size: 8pt)[$Q^*$ from retail wholesale]
  ],
  [
    #text(size: 9pt)[Wholesale #step(1)]
    $
        c_u &= p - w \
        c_o &= w - s \
        "cr" &= c_u / (c_u + c_o) \
        Q^* &= F^(-1)("cr") \
        z &= (Q^* - mu) / sigma \
        L(z) &= phi(z) - z (1 - Phi(z)) \
        E["Short"] &= sigma L(z) \
        E["Sales"] &= mu - E["Short"] \
        E["Left"] &= Q^* - E["Sales"] \
        E[pi_R] &= p E["Sales"] + s E["Left"] - w Q^*
    $
  ],
  [
    #text(size: 9pt)[Buyback #step(2)]
    $ E[pi_S] = (w - c) Q^* - (b - v) E["Left"] $
    #text(size: 8pt)[$Q^*$, $E["Left"]$ from retail buyback]
  ],
  [
    #text(size: 9pt)[Buyback #step(1)]
    $
      c_u &= p - w \
      c_o &= w - (b - r) \
      "cr" &= c_u / (c_u + c_o) = (p - w) / (p - b + r) \
      Q^* &= F^(-1)("cr") \
      z &= (Q^* - mu) / sigma \
      L(z) &= phi(z) - z (1 - Phi(z)) \
      E["Short"] &= sigma L(z) \
      E["Sales"] &= mu - E["Short"] \
      E["Left"] &= Q^* - E["Sales"] \
      E[pi_R] &= p E["Sales"] + (b - r) E["Left"] - w Q^*
    $
  ],

  // Supply chain
  table.cell(
    colspan: 2,
    [
      #text(size: 9pt)[*Supply Chain* #step(1)]
      $
        c_u = p - c \
        c_o = c - s \
        E[pi_"SC"] = p E["Sales"] + s E["Left"] - c Q^*
      $
      
      #text(size: 8pt)[rerun $Q^* -> E["Left"]$ chain with $"cr"_"SC"$]

      $
        (p - w) / (p - (b - r)) = (p - c) / (p - s)
      $

      $
        "given" w: quad b^* = p + r - ((p - w)(p - s)) / (p - c)
        quad quad
        "given" b: quad w^* = p - ((p - c)(p - b + r)) / (p - s)
      $

      $
        "buyback %" = b / w
      $

      #align(left)[
        #text(size: 8pt)[
          Feasiblity: 
          - $b < w$: retailer doesn't make profit returning merchandise
          - $b > s + r$: retailer prefers to return rather than salvage
          - $pi_R + pi_S = pi_"SC"$
        ]
      ]
    ]
  ),
)

#line(length: 100%)

= Order Up To

- $L$: Lead time






#[
  #set text(size: 7pt)

  #table(
    columns: 3,
    [$L$], [Lead time], [Time between ordering and receiving an order], 
    [$mu$], [Demand mean (1 period)], [], 
    [$sigma$], [Demand s.d. (1 period)], [], 
    [$mu_(L+1)$], [Demand mean ($L$ period)], [], 
    [$sigma_(L+1)$], [Demand s.d. ($L$ period)], [], 
    [$mu_(L+T)$], [Demand mean ($L+T$ period)], [], 
    [$sigma_(L+T)$], [Demand s.d. ($L+T$ period)], [], 
    [$b$], [Backorder penalty], [], 
    [$h$], [Holding cost], [], 
    [$S$], [], [], 
    [], [], [], 
    [], [], [], 
    [], [], [], 
  )

  #table(
    columns: 4,
    inset: 1em,
    [], [*Definition*], [*Formula*], [*Python*],
    [
      Inventory *Level*
    ],
    [
      Units in stock minus backorders. At the end of a period it equals $S - D_(L+1)$
    ],
    [
      $
        "OnHand" - "Backorder"
      $
    ],
    [
      ```py
      on_hand - backorder
      ```
    ],
    [
      Inventory *Position*
    ],
    [
      Inventory level plus units on order. Right after ordering it equals $S$
    ],
    [
      $
        underbrace("OnHand" - "Backorder", "Inventory\nLevel") + "OnOrder"
      $
    ],
    [
      ```py
      on_hand - backorder + on_order
      ```
    ],
    [
      Demand over $L+1$
    ],
    [
      Demand that $S$ must cover: $L$ periods of lead time plus the current period. Assumes periods are independent
    ],
    [
      $
        mu_(L+1) &= mu (L+1) \
        sigma_(L+1) &= sigma sqrt(L+1) \
      $
    ],
    [
      ```py
      mean_L1 = mean * (L + 1)
      sd_L1 = sd * np.sqrt(L + 1)
      ```
    ],
    [
      Demand over $L+T$
    ],
    [
      General case with review period $T$: $S$ must cover the lead time plus one review period
    ],
    [
      $
        mu_(L+T) &= mu (L+T) \
        sigma_(L+T) &= sigma sqrt(L+T) \
      $
    ],
    [
      ```py
      mean_LT = mean * (L + T)
      sd_LT = sd * np.sqrt(L + T)
      ```
    ],
    [
      E[OnOrder] \
      E[Pipeline] \
    ],
    [
      Number of units ordered but not received. Uses $L$, not $L+1$ (Little's Law), so it does not depend on demand variability
    ],
    [
      $
        mu L
      $
    ],
    [
      ```py
      mean * L
      ```
    ],

    [
      E[OnHand] \
      SafetyStock \
    ],
    [
      Expected on-hand inventory at the end of a period (analogous to expected leftover inventory in the newsvendor model)
    ],
    [
      $
        S - mu_(L+1) + E["Backorder"]
      $
    ],
    [
      ```py
      S - mean_L1 + e_backorder
      ```
    ],

    [
      E[Backorder]
    ],
    [
      Expected units backordered at the end of a period (analogous to expected lost sales in the newsvendor model, but the OUT model has no lost sales)
    ],
    [
      $
        z = (S - mu_(L+1)) / sigma_(L+1) \
        L(z) = phi(z) - z (1 - Phi(z)) \
        E["Backorder"] = sigma_(L+1) L(z)
      $
    ],
    [
      ```py
      z = (S - mean_L1) / sd_L1
      loss = norm.pdf(z) - z * (1 - norm.cdf(z))
      e_backorder = sd_L1 * loss
      ```
    ],
    [
      Order\
      Quantity
    ],
    [
      Ordered each period. It equals the previous period's demand (1-for-1, pull system)
    ],
    [
      $
        Q = S - I_p
      $
    ],
    [
      ```py
      q = S - inv_position
      ```
    ],
    [
      $S$ \
      OrderUpTo \
    ],
    [
      Order-up-to (base-stock) level: the maximum inventory position allowed
    ],
    [
      $
        S = mu_(L+1) + z dot sigma_(L+1)
      $
    ],
    [
      ```py
      mean_L1 = mean * (L + 1)
      sd_L1 = sd * np.sqrt(L + 1)

      z = norm.ppf(service)
      S = mean_L1 + z * sd_L1
      ```
    ],
    [
      Target InStock
    ],
    [
      Choose $S$ so the in-stock probability meets target $alpha$ (e.g. $F(3.08) = 0.9990$)
    ],
    [
      $
        Phi(mc(z)) = alpha \
        S = mu_(L+1) + mc(z) dot sigma_(L+1)
      $
    ],
    [
      ```py
      z = norm.ppf(service)
      S = mean_L1 + z * sd_L1
      ```
    ],
    [
      P(InStock)
    ],
    [
      Probability all demand is filled in a period
    ],
    [
      $
        P(D_(L+1) <= S) = Phi(z)
      $
    ],
    [
      ```py
      norm.cdf(z)
      ```
    ],
    [
      P(Stockout)
    ],
    [
      Probability at least one unit is backordered in a period
    ],
    [
      $
        1 - P(D_(L+1) <= S) = 1 - Phi(z)
      $
    ],
    [
      ```py
      1 - norm.cdf(z)
      ```
    ],
    [
      Stockouts\
      over time
    ],
    [
      For $N$ periods and in-stock target $alpha$
    ],
    [
      $
        E["periods out"] = N (1 - alpha) \
        E["periods to 1st"] = 1 / (1 - alpha)
      $
    ],
    [
      ```py
      N * (1 - alpha)
      1 / (1 - alpha)
      ```
    ],
    [
      Fillrate
    ],
    [
      Fraction of demand per period satisfied from stock. The denominator is one-period demand $mu$, not $mu_(L+1)$
    ],
    [
      $
        1 - E["Backorder"] / mu
      $
    ],
    [
      ```py
      1 - e_backorder / mean
      ```
    ],
    [
      Optimal\
      in-stock\
      probability
    ],
    [
      Critical ratio that minimises cost: $C_o = h$ if $S$ is too high, $C_u = b$ if too low
    ],
    [
      - $h$: holding cost per unit per period
      - $b$: backorder penalty per unit
      $
        P(D_(L+1) lt.eq S)
        &= C_u / (C_u + C_o) \
        &= b / (b + h) \
      $
    ],
    [
      ```py
      crit = b / (b + h)
      z = norm.ppf(crit)
      S = mean_L1 + z * sd_L1
      ```
    ],
    [
      E[Backorder] \
      SafetyStock \
      (general $L+T$)
    ],
    [
      Periodic review with review period $T$: replace $L+1$ with $L+T$
    ],
    [
      $
        S = mu_(L+T) + z dot sigma_(L+T) \
        E["Backorder"] = sigma_(L+T) L(z) \
        "SafetyStock" = S - mu_(L+T) + E["Backorder"]
      $
    ],
    [
      ```py
      S = mean_LT + z * sd_LT
      z = (S - mean_LT) / sd_LT
      loss = norm.pdf(z) - z * (1 - norm.cdf(z))
      e_backorder = sd_LT * loss
      ss = S - mean_LT + e_backorder
      ```
    ],
    [
      Cycle\
      inventory
    ],
    [
      Average order quantity is one period's demand, so cycle stock is half of it
    ],
    [
      $
        (mu T) / 2 quad (T = 1 => mu / 2)
      $
    ],
    [
      ```py
      mean * T / 2
      ```
    ],
    [
      Average\
      inventory
    ],
    [
      Used for holding cost when choosing the review period
    ],
    [
      $
        "SafetyStock" + "CycleInventory"
      $
    ],
    [
      ```py
      ss + mean * T / 2
      ```
    ],
    [
      $n$ \
      Orders/year
    ],
    [
      No order is placed in a period with zero demand
    ],
    [
      $
        (1 - P(D_T = 0)) / T_"years"
      $
    ],
    [
      ```py
      (1 - p_zero) / T_years
      ```
    ],
    [
      Days of\
      supply
    ],
    [
      Safety stock in periods of demand. Its three drivers are lead time, variability, and service level
    ],
    [
      $
        sqrt(L+1) dot sigma / mu dot (phi(z) + z Phi(z))
      $
    ],
    [
      ```py
      np.sqrt(L + 1) * sd / mean * (norm.pdf(z) + z * norm.cdf(z))
      ```
    ],
  )
]


#line(length: 100%)

Questions:
- How much to order?
- When to order?

Objective: 
- Minimize total inventory cost

Parameters
- Unit cost
- Holding cost
- Setup cost
- Lead time

= EOQ



= Not covered

- Revenue management
- Wagner-Whitin / time-varying demand
- Production wheel
- Marginal Unit Discount
- Price as a function of quantity
- Tailored aggregation
- Poisson

- EOQ with planned backorders
- EPQ when the whole batch must finish before use
- Demand as a function of price


= Study

- 2 suppliers (China / Portugal)
- Capacity control v. Overbooking
- OUT: if service level is not given, find it by balancing
- Newsvendor: $b$ $arrow$ how to calculate given param (who pays r, China v. Portugal) formula changes given problem formulation
- Inventory level / Inventory position calculations (given S, given backorders, etc.)
  - Inventory level:
    - Positive: No backorder
    - Negative: No onhand


#line(length: 100%)

#set page(paper: "a4", margin: (x: 1.6cm, y: 1.5cm),
  footer: context align(center, text(8pt, fill: luma(120))[MZ505 Inventory Systems — practice exercises · p. #counter(page).display()]))
#set text(size: 10pt, font: "New Computer Modern")
#set par(justify: true, leading: 0.55em, spacing: 0.75em)
#set enum(numbering: "(a)", indent: 0.4em, spacing: 0.55em)

#let accent = rgb("#1f4e79")
#let part(t) = block(width: 100%, inset: (y: 3pt), above: 1.3em, below: 0.6em, stroke: (bottom: 1.2pt + accent),
  text(fill: accent, weight: "bold", size: 13pt, t))
#let exn = counter("exn")
#let ex(title, body) = {
  exn.step()
  block(width: 100%, above: 1em, below: 0.6em, breakable: true)[
    #text(fill: accent, weight: "bold")[Exercise #context exn.display() — #title] \
    #body
  ]
}
#let sol(title, body) = block(width: 100%, fill: rgb("#eef4fa"), stroke: (left: 2pt + accent),
  inset: 6pt, above: 0.9em, below: 0.5em, breakable: true)[
  #text(fill: accent, weight: "bold")[#title] \
  #body
]
#let note(body) = block(width: 100%, fill: rgb("#fff6e0"), stroke: (left: 2pt + rgb("#d99a00")), inset: 6pt, below: 0.8em, body)

#align(center)[
  #text(17pt, weight: "bold", fill: accent)[MZ505 Inventory Systems — Practice Exercises] \
  #v(0.2em)
  #text(9.5pt, fill: luma(90))[EOQ family · Wagner–Whitin · Newsvendor · Contracts · Revenue management · Order-up-to]
]

#note[*Rules of the game.* Solve each exercise with your cheatsheet and a normal table, then check the solutions section (starts on a new page). When you read $z$ from a table, use the *round-up rule* (take the larger $z$, two decimals). Answers use the exact loss function $L(z)$, so table-based answers may differ in the last digit. Not included: marginal-unit discounts, price as a function of quantity, tailored aggregation, Poisson demand.]

#part[Part I · Deterministic demand]

#ex[Classic EOQ & sensitivity][
A distributor sells $D = 12\,000$ units/yr of a valve. Each order costs €80, the unit cost is €25 and the annual holding rate is 20%. The supplier's lead time is 2 weeks (52 weeks/yr).
+ Compute $Q^*$, the minimal total variable cost, the cycle time (in weeks) and the number of orders per year.
+ What is the reorder point?
+ The supplier will only ship in lots of 1,000. By what percentage does TVC rise? Verify the ratio formula against a direct computation.
+ Management wants lots of 300 units. To what value must the ordering cost fall for 300 to be optimal?
+ If the holding rate rises from 20% to 30%, what is the new $Q^*$ (without recomputing from scratch)?
]

#ex[Power-of-two policy][
Weekly demand is a constant 100 units ($D = 5200$/yr), $S = €200$ per order, $H = €2.60$/unit/yr. The base planning period is $T_B = 1$ week.
+ Compute the optimal cycle time $T^*$ in weeks.
+ Which power-of-two interval $2^k T_B$ should be used? Give $Q$.
+ What is the cost penalty relative to $T^*$? Compare with the 6% guarantee.
]

#ex[EPQ, setup from time, batch constraint][
A plant produces a component at $P = 50\,000$ units/yr; demand is $D = 20\,000$ units/yr (250 working days/yr). A setup takes 1.5 days and costs €1,000/day of lost line time. Holding cost is €4/unit/yr.
+ Compute $Q^*$, production time per run $T_p$, maximum inventory $I_max$, downtime per cycle $T_d$ and cycle length $T$ (all times in working days).
+ Number of runs per year, minimal TVC, and the fraction of the year the line is idle.
+ Suppose instead the whole batch can only be used once it is complete (it is shipped to the customer as a unit). Recompute $Q^*$ and TVC. Explain why TVC now *decreases* in $P$.
+ Back to the base model: the container system forces lots to be a multiple of 2,000. Which lot do you choose?
]

#ex[All-unit quantity discount][
Annual demand is 10,000 units, $S = €150$/order, holding rate 20%/yr. Supplier prices (all units): €20.00 for $Q < 500$; €19.00 for $500 <= Q < 2000$; €18.50 for $Q >= 2000$.
+ Apply the algorithm and find the optimal order quantity and its total annual cost (including purchase cost).
+ What is the resulting cycle inventory?
]

#ex[Aggregation & truck capacity][
A retailer buys three products from one supplier. A truck costs €600 per delivery, plus €60 per product included in the delivery. Holding rate is 20%/yr. A truck carries at most 1,000 units.

#align(center, table(columns: 4, align: center, inset: 4pt,
  [], [*Product 1*], [*Product 2*], [*Product 3*],
  [$D_i$ (units/yr)], [9,000], [3,000], [1,200],
  [$C_i$ (€/unit)], [50], [80], [120],
))
+ *No aggregation:* compute $n_i$, $Q_i$ and annual cost per product. Is every lot feasible? If not, fix it and give the total cost.
+ *Complete aggregation:* compute $n^*$ and $Q_i^*$. Check truck capacity and, if violated, give the capacity-feasible policy and its cost.
+ How much does aggregation save?
]

#ex[Product wheel][
Four products share one line, which is available 2,400 min/week. Data (per week):

#align(center, table(columns: 5, align: center, inset: 4pt,
  [], [*A*], [*B*], [*C*], [*D*],
  [Demand (units/wk)], [400], [150], [100], [50],
  [Setup cost $S_i$ (€)], [300], [200], [200], [200],
  [Holding $H_i$ (€/unit/wk)], [0.50], [0.50], [0.30], [0.40],
  [Production time (min/wk)], [900], [600], [300], [200],
  [Changeover time (min)], [60], [60], [45], [45],
))
+ If every product is produced once per wheel, what is the maximum number of wheels per week? Is one wheel/week feasible? Two?
+ Compute each product's EOQ cycle $T_i^*$ (weeks).
+ With a base cycle of 1 week, choose power-of-two multiples $k_i in {1, 2, 4, 8}$, give lot sizes, and check that the average changeover time per week fits.
]

#ex[Wagner–Whitin vs. Silver–Meal][
Demand over 6 periods is $d = (80, 20, 60, 120, 30, 70)$. Setup cost $K = €150$ per order; holding cost $h = €1$ per unit carried to the next period. No starting inventory, zero lead time, no backorders.
+ Solve with the Wagner–Whitin algorithm. Show $f(k)$ for $k = 1, dots, 6$ and the optimal ordering periods and quantities.
+ Apply the Silver–Meal heuristic. What is its plan and its cost? How far from optimal is it?
+ State the property that lets WW only consider orders of the form $Q_t = d_t + dots + d_k$.
]

#part[Part II · Newsvendor]

#ex[Newsvendor basics][
A shop orders a seasonal item once. Demand $tilde N(800, 250)$. Price €60, cost €25, leftovers sold at €10.
+ Compute $C_u$, $C_o$, the critical ratio and $Q^*$.
+ For $Q^*$, compute expected lost sales, sales, leftover inventory, expected profit, in-stock probability and fill rate.
+ Verify the expected profit with $pi(Q^*) = (p - c)mu - (C_u + C_o) phi(z^*) sigma$.
+ The buyer wants to order 1,000. What are the in-stock probability and expected profit? Is the loss large?
+ A forecasting tool would cut $sigma$ by 30%. What is the most you should pay for it per season?
]

#ex[Newsvendor variations][
Same data as Exercise 8.
+ Each unit short also costs €15 of goodwill. New critical ratio and $Q^*$?
+ (No goodwill.) A second supplier can deliver any shortfall after demand is known at €44/unit. Find $Q^*$, the expected profit, and the maximum annual fee you would pay for this option.
+ (No goodwill, no second supplier.) Placing the order has a fixed cost $S$. Does $Q^*$ change? Up to which $S$ is it worth ordering at all?
]

#ex[Discrete demand][
A bakery bakes special cakes: price €120, cost €70, unsold cakes go to a canteen for €30. Demand distribution:

#align(center, table(columns: 7, align: center, inset: 4pt,
  [Demand], [4], [5], [6], [7], [8], [9],
  [Prob.], [0.05], [0.15], [0.25], [0.25], [0.20], [0.10],
))
+ How many cakes should be baked? Use the critical ratio.
+ Verify by computing expected profit for $Q = 6, 7, 8$.
]

#ex[Supply-chain contracts][
A supplier makes a product at $c = €30$ and sells to a retailer at $w = €50$. Retail price $p = €80$, salvage $s = €10$. Demand $tilde N(2000, 600)$.
+ *Wholesale-price contract:* retailer's critical ratio, $Q$, retailer profit, supplier profit and SC profit.
+ *Integrated chain:* critical ratio, $Q$ and SC profit. How much is lost to double marginalization?
+ *Buyback:* the retailer pays $r = €2$ per returned unit; the supplier salvages returns at €10. Which buyback price $b$ coordinates the chain? Verify the retailer's critical ratio. Compute both firms' profits. Why is the SC profit still slightly below the integrated one?
]

#ex[Revenue management — protection level][
A 150-room hotel sells rooms at a discount rate €120 (abundant, books early) and a regular rate €220. Regular-rate demand $tilde N(60, 20)$.
+ Find the protection level and booking limit.
+ For that protection level, compute expected regular-rate customers turned away, regular rooms sold, empty rooms, probability the hotel is full, and expected revenue.
+ Compare with selling all rooms at the discount rate.
]

#ex[Revenue management — overbooking][
A 180-seat flight; a ticket is worth €150. A bumped passenger costs €400 (compensation + goodwill). No-shows $tilde N(12, 5)$.
+ How many reservations should be accepted?
+ Probability of bumping at least one passenger, expected number bumped, expected empty seats and expected compensation paid.
+ If compensation rises, does the airline overbook more or less? Why?
]

#part[Part III · Order-up-to model]

#ex[Order-up-to — service and cost targets][
A DC reviews inventory weekly; lead time $L = 3$ weeks. Monthly demand $tilde N(1300, 390)$ (use 4.33 weeks/month).
+ Weekly mean and st. dev.; mean and st. dev. of demand over $L + 1$.
+ Order-up-to level for a 98% in-stock probability.
+ For that $S$: expected backorders, on-hand inventory, on-order inventory, cycle inventory, fill rate.
+ This week: on-hand 350, no backorders, on-order 1,100. How much do you order?
+ Find $S$ for a 99.5% *fill rate* and for a 99.5% *in-stock* probability. Comment.
+ Unit cost €80, holding 26%/yr, backorder penalty €12/unit. Cost-optimal $S$?
]

#ex[Choosing the review period][
Weekly demand $tilde N(400, 120)$, $L = 2$ weeks, fixed order cost $K = €300$, holding €26/unit/yr, target in-stock 95% ($z = 1.645$, $L(1.645) = 0.0209$). Use 52 weeks/yr, $n = 52\/T$.
+ For $T = 1, 2, 3, 4$ weeks compute $S$, $E["BO"]$, safety stock, cycle inventory and annual holding + ordering cost.
+ Which $T$ is best? Compare with the EOQ cycle $T_"EOQ" = sqrt(2 K\/(H mu))$ and explain the difference.
]

#part[Part IV · Concepts]

#ex[Short answers][
+ Doubling demand changes $Q^*$ and TVC by what factor in the EOQ model?
+ In the EPQ model, what happens to $Q^*$ as $P -> D$? Interpret.
+ In an all-unit discount, why do you stop going to higher prices once an EOQ is feasible?
+ Why can a fill-rate target lead to a lower $S$ than the same in-stock target?
+ In the newsvendor model, does $z^*$ depend on $sigma$? Does $Q^*$?
+ Order-up-to: why is on-order inventory $L mu$ and not $(L+1)mu$? Does it depend on $sigma$?
+ Lead time halves (from 4 to 2 weeks, $T = 1$). Which inventory components fall, and by how much?
+ Why does a buyback contract raise the retailer's order quantity?
+ In the protection-level model, why is $C_o = r_L$ and $C_u = r_H - r_L$?
+ When is the order-up-to model preferable to the newsvendor model?
]

#pagebreak()
#part[Solutions]

#sol[1 · Classic EOQ][
$H = 0.2 dot 25 = 5$.
(a) $Q^* = sqrt(2 dot 12000 dot 80 \/ 5) = 619.7$; $"TVC"^* = sqrt(2 dot 12000 dot 80 dot 5) = €3098$; $T^* = 619.7\/12000 dot 52 = 2.69$ wk; $n^* = 19.4$ orders/yr.
\ 
(b) $R = D L = 12000\/52 dot 2 = 461.5$ units.
\ 
(c) Ratio $= 1/2(1000\/619.7 + 619.7\/1000) = 1.117$ → +11.7%. Direct: $12 dot 80 + 500 dot 5 = 960 + 2500 = €3460 = 1.117 dot 3098$. ✓
\ 
(d) $Q^* prop sqrt(S)$: $S' = 80 (300\/619.7)^2 = €18.75$.
\ 
(e) $H$ ×1.5 → $Q^*$ ×$1\/sqrt(1.5)$: $619.7 dot 0.816 = 506$.
]

#sol[2 · Power-of-two][
(a) $T^* = sqrt(2 S\/(H D)) = sqrt(400\/13520) = 0.172$ yr $= 8.94$ wk.
\ 
(b) Interval $[T^*\/sqrt(2), sqrt(2)T^*] = [6.32, 12.65]$ → $2^3 = 8$ weeks, $Q = 800$.
\ 
(c) Ratio $= 1/2(8\/8.94 + 8.94\/8) = 1.006$ → +0.6% (TVC $approx €2340$ vs. €2325.5), well inside the 6% guarantee.
]

#sol[3 · EPQ][
$S = 1.5 dot 1000 = €1500$; $1 - D\/P = 0.6$.
(a) $Q^* = sqrt(2 dot 20000 dot 1500\/(4 dot 0.6)) = 5000$. $T_p = 5000\/50000 = 0.1$ yr $= 25$ days; $I_max = 5000 dot 0.6 = 3000$; $T_d = 3000\/20000 = 0.15$ yr $= 37.5$ days; $T = 62.5$ days.
\ 
(b) $n = 4$ runs/yr; TVC $= sqrt(2 dot 20000 dot 1500 dot 4 dot 0.6) = €12\,000$ (6000 setup + 6000 holding). Idle fraction $= 1 - D\/P = 60%$ (150 days/yr).
\ 
(c) $Q^* = sqrt(2 D S\/(H(1 + D\/P))) = sqrt(6 dot 10^7 \/ 5.6) = 3273$; TVC $= sqrt(2 D S H dot 1.4) = €18\,330$. Inventory waits for the whole batch to finish; a faster line finishes sooner, so less stock sits waiting: $overline(I) = Q\/2 (1 + D\/P)$ falls as $P$ rises.
\ 
(d) TVC is convex: $"TVC"(4000) = 7500 + 4800 = 12\,300$; $"TVC"(6000) = 5000 + 7200 = 12\,200$ → choose *6,000*.
]

#sol[4 · All-unit discount][
(a) $C = 18.50$: $Q = sqrt(2 dot 10000 dot 150\/(0.2 dot 18.5)) = 900 < 2000$ → candidate 2000: TVC $= 750 + 3700 + 185\,000 = €189\,450$.
$C = 19$: $Q = 888.5$ feasible → candidate: TVC $= sqrt(2 dot 10000 dot 150 dot 3.8) + 190\,000 = 3376 + 190\,000 = €193\,376$. Stop (no need to evaluate €20).
→ Order *2,000* units, €189,450/yr.
\ 
(b) Cycle inventory $= 1000$ units.
]

#sol[5 · Aggregation][
(a) $S + s_i = 660$. $n_i = sqrt(D_i h C_i\/(2 dot 660))$:
P1: $n = 8.26$, $Q = 1090$, cost €10,900. P2: $n = 6.03$, $Q = 497$, €7,960. P3: $n = 4.67$, $Q = 257$, €6,166.
P1 violates the 1,000 capacity → use $Q_1 = 1000$: $9 dot 660 + 0.2 dot 50 dot 500 = €10\,940$. Total ≈ *€25,066*.
\ 
(b) $S' = 600 + 180 = 780$; $sum D_i h C_i = 90000 + 48000 + 28800 = 166\,800$. $n^* = sqrt(166800\/1560) = 10.34$; $Q = (870, 290, 116)$, total 1,276 > 1,000 → infeasible.
Capacity policy: $n = 13200\/1000 = 13.2$; $Q = (682, 227, 91)$; cost $= 13.2 dot 780 + 166800\/(2 dot 13.2) = 10\,296 + 6318 = €16\,614$.
\ 
(c) Savings ≈ €8,450/yr (≈ 34%).
]

#sol[6 · Product wheel][
(a) Production 2000 min → 400 min left for changeovers; one wheel = 210 min. Max $400\/210 = 1.9$ wheels/wk → 1/wk feasible (2210 ≤ 2400), 2/wk not (2420 > 2400).
\ 
(b) $T_i^* = sqrt(2 S_i\/(H_i D_i))$: A 1.73, B 2.31, C 3.65, D 4.47 weeks.
\ 
(c) Power-of-two: A → 2 ($[1.22, 2.45]$), B → 2 ($[1.63, 3.27]$), C → 4 ($[2.58, 5.16]$), D → 4 ($[3.16, 6.32]$). Lots: A 800, B 300, C 400, D 200. Avg. changeover $= 60\/2 + 60\/2 + 45\/4 + 45\/4 = 82.5$ min/wk ≤ 400 ✓.
]

#sol[7 · Wagner–Whitin & Silver–Meal][
(a) $f(k) = min_(j <= k) {f(j-1) + K + sum_(t=j)^k h(t - j) d_t}$:

#align(center, table(columns: 8, align: center, inset: 3.5pt,
  [$k$ \\ $j$], [1], [2], [3], [4], [5], [6], [$f(k)$],
  [1], [150], [], [], [], [], [], [*150*],
  [2], [170], [300], [], [], [], [], [*170*],
  [3], [290], [360], [320], [], [], [], [*290*],
  [4], [650], [600], [440], [440], [], [], [*440*],
  [5], [770], [690], [500], [470], [590], [], [*470*],
  [6], [1120], [970], [710], [610], [660], [620], [*610*],
))
Backtrack: $k = 6$ → $j = 4$; $k = 3$ → $j = 1$. Order *160 in period 1* (periods 1–3) and *220 in period 4* (periods 4–6). Cost €610.
\ 
(b) From period 1: avg. cost 150, 85, 96.7 → stop, cover periods 1–2 (100). From period 3: 150, 135, 110, 135 → cover 3–5 (210). Period 6: 70. Cost $= 170 + 330 + 150 = €650$, 6.6% above optimal.
\ 
(c) Zero-inventory ordering: $I_(t-1) dot Q_t = 0$ — you only order when inventory runs out, so each order covers an integer number of whole periods.
]

#sol[8 · Newsvendor basics][
(a) $C_u = 35$, $C_o = 15$, $alpha = 0.70$, $z = 0.53$ (exact 0.524) → $Q^* = 800 + 0.53 dot 250 = 932.5 approx 933$.
\ 
(b) $L(0.53) = 0.1887$ → short $= 47.2$; sales $= 752.8$; left $= 179.7$; $pi = 60 dot 752.8 + 10 dot 179.7 - 25 dot 932.5 approx €23\,654$. In-stock $= Phi(0.53) = 70.2%$; fill rate $= 1 - 47.2\/800 = 94.1%$.
\ 
(c) $35 dot 800 - 50 dot phi(0.53) dot 250 = 28\,000 - 50 dot 0.3467 dot 250 approx €23\,667$ (difference from rounding $z$).
\ 
(d) $z = 0.8$: in-stock 78.8%; $L(0.8) = 0.120$, short 30.1, sales 769.9, left 230.1, $pi approx €23\,497$ → only €157 less: the profit curve is flat near the optimum.
\ 
(e) $theta (C_u + C_o) phi(z^*) sigma = 0.3 dot 50 dot 0.3467 dot 250 approx €1300$.
]

#sol[9 · Variations][
(a) $C_u = 50$, $alpha = 50\/65 = 0.769$, $z = 0.74$ → $Q^* = 985$.
\ 
(b) $C_u = c_2 - c = 19$, $C_o = 15$, $alpha = 0.559$, $z = 0.15$ → $Q^* = 837.5$. $L(0.15) = 0.3284$: short 82.1, left 119.6. $pi = 60 dot 800 - 25 dot 837.5 - 44 dot 82.1 + 10 dot 119.6 approx €24\,646$. Value of option $approx 24\,646 - 23\,654 = €992$/season.
\ 
(c) $Q^*$ unchanged (the fixed cost doesn't affect the marginal trade-off). Order iff $pi(Q^*) - S > pi(0) = 0$ → $S < €23\,654$.
]

#sol[10 · Discrete demand][
(a) $alpha = 50\/90 = 0.556$. Cumulative: $F(5) = 0.20$, $F(6) = 0.45$, $F(7) = 0.70$ → smallest $Q$ with $F(Q) >= 0.556$ is *7*.
\ 
(b) $E pi(6) = 277.5$, $E pi(7) = 287.0$, $E pi(8) = 274.0$ → 7 ✓.
]

#sol[11 · Contracts][
(a) Retailer: $C_u = 30$, $C_o = 40$, $alpha = 0.429$, $z = -0.18$ → $Q = 1892$. Short 297.2, sales 1702.8, left 189.2. $pi_R = 80 dot 1702.8 + 10 dot 189.2 - 50 dot 1892 approx €43\,514$; $pi_S = 20 dot 1892 = €37\,840$; $pi_"SC" = €81\,354$.
\ 
(b) $alpha = 50\/70 = 0.714$, $z = 0.57$ → $Q = 2342$; short 106.2, sales 1893.8, left 448.2; $pi_"SC" approx €85\,724$. Loss to double marginalization ≈ €4,370 (5.1%).
\ 
(c) $b = p + r - (p - w)(p - s)\/(p - c) = 82 - 30 dot 70\/50 = €40$ (80% of $w$). Retailer: $C_u = 30$, $C_o = 50 - 40 + 2 = 12$, $alpha = 30\/42 = 0.714$ ✓ → $Q = 2342$.
$pi_R = 80 dot 1893.8 + 38 dot 448.2 - 50 dot 2342 approx €51\,434$; $pi_S = 20 dot 2342 - 30 dot 448.2 approx €33\,393$. Sum €84,827 = integrated − $r dot E["left"] = 85\,724 - 896$: the return shipping cost is a deadweight loss.
]

#sol[12 · Protection level][
(a) $C_u = 100$, $C_o = 120$, $alpha = 100\/220 = 0.455$, $z = -0.11$ → $Q = 60 - 2.2 = 57.8$ → protect *58*, booking limit *92*.
\ 
(b) $z = -0.10$, $L(-0.10) = 0.451$: turned away $= 20 dot 0.451 = 9.0$; regular sold 51.0; empty $= 58 - 60 + 9.0 = 7.0$; $"Pr"("full") = 1 - Phi(-0.1) = 0.54$. Revenue $= 220 dot 51.0 + 120 dot 92 approx €22\,256$.
\ 
(c) All discount: $150 dot 120 = €18\,000$ → protection adds ≈ €4,256 (+24%).
]

#sol[13 · Overbooking][
(a) $C_u = 150$, $C_o = 400$, $alpha = 0.273$, $z = -0.60$ → $R = 12 - 3 = 9$ → accept *189* reservations.
\ 
(b) $"Pr"("bump") = Phi(-0.6) = 0.274$. $L(-0.6) = 0.769$: bumped $= (9 - 12) + 5 dot 0.769 = 0.84$; empty seats $= 3.84$; compensation $= 400 dot 0.84 approx €337$.
\ 
(c) Less: higher $C_o$ lowers $alpha$, so a lower $R$.
]

#sol[14 · Order-up-to][
(a) $mu_w = 1300\/4.33 = 300.2$; $sigma_w = 390\/sqrt(4.33) = 187.4$. $L + 1 = 4$: $mu = 1200.9$, $sigma = 2 dot 187.4 = 374.8$.
\ 
(b) $z = 2.06$ → $S = 1200.9 + 2.06 dot 374.8 = 1973.1 → 1974$.
\ 
(c) $z = 2.06$, $L(z) = 0.0072$: BO $= 2.69$; on-hand $= 1974 - 1200.9 + 2.7 = 775.8$; on-order $= 3 dot 300.2 = 900.7$; cycle $= 150.1$; FR $= 1 - 2.69\/300.2 = 99.1%$.
\ 
(d) Position $= 350 - 0 + 1100 = 1450$ → order $1974 - 1450 = 524$.
\ 
(e) Fill rate: $L(z) = 0.005 dot 300.2\/374.8 = 0.0040$ → $z = 2.27$ → $S = 2052$. In-stock 99.5%: $z = 2.58$ → $S = 2168$. The fill-rate target needs less stock: a stockout period usually loses only a small part of the week's demand.
\ 
(f) $h = 0.26 dot 80\/52 = €0.40$/wk; $alpha = 12\/12.4 = 0.968$, $z = 1.85$ → $S = 1894.4 → 1895$.
]

#sol[15 · Review period][
#align(center, table(columns: 8, align: center, inset: 3.5pt,
  [$T$], [$sigma_(L+T)$], [$S$], [BO], [SS], [Cycle], [Hold + Order], [Total],
  [1], [207.8], [1542], [4.34], [346], [200], [14 202 + 15 600], [29 802],
  [2], [240.0], [1995], [5.01], [400], [400], [20 795 + 7 800], [*28 595*],
  [3], [268.3], [2441], [5.60], [447], [600], [27 222 + 5 200], [32 422],
  [4], [293.9], [2884], [6.14], [490], [800], [33 531 + 3 900], [37 431],
))
\ 
(b) $T = 2$ weeks. $T_"EOQ" = sqrt(2 dot 300\/(26 dot 20800)) = 0.0333$ yr $= 1.73$ wk → rounds to 2 too. EOQ ignores that safety stock grows with $sqrt(L + T)$, which pushes the stochastic optimum toward slightly shorter $T$.
]

#sol[16 · Short answers][
(a) Both × $sqrt(2) approx 1.41$.
\ 
(b) $Q^* -> infinity$: production barely outpaces demand, so stock hardly builds up — just run continuously.
\ 
(c) Every cheaper tier would need a larger $Q$ with a higher unit price → dominated.
\ 
(d) In a stockout period only part of the demand goes unfilled, so fill rate > in-stock probability for the same $S$.
\ 
(e) $z^*$ no (depends only on $C_u, C_o$); $Q^* = mu + z^* sigma$ yes (up if $z^* > 0$, down if $z^* < 0$).
\ 
(f) An order spends $L$ periods in the pipeline; by Little's law: throughput $mu$ × $L$. Independent of $sigma$.
\ 
(g) Pipeline falls linearly: $4mu -> 2mu$. Safety stock falls as $sqrt(L+1)$: $sqrt(3)\/sqrt(5) = 0.77$ → −23%. Cycle stock unchanged.
\ 
(h) Lower overage cost for the retailer ($w - b + r$ instead of $w - s$) → higher critical ratio → larger $Q$.
\ 
(i) Protect one too many and the room may stay empty, losing the sure discount sale ($r_L$); protect one too few and a regular customer pays $r_L$ instead of $r_H$.
\ 
(j) Many replenishments, long product life, backordered demand: inventory carries over between periods.
]

= Midterm Review Questions

1. (REVIEW!)

- $L$: 2
- $S$: 10
- $"IP"$: -4

Therefore:
- $D$: -14

$
  "IP" 
  &= "IL" + "On-Order" \
  &= "Onhand" - "Backorder" + "On-Order" \
  &= 0 - 4 + 0 \
  &= 0 - 5 + 1 \
  &= 0 - 10 + 6 \
$

On order is always positive

Therefore:
- $e$

2. 

CR: Probavility

Profit maximizing given cost structure

$
  P(D lt.eq Q^*) = "CR"
$

$
  min(Q^*, D) \
  E[min(Q^*, D)] = E[D - (D - Q)^+] = mu - E["short"] \
$

$
  E["sales"] lt.eq E["Demand"]
$

No backorders

Therefore:
- $a$

3. 

- $e$

4. 

Skip

5. 
#[
  #let D = 52000 // year
  #let P = 2000 // week
  #let S = 1000 // week
  #let H = 13 // unit / year
  #let weeks_per_year = 52
  #let L = 1 // week

  #let P = P * weeks_per_year

  #let Q = calc.sqrt((2 * D * S) / (H * (1 - D / P)))
  #Q

  #let n = Q / D
  #(n * weeks_per_year)

  #let Tp = Q / P
  #(Tp * weeks_per_year)
  
  
  #let ROP = (D / weeks_per_year) * L
  #ROP

  #let setup = 13 * 1000
  #let holding = 13 * 1000

  // Why setup + holding
]

#[
  #let mu = 5000
  #let sigma = 1000
  #let p = 20
  #let c = 8
  #let s = 3
  #let g = 0


]

= 6

#[
  #let mu = 5000
  #let sigma = 1000
  
  // Metta
  #let p = 20
  #let w = 8
  #let s = 3

  // Geno
  #let c = 4.50
  #let r = 1
  #let s_g = 4.00
  #let b = 6

  #let cu = p - w
  #let co = w - s

  #let cr = cu / (cu + co)
  #let z = norm.ppf(cr)

  #let Q = mu + z * sigma

  #Q

  #let loss = norm.pdf(z) - z * (1 - norm.cdf(z))
  #let e_lost = sigma * loss

  #e_lost

  #let e_sales = mu - e_lost
  #e_sales

  #let e_left = Q - e_sales
  #e_left

  #let e_profit_retailer = p * e_sales + s * e_left - w * Q
  #e_profit_retailer

  #let e_profit_supplier = Q * (w - c)
  #e_profit_supplier
  
  #let b = p + r - ((p - w) * (p - s)) / (p - c)

  #b

  Choose to slaveage where beneficial (s_g - r or s)


]

= 7

#[
  #let D = 400
  #let S = 80
  #let h = 0.2

  #let Cs = (8.50, 8.00, 7.50)
  #let qs = (99, 999)

  #let EOQ(C) = calc.sqrt((2 * D * S) / (C * h))
  #let TVC(Q, C) = S * D / Q + h * C * Q / 2 + C * D

  #let Q = EOQ(Cs.at(2))
  #let tvc = TVC(Q, Cs.at(2))

  #Q

  #tvc

  Not feasible

  Do for 1000

  #let tvc = TVC(1000, Cs.at(2))

  #tvc

  Now $C_2$

  #let Q = EOQ(Cs.at(1))
  #let tvc = TVC(qs.at(1), Cs.at(2))

  #Q

  #tvc
]

= 8

#[
  #let min = 300
  #let max = 600
  #let c = 2
  #let p = 3
  #let s = 1.50
  #let g = 0

  #let cu = p - c + g
  #let co = c - s

  #let cr = cu / (cu + co)
  #let Q = uniform.ppf(cr)

  #Q
]

= 9

#[
  #let mu = 100 // week
  #let sigma = 30
  #let L = 2 // weeks
  #let c = 10 
  #let p = 20
  #let H = 0.1 // week
  #let b = p - c

  
]