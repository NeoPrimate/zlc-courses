// Hilton Manufacturing Company: case analysis
// Every number in the text is computed by Typst from the data below.

#set document(title: "Hilton Manufacturing Company: Case Analysis", author: "Vladimir Borel")
#set page(paper: "a4", margin: (x: 2.2cm, y: 2.2cm), numbering: "1")
#set par(justify: false)
#set heading(numbering: "1.")
#show heading.where(level: 1): it => { v(0.6em); it; v(0.3em) }
#set table(stroke: 0.4pt + luma(170), inset: 5pt)
#show table.cell.where(y: 0): strong
#set text(font: "Helvetica", size: 8pt, lang: "en")
#show table: it => align(center, it)

// ─────────────────────────────────────────────────────────────
// 1. Helpers
// ─────────────────────────────────────────────────────────────

// Format a number with thousands separators and `d` decimals.
#let fmt(x, d: 0) = {
  let neg = x < 0
  let scale = calc.pow(10, d)
  let total = int(calc.round(calc.abs(x) * scale))
  let ip = calc.quo(total, scale)
  let fp = calc.rem(total, scale)
  let s = str(ip)
  let n = s.len()
  let out = ""
  for (i, c) in s.clusters().enumerate() {
    if i > 0 and calc.rem(n - i, 3) == 0 { out += "," }
    out += c
  }
  if d > 0 {
    let f = str(fp)
    while f.len() < d { f = "0" + f }
    out += "." + f
  }
  if neg and total != 0 { "−" + out } else { out }
}
#let usd(x, d: 2) = if x < 0 { "−$" + fmt(-x, d: d) } else { "$" + fmt(x, d: d) }   // dollars
#let kusd(x) = if x < 0 { "−$" + fmt(-x) + "K" } else { "$" + fmt(x) + "K" }       // thousands of dollars
#let pct(x, d: 1) = fmt(x * 100, d: d) + "%"
#let spct(x) = if x > 0 { "+" + pct(x) } else { pct(x) }                         // signed percent

// ─────────────────────────────────────────────────────────────
// 2. Data (from the case exhibits)
// ─────────────────────────────────────────────────────────────

// Cost lines. kind: "var" = changes with volume, "fixed" = does not (Exhibit 3),
// "mixed" = part variable, part fixed (compensation insurance, see comp-rate).
#let items = (
  (key: "rent",  name: "Rent",                   kind: "fixed"),
  (key: "tax",   name: "Property taxes",         kind: "fixed"),
  (key: "pins",  name: "Property insurance",     kind: "fixed"),
  (key: "comp",  name: "Compensation insurance", kind: "mixed"),
  (key: "dl",    name: "Direct labor",           kind: "var"),
  (key: "il",    name: "Indirect labor",         kind: "fixed"),
  (key: "power", name: "Power",                  kind: "var"),
  (key: "light", name: "Light and heat",         kind: "fixed"),
  (key: "bldg",  name: "Building service",       kind: "fixed"),
  (key: "mat",   name: "Materials",              kind: "var"),
  (key: "sup",   name: "Supplies",               kind: "var"),
  (key: "rep",   name: "Repairs",                kind: "var"),
  (key: "sell",  name: "Selling expense",        kind: "fixed"),
  (key: "ga",    name: "General administration", kind: "fixed"),
  (key: "dep",   name: "Depreciation",           kind: "fixed"),
  (key: "int",   name: "Interest",               kind: "fixed"),
)
#let var-items   = items.filter(i => i.kind in ("var", "mixed"))
#let fixed-items = items.filter(i => i.kind in ("fixed", "mixed"))

// Compensation insurance = 5% of (direct labor + indirect labor) (Exhibit 3).
// Direct labor is variable, indirect labor is fixed. So only 5% of direct labor
// is variable. The rest of the line is fixed.
#let comp-rate = 0.05
#let comp-item = items.find(i => i.key == "comp")

// Split one cost line into its variable and fixed parts.
// `costs` can be per cwt (a product) or a company total: the rule is the same.
#let var-part(costs, i) = if i.kind == "var" { costs.at(i.key) } else if i.kind == "mixed" { comp-rate * costs.dl } else { 0 }
#let fixed-part(costs, i) = costs.at(i.key) - var-part(costs, i)

// Products: price, cash discount, cost per cwt (Exhibit 2), units sold (Exhibits 2 and 4).
// Note: Exhibit 2 prints 2003 units of 103 as "86,974". That is a typo:
// $6,986K / $7.0787 per cwt = 986,974 cwt.
#let products = (
  "101": (
    quoted: 9.41, disc: 0.0108, units03: 2132191, units04: 996859, other: 0.0184,
    cost: (rent: 0.3383, tax: 0.1125, pins: 0.0941, comp: 0.1486, dl: 2.3282,
           il: 0.7941, power: 0.0403, light: 0.0269, bldg: 0.0180, mat: 1.3766,
           sup: 0.0941, rep: 0.0319, sell: 1.6397, ga: 0.6209, dep: 1.0172, int: 0.0941),
  ),
  "102": (
    quoted: 9.91, disc: 0.0222, units03: 1029654, units04: 712102, other: 0.0192,
    cost: (rent: 0.5856, tax: 0.1862, pins: 0.1486, comp: 0.1620, dl: 2.2740,
           il: 0.7903, power: 0.0929, light: 0.0472, bldg: 0.0288, mat: 1.7572,
           sup: 0.1774, rep: 0.0557, sell: 1.7069, ga: 0.4850, dep: 1.5955, int: 0.1490),
  ),
  "103": (
    quoted: 10.56, disc: 0.0172, units03: 986974, units04: 501276, other: 0.0192,
    cost: (rent: 0.7273, tax: 0.1555, pins: 0.2047, comp: 0.1747, dl: 2.6746,
           il: 0.8947, power: 0.1171, light: 0.0392, bldg: 0.0288, mat: 1.8862,
           sup: 0.1363, rep: 0.0396, sell: 1.8286, ga: 0.6904, dep: 1.4223, int: 0.2043),
  ),
)
#let names = products.keys()

// Company totals in $ thousands: full year 2003 (Exhibits 1 and 2) and H1 2004 actual (Exhibit 4).
#let year2003 = (
  sales: 40068, other: 78,
  cost: (rent: 2042, tax: 585, pins: 556, comp: 656, dl: 9945, il: 3390, power: 298,
         light: 145, bldg: 96, mat: 6606, sup: 519, rep: 164, sell: 7059, ga: 2505,
         dep: 5216, int: 556),
)
#let h1-2004 = (
  sales: 21382, other: 42,
  cost: (rent: 1021, tax: 307, pins: 278, comp: 348, dl: 5308, il: 1721, power: 170,
         light: 83, bldg: 50, mat: 3544, sup: 288, rep: 88, sell: 3706, ga: 1378,
         dep: 2686, int: 290),
)
#let h1-2004-profit-reported = 158   // Exhibit 4, $K

// Product 101 decision, January 2005.
#let decision = (
  hold: (label: "Keep price", price: 9.41, volume: 750000),
  cut:  (label: "Cut price",  price: 8.64, volume: 1000000),
  cost-change: (mat: 1.05, sup: 1.05),   // materials and supplies +5%
)

// ─────────────────────────────────────────────────────────────
// 3. Calculations
// ─────────────────────────────────────────────────────────────

#let net-price(p, price: none) = {
  let q = if price == none { p.quoted } else { price }
  q * (1 - p.disc)
}
// Variable cost per cwt. `adj` multiplies some lines (e.g. +5% materials).
#let var-cost(p, adj: (:)) = var-items.map(i => var-part(p.cost, i) * adj.at(i.key, default: 1.0)).sum()
#let fixed-cost(p) = fixed-items.map(i => fixed-part(p.cost, i)).sum()
#let full-cost(p) = var-cost(p) + fixed-cost(p) - p.other
#let cm(p) = net-price(p) - var-cost(p)          // contribution margin per cwt
#let cm-per-dl(p) = cm(p) / p.cost.dl             // CM per $ of direct labor

// Company period summary ($K). `f` scales the period (0.5 = half a year).
#let summary(per, f: 1) = {
  let v = var-items.map(i => var-part(per.cost, i)).sum() * f
  let fx = fixed-items.map(i => fixed-part(per.cost, i)).sum() * f
  let s = per.sales * f
  let o = per.other * f
  (sales: s, var: v, cm: s - v, fixed: fx, other: o, profit: s - v - fx + o)
}

#let p101 = products.at("101")
#let p103 = products.at("103")

// Q1
#let q1-lost-sales = p103.units04 * net-price(p103) / 1000
#let q1-saved-var  = p103.units04 * var-cost(p103) / 1000
#let q1-lost-cm    = q1-lost-sales - q1-saved-var
#let q1-new-profit = h1-2004-profit-reported - q1-lost-cm
#let q1-loss-per-cwt = net-price(p103) - full-cost(p103)

// Q2
#let new-var-101 = var-cost(p101, adj: decision.cost-change)
#let scenario(s) = {
  let np = net-price(p101, price: s.price)
  let unit-cm = np - new-var-101
  (label: s.label, price: s.price, volume: s.volume, net: np, unit-cm: unit-cm,
   total-cm: unit-cm * s.volume / 1000, below-cost: np < full-cost(p101))
}
#let hold = scenario(decision.hold)
#let cut  = scenario(decision.cut)
#let q2-gain = cut.total-cm - hold.total-cm
#let q2-breakeven = hold.total-cm * 1000 / cut.unit-cm
#let q2-dl-cut = cut.volume * p101.cost.dl / 1000
#let q2-dl-h1  = p101.units04 * p101.cost.dl / 1000

// Q3
#let best-by(f) = names.sorted(key: n => f(products.at(n))).last()
#let worst-by(f) = names.sorted(key: n => f(products.at(n))).first()
#let best-cm = best-by(cm)
#let best-dl = best-by(cm-per-dl)
#let worst-dl = worst-by(cm-per-dl)

// Q4
#let half03 = summary(year2003, f: 0.5)
#let h104 = summary(h1-2004)
#let units-half03 = names.map(n => products.at(n).units03).sum() / 2
#let units-h104 = names.map(n => products.at(n).units04).sum()
// Variable cost at 2003 cost per cwt, for H1 2004 units.
#let var-standard = names.map(n => {
  let p = products.at(n)
  p.units04 * var-cost(p) / 1000
}).sum()
// Fixed cost that the standard-cost system "charged" in H1 2004 = units × fixed cost per cwt.
#let fixed-charged = names.map(n => {
  let p = products.at(n)
  p.units04 * fixed-cost(p) / 1000
}).sum()

// ─────────────────────────────────────────────────────────────
// 4. Document
// ─────────────────────────────────────────────────────────────

#h(1fr) Manyara Kevin Omenyi \
#h(1fr) Vladimir Borel \
#h(1fr) Fabian Hernández Leiva

#align(center)[
  #text(size: 18pt, weight: "bold")[Hilton Manufacturing Company]
]

#v(0.5em)

- A cost is *variable* if it goes up when we produce more units, and down when we produce less units (e.g.,  materials)
- A cost is *fixed* if it does not vary with the number of units produced (e.g., rent)
- Exhibit 3 gives us which costs are variable and which costs are fixed
- *Contribution margin (CM)* = price − variable cost
- CM is the money each unit sale brings in to pay the fixed costs
- Whatever is left over is the profit
- Exhibit 2 spreads the fixed costs over the products and calls the result "cost per cwt" (this makes a product look like it loses money even when it does not)
- Since the fixed costs do not go away if we drop a product or change a price, they should be ignored when deciding
- Look only at CM

#table(
  columns: (auto, auto),
  [Variable (changes with volume)], [Fixed (stays the same)],
  var-items.map(i => if i.kind == "mixed" [#i.name (part)] else [#i.name]).join(", "),
  fixed-items.map(i => if i.kind == "mixed" [#i.name (part)] else [#i.name]).join(", "),
)

- Exhibit 3 calls compensation insurance "variable", but also says it is 5% of *direct labor + indirect labor*
- Direct labor is variable, but indirect labor is fixed
- So only the part that comes from direct labor changes with volume
- *Variable part* = 5% × direct labor, *fixed part* = the rest
- 5% × (direct + indirect labor) is close to the Exhibit 2 figure, so the 5% rule is fair

#figure(
  table(
    columns: (auto,) + names.map(_ => 1fr),
    align: (left,) + names.map(_ => right),
    [Line], ..names.map(n => [Product #n]),
    [Direct labor], ..names.map(n => usd(products.at(n).cost.dl, d: 4)),
    [Indirect labor], ..names.map(n => usd(products.at(n).cost.il, d: 4)),
    [5% × (direct + indirect)], ..names.map(n => usd(comp-rate * (products.at(n).cost.dl + products.at(n).cost.il), d: 4)),
    [Compensation insurance (Exhibit 2)], ..names.map(n => usd(products.at(n).cost.comp, d: 4)),
    [*Variable part* (5% × direct labor)], ..names.map(n => strong(usd(var-part(products.at(n).cost, comp-item), d: 4))),
    [Fixed part (the rest)], ..names.map(n => usd(fixed-part(products.at(n).cost, comp-item), d: 4)),
  ),
  caption: [Compensation insurance split (\$ per cwt)]
)

- *Net price* = price - cash discounts as percentage of the price

#figure(
  table(
    columns: (auto,) + names.map(_ => 1fr),
    align: (left,) + names.map(_ => right),
    [Line], ..names.map(n => [Product #n]),
    [Quoted price], ..names.map(n => usd(products.at(n).quoted, d: 4)),
    [− Cash discount], ..names.map(n => pct(products.at(n).disc, d: 2)),
    [\= Net price], ..names.map(n => usd(net-price(products.at(n)), d: 4)),
    ..var-items.map(i => ([− #i.name#if i.kind == "mixed" [ (variable part)]], ..names.map(n => usd(var-part(products.at(n).cost, i), d: 4)))).flatten(),
    [*\= Contribution margin*], ..names.map(n => strong(usd(cm(products.at(n)), d: 4))),
    [Fixed cost per cwt (allocated)], ..names.map(n => usd(fixed-cost(products.at(n)), d: 4)),
    ["Full cost" per cwt (Exhibit 2)], ..names.map(n => usd(full-cost(products.at(n)), d: 4)),
    [Units sold 2003 (cwt)], ..names.map(n => fmt(products.at(n).units03)),
    [Units sold H1 2004 (cwt)], ..names.map(n => fmt(products.at(n).units04)),
  ),
  caption: [CM for each product (\$ per cwt)]
)

- Every product has a positive CM. Therefore, each cwt we sell helps pay the fixed costs.
- We think there is an error: Exhibit 2 shows 2003 units of product 103 as "86,974". It should be \$6,986K ÷ \$7.0787 per cwt ≈ #fmt(6986 / 7.0787)K cwt
- We assume the right number to be 986,974

= What if we had dropped product 103 on 1 January 2004?

- Paul Hilton wants to drop 103 because Exhibit 2 says it loses #usd(-q1-loss-per-cwt) per cwt
- However this "loss" includes fixed costs (rent, depreciation, selling, etc.)
- Fixed costs would remain unchanged if we dropped 103, the company would still pay them
- If we drop 103, we lose its sales: #fmt(p103.units04) cwt × #usd(net-price(p103), d: 4) = *#kusd(q1-lost-sales)*
- We only save its variable costs: #fmt(p103.units04) cwt × #usd(var-cost(p103), d: 4) = *#kusd(q1-saved-var)*
- Net effect: we lose #kusd(q1-lost-sales) − #kusd(q1-saved-var) = *#kusd(q1-lost-cm)* of contribution
- Profit for H1 2004 would go from #kusd(h1-2004-profit-reported) to #kusd(h1-2004-profit-reported) − #kusd(q1-lost-cm) = *#kusd(q1-new-profit)*

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  Dropping 103 would have made a #kusd(h1-2004-profit-reported) profit into a #kusd(-q1-new-profit) loss. Product 103 should be kept.
]

= Should we cut the price of 101 from \$9.41 to \$8.64?

- *New variable cost.* The materials and supplies go up 5%. Light and heat goes up 7%, but it is a fixed cost, so it is the same in both options
  - Materials: #usd(p101.cost.mat, d: 4) × 1.05 = #usd(p101.cost.mat * 1.05, d: 4)
  - Supplies: #usd(p101.cost.sup, d: 4) × 1.05 = #usd(p101.cost.sup * 1.05, d: 4)
  - New variable cost: #usd(var-cost(p101), d: 4) → *#usd(new-var-101, d: 4)* per cwt
- Comparing the two options:

#table(
  columns: (auto, 1fr, 1fr),
  align: (left, right, right),
  [Line], [#hold.label (\$#hold.price)], [#cut.label (\$#cut.price)],
  [Quoted price], usd(hold.price), usd(cut.price),
  [Net price (after #pct(p101.disc, d: 2) discount)], usd(hold.net, d: 4), usd(cut.net, d: 4),
  [− Variable cost], usd(new-var-101, d: 4), usd(new-var-101, d: 4),
  [\= CM per cwt], usd(hold.unit-cm, d: 4), usd(cut.unit-cm, d: 4),
  [\× Volume (cwt, 6 months)], fmt(hold.volume), fmt(cut.volume),
  [*\= Total CM*], strong(kusd(hold.total-cm)), strong(kusd(cut.total-cm)),
)

- The difference is #kusd(cut.total-cm) − #kusd(hold.total-cm) = *#kusd(q2-gain)* #if q2-gain > 0 [in favour of cutting the price of 101] else [in favour of keeping the price of 101]
- Keeping the price gives #kusd(hold.total-cm)
- To beat that at \$#cut.price, we need #kusd(hold.total-cm) ÷ #usd(cut.unit-cm, d: 4) = *#fmt(q2-breakeven) cwt* (Weston expects #fmt(cut.volume) cwt, so we have some room)
- Direct labor for #fmt(cut.volume) cwt = #kusd(q2-dl-cut). In H1 2004, product 101 already used #kusd(q2-dl-h1). That stays approximately the same, so the plant can has the capacity
- The full cost of 101 is #usd(full-cost(p101), d: 4) per cwt, so \$#cut.price looks "below cost". But the fixed part of that full cost is paid either way. It does not change the decision
// - *Competitors.* Catalyst leads prices and the others usually follow. If Hilton keeps \$#hold.price alone, it will likely lose volume

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  #if q2-gain > 0 [Yes. Cutting the price earns about #kusd(q2-gain) more contribution in six months.] else [No. Keeping the price earns about #kusd(-q2-gain) more.]
]

= Which product is the most profitable?

- Acording to exhibit 2 only 101 makes money. That is wrong, because there, it spreads fixed costs over the products.
- If we look at the CM per cwt instead we get the right measure if the plant has spare capacity.
- In case the plant capacity is full, what matters is CM per unit of capacity. The case says direct labor dollars measure capacity. So we compute CM ÷ direct labor per cwt.

#table(
  columns: (auto,) + names.map(_ => 1fr),
  align: (left,) + names.map(_ => right),
  [Measure], ..names.map(n => [Product #n]),
  [Profit per cwt (Exhibit 2)], ..names.map(n => usd(net-price(products.at(n)) - full-cost(products.at(n)), d: 4)),
  [CM per cwt], ..names.map(n => usd(cm(products.at(n)), d: 4)),
  [Direct labor per cwt], ..names.map(n => usd(products.at(n).cost.dl, d: 4)),
  [CM per \$1 of direct labor], ..names.map(n => usd(cm-per-dl(products.at(n)), d: 3)),
)

- The highest CM per cwt is *product #best-cm* (#usd(cm(products.at(best-cm)), d: 4)).
- The highest CM per \$1 of direct labor is *product #best-dl* (#usd(cm-per-dl(products.at(best-dl)), d: 3)). (Products 101 and 102 are almost the same here. Lowest: product #worst-dl).

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  It depends on capacity
  - If there is spare capacity (like now, with a weak market): product #best-cm is the most profitable
  - If the plant is full: products 101 and 102 are best (about the same). Product #worst-dl is the weakest
]

= Why did Hilton make a profit in H1 2004?

- For same period comparison, H1 2004 is compared with half of 2003 (2003 ÷ 2).

#table(
  columns: (auto, 1fr, 1fr, 1fr),
  align: (left, right, right, right),
  [Line], [Half of 2003], [H1 2004], [Change],
  [Units sold (cwt)], fmt(units-half03), fmt(units-h104), fmt(units-h104 - units-half03),
  [Net sales], kusd(half03.sales), kusd(h104.sales), kusd(h104.sales - half03.sales),
  [− Variable costs], kusd(half03.var), kusd(h104.var), kusd(h104.var - half03.var),
  [*\= Contribution margin*], strong(kusd(half03.cm)), strong(kusd(h104.cm)), strong(kusd(h104.cm - half03.cm)),
  [− Fixed costs], kusd(half03.fixed), kusd(h104.fixed), kusd(h104.fixed - half03.fixed),
  [\+ Other income], kusd(half03.other), kusd(h104.other), kusd(h104.other - half03.other),
  [*\= Profit*], strong(kusd(half03.profit)), strong(kusd(h104.profit)), strong(kusd(h104.profit - half03.profit)),
)

- Hilton sold #fmt(units-h104 - units-half03) more units, an increase of #spct(units-h104 / units-half03 - 1).
- The units sold changed as follows:
  #list(..names.map(n => [Product #n: #fmt(products.at(n).units03 / 2) to #fmt(products.at(n).units04) cwt (#spct(products.at(n).units04 / (products.at(n).units03 / 2) - 1))]))
- This increased volume gave #kusd(h104.cm - half03.cm) higher in contribution margin.
- The costs fixed costs increased by #kusd(h104.fixed - half03.fixed) and variable costs were about #kusd(h104.var). At 2003 cost per cwt, they would have been #kusd(var-standard), about the same.
- In standard costing report, they have fixed cost per unit, and therefore with more units sold, they charge #kusd(fixed-charged) of fixed cost against the real fixed cost of #kusd(h104.fixed). The difference, #kusd(fixed-charged - h104.fixed) is the effect of selling more units (not a saving).

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  Therefore, Hilton made a profit because it sold more units, (more of 102, which Exhibit 2 said was loss making. The contribution margin increased by #kusd(h104.cm - half03.cm) while fixed costs rose by #kusd(h104.fixed - half03.fixed).
]

= Summary

- *Q1:* Dropping 103 would have cost about #kusd(q1-lost-cm). Profit would have been #kusd(q1-new-profit).
- *Q2:* Cut the price of 101 to \$#cut.price. It earns about #kusd(q2-gain) more.
- *Q3:* With spare capacity: product #best-cm. With a full plant: 101 and 102.
- *Q4:* Higher volume and a better mix, not cost savings.
- *Main lesson:* Decide with contribution margin. Fixed costs spread over products lead to wrong decisions.

Activity based costing v. Standard costing

Standard cost:
- Rule for allocating costs to fixed costs
- 


Main steps:
- Variable (increases with production volume) v. Fixed (decreases with production volume -> economies of scale)
- 
