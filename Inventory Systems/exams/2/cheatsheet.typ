// MZ 505 Inventory Systems — Exam cheatsheet (Sessions 16–22 + prerequisites)
// Compile: typst compile cheatsheet.typ

#set document(title: "MZ 505 Inventory Systems — Cheatsheet S16–S22")
#set page(paper: "a4", margin: (x: 0.55cm, y: 0.55cm), columns: 3)
#set columns(gutter: 0.3cm)
#set text(size: 8.4pt, font: ("Carlito", "Calibri", "Inter", "Arial"), lang: "en")
#set par(leading: 0.34em, spacing: 0.42em, justify: false)
#set list(indent: 0.2em, body-indent: 0.3em, spacing: 0.3em, marker: ([•], [–]))
#set table(inset: (x: 2pt, y: 1.6pt), stroke: 0.35pt + luma(170))
#show table: set par(leading: 0.25em)
#show math.equation: set text(size: 8.6pt)

#let navy = rgb("#1f4e79")
#let teal = rgb("#0f766e")
#show heading.where(level: 1): it => block(
  width: 100%, fill: navy, inset: (x: 3pt, y: 2pt), above: 4pt, below: 2.5pt, radius: 1.5pt,
  text(fill: white, weight: "bold", size: 9.4pt, it.body),
)
#show heading.where(level: 2): it => block(
  above: 3.5pt, below: 1.8pt,
  text(fill: teal, weight: "bold", size: 8.8pt, it.body),
)
#let hdr(..cells) = cells.pos().map(c => table.cell(fill: navy.lighten(82%), text(weight: "bold", c)))
#let box1(body) = block(width: 100%, fill: rgb("#fff7e0"), stroke: 0.4pt + rgb("#d4a017"),
  inset: 2.5pt, radius: 1.5pt, above: 2.5pt, below: 2.5pt, body)

#place(top + center, scope: "parent", float: true, clearance: 3pt,
  block(width: 100%, fill: navy.lighten(88%), inset: 3pt, radius: 2pt)[
    #align(center)[#text(size: 9pt, weight: "bold", fill: navy)[MZ 505 Inventory Systems — Exam Cheatsheet]
    #h(6pt) #text(size: 6.6pt)[S16 (s,S) · S17 (R,Q) · S18–S19 Risk Pooling · S21–S22 Demand Forecasting · + prerequisites (stats, EOQ, Newsvendor, OUT)]]
  ])

= 0 · Prerequisites

== Normal & probability toolkit

#table(columns: 2,
  ..hdr[Formula][Meaning],
  [$z$], [$(x - mu) \/ sigma$],
  [$L(z)$], [$phi(z) - z(1 - Phi(z))$],
  [E[Short]], [$sigma L(z)$],
  [$"CV"$], [$sigma \/ mu$],
  [Pipeline], [$D dot L$],
)

== Covariance & correlation

#table(columns: (auto, 1fr),
  [$"cov"(X,Y)$], [$E[(X - E X)(Y - E Y)] \ E[X Y] - E[X]E[Y]$],
  [Corr ($rho$)], [$"cov"(X,Y) \/ sqrt("var" X dot "var" Y) in [-1, 1]$],
  [$"var"(X+Y)$], [$"var" X + "var" Y + 2 "cov"(X,Y)$],
  [$"var"(sum X_i)$], [$sum "var"(X_i) + sum_(i != j) "cov"(X_i, X_j)$],
)

== EOQ (deterministic demand)

#table(columns: (auto, 1fr),
  [$"TC"(Q)$], [$S D \/ Q + h Q \/ 2 + c D$],
  [$Q^*$], [$sqrt(2 D S \/ h)$],
  [$T$], [$Q^* \/ D$],
  [], [$D \/ Q^*$],
  [$R$], [$D dot L$],
)

== Newsvendor (single period, stochastic)

#table(columns: (auto, 1fr),
  [Underage], [$C_u = p - c + g$],
  [Overage], [$C_o = c - s$],
  [Critical ratio], [$F(Q^*) = C_u \/ (C_u + C_o)$],
  [Normal], [$Q^* = mu + z sigma$, #h(2pt) $z = Phi^(-1)("CR")$],
  [Lost sales], [$E["lost"] = sigma L(z)$],
  [Sales], [$mu - E["lost"]$],
  [Leftover], [$Q - E["sales"]$],
  [Profit], [$p E["sales"] + v E["left"] - c Q (- g E["lost"])$],
  [P(InStock)], [$F(Q)$],
  [Fill rate], [$E["sales"] \/ mu$],
)

== Order-up-to (OUT) — periodic review

#table(columns: (auto, 1fr),
  [Choose $S$], [$F(S) = b \/ (b + h)$ or target in-stock; $S = mu_(L+1) + z sigma_(L+1)$],
  [In-stock prob.], [$F(S)$; stockout prob. $1 - F(S)$],
  [Exp. backorder], [$E["back"] = sigma_(L+1) L(z)$],
  [Exp. on-hand], [$S - mu_(L+1) + E["back"] approx S - mu_(L+1)$],
  [Pipeline], [$L dot mu$ (Little's law)],
  [Fill rate], [$1 - E["back"] \/ mu$],
)

== Which model? (decision tree)

#table(columns: (1fr, auto),
  ..hdr[Situation][Model],
  [Deterministic demand], [EOQ],
  [Stochastic, single period (no replenishment)], [Newsvendor],
  [Stochastic, multi-period, trigger = inventory level], [(R, Q) continuous],
  [Stochastic, multi-period, trigger = time], [OUT periodic],
  [Periodic + fixed set-up cost $K$], [(s, S)],
)

= The (s, S) periodic-review policy

#let st(n, body) = table.cell(fill: navy.lighten(88%))[*#n* #body]
#table(columns: (auto, auto, 1fr),
  ..hdr[Step][Case][Formula],
  st(0)[Units], table.cell(colspan: 2)[per *review period* $T$: $mu$, $sigma$ per period; $L$ = integer \# of periods; $n$ periods → $n mu$, $sigma sqrt(n)$],
  table.cell(rowspan: 3, st(1)[$alpha$ (CR)]),
    [CSL given], [$alpha = "CSL"$],
    [$b$, $h$ / period], [$alpha = b \/ (b + h)$],
    [$p, c, v$], [$alpha = C_u \/ (C_u + C_o)$; $C_u = p - c (+g)$, $C_o = c - v$],
  table.cell(rowspan: 2, st(2)[Setting]),
    [single period], [$F(S) = alpha$; find $s$ with $pi(s) = pi(S) - K$ → *stop*],
    [multi-period], [→ heuristic, steps 3–6],
  st(3)[EOQ], table.cell(colspan: 2)[$"EOQ" = sqrt(2 K D \/ H)$ ($D, H$ per yr); periods covered $n = "EOQ" \/ mu$],
  table.cell(rowspan: 3, st(4)[Model]),
    [$n <= 1$], [order every period → OUT ($s = S$)],
    [$T$ free], [set $T approx "EOQ" \/ D$ → OUT over $T + L$],
    [$n > 1$, $T$ fixed], [*(s, S)* → steps 5–6],
  table.cell(rowspan: 2, st(5)[$s$]),
    [$L = 0$ (slides)], [1 period: $s = mu + z sigma$, $z = Phi^(-1)(alpha)$],
    [$L > 0$ #super[†]], [$L + 1$ periods: $s = (L+1) mu + z sigma sqrt(L + 1)$],
  table.cell(rowspan: 2, st(6)[$S$]),
    [$L = 0$ (slides)], [$n$ periods: $S = n mu + z sigma sqrt(n)$],
    [$L > 0$ #super[†]], [$n + L$ periods: $S = (n+L) mu + z sigma sqrt(n + L)$],
  st(7)[Policy], table.cell(colspan: 2)[each review: IP $< s$ → order $S - "IP"$; else nothing (check $S > s$)],
)
#text(size: 0.85em)[#super[†] extension of the slide heuristic (protection interval adds $L$), not on the slides]

= The (R, Q) continuous-review model

#let st(n, body) = table.cell(fill: navy.lighten(88%))[*#n* #body]
#table(columns: (auto, auto, 1fr),
  ..hdr[Step][Case][Formula],
  st(0)[Units], table.cell(colspan: 2)[same time unit for $D, sigma_D, L, H$; mean $prop t$, $sigma prop sqrt(t)$],
  st(1)[$Q$], table.cell(colspan: 2)[$Q = "EOQ" = sqrt(2 K D \/ H)$ #h(1fr) ($K$ = setup)],
  table.cell(rowspan: 2, st(2)[$mu_L, sigma_L$]),
    [$L$ fixed], [$mu_L = D L$ \ $sigma_L = sigma_D sqrt(L)$],
    [$L$ random], [$mu_L = D overline(L)$ \ $sigma_L = sqrt(overline(L) sigma_D^2 + D^2 s_L^2)$],
  table.cell(rowspan: 4, st(3)[$alpha$ (CSL)]),
    [CSL given], [$alpha = "CSL"$],
    [backord. $b$], [$alpha = 1 - H Q \/ (b D)$],
    [lost sales $b$], [$alpha = b D \/ (b D + H Q)$],
    [FR $beta$], [$L(z) = (1 - beta) Q \/ sigma_L$ → $z$ (skip 4)],
  st(4)[$z$], table.cell(colspan: 2)[$z = Phi^(-1)(alpha)$ #h(1fr) `NORM.S.INV(α)`],
  st(5)[$R$], table.cell(colspan: 2)[$R = mu_L + z sigma_L$],
  st(6)[$n(R)$], table.cell(colspan: 2)[$n(R) = sigma_L L(z)$ = E[units short per cycle]],
  table.cell(rowspan: 2, st(7)[$Q'$]),
    [heuristic], [keep $Q = "EOQ"$],
    [exact], [$Q = sqrt(2 D (K + b n(R)) \/ H)$ \ → step 3, repeat],
  st(8)[SS], table.cell(colspan: 2)[$"SS" = R - mu_L = z sigma_L$ #h(1fr) (exact: $+ n(R)$)],
  table.cell(rowspan: 4, st(9)[KPIs]),
    [P(SO)/cycle], [$1 - "CSL"$],
    [SO cycles/yr], [$(1 - "CSL") D \/ Q$],
    [short/yr], [$n(R) D \/ Q$],
    [fill rate $beta$], [$1 - n(R) \/ Q$],
  table.cell(rowspan: 2, st(10)[Cost/yr]),
    [order + hold], [$K D \/ Q + H (Q \/ 2 + "SS")$],
    [short + buy], [$b n(R) D \/ Q + c D$],
)

- *Policy:* when $"IP" <= R$, order $Q$
- Minimize:
  - E[setup] + E[holding] + E[backorder] cost per unit time

== Exact (approximate-cost) formulation
#box1[$C(R,Q) = S D/Q + h(R - mu_L + Q/2) + b dot n(R) D/Q + c D$
#v(1pt)
(1) $Q = sqrt(2 D [S + b dot n(R)] \/ h)$ #h(8pt) (2) $F(R) = (b D - h Q) \/ (b D) = 1 - h Q \/ (b D)$]
- *Iterate:* $Q_0 = "EOQ"$ → $R$ from (2) → $n(R) = sigma_L L(z)$ → $Q$ from (1) → repeat until it converges.
- *Example:* $D = 12000$/yr, $sigma = 1000$, $L = 1$ month ($mu_L = 1000$, $sigma_L = 1000 sqrt(1\/12) = 288.67$), $S = 70$, $h = 0.5$, $b = 10$. EOQ = 1833 → converges to $Q = 1931$, $R = 1695$ ($z = 2.41$, $n(R) = 0.77$).
- *Lost-sales variant (appendix):* SS and holding cost include $+n(R)$; penalty term $(h+b) n(R) D \/ Q$; $F(R) = b D \/ (b D + h Q)$.

== Heuristic (used in practice)
- $Q = "EOQ"$; set $R$ so that $P(D_L <= R) = "CSL"$. If $b$ and $h$ are known, set CSL by the critical ratio.
- *Ex. (Nahmias):* $D = 60$/day, $sigma = 7$, $L = 6$ d, $S = \$10$, $h = \$0.5$/yr, 365 d, CSL 95%: $Q = sqrt(2 dot 21900 dot 10 \/ 0.5) = 936$; $R = 360 + 1.645 dot sqrt(6) dot 7 = 388$.

== Product availability
#table(columns: (auto, 1fr),
  ..hdr[Measure][Definition],
  [Type I: CSL], [fraction of cycles with no stockout $= P(D_L <= R)$],
  [Type II: Fill rate], [fraction of demand served from stock: $"FR" = 1 - n(R) \/ Q$],
)
- *Ex post:* 10 cycles, 2 with stockouts → CSL = 0.8. Demand 1450, short 55 → FR = 1395/1450 = 0.96.

== Uncertain lead time
- $mu_L = D dot overline(L)$, #h(3pt) $sigma_L = sqrt(overline(L) sigma^2 + D^2 s_L^2)$
- *Ex:* weekly $N(2500, 500)$ → daily $D = 357$, $sigma = 189$; $L ~ N(7, 7)$ days; CSL 0.90: $sigma_L = sqrt(7 dot 189^2 + 357^2 dot 7^2) = 2548.5$; $"SS" = 1.2816 dot 2548.5 = 3266$.
- Reducing supply uncertainty ($s_L$) cuts SS dramatically without hurting availability.
- *Levers to cut SS:* shorter $L$ · less LT volatility · lower $sigma_D$ (better forecasts, better information). SS rises with CSL/FR and with $sigma$.

== Insights
- ↑$R$ → ↑SS, fewer stockouts · ↑$Q$ → ↑cycle stock, ↓setup cost, *↓$R$* (fewer cycles exposed to stockouts, eq. 2)
- ↑$sigma$ → ↑$R$ · ↑$h$ → ↓$Q$ and ↓$R$
- Simple, and suppliers like constant $Q$, but *order timing is random*.

== Periodic vs. continuous review
#table(columns: (auto, 1fr, 1fr),
  ..hdr[][Periodic (OUT)][Continuous (R,Q)],
  [SS covers], [$T + L$ (larger SS)], [$L$],
  [Order qty / timing], [variable / fixed], [fixed / random],
  [Pros], [convenient; orders can be combined], [fixed lots → qty discounts; constant count],
  [Cons], [more SS], [record-keeping cost; random delivery time], 
)

= Risk Pooling

== Sum of demands

#table(columns: (auto, 1fr),
  table.header(..hdr[Quantity][Formula]),
  [$E[X+Y]$], [$mu_X + mu_Y$],
  [$sigma_(X+Y)$], [$sqrt(sigma_X^2 + sigma_Y^2 + 2 rho sigma_X sigma_Y)$],
  [$n$ demands], [$sigma = sqrt(sum_i sigma_i^2 + sum_(i != j) rho_(i j) sigma_i sigma_j)$],
  [CV], [$sigma_(X+Y) \/ (mu_X + mu_Y)$],
  [identical $mu, sigma$], [$sigma_(X+Y) = sqrt(2(1+rho)) sigma$; #h(2pt) $"CV" = sqrt(0.5(1+rho)) sigma \/ mu$],
  [$rho = +1$], [$sigma_X + sigma_Y$ → *no pooling benefit*],
  [$rho = 0$], [$sqrt(sigma_X^2 + sigma_Y^2)$; iid: $sigma sqrt(n)$],
  [$rho = -1$], [$|sigma_X - sigma_Y|$ → *maximum benefit* (0 if $sigma_X = sigma_Y$)],
)
- Pooled $sigma <= sum sigma_i$ always
- Benefit is largest when demands are: 
  - Similar in size 
  - $rho$ is low or negative

== Product pooling (newsvendor, e.g. universal design)
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Formula]),
  st(0)[Inputs], table.cell(colspan: 2)[$n$ versions with $mu_i$, $sigma_i$, $rho$; price $p$, cost $c$, salvage $v$],
  st(1)[$z$], table.cell(colspan: 2)[
    $C_u = p - c$, $C_o = c - v$ \
    $z = Phi^(-1)(C_u \/ (C_u + C_o))$
  ],
  table.cell(rowspan: 3, st(2)[Pooled \ demand]),
    [independent], [$mu_P = sum mu_i$; #h(2pt) $sigma_P = sqrt(sum sigma_i^2)$ (iid: $sigma sqrt(n)$)],
    [correlated], [$sigma_P$ incl. $sum_(i != j) rho_(i j) sigma_i sigma_j$],
    [2 identical], [$mu_P = 2 mu$; #h(2pt) $sigma_P = sqrt(2(1+rho)) sigma$],
  table.cell(rowspan: 2, st(3)[$Q$]),
    [separate], [$Q_i = mu_i + z sigma_i$ for each version],
    [pooled], [$Q_P = mu_P + z sigma_P$ (same $z$)],
  st(4)[Evaluate], table.cell(colspan: 2)[per case: lost $= sigma L(z)$; sales $= mu - "lost"$; left $= Q - "sales"$; #linebreak() $pi = p dot "sales" + v dot "left" - c Q$],
  st(5)[Compare], table.cell(colspan: 2)[$sum Q_i$ vs. $Q_P$ (↓ inventory); $sum pi_i$ vs. $pi_P$ (↑ profit); gain → 0 as $rho$ → +1],
)
- *Substitution:* *manufacturer-driven* (the firm ships a substitute based on its own inventory) vs. *customer-driven* (the customer switches or the sale is lost; this raises demand for the available items).
- *Pros:* less inventory and/or more service; SKU rationalization. *Cons:* may lose functionality or segmentation, higher production cost, lost short-term revenue. "Dark side of innovation": proliferation creates complexity.

== Location pooling (centralize $n$ stocking points)
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Formula]),
  st(0)[Inputs], table.cell(colspan: 2)[$n$ locations: $mu_i$, $sigma_i$ per period, $rho_(i j)$; lead time $L$; target CSL],
  st(1)[$z$], table.cell(colspan: 2)[$z = Phi^(-1)("CSL")$],
  st(2)[Decentral], table.cell(colspan: 2)[$"SS"^D = z sqrt(L) sum_i sigma_i$ #h(1fr) (sum of st. devs)],
  table.cell(rowspan: 3, st(3)[Central \ demand]),
    [independent], [$mu_C = sum mu_i$; #h(2pt) $sigma_C = sqrt(sum sigma_i^2)$],
    [iid], [$sigma_C = sigma sqrt(n)$],
    [correlated], [$sigma_C = sqrt(sum sigma_i^2 + sum_(i != j) rho_(i j) sigma_i sigma_j)$],
  table.cell(rowspan: 2, st(4)[Central \ stock]),
    [normal, (R,Q)], [$"SS"^C = z sqrt(L) sigma_C$],
    [Poisson, OUT], [$lambda_C = sum lambda_i$ over $L + 1$; $S$ = smallest with $F(S) >=$ target; on-hand $= S - lambda_C (L+1) + E["back"]$],
  table.cell(rowspan: 3, st(5)[Compare]),
    [iid, $rho = 0$], [$"SS"^C \/ "SS"^D = 1 \/ sqrt(n)$ (*square-root law*)],
    [$rho = +1$], [ratio $= 1$ → no benefit],
    [heavy tails], [$P(D > x) approx x^(-a)$: ratio $= n^((1-a)\/a)$],
  st(6)[Unchanged], table.cell(colspan: 2)[pipeline $= D dot L$ (Little) and cycle stock are *not* reduced by pooling],
)
- *Diminishing returns:* most of the benefit comes from pooling a few locations. Pooling shifts the inventory–service curve down and to the right.
- *Trade-offs:* farther from customers → longer response time and higher outbound transport cost; lower overhead and inbound scale economies.
- *Virtual pooling:* keep stock local but share information; another site fills a stockout (Gap, Walmart) → SS ↓, availability ↑, extra transshipment cost.

== Lead-time pooling ① Consolidated distribution (via a DC)
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Formula]),
  st(0)[Inputs], table.cell(colspan: 2)[$N$ stores, $mu_s$, $sigma_s$ per period (or Poisson); supplier→DC $L_1$, DC→store $L_2$; OUT; target → $z$],
  st(1)[Direct], table.cell(colspan: 2)[each store over $L_1 + 1$: $S = mu_s (L_1+1) + z sigma_s sqrt(L_1+1)$; #linebreak() on-hand $approx S - mu_s (L_1+1)$; total $times N$],
  st(2)[Stores], table.cell(colspan: 2)[via DC, each store over $L_2 + 1$ (short!): same formulas, $times N$],
  table.cell(rowspan: 2, st(3)[DC \ demand]),
    [independent], [$mu_"DC" = N mu_s$; #h(2pt) $sigma_"DC" = sqrt(N) sigma_s$],
    [correlated], [$sigma_"DC" > sqrt(N) sigma_s$ (use the given value)],
  st(4)[DC stock], table.cell(colspan: 2)[over $L_1 + 1$: $S_"DC" = mu_"DC" (L_1+1) + z sigma_"DC" sqrt(L_1+1)$; #linebreak() on-hand $approx S_"DC" - mu_"DC" (L_1+1)$ (DC assumed never to stock out)],
  st(5)[Pipeline], table.cell(colspan: 2)[extra DC→stores pipeline: $N mu_s L_2$ (Little)],
  st(6)[Total], table.cell(colspan: 2)[stores + DC + pipeline vs. direct; benchmark "all at DC" = DC on-hand only],
)
- Works *even though the total LT increases* to $L_1 + L_2$: the DC orders only the *total*, and allocation to stores is postponed.
- *Most effective* with a long $L_1$ and short $L_2$; less effective as $rho$ → +1. Keeps stock close to customers (unlike location pooling).
- *Pros:* less inventory, transport scale economies, purchase discounts. *Cons:* DC operating cost, extra handling and transport.

== Lead-time pooling ② Delayed differentiation (postponement)
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Formula]),
  st(0)[Inputs], table.cell(colspan: 2)[$n$ end variants: $mu_i$, $sigma_i$, $rho$; replenishment LT $L$ of base product; CSL],
  st(1)[$z$], table.cell(colspan: 2)[$z = Phi^(-1)("CSL")$],
  st(2)[No postp.], table.cell(colspan: 2)[stock finished variants: $"SS" = z sqrt(L) sum_i sigma_i$ (iid: $n z sigma sqrt(L)$)],
  table.cell(rowspan: 2, st(3)[Generic \ demand]),
    [independent], [$sigma_G = sqrt(sum sigma_i^2)$ (iid: $sigma sqrt(n)$)],
    [correlated], [add $sum_(i != j) rho_(i j) sigma_i sigma_j$ under the root],
  st(4)[Postp.], table.cell(colspan: 2)[stock generic, customize fast on demand: $"SS" = z sqrt(L) sigma_G$],
  st(5)[Compare], table.cell(colspan: 2)[iid, $rho = 0$: ratio $1 \/ sqrt(n)$; same profit as a universal design, but variety is kept],
)
- *Use when:* customers want variety · total demand is less uncertain than demand per variant · variety is added late, quickly and cheaply · the variety component is cheap relative to the generic one.
- Usually needs *product or process redesign/resequencing* (Benetton: dye after knitting; HP: localize printers at the DC).

== Capacity pooling (manufacturing flexibility)
#table(columns: (auto, auto, 1fr),
  table.header(..hdr[Step][Case][Rule]),
  st(0)[Map], table.cell(colspan: 2)[plants ↔ products; a *link* = a plant can make a product; a *chain* = a connected group],
  table.cell(rowspan: 3, st(1)[Design]),
    [dedicated], [1 link per plant → no pooling; excess demand is lost],
    [*long chain*], [each plant makes 2 products in one closed loop ($2n$ links) ≈ total flexibility],
    [total flex], [all $n^2$ links → maximum benefit and cost],
  st(2)[Evaluate], table.cell(colspan: 2)[expected sales and utilization; most valuable when capacity ≈ expected demand],
  table.cell(rowspan: 2, st(3)[Decide]),
    [flex cheap], [add flexibility (links)],
    [capacity cheap], [add capacity],
)
- A little flexibility goes a long way *if* it forms long chains (one long chain ≫ several short ones). Less effective as $rho$ → +1.
- *Heijunka* (Lean): level production volume and mix (heijunka box + kanban).

== Push–pull & decoupling point
- *Push* (upstream, forecast-driven, *low* uncertainty) | *decoupling point = strategic inventory* | *Pull* (downstream, demand-driven, *high* uncertainty).
- *Lean side:* forecast at aggregate level, economic batches, efficiency. *Agile side:* demand-driven, localized configuration, responsiveness.
#table(columns: (auto, 1fr, 1fr),
  table.header(..hdr[][Low uncertainty][High uncertainty]),
  [Low EoS], [push or pull (cost structure)], [*pure pull*],
  [High EoS], [*pure push*], [*push–pull* (decouple production from distribution)],
  [Short LT], [continuous replenishment], [pull],
  [Long LT], [push], [inventory positioning],
)
- *Where to put decoupling buffers:* further *upstream* the more variety or the harder demand is to predict · before high value-adding steps · before bottlenecks · between processes with different levels of smoothing.
- *Issues:* inventory placement, scale economies, redesign, delays from the postponement stage. Global optimization dominates local optimization.

== Risk pooling summary
- *Less effective with positive correlation.* A little pooling goes a long way. Gives lower inventory *and* higher service at the same time.


= S21 · Demand Forecasting I — methods
- *Demand planning:* shaping (product, promotion, price, place) → *forecasting* (strategic/tactical/operational; baseline, unbiased, unconstrained) → management (balance demand and supply, S&OP).
- *Principles:* forecasts are always wrong · should include an error estimate · use *demand*, not sales, data · more accurate for groups/families · more accurate over shorter horizons.
#table(columns: (auto, 1fr),
  ..hdr[Method type][Basis],
  [Time series], [historical demand only (cheap; good short-term; established products)],
  [Causal], [relationship of demand with other factors (regression)],
  [Qualitative], [judgment, opinion, "soft" information],
  [Experimental], [customer surveys, focus groups],
  [Simulation], [imitate consumer choices; combines time series and causal],
)
- *Components:* *level* (scale) · *trend* (growth rate) · *seasonality* (fixed known period) · *cyclical* (no fixed period, business cycle) · *random* (noise).
- *Observed = systematic + random* (random: independent, mean 0). Forms: multiplicative $L times T times S$ · additive $L + T + S$ · *mixed* $(L + T) times S$.
- *Decomposition:* clean data (errors, causals, outliers) → remove baseline and components → measure random error → project → recompose.
- *Notation:* $F_t$ = forecast for period $t$ made *before* $D_t$ is known.

== Time-series methods
#table(columns: (auto, 1fr),
  ..hdr[Method][Formula · use],
  [SMA], [$F_t = (D_(t-1) + dots + D_(t-N)) \/ N$, $F_(t+k) = F_t$. No trend or season. Large $N$: smoother, less responsive.],
  [SES], [$F_t = alpha D_(t-1) + (1-alpha) F_(t-1) = F_(t-1) + alpha(D_(t-1) - F_(t-1))$. Weights $alpha(1-alpha)^k$ (geometric); stores little data. Init $F_1 = D_1$. No trend or season.],
  [Holt], [$L_t = alpha D_(t-1) + (1-alpha) F_(t-1)$ #linebreak() $T_t = beta(L_t - L_(t-1)) + (1-beta) T_(t-1)$ #linebreak() $F_t = L_t + T_t$; $F_(t+k) = L_t + k T_t$. *Trend.*],
  [Winters], [$L_t = alpha (D_(t-1) \/ S_(t-1)) + (1-alpha)(L_(t-1) + T_(t-1))$ #linebreak() $T_t = beta(L_t - L_(t-1)) + (1-beta) T_(t-1)$ #linebreak() $S_(t+p-1) = gamma (D_(t-1) \/ L_(t-1)) + (1-gamma) S_(t-1)$ #linebreak() $F_t = (L_t + T_t) S_t$; $F_(t+k) = (L_t + k T_t) S_(t+k)$. *Trend + season.*],
)
- *SES ex.* ($alpha = .3$; $D$ = 12, 15, 11): $F_1 = 12$, $F_2 = 12$, $F_3 = 12.9$, $F_4 = 12.33$.
- *Holt ex.* ($alpha = .5$, $beta = .25$; $L_1 = 10$, $T_1 = 2$; $D$ = 12, 15, 17, 21): $F$ = 12, 14, 16.6, 19.0, 22.4; e.g. $L_3 = 14.5$, $T_3 = 2.125$.

== Regression
- $Y = a + b X$, least squares: $min sum epsilon_i^2$; $b = sum (x - overline(x))(y - overline(y)) \/ sum (x - overline(x))^2$, $a = overline(y) - b overline(x)$ (Excel `INTERCEPT`, `SLOPE`).
- *With time as $X$:* initialize Holt/Winters with $L_0 = a$, $T_0 = b$. *Ex:* $Y$ = 180, 160, 220, 200, 260, 240 → $a = 152$, $b = 16.6$, $F_7 = 152 + 16.6 dot 7 = 268$.
- *Multiple (causal):* $Y = a + b_1 X_1 + b_2 X_2 + dots$ (weather, macro indices, ads, promotions). Errors should be *unbiased, normal, not autocorrelated, constant-variance*.

== Seasonality — static method
- $F_(t+k) = [L + (t + k) T] times S_(t+k)$; periodicity $p$ = number of periods per cycle.
- *1. Deseasonalize* (centered moving average):
  - $p$ odd: $overline(D)_t = 1/p sum_(i = t - (p-1)\/2)^(t + (p-1)\/2) D_i$
  - $p$ even: $overline(D)_t = 1/(2p) [D_(t - p\/2) + D_(t + p\/2) + sum_(i = t+1-p\/2)^(t-1+p\/2) 2 D_i]$
- *2.* Regress $overline(D)_t = L + T t$ → $L$, $T$.
- *3.* Seasonal ratios $overline(S)_t = D_t \/ overline(D)_t$; average over $r$ cycles: $S_i = sum_(j=0)^(r-1) overline(S)_(j p + i) \/ r$.
- *Alternative:* $S_i$ = season average ÷ overall average (quarterly ex.: 76.8%, 86.4%, 147.4%, 89.4%). Deseasonalized = $D_t \/ S_i$ (+ annual correction so yearly totals match).
- *Adaptive steps:* initialize ($L_0$, $T_0$, $S_1 dots S_p$, as in static) → forecast → update after $D$ is observed → repeat.

= S22 · Demand Forecasting II — error & optimization
- Error $epsilon_i = F_i - D_i$ (positive = over-forecast). *Two uses:* evaluate/improve models, and *estimate demand variability $sigma$* for inventory models.
- *Accuracy* = magnitude/spread of errors · *bias* = systematic over- or under-forecasting (dart-board analogy).
#table(columns: (auto, 1fr, auto),
  ..hdr[Measure][Formula][Type],
  [CSE], [$sum (F_i - D_i)$], [bias],
  [MFE], [$1/N sum (F_i - D_i)$], [bias],
  [MPE], [$1/N sum (F_i - D_i)\/D_i dot 100$], [bias],
  [MAD / MAE], [$1/N sum |F_i - D_i|$], [accuracy],
  [MAPE], [$1/N sum |F_i - D_i| \/ D_i dot 100$], [accuracy],
  [MSE / RMSE], [$1/N sum (F_i - D_i)^2$ / $sqrt("MSE")$], [accuracy],
)
- *Ex:* $F = 1000$ for 10 periods, $sum D = 10200$: CSE = −200, *MFE = −20* (under-forecast), *MAD = 160*, MSE = 40,000.
- *KPI choice:* min (R)MSE → *mean* (unbiased) · min MAE → *median* · min MAPE → *too-low* forecast (heavy weight when demand is low).
- *Monitoring tests:* "reasonable" demand: $|F_t - D_t| <= 4 dot "MAD"_(t-1)$ · bias: $|"MFE"_t| <= 0.5 dot "MAD"_t$.

== Choosing & optimizing a model
- Split the data into an *estimation sample* (fit parameters) and a *holdout sample* (evaluate). Compare MSE and MFE on the holdout. This is a stronger validity test because the model was fitted to the estimation data.
- More estimation data gives better parameter estimates; a larger holdout gives a more powerful test.
- *Parameters:* MA → $N$ · ES → $alpha, beta, gamma$ (best practice $alpha = 0.3$, $beta = gamma = 0.1$; or Solver: minimize estimation-sample MSE with $0 <= alpha, beta, gamma <= 1$) · regression → $a$, $b$. *Also use good sense!*

== From forecast error to safety stock
#box1[$sigma = sqrt(sum (epsilon_i - overline(epsilon))^2 \/ (n - 1))$ (on the *holdout*). Ex: 209.8.
If errors are normal: $sigma approx sqrt(pi\/2) dot "MAD" approx 1.25 dot "MAD"$.
$X = overline(X) + z sigma$ → this $sigma$ feeds $sigma_L$ in (R,Q), OUT and pooling.
*Ex:* forecast 50, $sigma = 4$: $P(D <= 58) = Phi(2) = 0.977$.]
- *Forecast system design:* integrate across the supply chain (who owns accuracy?) · identify demand drivers · data sources and periods · set horizon, granularity (family/SKU), period, frequency, lag, revisions · pick models by demand pattern, test accuracy, do root-cause analysis of errors · review regularly.