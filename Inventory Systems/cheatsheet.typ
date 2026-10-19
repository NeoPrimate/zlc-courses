// =====================================================================
//  MZ505 Inventory Systems — Ultimate Formula Sheet
//  Scope: EOQ · EPQ · sensitivity · power of two · all-unit discounts ·
//         aggregation · newsvendor · SC contracts · order-up-to
//  Not covered: revenue management, Wagner–Whitin, production wheel,
//  marginal-unit discounts, price as a function of quantity,
//  tailored aggregation, Poisson.
// =====================================================================

#let FS = 8.4pt
#set page(paper: "a4", margin: (x: 0.55cm, y: 0.55cm), columns: 2)
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

#let mod(t) = block(fill: navy, inset: (x: 4pt, y: 2pt), radius: 1.5pt, width: 100%,
  above: 5pt, below: 2.5pt, sticky: true,
  text(fill: white, weight: "bold", size: FS + 1.2pt, t))
#let sub(t) = block(above: 4pt, below: 2pt, sticky: true,
  text(fill: navy, weight: "bold", size: FS + 0.4pt, t))
#let vars(b) = block(fill: rgb("#eaf0f8"), inset: 2.5pt, width: 100%, radius: 1.5pt,
  above: 2pt, below: 2.5pt, text(size: FS - 0.6pt)[*Variables:* #b])
#let teo(b) = block(fill: rgb("#eef6ee"), inset: 2.5pt, width: 100%, radius: 1.5pt,
  above: 2pt, below: 2.5pt, text(size: FS - 0.6pt, b))
#let nota(b) = block(fill: rgb("#fdf1d8"), inset: 2.5pt, width: 100%, radius: 1.5pt,
  above: 2.5pt, below: 2.5pt, text(size: FS - 0.6pt, b))
#let key(b) = block(stroke: 0.7pt + navy, inset: 3pt, width: 100%, radius: 1.5pt,
  above: 3pt, below: 3pt, b)
#let hd(..xs) = xs.pos().map(x => text(weight: "bold", x))

#place(top, scope: "parent", float: true, block(width: 100%, below: 1pt)[
  #align(center)[#text(size: 11pt, weight: "bold", fill: navy)[MZ505 Inventory Systems — Formula Sheet]]
])

// =====================================================================

#mod[1 · EOQ and EPQ]
#vars[$D$ demand rate · $S$ cost per order/setup · $C$ unit cost · $p$ selling price · $i$ holding rate (%/yr) · $H = i C$ holding cost per unit per year · $Q$ lot size · $P$ production rate ($P > D$) · $L$ lead time · $T$ cycle · $n$ orders (runs) per year · $T_p$ uptime · $T_d$ downtime · TVC total variable cost/yr · TC total cost/yr · $pi$ profit/yr.]
#teo[*EOQ assumptions:* demand & lead time known and constant; instantaneous receipt; constant price; holding on average inventory; constant order cost; no backorders. Trade-off: ordering (economies of scale) vs. holding. *EPQ:* production at $P$ while demand consumes at $D$ → stock rises at $P - D$, never reaches $Q$. EPQ $>$ EOQ; $P -> infinity$ gives EOQ. Changes vs. EOQ in #mc[red].]
#[
#set text(size: FS - 0.3pt)
#table(
  columns: (auto, 1fr, 1.25fr),
  align: (left, center, center),
  fill: (x, y) => if y == 0 { rgb("#eaf0f8") },
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
+ Cost ratio $r = 1/2 (T^* /T + T/T^*) <= 1/2 (sqrt(2) + 1/sqrt(2)) = 1.0607$ → at most +6.1%.
+ Lot $Q = D T$; % increase $= (r - 1) times 100$.
#nota[Table trick: list $k$, $2^k$, "in range?" and tick the single yes. With several products, each gets its own $2^(k_i)$ on a common base → they synchronize.]

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
  fill: (x, y) => if y == 0 { rgb("#eaf0f8") },
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
  [In-stock (Type I SL)], $P(D <= Q) = Phi(z)$,
  [Stockout prob.], $P(D > Q) = 1 - Phi(z)$,
  [$E["short"]$ (lost sales)], $E(D - Q)^+ = sigma L(z), quad L(z) = phi(z) - z(1 - Phi(z))$,
  [$E["sales"]$], $mu - E["short"]$,
  [$E["left"]$], $Q - E["sales"] = Q - mu + E["short"] = sigma (z + L(z))$,
  [Fill rate (Type II)], [$E["sales"]\/mu = 1 - E["short"]\/mu$ (usually > in-stock)],
  [Expected profit], $pi = p E["sales"] + s E["left"] - g E["short"] - c Q$,
  [ ], $= (p - c) mu - C_u E["short"] - C_o E["left"]$,
  [Max profit], $pi(Q^*) = (p - c) mu - (C_u + C_o) phi(z^*) sigma$,
)
]
#sub[Mismatch cost and the value of cutting $sigma$]
#key[
$ C(Q) = C_u E["short"] + C_o E["left"] quad quad C(Q^*) = (C_u + C_o) phi(z^*) thin sigma $
$ sigma -> (1 - theta) sigma: quad Delta pi^* = theta (C_u + C_o) phi(z^*) thin sigma $
]
- Why: $E["left"] = sigma(z^* + L(z^*))$ and $1 - Phi(z^*) = C_o\/(C_u + C_o)$ → $C(Q^*) = sigma[(C_u + C_o) L(z^*) + C_o z^*] = (C_u + C_o) phi(z^*) sigma$.
- $alpha$, $z^*$ do not depend on $sigma$ → $pi^*$ is *linear decreasing* in $sigma$. $theta (C_u + C_o) phi(z^*) sigma$ = max to pay for a forecast tool / quick-response that cuts $sigma$ by $theta$ (recompute $phi(z^*)$ if $C_u$, $C_o$ change, e.g. 2nd supplier).
- *Target in-stock* $alpha$: $Q = mu + Phi^(-1)(alpha) sigma$. *Target fill rate* FR: $E["short"] = (1 - "FR") mu$ → $L(z) = E["short"]\/sigma$ → $z$ (larger one; $L$ falls with $z$) → $Q$.
- *Discrete demand table:* $Q^* =$ smallest $Q$ with $F(Q) >= alpha$ (cumulate probabilities). $E["short"] = sum_(d > Q) (d - Q) P(d)$; then the same chain.
#sub[Variants]
- *Goodwill:* $C_u = p - c + g$ and $- g E["short"]$ in $pi$. Compare scenarios with the same $g$.
- *2nd (emergency) supplier* at $c_P$ after demand ($c < c_P < p$): $C_u = c_P - c$, $C_o = c - s$. $pi = p mu + s E["left"] - c_P E["short"] - c Q$. Max fee for the option $= pi_"with" - pi_"without"$.
- *Fixed order cost* $K$: $Q^*$ unchanged; profit $pi(Q^*) - K$; order only if $> 0$ (max $K = pi(Q^*)$).
- *Sensitivity:* $s arrow.t => C_o arrow.b => Q^* arrow.t$ · $g arrow.t$ or $p arrow.t => Q^* arrow.t$ · $c arrow.t => Q^* arrow.b$ · $sigma arrow.t$: $Q^* arrow.t$ if $z^* > 0$, $arrow.b$ if $z^* < 0$; $pi^* arrow.b$ always.

// =====================================================================
#mod[7 · Supply-chain contracts (double marginalization)]
#vars[$c$ supplier's production cost · $w$ wholesale price · $p$, $s$, $g$ retailer's price, salvage, goodwill · $b$ buy-back price per return · $r$ cost per return (shipping) · $v$ supplier's salvage per returned unit (0 if scrapped) · $pi_R$, $pi_S$, $pi_"SC"$.]
#teo[Each firm decides with its own margin → retailer uses $C_u = p - w < p - c$, $C_o = w - s > c - s$ → orders *less* than the SC optimum. Contracts shift risk/margin to coordinate. Every profit uses the same chain: $Q -> z -> L(z) -> E["short"] -> E["sales"] -> E["left"]$. *Order:* solve the retailer first (its $Q$, $E["left"]$), then plug them into $pi_S$.]
#[
#set text(size: FS - 0.3pt)
#table(
  columns: (auto, 1fr),
  fill: (x, y) => if y == 0 { rgb("#eaf0f8") },
  ..hd[Contract], [Critical ratio and profits],
  [Wholesale], [$C_u = p - w + g$, $C_o = w - s$ → $Q_R$ \
    $pi_R = p E["sales"] + s E["left"] - g E["short"] - w Q$; #h(3pt) $pi_S = (w - c) Q$],
  [Integrated SC], [$C_u = p - c + g$, $C_o = c - s$ ($w$ cancels) → larger $Q$ \
    $pi_"SC" = p E["sales"] + s E["left"] - g E["short"] - c Q$],
  [Buy-back], [$C_u = p - w$, $C_o = w - b + r$, #h(3pt) $alpha_R = (p - w)\/(p - b + r)$ \
    $pi_R = p E["sales"] + (b - r) E["left"] - w Q$ \
    $pi_S = (w - c) Q - (b - v) E["left"]$],
)
]
- Loss from double marginalization $= pi_"SC"^"int" - (pi_R + pi_S)_"wholesale"$.
- *Coordinate:* set the retailer's ratio equal to the SC ratio:
#key[
$ (p - w)/(p - b + r) = (p - c)/(p - s) $
$ "given " w: quad b^* = p + r - ((p - w)(p - s))/(p - c) $
$ "given " b: quad w^* = p - ((p - c)(p - b + r))/(p - s) $
]
- Buy-back % $= b \/ w$. Feasible: $b < w$ (no profit from ordering to return) and $b - r > s$ (returning beats salvaging), i.e. $s + r < b < w$.
#sub[Buy-back: who salvages, who ships?]
Rule: retailer's $C_o = w - R$, $R$ = what the retailer recovers per leftover. Coordinating recovery $R^* = p - (p - w)(p - s)\/(p - c)$, then solve $b$ from $R^*$.
#[
#set text(size: FS - 0.9pt)
#table(
  columns: (auto, 1fr, 1fr, 1fr),
  fill: (x, y) => if y == 0 { rgb("#eaf0f8") },
  ..hd[], [(a) Returned · supplier salvages $v$ · retailer ships], [(b) Returned · supplier salvages $v$ · supplier ships], [(c) No return · retailer salvages $s$ · supplier credits $b$],
  [Retailer recovers], $b - r$, $b$, $b + s$,
  [$C_o^R$], $w - b + r$, $w - b$, $w - b - s$,
  [$b^*$], $R^* + r$, $R^*$, $R^* - s$,
  [$pi_R$ leftover], $+(b - r) E["left"]$, $+b E["left"]$, $+(b + s) E["left"]$,
  [$pi_S$], $(w - c) Q - (b - v) E["left"]$, $(w - c) Q - (b + r - v) E["left"]$, $(w - c) Q - b E["left"]$,
  [SC per leftover], $v - r$, $v - r$, $s$,
  [Feasible], $s + r < b < w$, $s < b < w$, $0 < b < w - s$,
)
]
- $pi_R + pi_S = p E["sales"] + ("SC per leftover") E["left"] - c Q$. Equals integrated $pi_"SC"$ (with $s$) only if that value $= s$: in (a)/(b) need $v - r = s$, so with $v = s$ the SC is slightly below integrated (shipping $r$ is wasted). (c) coordinates *exactly* (no shipping). Exact coordination for (a)/(b): use $s_"SC" = v - r$ in $(p - c)\/(p - s_"SC")$.
- Who pays $r$ does not change $pi_"SC"$, only how it is split ($b$ shifts by $r$).
- Accepted only if *both* $pi_R$ and $pi_S$ beat their wholesale-contract values.
#nota[Buy-back drawbacks: needs reverse logistics, admin cost, may push retailer to over-stock low-value items. Other coordinating contracts: *revenue sharing* (low $w$ + share of revenue), *quantity flexibility* (full refund up to a return quota), *quantity discounts* (induce larger orders). With goodwill, add $+g$ to every $C_u$ and to both denominators.]

// =====================================================================
#mod[8 · Order-up-to (periodic review, backorders)]
#vars[$L$ lead time (periods) · $T$ review period ($T = 1$ default) · $mu$, $sigma$ demand per period · $D_(L+1)$ demand over $L + 1$ periods · $S$ order-up-to (base-stock) level · $alpha$ target in-stock · $h$ holding/unit/period · $b$ backorder penalty/unit · $N$ periods · $K$ cost per order.]
#teo[Long-life product, stationary random demand, unlimited replenishments, backorders. Each period: order → the order from $L$ periods ago arrives → demand. *Inventory level* $=$ on-hand $-$ backorder; *inventory position* $=$ level $+$ on-order $= S$ right after ordering. Order $= S -$ position $=$ last period's demand (one-for-one, pull). Level at end of period $= S - D_(L+1)$.]
#key[
$ mu_(L+1) = (L + 1) mu quad quad sigma_(L+1) = sqrt(L + 1) thin sigma quad ("periods independent") $
$ S = mu_(L+1) + z sigma_(L+1), quad z = Phi^(-1)(alpha) quad "or cost-based: " alpha = C_u/(C_u + C_o) = b/(b + h) $
]
#[
#set text(size: FS - 0.3pt)
#table(
  columns: (auto, 1fr),
  [Given $S$], [$z = (S - mu_(L+1)) \/ sigma_(L+1)$ (recompute with the *rounded* $S$)],
  [In-stock], [$P(D_(L+1) <= S) = Phi(z)$; stockout $= 1 - Phi(z)$],
  [$E["backorder"]$], [$sigma_(L+1) L(z)$ (≈ newsvendor lost sales)],
  [$E["on-hand"]$ = SS], $S - mu_(L+1) + E["BO"] = sigma_(L+1) (phi(z) + z Phi(z))$,
  [$E["on-order"]$], [$L mu$ (Little's law; uses $L$, not $L + 1$; indep. of $sigma$)],
  [Fill rate], [$1 - E["BO"] \/ mu$ (one period's demand, not $mu_(L+1)$)],
  [Cycle inventory], $mu\/2$,
  [Days of supply], $E["on-hand"]\/mu = sqrt(L + 1) thin sigma/mu (phi(z) + z Phi(z))$,
  [Stockouts in $N$], [$N (1 - alpha)$; periods until the 1st $= 1\/(1 - alpha)$],
)
]
- *Target fill rate* FR: $E["BO"] = (1 - "FR") mu$ → $L(z) = E["BO"] \/ sigma_(L+1)$ → $z$ (larger) → $S$.
- $h$ in $b\/(b + h)$ must be *per period* (annual $h$ → $h\/52$ for weeks). Optimal in-stock is usually high ($b >> h$).
- Safety-stock drivers: lead time, variability $sigma\/mu$, service level. $L arrow.b => mu_(L+1), sigma_(L+1), S$, on-order and SS $arrow.b$ (strongest at high $alpha$).
#sub[General review period $T$ (replace $L + 1$ by $L + T$)]
#key[
$ mu_(L+T) = (L + T) mu quad sigma_(L+T) = sqrt(L + T) thin sigma quad S = mu_(L+T) + z sigma_(L+T) $
$ E["BO"] = sigma_(L+T) L(z) quad "SS" = S - mu_(L+T) + E["BO"] approx z sigma_(L+T) $
]
- Cycle inventory $= mu T \/ 2$ · average inventory $= "SS" + mu T\/2$ · pipeline $= L mu$ · fill rate $= 1 - E["BO"]\/(mu T)$.
- Days of cover: SS$\/mu$ and cycle $T\/2$. $quad$ Orders/yr $n = (1 - P(D_T = 0)) \/ T_"yr"$ ($= 1\/T_"yr"$ for normal demand).
- *Annual cost* $=$ avg. inventory $times H$ ($+ L mu H$ if the firm owns goods in transit) $+ n K$ ($+$ transport/unit $times D$).
- *Choosing $T$:* lowest ordering + holding cost. $T arrow.t$ → fewer orders, more SS and cycle stock (EOQ-like trade-off). Keep all costs in the same time unit.
