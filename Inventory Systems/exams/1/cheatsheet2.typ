#import "@local/tystats:0.1.0": norm, expon, poisson, uniform
#import "@preview/lilaq:0.5.0" as lq

// =====================================================================
//  MZ505 Inventory Systems — Ultimate Formula Sheet
//  Scope: EOQ · EPQ · sensitivity · power of two · all-unit discounts ·
//         aggregation · newsvendor · SC contracts · order-up-to
//  Not covered: revenue management, Wagner–Whitin, production wheel,
//  marginal-unit discounts, price as a function of quantity,
//  tailored aggregation, Poisson.
// =====================================================================

#let FS = 7.5pt
#set page(paper: "a4", margin: (x: 0.1cm, y: 0.1cm), columns: 2)
#set columns(gutter: 0.35cm)
#set text(font: "Libertinus Serif", size: FS, lang: "en")
#set par(leading: 0.42em, spacing: 0.45em, justify: false)
#show math.equation: set text(font: "New Computer Modern Math")
#set enum(spacing: 0.42em, indent: 0pt, body-indent: 0.3em)
#set list(spacing: 0.42em, indent: 0pt, body-indent: 0.3em, marker: [•])
#set table(stroke: 0.3pt + luma(185), inset: (x: 2.4pt, y: 2.2pt))
#show table: it => { show math.frac: f => math.display(f); it }

#let navy = rgb("#1e3a6b")
#let red = rgb("#b3261e")
#let mc(x) = text(fill: red, x)

#let mod(t) = block(fill: luma(232).darken(75%), inset: (x: 4pt, y: 2pt), radius: 1.5pt, width: 100%,
  above: 5pt, below: 2.5pt, sticky: true,
  text(fill: white, weight: "bold", size: FS + 1.2pt, t))
#let sub(t) = block(above: 4pt, below: 2pt, sticky: true,
  text(fill: navy, weight: "bold", size: FS + 0.4pt, t))
#let vars(b) = block(fill: luma(232), inset: 2.5pt, width: 100%, radius: 1.5pt,
  above: 2pt, below: 2.5pt, text(size: FS - 0.6pt)[*Variables:* #b])
#let teo(b) = block(fill: rgb("#eef6ee"), inset: 2.5pt, width: 100%, radius: 1.5pt,
  above: 2pt, below: 2.5pt, text(size: FS - 0.6pt, b))
#let nota(b) = block(fill: rgb("#fdf1d8"), inset: 2.5pt, width: 100%, radius: 1.5pt,
  above: 2.5pt, below: 2.5pt, text(size: FS - 0.6pt, b))
#let key(b) = block(stroke: 0.7pt + navy, inset: 3pt, width: 100%, radius: 1.5pt,
  above: 3pt, below: 3pt, b)
#let hd(..xs) = xs.pos().map(x => text(weight: "bold", x))

#let sec(t) = table.cell(colspan: 3, fill: luma(232), align: left, strong(t))
#let both(body) = table.cell(colspan: 2, body)

// =====================================================================
#mod[1 · EOQ and EPQ]
#vars[$D$ demand rate · $S$ cost per order/setup · $C$ unit cost · $p$ selling price · $i$ holding rate (%/yr) · $H = i C$ holding cost per unit per year · $Q$ lot size · $P$ production rate ($P > D$) · $L$ lead time · $T$ cycle · $n$ orders (runs) per year · $T_p$ uptime · $T_d$ downtime · TVC total variable cost/yr · TC total cost/yr · $pi$ profit/yr.]
#teo[*EOQ assumptions:* demand & lead time known and constant; instantaneous receipt; constant price; holding on average inventory; constant order cost; no backorders. Trade-off: ordering (economies of scale) vs. holding. *EPQ:* production at $P$ while demand consumes at $D$ → stock rises at $P - D$, never reaches $Q$. EPQ $>$ EOQ; $P -> infinity$ gives EOQ.]
#[
#set text(size: FS - 1pt)
#table(
  columns: (auto, 1fr, 1.25fr),
  align: (left, center, center),
  inset: 0.5em,
  fill: (x, y) => if y == 0 { luma(232) },
  ..hd[], [EOQ], [EPQ],
  [$"TVC"(Q)$], $S D/Q + H Q/2$, $S D/Q + H Q/2 mc((1 - D/P))$,
  [$"TC"(Q)$], table.cell(colspan: 2, $C D + "TVC"(Q)$),
  [$pi(Q)$], $(p - C) D - S D/Q - H Q/2$, $(p - C) D - S D/Q - H Q/2 mc((1 - D/P))$,
  [$pi^*$], $(p - C) D - sqrt(2 D S H)$, $(p - C) D - sqrt(2 D S H mc((1 - D\/P)))$,
  [FOC], $-S D/Q^2 + H/2 = 0$, $-S D/Q^2 + H/2 mc((1 - D/P)) = 0$,
  [$Q^*$], $sqrt((2 D S)/H)$, $sqrt((2 D S)/(H mc((1 - D\/P))))$,
  [$"TVC"(Q^*)$], $sqrt(2 D S H)$, $sqrt(2 D S H mc((1 - D\/P)))$,
  [$I_max$], $Q$, $T_p (P - D) = Q (1 - D\/P)$,
  [$macron(I)$ avg], $Q\/2$, [$I_max \/ 2$ (not $Q\/2$)],
  [$T_p$], $0$, $Q\/P$,
  [$T_d$], $Q\/D$, $I_max \/ D$,
  [$T$], $Q\/D$, $T_p + T_d = Q\/D$,
  [$n$], table.cell(colspan: 2, $D\/Q = 1\/T$),
  [$T^*$], $sqrt((2 S)/(D H))$, $sqrt((2 S)/(D H mc((1 - D\/P))))$,
  [$n^*$], $sqrt((D H)/(2 S))$, $sqrt((D H mc((1 - D\/P)))/(2 S))$,
  [$rho$ util.], $0$, [$D\/P = T_p\/T$ (need $D < P$)],
  [$1 - rho$ idle], [—], [$1 - D\/P = T_d\/T$; idle time/yr $= (1 - D\/P) times$ 1 yr],
)
]
- *Profit:* with $p$ and $C$ fixed, $(p - C) D$ is a constant → $max pi <=> min "TVC"$, same $Q^*$. Price breaks or $p(Q)$ change this (use TC/$pi$ per range).
- At $Q^*$: ordering cost $=$ holding cost $= "TVC"^* \/ 2$. EPQ downtime/yr $= n T_d = (1 - rho)$ yr. Savings $= 1 - "TVC"(Q^*) \/ "TVC"(Q_"current")$.
- *Reorder point* (on-hand trigger, $D$, $L$ same unit). $L <= T$: $"ROP" = D L$. $quad L > T$: inventory position still triggers at $D L$, but $floor(L\/T)$ orders are in transit:
$ "ROP"_"on-hand" = D L - floor(L\/T) Q $
- EPQ: $D L$ is the on-hand trigger only if $L <= T_d$; if $T_d < L <= T$ the reorder falls during the run and on-hand $= (P - D)(T - L)$.

// =====================================================================
#mod[2 · Sensitivity and robustness]
#key[
$ r = ("TVC"(Q))/("TVC"(Q^*)) = 1/2 (Q^* /Q + Q/Q^*) quad quad "% increase" = (r - 1) times 100 $
]
- Steps: compute $Q^*$ → take the other $Q$ (given / rounded / policy) → $r$ → $(r - 1) 100%$.
- Benchmarks: $Q\/Q^* = 4\/3$ or $3\/4$ → +4.2% · $sqrt(2)$ → +6.1% · 2 or 1⁄2 → +25%. TVC is flat near $Q^*$.
- *Scaling:* $Q^* prop sqrt(D S \/ H)$, $"TVC"^* prop sqrt(D S H)$, $n^* prop sqrt(D H \/ S)$. A parameter ×$k$ → multiply by $sqrt(k)$ if it is in the numerator, divide by $sqrt(k)$ if in the denominator. E.g. $S times 4$: $Q^*$ and $"TVC"^*$ ×2. To halve the lot, $S$ must fall to $S\/4$.
- *Mis-estimated input* ($D$ or $S$ off by factor $k$, or $H$ off by $1\/k$): $Q = sqrt(k) Q^*$, penalty $r = 1/2 (sqrt(k) + 1\/sqrt(k))$ (e.g. $k = 2$ → +6.1%).

// =====================================================================
#mod[3 · Power-of-two policies]
#vars[$T^*$ optimal interval · $T_B$ base period (1 week $= 1\/52$ yr) · $T = 2^k T_B$, $k = 0, 1, 2, dots$ · $"TVC"(T) = S\/T + H D T \/ 2$ (with $Q = D T$).]
+ $T^* = Q^* \/ D$ (convert to base periods).
+ *Range test:* choose the $k$ with $2^k T_B in [T^* \/ sqrt(2), #h(2pt) sqrt(2) T^*]$ (exactly one exists). \
  Equivalent: smallest $k$ with $"TVC"(2^k T_B) <= "TVC"(2^(k+1) T_B)$.
  #align(center)[
  #set text(size: FS - 1.5pt)
  #table(
    columns: 3,
    [$k$], [$2^k$], [In $[T\/sqrt(2), , T sqrt(2)]$],
    [0], [0], [no],
    [1], [2], [no],
    [2], [4], [*yes*],
    [3], [8], [no],
  )
  ]
+ Cost ratio $r = 1/2 (T^* /T + T/T^*) <= 1/2 (sqrt(2) + 1/sqrt(2)) = 1.0607$ → at most +6.1%.
+ Lot $Q = D T$; % increase $= (r - 1) times 100$.

// =====================================================================
#mod[4 · All-unit quantity discounts]
#vars[Break points $q_0 = 0 < q_1 < dots < q_m = infinity$ · if $q_i <= Q < q_(i+1)$ *every* unit costs $C_i$ · $C_0 >= C_1 >= dots$ · $H_i = h C_i$ changes with price.]
#key[
$ "TC"_i (Q) = D/Q S + Q/2 h C_i + mc(D C_i) quad q_i <= Q < q_(i+1) quad quad Q_i = sqrt((2 D S)/(h C_i)) $
]
+ Start at the *lowest* price. If $Q_i$ is feasible ($q_i <= Q_i < q_(i+1)$): candidate $Q_i$, *stop* (higher prices cannot beat it).
+ If $Q_i < q_i$: candidate $= q_i$ (the break point); move to the next higher price and repeat.
+ $Q^* =$ candidate with the lowest $"TC"_i$. Cycle inventory $= Q^* \/ 2$.
#nota[Must include purchase cost $D C_i$ (it differs across ranges): compare TC, not TVC. Read break points carefully: "1,001–2,000" → $q_i = 1 thin 001$.]

// =====================================================================
#mod[5 · Aggregation (joint ordering)]
#vars[$m$ products · $S$ common cost per order (truck/transport) · $s_i$ product-specific cost (paid when $i$ is in the order) · $D_i$, $C_i$, $h$, $H_i = h C_i$ · $n$ orders/yr · $K$ truck capacity (units per order).]
#sub[No aggregation (each product alone, $S'_i = S + s_i$)]
$ Q_i^* = sqrt((2 D_i S'_i)/H_i) quad n_i^* = sqrt((D_i H_i)/(2 S'_i)) quad "TVC"_"no" = sum_i sqrt(2 D_i S'_i H_i) $
#sub[Complete aggregation (all products every order, $S' = S + sum_i s_i$)]
$ n = D_i \/ Q_i "(same for all)" quad "TVC"(n) = n S' + (sum_i H_i D_i)/(2 n) $
#key[
$ n^* = sqrt((sum_i D_i H_i)/(2 S')) quad Q_i^* = D_i / n^* quad "TVC"_"agg" = sqrt(2 S' sum_i D_i H_i) = 2 n^* S' $
]
- Savings $= (1 - "TVC"_"agg" \/ "TVC"_"no") times 100%$.
- Report per product: $Q_i$, $n$, cycle inventory $Q_i \/ 2$, days of inventory $= Q_i \/ (2 D_i) times 365$.
#sub[Infeasible solution: capacity $K$ binds]
TVC is convex in $Q$ (or $n$) → if the unconstrained optimum breaks capacity, the best feasible point is *on the boundary* (full truck).
#[
#set text(size: FS - 0.3pt)
#table(
  columns: (auto, 1fr),
  fill: (x, y) => if y == 0 { luma(232) },
  ..hd[Case], [If infeasible → fix and recompute],
  [No aggr. ($Q_i^* > K$)], [$Q_i = K$, #h(2pt) $n_i = D_i \/ K$ \
    $"TVC"_i = (D_i \/ K)(S + s_i) + H_i K \/ 2$ \ (not $sqrt(2 D_i S'_i H_i)$)],
  [Aggregated \ ($sum_i D_i \/ n^* > K$)], [$n = sum_i D_i \/ K > n^*$, #h(2pt) $Q_i = D_i \/ n = K D_i \/ sum_j D_j$ \
    $"TVC" = n S' + sum_i H_i D_i \/ (2 n)$ (not $2 n S'$)],
)
]
- Savings then use the *constrained* costs on both sides. Order-cost share $!=$ holding share → check by computing both terms.

// =====================================================================
#mod[6 · Newsvendor (single period)]
#vars[$D$ demand, $N(mu, sigma)$ · $Q$ order qty · $p$ price · $c$ unit cost · $s$ salvage per leftover · $g$ goodwill per unit short (0 if not given) · $C_u$ underage (1 too few) · $C_o$ overage (1 too many) · $alpha$ critical ratio · $F$ CDF · $Phi, phi$ std. normal CDF, pdf · $L(z)$ std. normal loss · $theta$ fraction by which $sigma$ is cut.]
#teo[Order $Q$ once, before demand → pay $c Q$ → demand → sell $min(Q, D)$ at $p$ → leftovers at $s$ → each shortage costs $g$. If unsure of $C_u$, $C_o$: profit lost by having 1 fewer / 1 more unit.]
#key[
$ C_u = p - c + g quad quad C_o = c - s $
$ "Marginal unit: " C_o F(Q) = C_u (1 - F(Q)) $
$ F(Q^*) = P(D <= Q^*) = alpha = C_u/(C_u + C_o) = (p - c + g)/(p - s + g) $
$ z^* = Phi^(-1)(alpha), quad Q^* = mu + z^* sigma $
#align(center)[round $Q$ up · $alpha < 0.5 => z^* < 0 => Q^* < mu$]
]
#sub[Performance for any $Q$ (first: $z = (Q - mu)\/sigma$)]
#[
#set text(size: FS - 0.3pt)
#table(
  columns: (auto, 1fr),
  [], [$z = (Q - mu)\/sigma$ #h(4pt) (use the *rounded* $Q$) → look up $Phi(z)$, $L(z)$, $phi(z)$],
  [In-stock (Type I SL)], [$P(D <= Q) = Phi(z)$ #h(4pt) (= $alpha$ at $Q^*$) · counts *seasons*],
  [Stockout prob.], $P(D > Q) = 1 - Phi(z)$,
  [$E["short"]$ (lost sales)], $E(D - Q)^+ = sigma L(z), quad L(z) = phi(z) - z(1 - Phi(z))$,
  [$E["sales"]$], [$E[min(D, Q)] = mu - E["short"]$ #h(4pt) (always $< mu$)],
  [$E["left"]$], $E(Q - D)^+ = Q - E["sales"] = Q - mu + E["short"] = sigma (z + L(z))$,
  [Identities], [$E["sales"] + E["short"] = mu$ #h(4pt) · #h(4pt) $E["sales"] + E["left"] = Q$],
  [Fill rate (Type II)], [$E["sales"]\/mu = 1 - E["short"]\/mu$ · counts *units* → usually $>$ in-stock],
  [Target fill rate FR], [$L(z) = (1 - "FR") mu \/ sigma$ → $z$ from loss table (take larger $z$) → $Q = mu + z sigma$],
  [Expected profit \ (any $Q$)], [
    $
      pi
      &= p E["sales"] + s E["left"] - g E["short"] - c Q \
      &= (p - c) mu - C_u E["short"] - C_o E["left"]
    $
  ],
  [Mismatch cost], $C(Q) = C_u E["short"] + C_o E["left"] quad -> quad pi = (p - c) mu - C(Q)$,
  [Max profit \ (only at $Q^*$)], [
    $pi(Q^*) = (p - c) mu - (C_u + C_o) phi(z^*) sigma$
    $
      phi(z) = 1/sqrt(2 pi) e^(-z^2\/2)
    $
  ],
  [Cut $sigma$ by $theta$], [
    $theta = (sigma_"old" - sigma_"new")/sigma_"old" = 1 - sigma_"new"/sigma_"old"$ \
    $Delta pi = theta (C_u + C_o) phi(z^*) sigma_"old" = (C_u + C_o) phi(z^*) (sigma_"old" - sigma_"new")$ \
    ($z^*$ unchanged; profit linear in $sigma$; $phi$ = pdf, not $Phi$)
  ],
)
]
#sub[Mismatch cost]
- $(p - c) mu$: crystal-ball profit — knowing $D$, you order exactly $D$ and earn $p - c$ on every unit.
- *Too few* (lost sale): each costs $C_u = p - c + g$, expect $E["short"]$ → $C_u E["short"]$.
- *Too many* (leftover): each costs $C_o = c - s$, expect $E["left"]$ → $C_o E["left"]$.
- $C(Q) = C_u E["short"] + C_o E["left"]$ = expected cost of guessing wrong → $pi = (p - c) mu - C(Q)$: maximizing profit $<=>$ minimizing mismatch cost.
- *At $Q^*$* (proof): $E["left"] = sigma(z^* + L(z^*))$ and $1 - Phi(z^*) = C_o\/(C_u + C_o)$ → $C(Q^*) = sigma[(C_u + C_o) L(z^*) + C_o z^*] = (C_u + C_o) phi(z^*) sigma$ = constant $times sigma$.

#sub[Value of cutting $sigma$]
- $alpha$ and $z^*$ do not depend on $sigma$ → $C(Q^*)$ and $pi^*$ are *linear* in $sigma$; with $sigma = 0$ you earn the crystal-ball profit.
- $theta = 1 - sigma_"new"\/sigma_"old"$ → $Delta pi = theta (C_u + C_o) phi(z^*) sigma_"old" = (C_u + C_o) phi(z^*)(sigma_"old" - sigma_"new")$ = max to pay for a forecast tool / quick response.
- Use the $C_u$, $C_o$ of *the setting* (e.g. 2nd supplier: $C_u = c_P - c_C$) → different $z^*$, $phi(z^*)$, so a fast supplier makes better forecasts worth less. $phi$ = pdf, not $Phi$.

#sub[Variants]
- *Discrete demand table:* $Q^* =$ smallest $Q$ with $F(Q) >= alpha$ (cumulate probabilities). $E["short"] = sum_(d > Q) (d - Q) P(d)$; then the same chain.
- *Goodwill:* $C_u = p - c + g$ and $- g E["short"]$ in $pi$. Compare scenarios with the same $g$.
- *Fixed order cost* $K$: $Q^*$ unchanged; profit $pi(Q^*) - K$; order only if $> pi(0) = -g mu$ (with $g = 0$: if $> 0$).
- *Sensitivity:* $s arrow.t => C_o arrow.b => Q^* arrow.t$ · $g arrow.t$ or $p arrow.t => Q^* arrow.t$ · $c arrow.t => Q^* arrow.b$ · $sigma arrow.t$: $Q^* arrow.t$ if $z^* > 0$, $arrow.b$ if $z^* < 0$; $pi^* arrow.b$ always.

#sub[Uniform demand $D tilde U[a, b]$ (exact, no tables)]
#key[
$ mu = (a + b)/2 quad sigma = (b - a)/sqrt(12) quad F(Q) = (Q - a)/(b - a) $
$ Q^* = a + alpha (b - a) quad quad P("short") = 1 - alpha = (b - Q)/(b - a) $
]
#[
#set text(size: FS - 0.3pt)
#table(
  columns: (auto, 1fr),
  [$E["short"]$], $(b - Q)^2 \/ (2(b - a))$,
  [$E["left"]$], $(Q - a)^2 \/ (2(b - a))$,
  [$E["sales"]$], [$mu - E["short"] = Q - E["left"]$],
  [Fill rate], $1 - E["short"]\/mu$,
  [Profit], [same chain: $pi = (p - c) mu - C_u E["short"] - C_o E["left"]$],
)
]
- Valid for $a <= Q <= b$. If $Q <= a$: nothing left over, $E["short"] = mu - Q$. If $Q >= b$: nothing short.
- *Second run on residual demand* 
  - $U[a, b]$: $Q^*_2 = a + alpha (b - a)$ 
  - max short $= (1 - alpha)(b - a)$
  - max left $= alpha (b - a)$
  - $P(R > Q_2^*) = (b - Q_2^*)/(b - a) = 1 - alpha$

#sub[Backup supplier (China $c_C$ before season · Portugal $c_P$ after $D$ known)]
#teo[A unit short can be lost (costs $p + g$) or bought from Portugal (costs $c_P$) → take the cheaper. Portugal has no demand risk; China is cheap but must be ordered blind.]
#key[
$ C_u = min(p + g, #h(2pt) c_P) - c_C quad quad C_o = c_C - s $
]
#[
#set text(size: FS - 0.3pt)
#table(
  columns: (auto, 1fr),
  fill: (x, y) => if y == 0 { luma(232) },
  ..hd[Condition], [Decision],
  [$c_P >= p + g$], [*All from China* · Portugal never used (dearer than losing the sale) → plain newsvendor, $C_u = p - c_C + g$],
  [$c_C < c_P < p + g$], [*Both* · China $Q_C$ from $alpha$ below, Portugal tops up the shortfall],
  [$c_P <= c_C$], [*All from Portugal* · $Q_C = 0$ ($C_u <= 0$); $pi = (p - c_P) mu$, no risk],
)
]
*Both suppliers* ($c_C < c_P < p + g$) — recalculate the chain:
#key[
$ C_u = c_P - c_C quad alpha = (c_P - c_C)/(c_P - s) quad z = Phi^(-1)(alpha) quad Q_C = mu + z sigma $
$ E["short"] = sigma L(z) = E["Portugal order"] quad E["left"] = Q_C - mu + E["short"] $
$ pi = p mu - c_C Q_C - c_P E["short"] + s E["left"] $
]
- $E["sales"] = mu$ (every unit is served) → fill rate and in-season service $= 100%$; $g$ *drops out* of $pi$ (no lost sales).
- Max one-time fee for Portugal $= pi_"both" - pi_"China only"$. Goodwill $g arrow.t$ → $pi_"China only" arrow.b$, $pi_"both"$ unchanged → Portugal worth more.
- Fixed cost $K$ per China order: $Q_C$ unchanged; order from China only if $pi_"both" (Q_C) - K > (p - c_P) mu$ (Portugal-only profit).
- Value of cutting $sigma$ by $theta$: $theta (c_P - s) phi(z) sigma$ (smaller than China-only, since Portugal already absorbs risk).

// =====================================================================
#mod[7 · Supply-chain contracts (double marginalization)]
#vars[$c$ supplier's production cost · $w$ wholesale price · $p$, $s$, $g$ retailer's price, salvage, goodwill · $b$ buy-back price per return · $r$ cost per return (shipping) · $v$ supplier's salvage per returned unit (0 if scrapped) · $pi_R$, $pi_S$, $pi_"SC"$.]
#teo[Each firm decides with its own margin → retailer uses $C_u = p - w < p - c$, $C_o = w - s > c - s$ → orders *less* than the SC optimum. Contracts shift risk/margin to coordinate. Every profit uses the same chain: $Q -> z -> L(z) -> E["short"] -> E["sales"] -> E["left"]$. *Order:* solve the retailer first (its $Q$, $E["left"]$), then plug them into $pi_S$.]
#[
#set text(size: FS - 0.3pt)
#table(
  columns: (auto, 1fr),
  fill: (x, y) => if y == 0 { luma(232) },
  ..hd[Benchmark], [Critical ratio and profits],
  [Wholesale], [$C_u = p - w + g$, #h(2pt) $C_o = w - s_R$ → $Q_R$ \
    $pi_R = p E["sales"] + s_R E["left"] - g E["short"] - w Q$ \
    $pi_S = (w - c) Q$],
  [Integrated SC], [$C_u = p - c + g$, #h(2pt) $C_o = c - s_"SC"$ ($w$ cancels) → larger $Q$ \
    $pi_"SC" = p E["sales"] + s_"SC" E["left"] - g E["short"] - c Q$],
)
]
- Double-marginalization loss $= pi_"SC" - (pi_R + pi_S)_"wholesale"$. #h(4pt) Buy-back % $= b\/w$.
- *Given $b$, find $w^*$* (column (a), $g = 0$): $w^* = p - (p - c)(p - b + r)\/(p - s)$.
#[
#set text(size: FS - 3pt)
#table(
  columns: (auto, 1fr, 1fr, 1fr),
  fill: (x, y) => if y == 0 { luma(232) },
  ..hd[],
    [(a) Returned · *retailer* pays return freight $r$ · supplier salvages $s_S$],
    [(b) Returned · *supplier* pays return freight $r$ · supplier salvages $s_S$],
    [(c) No return · retailer salvages $s_R$ · supplier pays credit $b$],

  [$R^*$ ], table.cell(colspan: 3,
    [$R^* = p + g - ((p - w + g)(p - s_"SC" + g))/(p - c + g)$, #h(4pt) $s_"SC" = max(s_R, #h(1pt) s_S - r)$]),
  [Retailer recovers $R$], $b - r$, $b$, $b + s_R$,
  [$b^*$ (given $w$: set $R = R^*$)], $R^* + r$, $R^*$, $R^* - s_R$,
  [$w^*$ (given $b$)],
    $p + g - ((p - c + g)(p - b + r + g))/(p - s_"SC" + g)$,
    $p + g - ((p - c + g)(p - b + g))/(p - s_"SC" + g)$,
    $p + g - ((p - c + g)(p - b - s_R + g))/(p - s_"SC" + g)$,
  [$C_u^R$], table.cell(colspan: 3, [$p - w + g$ #h(4pt)]),
  [$C_o^R = w - R$], $w - b + r$, $w - b$, $w - b - s_R$,
  [$alpha_R$], table.cell(colspan: 3, [$C_u^R \/ (C_u^R + C_o^R) = (p - w + g)\/(p - R + g)$]),
  [$pi_R$], $p E["sales"] + (b - r) E["left"] - g E["short"] - w Q$, $p E["sales"] + b E["left"] - g E["short"] - w Q$, $p E["sales"] + (b + s_R) E["left"] - g E["short"] - w Q$,
  [$pi_S$], $(w - c) Q - (b - s_S) E["left"]$, $(w - c) Q - (b + r - s_S) E["left"]$, $(w - c) Q - b E["left"]$,
  [Chain per leftover], $s_S - r$, $s_S - r$, $s_R$,
  [Feasible $b$], $s_R + r < b < w$, $s_R < b < w$, $0 < b < w - s_R$,
)
]
- $pi_R + pi_S = p E["sales"] + ("SC per leftover") E["left"] - c Q$. Equals integrated $pi_"SC"$ (with $s$) only if that value $= s$: in (a)/(b) need $v - r = s$, so with $v = s$ the SC is slightly below integrated (shipping $r$ is wasted). (c) coordinates *exactly* (no shipping). Exact coordination for (a)/(b): use $s_"SC" = v - r$ in $(p - c)\/(p - s_"SC")$.
- Who pays $r$ does not change $pi_"SC"$, only how it is split ($b$ shifts by $r$).
- Accepted only if *both* $pi_R$ and $pi_S$ beat their wholesale-contract values.

#table(
  columns: 5,
  inset: 0.45em,
  align: (left, center, center, center, center, left),
  fill: (x, y) => if y == 0 { luma(232) },
  [*Firm*], [*Better off*], [*No change*], [*Worse off*], [*Unsure*],
  [Retailer], [$b - r > s_R$], [$b - r <= s_R$], [never], [—],
  [Supplier], [$s_S >= b$ #h(2pt) (and $b - r > s_R$)], [$b - r <= s_R$], [—], [$s_S < b$],
)

#sub[Demand as a function of price: $D(p) = A - B p$ (deterministic)]
#vars[$A$ demand at $p = 0$ · $B$ units lost per €1 of price · $P_0 = A\/B$ price at which demand hits 0 · $c$ production cost · $w$ wholesale · $m = p - w$ retailer margin · $pi^0$ wholesale-contract profits · $F$ franchise fee.]
#teo[Each firm maximizes (its margin) × (demand). The *follower's* reaction is plugged into the *leader's* problem (solve backwards). Linear demand → optimal price is the *midpoint* between $P_0$ and the relevant cost.]
#[
#set text(size: FS - 0.3pt)
#table(
  columns: (auto, 1fr),
  fill: (x, y) => if y == 0 { luma(232) },
  ..hd[Setting], [Result],
  [Retailer, given $w$], [$max_p (p - w)(A - B p)$ → $p(w) = (P_0 + w)\/2$, #h(2pt) $D = B(P_0 - w)\/2$],
  [Supplier leads \ (sets $w$ first)], [$max_w (w - c) B(P_0 - w)\/2$ → $w = (P_0 + c)\/2$, $p = (3 P_0 + c)\/4$, $D = B(P_0 - c)\/4$ \
    $pi_S = B(P_0 - c)^2\/8$, #h(2pt) $pi_R = B(P_0 - c)^2\/16$],
  [Integrated], [$max_p (p - c)(A - B p)$ → $p^I = (P_0 + c)\/2$, $D^I = B(P_0 - c)\/2 = 2 D_"dec"$, $pi^I = B(P_0 - c)^2\/4$],
  [Retailer leads \ (sets $m = p - w$ first)], [Supplier reacts: $max_w (w - c) B(P_0 - m - w)$ → $w(m) = (P_0 - m + c)\/2$, #h(2pt) $D = B(P_0 - m - c)\/2$ \
    Retailer: $max_m m dot B(P_0 - m - c)\/2$ → $m = (P_0 - c)\/2$ \
    → $w = (P_0 + 3 c)\/4$, $p = w + m = (3 P_0 + c)\/4$, $D = B(P_0 - c)\/4$ \
    $pi_R = B(P_0 - c)^2\/8$, #h(2pt) $pi_S = B(P_0 - c)^2\/16$],
)
]
- Decentralized: leader earns 2× the follower; total $= 3\/4$ of integrated (25% lost). Price too high because both firms add a margin (double marginalization) → lower demand.
- *Quantity discount* (price $w'$ only if $Q >= D^I$): the retailer must charge $p^I$ to sell $D^I$; both accept if $c + pi_S^0\/D^I <= w' <= p^I - pi_R^0\/D^I$.
- *Franchise* ($w = c$ + fixed fee $F$): retailer faces the chain's cost → sets $p^I$; both accept if $pi_S^0 <= F <= pi^I - pi_R^0$.

// =====================================================================
#mod[8 · Order-up-to (periodic review, backorders)]
#vars[$L$ lead time (periods) · $T$ review period ($T = 1$ default) · $mu$, $sigma$ demand per period · $D_(L+1)$ demand over $L + 1$ periods · $S$ order-up-to (base-stock) level · $alpha$ target in-stock · $h$ holding/unit/period · $b$ backorder penalty/unit · $N$ periods · $K$ cost per order · $f$ freight cost per unit]
#teo[Long-life product, stationary random demand, unlimited replenishments, backorders. Each period: order → the order from $L$ periods ago arrives → demand. Order $= S -$ IP $=$ last period's demand (one-for-one, pull). Level at end of period $= S - D_(L+1)$.]

// ---- OUT timeline (S11 slide 4 / S12 slide 2) ----
#let step(n, t, sub) = box(stroke: 0.6pt + rgb("#1e3a6b"), inset: 4pt, radius: 2pt, width: 100%)[
  #align(center)[*#n. #t* \ #text(size: 0.85em, fill: luma(90), sub)]
]
#let arr = align(center + horizon, text(size: 1.3em)[→])

*Each period (day, week, …):*
#grid(
  columns: (1fr, auto, 1fr, auto, 1fr),
  column-gutter: 3pt,
  step(1, [Order], [$"order" = S - "IP"$ \ (= last period's demand)]),
  arr,
  step(2, [Receive], [order placed $L$ periods ago arrives]),
  arr,
  step(3, [Demand], [random $D$; unmet → backorder]),
)
#v(3pt)
*Example, $L = 1$:*
#table(
  columns: (auto, 1fr, 1fr, 1fr),
  align: center, inset: 3pt, stroke: 0.4pt + luma(170),
  [], [*Period 1*], [*Period 2*], [*Period 3*],
  [Order], [$q_1$ placed], [$q_2$ placed], [$q_3$ placed],
  [Receive], [(from period 0)], [$q_1$ arrives], [$q_2$ arrives],
  [Demand], [$D_1$], [$D_2$], [$D_3$],
)
#text(size: 0.85em)[An order placed in period $t$ must cover demand in periods $t, dots, t + L$ → $S$ protects $L + 1$ periods.]

#sub[Inventory level vs. inventory position]
#key[
$ "IL" = "OnHand" - "BO" quad quad "IP" = "OnHand" + "OnOrder" - "BO" = "IL" + "OnOrder" $
]
#[
#set text(size: FS - 0.3pt)
#table(
  columns: (1fr, auto, auto, auto, auto),
  align: (left, center, center, center, center),
  fill: (x, y) => if y == 0 { luma(232) },
  ..hd[Event], [OnHand], [OnOrder], [BO], [IP],
  [Place an order of $q$], [—], [$+q$], [—], [$arrow.t q$],
  [Shipment of $q$ arrives], [$+q$], [$-q$], [—], [unchanged],
  [Arrival fills $x$ backorders], [$-x$], [—], [$-x$], [unchanged],
  [Demand $d$ (stock / backorder)], [$-$], [—], [$+$], [$arrow.b d$],
)
]
- *Never both positive* (arriving stock fills backorders first): 
  - $"BO" > 0 => "OnHand" = 0$
  - $"OnHand" > 0 => "BO" = 0$
So: 
- $"IL" >= 0$: OnHand $=$ IL, BO $= 0$
- $"IL" < 0$: BO $= -$IL, OnHand $= 0$
- IL and IP *can be negative*.
- $D_(t-1) = S - "IP"_t$
- $Q = S - "IP"$
- $"IP" = S$ right after ordering and right before demand
- *Only demand lowers IP; only ordering raises IP.* Arrivals and filling backorders just move units between terms.
- IP right after ordering $= S$ → IP before ordering $= S - $ last period's demand.

#[
#set text(size: FS - 2pt)
#table(
  columns: (auto, 1fr, 1fr),
  inset: 0.45em,
  align: (col, row) => if col == 0 { left + horizon } else { center + horizon },
  table.header(
    [],
    [*Review every period* \ ($T = 1$)],
    [*Review every $mc(T)$ periods* \ (replace $L + 1$ by $L + mc(T)$)],
  ),

  sec[Policy],
  [Mean demand \ over horizon],     [$mu_(L+1) = (L + 1) mu$],                [$mu_(L+T) = (L + mc(T)) mu$],
  [Std. dev. \ (periods indep.)],   [$sigma_(L+1) = sqrt(L + 1) thin sigma$], [$sigma_(L+T) = sqrt(L + mc(T)) thin sigma$],
  [Service level],                  both[$z = Phi^(-1)(alpha)$],
  [Cost-based $alpha$],             [$alpha = C_u/(C_u + C_o) = b/(b + h)$ \ ($h$ *per period*)], [—],
  [Order-up-to],                    [$S = mu_(L+1) + z sigma_(L+1)$],         [$S = mu_(L+T) + z sigma_(L+T)$],
  [Given $S$],                      [$z = (S - mu_(L+1)) \/ sigma_(L+1)$],    [$z = (S - mu_(L+T)) \/ sigma_(L+T)$],

  sec[Service],
  [In-stock prob.],                 [$P(D_(L+1) <= S) = Phi(z)$],             [$P(D_(L+T) <= S) = Phi(z)$],
  [Stockout prob.],                 both[$1 - Phi(z)$],
  [$E["Backorder"]$],               [$sigma_(L+1) L(z)$],                     [$sigma_(L+T) L(z)$],
  [Fill rate],                      [$1 - E["BO"] \/ mu$],                    [$1 - E["BO"] \/ (mu mc(T))$],
  [Target fill rate \ FR $->$ $L(z)$], [$L(z) = (1 - "FR") mu \/ sigma_(L+1)$], [$L(z) = (1 - "FR") mu mc(T) \/ sigma_(L+T)$],
  [Stockouts in $N$ \ (review cycles)], both[$N (1 - alpha)$],
  [Cycles until \ 1st stockout],    both[$1 \/ (1 - alpha)$],

  sec[Inventory],
  [$E["On-hand"]$ = SS],            [$S - mu_(L+1) + E["BO"]$ \ $= sigma_(L+1) (phi(z) + z Phi(z))$],
                                    [$S - mu_(L+T) + E["BO"]$ \ $= sigma_(L+T) (phi(z) + z Phi(z)) approx z sigma_(L+T)$],
  [Cycle inventory],                [$mu \/ 2$],                              [$mu mc(T) \/ 2$],
  [Avg. inventory],                 [$"SS" + mu \/ 2$],                       [$"SS" + mu mc(T) \/ 2$],
  [$E["On-order"]$ \ = pipeline],   both[$L mu$ #h(0.5em) (Little's law; $L$, not $L + T$; indep. of $sigma$)],
  [Days of supply],                 [$"SS" \/ mu$ (+ cycle $1\/2$)],          [$"SS" \/ mu$ (+ cycle $mc(T)\/2$)],
  

  sec[Cost (keep all in the same time unit)],
  [Orders / yr],                    [$n = 1 \/ T_"yr"$],                      [$n = (1 - P(D_T = 0)) \/ T_"yr"$ \ ($= 1\/T_"yr"$ for normal demand)],
  [Annual cost],                    both[
    $underbrace(("SS" + "CI") H_"yr", "holding")
     + underbrace(n K, "ordering")
     + underbrace(L_"yr" mu_"yr" H, "if firm owns" \ "in-transit")
     + underbrace(f mu_"yr", "transport")$
  ],
)
]

- Rounding: always recompute $z$ from the *rounded* $S$.
- $E["BO"] approx$ newsvendor expected lost sales, but the fill rate divides by *one review cycle's* demand ($mu T$), not $mu_(L+T)$.
- Optimal in-stock is usually high because $b >> h$. Annual $h$ → $h\/52$ for weekly periods.
- Safety-stock drivers: lead time, variability $sigma\/mu$, service level. $L arrow.b => mu_(L+T), sigma_(L+T), S$, on-order and SS all $arrow.b$ (strongest at high $alpha$).
- Target fill rate: $L(z)$ from the table → look up $z$ (larger) → $S$.
- *Choosing $T$* (min ordering + holding per yr):
  + For each $T = 1, 2, 3, dots$: $mu_(L+T)$, $sigma_(L+T)$ → $S$ → $E["BO"] = sigma_(L+T) L(z)$ → $"SS" = S - mu_(L+T) + E["BO"]$.
  + $"Cost"(T) = H_"yr" ("SS" + mu T\/2) + K n$, #h(2pt) $n approx 1\/T_"yr"$ (+ $L mu H$ if pipeline owned; transport $f mu_"yr"$ is the same for every $T$).
  + Pick the min. Start near $T_"EOQ" = sqrt(2K\/(H mu))$ (in periods); the optimum is close but not equal (EOQ ignores SS).
  - $T arrow.t$: fewer orders, but SS $prop sqrt(L+T)$ and cycle stock $prop T$ $arrow.t$. If $alpha = b\/(b+h)$ with $h$ per review period, a longer $T$ gives a lower $alpha$.

// #pagebreak()

// #let CR = 0.8
// #let MU = none
// #let SD = none

// #let loss(x) = (norm.pdf)(x) - x * (1 - (norm.cdf)(x))
// #let z = norm.ppf(CR)
// #let e-short = loss(z)
// #let e-left  = z + loss(z)

// #let c-sold  = rgb("#6c8ee0")
// #let c-left  = rgb("#5a9e6a")
// #let c-short = rgb("#d4726a")
// #let soft(c) = c.transparentize(55%)
// #let r3(x) = str(calc.round(x, digits: 3))

// #let xs = lq.linspace(-3.5, 3.5, num: 281)
// #let xl = xs.filter(x => x <= z) + (z,)
// #let xr = (z,) + xs.filter(x => x >= z)
// #let surv(x) = 1 - (norm.cdf)(x)

// = Newsvendor on a standard normal

// #text(9pt)[CR = #CR #h(0.6em) $z = Phi^(-1)("CR") = #r3(z)$]

// #lq.diagram(
//   width: 15cm, height: 5.2cm,
//   title: [PDF: $Q$ splits demand outcomes into "leftover" and "short"],
//   xlabel: [$x$ (demand in $sigma$ units from the mean)], ylabel: [$phi(x)$],
//   xlim: (-3.5, 3.5), ylim: (0, 0.45),
//   legend: (position: top + left),
//   lq.fill-between(xl, xl.map(norm.pdf), fill: soft(c-left), stroke: none,
//     label: [$D <= Q$: leftover, prob $Phi(z) = "CR"$]),
//   lq.fill-between(xr, xr.map(norm.pdf), fill: soft(c-short), stroke: none,
//     label: [$D > Q$: short, prob $1 - "CR"$]),
//   lq.plot(xs, xs.map(norm.pdf), mark: none, stroke: 1.4pt + black),
//   lq.vlines(0, stroke: (paint: gray, dash: "dashed")),
//   lq.vlines(z, stroke: 1pt + black),
//   lq.place(0.05, 0.43, align: left)[$mu$],
//   lq.place(z + 0.05, 0.43, align: left)[$Q = mu + z sigma$],
// )

// #v(4pt)

// #lq.diagram(
//   width: 15cm, height: 5.2cm,
//   title: [Per outcome: sold $= min(D, Q)$, leftover $= (Q-D)^+$, short $= (D-Q)^+$],
//   xlabel: [$x$ (realised demand, $sigma$ units)], ylabel: [units ($sigma$)],
//   xlim: (-3.5, 3.5), ylim: (-3.5, 3.5),
//   legend: (position: top + left),
//   lq.fill-between(xs, xs.map(x => calc.min(x, z)), y2: xs.map(_ => -3.5),
//     fill: soft(c-sold), stroke: none, label: [sold]),
//   lq.fill-between(xl, xl, y2: xl.map(_ => z), fill: soft(c-left), stroke: none, label: [leftover]),
//   lq.fill-between(xr, xr, y2: xr.map(_ => z), fill: soft(c-short), stroke: none, label: [short]),
//   lq.plot(xs, xs, mark: none, stroke: (paint: gray, dash: "dashed")),
//   lq.plot(xs, xs.map(x => calc.min(x, z)), mark: none, stroke: 1.6pt + c-sold.darken(20%)),
//   lq.vlines(z, stroke: (paint: black, dash: "dotted")),
//   lq.place(2.6, 3.0)[$y = D$],
//   lq.place(2.9, z + 0.3)[$y = Q$],
// )

// #v(4pt)

// #lq.diagram(
//   width: 15cm, height: 5.2cm,
//   title: [In expectation: areas around $1 - Phi(x)$ (units of $sigma$)],
//   xlabel: [$x$], ylabel: [$P(Z > x)$],
//   xlim: (-3.5, 3.5), ylim: (0, 1.05),
//   legend: (position: top + right),
//   lq.fill-between(xl, xl.map(surv), fill: soft(c-sold), stroke: none,
//     label: [sold (relative to the left edge)]),
//   lq.fill-between(xl, xl.map(_ => 1), y2: xl.map(surv), fill: soft(c-left), stroke: none,
//     label: [$E["leftover"] = sigma (z + L(z))$ = #r3(e-left) $sigma$]),
//   lq.fill-between(xr, xr.map(surv), fill: soft(c-short), stroke: none,
//     label: [$E["short"] = sigma L(z)$ = #r3(e-short) $sigma$]),
//   lq.plot(xs, xs.map(surv), mark: none, stroke: 1.4pt + black),
//   lq.vlines(0, stroke: (paint: gray, dash: "dashed")),
//   lq.vlines(z, stroke: 1pt + black),
//   lq.place(0.05, 0.05, align: left)[$mu$],
//   lq.place(z + 0.05, 0.05, align: left)[$Q$],
// )

// #v(6pt)
// #block(width: 100%, inset: 6pt, radius: 3pt, stroke: 0.6pt + luma(160))[
//   *Every newsvendor quantity is one of these areas* (colours as above):
//   #grid(columns: (1fr, 1fr), gutter: 6pt,
//     [
//       - $z = Phi^(-1)("CR")$, #h(0.3em) $Q = mu + z sigma$
//       - In-stock prob $= Phi(z)$ (green in ①)
//       - Stockout prob $= 1 - Phi(z)$ (red in ①)
//       - #text(fill: c-short.darken(20%))[$E["short"] = sigma L(z)$]
//     ],
//     [
//       - #text(fill: c-sold.darken(20%))[$E["sales"] = mu - E["short"]$]
//       - #text(fill: c-left.darken(20%))[$E["leftover"] = Q - E["sales"]$]
//       - Fill rate $= E["sales"] / mu$
//       - $E[pi] = p E["sales"] + s E["leftover"] - c Q$
//     ],
//   )
//   *Check:* green − red ③ $= z$, i.e. $E["leftover"] - E["short"] = Q - mu$.
//   #if MU != none and SD != none [
//     #linebreak()
//     With $mu = #MU$, $sigma = #SD$: $Q = #calc.round(MU + z * SD, digits: 1)$,
//     $E["short"] = #calc.round(SD * e-short, digits: 1)$,
//     $E["sales"] = #calc.round(MU - SD * e-short, digits: 1)$,
//     $E["leftover"] = #calc.round(SD * e-left, digits: 1)$.
//   ]
// ]