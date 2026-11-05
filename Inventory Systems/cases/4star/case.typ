#set text(font: "Helvetica", size: 8pt)
#set par(justify: true)
#set heading(numbering: none)
#show table: it => align(center, it)
#set table(stroke: 0.5pt + gray, inset: 5pt)
#show table.cell.where(y: 0): strong

#let result(content) = box(stroke: blue, fill: blue.transparentize(75%), inset: 0.5em, radius: 0.25em)[#content]

#let r(d, digits: 3) = calc.round(d, digits: digits)

// ---------------------------------------------------------------------------
// Case data
// ---------------------------------------------------------------------------

#let company = (
  revenue-sgd: (y1989: 9000000, y2002: 6000000),
  models: (y1996: 13, y2002: 230),
  fast-movers: 20,
  slow-movers: 210,
  fill-rate: (late-1990s: 0.70, y2002: 0.60),
  warehouse-sqft: (y1998: 5000, y2002: 45000),
  staff: 100,
  supervisors: 3,
  assembly-tables: 3,
  dealers: (large: 20),
  top-dealer: (name: "Novena", sales-share: 0.25),
)

#let cost = (
  unit-cost-sgd: 150,
  spring-unit-sgd: 85,
  quilt-panel-sgd: 35,
  foam-layer-sgd: 30,
  holding-rate: 0.20,
)

#let ops = (
  safety-stock-weeks: 2,
  batch: (
    spring-unit: 100,
    quilt-panel: 50,
    assembly-fast: (min: 9, max: 12),
    assembly-slow: 3,
  ),
  fabric-roll-m: 400,
  fabric-varieties: 45,
  spring-count-range: (min: 384, max: 1308),
  sizes: ("Single", "Super Single", "Queen", "King"),
  delivery-expectation-days: 2,
  setup-heavy-machines: ("coil spring machine", "quilt panel stitching machine"),
)

#let slow-mover = (count: 210, mu: 30, sigma: 25)

#let new-models = (
  (year: 1997, n: 7),
  (year: 1998, n: 60),
  (year: 1999, n: 40),
  (year: 2000, n: 30),
  (year: 2001, n: 30),
  (year: 2002, n: 50),
)

#let production = (
  (year: 1996, units: 18700),
  (year: 1997, units: 17470),
  (year: 1998, units: 16380),
  (year: 1999, units: 15340),
  (year: 2000, units: 14380),
  (year: 2001, units: 14560),
  (year: 2002, units: 15080),
)

#let fast-movers = (
  (id: "PU",     ex7: "PU-Queen",    size: "Q", mu: 1200, sigma: 108.1, springs: 788,  wire-mm: 2.1, fabric: "QF1",  foam-mm: 25),
  (id: "CMD",    ex7: "CMD-Queen",   size: "Q", mu: 920,  sigma: 114.5, springs: 1116, wire-mm: 2.1, fabric: "QF2",  foam-mm: 25),
  (id: "GOMK",   ex7: "GOMK-Queen",  size: "Q", mu: 800,  sigma: 102.9, springs: 788,  wire-mm: 2.1, fabric: "QF1",  foam-mm: 25),
  (id: "JC",     ex7: "JC-Queen",    size: "Q", mu: 650,  sigma: 89.9,  springs: 788,  wire-mm: 2.1, fabric: "QF3",  foam-mm: 25),
  (id: "PL",     ex7: "PL-Queen",    size: "Q", mu: 630,  sigma: 61.7,  springs: 1116, wire-mm: 2.1, fabric: "QF4",  foam-mm: 25),
  (id: "SM2",    ex7: "SM2-Queen",   size: "Q", mu: 580,  sigma: 53.1,  springs: 788,  wire-mm: 2.1, fabric: "QF4",  foam-mm: 18),
  (id: "SJL",    ex7: "SJL-Queen",   size: "Q", mu: 540,  sigma: 43.6,  springs: 788,  wire-mm: 2.1, fabric: "QF5",  foam-mm: 18),
  (id: "PU(S)",  ex7: "PU-Single",   size: "S", mu: 500,  sigma: 38.8,  springs: 788,  wire-mm: 2.1, fabric: "QF1",  foam-mm: 25),
  (id: "PF",     ex7: "PF-Queen",    size: "Q", mu: 480,  sigma: 43.6,  springs: 1116, wire-mm: 2.1, fabric: "QF6",  foam-mm: 18),
  (id: "RC",     ex7: "RC-Queen",    size: "Q", mu: 440,  sigma: 34.2,  springs: 1116, wire-mm: 2.1, fabric: "QF7",  foam-mm: 25),
  (id: "CMD(K)", ex7: "CMD-King",    size: "K", mu: 380,  sigma: 40.0,  springs: 1116, wire-mm: 2.1, fabric: "QF2",  foam-mm: 25),
  (id: "OGN",    ex7: "OGN-Queen",   size: "Q", mu: 330,  sigma: 30.8,  springs: 688,  wire-mm: 2.1, fabric: "QF8",  foam-mm: 30),
  (id: "PU(K)",  ex7: "PU-King",     size: "K", mu: 310,  sigma: 38.3,  springs: 788,  wire-mm: 2.1, fabric: "QF1",  foam-mm: 25),
  (id: "SBS",    ex7: "SBS-Queen",   size: "Q", mu: 290,  sigma: 24.3,  springs: 688,  wire-mm: 2.1, fabric: "QF8",  foam-mm: 25),
  (id: "GMK(K)", ex7: "GDMK-King",   size: "K", mu: 250,  sigma: 22.5,  springs: 788,  wire-mm: 2.1, fabric: "QF1",  foam-mm: 25),
  (id: "SC788",  ex7: "Q788-Queen",  size: "Q", mu: 230,  sigma: 18.5,  springs: 788,  wire-mm: 2.1, fabric: "QF1",  foam-mm: 25),
  (id: "GA",     ex7: "GA-Queen",    size: "Q", mu: 210,  sigma: 19.5,  springs: 788,  wire-mm: 2.1, fabric: "QF9",  foam-mm: 30),
  (id: "USQ",    ex7: "CLSQ-Queen",  size: "Q", mu: 200,  sigma: 19.6,  springs: 1308, wire-mm: 1.7, fabric: "QF10", foam-mm: 30),
  (id: "SC1116", ex7: "Q1116-Queen", size: "Q", mu: 190,  sigma: 17.3,  springs: 1116, wire-mm: 1.9, fabric: "QF11", foam-mm: 25),
  (id: "EX",     ex7: "EX-Queen",    size: "Q", mu: 170,  sigma: 21.8,  springs: 1116, wire-mm: 1.9, fabric: "QF12", foam-mm: 25),
)

#let spring-wire = (
  (gauge-mm: 2.1, moq-kg: 24000, price: 0.90, currency: "USD", lead-time-days: 49),
  (gauge-mm: 1.9, moq-kg: 24000, price: 0.90, currency: "USD", lead-time-days: 49),
)

#let quilt-fabrics = (
  (id: "QF1",  moq-m: 3000, price: 1.75, currency: "USD", lead-time-days: 42),
  (id: "QF2",  moq-m: 3000, price: 2.35, currency: "USD", lead-time-days: 42),
  (id: "QF3",  moq-m: 2000, price: 1.75, currency: "USD", lead-time-days: 42),
  (id: "QF4",  moq-m: 2000, price: 2.35, currency: "USD", lead-time-days: 42),
  (id: "QF5",  moq-m: 2000, price: 1.35, currency: "USD", lead-time-days: 42),
  (id: "QF6",  moq-m: 2000, price: 2.00, currency: "USD", lead-time-days: 42),
  (id: "QF7",  moq-m: 2000, price: 3.00, currency: "USD", lead-time-days: 42),
  (id: "QF8",  moq-m: 2000, price: 2.70, currency: "USD", lead-time-days: 42),
  (id: "QF9",  moq-m: 2000, price: 2.40, currency: "USD", lead-time-days: 42),
  (id: "QF10", moq-m: 2000, price: 3.50, currency: "USD", lead-time-days: 42),
  (id: "QF11", moq-m: 2000, price: 2.35, currency: "USD", lead-time-days: 42),
  (id: "QF12", moq-m: 2000, price: 4.20, currency: "USD", lead-time-days: 42),
)

#let foam = (
  (thickness-mm: 7,  moq-m: 680, price: 2.18, currency: "SGD", lead-time-days: 2),
  (thickness-mm: 12, moq-m: 680, price: 3.80, currency: "SGD", lead-time-days: 2),
  (thickness-mm: 18, moq-m: 680, price: 4.77, currency: "SGD", lead-time-days: 2),
)

// ---------------------------------------------------------------------------
// Modelling assumptions (our own, stated in the text)
// ---------------------------------------------------------------------------

#let weeks = 52
#let review-weeks = 1      // production schedule fixed weekly
#let lead-weeks = 1        // make a batch within the following week
#let T = (review-weeks + lead-weeks) / weeks   // protection interval, in years
#let z95 = 1.645           // 95% cycle service level
#let fx = 1.79             // SGD per USD, 2002 average
#let m-per-panel = ops.fabric-roll-m / ops.batch.quilt-panel   // 8 m of fabric per quilt panel
#let k = slow-mover.count / company.fast-movers                // 10.5 slow models share each fast-mover BOM

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

#let sum(xs) = xs.fold(0, (a, b) => a + b)

// Abramowitz & Stegun 7.1.26
#let erf(x) = {
  let s = if x < 0 { -1 } else { 1 }
  let x = calc.abs(x)
  let t = 1 / (1 + 0.3275911 * x)
  let poly = ((((1.061405429 * t - 1.453152027) * t + 1.421413741) * t - 0.284496736) * t + 0.254829592) * t
  s * (1 - poly * calc.exp(-x * x))
}
#let Phi(x) = 0.5 * (1 + erf(x / calc.sqrt(2)))

#let fmt(n) = {
  let s = str(int(calc.round(calc.abs(n))))
  let L = s.len()
  let out = ""
  for (i, c) in s.clusters().enumerate() {
    if i > 0 and calc.rem(L - i, 3) == 0 { out += "," }
    out += c
  }
  if n < 0 { "−" + out } else { out }
}
#let sgd(n) = "S$" + fmt(n)
#let pct(x, digits: 0) = str(r(100 * x, digits: digits)) + "%"

// Safety stock under the current "2 weeks of demand" rule and the CSL it implies
#let ss-weeks(mu) = ops.safety-stock-weeks * mu / weeks
#let csl-implied(mu, sigma) = Phi(ss-weeks(mu) / (sigma * calc.sqrt(T)))
#let ss-sigma(sigma, z: z95) = z * sigma * calc.sqrt(T)

// Aggregates
#let fast-mu = sum(fast-movers.map(f => f.mu))
#let slow-mu = slow-mover.count * slow-mover.mu
#let cv-slow = slow-mover.sigma / slow-mover.mu
#let csl-slow = csl-implied(slow-mover.mu, slow-mover.sigma)

#h(1fr) Manyara Kevin Omenyi \
#h(1fr) Fabian Hernandez \
#h(1fr) Vladimir Borel \

= 4 Star

// *Assumptions used throughout.* Annual demand is normal and independent across models. The production schedule is set weekly and a batch is available within the following week, so finished stock must cover a protection interval of $R + L = #(review-weeks + lead-weeks)$ weeks. Target cycle service level 95% ($z = #z95$). Each quilt panel uses $#ops.fabric-roll-m "m" \/ #ops.batch.quilt-panel = #m-per-panel$ m of fabric. Following the case, the #slow-mover.count slow movers ($mu = #slow-mover.mu$, $sigma = #slow-mover.sigma$) are spread evenly over the #company.fast-movers fast-mover BOMs, i.e. $k = #k$ slow models per BOM. FX: #fx SGD/USD.

== 1. What are the problems faced by Four Star Industries in their mattress manufacturing operations?

*Drivers (external)*

- Intensifying competition: Dreammakers, Dunlopillo, Simmons, Slumberland and late entrants
- Product proliferation required by dealers (e.g. Novena, #pct(company.top-dealer.sales-share) of sales)
- Dealers stopped holding stock and taking care of logitics: Four Star now has to carry the inventory, take care of delivery and is expected to deliver within #ops.delivery-expectation-days days
- Demand is seasonal and highly dependent on promotions (very uncertain during discounts)

*Operational*

- Models went from #company.models.y1996 to #company.models.y2002 (#r(company.models.y2002 / company.models.y1996, digits: 0)×)
- Volume fell from #fmt(production.first().units) to #fmt(production.last().units) units
- Fill rate fell from #pct(company.fill-rate.late-1990s) to #pct(company.fill-rate.y2002)
- Warehouse space increased from #fmt(company.warehouse-sqft.y1998) to #fmt(company.warehouse-sqft.y2002) sq ft (#r(company.warehouse-sqft.y2002 / company.warehouse-sqft.y1998, digits: 0)×)
- Stockouts and excess stock at the same time
- Scheduling problem: 
  - Setup-heavy machines (#ops.setup-heavy-machines.join(" and ")) 
  - Fixed batches (#ops.batch.spring-unit spring units, #ops.batch.quilt-panel quilt panels, assembly batches of #ops.batch.assembly-fast.min–#ops.batch.assembly-fast.max or #ops.batch.assembly-slow)
- Raw material MOQs (24 t of wire, 2,000–3,000 m of fabric per variety, 45 varieties) engender large cycle stocks
- Safety-stock rule that ignores variability (#ops.safety-stock-weeks weeks of demand for every model) 
- Orders taken by fax / phone
- No forecasts
- No commitments from dealers
- Expedited backorders

*Consequences*

- Operating losses for three years (revenue down from S\$#fmt(company.revenue-sgd.y1989) in 1989 to S\$#fmt(company.revenue-sgd.y2002) in 2002)
- Overtime, wastage, and long-serving staff with stress-related health problems threatening to quit

== 2. How does the proliferation of mattress varieties impact Four Star's operations?

*1. Demand is split* 

Average demand per model decreased while total volume stayed the same

#table(
  columns: 4,
  [Year], [Models], [Units], [Units / model / week],
  [1996], [#company.models.y1996], [#fmt(production.first().units)], [#r(production.first().units / company.models.y1996 / weeks, digits: 1)],
  [2002], [#company.models.y2002], [#fmt(production.last().units)], [#r(production.last().units / company.models.y2002 / weeks, digits: 1)],
)

2002 volume:
- #company.fast-movers fast movers sell #fmt(fast-mu) units 
- #slow-mover.count slow movers #fmt(slow-mu)
- Total #fmt(fast-mu + slow-mu)

The last of the #slow-mover.count models represents #pct(slow-mu / (fast-mu + slow-mu)) of the volume but #pct(slow-mover.count / company.models.y2002) of the SKUs

*2. Variability per SKU explodes*

$
  "CV" = sigma / mu
$

#let n = fast-movers.len()
#let cv = fast-movers.map(f => f.sigma / f.mu).sum() / n

Average CV:
- Fast movers: $ "CV"_"fast" = 1/#n #sym.sum _(i=1)^#n sigma_i / mu_i = #r(cv, digits: 2) $
- Slow movers: #result[$"CV"_"slow" = #slow-mover.sigma \/ #slow-mover.mu = #r(cv-slow, digits: 2)$] 

A slow mover sells $#slow-mover.mu \/ #weeks = #r(slow-mover.mu / weeks, digits: 2)$ units per week, so a single assembly batch of #ops.batch.assembly-slow covers #r(ops.batch.assembly-slow / (slow-mover.mu / weeks), digits: 1) weeks

*3. The safety-stock rule fails where products proliferated* 

- Holding #ops.safety-stock-weeks weeks of average demand gives us $"SS" = 2 mu \/ 52$
- Over the #(review-weeks + lead-weeks)-week protection interval the implied service level is $"CSL" = Φ("SS" \/ (sigma sqrt(T)))$:

#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  [Model], [$mu$], [$sigma$], [CV], [SS (2 wks)], [$sigma_T$], [Implied CSL],
  ..fast-movers.map(f => (
    f.id, str(f.mu), str(f.sigma), str(r(f.sigma / f.mu, digits: 2)),
    str(r(ss-weeks(f.mu), digits: 1)), str(r(f.sigma * calc.sqrt(T), digits: 1)),
    pct(csl-implied(f.mu, f.sigma), digits: 1),
  )).flatten(),
  [*Each slow mover*], [#slow-mover.mu], [#slow-mover.sigma], [#r(cv-slow, digits: 2)],
  [#r(ss-weeks(slow-mover.mu), digits: 2)], [#r(slow-mover.sigma * calc.sqrt(T), digits: 1)], [*#pct(csl-slow, digits: 1)*],
)

- Fast movers are over-protected (CSL > 93%)
- Slow movers are a coin flip

*4. Order fill rate collapses on multi-line orders* 

- A dealer order is filled only if every line is in stock 
- If we have a #pct(csl-slow) availability per slow-moving line:

#table(
  columns: 6,
  [Slow-moving lines in order], ..range(1, 6).map(n => str(n)),
  [P(order complete)], ..range(1, 6).map(n => pct(calc.pow(csl-slow, n))),
)

An order containing a few slow movers is almost certain to wait (bottleneck)

*5. Raw-material and setup effects* 

Every new model needs its own spring-unit or quilt setup and sometimes its own fabric or wire gauge. MOQs are per material, not per model (a fabric MOQ of 2,000 m is #fmt(2000 / m-per-panel) panels, i.e. #r(2000 / m-per-panel / slow-mover.mu, digits: 1) years of demand for a slow mover. This increases warehouse space and locks cash up in stock.

== 3. Analyze the various courses of action that Sia Meng is contemplating to solve Four Star's operational problems. How effective will these actions be?

#let ss-now-units = ss-weeks(fast-mu) + ss-weeks(slow-mu)
#let ss-now-value = ss-now-units * cost.unit-cost-sgd
#let csl-slow-1wk = Phi((slow-mover.mu / weeks) / (slow-mover.sigma * calc.sqrt(T)))
#let n1998 = company.models.y1996 + 7 + 60
#let T-off = (review-weeks + 4) / weeks
Sia Meng is considering 4 ideas: \

*a) Reduce the number of models back to the levels in 1996 or 1998.* \
Pooling slow-moving in $N$ models, will reduce total safety stock (SS) by a factor of $sqrt(N)$ (as per the square-root law) - assuming customers switch models. \

This means, going from the #company.models.y2002 models to #n1998 models (1998) will reduce it by #pct(1 - calc.sqrt(n1998 / company.models.y2002)). Going to #company.models.y1996 models will reduce it by #pct(1 - calc.sqrt(company.models.y1996 / company.models.y2002)). The problem is, the dealers are demanding for their own exclusive models and they are most likely to walk away if they don't get what they want. 

Novena sales alone constitute #pct(company.top-dealer.sales-share) of sales (≈ S\$#fmt(company.top-dealer.sales-share * company.revenue-sgd.y2002)) and losing them may cost more than the inventory saved. \

 Also, the #company.models.y1996 models are fewer than today's #company.fast-movers fast moving mattresses and going back to 1996 numbers would hurt best selling mattresses. \
 
 Therefore, this solution is only *Partially effective*. The company should remove only the unprofitable models, and should avoid making blanket cuts.

*b) Make dealers order minimum number corresponding to batch size.* \
Slow moving models have a batch of #ops.batch.assembly-slow which is #r(ops.batch.assembly-slow / (slow-mover.mu / weeks), digits: 1) weeks of demand. Implementing this proposal forces the stock onto dealers, who decided not to carry inventory anymore. So, the solution risks the dealers moving to competition. \

Also, even if the dealers were to accept the proposal, this would not reduce inventory in the overall supply chain. It only moves it to dealers, and that would not be an effective solution. \

This proposal also does not solve the batching issue in the production process. The spring units batch (#ops.batch.spring-unit) and quilt panels batch (#ops.batch.quilt-panel) depend on the equipment. Imposing a minimum order size would not address this issue. Therefore, the solution will *Not be effective*.

*c) Reduce safety stock requirement for finished mattresses.* \


$
  "SS"_"week" = (#ops.safety-stock-weeks times #fast-mu) / #weeks + (#ops.safety-stock-weeks times #slow-mu) / #weeks = #ss-now-units
$

$
  "SS"_"week" times #cost.unit-cost-sgd = #ss-now-value
$

The current inventory policy translates to #fmt(ss-now-units) units of Safety Stock worth (#sgd(ss-now-value)), with an annual holding cost of #sgd(ss-now-value * cost.holding-rate) at #pct(cost.holding-rate). These numbers are relatively small and would not resolve the core issue. \

Slow moving products are normally in stock #pct(csl-slow) of the time. A reduction of Safety Stock from 2 to 1 week drops slow-movers' CSL from #pct(csl-slow) to #pct(csl-slow-1wk). Since, fill rate already was down to 60% from 70%, this solution will make it worse. \

The core issue is not safety stock but the fact that the warehouse is filled with cycle stock, fabric bought at MOQ, and defective finished goods. \

So, this solution will *Not be effective*. But, calculating SS using  $sigma$ instead of weeks of demand will improve the numbers.

*d) Relocating manufacturing Overseas.* \
While offshoring may reduce overtime and facility costs, does not address product complexity, scheduling issues and inventory mismatch. Besides, Four star's Labour and capacity are not the bottlenecks. \

Taking manufacturing overseas will increase lead time, which may compromise their ability to meet the dealer's expectation of "#(ops.delivery-expectation-days)-day delivery. It will also need a higher inventory level (from #(review-weeks + lead-weeks) to 5 weeks) and safety stock will go up by $sqrt(5\/2) = #r(calc.sqrt(5 / 2), digits: 2)$×. \

Also, mattresses are bulky andcostly to ship, and this will increase the costs for the products in an already very competitive market. \

Therefore, this solution is *Not effective*.

== 4. Discuss possible ways in which Four Star can reconfigure its product design, manufacturing and order fulfilment. How will this help to solve its operational problems?

By maintaining the diversity for the dealer without holding inventory in the warehouse, we can: standardize parts, differentiate late, and only hold stocks where demand is consolidated.

=== 4.1 Product design: modular platform

The differentiation would come from the spring unit (count × gauge × dimensions), quilt fabric, and foam. The 20 fast-moving items already utilize only a limited number of spring units:

#let su-key(f) = f.size + "-" + str(f.springs) + "-" + str(f.wire-mm)
#let su-types = {
  let d = (:)
  for f in fast-movers {
    let key = su-key(f)
    let cur = d.at(key, default: (n: 0, mu: 0))
    d.insert(key, (n: cur.n + 1, mu: cur.mu + f.mu))
  }
  d
}

#table(
  columns: 5,
  align: (left, right, right, right, right),
  [Spring unit (size-count-gauge)], [Fast models], [Fast demand], [Slow models (≈ $k n$)], [Total demand],
  ..su-types.pairs().map(((key, v)) => (
    key, str(v.n), fmt(v.mu), str(r(k * v.n, digits: 1)), fmt(v.mu + k * v.n * slow-mover.mu),
  )).flatten(),
)

#result[#company.models.y2002 models are built from about #su-types.len() spring units.] 

Recommendations:

- *Standardize the spring unit platform*: the company will manufacture spring units with only one gauge (2.1 mm) and 3–4 spring counts per size. The 1.9 mm and 1.7 mm gauges are only used to manufacture #fmt(sum(fast-movers.filter(f => f.wire-mm != 2.1).map(f => f.mu + k * slow-mover.mu))) mattresses per year, while the 2.1 mm gauge is used to manufacture #fmt(sum(fast-movers.filter(f => f.wire-mm == 2.1).map(f => f.mu + k * slow-mover.mu))) mattresses per year. Both have the same minimum order quantity of 24 t. Therefore, an order of 1.9 mm wire lasts approximately #r(sum(fast-movers.filter(f => f.wire-mm == 2.1).map(f => f.mu + k * slow-mover.mu)) / sum(fast-movers.filter(f => f.wire-mm == 1.9).map(f => f.mu + k * slow-mover.mu)), digits: 0) times longer than an order of 2.1 mm wire.
- Rationalize fabrics (45 → \~12–15). With MOQ = 2,000–3,000 m and #m-per-panel m per panel, fabric cover per order is:

#let fab-demand(id) = sum(fast-movers.filter(f => f.fabric == id).map(f => f.mu + k * slow-mover.mu))

#table(
  columns: 6,
  align: (left, right, right, right, right, right),
  [Fabric], [Panels / yr], [m / yr], [MOQ (m)], [Weeks of cover], [Avg cycle stock (S\$)],
  ..quilt-fabrics.map(q => {
    let p = fab-demand(q.id)
    (q.id, fmt(p), fmt(p * m-per-panel), fmt(q.moq-m), str(r(q.moq-m / (p * m-per-panel) * weeks, digits: 1)), fmt(q.moq-m / 2 * q.price * fx))
  }).flatten(),
)

#let avg-fab-price = sum(quilt-fabrics.map(q => q.price)) / quilt-fabrics.len()
#let extra-fabrics = ops.fabric-varieties - quilt-fabrics.len()
#let extra-fab-value = extra-fabrics * 2000 / 2 * avg-fab-price * fx

The 12 fabrics in the fast-mover BOMs can cover all models according to the case's own BOM assumption. The other #extra-fabrics varieties each tie up an average of 1,000 m of fabric, which is equivalent to approximately #result[#sgd(extra-fab-value) of fabric and #sgd(extra-fab-value * cost.holding-rate) per year to hold], for low-volume models where a single MOQ can cover several years of demand.
- Give dealers exclusivity through low-cost, late features, such as label, tape edge colour, quilting pattern, foam/comfort layer, name and price point. All models would be built on standard spring units and a reduced fabric palette. Novena keeps its "Premier" range, but for the factory it is simply five variants of one platform.

=== 4.2 Manufacturing: hybrid make-to-stock / assemble-to-order

Move the *decoupling point*:

- Fast movers (A items, #pct(fast-mu / (fast-mu + slow-mu)) of volume): make-to-stock (MTS) of finished mattresses. Safety stock for fast movers is set with the formula $"SS" = z sigma sqrt(T)$, rather than a fixed two weeks of demand.
- Slow movers: assemble-to-order (ATO). Safety stock for slow movers is held as spring units and quilt panels rather than finished mattresses, pooled across all the models that share them. Foam is bought to order, with a 2-day lead time. Assembly is manual with no significant setup, and the three assembly tables have spare capacity, since current volume is #pct(1 - production.last().units / production.first().units) below 1996. Slow-mover volume is also low, at only #r(slow-mu / weeks / 5, digits: 0) mattresses per day, so they can be assembled within the #(ops.delivery-expectation-days)-day delivery window.

Component pooling: if $n$ independent models share the same component, the pooled standard deviation is $sigma_"pool" = sigma sqrt(n)$ instead of $n sigma$, so total safety stock falls by a factor of $sqrt(n)$.

#let fab-size-groups = {
  let d = (:)
  for f in fast-movers {
    let key = f.fabric + "-" + f.size
    d.insert(key, d.at(key, default: 0) + 1)
  }
  d
}
#let pooled-ss(groups) = sum(groups.map(n => ss-sigma(slow-mover.sigma * calc.sqrt(k * n))))

#let ss-fast-sigma = sum(fast-movers.map(f => ss-sigma(f.sigma)))
#let ss-slow-sku = slow-mover.count * ss-sigma(slow-mover.sigma)
#let ss-spring = pooled-ss(su-types.values().map(v => v.n))
#let ss-quilt = pooled-ss(fab-size-groups.values())

#let scen-now = (ss-weeks(fast-mu) + ss-weeks(slow-mu)) * cost.unit-cost-sgd
#let scen-mts = (ss-fast-sigma + ss-slow-sku) * cost.unit-cost-sgd
#let scen-hyb = ss-fast-sigma * cost.unit-cost-sgd + ss-spring * cost.spring-unit-sgd + ss-quilt * cost.quilt-panel-sgd

#table(
  columns: 5,
  align: (left, left, right, right, right),
  [Scenario], [Safety stock held as], [Slow-mover CSL], [Value (S\$)], [Holding cost / yr],
  [A. Current rule (2 wks)], [#fmt(ss-weeks(fast-mu)) fast + #fmt(ss-weeks(slow-mu)) slow FG], [#pct(csl-slow)], [#fmt(scen-now)], [#fmt(scen-now * cost.holding-rate)],
  [B. Pure MTS at 95%], [#fmt(ss-fast-sigma) fast + #fmt(ss-slow-sku) slow FG], [95%], [#fmt(scen-mts)], [#fmt(scen-mts * cost.holding-rate)],
  [C. Hybrid MTS + ATO], [#fmt(ss-fast-sigma) fast FG + #fmt(ss-spring) spring units (#su-types.len() types) + #fmt(ss-quilt) quilt panels (#fab-size-groups.len() fabric×size)], [95%], [#fmt(scen-hyb)], [#fmt(scen-hyb * cost.holding-rate)],
)

#result[Hybrid C serves slow movers at 95% instead of #pct(csl-slow) for #pct(1 - scen-hyb / scen-mts) less safety stock than pure MTS, at about the same cost as today (#sgd(scen-hyb) vs #sgd(scen-now)).] Finished-goods SKUs on the shelf drop from #company.models.y2002 to #company.fast-movers, which frees most of the 45,000 sq ft and ends "stockout and excess at the same time".

Supporting changes:

- *Setup reduction* on the coil-spring and quilt-stitching machines: smaller economic batches for spring units and panels, so cycle stock shrinks too.
- *Daily assembly schedule* for ATO orders on top of the weekly MTS plan for fast movers. One planner owns the component buffers (reorder points per spring-unit type and fabric×size).
- *Raw materials*: fewer fabrics and one wire gauge mean MOQs turn quickly. Negotiate split deliveries or consignment for the remaining low-volume fabrics.

=== 4.3 Order fulfilment: differentiated service and information

- The two service promises of the company are that fast moving products will be delivered ex-stock within one day, while slow moving and exclusive products will be assembled to order within 2 days. These promises match the expectations of the dealers of the company.
- Implementation of electronic ordering systems for the pharmacy. These systems allow for orders to be placed online or through EDI software instead of having to place orders via fax or phone. Also, these systems have a cutoff time for placing orders and the pharmacy has real-time visibility of the stock in their warehouse as well as the available ATP of their products. When an order is placed, the pharmacy receives a confirmation of that order.

This solution keeps the variety in the market but absorbs it at the component level. The inventory of components follows the $sqrt(n)$ instead of $n$. The fill rate of products increases since the slow movers do not have to rely on a 59% chance of being on the shelf. The warehouse space, working capital and wastage decrease. The scheduling of the components only requires two loops each week and each day.