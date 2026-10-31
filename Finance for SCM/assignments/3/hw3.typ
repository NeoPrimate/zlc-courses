// #set heading(numbering: "1.1.")
#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)

#let payback(cfs) = {
  let cum = cfs.at(0)
  for t in range(1, cfs.len()) {
    if cum + cfs.at(t) >= 0 { return t - 1 + (-cum) / cfs.at(t) }
    cum += cfs.at(t)
  }
  none
}

#let npv(r, cfs) = cfs.enumerate().map(((t, cf)) => cf / calc.pow(1 + r, t)).sum()

#let irr(cfs, lo: 0.0, hi: 1.0) = {
  let (l, h) = (lo, hi)
  for _ in range(100) {
    let mid = (l + h) / 2
    if npv(mid, cfs) > 0 { l = mid } else { h = mid }
  }
  (l + h) / 2
}

#let fmt(x, d: 2) = str(calc.round(x, digits: d))
#let pct(x) = fmt(x * 100) + "%"

#h(1fr) Vladimir Borel

= Problem 1

#let A = (-3400, 0, 0, 6460)
#let B = (-3400, 1870, 1870, 1870)
#let C = (-3400, 1020, 1700, 3284)
#let projects = (A: A, B: B, C: C)

#let dcf(cfs, base) = cfs.enumerate().filter(((t, c)) => c != 0).map(((t, c)) => {
  if t == 0 { return [#c] }
  let den = if t == 1 { base } else { math.attach(base, t: [#t]) }
  math.frac([#c], den)
}).join($+$)

#let payback-eq(cfs) = {
  let cum = cfs.at(0)
  for t in range(1, cfs.len()) {
    if cum + cfs.at(t) >= 0 {
      return $"Payback" = #str(t - 1) + frac(#str(-cum), #str(cfs.at(t))) = #fmt(payback(cfs)) "yrs"$
    }
    cum += cfs.at(t)
  }
}

#table(
  columns: 4,
  [*Period*], [*A*], [*B*], [*C*],
  ..range(A.len()).map(t => ([#t], [#A.at(t)], [#B.at(t)], [#C.at(t)])).flatten(),
)

#table(
  columns: 5,
  [*Project*], [*Payback (yrs)*], [*IRR*], [*NPV \@10%*], [*NPV \@15%*],
  ..projects.pairs().map(((name, cf)) => (
    [#name], [#fmt(payback(cf))], [#pct(irr(cf))], [#fmt(npv(0.10, cf))], [#fmt(npv(0.15, cf))],
  )).flatten(),
)

#for (name, cf) in projects.pairs() [
  *Project #name*
  $ #payback-eq(cf) $
  $ 0 = #dcf(cf, $(1 + "IRR")$) quad => quad "IRR" = #pct(irr(cf)) $
  #for r in (0.10, 0.15) [
    $ "NPV"_#pct(r) = #dcf(cf, $(#fmt(1 + r))$) = #fmt(npv(r, cf)) $
  ]
]

= Problem 2

#let A = (-400, 250, 300)
#let B = (-200, 140, 179)
#let AB = A.zip(B).map(((a, b)) => a - b)
#let r = 0.09

#table(
  columns: 4,
  [*Period*], [*A*], [*B*], [*A - B*],
  ..range(A.len()).map(t => ([#t], [#A.at(t)], [#B.at(t)], [#AB.at(t)])).flatten(),
)

#table(
  columns: 3,
  [*Project*], [*IRR*], [*NPV \@#pct(r)*],
  ..(("A", A), ("B", B), ("A - B", AB)).map(((name, cf)) => (
    [#name], [#pct(irr(cf))], [#fmt(npv(r, cf))],
  )).flatten(),
)

#for (name, cf) in (("A", A), ("B", B), ("A - B", AB)) [
  $ "NPV"_(#name) = #dcf(cf, $(#fmt(1 + r))$) = #fmt(npv(r, cf)) $
  $ 0 = #dcf(cf, $(1 + "IRR")$) quad => quad "IRR" = #pct(irr(cf)) $
]

*Decision:* *Project #if npv(r, A) > npv(r, B) [A] else [B]*.

- B has a greater IRR (#pct(irr(B)) vs. #pct(irr(A)))
- Difference in scale makes IRR ranking incorrect
- At #pct(r), A has a higher NPV (#fmt(npv(r, A)) vs. #fmt(npv(r, B))).
- Incremental A - B (invest 200 more, get 110 and 121)
  - IRR = #pct(irr(AB)) > #pct(r), so the extra investment creates value (incremental NPV = #fmt(npv(r, AB)))
- The NPV profiles cross at #pct(irr(AB))
  - Below rate, A is preferred 
  - Above rate, B is preferred

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

#let money(x, blank-zero: true) = {
  if blank-zero and x == 0 { return "" }
  let v = int(calc.round(x))
  let s = str(calc.abs(v))
  let out = ""
  for (i, ch) in s.clusters().enumerate() {
    if i > 0 and calc.rem(s.len() - i, 3) == 0 { out += "," }
    out += ch
  }
  if v < 0 { "-" + out } else { out }
}

#let cf-row(label, n, f) = (label: label, values: range(n + 1).map(f))
#let total(rows, n) = range(n + 1).map(t => rows.map(r => r.values.at(t)).sum())

#let cf-table(rows, n, cell: money, head: t => [#t], rate: none) = {
  let tot = total(rows, n)
  let disc = if rate == none { () } else {
    let dfs = range(n + 1).map(t => 1 / calc.pow(1 + rate, t))
    let pvs = tot.zip(dfs).map(((c, f)) => c * f)
    (
      [Discount factor \@#pct(rate)], ..dfs.map(f => [#fmt(f, d: 4)]),
      [*PV*], ..pvs.map(v => [*#cell(v, blank-zero: false)*]),
      table.hline(),
      [*NPV*], table.cell(colspan: n + 1, align: right)[*#cell(pvs.sum(), blank-zero: false)*],
    )
  }
  table(
    columns: (auto,) + (1fr,) * (n + 1),
    align: (left,) + (right,) * (n + 1),
    [*Period*], ..range(n + 1).map(t => [*#head(t)*]),
    ..rows.map(r => ([#r.label], ..r.values.map(v => [#cell(v)]))).flatten(),
    table.hline(),
    [*Net cash flow*], ..tot.map(v => [*#cell(v, blank-zero: false)*]),
    ..disc,
  )
}

= Problem 3

#let tax = 0.30
#let r = 0.15
#let n = 5
#let cost = 800000
#let new-dep = cost / n
#let old-sale = 180000
#let old-bv = 300000
#let old-dep = 100000
#let old-life = 3
#let inflow = 200000
#let savings = 50000
#let wc = 30000

// *Assumptions:* 
// - New equipment depreciated straight-line over #n years to zero salvage
// - Spare-parts inventory is working capital, kept at #money(wc) by replenishment and recovered at the end of year #n

*T 0* 

- Old assets are sold under book value
- Loss = #money(old-bv) - #money(old-sale) = #money(old-bv - old-sale)
- Tax shield = #money(old-bv - old-sale) × #(tax * 100)% = #money((old-bv - old-sale) * tax)

*T 1-#n* 

- Pre-tax benefit = #money(inflow) + #money(savings) = #money(inflow + savings)
- #money((inflow + savings) * (1 - tax)) after tax
- Incremental depreciation = #money(new-dep) - #money(old-dep) in years 1-#old-life (the old assets' depreciation is lost)

$ "Years 1-"#str(old-life): (#money(new-dep) - #money(old-dep)) times #pct(tax) = #money((new-dep - old-dep) * tax) $
$ "Years "#str(old-life + 1)"-"#str(n): #money(new-dep) times #pct(tax) = #money(new-dep * tax) $

#let rows3 = (
  cf-row([New equipment], n, t => if t == 0 { -cost } else { 0 }),
  cf-row([Sale of old assets], n, t => if t == 0 { old-sale } else { 0 }),
  cf-row([Tax shield on loss on sale], n, t => if t == 0 { (old-bv - old-sale) * tax } else { 0 }),
  cf-row([Working capital], n, t => if t == 0 { -wc } else if t == n { wc } else { 0 }),
  cf-row([After-tax operating benefit], n, t => if t > 0 { (inflow + savings) * (1 - tax) } else { 0 }),
  cf-row([Depreciation tax shield], n, t => if t > 0 { (new-dep - if t <= old-life { old-dep } else { 0 }) * tax } else { 0 }),
)

#let cf3 = total(rows3, n)
#let npv3 = npv(r, cf3)

#cf-table(rows3, n, rate: r)

*NPV \@#pct(r)* = #money(npv3, blank-zero: false).

#if npv3 > 0 [
  - The NPV is positive, so the investment earns more than the #pct(r) required return:
  - ABC Manufacturing should replace the old equipment
] else [
  - The NPV is negative 
  - ABC Manufacturing should not replace the old equipment
]

= Problem 4

The \$50K preliminary study is excluded (sunk cost)

#let tax = 0.40
#let r = 0.20
#let n = 3
#let mach-cost = 1000
#let mach-acc-dep = 400
#let mach-bv = mach-cost - mach-acc-dep
#let mach-sale = 300
#let mach-dep = mach-bv / n
#let inv = 150
#let sw = 300
#let sw-dep = sw / n
#let ot0 = 100
#let g = 0.10

#let k(x, blank-zero: true) = if blank-zero and x == 0 { "" } else { fmt(x, d: 1) }

== Question 1: NPV of change \#1 only

- Book value of the machines = #mach-cost - #mach-acc-dep = #mach-bv
- Selling at #mach-sale is a loss of #(mach-bv - mach-sale), with a tax shield of #(mach-bv - mach-sale) × #(tax * 100)% = #k((mach-bv - mach-sale) * tax)
- Additionally, selling cancels #k(mach-dep)/yr of depreciation, i.e. a tax shield of #k(mach-dep * tax)/yr in years 1-#n

#let rows-m = (
  cf-row([Sale of machines], n, t => if t == 0 { mach-sale } else { 0 }),
  cf-row([Tax shield on loss on sale], n, t => if t == 0 { (mach-bv - mach-sale) * tax } else { 0 }),
  cf-row([Lost depreciation tax shield], n, t => if t > 0 { -mach-dep * tax } else { 0 }),
)
#let npv-m = npv(r, total(rows-m, n))

#cf-table(rows-m, n, cell: k, rate: r)

NPV of change \#1 \@#pct(r) = #k(npv-m, blank-zero: false)K

== Question 2: Relevant cash flows

- Overtime savings: + #pct(g) a year: #range(1, n + 1).map(t => k(ot0 * calc.pow(1 + g, t - 1))).join(", ") (without tax)
- Inventory is working capital (recovered at cost in year #n)
- Holding costs are not taken into account

#let rows4 = rows-m + (
  cf-row([Inventory (working capital)], n, t => if t == 0 { -inv } else if t == n { inv } else { 0 }),
  cf-row([Software purchase], n, t => if t == 0 { -sw } else { 0 }),
  cf-row([Software depreciation tax shield], n, t => if t > 0 { sw-dep * tax } else { 0 }),
  cf-row([After-tax overtime savings], n, t => if t > 0 { ot0 * calc.pow(1 + g, t - 1) * (1 - tax) } else { 0 }),
)
#let cf4 = total(rows4, n)

#cf-table(rows4, n, cell: k, head: t => if t == 0 [Time 0] else [End of Year #t])

== Question 3: Decision

#let npv4 = npv(r, cf4)
#let terms = cf4.enumerate().map(((t, c)) => if t == 0 { k(c) } else { k(c) + "/" + fmt(1 + r, d: 1) + if t > 1 { "^" + str(t) } else { "" } })
$ "NPV"_(#pct(r)) = #eval(terms.join(" + ").replace("+ -", "- ").replace("-", "-"), mode: "math") = #k(npv4, blank-zero: false) "K" $

#if npv4 > 0 [
  The NPV is positive, so C2L should use level production
] else [
  The NPV is negative, so C2L should keep the chase strategy
]

