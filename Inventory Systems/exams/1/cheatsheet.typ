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

- Unit cost ($c$): \$ / unit
- Holding cost rate ($h$): fraction of $c$ / time
- Holding cost ($H = h c$): \$ / unit / time
- Demand rate ($D$): units / time
- Order (lot) quantity ($Q$): units
- Cycle time ($T$): time
- Setup / ordering cost ($S$): \$ / order
- Production rate ($P$): units / time, $P > D$
- Lead time ($L$): time
- Inventory level ($I$): units
- Maximum inventory level ($I_"max"$): units
- Average inventory level ($macron(I)$): units

#table(
  columns: 3,
  [], [EOQ], [EPQ],
  [$I_max$],
  [What is the highest inventory level in a cycle?],
  [],

  [$Q^*$],
  [What is the optimal order (lot) size?],
  [],
  
  [$macron(I)$],
  [How much inventory do we hold on average?],
  [],
  
  [$N^*$],
  [How many orders should we place per unit of time (the time unit of $D$)?],
  [],
  
  [$R$],
  [At what inventory level should we place the next order?],
  [],

  [$T$], 
  [How long is one cycle (the time between two consecutive orders)?], 
  [How long is one cycle (time between the starts of two consecutive production runs)?],

  [$T^*$], 
  [What is the optimal time between orders?], 
  [What is the optimal time between production runs?],

  [$T_p$], [-], [How long does each production run last?],
  [$T_d$], [-], [How long does inventory last after production stops, until it hits zero?],

  [Sensitivity],
  [How much extra cost do we pay if we order $Q$ instead of $Q^*$?],
  [],
  
  [Power of 2],
  [What reorder interval should we use if intervals must be powers of 2 of a base period, and how much does that cost us?],
  [],
)

#table(
  columns: (auto, 1fr, 1fr),
  inset: 1em,
  [], [*EOQ*], [*EPQ*],

  [Total\ Cost],
  [
    $ "TC"(Q) = c D + S D / Q + H Q / 2 $
  ],
  [
    $ "TC"(Q) = c D + S D / Q + H Q / 2 (1 - D / P) $
  ],

  [Max\ Inventory],
  [
    $ I_"max" = Q $
  ],
  [
    $
      Q = T_p P quad arrow.double quad T_p = Q / P \
      I_"max" = T_p (P - D) = Q (1 - D / P) \
      T_d = I_"max" / D = Q / D - Q / P \
      T = T_p + T_d = Q / D
    $
  ],

  [Total\ Variable\ Cost],
  [
    $ "TVC"(Q) = S D / Q + H Q / 2 $
  ],
  [
    $ "TVC"(Q) = S D / Q + H I_"max" / 2 $
    $ "TVC"(Q) = S D / Q + H Q / 2 (1 - D / P) $
  ],

  [Derivative],
  [
    $ (dif "TVC") / (dif Q) = - (S D) / Q^2 + H / 2 = 0 $
  ],
  [
    $ (dif "TVC") / (dif Q) = - (S D) / Q^2 + H / 2 (1 - D / P) = 0 $
  ],

  [Closed\ Form\ ($Q^*$)],
  [
    $ Q^* = sqrt((2 D S) / H) $
  ],
  [
    $ Q^* = sqrt((2 D S) / (H (1 - D / P))) $
  ],

  [Closed\ Form\ ($"TVC"(Q^*)$)],
  [
    $ "TVC"(Q^*) = sqrt(2 D S H) $
    At $Q^*$: $S D / Q^* = H Q^* / 2$
  ],
  [
    $ "TVC"(Q^*) = sqrt(2 D S H (1 - D / P)) $
    At $Q^*$: setup cost = holding cost
  ],

  [Average\ (Cycle)\ Inventory],
  [
    $ macron(I) = Q / 2 $
  ],
  [
    $ macron(I) = I_"max" / 2 = Q / 2 (1 - D / P) $
  ],

  [Cycle Time],
  [
    $ "TC"(T) = c D + S / T + H (D T) / 2 $
    $ (dif "TC") / (dif T) = - S / T^2 + (H D) / 2 = 0 $
    $ T^* = Q^* / D = sqrt((2 S) / (D H)) $
  ],
  [
    $ "TC"(T) = c D + S / T + H (D T) / 2 (1 - D / P) $
    $ T^* = Q^* / D = sqrt((2 S) / (D H (1 - D / P))) $
  ],

  [Order\ Frequency],
  [
    $ N^* = D / Q^* = 1 / T^* = sqrt((D H) / (2 S)) $
  ],
  [
    $ N^* = D / Q^* = sqrt((D H (1 - D / P)) / (2 S)) $
  ],

  [Reorder\ Point],
  [
    $ R = D L $
  ],
  [
    $ R = D L $
  ],

  [Sensitivity],
  [
    $ "TVC"(Q) / "TVC"(Q^*) = 1 / 2 (x + 1 / x), quad x = Q / Q^* $
  ],
  [
    Same formula, using the EPQ $Q^*$
  ],

  [Power of 2],
  [
    Base period $T_B$ (e.g. 1 day), $T = 2^k T_B$
    $
      2^0 T_B = 1 "day" \
      2^1 T_B = 2 "days" \
      2^2 T_B = 4 "days" \
      dots.v
    $
    Pick the smallest $k$ with $T^* \/ sqrt(2) <= 2^k T_B <= sqrt(2) T^*$\
    Cost $<= 1.06 dot "TVC"(Q^*)$ (about 2% if $T_B$ is chosen optimally)
  ],
  [
    Same rule, using the EPQ $T^*$
  ],
)

= All-Unit Discount

Price breaks $0 = q_0 < q_1 < dots < q_r$; price $c_i$ applies to *all* units if $q_i <= Q < q_(i+1)$.

$
  "TC"_i (Q) = c_i D + S D / Q + h c_i Q / 2
$

$
  Q^*_i = sqrt((2 D S) / (h c_i))
$

*Procedure*
+ For each range $i$, compute $Q^*_i$.
+ If $Q^*_i < q_i$, set $Q_i = q_i$. If $Q^*_i >= q_(i+1)$, set $Q_i = q_(i+1)$ (or skip the range: range $i+1$ at $Q = q_(i+1)$ always costs less). Otherwise keep $Q_i = Q^*_i$.
+ Evaluate $"TC"_i (Q_i)$ and pick the range with the lowest total cost.

= Aggregation

Several *products* in the same shipment
OR
several *customers* in the same shipment

- $D_i$: demand of product $i = 1, dots, m$ (units / time)
- $c_i$: unit cost of product $i$ (\$ / unit)
- $h$: holding cost rate (fraction of $c_i$ / time), so $H_i = h c_i$
- $S$: fixed setup cost per shipment (\$ / shipment)
- $s_i$: extra setup cost if product $i$ is in the shipment (\$ / shipment)
- $n$: number of shipments (shipments / time)

*Complete Aggregation* (every product in every shipment)

$
  tilde(S) = S + s_1 + s_2 + dots + s_m
$

$
  Q_i = D_i / n quad arrow.double quad n = D_i / Q_i
$

$
  "TVC"(n)
  &= tilde(S) n + sum_(i=1)^m h c_i Q_i / 2 \
  &= tilde(S) n + sum_(i=1)^m (h c_i D_i) / (2 n)
$

$
  (dif "TVC"(n)) / (dif n) = tilde(S) - (sum_(i=1)^m h c_i D_i) / (2 n^2) = 0
  quad arrow.double quad
  n^* = sqrt((sum_(i=1)^m h c_i D_i) / (2 tilde(S)))
$

$
  Q^*_i = D_i / n^*, quad
  "TVC"(n^*) = sqrt(2 tilde(S) sum_(i=1)^m h c_i D_i)
$

*No Aggregation* (for comparison: each product has its own EOQ)

$
  Q^*_i = sqrt((2 D_i (S + s_i)) / (h c_i)), quad
  "TVC" = sum_(i=1)^m sqrt(2 D_i (S + s_i) h c_i)
$

#line(length: 100%)

$
  n = D_1 / Q_1 = D_2 / Q_2 = dots = D_m / Q_m
$

$
  "TVC"(n) = n S' + (h c_1 D_1) / (2 n) + dots + (h c_m D_m) / (2 n)
$

$
  Q^*_i = D_i / n^* quad "for" i = 1, dots, m
$


Newsvenodor

- $c$: cost per unit
- $p$: price per unit
- $s$: salvage price per unit leftover 
- $g$: goodwill (penalty) per unit short
- $c_u$: Underage

$
  c_u = p + g - c \
  c_o = c - s \
$

$
  "cr" = c_u / (c_u + c_o)
$

$
  Pi(Q) = p E["sold"] + s E["leftover"] - g E["short"] - c Q
$

- $E["sold"] = E[min(D, Q)] = E[D - (D - Q)^+] = mu - E["short"]$ 
- $E["leftover"] = Q - E["sales"] = Q - mu + E["short"]$
- $E["short"] = E[(D - Q)^+]$

Z

$
  z = (D - mu) / sigma
$

$
  L(z) = 
$

Fill rate

$
  "Fill Rate" = E["sold"] / mu = 1 - E["short"] / mu
$

Integrated SC

