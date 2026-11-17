// =====================================================================
// HBP Working Capital Simulation: Managing Growth V2 — Sunflower Nutraceuticals (SNC)
//
// HOW TO USE
//   ONCE, before Phase 1 (section 1):
//     • `history`  — 2010–2012 Income Statement + Balance Sheet (Analyze tab)
//     • `setup`    — tax rate, required cash, credit line, cost of capital,
//                    Dashboard "Total Value" at end-2012
//     • `financing`— the Board memo's three options (only if your instructor
//                    enabled the financing decision) and your choice
//   EACH PHASE (section 2):
//     • copy every opportunity's "initial assumptions" table from the Decide tab
//       (Incremental Sales, Cost of Sales, Accounts Receivable, Inventories,
//        Accounts Payable for the 3 years + "Post" column)
//     • read the recommendation, submit in the sim, then fill in `accept`
//     • optional: paste the sim's reported numbers into `actuals`
//
// Units: $000, as in the sim. Model mechanics are calibrated to the sim — see
// "How the model works" at the end of the report.
// =====================================================================

#import "@preview/lilaq:0.6.0" as lq

#let days-in-year = 365

#let cogs-from-pct(pct, revenue) = {
  pct * revenue
}

#let AR(dso, sales) = {
  dso / days-in-year * sales
}

// DIO
#let iventory(dsi, cogs) = {
  dsi / days-in-year * cogs
}

#let AP(dpo, cogs) = {
  dpo / days-in-year * cogs
}

// =====================================================================
// 1. ENTER ONCE
// =====================================================================

// Analyze tab, 2010–2012 (data in thousands of dollars).
//   cash = "Cash & Equivalents (Shortfall)" line, i.e. cash ABOVE the $300
//   requirement (negative = shortfall). interest is optional (checks the model).
#let history = (
  (year: 2010, sales: 10000, cogs: 9560, AR: 3123, inv: 2357, AP: 1021, debt: 3332, cash: 0, interest: 180),
  (year: 2011, sales: 10000, cogs: 9630, AR: 3096, inv: 2348, AP: 1055, debt: 3200, cash: 0, interest: 267),
  (year: 2012, sales: 10000, cogs: 9350, AR: 3014, inv: 2305, AP: 1050, debt: 2844, cash: 0, interest: 256),
)

#let setup = (
  tax_rate:      0.39848,   // income taxes ÷ pre-tax income (104/260)
  min_cash:      300,    // required cash
  credit_line:   3200,   // MDM Bank limit
  interest_rate: 0.08,   // charged on the opening balance drawn
  WACC:          0.12,   // "cost of capital of 12% to evaluate investment opportunities"
  base_firm_value: 3248, // Dashboard "Total Value", end of 2012 (none = EBIT·(1−t)/WACC)

  // Recommendation settings
  risk_adjust: true,     // use expected value for opportunities with `p_default`
  min_headroom: 0,       // require at least this much unused credit every year
)

// Financing decision (Decide tab → Financing Options, "pending class
// settings"). Taken once, before Phase 1; applies from 2013.
// Set `options: (:)` if your class doesn't have it.
#let financing = (
  options: (
    mdm:    (label: "MDM Bank (status quo)",       credit_line: 3200, interest_rate: 0.08, dilution: 0.00),
    flores: (label: "Flores debt + free equity",   credit_line: 4700, interest_rate: 0.08, dilution: 0.20),
    at:     (label: "A&T (Averell & Tuttle)",      credit_line: 3700, interest_rate: 0.10, dilution: 0.10),
  ),
  choice: none,          // none = not decided yet → the report recommends one
)


// =====================================================================
// 2. EACH PHASE — opportunities as shown on the Decide tab, then `accept`
//
// Opportunity table (incremental, $000). Each line is either one number
// (same every year) or (year1, year2, year3, Post).
//   sales, cogs, AR, inv, AP        — as shown in the sim
//   ebit:                           — if given, it is used as-is; any gap to
//                                     sales − cogs is treated as other
//                                     operating costs (opex)
//   opex:                           — alternative to ebit
//   p_default:, recovery:           — optional risk (e.g. high-risk customer)
//
// accept:  none            → not decided yet (the report recommends)
//          ()              → decided: decline everything
//          ("tighten",)    → one opportunity (note the trailing comma)
//          ("a", "b")      → several
// actuals: optional, the sim's reported numbers for that phase's years.
//          Enter at least the LAST year of the phase: every later year (and the
//          next phase's recommendation) then builds on those figures. Any of:
//            sales, cogs, ebit (or opex), net_income, interest,
//            AR, inv, AP — or DSO, DSI, DPO in days instead,
//            debt (credit line drawn), cash (above $300; negative = shortfall)
//          ("2015": (sales: 9000, cogs: 8378, ebit: 622, net_income: 308,
//                    DSO: 90, DSI: 86, DPO: 39, debt: 1048, cash: 0), ...)
// =====================================================================
#let phases = (
  // ---------------------------------------------------------------- Phase 1
  // Values reconstructed from the how-to-play guide and student reports;
  // they reproduce reported outcomes to within $2K. Check against your Decide tab.
  (
    name: "Phase 1", start: 2013, end: 2015,
    opportunities: (
      new_customer: (
        label: "Acquire a New Customer", note: "Atlantic Wellness: +$4M sales, same margins & terms",
        sales: 4000, cogs: 3740, ebit: 260, AR: 1205, inv: 922, AP: 420,
      ),
      supplier: (
        label: "Leverage Supplier Discount", note: "Half-size Atlantic Wellness contract + Ayurveda 2/30 net 60",
        sales: 2000, cogs: 1833, ebit: 167, AR: 603, inv: 452, AP: 151,
      ),
      tighten: (
        label: "Tighten Accounts Receivable", note: "Drop Super Sports Centers (20% of sales, ~200 days to pay)",
        sales: -2000, cogs: -1870, ebit: -130, AR: -1096, inv: -461, AP: -210,
      ),
      drop: (
        label: "Drop Poorly Selling Products", note: "Cut 100+ SKUs, DSI → 86 days",
        sales: -1000, cogs: -935, ebit: -65, AR: -301, inv: -323, AP: -105,
      ),
    ),
    accept: ("supplier", "tighten", "drop"),
    actuals: (:),
  ),
  // ---------------------------------------------------------------- Phase 2
  // ILLUSTRATIVE ONLY — built from student descriptions, sized for ~$9M sales.
  // The sim scales these to your own company: replace with your Decide tab.
  (
    name: "Phase 2", start: 2016, end: 2018,
    opportunities: (
      bigbox: (
        label: "Pursue Big-Box Distribution", note: "Mega-Mart: sales +25/10/5%, lower margin, pays on time",
        sales: (2250, 3375, 3994), cogs: (2151, 3203, 3783),
        AR: (462, 663, 807), inv: (507, 755, 891), AP: (227, 339, 400),
      ),
      online: (
        label: "Expand Online Presence", note: "Golden Years Nutraceuticals: sales +10/5/3%, low DSO",
        sales: (900, 1395, 1707), cogs: (838, 1299, 1589),
        AR: (32, 59, 69), inv: (197, 306, 374), AP: (89, 137, 168),
      ),
      privlab: (
        label: "Develop a Private-Label Product", note: "Fountain of Youth Spas: sales +5/4/3%, higher margin, more AR & inventory",
        sales: (450, 828, 1123), cogs: (230, 574, 843),
        AR: (189, 285, 360), inv: (148, 233, 300), AP: (24, 61, 89),
      ),
    ),
    // accept: ("online", "privlab"),
    accept: ("online", "privlab"),
  
    actuals: (:),
  ),
  // // ---------------------------------------------------------------- Phase 3
  // // high_risk: transcribed from one student's Decide tab; others ILLUSTRATIVE.
  (
    name: "Phase 3", start: 2019, end: 2021,
    opportunities: (
      high_risk: (
        label: "Acquire a High-Risk Customer", note: "Midwest Miracles: 20% bankruptcy risk, 50% recovery",
        sales: 3549, cogs: 3127, ebit: 422, AR: 1637, inv: 766, AP: 331,
        p_default: 0.20, recovery: 0.50,
      ),
      renegotiate: (
        label: "Renegotiate Supplier Credit Terms", note: "Dynasty Enterprises 2/10 net 30: 3% discount, DPO → ~10 days",
        sales: 0, cogs: -237, AR: 0, inv: -58, AP: -923,
      ),
      global: (
        label: "Adopt a Global Expansion Strategy", note: "Viva Familia (Latin America): modest sales growth, DSO -2, DSI +2",
        sales: (355, 842, 842), cogs: (324, 770, 770),
        AR: (46, 119, 119), inv: (110, 252, 252), AP: (34, 81, 81),
      ),
    ),
    accept: none,
    // accept: ("renegotiate", "global"),
    actuals: (:),
  ),
)

// =====================================================================
// MODEL — nothing to edit below
// =====================================================================

// Accept `phases = ()` (new game) and a single phase written without the
// trailing comma (Typst reads `( (...) )` as one dictionary, not an array).
#let phases = if type(phases) == dictionary { (phases,) } else { phases }
#let history = if type(history) == dictionary { (history,) } else { history }
#let FIELDS = ("sales", "cogs", "opex", "AR", "inv", "AP")
#let t = setup.tax_rate
#let r = setup.WACC
#let base = history.last()
#let first_year = history.first().year
#let phase_start = if phases.len() > 0 { phases.first().start } else { history.last().year + 1 }
#let n_years(ph) = ph.end - ph.start + 1

// value of a line in year index i (0-based; i = n is "Post"; arrays repeat last)
#let pick(v, i) = if type(v) == array { v.at(calc.min(i, v.len() - 1)) } else { v }
#let fld(o, k, i) = {
  // "opex" = other operating costs between cost of sales and EBIT.
  // If the table gives EBIT, it wins: opex = sales − cogs − EBIT.
  if k == "opex" and "opex" not in o and "ebit" in o {
    pick(o.sales, i) - pick(o.at("cogs", default: 0), i) - pick(o.ebit, i)
  } else { pick(o.at(k, default: 0), i) }
}
#let o_ebit(o, i) = fld(o, "sales", i) - fld(o, "cogs", i) - fld(o, "opex", i)

// Complete a reported year (history or actuals): EBIT → opex, days → balances.
#let normalize(y) = {
  if "ebit" in y and "opex" not in y { y.insert("opex", y.sales - y.cogs - y.ebit) }
  if "opex" not in y { y.insert("opex", 0) }
  if "AR" not in y and "DSO" in y { y.insert("AR", y.DSO * y.sales / 365) }
  if "inv" not in y and "DSI" in y { y.insert("inv", y.DSI * y.cogs / 365) }
  if "AP" not in y and "DPO" in y { y.insert("AP", y.DPO * y.cogs / 365) }
  y
}

// ---- input checks -----------------------------------------------------------
#for (pi, ph) in phases.enumerate() {
  if ph.at("accept", default: none) != none {
    for k in ph.accept {
      if k not in ph.opportunities {
        panic(ph.name + ": unknown opportunity \"" + k + "\". Valid: " + ph.opportunities.keys().join(", "))
      }
    }
    if pi > 0 and phases.at(pi - 1).at("accept", default: none) == none {
      panic(ph.name + " has `accept` but " + phases.at(pi - 1).name + " doesn't — decide phases in order.")
    }
  }
}
#for (i, h) in history.enumerate() {
  if i > 0 and h.year != history.at(i - 1).year + 1 {
    panic("history: years must be consecutive (" + str(history.at(i - 1).year) + " is followed by " + str(h.year) + ")")
  }
}
#if phases.len() > 0 and phases.first().start != history.last().year + 1 {
  panic("history ends in " + str(history.last().year) + " but " + phases.first().name + " starts in " + str(phases.first().start) + ": history should be the years BEFORE Phase 1 (2010–2012); put played years in that phase's `actuals`")
}
#for (i, ph) in phases.enumerate() {
  if ph.end < ph.start { panic(ph.name + ": end is before start") }
  if i > 0 and ph.start != phases.at(i - 1).end + 1 {
    panic(ph.name + " starts in " + str(ph.start) + " but " + phases.at(i - 1).name + " ends in " + str(phases.at(i - 1).end) + " — phases must follow each other")
  }
}
#if financing.choice != none and financing.choice not in financing.options {
  panic("financing.choice must be one of: " + financing.options.keys().join(", "))
}

#let decided = phases.filter(ph => ph.at("accept", default: none) != none).len()
#let played = range(decided).map(i => (phase: i, keys: phases.at(i).accept))

// ---- one opportunity's value (what the sim reports as "value created") -----
// PV at the phase start, WACC, of ΔEBIT·(1−t) − Δ(ΔNWC) for the phase years,
// plus a perpetuity of the Post year (incl. the last NWC step).
#let opp_value(ph, o) = {
  let n = n_years(ph)
  let v = 0
  let prev = 0
  for i in range(n) {
    let nopat = o_ebit(o, i) * (1 - t)
    let nwc = fld(o, "AR", i) + fld(o, "inv", i) - fld(o, "AP", i)
    v += (nopat - (nwc - prev)) / calc.pow(1 + r, i + 1)
    prev = nwc
  }
  let nopat = o_ebit(o, n) * (1 - t)
  let nwc = fld(o, "AR", n) + fld(o, "inv", n) - fld(o, "AP", n)
  v + (nopat / r - (nwc - prev) / (1 + r)) / calc.pow(1 + r, n)
}
// Expected value if the customer can default (my adjustment; the sim's
// "value created" ignores it): lose the deal and (1 − recovery) of year-1 AR.
#let opp_value_risk(ph, o) = {
  let v = opp_value(ph, o)
  let p = o.at("p_default", default: 0)
  if p == 0 { v } else {
    (1 - p) * v - p * (1 - o.at("recovery", default: 0)) * fld(o, "AR", 0) / (1 + r)
  }
}
#let set_value(pi, keys, risk: false) = {
  let ph = phases.at(pi)
  keys.map(k => if risk { opp_value_risk(ph, ph.opportunities.at(k)) } else { opp_value(ph, ph.opportunities.at(k)) }).sum(default: 0)
}

// ---- credit terms in a year -------------------------------------------------
#let terms(year, fin) = {
  if fin != none and year >= phase_start {
    let f = financing.options.at(fin)
    (limit: f.credit_line, rate: f.interest_rate)
  } else { (limit: setup.credit_line, rate: setup.interest_rate) }
}

// ---- operating levels: roll forward from the LATEST reported year ------------
// Each projected year = previous year's levels + the change in every accepted
// opportunity's increment (0 before its phase; year 1–3; then Post forever).
// So once you enter the sim's `actuals`, later years build on the sim's real
// figures, not on 2012 + the model.
#let inc(c, k, f, year) = {
  let ph = phases.at(c.phase)
  if year < ph.start { 0 } else { fld(ph.opportunities.at(k), f, calc.min(year - ph.start, n_years(ph))) }
}
#let step(prev_levels, year, choices) = {
  let y = prev_levels
  for c in choices { for k in c.keys { for f in FIELDS {
    y.insert(f, y.at(f) + inc(c, k, f, year) - inc(c, k, f, year - 1))
  } } }
  // sim's reported numbers win for played phases
  for c in choices {
    let ph = phases.at(c.phase)
    if ph.at("accept", default: none) != none and year >= ph.start and year <= ph.end {
      let a = ph.at("actuals", default: (:)).at(str(year), default: (:))
      if "ebit" in a and "opex" not in a { a.insert("opex", a.at("sales", default: y.sales) - a.at("cogs", default: y.cogs) - a.ebit) }
      for (d, f, on) in (("DSO", "AR", "sales"), ("DSI", "inv", "cogs"), ("DPO", "AP", "cogs")) {
        if d in a and f not in a { a.insert(f, a.at(d) * a.at(on, default: y.at(on)) / 365) }
      }
      y = y + a
    }
  }
  y
}

// ---- simulate all years up to `last` ------------------------------------------
// Net borrowing B = credit line drawn + shortfall − cash above the requirement.
// Each year: B falls by (net income − ΔNWC). Interest = rate × opening B (if > 0).
#let run(last, choices, fin) = {
  let rows = ()
  let prev = none
  let lv = none
  for year in range(first_year, last + 1) {
    let hist = history.find(h => h.year == year)
    let y = if hist != none { normalize(hist) } else { step(lv, year, choices) }
    lv = (:)
    for f in FIELDS { lv.insert(f, y.at(f)) }
    let tm = terms(year, fin)
    let ebit = y.sales - y.cogs - y.opex
    let nwc = y.AR + y.inv - y.AP
    let dnwc = if prev == none { 0 } else { nwc - prev.NWC }
    let nopat = ebit * (1 - t)
    let interest = if "interest" in y { y.interest } else if prev == none { 0 } else { tm.rate * calc.max(prev.B, 0) }
    let ni = if "net_income" in y { y.net_income } else { (ebit - interest) * (1 - t) }
    let B = if "debt" in y { y.debt - y.at("cash", default: 0) } else { prev.B - (ni - dnwc) }
    let debt = if "debt" in y { y.debt } else { calc.clamp(B, 0, tm.limit) }
    let shortfall = if "debt" in y { calc.max(-y.at("cash", default: 0), 0) } else { calc.max(B - tm.limit, 0) }
    let excess = calc.max(-B, 0)
    let row = (
      year: year, projected: hist == none,
      sales: y.sales, cogs: y.cogs, opex: y.opex, EBIT: ebit, interest: interest, NI: ni,
      AR: y.AR, inv: y.inv, AP: y.AP, NWC: nwc, dNWC: dnwc,
      FCF: nopat - dnwc,
      B: B, debt: debt, limit: tm.limit, avail: tm.limit - debt,
      surplus: excess - shortfall, shortfall: shortfall,
      DSO: y.AR / y.sales * 365, DSI: y.inv / y.cogs * 365, DPO: y.AP / y.cogs * 365,
    )
    row.CCC = row.DSO + row.DSI - row.DPO
    row.cumFCF = if prev == none { row.FCF } else { prev.cumFCF + row.FCF }
    rows.push(row)
    prev = row
  }
  rows
}

// ---- evaluate one choice for phase pi on top of earlier choices ---------------
#let subsets(xs) = {
  let out = ((),)
  for x in xs { out = out + out.map(s => s + (x,)) }
  out
}
#let evaluate(pi, keys, prior, fin) = {
  let ph = phases.at(pi)
  let rows = run(ph.end, prior + ((phase: pi, keys: keys),), fin).filter(x => x.year >= ph.start)
  let v = set_value(pi, keys)
  let vr = set_value(pi, keys, risk: true)
  (
    keys: keys, rows: rows, last: rows.last(),
    value: v, value_risk: vr, score: if setup.risk_adjust { vr } else { v },
    shortfall: rows.map(x => x.shortfall).sum(),
    min_avail: calc.min(..rows.map(x => x.avail - x.shortfall)),
    worst: rows.sorted(key: x => x.surplus - x.avail).first(),
    NI: rows.map(x => x.NI).sum(), FCF: rows.map(x => x.FCF).sum(),
    ok: rows.all(x => x.shortfall < 0.5 and x.avail >= setup.min_headroom - 0.5),
  )
}
#let candidates(pi, prior, fin) = subsets(phases.at(pi).opportunities.keys()).map(s => evaluate(pi, s, prior, fin))
#let best_of(cands) = {
  let ok = cands.filter(c => c.ok)
  if ok.len() == 0 { (best: none, fallback: cands.sorted(key: c => c.shortfall).first()) } else {
    // highest score; ties → fewer opportunities
    (best: ok.sorted(key: c => c.score - c.keys.len() * 1e-3).last(), fallback: none)
  }
}

// ---- financing recommendation: best feasible plan under each option ----------
#let base_equity = {
  let fv = if setup.base_firm_value == none { (base.sales - base.cogs) * (1 - t) / r } else { setup.base_firm_value }
  (fv: fv, eq: fv - base.debt + base.at("cash", default: 0) + setup.min_cash)
}
#let plan_for(fin) = {
  let choices = ()
  let feasible = true
  for (pi, ph) in phases.enumerate() {
    if ph.at("accept", default: none) != none { choices.push((phase: pi, keys: ph.accept)) } else {
      let b = best_of(candidates(pi, choices, fin))
      if b.best == none { feasible = false; choices.push((phase: pi, keys: b.fallback.keys)) }
      else { choices.push((phase: pi, keys: b.best.keys)) }
    }
  }
  let vc = choices.map(c => set_value(c.phase, c.keys)).sum(default: 0)
  let rows = run(phases.last().end, choices, fin).filter(x => x.projected)
  let d = financing.options.at(fin).dilution
  (fin: fin, choices: choices, vc: vc, feasible: feasible and rows.all(x => x.shortfall < 0.5),
   owners: (1 - d) * (base_equity.eq + vc), min_avail: calc.min(..rows.map(x => x.avail - x.shortfall)))
}
#let fin_plans = if financing.choice == none and financing.options.len() > 0 and decided == 0 and phases.len() > 0 {
  financing.options.keys().map(plan_for)
} else { () }
#let fin_best = if fin_plans.len() == 0 { none } else {
  let ok = fin_plans.filter(p => p.feasible)
  let pool = if ok.len() > 0 { ok } else { fin_plans }
  pool.sorted(key: p => p.owners).last()
}
// financing used for the analysis
#let fin = if financing.options.len() == 0 { none } else if financing.choice != none { financing.choice } else if fin_best != none { fin_best.fin } else { financing.options.keys().first() }
#let dilution = if fin == none { 0 } else { financing.options.at(fin).dilution }

// ---- state of the game -------------------------------------------------------
#let next_i = if decided < phases.len() { decided } else { none }
#let last_played = if decided == 0 { base.year } else { phases.at(decided - 1).end }
#let rows = run(last_played, played, fin)
#let vc_by_phase = played.map(c => set_value(c.phase, c.keys))
#let total_vc = vc_by_phase.sum(default: 0)
#let firm_value = base_equity.fv + total_vc
#let equity_value = base_equity.eq + total_vc
#let cands = if next_i == none { () } else { candidates(next_i, played, fin) }
#let rec = if next_i == none { none } else { best_of(cands) }


// =====================================================================
// FORMATTING
// =====================================================================
#let thousands(n) = {
  let s = str(calc.abs(n))
  let out = ""
  for (i, c) in s.clusters().rev().enumerate() {
    if i > 0 and calc.rem(i, 3) == 0 { out = "," + out }
    out = c + out
  }
  out
}
#let money(x) = { let v = int(calc.round(x)); if v < 0 [(\$#thousands(v))] else [\$#thousands(v)] }
#let signed(x) = { let v = int(calc.round(x)); if v > 0 [+\$#thousands(v)] else if v < 0 [−\$#thousands(v)] else [\$0] }
#let days(x) = [#calc.round(x, digits: 0)]
#let pct(x) = [#calc.round(x * 100, digits: 1)%]

#let good = rgb("#d9f2e3")
#let bad  = rgb("#f9d6d5")
#let warn = rgb("#fdf1c7")
#let muted = luma(110)

#let olabel(pi, k) = phases.at(pi).opportunities.at(k).label
#let set_label(pi, keys) = if keys.len() == 0 [Decline all] else { keys.map(k => olabel(pi, k)).join(" + ") }
#let set_code(keys) = if keys.len() == 0 { "()" } else if keys.len() == 1 { "(\"" + keys.first() + "\",)" } else {
  "(" + keys.map(k => "\"" + k + "\"").join(", ") + ")"
}

#set page(paper: "a4", flipped: true, margin: (x: 1.3cm, y: 1.2cm),
  footer: context [#text(size: 7pt, fill: muted)[SNC working-capital model · \$000 · page #counter(page).display()]])
#set text(size: 8.5pt, font: ("Libertinus Serif", "New Computer Modern"))
#set par(justify: false)
#show heading.where(level: 1): set text(size: 15pt)
#show heading.where(level: 2): it => block(above: 1.1em, below: 0.6em, text(size: 11pt, it.body))
#set table(
  stroke: (x, y) => if y == 0 { (bottom: 0.7pt) } else { (bottom: 0.25pt + luma(215)) },
  inset: (x: 4pt, y: 3pt),
)
#show table.cell.where(y: 0): strong
#let section(title, cols) = table.cell(colspan: cols, fill: luma(238))[*#title*]
#let kpi(label, value, ..rest) = { let sub = rest.pos().at(0, default: none); box(width: 100%, inset: 6pt, radius: 3pt, stroke: 0.5pt + luma(200))[
  #text(size: 7.5pt, fill: muted)[#label] \
  #text(size: 13pt, weight: "bold")[#value]
  #if sub != none [\ #text(size: 7pt, fill: muted)[#sub]]
] }


// =====================================================================
// REPORT
// =====================================================================
= Sunflower Nutraceuticals — Working Capital Simulation

#text(fill: muted)[
  #for (i, ph) in phases.enumerate() [
    #ph.name (#ph.start–#ph.end): #if i < decided [*#set_label(i, ph.accept)*] else if i == next_i [_deciding now_] else [—]. #h(0.4em)
  ]
  Financing: #if fin == none [not part of this class] else if financing.choice == none [_not chosen — analysis assumes #(financing.options.at(fin).label)_] else [*#financing.options.at(fin).label*].
]

#let last = rows.last()
#grid(columns: (1fr,) * 6, column-gutter: 6pt,
  kpi[Total firm value][#money(firm_value)][end-2012 #money(base_equity.fv) + value created],
  kpi[Equity value][#money(equity_value)][#if dilution > 0 [owners' #pct(1 - dilution): #money((1 - dilution) * equity_value)] else [sim definition]],
  kpi[Total value created][#signed(total_vc)],
  kpi[Sales #last.year][#money(last.sales)][EBIT #money(last.EBIT)],
  kpi[Credit available #last.year][#money(last.avail)][limit #money(last.limit)],
  kpi[Cash conversion cycle][#days(last.CCC) days][DSO #days(last.DSO) · DSI #days(last.DSI) · DPO #days(last.DPO)],
)

// ---------------------------------------------------------------- financing
#if fin_plans.len() > 0 [
  == Financing decision (before Phase 1): recommendation
  #let fb = fin_best
  *Choose: #financing.options.at(fb.fin).label* · set #raw("choice: \"" + fb.fin + "\"") in `financing`.
  The opportunities entered so far are all played greedily (best safe choice
  each phase) under each option, then compared on the owners' share of equity
  value. Dilution is permanent, so a bigger line only wins if it unlocks more
  value than it gives away.

  #table(
    columns: (1.6fr, auto, auto, auto, 2.6fr, auto, auto, auto),
    align: (left, right, right, right, left, right, right, right),
    [Option], [Limit], [Rate], [Dilution], [Best plan under this option], [Value created], [Lowest credit left], [Owners' equity],
    ..fin_plans.map(p => {
      let o = financing.options.at(p.fin)
      let hl = if p.fin == fb.fin { good } else { none }
      (
        table.cell(fill: hl)[#o.label #if p.fin == fb.fin [★]],
        money(o.credit_line), pct(o.interest_rate), pct(o.dilution),
        p.choices.map(c => [#phases.at(c.phase).name: #set_label(c.phase, c.keys)]).join([ · ]),
        signed(p.vc),
        table.cell(fill: if p.min_avail < 0 { bad })[#money(p.min_avail)],
        table.cell(fill: hl)[*#money(p.owners)*],
      )
    }).flatten(),
  )
]

// ---------------------------------------------------------------- next phase
#if next_i != none {
  let ph = phases.at(next_i)
  let b = rec.best
  [== #ph.name (#ph.start–#ph.end): recommendation]
  if b == none [
    #block(fill: bad, inset: 6pt, radius: 3pt)[*No safe choice* — every combination overdraws the credit line.
    Least bad: *#set_label(next_i, rec.fallback.keys)* (total shortfall #money(rec.fallback.shortfall)).]
  ] else [
    #block(fill: good, inset: 6pt, radius: 3pt, width: 100%)[
      *Accept: #set_label(next_i, b.keys)* — value created #signed(b.value)#if setup.risk_adjust and calc.abs(b.value - b.value_risk) > 0.5 [ (risk-adjusted #signed(b.value_risk))],
      lowest credit available #money(b.min_avail) (#b.worst.year). \
      Then set #raw("accept: " + set_code(b.keys)) in #ph.name.
    ]
  ]
  // per-opportunity scorecard
  let alone = ph.opportunities.keys().map(k => cands.find(c => c.keys == (k,)))
  [
    #v(4pt)
    #table(
      columns: (1.7fr, 2.6fr, auto, auto, auto, auto, auto, auto, auto),
      align: (left, left, right, right, right, right, right, right, left),
      [Opportunity], [What it is], [Value\ created], [Risk-\ adjusted], [ΔEBIT\ Post], [ΔNWC\ yr 1], [ΔNWC\ Post], [Alone: lowest\ credit left], [Verdict],
      ..ph.opportunities.keys().zip(alone).map(((k, c)) => {
        let o = ph.opportunities.at(k)
        let n = n_years(ph)
        let nwc(i) = fld(o, "AR", i) + fld(o, "inv", i) - fld(o, "AP", i)
        let inb = b != none and k in b.keys
        (
          table.cell(fill: if inb { good })[*#o.label* #text(fill: muted, size: 7pt)[#raw(k)]],
          text(size: 7.5pt, o.at("note", default: "")),
          table.cell(fill: if c.value > 0.5 { good } else if c.value < -0.5 { bad })[#signed(c.value)],
          if o.at("p_default", default: 0) > 0 [#signed(c.value_risk)] else [—],
          signed(o_ebit(o, n)),
          signed(nwc(0)), signed(nwc(n)),
          table.cell(fill: if c.min_avail < 0 { bad })[#money(c.min_avail)],
          if inb [accept] else if c.score < -0.5 [destroys value] else if not c.ok [overdraws line] else [not needed],
        )
      }).flatten(),
    )
    _Value created_ = PV at #ph.start of ΔEBIT·(1−#t) − Δ(net working capital) over the phase, plus a perpetuity of the Post year, at #pct(r). Additive across opportunities; financing does not change it, but it decides whether a set fits under the line.
  ]
  // all combinations
  let order = cands.sorted(key: c => (if c.ok { 1e9 } else { 0 }) + c.score).rev()
  [
    == #ph.name: every combination (safe first, best value first)
    #table(
      columns: (2.8fr, auto, auto, auto, auto, auto, auto, auto, auto, auto),
      align: (left,) + (right,) * 9,
      [Accept], [Value\ created], [Risk-\ adjusted], [Sales\ #ph.end], [EBIT\ #ph.end], [Net income\ (phase)], [FCF\ (phase)], [CCC\ #ph.end], [Lowest credit\ available], [Worst cash\ surplus/(shortfall)],
      ..order.map(c => {
        let isb = b != none and c.keys == b.keys
        (
          table.cell(fill: if isb { good })[#set_label(next_i, c.keys)#if isb [ ★]],
          signed(c.value), signed(c.value_risk), money(c.last.sales), money(c.last.EBIT),
          money(c.NI), table.cell(fill: if c.FCF < 0 { warn })[#money(c.FCF)], days(c.last.CCC),
          table.cell(fill: if c.min_avail < 0 { bad } else if c.min_avail < 0.15 * c.last.limit { warn })[#money(c.min_avail)],
          table.cell(fill: if c.worst.surplus < -0.5 { bad })[#money(calc.min(..c.rows.map(x => x.surplus)))],
        )
      }).flatten(),
    )
  ]
} else if phases.len() == 0 [
  == No phases entered yet
  Add Phase 1's opportunities (Decide tab → "initial assumptions") to `phases` to get the financing and Phase 1 recommendations.
] else [
  == Simulation complete
  Total value created #signed(total_vc); total firm value #money(firm_value); equity value #money(equity_value).
]

// ---------------------------------------------------------------- value created
#if decided > 0 [
  == Value created by phase
  #table(
    columns: (auto, 1fr, auto, auto),
    align: (left, left, right, right),
    [Phase], [Accepted], [Value created], [Firm value after],
    ..played.enumerate().map(((i, c)) => (
      [#phases.at(i).name], set_label(i, c.keys),
      table.cell(fill: if vc_by_phase.at(i) > 0.5 { good } else if vc_by_phase.at(i) < -0.5 { bad })[#signed(vc_by_phase.at(i))],
      money(base_equity.fv + vc_by_phase.slice(0, i + 1).sum()),
    )).flatten(),
    table.hline(stroke: 0.7pt),
    [], [*Total*], [*#signed(total_vc)*], [*#money(firm_value)*],
  )
]

// ---------------------------------------------------------------- history
== Financial history#if decided > 0 [ (projected years: model, or the sim's numbers where you entered `actuals`)]
#{
  let n = rows.len()
  // header spans counted from the years actually in the table
  let groups = (([History], rows.filter(x => not x.projected).len()),)
  for c in played {
    let ph = phases.at(c.phase)
    groups.push(([#ph.name: #set_label(c.phase, c.keys)], rows.filter(x => x.projected and x.year >= ph.start and x.year <= ph.end).len()))
  }
  let gap = n - groups.map(g => g.at(1)).sum()
  if gap > 0 { groups.push(([], gap)) }
  groups = groups.filter(g => g.at(1) > 0)
  let spec = (
    "Income statement",
    ("Sales", "sales", money, none),
    ("Cost of sales", "cogs", money, none),
    ..if rows.any(x => calc.abs(x.opex) > 0.5) { (("Other operating costs", "opex", money, none),) } else { () },
    ("EBIT", "EBIT", money, none),
    ("Interest expense", "interest", money, none),
    ("Net income", "NI", money, v => if v < 0 { bad }),
    "Working capital",
    ("Accounts receivable", "AR", money, none),
    ("Inventories", "inv", money, none),
    ("Accounts payable", "AP", money, none),
    ("Net working capital (AR + Inv − AP)", "NWC", money, none),
    ("DSO (days)", "DSO", days, none),
    ("DSI (days)", "DSI", days, none),
    ("DPO (days)", "DPO", days, none),
    ("Cash conversion cycle (days)", "CCC", days, none),
    "Cash flow & credit line",
    ("Change in NWC", "dNWC", money, v => if v > 0.5 { warn }),
    ("Free cash flow  EBIT·(1−t) − ΔNWC", "FCF", money, v => if v < 0 { bad }),
    ("Cumulative FCF", "cumFCF", money, none),
    ("Credit line drawn", "debt", money, none),
    ("Credit line limit", "limit", money, none),
    ("Incremental credit available", "avail", money, v => if v < 0 { bad }),
    ("Cash surplus / (shortfall)", "surplus", money, v => if v < -0.5 { bad }),
  )
  table(
    columns: (auto,) + (1fr,) * n,
    align: (left,) + (right,) * n,
    [], ..groups.map(((l, s)) => table.cell(colspan: s, align: center, text(size: 7.5pt, l))),
    [*Year*], ..rows.map(x => [*#x.year*]),
    ..spec.map(row => {
      if type(row) == str { (section(row, n + 1),) } else {
        let (label, key, f, rule) = row
        (label, ..rows.map(x => { let v = x.at(key); table.cell(fill: if rule == none { none } else { rule(v) }, f(v)) }))
      }
    }).flatten(),
  )
}

// ---------------------------------------------------------------- charts
#{
  let ys = rows.map(x => x.year)
  let ticks = (ticks: ys.map(y => (y, str(y))), subticks: none)
  // y-range with room above the data for the legend
  let span(..vals) = {
    let v = vals.pos().flatten()
    let lo = calc.min(0, ..v)
    let hi = calc.max(..v)
    (lo - 0.05 * (hi - lo), hi + 0.55 * (hi - lo))
  }
  let chart(title, ylim, ..series) = lq.diagram(title: title, width: 100%, height: 4.4cm, ylim: ylim,
    xaxis: ticks, yaxis: (exponent: 0), legend: (position: left + top), ..series)
  grid(columns: (1fr, 1fr), column-gutter: 1.5em, row-gutter: 1em,
    chart([Sales], span(rows.map(x => x.sales)),
      lq.bar(ys, rows.map(x => x.sales), label: [Sales]),
    ),
    chart([EBIT, net income, free cash flow], span(rows.map(x => (x.EBIT, x.NI, x.FCF))),
      lq.plot(ys, rows.map(x => x.EBIT), label: [EBIT]),
      lq.plot(ys, rows.map(x => x.NI), label: [Net income]),
      lq.plot(ys, rows.map(x => x.FCF), label: [FCF]),
    ),
    chart([Cash conversion cycle (days)], span(rows.map(x => (x.DSO, x.DSI, x.DPO, x.CCC))),
      lq.plot(ys, rows.map(x => x.DSO), label: [DSO]),
      lq.plot(ys, rows.map(x => x.DSI), label: [DSI]),
      lq.plot(ys, rows.map(x => x.DPO), label: [DPO]),
      lq.plot(ys, rows.map(x => x.CCC), label: [CCC], stroke: 1.6pt),
    ),
    chart([Credit line and cash], span(rows.map(x => (x.debt, x.limit, x.surplus))),
      lq.plot(ys, rows.map(x => x.debt), label: [Drawn]),
      lq.plot(ys, rows.map(x => x.limit), label: [Limit], stroke: (dash: "dashed"), mark: none),
      lq.plot(ys, rows.map(x => x.surplus), label: [Cash surplus/(shortfall)]),
    ),
  )
}

// ---------------------------------------------------------------- notes
#v(6pt)
#block(inset: 6pt, stroke: 0.4pt + luma(200), radius: 3pt, text(size: 7.5pt)[
  *How the model works* (calibrated to the sim's 2010–2012 statements and to results students reported). \
  Operations in a projected year = 2012 levels + every accepted opportunity's increments (year 1–3 of its phase, then its Post column forever).
  EBIT = sales − cost of sales (no D&A or CapEx in the sim). Free cash flow = EBIT·(1−t) − ΔNWC.
  Interest = line rate × opening amount borrowed; net income = (EBIT − interest)·(1−t).
  All cash above the \$#setup.min_cash requirement repays the line; borrowing beyond the limit shows as a cash shortfall (the sim's "Cash & Equivalents (Shortfall)").
  Value created = PV of incremental FCF at #pct(r) plus a perpetuity of the Post year; firm value = end-2012 Total Value + value created; equity value = end-2012 equity (#money(base_equity.eq)) + value created.
  Recommendation = highest value among combinations that never overdraw the line#if setup.min_headroom > 0 [ (keeping #money(setup.min_headroom) headroom)]#if setup.risk_adjust [; opportunities with `p_default` are scored on expected value].
  Checks: this reproduces 2011–12 interest and FCF, 2013–15 net income of 292/314/329 for one reported Phase 1, and reported Phase 1 values of \$466K and \$721K to within \$2K.
])
