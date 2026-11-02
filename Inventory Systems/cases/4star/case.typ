#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)
#set table(stroke: 0.5pt + gray, inset: 5pt)
#show table.cell.where(y: 0): strong

#let result(content) = box(stroke: blue, fill: blue.transparentize(75%), inset: 0.5em, radius: 0.25em)[#content]

#let r(d, digits: 3) = calc.round(d, digits: digits)

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

#h(1fr) Manyara Kevin Omenyi \
#h(1fr) Fabian Hernandez \
#h(1fr) Vladimir Borel \

= 4 Star

== 1. What are the problems faced by Four Star Industries in their mattress manufacturing operations?

*Drivers*

- Intensifying competition
- Product proliferation
- Dealers no longer taking care of logistics (stock)

*Operational*

- Fill rate decrease (70% to 60%) 
- Warehouse space up from 5k to 45k sq ft
- Stockouts and excess stock at the same time
- Difficult scheduling
- Orders taken by fax / phone
- No forecasts from dealers.

*Consequences*

- Operating losses (revenue down from \$9M to \$6M) 
- Staff threatening to quit

== 2. How does the proliferation of mattress varieties impact Four Star's operations?

- Demand was split across 230 SKUs

$
  "CV" = sigma / mu
  
$

== 3. Analyze the various courses of action that Sia Meng is contemplating to solve Four Star's operational problems. How effective will these actions be? 

- Reduce number of SKUs
- Making dealers order full batches
- Cutting safety stock
- Moving production offshore

== 4. Discuss possible ways in which Four Star can reconfigure its product design, manufacturing and order fulfilment. How will this help to solve its operational problems? Please use qualitative and quantitative analysis to support your recommendations. 

  1. Product design
  
  2. Manufacturing
  
  3. Order fulfilment