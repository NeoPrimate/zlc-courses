// MZ 505 Inventory Systems — Exam cheatsheet: (s,S) · (R,Q) · Risk Pooling · Forecasting
// Compile: typst compile cheatsheet.typ   (2 pages, A4)

#set document(title: "MZ 505 Inventory Systems — Cheatsheet")
#set page(paper: "a4", margin: (x: 0.45cm, y: 0.45cm), columns: 3)
#set columns(gutter: 0.25cm)
#set text(size: 7.9pt, font: ("Helvetica Neue", "Carlito", "Calibri", "Inter", "Arial"), lang: "en")
#set par(leading: 0.3em, spacing: 0.35em, justify: false)
#set table(inset: (x: 1.8pt, y: 1.3pt), stroke: 0.3pt + luma(170), align: left + horizon)
#show table: set par(leading: 0.22em)
#show table: it => block(above: 2pt, below: 2.5pt, it)
#show math.equation: set text(size: 8.1pt)

#let navy = rgb("#1f4e79")
#let teal = rgb("#0f766e")
#show heading.where(level: 1): it => block(
  width: 100%, fill: navy, inset: (x: 3pt, y: 1.8pt), above: 3pt, below: 2pt, radius: 1.5pt,
  text(fill: white, weight: "bold", size: 8.6pt, it.body),
)
#show heading.where(level: 2): it => block(
  above: 3pt, below: 1.2pt,
  text(fill: teal, weight: "bold", size: 7.9pt, it.body),
)
#let hdr(..cells) = cells.pos().map(c => table.cell(fill: navy.lighten(82%), text(weight: "bold", c)))
#let st(n, body) = table.cell(fill: navy.lighten(88%))[*#n* #body]
#let wide(n, body) = table.cell(colspan: n, body)

#place(top + center, scope: "parent", float: true, clearance: 2pt,
  block(width: 100%, fill: navy.lighten(88%), inset: 2.5pt, radius: 2pt)[
    #align(center)[#text(size: 8.6pt, weight: "bold", fill: navy)[MZ 505 Inventory Systems — Exam Cheatsheet]
    #h(6pt) #text(size: 6.6pt)[Toolkit · (s, S) periodic · (R, Q) continuous · Risk pooling · Demand forecasting]]
  ])

// =====================================================================
= 0 · Toolkit (used by every model)

#table(columns: (auto, 1fr),
  ..hdr[Item][Formula · Excel],
  [$z$ · $Phi$ · $phi$], [$z = (x - mu)\/sigma$ · CDF `norm.cdf(z)` · pdf `norm.pdf(z)`],
  [$z$ from $alpha$], [`norm.pdf(α)` · $x$ directly: `norm.ppf(α, μ, σ)`],
  [Loss $L(z)$], [$phi(z) - z(1 - Phi(z))$; inverse: loss table],
  [E[short]], [$E(D - x)^+ = sigma L(z)$ #h(1fr) E[left] $= sigma(z + L(z))$],
  [Over $t$ periods], [mean $mu t$, st. dev. $sigma sqrt(t)$ (iid periods)],
  [Uniform $[a, b]$], [$F(x) = (x-a)\/(b-a)$; $n(x) = (b - x)^2 \/ (2(b-a))$],
  [Poisson], [smallest $x$ with $F(x) >= alpha$ (table)],
  [CV], [$sigma \/ mu$],
  [$H$], [annual holding $= h dot c$ (rate × unit cost) if given as %],
)

== Critical ratio $alpha$ (target in-stock / CSL)
#table(columns: (auto, 1fr),
  ..hdr[Given][$alpha$],
  [CSL / in-stock], [$alpha$ = CSL],
  [Newsvendor], [$C_u \/ (C_u + C_o)$; $C_u = p - c + g$, $C_o = c - v$],
  [Backorder $b$, hold $h$ / period], [$b \/ (b + h)$ (OUT, (s, S))],
  [(R,Q) backorders], [$1 - H Q \/ (b D)$ ($C_o = H Q \/ D$ per cycle)],
  [(R,Q) lost sales], [$b D \/ (b D + H Q)$],
  [Fill rate target], [$L(z) = (1 - beta) dot "(demand per cycle)" \/ sigma$ → $z$],
)

== Model family — one rule: level $= mu_I + z sigma_I$ over the interval $I$ it covers
#table(columns: (auto, 1fr, auto, auto),
  ..hdr[Model][Built from][Sets][Covers $I$],
  [EOQ], [deterministic $D$; order vs. hold], [$Q$], [—],
  [Newsvendor], [1 period, random $D$; $C_u$ vs. $C_o$], [$Q$], [1 season],
  [OUT], [NV every $T$ + backorders + LT], [$S$], [$T + L$],
  [(s, S)], [OUT + fixed cost $K$ (EOQ)], [$s$, $S$], [1 / $n$ per.],
  [(R, Q)], [EOQ for $Q$ + NV over LT for $R$], [$Q$, $R$], [$L$],
)
#table(columns: (1fr, auto),
  ..hdr[Situation][Model],
  [Deterministic demand], [EOQ],
  [Random, one shot (no replenishment)], [Newsvendor],
  [Random, trigger = time, no $K$], [OUT],
  [Random, trigger = time, fixed $K$], [(s, S)],
  [Random, trigger = inventory level], [(R, Q)],
)

== EOQ · Newsvendor · OUT recap
#table(columns: (auto, 1fr),
  ..hdr[Item][Formula],
  [EOQ], [$Q^* = sqrt(2 K D \/ H)$; $"TC" = K D\/Q + H Q\/2 + c D$; $"TVC"^* = sqrt(2 K D H)$],
  [Cycle], [$T = Q\/D$; orders/yr $= D\/Q$; det. reorder $R = D L$ (on IP)],
  [NV sales], [$mu - sigma L(z)$; left $= Q - "sales"$; FR $= "sales"\/mu$],
  [NV profit], [$p dot "sales" + v dot "left" - c Q - g dot "short"$],
  [IP], [on-hand + pipeline − backorders],
  [OUT $S$], [$S = mu_(T+L) + z sigma_(T+L)$; slides $T = 1$: $mu(L+1) + z sigma sqrt(L+1)$],
  [OUT E[back]], [$sigma_(T+L) L(z)$ #h(1fr) FR $= 1 - E["back"]\/(mu T)$],
  [OUT on-hand], [$S - mu_(T+L) + E["back"] approx z sigma_(T+L)$ (= SS)],
  [OUT avg inv.], [$mu T \/ 2 + "SS"$ #h(1fr) pipeline $= mu L$ (Little)],
  [OUT order qty], [equals demand since last review (variable)],
)

// =====================================================================
= 1 · (s, S) periodic review with order cost $K$

#table(columns: (auto, auto, 1fr),
  ..hdr[Step][Case][Formula],
  st(0)[Units], wide(2)[per *review period*: $mu$, $sigma$; $L$ = \# periods; $n$ periods → $n mu$, $sigma sqrt(n)$],
  st(1)[$alpha$], wide(2)[CSL, $b\/(b+h)$ or $C_u\/(C_u+C_o)$ (table §0); $z = Phi^(-1)(alpha)$],
  table.cell(rowspan: 2, st(2)[Setting]),
    [single period], [$F(S) = alpha$; $s$ solves $pi(s) = pi(S) - K$ → *stop*],
    [multi-period], [heuristic, steps 3–6],
  st(3)[EOQ], wide(2)[$"EOQ" = sqrt(2 K D \/ H)$ ($D$, $H$ same unit); $n = "EOQ" \/ mu$ periods covered],
  table.cell(rowspan: 3, st(4)[Model]),
    [$n <= 1$], [order every period → OUT ($s = S$)],
    [$T$ free], [$T approx "EOQ"\/D$, then OUT over $T + L$],
    [$n > 1$, $T$ fixed], [*(s, S)* → steps 5–6],
  table.cell(rowspan: 2, st(5)[$s$]),
    [$L = 0$ (slides)], [1 period: $s = mu + z sigma$],
    [$L > 0$ #super[†]], [$L+1$ per.: $s = (L+1)mu + z sigma sqrt(L+1)$],
  table.cell(rowspan: 2, st(6)[$S$]),
    [$L = 0$ (slides)], [$n$ periods: $S = n mu + z sigma sqrt(n)$],
    [$L > 0$ #super[†]], [$n+L$ per.: $S = (n+L)mu + z sigma sqrt(n+L)$],
  st(7)[Policy], wide(2)[each review: IP $< s$ → order $S - "IP"$; else nothing (check $S > s$)],
)
#text(size: 0.85em)[#super[†] extension of slide heuristic (adds $L$ to protection interval). Scarf (1960): (s, S) optimal for stationary demand, linear costs, zero LT.]

== Choosing the review period $T$ (order every $T$, OUT)
#table(columns: (auto, 1fr),
  ..hdr[Cost / yr][Formula ($N$ = periods per year)],
  [Ordering], [$K dot N \/ T$ (assumes $P("demand" = 0) = 0$ → an order every review)],
  [SS], [$z sigma sqrt(T + L)$ (ignore E[back])],
  [Holding], [$h dot (mu T \/ 2 + "SS")$ × periods/yr (match units of $h$)],
  [Decide], [compare total for $T = 1, 2, dots$; ↑$T$: ↓ordering, ↑cycle + ↑SS],
)

// =====================================================================
= 2 · (R, Q) continuous review (heuristic, no iteration)

#table(columns: (auto, auto, 1fr),
  ..hdr[Step][Case][Formula],
  st(0)[Units], wide(2)[same time unit for $D$, $sigma_D$, $L$, $H$; mean $prop t$, $sigma prop sqrt(t)$],
  st(1)[$Q$], wide(2)[$Q = "EOQ" = sqrt(2 K D \/ H)$ (or given)],
  table.cell(rowspan: 2, st(2)[$mu_L$, $sigma_L$]),
    [$L$ fixed], [$mu_L = D L$; #h(2pt) $sigma_L = sigma_D sqrt(L)$],
    [$L$ random], [$mu_L = D overline(L)$; #h(2pt) $sigma_L = sqrt(overline(L) sigma_D^2 + D^2 s_L^2)$],
  st(3)[$alpha$], wide(2)[CSL; or cost-based with $Q$ = EOQ (§0 table)],
  st(4)[$R$], wide(2)[$z = Phi^(-1)(alpha)$; #h(2pt) $R = mu_L + z sigma_L$],
  st(5)[Given $R$], wide(2)[$z = (R - mu_L)\/sigma_L$ → CSL $= Phi(z)$],
  st(6)[$n(R)$], wide(2)[E[short] per cycle $= sigma_L L(z)$ (uniform: §0)],
  table.cell(rowspan: 2, st(7)[SS]),
    [backorders], [$"SS" = R - mu_L = z sigma_L$],
    [lost sales], [$"SS" = R - mu_L + n(R)$],
  st(8)[Policy], wide(2)[when IP $<= R$ → order $Q$],
)

== KPIs & annual cost
#table(columns: (auto, 1fr),
  ..hdr[KPI][Formula],
  [CSL (Type I)], [$P(D_L <= R)$ = fraction of *cycles* without stockout],
  [Fill rate (Type II)], [$beta = 1 - n(R)\/Q$ = fraction of *units* served],
  [P(stockout)/cycle], [$1 - "CSL"$ #h(1fr) SO cycles/yr $= (1 - "CSL") D\/Q$],
  [Units short/yr], [$n(R) D \/ Q$],
  [Avg inventory], [$Q\/2 + "SS"$],
  [TC / yr], [$K D\/Q + H(Q\/2 + "SS") + b n(R) D\/Q + c D$],
  [Lost sales TC], [penalty $(h + b) n(R) D\/Q$ → in practice: SS incl. $+n(R)$],
)

== CSL vs. fill rate
#table(columns: (auto, 1fr),
  ..hdr[Point][Answer],
  [Ex post], [10 cycles, 2 with SO → CSL 0.8; demand 1450, short 55 → FR = 1395/1450 = 0.96],
  [Why FR > CSL usually], [a stockout cycle still serves most of its $Q$ units: CSL counts whole cycle as failure, FR only the missing units],
  [CSL > FR case], [4 cycles, $Q = 10$, demand 10, 10, 10, 40 → CSL = 0.75, FR = 40/70 = 0.57 (one huge shortage)],
  [↑R], [↑CSL and ↑FR (both rise), ↑SS],
  [↑Q], [same CSL, but ↑FR (fewer cycles exposed)],
)

== Effect of parameters (heuristic; cost-based $alpha$)
#table(columns: (auto, auto, auto, 1fr),
  ..hdr[↑ Param][$Q$][$R$][SS · why],
  [$sigma_D$], [–], [↑], [↑ ($z sigma_L$)],
  [$L$ or $s_L$], [–], [↑], [↑; cutting LT variability cuts SS a lot],
  [CSL / FR target], [–], [↑], [↑ (convex in CSL)],
  [$K$], [↑], [↓], [↓: larger $Q$ → fewer cycles exposed, ↓$alpha$],
  [$h$], [↓], [↓], [↓: $H Q$ ↑ → ↓$alpha$],
  [$b$], [–], [↑], [↑: ↑$alpha$],
  [$D$], [↑], [↑], [↑: $mu_L$ ↑, $alpha$ ↑ ($H Q\/D$ ↓)],
)

== Uncertain lead time — example
#table(columns: (auto, 1fr),
  [Data], [weekly $N(2500, 500)$ → daily $D = 357$, $sigma = 189$; $L tilde N(7, 7)$ d; CSL 0.90],
  [Result], [$sigma_L = sqrt(7 dot 189^2 + 357^2 dot 7^2) = 2548.5$; $"SS" = 1.2816 dot 2548.5 = 3266$],
  [Nahmias], [$D = 60$/d, $sigma = 7$, $L = 6$ d, $K = 10$, $h = 0.5$/yr: $Q = 936$; $R = 360 + 1.645 dot 7 sqrt(6) = 388$],
)

== Periodic (OUT) vs. continuous (R, Q)
#table(columns: (auto, 1fr, 1fr),
  ..hdr[][Periodic (OUT)][Continuous (R, Q)],
  [SS covers], [$T + L$ → *more SS*], [$L$ only],
  [Qty / timing], [variable / fixed], [fixed / random],
  [Pros], [convenient; combine orders], [fixed lots (discounts); less SS],
  [Cons], [more SS], [monitoring cost; random timing],
  [Same CSL, why SS differs], [must protect review gap + LT: $z sigma sqrt(T+L)$], [only LT: $z sigma sqrt(L)$],
)

== Worked chain: weekly $N(200, 120)$, $L = 2$ wk, $Q = 1000$
#table(columns: (auto, 1fr),
  ..hdr[Question][Computation],
  [$mu_L$, $sigma_L$], [$400$; $120 sqrt(2) = 169.7$],
  [SS at $R = 600$], [$600 - 400 = 200$],
  [CSL], [$z = 200\/169.7 = 1.18$ → $Phi = 0.881$],
  [FR], [$L(1.18) = 0.0586$; $n(R) = 9.95$; $1 - 9.95\/1000 = 0.990$],
  [$R$ = 500/400/300/200], [CSL .72/.50/.28/.12 · FR .97/.93/.87/.79],
  [CSL 95%], [$z = 1.645$; $R = 400 + 1.645 dot 169.7 = 679$; SS = 279],
  [$L tilde N(2, 1.1)$], [$sigma_L = sqrt(2 dot 120^2 + 200^2 dot 1.1^2) = 277.8$; SS = 457],
  [OUT, $T = 1$], [over $L + 1 = 3$: $S = 600 + 1.645 dot 120 sqrt(3) = 942$; SS = 342 > 279],
)

// =====================================================================
#pagebreak()
= 3 · Risk pooling

== Sum of demands
#table(columns: (auto, 1fr),
  ..hdr[Quantity][Formula],
  [$mu_P$], [$sum mu_i$ (always)],
  [$sigma$ two], [$sqrt(sigma_X^2 + sigma_Y^2 + 2 rho sigma_X sigma_Y)$],
  [$sigma$ $n$], [$sqrt(sum sigma_i^2 + 2 sum_(i<j) rho_(i j) sigma_i sigma_j)$],
  [cov], [$rho sigma_X sigma_Y = E[X Y] - E X E Y$],
  [2 identical], [$sigma_P = sqrt(2(1+rho)) sigma$; $"CV"_P = sqrt((1+rho)\/2) "CV"$],
  [$rho = 0$, iid], [$sigma sqrt(n)$ → CV ÷ $sqrt(n)$],
  [$rho = +1$], [$sum sigma_i$ → *no benefit*],
  [$rho = -1$], [$|sigma_X - sigma_Y|$ → *max benefit*],
  [Best when], [$rho$ low/negative · similar sizes · high CV · few sites ⇒ most gain],
)

== Pooling strategies — overview
#table(columns: (0.8fr, 1fr, 1fr),
  ..hdr[Strategy][Pros][Cons / note],
  [Location (centralize)], [↓SS, ↓overhead, inbound scale], [farther from customer: ↑outbound transport, ↑response time],
  [Virtual pooling], [stock local, share info, transship (Gap, Walmart)], [transshipment cost],
  [Product (universal design)], [↓inventory, SKU rationalization], [lose functionality / segmentation, ↑unit cost],
  [Consolidated distribution (DC)], [lead-time pooling, transport + purchase scale, stock near customer], [DC cost, extra handling; works even though total LT ↑],
  [Delayed differentiation], [keeps variety, same gain as universal design], [needs product/process redesign],
  [Capacity (flexibility)], [chains of flexible plants], [flex cost],
)
#table(columns: (auto, 1fr),
  ..hdr[Substitution][Meaning],
  [Manufacturer-driven], [firm ships a substitute from its own stock],
  [Customer-driven], [customer switches or sale is lost → ↑demand for available items],
)

== Location pooling (centralize $n$ sites)
#table(columns: (auto, auto, 1fr),
  ..hdr[Step][Case][Formula],
  st(1)[$z$], wide(2)[$z = Phi^(-1)("CSL")$],
  st(2)[Decentral], wide(2)[$"SS"^D = z sqrt(L) sum_i sigma_i$ (each site $mu_i$, $sigma_i$)],
  table.cell(rowspan: 2, st(3)[Central]),
    [indep.], [$mu_C = sum mu_i$; $sigma_C = sqrt(sum sigma_i^2)$; $"SS"^C = z sqrt(L) sigma_C$],
    [correl.], [$sigma_C$ incl. $2 sum_(i<j) rho_(i j) sigma_i sigma_j$],
  table.cell(rowspan: 3, st(4)[Ratio]),
    [iid], [$"SS"^C \/ "SS"^D = 1\/sqrt(n)$ (*square-root law*)],
    [$rho = +1$], [1 → no benefit],
    [heavy tails], [$P(D > x) approx x^(-a)$: $n^((1-a)\/a)$],
  st(5)[Not cut], wide(2)[pipeline $= D L$ and cycle stock $Q\/2$ unchanged by pooling *if* same $Q$],
)

== Location pooling — full cost comparison (continuous review)
#table(columns: (auto, 1fr, 1fr),
  ..hdr[Cost/period][Decentralized (each $i$)][Centralized at $j$],
  [Demand], [$mu_i$, $sigma_i$ (sample `AVERAGE`, `STDEV`)], [$mu_C$, $sigma_C$],
  [$Q$], [$sqrt(2 K mu_i \/ h)$], [$sqrt(2 K mu_C \/ h)$],
  [SS], [$z sigma_i sqrt(L)$], [$z sigma_C sqrt(L)$],
  [Ordering], [$K mu_i \/ Q_i$], [$K mu_C \/ Q_C$],
  [Holding], [$h(Q_i\/2 + "SS"_i)$], [$h(Q_C\/2 + "SS"_C)$],
  [Inbound], [$"in"_i dot mu_i$], [$"in"_j dot mu_C$],
  [Outbound], [$"out"_i dot mu_i$], [$sum_i "out"_(j -> i) mu_i$],
  [Total], [sum over $i$], [pick $j$ with min total (transport usually decides)],
)

== Product pooling (newsvendor)
#table(columns: (auto, 1fr),
  ..hdr[Step][Formula],
  [$z$], [$C_u = p - c$, $C_o = c - v$; $z = Phi^(-1)(C_u\/(C_u+C_o))$],
  [Separate], [$Q_i = mu_i + z sigma_i$ each],
  [Pooled], [$Q_P = mu_P + z sigma_P$ (same $z$)],
  [Evaluate], [lost $= sigma L(z)$; sales $= mu -$ lost; left $= Q -$ sales; $pi = p "sales" + v "left" - c Q$],
  [Compare], [$sum Q_i$ vs. $Q_P$ (↓); $sum pi_i$ vs. $pi_P$ (↑); gain → 0 as $rho -> +1$],
)

== Consolidated distribution (lead-time pooling via DC, OUT)
#table(columns: (auto, 1fr),
  ..hdr[Piece][Formula ($N$ stores, $mu_s$, $sigma_s$/period)],
  [Direct], [each store over $L_1 + 1$: on-hand $approx z sigma_s sqrt(L_1+1)$; × $N$],
  [Stores via DC], [each over $L_2 + 1$ (short): $z sigma_s sqrt(L_2+1)$; × $N$],
  [DC demand], [$mu_"DC" = N mu_s$; $sigma_"DC" = sqrt(N) sigma_s$ (indep.)],
  [DC stock], [over $L_1 + 1$: on-hand $approx z sigma_"DC" sqrt(L_1+1)$ (DC never stocks out)],
  [Pipeline], [extra DC→store pipeline $N mu_s L_2$],
  [Total], [stores + DC (+ pipeline) vs. direct; best when $L_1$ long, $L_2$ short, $rho$ low],
)

== Delayed differentiation / component pooling (postponement)
#table(columns: (auto, 1fr),
  ..hdr[Piece][Formula ($n$ variants, OUT over $L + 1$)],
  [Finished variants], [on-hand each $= S_i - mu_i(L+1) + E["back"] approx z sigma_i sqrt(L+1)$],
  [Generic / common part], [$sigma_G = sqrt(sum sigma_i^2)$ (iid $sigma sqrt(n)$); on-hand $approx z sigma_G sqrt(L+1)$],
  [Variant part (tops)], [same as finished variant (unchanged)],
  [Saving on common], [$z sqrt(L+1)(sum sigma_i - sigma_G)$; iid: ratio $1\/sqrt(n)$],
  [Use when], [variety wanted · aggregate less uncertain · customize late, fast, cheap (Benetton dye, HP DC)],
)

== Capacity pooling & push-pull
#table(columns: (auto, 1fr),
  ..hdr[Design][Effect],
  [Dedicated (1 link/plant)], [no pooling; excess demand lost],
  [Long chain ($2n$ links, 1 loop)], [≈ total flexibility; one long chain ≫ several short],
  [Total flex ($n^2$ links)], [max benefit and cost],
  [Most valuable when], [capacity ≈ expected demand; $rho$ low],
  [Flex cheap / capacity cheap], [add links / add capacity],
)
#table(columns: (auto, 1fr, 1fr),
  ..hdr[][Low uncertainty][High uncertainty],
  [Low EoS], [push or pull], [*pure pull*],
  [High EoS], [*pure push*], [*push-pull* (decouple)],
  [Short LT], [continuous replenishment], [pull],
  [Long LT], [push], [inventory positioning],
)
#table(columns: (auto, 1fr),
  ..hdr[Decoupling point][Rule],
  [Push side (upstream)], [forecast, aggregate, lean, economic batches],
  [Pull side (downstream)], [demand-driven, agile, local config.],
  [Place buffer], [more upstream if variety/uncertainty high · before high value-add · before bottlenecks · between different smoothing],
)

// =====================================================================
= 4 · Demand forecasting

#table(columns: (auto, 1fr),
  ..hdr[Concept][Content],
  [Planning], [shaping (4P) → forecasting (baseline, unbiased, *unconstrained*) → S&OP],
  [Principles], [always wrong · give error estimate · use *demand* not sales (censored by stockouts) · better for aggregates · better short horizon],
  [Method types], [time series (history) · causal (regression) · qualitative · experimental (surveys) · simulation],
  [Components], [level · trend · seasonality (fixed period) · cyclical (no fixed period) · random],
  [Forms], [mult. $L T S$ · add. $L + T + S$ · mixed $(L + T) S$],
  [Notation], [$F_t$ made before $D_t$ known],
)

== Time-series methods
#table(columns: (auto, 1fr),
  ..hdr[Method][Formula · use],
  [SMA ($N$)], [$F_t = (D_(t-1) + dots + D_(t-N))\/N$; $F_(t+k) = F_t$. No trend/season; ↑$N$ smoother, slower],
  [SES ($alpha$)], [$F_t = alpha D_(t-1) + (1-alpha) F_(t-1)$; weights $alpha(1-alpha)^k$; $F_2 = D_1$; flat for $k > 1$],
  [Holt ($alpha$, $beta$)], [$L_t = alpha D_(t-1) + (1-alpha) F_(t-1)$ · $T_t = beta(L_t - L_(t-1)) + (1-beta) T_(t-1)$ · $F_t = L_t + T_t$; $F_(t+k) = L_t + k T_t$. *Trend*; init $L$, $T$ = intercept, slope of early data],
  [Winters], [$L_t = alpha D_(t-1)\/S_(t-1) + (1-alpha)(L_(t-1) + T_(t-1))$ · $T_t$ as Holt · $S_(t+p-1) = gamma D_(t-1)\/L_(t-1) + (1-gamma) S_(t-1)$ · $F_(t+k) = (L_t + k T_t) S_(t+k)$. *Trend + season*],
)
#table(columns: (auto, 1fr),
  ..hdr[Example][Values],
  [SES $alpha = .3$], [$D$ = 12, 15, 11 → $F$ = 12, 12, 12.9, 12.33],
  [Holt $.5$/$.25$], [$L_1 = 10$, $T_1 = 2$; $D$ = 12, 15, 17, 21 → $F$ = 12, 14, 16.6, 19.0, 22.4],
  [Regression], [$Y$ = 180, 160, 220, 200, 260, 240 → $a = 152$, $b = 16.6$, $F_7 = 268$],
)

== Regression (causal / trend)
#table(columns: (auto, 1fr),
  ..hdr[Item][Formula · check],
  [Simple], [$b = sum(x - overline(x))(y - overline(y)) \/ sum(x - overline(x))^2$; $a = overline(y) - b overline(x)$ (`SLOPE`, `INTERCEPT`)],
  [Multiple], [$Y = a + b_1 X_1 + b_2 X_2 + dots$ (Data Analysis → Regression); $b_k$ = extra $Y$ per unit $X_k$],
  [Significance], [$|t| > 2$ / p < 0.05 / 95% CI excludes 0],
  [Benefit/cost], [ad spend: $b_k$ per \$1 → worth it if $b_k > 1$ (CI incl. < 1 → doubtful); revenue ≠ profit],
  [Validity], [only inside observed $X$ range (extrapolation risky)],
)
#table(columns: (auto, 1fr),
  ..hdr[Error assumption][How to check],
  [Unbiased], [mean error ≈ 0; $t = overline(e)\/(s\/sqrt(n))$, $|t| < 2$],
  [Normal], [histogram, normal prob. plot (straight), skew ≈ 0, kurt ≈ 0],
  [No autocorr.], [lag-1 $r$ within $plus.minus 2\/sqrt(n)$; Durbin–Watson ≈ 2; no runs over time],
  [Const. variance], [no funnel in error vs. fitted plot],
)

== Seasonality — static method
#table(columns: (auto, 1fr),
  ..hdr[Step][Formula],
  [Model], [$F_(t+k) = [L + (t+k) T] S_(t+k)$; $p$ = periods per cycle],
  [1 Deseason. $p$ odd], [$overline(D)_t = 1\/p sum_(i = t-(p-1)\/2)^(t+(p-1)\/2) D_i$],
  [1 Deseason. $p$ even], [$overline(D)_t = [D_(t-p\/2) + D_(t+p\/2) + sum_(i=t+1-p\/2)^(t-1+p\/2) 2 D_i] \/ (2p)$],
  [2 Trend], [regress $overline(D)_t = L + T t$],
  [3 Factors], [$overline(S)_t = D_t\/overline(D)_t$; $S_i$ = average over $r$ cycles of same season],
  [Alt.], [$S_i$ = season avg ÷ overall avg; deseasonalized $= D_t\/S_i$],
  [Adaptive], [init $L_0$, $T_0$, $S_1..S_p$ (static) → forecast → update → repeat],
)

== Forecast error measures ($e_i = F_i - D_i$, + = over-forecast)
#table(columns: (auto, 1fr, auto),
  ..hdr[Measure][Formula][Type],
  [CSE], [$sum e_i$], [bias],
  [MFE], [$1\/N sum e_i$], [bias],
  [MPE], [$1\/N sum e_i\/D_i dot 100$], [bias],
  [MAD/MAE], [$1\/N sum |e_i|$], [accuracy],
  [MAPE], [$1\/N sum |e_i|\/D_i dot 100$], [accuracy],
  [MSE/RMSE], [$1\/N sum e_i^2$ / $sqrt("MSE")$], [accuracy],
)
#table(columns: (auto, 1fr),
  ..hdr[Point][Rule],
  [Example], [$F = 1000$ × 10, $sum D = 10200$: CSE −200, MFE −20 (under), MAD 160, MSE 40 000],
  [KPI choice], [min MSE → *mean* · min MAE → *median* · min MAPE → *too low*],
  [Tracking], [reasonable: $|e_t| <= 4 "MAD"_(t-1)$ · bias: $|"MFE"_t| <= 0.5 "MAD"_t$],
  [Accuracy vs. bias], [spread of errors vs. systematic offset (dart board)],
  [Sign caution], [Excel/regression often uses $D - F$: flip signs],
)

== Choosing & tuning a model
#table(columns: (auto, 1fr),
  ..hdr[Step][Rule],
  [Split], [estimation sample (fit) + holdout (evaluate); more estimation data → better parameters, larger holdout → stronger test],
  [Tune], [MA → $N$; ES → $alpha, beta, gamma in [0,1]$ via Solver min MSE (or MAE) on *estimation*; default $alpha = .3$, $beta = gamma = .1$],
  [Select], [lowest holdout MSE, MFE ≈ 0; use good sense (no overfitting)],
  [Data], [use *unconstrained demand*, not sales],
)

== From forecast error to safety stock
#table(columns: (auto, 1fr),
  ..hdr[Item][Formula],
  [$sigma$ of error], [$sqrt(sum(e_i - overline(e))^2\/(n-1))$ (`STDEV` on holdout); normal: $sigma approx 1.25 "MAD"$],
  [Stock level], [$F + z sigma$ → $sigma$ feeds $sigma_L$, OUT, pooling],
  [% error method], [PE $= e\/D$; stocking level $= F(1 + z dot "sd"("PE"))$],
  [Evaluate policy], [in-stock % = weeks with level ≥ demand; cost = $h dot$ leftover + stockout cost per SO week],
  [Example], [forecast 50, $sigma = 4$: $P(D <= 58) = Phi(2) = 0.977$],
)
#table(columns: (auto, 1fr),
  ..hdr[System design][Choices],
  [Who / what], [integrate across SC (accuracy owner) · demand drivers · data sources],
  [Settings], [horizon · granularity (family/SKU) · period · frequency · lag · revisions],
  [Process], [model by demand pattern → test accuracy → root-cause errors → review],
)