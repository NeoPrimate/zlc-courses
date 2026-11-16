#set text(font: "Helvetica", size: 8pt, lang: "en")
#set par(justify: true)
#show heading.where(level: 1): set block(above: 1.6em, below: 0.9em)
#set table(stroke: 0.4pt + luma(170), inset: 5pt)
#show table.cell.where(y: 0): strong
#show table: it => align(center, it)

#let fmt(x, d: 2) = {
  let p = calc.pow(10, d)
  let total = int(calc.round(calc.abs(float(x)) * p))
  let ip = calc.quo(total, p)
  let fp = calc.rem(total, p)
  let s = str(ip).clusters().rev()
  let out = ""
  for (i, c) in s.enumerate() {
    if i > 0 and calc.rem(i, 3) == 0 { out = "," + out }
    out = c + out
  }
  let frac = if d > 0 { let f = str(fp); "." + "0" * (d - f.len()) + f } else { "" }
  (if x < 0 and total != 0 { "-" } else { "" }) + out + frac
}

#let usd(x, d: 2) = [\$#fmt(x, d: d)]

#let sjoin(arr, d: 0) = arr.enumerate().map(((k, v)) => if k == 0 { fmt(v, d: d) } else if v < 0 { " - " + fmt(-v, d: d) } else { " + " + fmt(v, d: d) }).join()

#let mean(a) = a.sum() / a.len()

#let regress(x, y) = {
  let mx = mean(x)
  let my = mean(y)
  let sxy = x.zip(y).map(((u, v)) => (u - mx) * (v - my)).sum()
  let sxx = x.map(u => calc.pow(u - mx, 2)).sum()
  let b = sxy / sxx
  (a: my - b * mx, b: b, mx: mx, my: my, sxy: sxy, sxx: sxx)
}

#h(1fr) Vladimir Borel

#align(center)[
  #text(size: 15pt, weight: "bold")[Assignment 4] \
  #v(2pt)
]

= Problem 1 (Max Points 20)

#let p1 = (
  qty: 12, loan: 2500, rate: 0.12, n-pay: 6,
  loom: 2000, dep-months: 24,
  thread: 250, transport: 100, stall: 60, price: 350,
)
#let p1-cm = p1.price - p1.thread
#let p1-dep = p1.loom / p1.dep-months
#let p1-int = p1.loan * p1.rate / 12
#let p1-principal = p1.loan / p1.n-pay
#let p1-fixed = p1-dep + p1-int + p1.transport + p1.stall
#let p1-bep = p1-fixed / p1-cm
#let p1-profit = p1.qty * p1-cm - p1-fixed
// after the loan is repaid (months 7–24) there is no interest
#let p1-profit-after = p1.qty * p1-cm - (p1-fixed - p1-int)
#let p1-profit-avg24 = (p1.n-pay * p1-profit + (p1.dep-months - p1.n-pay) * p1-profit-after) / p1.dep-months

*a. The contribution margin per $m^2$ of hand-woven cloth. (10 points)*

- The only cost that changes with each $m^2$ produced is thread (#usd(p1.thread, d: 0)/$m^2$)
- Transportation and stall rental are fixed costs (paid every month whatever the output)
- CM per $m^2$ = Price - Variable cost = #usd(p1.price, d: 0) - #usd(p1.thread, d: 0) = #usd(p1-cm, d: 0) per $m^2$

*b. The break-even point in $m^2$ and the average profit per month. (10 points)*

Fixed costs:

#table(
  columns: (auto, auto, auto),
  align: (left, left, right),
  table.header([*Item*], [*Calculation*], [*\$ / month*]),
  [Loom depreciation], [#usd(p1.loom, d: 0) / #p1.dep-months months], [#fmt(p1-dep)],
  [Interest], [#usd(p1.loan, d: 0) × #(calc.round(p1.rate * 100))% / 12 (on original amount)], [#fmt(p1-int)],
  [Transportation], [given], [#fmt(p1.transport)],
  [Stall rental], [given], [#fmt(p1.stall)],
  table.cell(colspan: 2)[*Total fixed costs*], [*#fmt(p1-fixed)*],
)

- The principal repayment (#usd(p1-principal)) is not a cost
- Only the interest is a cost
- Break-even point = Fixed costs / CM per $m^2$ = #fmt(p1-fixed) / #fmt(p1-cm, d: 0) = #fmt(p1-bep) $m^2$ per month
- Profit = #p1.qty $m^2$ × #usd(p1-cm, d: 0) - #usd(p1-fixed) = #usd(p1-profit) per month (outstanding loan of months 1 to #p1.n-pay)
- After the loan is repaid (no interest), profit rises to #usd(p1-profit-after) (months #(p1.n-pay + 1) to #p1.dep-months)
- Average (over the loom's full #p1.dep-months months): (#p1.n-pay × #fmt(p1-profit) + #(p1.dep-months - p1.n-pay) × #fmt(p1-profit-after)) / #p1.dep-months = #usd(p1-profit-avg24) per month

= Problem 2 (Max Points 15)

#let months = ("JAN", "FEB", "MAR")
#let units-sold = (250, 400, 300)
#let sales = (6250, 10000, 7500)
#let cogs = (3000, 4200, 3500)
#let gross-margin = (3250, 5800, 4000)
#let operating-expenses = (1000, 1450, 1000)
#let net-income = (2250, 4350, 3000)

#table(
  columns: 4,
  align: (left, right, right, right),
  table.header([], ..months.map(m => [*#m*])),
  [Number of units sold], ..units-sold.map(v => [#fmt(v, d: 0)]),
  [Sales], ..sales.map(v => [#fmt(v, d: 0)]),
  [Cost of Goods Sold], ..cogs.map(v => [#fmt(v, d: 0)]),
  [Gross Margin], ..gross-margin.map(v => [#fmt(v, d: 0)]),
  [Operating expenses], ..operating-expenses.map(v => [#fmt(v, d: 0)]),
  [Net Income], ..net-income.map(v => [#fmt(v, d: 0)]),
)

#let r-cogs = regress(units-sold, cogs)
#let r-opex = regress(units-sold, operating-expenses)
#let p2-price = mean(sales.zip(units-sold).map(((s, u)) => s / u))
#let p2-vc = r-cogs.b + r-opex.b
#let p2-cm-unit = p2-price - p2-vc

*a. Using regression analysis, calculate the fixed and variable cost elements for "COGS" and "operating expenses". (10 points)*

- Cost driver: number of units sold ($x$)
-  Model: Cost = $beta_0 + beta_1 x$, where $beta_0$ (intercept) is fixed cost per month and $beta_1$ (slope) is the per unit variable cost
- Where: 

$
  beta_1 = (sum (x - overline(x))(y - overline(y))) / (sum (x - overline(x))^2)
$ 

and 
$
  beta_0 = overline(y) - b overline(x)
$

- Mean units sold $overline(x)$ = #fmt(r-cogs.mx), and $sum (x - overline(x))^2$ = #fmt(r-cogs.sxx)

#table(
  columns: 3,
  align: (left, right, right),
  table.header([], [*COGS*], [*Operating expenses*]),
  [$overline(y)$ (mean cost)], [#fmt(r-cogs.my)], [#fmt(r-opex.my)],
  [$sum (x - overline(x))(y - overline(y))$], [#fmt(r-cogs.sxy)], [#fmt(r-opex.sxy)],
  [Variable cost per unit ($beta_1$)], [#usd(r-cogs.b, d: 3)], [#usd(r-opex.b, d: 3)],
  [Fixed cost per month ($beta_0$)], [#usd(r-cogs.a)], [#usd(r-opex.a)],
)

- $"COGS" = #fmt(r-cogs.a) + #fmt(r-cogs.b, d: 3) x$
- $"Operating expenses" = #fmt(r-opex.a) + #fmt(r-opex.b, d: 3) x$

*b. Calculate the contribution margin for the months JAN, FEB, and MAR. (5 points)*

- Selling price = Sales / Units = #usd(p2-price) per unit
- Total variable cost per unit $= b_"COGS" + b_"OpEx"$ = #fmt(r-cogs.b, d: 3) + #fmt(r-opex.b, d: 3) = #usd(p2-vc, d: 3).
- Contribution margin $= "Sales" - "Units" times "VC"_"unit"$
  - $"Per unit Price" - "VC"_"unit"$ = #usd(p2-price) − #usd(p2-vc, d: 3) = #usd(p2-cm-unit) per unit

#table(
  columns: 4,
  align: (left, right, right, right),
  table.header([], ..months.map(m => [*#m*])),
  [Sales], ..sales.map(v => [#fmt(v)]),
  [Variable COGS], ..units-sold.map(u => [#fmt(u * r-cogs.b)]),
  [Variable operating expenses], ..units-sold.map(u => [#fmt(u * r-opex.b)]),
  [Contribution margin], ..sales.zip(units-sold).map(((s, u)) => [#fmt(s - u * p2-vc)]),
)

= Problem 3 (Max Points 25)

#let products = ("A", "B", "C", "D", "E")
#let p3-sales = (30, 40, 20, 10, 20)
#let variable-costs = (12, 8, 21, 8, 14)
#let contribution-margin = (18, 32, -1, 2, 6)
#let fixed-costs-I = (3, 3, 2, 3, 4)
#let fixed-costs-II = (6, 8, 4, 2, 4)
#let operating-margin = (9, 21, -7, -3, -2)

#let idx = range(products.len())
#let row(label, arr) = ([#label], ..arr.map(v => [#fmt(v, d: 0)]))

#table(
  columns: products.len() + 1,
  align: (left,) + (right,) * products.len(),
  table.header([], ..products.map(p => [*#p*])),
  ..row("Sales", p3-sales),
  ..row("Variable costs", variable-costs),
  ..row("Contribution margin", contribution-margin),
  ..row("Fixed costs I", fixed-costs-I),
  ..row("Fixed costs II", fixed-costs-II),
  ..row("Operating margin", operating-margin),
)

#let total-om(removed) = idx.map(i => if i in removed { -fixed-costs-II.at(i) } else { operating-margin.at(i) }).sum()
#let names(s) = s.map(i => products.at(i)).join(", ")

#let om-now = operating-margin.sum()

#let avoidable = idx.map(i => contribution-margin.at(i) - fixed-costs-I.at(i))
#let neg-om = idx.filter(i => operating-margin.at(i) < 0)
#let drop = idx.filter(i => avoidable.at(i) < 0)
#let om-a = total-om(neg-om)
#let om-c = total-om(drop)

*a. If products having negative operating margin are removed, what is total operating margin? (8 points)*

- Current total operating margin = #sjoin(operating-margin) = #fmt(om-now, d: 0)
- Negative operating margin products: #names(neg-om)
- If they are removed
  - Revenue, variable and fixed costs I disappear
  - Fixed costs II (#neg-om.map(i => fmt(fixed-costs-II.at(i), d: 0)).join(" + ") = #fmt(neg-om.map(i => fixed-costs-II.at(i)).sum(), d: 0)) remain
- Total operating margin = operating margin of kept products - fixed costs II of removed products = #sjoin(idx.filter(i => i not in neg-om).map(i => operating-margin.at(i))) - #fmt(neg-om.map(i => fixed-costs-II.at(i)).sum(), d: 0) = #fmt(om-a, d: 0).

*b. Which products, if any, should be removed to maximize profit? Briefly explain why (10 points)*

- Fixed costs II are paid whether a product is kept or not, so they do not matter for the decision.
- A product is worth keeping if its contribution margin covers its own avoidable fixed costs (type I), i.e. if CM - FC I > 0.

#table(
  columns: products.len() + 1,
  align: (left,) + (right,) * products.len(),
  table.header([], ..products.map(p => [*#p*])),
  ..row("Contribution margin", contribution-margin),
  ..row("- Fixed costs I (saved if removed)", fixed-costs-I),
  [$=$ Margin lost (if removed)], ..avoidable.map(v => [#fmt(v, d: 0)]),
  [Decision], ..avoidable.map(v => if v < 0 [Remove] else [Keep]),
)

- Remove #names(drop): contribution margin is smaller than the fixed costs I they incur
#for i in idx.filter(i => operating-margin.at(i) < 0 and avoidable.at(i) >= 0) [
  - Keep #products.at(i), even though its operating margin is negative (#fmt(operating-margin.at(i), d: 0)): its CM (#fmt(contribution-margin.at(i), d: 0)) covers its fixed costs I (#fmt(fixed-costs-I.at(i), d: 0)) and leaves #fmt(avoidable.at(i), d: 0) to help pay the fixed costs II, which we pay anyways
]
- Keep #names(idx.filter(i => operating-margin.at(i) >= 0)) as they are profitable

*c. If the products you suggest were removed, what would the total operating margin be? (7 points)*

- Removing a product changes profit by -(CM - FC I).
- New total = #fmt(om-now, d: 0) #sjoin(drop.map(i => -avoidable.at(i))).replace(regex("^"), "+ ") = #fmt(om-c, d: 0).

= Problem 4 (Max Points 40)

#let p4-products = ("A", "B")
#let price = (25, 35)
#let variable-cost = (17, 23)
#let fixed-costs = (2, 3)
#let machine-time = (2, 4)

#let p4-idx = range(p4-products.len())
#let total-fixed = 50000
#let demand = (10000, 10000)
#let hours = 30000
#let supplier-price = (20, 31)

#table(
  columns: 3,
  align: (left, right, right),
  table.header([], [*A*], [*B*]),
  [Price (\$ per unit)], ..price.map(v => [#v]),
  [Variable cost (\$ per unit)], ..variable-cost.map(v => [#v]),
  [Fixed cost (\$ per unit)], ..fixed-costs.map(v => [#v]),
  [Time required in machine M (hours per unit)], ..machine-time.map(v => [#v]),
)

// Contribution margins
#let cm = p4-idx.map(i => price.at(i) - variable-cost.at(i))
#let cm-h = p4-idx.map(i => cm.at(i) / machine-time.at(i))

// Allocate machine hours to products in order of the given score (highest first)
#let allocate(score) = {
  let order = p4-idx.filter(i => score.at(i) > 0).sorted(key: i => -score.at(i))
  let units = (0,) * p4-idx.len()
  let left = hours
  for i in order {
    let u = calc.min(demand.at(i), calc.floor(left / machine-time.at(i)))
    units.at(i) = u
    left -= u * machine-time.at(i)
  }
  units
}

#let make1 = allocate(cm-h)
#let cm1 = p4-idx.map(i => make1.at(i) * cm.at(i)).sum()
#let profit1 = cm1 - total-fixed
#let normal-hours = p4-idx.map(i => demand.at(i) * machine-time.at(i)).sum()

*1. At the end of November, a machine breakdown reduces the total number of machine hours available in December to 30,000. Since not all the demand can be satisfied, how many units of product A and product B would you produce to maximize profit? Briefly explain why. (20 points)*

- Meeting all demand would need #p4-idx.map(i => fmt(demand.at(i), d: 0) + " × " + str(machine-time.at(i))).join(" + ") = #fmt(normal-hours, d: 0) hours
- Only #fmt(hours, d: 0) are available
- Machine time is the bottleneck
- The allocated fixed cost (\$#fmt(total-fixed, d: 0)) is ignored (paid no matter what we produce)
- Only the contribution margin matters
- Ranking products by contribution margin per unit of the scarce resource (per machine hour)

#table(
  columns: 3,
  align: (left, right, right),
  table.header([], [*A*], [*B*]),
  [CM per unit = Price - Variable cost], ..p4-idx.map(i => [#price.at(i) - #variable-cost.at(i) = #usd(cm.at(i), d: 0)]),
  [Machine hours per unit], ..machine-time.map(v => [#v]),
  [CM per machine hour], ..cm-h.map(v => [#usd(v)]),
  [Units to produce], ..make1.map(v => [#fmt(v, d: 0)]),
  [Hours used], ..p4-idx.map(i => [#fmt(make1.at(i) * machine-time.at(i), d: 0)]),
  [Contribution margin], ..p4-idx.map(i => [#usd(make1.at(i) * cm.at(i), d: 0)]),
)

#let first = p4-idx.sorted(key: i => -cm-h.at(i)).at(0)
#let second = p4-idx.sorted(key: i => -cm-h.at(i)).at(1)
- Product #p4-products.at(first) earns more per machine hour (#usd(cm-h.at(first)) vs #usd(cm-h.at(second))), even though its CM per unit is lower, so it gets the machine first
- Produce #fmt(make1.at(0), d: 0) units of A and #fmt(make1.at(1), d: 0) units of B
- Product #p4-products.at(first) uses #fmt(make1.at(first) * machine-time.at(first), d: 0) hours to meet all demand, the rest #fmt(hours - make1.at(first) * machine-time.at(first), d: 0) hours go to #p4-products.at(second)
- Total CM = #usd(cm1, d: 0). Profit = #usd(cm1, d: 0) - #usd(total-fixed, d: 0) = #usd(profit1, d: 0)

// Contribution margin when buying = price - supplier price
#let cm-buy = p4-idx.map(i => price.at(i) - supplier-price.at(i))
// Extra CM from making instead of buying, per machine hour
#let gain-h = p4-idx.map(i => (cm.at(i) - cm-buy.at(i)) / machine-time.at(i))
#let make2 = allocate(gain-h)
#let buy2 = p4-idx.map(i => if cm-buy.at(i) > 0 { demand.at(i) - make2.at(i) } else { 0 })
#let cm2 = p4-idx.map(i => make2.at(i) * cm.at(i) + buy2.at(i) * cm-buy.at(i)).sum()
#let profit2 = cm2 - total-fixed
// Alternative: keep the Question 1 production plan and buy the rest
#let buy-alt = p4-idx.map(i => demand.at(i) - make1.at(i))
#let cm-alt = p4-idx.map(i => make1.at(i) * cm.at(i) + buy-alt.at(i) * cm-buy.at(i)).sum()

*2. How many units of product A and product B would you buy from the supplier in December to maximize profit? Please use a "contribution margin" approach to develop your answer and explain why (points will be deducted if not). (20 points)*

- Buying and reselling earns a CM of Price - Supplier price
- CM is positive for both products
- All unmet demand should be bought
- We can now sell #fmt(demand.at(0), d: 0) units of each product
- The question is now only which product should use the #fmt(hours, d: 0) machine hours. 
- The machine should be allocated to product where making adds the most CM per machine hour

#table(
  columns: 3,
  align: (left, right, right),
  table.header([], [*A*], [*B*]),
  [CM if made], ..cm.map(v => [#usd(v, d: 0)]),
  [CM if bought = Price - Supplier price], ..p4-idx.map(i => [#price.at(i) - #supplier-price.at(i) = #usd(cm-buy.at(i), d: 0)]),
  [Extra CM from making (per unit)], ..p4-idx.map(i => [#usd(cm.at(i) - cm-buy.at(i), d: 0)]),
  [Machine hours per unit], ..machine-time.map(v => [#v]),
  [*Extra CM from making per machine hour*], ..gain-h.map(v => [*#usd(v)*]),
  [*Units made*], ..make2.map(v => [*#fmt(v, d: 0)*]),
  [*Units bought from supplier*], ..buy2.map(v => [*#fmt(v, d: 0)*]),
  [Contribution margin], ..p4-idx.map(i => [#usd(make2.at(i) * cm.at(i) + buy2.at(i) * cm-buy.at(i), d: 0)]),
)

#let best = p4-idx.sorted(key: i => -gain-h.at(i)).at(0)
#let other = p4-idx.sorted(key: i => -gain-h.at(i)).at(1)
- Each machine hour used instead of buying on
  - #p4-products.at(best): #usd(gain-h.at(best))
  - #p4-products.at(other): #usd(gain-h.at(other))
- The machine should now be used for #p4-products.at(best)
- Make #fmt(make2.at(best), d: 0) units of #p4-products.at(best) (#fmt(make2.at(best) * machine-time.at(best), d: 0) hours) and buy everything else
- Buy #fmt(buy2.at(0), d: 0) units of A and #fmt(buy2.at(1), d: 0) units of B
- Total CM = #usd(cm2, d: 0). Profit = #usd(cm2, d: 0) - #usd(total-fixed, d: 0) = *#usd(profit2, d: 0)*