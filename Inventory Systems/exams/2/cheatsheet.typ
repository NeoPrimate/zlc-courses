// MZ 505 Inventory Systems — Exam cheatsheet (self-contained sections)
// Each section defines every symbol it uses in its "Notation" table and lists every formula it needs.
// Compile: typst compile cheatsheet.typ   (2 pages, A4) — z / L(z) tables kept on a separate sheet

#set document(title: "MZ 505 Inventory Systems — Cheatsheet")
#set page(paper: "a4", margin: (x: 0.45cm, y: 0.45cm), columns: 3)
#set columns(gutter: 0.25cm)
#set text(size: 7.6pt, font: ("Helvetica Neue", "Carlito", "Calibri", "Inter", "Arial"), lang: "en")
#set par(leading: 0.3em, spacing: 0.35em, justify: false)
#set table(inset: (x: 1.8pt, y: 1.3pt), stroke: 0.3pt + luma(170), align: left + horizon)
#show table: set par(leading: 0.22em)
#show table: it => block(above: 2pt, below: 2.5pt, it)
#show math.equation: set text(size: 7.8pt)

#let navy = rgb("#1f4e79")
#let teal = rgb("#0f766e")
#show heading.where(level: 1): it => block(
  width: 100%, fill: navy, inset: (x: 3pt, y: 1.8pt), above: 3pt, below: 2pt, radius: 1.5pt,
  text(fill: white, weight: "bold", size: 8.3pt, it.body),
)
#show heading.where(level: 2): it => block(
  above: 3pt, below: 1.2pt,
  text(fill: teal, weight: "bold", size: 7.6pt, it.body),
)
#let hdr(..cells) = cells.pos().map(c => table.cell(fill: navy.lighten(82%), text(weight: "bold", c)))
#let st(n, body) = table.cell(fill: navy.lighten(88%))[*#n* #body]
#let wide(n, body) = table.cell(colspan: n, body)
// notation table: pairs of (symbol, meaning), two pairs per row
#let notation(..cells) = table(columns: (auto, 1fr, auto, 1fr),
  fill: (x, y) => if calc.even(x) { rgb("#fff7e0") },
  ..cells.pos())

// =====================================================================
= 1 · Periodic review: OUT & (s, S)

== Notation
#notation(
  [$mu$, $sigma$], [mean, st. dev. of demand per period], [$T$], [review period (periods between orders)],
  [$L$], [lead time (periods)], [$overline(L)$, $s_L$], [mean, st. dev. of a random $L$],
  [$tau$], [protection interval $= T + L$], [$mu_tau$, $sigma_tau$], [mean, st. dev. of demand over $tau$],
  [$N$], [periods per year], [$D$], [annual demand $= N mu$],
  [$S$], [order-up-to level], [$s$], [reorder level of (s, S)],
  [$alpha$], [target in-stock prob. per review (CSL)], [$z$], [safety factor (std. normal quantile)],
  [$Phi$, $phi$], [std. normal CDF, pdf], [$L(z)$], [std. normal loss function],
  [$F$], [CDF of demand], [$overline(I)$], [average inventory],
  [$K$], [fixed cost per order], [$c$], [unit cost],
  [$i$], [holding rate (% of $c$ per year)], [$H$], [holding /unit/yr $= i c$],
  [$h$], [holding /unit/period $= H\/N$], [$b$], [cost per unit backordered (per occurrence)],
  [$b'$], [backorder cost /unit/period], [$n$], [periods covered by one EOQ],
  [$p$, $v$, $g$], [price, salvage value, goodwill loss /unit], [$C_u$, $C_o$], [underage, overage cost /unit],
  [$pi(y)$], [expected profit when stocking $y$], [$D_(t-1)$], [demand in the previous period],
)

== Formulas used
#table(columns: (auto, 1fr),
  table.header(..hdr[Item][Formula, Excel / Python]),
  [$z$ from $alpha$], [$z = Phi^(-1)(alpha)$: `NORM.S.INV(α)` / `norm.ppf(α)`],
  [$Phi$, $phi$], [`NORM.S.DIST(z,1)` / `norm.cdf(z)` \ `NORM.S.DIST(z,0)` / `norm.pdf(z)`],
  [$L(z)$], [$phi(z) - z(1 - Phi(z))$ \ $z$ from $L$: loss table],
  [Over $t$ periods], [mean $mu t$, st. dev. $sigma sqrt(t)$ (iid periods)],
  [$alpha$ (target)], [given CSL \ $b'\/(b' + h)$ \ newsvendor $C_u\/(C_u + C_o)$, $C_u = p - c + g$, $C_o = c - v$],
  [EOQ], [$sqrt(2 K D \/ H)$],
  [IL, IP], [IL $=$ OH $-$ BO \ IP $=$ IL $+$ OO \ BO $> 0$ ⇒ OH $= 0$; OH $> 0$ ⇒ BO $= 0$ \ OUT: IP is exactly $S$ (right after order)],
  [OUT events], [① review IP ② order up to $S$ ③ receive order placed $L$ ago ④ demand],
  [IP trap], [IP before ordering $= S - D_(t-1)$; IP alone can't split BO vs. OO],
  [Pipeline], [average OO $= mu L$ (Little's law)],
)

== OUT $(T, S)$ = newsvendor every $T$ + backorders + lead time
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Formula]),
  st(0)[Units], wide(2)[$mu$, $sigma$, $T$, $L$ in the same period; $N$ periods/yr],
  st(1)[$T$], wide(2)[given (or $T approx "EOQ"\/mu$ periods)],
  table.cell(rowspan: 2, st(2)[$mu_tau$, $sigma_tau$]),
    [$L$ fixed], [$mu_tau = mu(T + L)$ \ $sigma_tau = sigma sqrt(T + L)$],
    [$L$ random], [$mu_tau = mu(T + overline(L))$ \ $sigma_tau = sqrt((T + overline(L)) sigma^2 + mu^2 s_L^2)$],
  st(3)[$S$], wide(2)[$z = Phi^(-1)(alpha)$ \ $S = mu_tau + z sigma_tau$ \ SS $= S - mu_tau = z sigma_tau$],
  st(4)[Given $S$], wide(2)[$z = (S - mu_tau)\/sigma_tau$ → CSL $= Phi(z)$],
  st(5)[E[back]], wide(2)[$sigma_tau L(z)$ per review],
  st(6)[KPIs], wide(2)[FR $= 1 - E["back"]\/(mu T)$ \ $overline(I) = mu T\/2 + "SS"$ \ end-of-period on-hand $= S - mu_tau + E["back"]$],
  st(7)[Policy], wide(2)[every $T$: order $S - "IP"$ (= demand since last review)],
  st(8)[Cost/yr], wide(2)[$K N\/T + H overline(I) + b E["back"] N\/T$],
)

== (s, S) = OUT + fixed order cost $K$
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Formula]),
  st(0)[Units], wide(2)[$mu$, $sigma$ per review period; $L$ in periods; $D$, $H$ per year],
  st(1)[$alpha$], wide(2)[CSL, $b'\/(b'+h)$ or $C_u\/(C_u+C_o)$ → $z = Phi^(-1)(alpha)$],
  table.cell(rowspan: 2, st(2)[Setting]),
    [single period], [$F(S) = alpha$ \ $s$ solves $pi(s) = pi(S) - K$ → *stop*],
    [multi-period], [heuristic, steps 3–6],
  st(3)[EOQ], wide(2)[$"EOQ" = sqrt(2 K D\/H)$ \ $n = "EOQ"\/mu$],
  table.cell(rowspan: 2, st(4)[Model]),
    [$n <= 1$], [order every period → OUT ($s = S$)],
    [$n > 1$], [*(s, S)* → steps 5–6],
  table.cell(rowspan: 2, st(5)[$s$]),
    [$L = 0$ (slides)], [1 period: $s = mu + z sigma$],
    [$L > 0$ #super[†]], [$s = (L+1)mu + z sigma sqrt(L+1)$],
  table.cell(rowspan: 2, st(6)[$S$]),
    [$L = 0$ (slides)], [$n$ periods: $S = n mu + z sigma sqrt(n)$],
    [$L > 0$ #super[†]], [$S = (n+L)mu + z sigma sqrt(n+L)$],
  st(7)[Policy], wide(2)[each review: IP $< s$ → order $S - "IP"$, else nothing],
)
#text(size: 0.85em)[#super[†] extension of slide heuristic \ Scarf (1960): (s, S) optimal (stationary demand, linear costs, zero lead time) \ ↑$T$: ↓ordering, ↑cycle stock, ↑SS]

// =====================================================================
= 2 · Continuous review (R, Q) & choosing a policy

== Notation
#notation(
  [$mu$, $sigma$], [mean, st. dev. of demand per period], [$D$], [annual demand $= N mu$],
  [$N$], [periods per year], [$L$], [lead time (periods)],
  [$overline(L)$, $s_L$], [mean, st. dev. of a random $L$], [$mu_L$, $sigma_L$], [mean, st. dev. of demand over $L$],
  [$Q$], [order quantity], [$R$], [reorder point (on IP)],
  [$K$], [fixed cost per order], [$c$], [unit cost],
  [$i$], [holding rate (% of $c$ per year)], [$H$], [holding /unit/yr $= i c$],
  [$b$], [shortage cost per unit short], [$alpha$], [target in-stock prob. per cycle (CSL)],
  [$z$], [safety factor], [$Phi$, $phi$], [std. normal CDF, pdf],
  [$L(z)$], [std. normal loss function], [$n(R)$], [expected units short per cycle],
  [$overline(I)$], [average inventory], [$beta$], [fill rate (FR), share of units served],
  [$T$], [review period (periodic comparison)], [$a$, $b_u$], [bounds of a uniform demand],
  [$x$], [stock level being evaluated],
)

== Formulas used
#table(columns: (auto, 1fr),
  table.header(..hdr[Item][Formula, Excel / Python]),
  [$z$ from $alpha$], [$z = Phi^(-1)(alpha)$: `NORM.S.INV(α)` / `norm.ppf(α)` \ $R$ directly: `NORM.INV(α, μL, σL)`],
  [$Phi$, $phi$], [`NORM.S.DIST(z,1)` / `norm.cdf(z)` \ `NORM.S.DIST(z,0)` / `norm.pdf(z)`],
  [$L(z)$], [$phi(z) - z(1 - Phi(z))$ \ $z$ from $L$: loss table],
  [Uniform $[a, b_u]$], [$F(x) = (x - a)\/(b_u - a)$ \ E[short] $= (b_u - x)^2\/(2(b_u - a))$],
  [Over $t$ periods], [mean $mu t$, st. dev. $sigma sqrt(t)$ (iid periods)],
  [EOQ], [$Q^* = sqrt(2 K D\/H)$ \ total cost $= K D\/Q + H Q\/2 + c D$ \ orders/yr $D\/Q$],
  [$alpha$ (target)], [given CSL \ backorders: $1 - H Q\/(b D)$ \ lost sales: $b D\/(b D + H Q)$ \ fill-rate target $beta$: $L(z) = (1 - beta) Q\/sigma_L$ → $z$],
)

== (R, Q) = EOQ for $Q$ + newsvendor over $L$ for $R$
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Formula]),
  st(0)[Units], wide(2)[$mu$, $sigma$, $L$ in the same period \ $D$, $H$ per year],
  table.cell(rowspan: 2, st(1)[$Q$]),
    [heuristic], [$Q = "EOQ" = sqrt(2 K D\/H)$ (or given)],
    [exact ($b$)], [iterate: $alpha = 1 - H Q\/(b D)$ → $z$ → $n(R)$ → $Q = sqrt(2 D(K + b n(R))\/H)$],
  table.cell(rowspan: 2, st(2)[$mu_L$, $sigma_L$]),
    [$L$ fixed], [$mu_L = mu L$ \ $sigma_L = sigma sqrt(L)$],
    [$L$ random], [$mu_L = mu overline(L)$ \ $sigma_L = sqrt(overline(L) sigma^2 + mu^2 s_L^2)$],
  st(3)[$R$], wide(2)[$z = Phi^(-1)(alpha)$ \ $R = mu_L + z sigma_L$ \ SS $= R - mu_L = z sigma_L$],
  st(4)[Given $R$], wide(2)[$z = (R - mu_L)\/sigma_L$ → CSL $= Phi(z)$],
  st(5)[$n(R)$], wide(2)[$sigma_L L(z)$ (uniform: formula above)],
  st(6)[KPIs], wide(2)[FR $= 1 - n(R)\/Q$ \ $overline(I) = Q\/2 + "SS"$],
  st(7)[Policy], wide(2)[when IP $<= R$ → order $Q$],
  st(8)[Cost/yr], wide(2)[$K D\/Q + H overline(I) + b n(R) D\/Q$ (+ $c D$)],
)

== Service measures
#table(columns: (auto, 1fr),
  table.header(..hdr[Measure][Rule]),
  [CSL (Type I)], [P(demand over $L$ $<= R$) = cycles without SO / all cycles],
  [FR (Type II)], [$1 - n(R)\/Q$ = units served / units demanded],
  [Stockouts], [P(SO)/cycle $= 1 - "CSL"$ \ SO cycles/yr $= (1 - "CSL") D\/Q$ \ units short/yr $= n(R) D\/Q$],
  [FR vs. CSL], [usually FR > CSL (an SO cycle still serves most of $Q$) \ CSL > FR if shortages are large vs. $Q$],
  [Levers], [↑$R$: ↑CSL, ↑FR, ↑SS \ ↑$Q$: same CSL, ↑FR \ ↑$sigma$, $L$, $s_L$: ↑$R$, ↑SS],
)

== Periodic (OUT) vs. continuous (R, Q)
#table(columns: (auto, 1fr, 1fr),
  table.header(..hdr[][Periodic (OUT)][Continuous (R, Q)]),
  [SS covers], [$T + L$ → *more SS*], [$L$ only],
  [Qty / timing], [variable / fixed], [fixed / random],
  [Cycle stock], [$mu T\/2$], [$Q\/2$],
  [Orders / yr], [$N\/T$], [$D\/Q$],
  [Pros], [convenient \ combine orders], [fixed lots (discounts) \ less SS],
  [Cons], [more SS], [monitoring cost \ random timing],
)

== Which model? (level $= mu + z sigma$ over the interval it covers)
#table(columns: (1fr, auto, auto),
  table.header(..hdr[Situation][Model][Covers]),
  [Deterministic demand], [EOQ], [—],
  [Random, one shot (no replenishment)], [newsvendor], [1 season],
  [Random, trigger = time, no $K$], [OUT], [$T + L$],
  [Random, trigger = time, fixed $K$], [(s, S)], [§1],
  [Random, trigger = inventory level], [(R, Q)], [$L$],
)

// =====================================================================
= 3 · Risk pooling

== Notation
#notation(
  [$i$, $j$], [index of site / product / variant], [$n$], [number of items pooled],
  [$mu_i$, $sigma_i$], [mean, st. dev. of demand per period of $i$], [$rho_(i j)$, $rho$], [correlation of demands],
  [$a ⊕ b$], [$sqrt(a^2 + b^2 + 2 rho a b)$ (pooled st. dev.)], [$X_P$], [pooled quantity (e.g. $mu_P$, $sigma_P$, $Q_P$, $D_P$)],
  [$T$, $L$], [review period, lead time (periods)], [$tau$], [protection interval: periodic $T + L$, continuous $L$],
  [$D_tau$], [demand over $tau$], [$alpha$], [target in-stock prob. (CSL)],
  [$z$], [safety factor $= Phi^(-1)(alpha)$], [$Phi$, $phi$], [std. normal CDF, pdf],
  [$L(z)$], [std. normal loss function], [$overline(I)$], [average inventory $=$ SS $+$ cycle stock],
  [$Q$], [order quantity (EOQ)], [$K$], [fixed cost per order],
  [$D$], [annual demand], [$H$, $h$], [holding /unit/yr, /unit/period],
  [$N$], [periods per year], [$p$, $c$, $v$], [price, unit cost, salvage value],
  [$C_u$, $C_o$], [underage $p - c$, overage $c - v$], [$pi$], [expected profit],
  [$m$], [number of stores], [$mu_s$, $sigma_s$], [store demand per period],
  [$L_1$, $L_2$], [LT supplier→DC, DC→store],
)

== Formulas used
#table(columns: (auto, 1fr),
  table.header(..hdr[Item][Formula]),
  [Pooled mean], [$mu_P = sum mu_i$ (always)],
  [Pooled st. dev.], [$sigma_P = sqrt(sum sigma_i^2 + 2 sum_(i<j) rho_(i j) sigma_i sigma_j)$ \ two: $sigma_1 ⊕ sigma_2$],
  [Special cases], [indep.: $sqrt(sum sigma_i^2)$ \ iid: $sigma sqrt(n)$ \ $rho = +1$: $sum sigma_i$ (*no gain*) \ $rho = -1$: $|sigma_1 - sigma_2|$ (*max gain*)],
  [CV, 2 identical], [$"CV"_P = sqrt((1 + rho)\/2) "CV"$ (indep. → CV$\/sqrt(2)$)],
  [Over $tau$], [$D_tau tilde N(mu tau, sigma sqrt(tau))$ \ SS $= z sigma sqrt(tau)$],
  [$z$, $L(z)$], [$z = Phi^(-1)(alpha)$ (`NORM.S.INV`) \ $L(z) = phi(z) - z(1 - Phi(z))$],
  [EOQ], [$Q = sqrt(2 K D\/H)$],
  [Newsvendor], [$Q = mu + z sigma$, $z = Phi^(-1)(C_u\/(C_u + C_o))$ \ lost $= sigma L(z)$ \ sales $= mu -$ lost \ left $= Q -$ sales \ $pi = p "sales" + v "left" - c Q$ \ max $pi = (p - c)mu - (C_u + C_o) phi(z) sigma$],
  [Gain], [SS falls by $z sqrt(tau)(sum sigma_i - sigma_P)$ \ pipeline $mu L$ never changes],
)

== Location pooling: step by step ($n$ sites → 1 DC, same product, continuous $(R, Q)$)
#table(columns: (auto, auto, 1fr, 1fr),
  table.header(..hdr[Step][Item][Decentralized (each site $i$)][Centralized (pool $P$)]),
  st(0)[Inputs], wide(3)[$mu_i$, $sigma_i$, $rho$, $K$, $H$, $L$, CSL, transport rates in / out \
    units: $mu$ (= $D$) and $H$ per *year* → EOQ; $sigma$ and $L$ in the *same period* → SS],
  st(1)[$z$], wide(3)[$z = Phi^(-1)("CSL")$ (`norm.ppf`), same for both],
  table.cell(rowspan: 2, st(2)[Demand]),
    [mean], [$D_i = mu_i$], [$D_P = sum mu_i$],
    [st. dev.], [$sigma_i$], [$sigma_P = sqrt(sum sigma_i^2) + 2 sum_(i<j) rho_(i j) sigma_i sigma_j$],
  st(3)[$Q$], [EOQ], [$Q_i = sqrt(2 K D_i \/ H)$], [$Q_P = sqrt(2 K D_P \/ H)$],
  st(4)[SS], [$z sigma sqrt(L)$], [$"SS"_i = z sigma_i sqrt(L)$], [$"SS"_P = z sigma_P sqrt(L)$],
  st(5)[Cycle], [$Q\/2$], [$Q_i \/ 2$], [$Q_P \/ 2$],
  st(6)[$overline(I)$], [SS + cycle], [$overline(I)_i = "SS"_i + Q_i\/2$], [$overline(I)_P = "SS"_P + Q_P\/2$],
  table.cell(rowspan: 3, st(7)[Cost/yr]),
    [holding], [$H sum overline(I)_i$], [$H overline(I)_P$],
    [ordering], [$sum K D_i \/ Q_i$], [$K D_P \/ Q_P$],
    [transport], [$sum mu_i ("in"_i + "out"_i)$], [$"in"_P D_P + sum "out"_(P i) mu_i$],
  st(8)[TC], [sum], [$"TC"_"dec"$ = hold + order + transp.], [$"TC"_"cen"$ = hold + order + transp.],
  st(9)[Compare], wide(3)[saving $= "TC"_"dec" - "TC"_"cen"$ \
    holding ↓ (SS *and* cycle fall), ordering ↓ (one stock), transport usually ↑ \
    iid check: $"SS"_P \/ sum "SS"_i = 1\/sqrt(n)$, $Q_P \/ sum Q_i = 1\/sqrt(n)$],
)
#text(size: 0.85em)[*Periodic (OUT) instead:* SS uses $sqrt(T + L)$ · cycle $mu T\/2$ (cen. *unchanged*, $mu_P T\/2 = sum mu_i T\/2$) · ordering $K N\/T$ per stock.]

== Location pooling worksheet (products A, B × regions 1, 2)
#text(size: 0.85em)[pool the *same product* across regions \ cycle stock $= mu T\/2$ (periodic) or $Q\/2$ (continuous)]
#let grid4(f) = table(columns: (auto, 1fr, 1fr), align: center + horizon,
  table.header(..hdr[][A][B]),
  [*1*], f("A1"), f("B1"),
  [*2*], f("A2"), f("B2"),
)
#let grid2(f) = table(columns: (1fr, 1fr), align: center + horizon,
  table.header(..hdr[A][B]),
  f("A"), f("B"),
)
*(a) Decentralized — one stock per region / product*

$D_tau tilde N(mu tau, sigma sqrt(tau))$
#grid4(k => $N(mu_#k tau, sigma_#k sqrt(tau))$)
$"SS" = z sigma sqrt(tau)$
#grid4(k => $z sigma_#k sqrt(tau)$)
$overline(I) = "SS" + "cycle stock"$
#grid4(k => $"SS"_#k + mu_#k T\/2$)
- Holding $= h dot sum overline(I) dot N$ \ Transport $= sum mu dot N dot ("in" + "out")$ \ Total $=$ holding + transport (+ $K N\/T$ per stock)

*(b) Centralized — one stock per product*

Combined demand per period: $N(mu_1 + mu_2, sigma_1 ⊕ sigma_2)$
#grid2(k => if k == "A" { $N(mu_(A 1) + mu_(A 2), sigma_(A 1) ⊕ sigma_(A 2))$ } else { $N(mu_(B 1) + mu_(B 2), sigma_(B 1) ⊕ sigma_(B 2))$ })
$D_tau tilde N(mu tau, sigma sqrt(tau))$
#grid2(k => $N(mu_#k tau, sigma_#k sqrt(tau))$)
$"SS" = z sigma sqrt(tau)$
#grid2(k => $z sigma_#k sqrt(tau)$)
$overline(I) = "SS" + "cycle stock"$
#grid2(k => $"SS"_#k + mu_#k T\/2$)
- Holding and transport as in (a), with the new in / out rates \ Saving $=$ total (a) $-$ total (b) \ only SS falls (periodic cycle stock unchanged)
- Pooling *products* too (universal design / substitutes): combine A + B the same way; both → one stock

== Product pooling ($n$ versions → 1 universal / substitute)
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Do]),
  st(1)[Data], wide(2)[$mu_i$, $sigma_i$, $rho$ per version \ only if one item can serve all demands],
  table.cell(rowspan: 3, st(2)[Setting]),
    [single period], [newsvendor: $z = Phi^(-1)(C_u\/(C_u + C_o))$],
    [periodic], [replenished: $z = Phi^(-1)("CSL")$, $tau = T + L$],
    [continuous], [replenished: $z = Phi^(-1)("CSL")$, $tau = L$],
  st(3)[Pooled], wide(2)[$mu_P = sum mu_i$ \ $sigma_P$ from formulas above],
  table.cell(rowspan: 2, st(4)[Stock]),
    [single period], [separate $Q_i = mu_i + z sigma_i$ \ pooled $Q_P = mu_P + z sigma_P$],
    [repl.], [separate $"SS"_i = z sigma_i sqrt(tau)$ \ pooled $"SS"_P = z sigma_P sqrt(tau)$],
  table.cell(rowspan: 2, st(5)[Evaluate]),
    [single period], [newsvendor lost / sales / left / $pi$ for each case],
    [repl.], [holding cost of $overline(I)$ as in location pooling],
  st(6)[Compare], wide(2)[↓stock $z(sum sigma_i - sigma_P)$ \ ↑profit $(C_u + C_o) phi(z)(sum sigma_i - sigma_P)$ \ gain → 0 as $rho -> +1$],
  st(7)[Trade-off], wide(2)[pros: SKU rationalization \ cons: lost functionality / segmentation, ↑unit cost \ substitution: *manufacturer-driven* (firm ships substitute) vs. *customer-driven* (customer switches)],
)

== Lead-time pooling: consolidated distribution (via DC)
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Do]),
  st(1)[Data], wide(2)[$m$ stores, $mu_s$, $sigma_s$ per period \ $L_1$ supplier→DC \ $L_2$ DC→store],
  table.cell(rowspan: 2, st(2)[Interval]),
    [periodic], [a stage with LT $L$ covers $T + L$ (slides OUT, $T = 1$: $L + 1$)],
    [continuous], [a stage with LT $L$ covers $L$ (replace $T + L$ by $L$ below)],
  st(3)[Direct], wide(2)[each store over $T + L_1$: on-hand $approx z sigma_s sqrt(T + L_1)$, × $m$],
  st(4)[Stores via DC], wide(2)[each store over $T + L_2$ (short): $z sigma_s sqrt(T + L_2)$, × $m$],
  st(5)[DC demand], wide(2)[$mu_"DC" = m mu_s$ \ $sigma_"DC" = sqrt(m) sigma_s$ (indep.; use given value if correlated)],
  st(6)[DC stock], wide(2)[over $T + L_1$: on-hand $approx z sigma_"DC" sqrt(T + L_1)$ (DC assumed never to stock out)],
  st(7)[Pipeline], wide(2)[extra DC→stores: $m mu_s L_2$ (Little's law)],
  st(8)[Compare], wide(2)[stores + DC + pipeline vs. direct \ benchmark "all at DC" = DC only \ works although total LT ↑ \ best: $L_1$ long, $L_2$ short, $rho$ low \ cons: DC cost, handling],
)

== Delayed differentiation (postponement)
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Do]),
  st(1)[Data], wide(2)[$n$ variants: $mu_i$, $sigma_i$, $rho$ \ LT $L$ of the base product \ customization fast],
  table.cell(rowspan: 2, st(2)[Interval]),
    [periodic], [$tau = T + L$ (slides OUT: $L + 1$)],
    [continuous], [$tau = L$],
  st(3)[No postp.], wide(2)[stock finished variants: SS $= z sqrt(tau) sum sigma_i$],
  st(4)[Generic G], wide(2)[$mu_G = sum mu_i$ \ $sigma_G$ = pooled st. dev. (iid: $sigma sqrt(n)$)],
  st(5)[Postp.], wide(2)[stock generic, customize on order: SS $= z sqrt(tau) sigma_G$],
  st(6)[Compare], wide(2)[saving $z sqrt(tau)(sum sigma_i - sigma_G)$ \ iid: ratio $1\/sqrt(n)$ \ keeps variety],
  st(7)[Use when], wide(2)[variety wanted \ total less uncertain than per variant \ customize late, fast, cheap \ variety part cheap \ may need redesign (Benetton, HP)],
)

== Capacity pooling (flexibility) — no periodic/continuous split
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Do]),
  st(1)[Map], wide(2)[plants ↔ products \ *link* = plant can make product \ *chain* = connected group],
  table.cell(rowspan: 3, st(2)[Design]),
    [dedicated], [$n$ links → no pooling; excess demand lost even if another plant is idle],
    [long chain], [$2n$ links, one closed loop ≈ total flexibility],
    [total flex], [$n^2$ links → max benefit, max cost],
  st(3)[Evaluate], wide(2)[expected sales / utilization \ most valuable when capacity ≈ demand, $rho$ low],
  st(4)[Decide], wide(2)[flexibility cheap → add links \ capacity cheap → add capacity \ one long chain ≫ several short],
)

== Push–pull & decoupling
#table(columns: (auto, 1fr),
  table.header(..hdr[Topic][Rule]),
  [Push–pull], [low unc. + high EoS → push \ high unc. + low EoS → pull \ high + high → push–pull \ short LT: low unc. → continuous replenishment, high → pull \ long LT: low → push, high → inventory positioning],
  [Decoupling], [push side: forecast, aggregate, batches \ pull side: demand-driven, agile \ buffer upstream if variety / uncertainty high, before value-add, before bottlenecks],
)

// =====================================================================
= 4 · Demand forecasting

== Notation
#notation(
  [$t$], [period index], [$k$], [periods ahead (horizon)],
  [$D_t$], [demand in period $t$], [$F_t$], [forecast for $t$, made before $D_t$ is known],
  [$N$], [moving-average window], [$alpha$, $beta$, $gamma$], [smoothing constants (level, trend, season)],
  [$L_t$, $T_t$], [level, trend estimate], [$S_t$], [seasonal factor of period $t$],
  [$p$], [periods per seasonal cycle], [$r$], [number of cycles in the data],
  [$overline(D)_t$], [deseasonalized demand], [$hat(D)_t$], [regression-fitted demand],
  [$overline(S)_t$], [seasonal ratio $D_t\/hat(D)_t$], [$S_i$], [seasonal factor of season $i$],
  [$L$, $T$], [static level, trend (intercept, slope)], [$x$, $y$, $overline(x)$, $overline(y)$], [regressor, response; their means],
  [$a$, $b$], [regression intercept, slope], [$Y$, $X_k$, $b_k$], [response, $k$-th driver, its coefficient],
  [$e_i$], [error $F_i - D_i$ (+ = over-forecast)], [$n$], [number of errors averaged],
  [$overline(e)$], [mean error], [$sigma$], [st. dev. of forecast error],
  [$z$, $Phi$], [safety factor, std. normal CDF], [$h$], [holding cost per unit left over],
)

== Seasonality — static method
#table(columns: (auto, 1fr),
  table.header(..hdr[Step][Do]),
  st(1)[$p$], [periods per cycle (quarters → 4, months → 12)],
  st(2)[Deseason.], [centered MA \ $p$ odd: $overline(D)_t = 1\/p sum_(i = t-(p-1)\/2)^(t+(p-1)\/2) D_i$ \ $p$ even: $overline(D)_t = [D_(t-p\/2) + D_(t+p\/2) + sum_(i=t+1-p\/2)^(t-1+p\/2) 2 D_i] \/ (2p)$ \ first / last $p\/2$ periods have none],
  st(3)[Trend], [regress $overline(D)_t$ on $t$ → $L$ = `INTERCEPT`, $T$ = `SLOPE`],
  st(4)[Fitted], [$hat(D)_t = L + T t$ for *every* $t$],
  st(5)[Ratios], [$overline(S)_t = D_t\/hat(D)_t$ (regression value, not the MA)],
  st(6)[Factors], [$S_i$ = average of $overline(S)_t$ for season $i$ over $r$ cycles \ check $sum S_i approx p$],
  st(7)[Forecast], [$F_(t+k) = [L + (t+k) T] dot S_(t+k)$],
  [Index], [$S_i = 0.80$ → season 20% *below* average \ $1.25$ → 25% above],
  [Adaptive], [init $L_0$, $T_0$, $S_1 dots S_p$ (static) → forecast → update → repeat],
)

== Regression (causal / trend)
#table(columns: (auto, 1fr),
  table.header(..hdr[Item][Formula, check]),
  [Simple], [$Y = a + b x$ \ $b = sum(x - overline(x))(y - overline(y))\/sum(x - overline(x))^2$ \ $a = overline(y) - b overline(x)$ (`SLOPE`, `INTERCEPT`)],
  [Multiple], [$Y = a + b_1 X_1 + b_2 X_2 + dots$ \ $b_k$ = extra $Y$ per unit of $X_k$],
  [Significance], [$|t"-stat"| > 2$ / p-value < 0.05 / 95% CI excludes 0],
  [Benefit / cost], [ad spend worth it if $b_k > 1$ per \$1 (CI incl. < 1 → doubtful) \ revenue ≠ profit],
  [Residuals], [unbiased \ normal \ no autocorr. (DW ≈ 2) \ constant variance \ valid only inside observed $X$ range],
)

== Forecast error ($e_i = F_i - D_i$, average over $n$ periods)
#table(columns: (auto, 1fr, auto),
  table.header(..hdr[Measure][Formula][Type]),
  [CSE (cum. sum of errors)], [$sum e_i$], [bias],
  [MFE (mean forecast error)], [$1\/n sum e_i$], [bias],
  [MPE (mean % error)], [$1\/n sum e_i\/D_i dot 100$], [bias],
  [MAD / MAE (mean abs. dev.)], [$1\/n sum |e_i|$], [accuracy],
  [MAPE (mean abs. % error)], [$1\/n sum |e_i|\/D_i dot 100$], [accuracy],
  [MSE / RMSE (mean sq. error)], [$1\/n sum e_i^2$ / $sqrt("MSE")$], [accuracy],
)
#table(columns: (auto, 1fr),
  table.header(..hdr[Point][Rule]),
  [Per row], [$e$, $|e|$, $e^2$, $|e|\/D$ → average each column (skip periods with no forecast)],
  [KPI choice], [min MSE → *mean* \ min MAE → *median* \ min MAPE → *too low*],
  [Tracking], [reasonable: $|e_t| <= 4 "MAD"_(t-1)$ \ bias: $|"MFE"_t| <= 0.5 "MAD"_t$],
  [Accuracy vs. bias], [spread of errors vs. systematic offset (dart board)],
  [Sign caution], [Excel / regression often uses $D - F$: flip signs],
)

== Choosing & tuning a model
#table(columns: (auto, 1fr),
  table.header(..hdr[Step][Rule]),
  [Split], [estimation sample (fit) + holdout (evaluate) \ more estimation data → better parameters; larger holdout → stronger test],
  [Tune], [MA → $N$ \ smoothing → $alpha, beta, gamma in [0, 1]$ via Solver, min MSE on *estimation* \ default $alpha = .3$, $beta = gamma = .1$],
  [Select], [lowest holdout MSE, MFE ≈ 0 \ use good sense (no overfitting)],
)

== From forecast error to safety stock
#table(columns: (auto, 1fr),
  table.header(..hdr[Item][Formula]),
  [$sigma$ of error], [$sqrt(sum(e_i - overline(e))^2\/(n-1))$ (`STDEV` on holdout) \ normal: $sigma approx 1.25 "MAD"$],
  [Stock level], [$F + z sigma$, $z = Phi^(-1)("target")$ \ this $sigma$ is the demand $sigma$ of the inventory models],
  [% error method], [level $= F(1 + z dot "st.dev."("PE"))$],
  [Evaluate policy], [in-stock % = periods with level ≥ demand \ cost $= h dot$ leftover + SO cost per SO period],
)

#set page(paper: "a4", margin: (x: 0.45cm, y: 0.45cm), columns: 1)

#let na = text(fill: luma(150))[—]

== Time series: general rules ($n$ = last observed period)
#table(columns: (auto, 1fr),
  table.header(..hdr[Method · use when][Update · forecast ahead]),
  [SMA ($N$)], [$F_t = (D_(t-1) + dots + D_(t-N))\/N$],
  [SES ($alpha$)], [$F_t = alpha D_(t-1) + (1-alpha) F_(t-1)$],
  [Holt \ ($alpha$, $beta$) \ _trend_], [$L_t = alpha D_(t-1) + (1-alpha) F_(t-1)$ \ $T_t = beta(L_t - L_(t-1)) + (1-beta) T_(t-1)$ \ $F_t = L_t + T_t$],
  [Winters \ ($alpha$, $beta$, $gamma$) \ _trend + season_], [$L_t = alpha D_(t-1)\/S_(t-1) + (1-alpha)(L_(t-1) + T_(t-1))$ \ $T_t = beta(L_t - L_(t-1)) + (1-beta) T_(t-1)$ \ $S_t = gamma D_(t-p)\/L_(t-p) + (1-gamma) S_(t-p)$ (slides: $S_(t+p-1) = gamma D_(t-1)\/L_(t-1) + (1-gamma) S_(t-1)$) \ $F_t = (L_t + T_t) S_t$],
  [Static \ _trend + season, stable_], [$F_t = (L + T t) S_t$],
)

*SMA template* ($N = 3$, data up to $D_6$)
#table(
  columns: (auto, auto, auto, auto),
  fill: (x, y) => if y >= 7 { rgb("#eef3f8") },
  inset: (x: 1em, y: 0.25em),
  table.header(..hdr[$t$][$D_t$][$F_t$ ↑$N$][$e_t$]),
  [1], [$D_1$], [#na (fewer than $N$ past values)], [#na],
  [2], [$D_2$], [#na], [#na],
  [3], [$D_3$], [#na], [#na],
  [4], [$D_4$], [$(D_1 + D_2 + D_3)\/3$ *first forecast*], [$F_4 - D_4$],
  [5], [$D_5$], [$(D_2 + D_3 + D_4)\/3$], [$F_5 - D_5$],
  [6], [$D_6$], [$(D_3 + D_4 + D_5)\/3$], [$F_6 - D_6$],
  table.hline(y: 7, stroke: 1pt + navy),
  [7], [#na], [$(D_4 + D_5 + D_6)\/3$ *last update*], [#na],
  [8], [#na], [$F_7$ (flat)], [#na],
  [9], [#na], [$F_7$ (flat)], [#na],
)

*SES template* (data up to $D_5$)
#table(
  columns: (auto, auto, auto, auto),
  fill: (x, y) => if y >= 6 { rgb("#eef3f8") },
  inset: (x: 1em, y: 0.25em),
  table.header(..hdr[$t$][$D_t$][$F_t$ ↑][$e_t$]),
  [1], [$D_1$], [$F_1$], [$F_1 - D_1$],
  [2], [$D_2$], [$alpha D_1 + (1-alpha) F_1$], [$F_2 - D_2$],
  [3], [$D_3$], [$alpha D_2 + (1-alpha) F_2$], [$F_3 - D_3$],
  [4], [$D_4$], [$alpha D_3 + (1-alpha) F_3$], [$F_4 - D_4$],
  [5], [$D_5$], [$alpha D_4 + (1-alpha) F_4$], [$F_5 - D_5$],
  table.hline(y: 6, stroke: 1pt + navy),
  [6], [#na], [$alpha D_5 + (1-alpha) F_5$], [#na],
  [7], [#na], [$F_6$ (flat)], [#na],
  [8], [#na], [$F_6$ (flat)], [#na],
)

- $F_1$ (given, or $F_1 = D_1$)

*Holt template* (data up to $D_5$)
#table(
  columns: (auto, auto, auto, auto, auto, auto),
  fill: (x, y) => if y >= 6 { rgb("#eef3f8") },
  inset: (x: 1em, y: 0.25em),
  table.header(..hdr[$t$][$D_t$][$L_t$ ↑][$T_t$ ↑][$F_t$ ←][$e_t$]),
  [1], [$D_1$], [$L_1$], [$T_1$], [$L_1 + T_1$], [$F_1 - D_1$],
  [2], [$D_2$], [$alpha D_1 + (1-alpha) F_1$], [$beta(L_2 - L_1) + (1-beta) T_1$], [$L_2 + T_2$], [$F_2 - D_2$],
  [3], [$D_3$], [$alpha D_2 + (1-alpha) F_2$], [$beta(L_3 - L_2) + (1-beta) T_2$], [$L_3 + T_3$], [$F_3 - D_3$],
  [4], [$D_4$], [$alpha D_3 + (1-alpha) F_3$], [$beta(L_4 - L_3) + (1-beta) T_3$], [$L_4 + T_4$], [$F_4 - D_4$],
  [5], [$D_5$], [$alpha D_4 + (1-alpha) F_4$], [$beta(L_5 - L_4) + (1-beta) T_4$], [$L_5 + T_5$], [$F_5 - D_5$],
  table.hline(y: 6, stroke: 1pt + navy),
  [6], [#na], [$alpha D_5 + (1-alpha) F_5$], [$beta(L_6 - L_5) + (1-beta) T_5$], [$L_6 + 1 T_6$], [#na],
  [7], [#na], [#na], [#na], [$L_6 + 2 T_6$], [#na],
  [8], [#na], [#na], [#na], [$L_6 + 3 T_6$], [#na],
  [9], [#na], [#na], [#na], [$L_6 + 4 T_6$], [#na],
)

*Winters template* ($p = 4$, demand known up to $D_5$)
#table(
  columns: (auto, auto, auto, auto, auto, auto, auto),
  fill: (x, y) => if y >= 6 { rgb("#eef3f8") },
  inset: (x: 1em, y: 0.25em),
  table.header(..hdr[$t$][$D_t$][$L_t$ ↑][$T_t$ ↑][$S_t$ ↑$p$][$F_t$ ←][$e_t$]),
  [1], [$D_1$], [$L_1$], [$T_1$], [$S_1$], [$F_1 = (L_1 + T_1) S_1$], [$F_1 - D_1$],
  [2], [$D_2$], [$L_2 = alpha D_1\/S_1 + (1-alpha)(L_1 + T_1)$], [$T_2 = beta(L_2 - L_1) + (1-beta) T_1$], [$S_2$], [$F_2 = (L_2 + T_2) S_2$], [$F_2 - D_2$],
  [3], [$D_3$], [$L_3 = alpha D_2\/S_2 + (1-alpha)(L_2 + T_2)$], [$T_3 = beta(L_3 - L_2) + (1-beta) T_2$], [$S_3$], [$F_3 = (L_3 + T_3) S_3$], [$F_3 - D_3$],
  [4], [$D_4$], [$L_4 = alpha D_3\/S_3 + (1-alpha)(L_3 + T_3)$], [$T_4 = beta(L_4 - L_3) + (1-beta) T_3$], [$S_4$], [$F_4 = (L_4 + T_4) S_4$], [$F_4 - D_4$],
  [5], [$D_5$], [$L_5 = alpha D_4\/S_4 + (1-alpha)(L_4 + T_4)$], [$T_5 = beta(L_5 - L_4) + (1-beta) T_4$], [$S_5 = gamma D_1\/L_1 + (1-gamma) S_1$], [$F_5 = (L_5 + T_5) S_5$], [$F_5 - D_5$],
  table.hline(y: 6, stroke: 1pt + navy),
  [6], [#na], [$L_6 = alpha D_5\/S_5 + (1-alpha)(L_5 + T_5)$], [$T_6 = beta(L_6 - L_5) + (1-beta) T_5$], [$S_6 = gamma D_2\/L_2 + (1-gamma) S_2$], [$F_6 = (L_6 + 1 T_6) S_6$ \ $h = 1$], [#na],
  [7], [#na], [#na], [#na], [$S_7 = gamma D_3\/L_3 + (1-gamma) S_3$], [$F_7 = (L_6 + 2 T_6) S_7$], [#na],
  [8], [#na], [#na], [#na], [$S_8 = gamma D_4\/L_4 + (1-gamma) S_4$], [$F_8 = (L_6 + 3 T_6) S_8$], [#na],
  [9], [#na], [#na], [#na], [$S_9 = gamma D_5\/L_5 + (1-gamma) S_5$], [$F_9 = (L_6 + 4 T_6) S_9$], [#na],
  [10], [#na], [#na], [#na], [$S_10 := S_6$ ($D_6$ unknown → latest season-2 factor)], [$F_10 = (L_6 + 5 T_6) S_10$], [#na],
)

== Initialization: which values, from where
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Method][Need][If not given: compute (estimation sample only)]),
  [SMA ($N$)], [nothing], [first forecast $F_(N+1) = (D_1 + dots + D_N)\/N$; rows $1 dots N$ have no $F$],
  [SES ($alpha$)], [$F_1$], [$F_1 = D_1$ (slides) ⇒ $F_2 = D_1$ \ ($F_1$ = avg of first few $D$ only if told)],
  [Holt \ ($alpha$, $beta$)], [$L_1$, $T_1$], [
    $y = a + b x$ \
    $x = t$ \
    $y = D_t$ \
    $b = sum(x - overline(x))(y - overline(y))\/sum(x - overline(x))^2$ \
    $a = overline(y) - b overline(x)$ \
    $L_1 = a$, $T_1 = b$ \
    check: $F_1 = L_1 + T_1 = hat(D)_1$
  ],
  [Winters \ ($alpha$, $beta$, $gamma$)], [$L_1$, $T_1$, \ $S_1 dots S_p$], [
    1. $overline(D)_t$ = centered MA over $p$: \
      $p$ odd: $1\/p sum_(i = t-(p-1)\/2)^(t+(p-1)\/2) D_i$ \
      $p$ even: $[D_(t-p\/2) + D_(t+p\/2) + sum_(i=t+1-p\/2)^(t-1+p\/2) 2 D_i] \/ (2p)$ \
    2. $y = a + b x$ \
      $x = t$ \
      $y = overline(D)_t$ \
      $b = sum(x - overline(x))(y - overline(y))\/sum(x - overline(x))^2$ \
      $a = overline(y) - b overline(x)$ → $L_1 = a$, $T_1 = b$ \
    3. $hat(D)_t = a + b t$ for *all* $t$ \
    4. $S_i$ = average of $D_t \/ hat(D)_t$ over all $t$ of the same season $i$ (e.g. all Q1s: $t = 1, 5, 9, dots$) · $sum S_i approx p$ \
  ],
)



