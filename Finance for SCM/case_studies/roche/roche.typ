// ---------- helpers ----------
#let fmt(x, d: 2) = {
  let parts = str(calc.round(x, digits: d)).split(".")
  let frac = if parts.len() > 1 { parts.at(1) } else { "" }
  if d == 0 { parts.at(0) } else { parts.at(0) + "." + frac + "0" * (d - frac.len()) }
}
#let money(x) = {
  let v = int(calc.round(x))
  let s = str(calc.abs(v))
  let out = ""
  for (i, ch) in s.clusters().enumerate() {
    if i > 0 and calc.rem(s.len() - i, 3) == 0 { out += "," }
    out += ch
  }
  if v < 0 { "-" + out } else { out }
}

#h(1fr) Manyara Kevin Omenyi \
#h(1fr) Fabian Hernandez \
#h(1fr) Vladimir Borel \

#let pct(x) = fmt(x * 100, d: 0) + "%"

// ---------- data (Exhibit 5) ----------
#let demand-hist = (2378, 2256, 2352, 2306, 2451, 2259, 2361, 2384, 2398, 2305)
#let d = demand-hist.sum() / demand-hist.len()   // kg / year
 
#let unit = (raw1: 1171, overhead: 712, raw2: 298, others: 73)           // \$ / kg
#let setup = (depreciation: 689523, cleaning: 65826, setup-raw: 21086)  // \$ / batch
 
#let c-full = unit.values().sum()               // incl. overhead
#let c = c-full - unit.overhead                 // incremental unit cost
#let K-full = setup.values().sum()              // incl. depreciation
#let K = K-full - setup.depreciation            // incremental setup cost
 
#let h-mat = 0.05     // non-financial holding cost (handling, obsolescence, insurance)
#let r = 0.12         // cost of capital = WACC (no taxes)
#let h = h-mat + r    // 17% total holding cost
#let q0 = 3000        // current campaign size, kg
 
// ---------- model ----------
// Every approach reduces to an EOQ-type optimum with some effective holding rate
#let eoq(K, c, h) = calc.sqrt(2 * K * d / (c * h))
 
// Annual relevant cost: setups + non-financial holding + capital charge on inventory
#let trc(q) = K * d / q + 0.5 * q * c * (h-mat + r)
 
// NPV (correct): inventory released once at t = 0, annual savings as a perpetuity
#let inv-release(q) = 0.5 * c * (q0 - q)
#let annual-saving(q) = K * d * (1 / q0 - 1 / q) + 0.5 * c * h-mat * (q0 - q)
#let npv(q) = inv-release(q) + annual-saving(q) / r
 
// MVA (correct): EVA = ΔNOPAT - ΔInventory × WACC, as a perpetuity
#let mva(q) = (annual-saving(q) - (-inv-release(q)) * r) / r
 
#let q-star = eoq(K, c, h)



= Questions

#let paul-q = eoq(K, c, h + r + 1)
#let pierre-q = eoq(K, c, h + r)
#let andreu-q = eoq(K-full, c-full, h)
#let share(q) = pct(npv(q) / npv(q-star))

== 1. Are the calculations in some of the reports incorrect?

- Yes. All three reports seem to have some errors but the calculations are mostly ok.
- The errors are in the figures especially to compute the cashflow.

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, right),
  [*Report*], [*Error*], [*Corrected NPV*],
  [Andreu (EOQ)],
  [
    - Andreu used costs that include fixed costs which don't change with the size of Q: $K =$ #money(K-full), $c =$ #money(c-full)
    - Depreciation (#money(setup.depreciation)) and overhead (#money(unit.overhead)/kg) are fixed and should be excluded.
    - Higher $K$ increases $Q^*$, while higher $c$ descreases it (they cancel near #money(q0) kg)
  ],
  [\$ #money(npv(andreu-q))],
  [Paul (NPV)],
  [
    - Paul factors the one-time inventory release every year (#money(inv-release(paul-q))/yr) which is wrong.
    - The holding cost used (#pct(h)) already includes the #pct(r) cost of capital, and he also counts the inventory cash flow (cost of capital counted twice)
    - Inconsistent inventory figures (1,971,448 vs 1,963,985)
  ],
  [\$ #money(npv(paul-q))],
  [Pierre (EVA)],
  [
    - EVA setup is correct
    - NOPAT uses the #pct(h) holding cost, which already includes #pct(r)
    - The capital charge adds #pct(r) again (effective rate of #pct(h + r))
  ],
  [\$ #money(npv(pierre-q))],
)

- Paul and Pierre do correctly exclude fixed costs from $K$ and $c$

== 2. If the calculations were correct, which approach is right?

- All three, if they:
  - use only incremental costs
  - charge the cost of capital exactly once
- Then all give #money(q-star) kg and \$ #money(npv(q-star))

$ "NPV"(q) = "MVA"(q) = (op("TRC")(q_0) - op("TRC")(q)) / r $

- Why they agree:
  - *NPV = MVA:* PV of all future EVAs = NPV, if the capital charge is on the same capital the cash flows create
  - *NPV = EOQ:* in a perpetuity, $r$ × one-time inventory release = annual cost of capital on that inventory (max NPV = min annual cost with $h = h_"mat" + r$)
- Correct objective: maximise value (NPV)
- EOQ minimises cost, which is equivalent here because revenue does not depend on batch size

== 3. Is one approach always superior to the others?

- No, but they do not cover the same ground

#table(
  columns: (auto, 1fr, 1fr),
  align: left,
  [*Method*], [*Strengths*], [*Limits*],
  [EOQ],
  [
    - Simple closed-form formula
    - Needs only four inputs
    - Shows the trade-off clearly
  ],
  [
    - Only valid under its assumptions (Q4)
    - Cost of capital must be built into $h$ correctly
  ],
  [NPV],
  [
    - Most general
    - Handles taxes, finite horizons, changing demand, transition timing, one-time costs
  ],
  [
    - Needs a full cash-flow model
    - Easy to get working capital wrong (Paul)
  ],
  [EVA / MVA],
  [
    - Equals NPV if done consistently
    - Links to managers' performance metrics
  ],
  [
    - Mixes book and market values
    - One year's EVA can mislead; only MVA is a decision rule
    - Easy to double-count capital cost (Pierre)
  ],
)

- NPV is the *reference*: EVA must match it, and EOQ is a special case of it
- Most general ≠ best tool for routine decisions

== 4. Are the other approaches inappropriate? What assumptions would invalidate them?

- None is inappropriate for Mainclas
- The case meets EOQ's assumptions: stable demand, one plant with spare capacity, no taxes
- EOQ stops being exact when:
  - *Demand varies or is uncertain*: safety stock, Wagner-Whitin, or simulation
  - *Horizon is finite* (end of life, patent expiry, 2-3-year shelf life) (no perpetuity; coverage must stay below shelf life)
  - *Capacity is shared*: setup cost includes lost production (shutdowns of "days or weeks") so, joint scheduling (ELSP)
  - *Production is not instant*: use EPQ: average inventory $= q(1 - d\/p)\/2$, not $q\/2$
  - *Taxes exist*: use after-tax costs and after-tax WACC; simple EOQ no longer matches NPV
- NPV and EVA can model all of these (they fail only when misapplied)

== 5. Are some approaches just rough approximations?

- Yes, even the corrected models simplify reality:
  - *EOQ uses averages:* an exact model discounts each setup and each unit of inventory at its actual date so the optimum shifts slightly
  - *Inventory release is not instant:* stock falls only as the current #money(q0)-kg campaign is used up (the release comes over year 1, so the real NPV is slightly lower)
  - *Lumpy flows are replaced by averages* (Paul's own stated assumption)
- This matters little because the value curve is flat near the optimum:

#let grid = (800, 1000, 1100, q-star, 1400, 1600, 2000)
#table(
  columns: (auto,) + (1fr,) * grid.len(),
  align: (left,) + (right,) * grid.len(),
  [*$q$ (kg)*], ..grid.map(q => [#money(q)]),
  [*NPV (\$)*], ..grid.map(q => [#money(npv(q))]),
  [*% of max*], ..grid.map(q => [#share(q)]),
)

- 1,000–1,600 kg (more than 90% of max value)
- Getting the method right matters more than precision:
  - Paul's error: a \$ #money(npv(q-star)) gain becomes a #money(-npv(paul-q)) loss
  - Rounding to 1,200 kg: still #share(1200) of max value

*Bottom line:*
- The reports disagree because of modelling errors, not because the methods disagree
- Done correctly, EOQ, NPV and EVA give the same answer
- Recommendation: cut the campaign to about #money(q-star) kg// ---------- helpers ----------
#let fmt(x, d: 2) = {
  let parts = str(calc.round(x, digits: d)).split(".")
  let frac = if parts.len() > 1 { parts.at(1) } else { "" }
  if d == 0 { parts.at(0) } else { parts.at(0) + "." + frac + "0" * (d - frac.len()) }
}
#let money(x) = {
  let v = int(calc.round(x))
  let s = str(calc.abs(v))
  let out = ""
  for (i, ch) in s.clusters().enumerate() {
    if i > 0 and calc.rem(s.len() - i, 3) == 0 { out += "," }
    out += ch
  }
  if v < 0 { "-" + out } else { out }
}
#let pct(x) = fmt(x * 100, d: 0) + "%"
 
// ---------- data (Exhibit 5) ----------
#let demand-hist = (2378, 2256, 2352, 2306, 2451, 2259, 2361, 2384, 2398, 2305)
#let d = demand-hist.sum() / demand-hist.len()   // kg / year
 
#let unit = (raw1: 1171, overhead: 712, raw2: 298, others: 73)           // \$ / kg
#let setup = (depreciation: 689523, cleaning: 65826, setup-raw: 21086)  // \$ / batch
 
#let c-full = unit.values().sum()               // incl. overhead
#let c = c-full - unit.overhead                 // incremental unit cost
#let K-full = setup.values().sum()              // incl. depreciation
#let K = K-full - setup.depreciation            // incremental setup cost
 
#let h-mat = 0.05     // non-financial holding cost (handling, obsolescence, insurance)
#let r = 0.12         // cost of capital = WACC (no taxes)
#let h = h-mat + r    // 17% total holding cost
#let q0 = 3000        // current campaign size, kg
 
// ---------- model ----------
// Every approach reduces to an EOQ-type optimum with some effective holding rate
#let eoq(K, c, h) = calc.sqrt(2 * K * d / (c * h))
 
// Annual relevant cost: setups + non-financial holding + capital charge on inventory
#let trc(q) = K * d / q + 0.5 * q * c * (h-mat + r)
 
// NPV (correct): inventory released once at t = 0, annual savings as a perpetuity
#let inv-release(q) = 0.5 * c * (q0 - q)
#let annual-saving(q) = K * d * (1 / q0 - 1 / q) + 0.5 * c * h-mat * (q0 - q)
#let npv(q) = inv-release(q) + annual-saving(q) / r
 
// MVA (correct): EVA = ΔNOPAT - ΔInventory × WACC, as a perpetuity
#let mva(q) = (annual-saving(q) - (-inv-release(q)) * r) / r
 
#let q-star = eoq(K, c, h)
