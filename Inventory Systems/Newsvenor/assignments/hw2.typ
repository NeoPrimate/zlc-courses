#import "@preview/lilaq:0.6.0" as lq
#import "@local/tystats:0.1.0": norm, poisson

#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)

#let result(content) = box(stroke: blue, fill: blue.transparentize(75%), inset: 0.5em, radius: 0.25em)[#content]

#h(1fr) Vladimir Borel

// ============================================================
// Shared helpers
// ============================================================
// NOTE: never name a variable mu, sigma, lambda, phi, Phi, pi or theta:
// in math mode a defined variable replaces the Greek letter.

// Rounding for display
#let r(x, digits: 2) = calc.round(x, digits: digits)
#let r4(x) = calc.round(x, digits: 4)

// Critical ratio cr = c_u / (c_u + c_o)
#let critical_ratio(cu, co) = cu / (cu + co)

// Standard normal loss L(z) = E[(Z - z)^+] = phi(z) - z (1 - Phi(z))
#let loss(z) = norm.pdf(z) - z * (1 - norm.cdf(z))

// Normal demand: Q* = F^(-1)(cr)
#let normal_q(ratio, mean, sd) = norm.ppf(ratio, mean: mean, std_dev: sd)

// Normal demand: expected outcomes for order q
#let normal_outcomes(q, mean, sd) = {
  let z = (q - mean) / sd
  let L = loss(z)
  let short = sd * L // E[(D - q)^+]
  (z: z, L: L, short: short, sold: mean - short, left: q - mean + short)
}

// Poisson demand: expected outcomes for order q
#let poisson_outcomes(q, lam) = {
  let short = lam * (1 - poisson.cdf(q - 1, lam)) - q * (1 - poisson.cdf(q, lam))
  (short: short, sold: lam - short, left: q - lam + short)
}

// Newsvendor profit = p E[Sold] + s E[Left] - g E[Short] - c q
#let nv_profit(out, q, price: 0, cost: 0, salvage: 0, goodwill: 0) = (
  price * out.sold + salvage * out.left - goodwill * out.short - cost * q
)

// ============================================================
#[
= Problem 1 (Max Points 40)

Sport Zone's running shoes division in Zaragoza purchases a line of shoes at €30 from its supplier in China. As there is a long lead time, at the time of order placement, demand is still uncertain. Sport Zone has a forecast that its demand is normally distributed with mean 2,100 and standard deviation 600 for the upcoming season. In addition, Sport Zone recently found an alternative supplier in Portugal with a higher unit cost of €40 but with a negligible lead time. As the lead time from Portugal is very short, Sport Zone may make the order decision from Portugal even after demand is realized. Sport Zone sells the shoes at €50 each. The leftover inventory can be sold to discounters for €5.

#let price = 50
#let cost_cn = 30 // China
#let cost_pt = 40 // Portugal
#let salvage = 5
#let mean = 2100
#let sd = 600

#let out(q, sd: sd) = normal_outcomes(q, mean, sd)
#let profit(q, out, goodwill: 0) = nv_profit(out, q, price: price, cost: cost_cn, salvage: salvage, goodwill: goodwill)

- $p = #price, quad c_c = #cost_cn, quad c_p = #cost_pt, quad s = #salvage$
- $D tilde cal(N)(mu = #mean, sigma = #sd)$

$
  z = (Q - mu) / sigma, quad L(z) = phi(z) - z (1 - Phi(z)) \
  E["Short"] = sigma L(z), quad E["Sold"] = mu - E["Short"], quad E["Left"] = Q - mu + E["Short"]
$

_(a) If Sport Zone can only place an order from the supplier in China, how many shoes should Sport Zone buy to maximize its expected profit in the upcoming season? What is its expected profit? (5 points)_

#let cu_a = price - cost_cn
#let co_a = cost_cn - salvage
#let cr_a = critical_ratio(cu_a, co_a)
#let Q_a = normal_q(cr_a, mean, sd)
#let out_a = out(Q_a)
#let profit_a = profit(Q_a, out_a)

$
  c_u &= p - c_c = #price - #cost_cn = #cu_a \
  c_o &= c_c - s = #cost_cn - #salvage = #co_a \
  "cr" &= c_u / (c_u + c_o) = #cu_a / (#cu_a + #co_a) = #r4(cr_a) \
  z^* &= Phi^(-1)("cr") = #r4(out_a.z) \
  Q^* &= mu + z^* sigma = #mean + (#r4(out_a.z))(#sd) = #result[#r(Q_a)] approx #calc.round(Q_a)
$

$
  L(z^*) &= #r4(out_a.L) \
  E["Short"] &= #sd times #r4(out_a.L) = #r(out_a.short) \
  E["Sold"] &= #mean - #r(out_a.short) = #r(out_a.sold) \
  E["Left"] &= #r(Q_a) - #mean + #r(out_a.short) = #r(out_a.left)
$

$
  pi_a &= p E["Sold"] + s E["Left"] - c_c Q \
  &= #price times #r(out_a.sold) + #salvage times #r(out_a.left) - #cost_cn times #r(Q_a) \
  &= #result[#r(profit_a)]
$

#let qs = lq.linspace(0, 4000, num: 300)
#let outs = qs.map(q => out(q))

#figure(
  lq.diagram(
    width: 10cm,
    height: 6cm,
    xlim: (0, 4000),
    ylim: (0, 1),
    xlabel: [$Q$],
    ylabel: [$F(Q)$],
    lq.plot(qs, qs.map(q => norm.cdf(q, mean: mean, std_dev: sd)), mark: none, stroke: 1.5pt),
    lq.hlines(cr_a, max: Q_a, stroke: 1pt + red),
    lq.vlines(Q_a, max: cr_a, stroke: 1pt + red),
  ),
  caption: [$Q^* = F^(-1)("cr")$],
)

#let cost_over = outs.map(o => co_a * o.left)
#let cost_under = outs.map(o => cu_a * o.short)
#let mismatch = cost_over.zip(cost_under).map(((o, u)) => o + u)

#figure(
  lq.diagram(
    width: 10cm,
    height: 6cm,
    xlim: (0, 4000),
    ylim: (0, 60000),
    xlabel: [$Q$],
    ylabel: [Expected cost (€)],
    legend: (position: top + right),
    lq.plot(qs, cost_over, mark: none, label: [$c_o E["Left"]$]),
    lq.plot(qs, cost_under, mark: none, label: [$c_u E["Short"]$]),
    lq.plot(qs, mismatch, mark: none, stroke: 1.5pt, label: [$M(Q)$]),
    lq.vlines(Q_a, stroke: (paint: black, dash: "dashed")),
  ),
  caption: [Mismatch cost $M(Q)$. $pi(Q) = (p - c_c) mu - M(Q)$, so $Q^*$ minimizes $M$.],
)

#let revenue = outs.map(o => price * o.sold)
#let salvage_rev = outs.map(o => salvage * o.left)
#let purchase = qs.map(q => cost_cn * q)
#let profit_q = qs.zip(outs).map(((q, o)) => profit(q, o))

#figure(
  lq.diagram(
    width: 10cm,
    height: 6cm,
    xlim: (0, 4000),
    xlabel: [$Q$],
    ylabel: [€],
    legend: (position: top + left),
    lq.plot(qs, revenue, mark: none, label: [$p E["Sold"]$]),
    lq.plot(qs, salvage_rev, mark: none, label: [$s E["Left"]$]),
    lq.plot(qs, purchase, mark: none, label: [$c_c Q$]),
    lq.plot(qs, profit_q, mark: none, stroke: 1.5pt, label: [$pi(Q)$]),
    lq.vlines(Q_a, stroke: (paint: black, dash: "dashed")),
  ),
  caption: [Components of expected profit.],
)

_(b) If Sport Zone can place an order from both suppliers, how many shoes should Sport Zone buy from China to maximize expected profit, especially considering that it still has a chance to order some quantity from Portugal after demand is realized? What is its expected profit in this case? (5 points)_

#let cu_b = cost_pt - cost_cn
#let co_b = cost_cn - salvage
#let cr_b = critical_ratio(cu_b, co_b)
#let Q_b = normal_q(cr_b, mean, sd)
#let out_b = out(Q_b)
#let profit_b = price * mean - cost_cn * Q_b - cost_pt * out_b.short + salvage * out_b.left

- Demand above $Q$ is ordered from Portugal after demand is known $=>$ no lost sales
- Underage = extra sourcing cost only

$
  c_u &= (p - c_c) - (p - c_p) = c_p - c_c = #cost_pt - #cost_cn = #cu_b \
  c_o &= c_c - s = #cost_cn - #salvage = #co_b \
  "cr" &= #cu_b / (#cu_b + #co_b) = #r4(cr_b) \
  z^* &= #r4(out_b.z) \
  Q^* &= #mean + (#r4(out_b.z))(#sd) = #result[#r(Q_b)] approx #calc.round(Q_b)
$

$
  E["Portugal"] &= E["Short"] = #sd times #r4(out_b.L) = #r(out_b.short) \
  E["Left"] &= #r(Q_b) - #mean + #r(out_b.short) = #r(out_b.left)
$

- All $mu$ units are sold at $p$:

$
  pi_b &= p mu - c_c Q - c_p E["Portugal"] + s E["Left"] \
  &= #price times #mean - #cost_cn times #r(Q_b) - #cost_pt times #r(out_b.short) + #salvage times #r(out_b.left) \
  &= #result[#r(profit_b)]
$

- China order drops by $#r(Q_a) - #r(Q_b) = #r(Q_a - Q_b)$ units: a shortage now costs #cu_b € instead of #cu_a €

#let pdf(x) = norm.pdf(x, mean: mean, std_dev: sd)
#let xs = lq.linspace(0, 4200, num: 300)
#let xs_cn = lq.linspace(0, Q_b, num: 150)
#let xs_pt = lq.linspace(Q_b, 4200, num: 150)
#let p_cn_only = norm.cdf(Q_b, mean: mean, std_dev: sd)

#figure(
  lq.diagram(
    width: 10cm,
    height: 6cm,
    xlim: (0, 4200),
    ylim: (0, auto),
    xlabel: [Demand $D$],
    ylabel: [$f(D)$],
    legend: (position: top + left),
    lq.fill-between(xs_cn, xs_cn.map(pdf), fill: blue.transparentize(60%),
      label: [$D <= Q^*_b$: China only ($P = #r(p_cn_only, digits: 3)$)]),
    lq.fill-between(xs_pt, xs_pt.map(pdf), fill: orange.transparentize(60%),
      label: [$D > Q^*_b$: Portugal tops up ($P = #r(1 - p_cn_only, digits: 3)$)]),
    lq.plot(xs, xs.map(pdf), mark: none, stroke: 1.5pt + black),
    lq.vlines(Q_b, stroke: (paint: red, dash: "dashed"), label: [$Q^*_b approx #calc.round(Q_b)$]),
    lq.vlines(Q_a, stroke: (paint: black, dash: "dashed"), label: [$Q^*_a approx #calc.round(Q_a)$]),
  ),
  caption: [Demand split at the China order quantity.],
)

_(c) Now suppose that Sport Zone has to make a one-time contract payment to establish a business relationship with the Portuguese supplier. What is the maximum amount Sport Zone would be willing to pay to have this new supplier? (5 points)_

#let option_value = profit_b - profit_a

- Max payment = expected profit gain from Portugal

$
  pi_b - pi_a = #r(profit_b) - #r(profit_a) = #result[#r(option_value)]
$

_(d) Now back to (a), suppose that Sport Zone is considering a thesis project with ZLOG 2017 to improve their demand forecasting. If the company anticipates a more accurate forecast with the same mean but a reduced standard deviation of $(1 - theta) times 600$ (where $theta$ is a number between 0 and 1), how much would Sport Zone be willing to pay for this project? Please express your response as a function of $theta$ (rather than testing different values of $theta$). (5 points)_

#let z_star = out_a.z
#let phi_star = norm.pdf(z_star)
#let slope = (cu_a + co_a) * phi_star // € lost per unit of sigma
#let value_perfect = slope * sd // V(1): value of a perfect forecast
#let profit_perfect = (price - cost_cn) * mean

- $z^* = Phi^(-1)("cr") = #r4(z_star)$ depends only on cr, not on $sigma$
- $Q^* = mu + z^* sigma$, $E["Short"] = sigma L(z^*)$, $E["Left"] = sigma (z^* + L(z^*))$ $=>$ all scale with $sigma$

$
  pi(sigma)
  &= (p - c_c) mu - c_o E["Left"] - c_u E["Short"] \
  &= (p - c_c) mu - sigma [c_o z^* + (c_u + c_o) L(z^*)] \
  &= (p - c_c) mu - (c_u + c_o) phi(z^*) sigma
$

- Last step uses $1 - Phi(z^*) = c_o \/ (c_u + c_o)$
- Slope:

$
  (c_u + c_o) phi(z^*) = (#cu_a + #co_a) times #r4(phi_star) = #r(slope) "€ per unit of" sigma
$

- With $sigma' = (1 - theta) sigma$:

$
  V(theta)
  &= pi((1 - theta) sigma) - pi(sigma) \
  &= (c_u + c_o) phi(z^*) sigma theta \
  &= #r(slope) times #sd times theta \
  &= #result[#r(value_perfect) $theta$]
$

- Check, $theta = 1$: $V = #r(value_perfect)$ = mismatch cost in (a) $= (p - c_c) mu - pi_a = #r(profit_perfect - profit_a)$

#let profit_for_sd(s) = {
  if s < 1e-9 { return profit_perfect }
  let q = normal_q(cr_a, mean, s)
  profit(q, out(q, sd: s))
}
#let profit_theta(t) = profit_a + value_perfect * t
#let theta_breakeven = option_value / value_perfect

#let ts = lq.linspace(0, 1, num: 100)
#let ts_check = lq.linspace(0, 1, num: 11)

#figure(
  lq.diagram(
    width: 10cm,
    height: 6cm,
    xlim: (0, 1),
    ylim: (30000, 43000),
    xlabel: [$theta$],
    ylabel: [Expected profit (€)],
    legend: (position: bottom + right),
    lq.fill-between(ts, ts.map(_ => profit_a), y2: ts.map(profit_theta),
      fill: blue.transparentize(80%), label: [$V(theta) = #r(value_perfect) theta$]),
    lq.plot(ts, ts.map(profit_theta), mark: none, stroke: 1.5pt, label: [$pi(theta)$, closed form]),
    lq.scatter(ts_check, ts_check.map(t => profit_for_sd((1 - t) * sd)),
      color: black, size: 4pt, label: [$pi(theta)$, newsvendor]),
    lq.hlines(profit_a, stroke: (paint: gray, dash: "dotted")),
    lq.hlines(profit_perfect, stroke: (paint: gray, dash: "dotted")),
    lq.hlines(profit_b, stroke: (paint: orange, dash: "dashed"), label: [$pi_b$ (Portugal backup)]),
    lq.vlines(theta_breakeven, stroke: 0.8pt + orange),
  ),
  caption: [Project beats the Portugal backup for $theta > #r(theta_breakeven, digits: 3)$.],
)

_(e) What do you observe in (d) in terms of the impact of standard deviation on the expected profit? (5 points)_

- $pi^*(sigma) = (p - c_c) mu - #r(slope) sigma$: linear, decreasing in $sigma$
- Each unit of $sigma$ costs #r(slope)
- $sigma = 0$: $pi = (p - c_c) mu = #profit_perfect$ (perfect information)
- $sigma = #sd$: $pi = #r(profit_a)$
- $z^* = #r4(z_star) < 0$ (cr $< 0.5$) $=> Q^* < mu$, gap grows with $sigma$

_(f) Back to (a), the company has realized from their history that if a customer can't find buy what he/she wants because of stock out, their reputation gets worse and they eventually lose some of the customers. They have estimated this undesirable impact as the monetary cost, which is €3 per each of lost sales. What is the optimal order quantity and the expected profit respectively? What do you observe here especially comparing this result with that of (a)? (5 points)_

#let g_f = 3
#let cu_f = price - cost_cn + g_f
#let co_f = cost_cn - salvage
#let cr_f = critical_ratio(cu_f, co_f)
#let Q_f = normal_q(cr_f, mean, sd)
#let out_f = out(Q_f)
#let profit_f = profit(Q_f, out_f, goodwill: g_f)

$
  c_u &= p - c_c + g = #price - #cost_cn + #g_f = #cu_f \
  c_o &= c_c - s = #co_f \
  "cr" &= #cu_f / (#cu_f + #co_f) = #r4(cr_f) \
  z^* &= #r4(out_f.z) \
  Q^* &= #mean + (#r4(out_f.z))(#sd) = #result[#r(Q_f)] approx #calc.round(Q_f)
$

$
  pi_f &= p E["Sold"] + s E["Left"] - g E["Short"] - c_c Q \
  &= #price times #r(out_f.sold) + #salvage times #r(out_f.left) - #g_f times #r(out_f.short) - #cost_cn times #r(Q_f) \
  &= #result[#r(profit_f)]
$

- vs (a): $Q^*$ up by #r(Q_f - Q_a), $pi$ down by #r(profit_a - profit_f)
- Goodwill raises $c_u$ $=>$ higher cr $=>$ order more
- Profit falls: each stockout now costs $g$ on top of the lost margin

_(g) In (f), what are the optimal order quantity and the expected profit if the monetary cost per each of lost sales is €10, €20, €30 and €40? What do you observe here especially comparing this result with that of (f)? (5 points)_

#let solve_goodwill(g) = {
  let cr = critical_ratio(price - cost_cn + g, co_a)
  let q = normal_q(cr, mean, sd)
  (g: g, cr: cr, q: q, profit: profit(q, out(q), goodwill: g))
}
#let rows = (0, 3, 10, 20, 30, 40).map(solve_goodwill)

#table(
  columns: 5,
  inset: 0.6em,
  table.header([$g$], [cr], [$Q^*$], [$Q^* - mu$], [$pi^*$]),
  ..rows.map(x => (
    [#x.g], [#r4(x.cr)], [#r(x.q)], [#r(x.q - mean)], [#r(x.profit)],
  )).flatten()
)

- Higher $g$ $=>$ higher cr $=>$ higher $Q^*$
- $Q^* > mu$ once cr $> 0.5$ $<=> c_u > c_o <=> g > c_o - (p - c_c) = #(co_a - cu_a)$
- Expected profit keeps falling as $g$ rises
- Expensive stockouts $=>$ order well above mean demand

_(h) In (a), suppose Sport Zone has to pay a fixed transportation cost of €500 whenever it places an order in addition to other costs. How many shoes should Sport Zone buy to maximize its expected profit in the upcoming season? What is its expected profit? (5 points)_

#let fixed_cost = 500

- Fixed cost does not change $c_u$ or $c_o$ $=>$ same $Q^* = #r(Q_a)$
- Still order, since $pi_a - #fixed_cost > 0$

$
  pi_h = pi_a - #fixed_cost = #r(profit_a) - #fixed_cost = #result[#r(profit_a - fixed_cost)]
$
]

// ============================================================
#[
= Problem 2 (Max Points 35)

Sam Holding (SH) sells a tent to Intersport (IP). SH's variable cost per tent is €100 while its wholesale price is €185 per tent (the wholesale price includes the cost of shipping the tent to IP). IP sells the tent for €250. Suppose IP's forecast for season sales can be described with a Poisson distribution with rate (mean) 8.75. Furthermore, IP plans to only buy once from SH and any eventual leftovers are sold at a discount of 75% (i.e., at €62.5 per tent).

#let c = 100 // SH's variable cost
#let w = 185 // wholesale price
#let p = 250 // retail price
#let s = 62.5 // salvage value
#let lam = 8.75 // Poisson mean

#let out(q) = poisson_outcomes(q, lam)
#let q_for(cr) = poisson.ppf(cr, lam) // smallest k with F(k) >= cr

// F(k - 1) < cr <= F(k) => Q* = k
#let poisson_step(q, cr) = $
  F(#(q - 1)) = #r4(poisson.cdf(q - 1, lam)) < #r4(cr) <= F(#q) = #r4(poisson.cdf(q, lam))
  ==> Q^* = #result[#q]
$

- $c = #c, quad w = #w, quad p = #p, quad s = #s$
- $D tilde "Poisson"(lambda = #lam)$

$
  E["Short"] = lambda (1 - F(Q - 1)) - Q (1 - F(Q)) \
  E["Sold"] = lambda - E["Short"], quad E["Left"] = Q - E["Sold"]
$

_(a) How many tents should IP order? (5 points)_

#let cu_a = p - w
#let co_a = w - s
#let cr_a = critical_ratio(cu_a, co_a)
#let Q_a = q_for(cr_a)

$
  c_u &= p - w = #cu_a \
  c_o &= w - s = #co_a \
  "cr" &= c_u / (c_u + c_o) = #r4(cr_a)
$

#poisson_step(Q_a, cr_a)

_(b) What is IP's expected profit given his optimal order quantity in (a)? (5 points)_

#let out_b = out(Q_a)
#let profit_ip_b = nv_profit(out_b, Q_a, price: p, cost: w, salvage: s)

$
  E["Short"] &= #r(out_b.short) \
  E["Sold"] &= #lam - #r(out_b.short) = #r(out_b.sold) \
  E["Left"] &= #Q_a - #r(out_b.sold) = #r(out_b.left)
$

$
  pi_"IP" &= p E["Sold"] + s E["Left"] - w Q \
  &= #p times #r(out_b.sold) + #s times #r(out_b.left) - #w times #Q_a \
  &= #result[#r(profit_ip_b)]
$

_(c) What is SH's expected profit given IP's order in part (a)? (5 points)_

#let profit_sh_c = (w - c) * Q_a

$
  pi_"SH" = (w - c) Q = (#w - #c) times #Q_a = #result[#profit_sh_c]
$

_(d) To maximize the supply chain's total profit (SH's profit plus IP's profit) how many tents should be shipped to IP? (5 points)_

#let cu_d = p - c
#let co_d = c - s
#let cr_d = critical_ratio(cu_d, co_d)
#let Q_d = q_for(cr_d)

- Supply chain buys at $c$, not $w$

$
  c_u &= p - c = #cu_d \
  c_o &= c - s = #co_d \
  "cr" &= #r4(cr_d)
$

#poisson_step(Q_d, cr_d)

_(e)–(f): Suppose SH were to accept unsold tents at the end of the season. IP would incur a €15 shipping cost per tent returned to SH. Suppose SH gives IP a 90% credit for each returned tent, that is, SH pays IP €166.5 for each returned tent._

#let shipping = 15
#let b = 0.9 * w // buyback price = 166.5
#let s_e = b - shipping // IP's net value per leftover = 151.5

- $b = 0.9 w = #b$
- IP's net value per leftover: $b - "shipping" = #s_e$

_(e) How many tents should IP order to maximize its profit? (5 points)_

#let cu_e = p - w
#let co_e = w - s_e
#let cr_e = critical_ratio(cu_e, co_e)
#let Q_e = q_for(cr_e)

$
  c_u &= p - w = #cu_e \
  c_o &= w - (b - "shipping") = #co_e \
  "cr" &= #r4(cr_e)
$

#poisson_step(Q_e, cr_e)

_(f) What is the expected profit for IP and SH, given IP's order in part (e)? (5 points)_

#let out_f = out(Q_e)
#let profit_ip_f = nv_profit(out_f, Q_e, price: p, cost: w, salvage: s_e)
#let profit_sh_f = (w - c) * Q_e - b * out_f.left

$
  E["Short"] &= #r(out_f.short) \
  E["Sold"] &= #lam - #r(out_f.short) = #r(out_f.sold) \
  E["Left"] &= #Q_e - #r(out_f.sold) = #r(out_f.left)
$

$
  pi_"IP" &= p E["Sold"] + (b - "shipping") E["Left"] - w Q \
  &= #p times #r(out_f.sold) + #s_e times #r(out_f.left) - #w times #Q_e \
  &= #result[#r(profit_ip_f)]
$

$
  pi_"SH" &= (w - c) Q - b E["Left"] \
  &= (#w - #c) times #Q_e - #b times #r(out_f.left) \
  &= #result[#r(profit_sh_f)]
$

- Assumes returned tents are worth nothing to SH

_(g) To maximize the supply chain's total profit, what should IP's buyback percentage be? (The current credit is 90%). Assuming that SH can sell all returned tents at €185 per tent, is profit maximizing buyback percentage feasible? (5 points)_

#let resale = 185 // SH's resale price for returns
#let b_g = p + shipping - (p - w) / cr_d // coordinating buyback price
#let s_g = b_g - shipping
#let cr_g = critical_ratio(p - w, w - s_g)
#let Q_g = q_for(cr_g)
#let out_g = out(Q_g)
#let profit_ip_g = nv_profit(out_g, Q_g, price: p, cost: w, salvage: s_g)
#let profit_sh_g = (w - c) * Q_g - (b_g - resale) * out_g.left
#let profit_sh_f_resale = profit_sh_f + resale * out_f.left

- Coordination: IP's cr = supply chain's cr from (d)

$
  (p - w) / (p - w + w - (b - "shipping")) = (p - w) / (p - b + "shipping") = #r4(cr_d)
$

$
  b^* &= p + "shipping" - (p - w) / "cr"_"SC" = #p + #shipping - #cu_e / #r4(cr_d) = #result[#r(b_g)] \
  b^* / w &= #r(b_g) / #w = #result[#r(b_g / w * 100) %]
$

- IP then orders $Q = #Q_g$ = supply-chain optimum from (d)
- SH pays $b^* = #r(b_g)$, resells at $r = #resale$ $=>$ keeps $r - b^* = #r(resale - b_g)$ per return $>= 0$ $=>$ *feasible*

$
  pi_"IP" &= p E["Sold"] + (b^* - "shipping") E["Left"] - w Q = #r(profit_ip_g) \
  pi_"SH" &= (w - c) Q - (b^* - r) E["Left"] = #r(profit_sh_g)
$

- vs 90% credit (f): IP #r(profit_ip_g) vs #r(profit_ip_f); SH #r(profit_sh_g) vs #r(profit_sh_f_resale) (with resale) $=>$ both better off
]

// ============================================================
#[
= Problem 3 (Max Points 15)

Each year the admissions committee at a top business school receives a large number of applications for admission to the MBA program and they have to decide on the number of offers to make. Since some of the admitted students may decide to pursue other opportunities, the committee typically admits more students than the ideal class size of 720 students. You were asked to help the admissions committee estimate the appropriate number of people who should be admitted. It is estimated that in the coming year the number of people who will not accept the admission offer is normally distributed with mean 50 and standard deviation 21. Suppose for now that this school does not maintain a waiting list, that is, all students are accepted or rejected.

#let n_ideal = 720
#let mean = 50 // mean no-shows R
#let sd = 21 // std. dev. of no-shows R

// Buffer newsvendor: admit Q = 720 + y, with y = mean + z sd
#let solve_buffer(cu, co) = {
  let cr = critical_ratio(cu, co)
  let z = norm.ppf(cr)
  let y = mean + z * sd
  (cr: cr, z: z, y: y, q: n_ideal + y)
}

- $R tilde cal(N)(mu = #mean, sigma = #sd)$: admitted students who decline
- Admit $Q$ $=>$ class size $Q - R$

_(a) Suppose 750 students are admitted. What is the probability that the class size will be at least 720 students? (5 points)_

#let Q_a = 750
#let r_max = Q_a - n_ideal // class >= 720 <=> R <= 30
#let z_a = (r_max - mean) / sd
#let prob_a = norm.cdf(z_a)

$
  P(Q - R >= #n_ideal) &= P(R <= #Q_a - #n_ideal) = P(R <= #r_max) \
  z &= (#r_max - #mean) / #sd = #r4(z_a) \
  P(R <= #r_max) &= Phi(#r4(z_a)) = #result[#r4(prob_a)]
$

#let xs = lq.linspace(mean - 4 * sd, mean + 4 * sd, num: 200)
#let pdf(x) = norm.pdf(x, mean: mean, std_dev: sd)
#let xs_fill = xs.filter(x => x <= r_max)

#figure(
  lq.diagram(
    width: 10cm,
    height: 6cm,
    xlabel: [No-shows $R$],
    ylabel: [Density],
    lq.fill-between(xs_fill, xs_fill.map(pdf)),
    lq.plot(xs, xs.map(pdf), mark: none, stroke: 1.5pt),
    lq.vlines(r_max, stroke: 1pt + red),
  ),
  caption: [Shaded: $P(R <= #r_max)$ = class has at least #n_ideal students.],
)

_(b) There is a mutual agreement that it is about two times more expensive to have a student in excess of the ideal 720 than to have fewer students in the class. What is the appropriate number of students to admit? (5 points)_

- Newsvendor on buffer $y = Q - #n_ideal$
- $R < y$ $=>$ class too big (overage); $R > y$ $=>$ too small (underage)

#let cu_b = 1
#let co_b = 2
#let sol_b = solve_buffer(cu_b, co_b)

$
  "cr" &= c_u / (c_u + c_o) = #cu_b / (#cu_b + #co_b) = #r4(sol_b.cr) \
  z^* &= Phi^(-1)(#r4(sol_b.cr)) = #r4(sol_b.z) \
  y^* &= mu + z^* sigma = #mean + (#r4(sol_b.z))(#sd) = #r(sol_b.y) \
  Q^* &= #n_ideal + y^* = #r(sol_b.q) approx #result[#calc.round(sol_b.q)]
$

_(c) A waiting list mitigates the problem of having too few students since at the very last moment there is an opportunity to admit some students from the waiting list. Hence, the admissions committee revises its estimate: It claims that it is five times more expensive to have a student in excess of 720 than to have fewer students accept among the initial group of admitted students. What is your revised suggestion? (5 points)_

#let cu_c = 1
#let co_c = 5
#let sol_c = solve_buffer(cu_c, co_c)

$
  "cr" &= #cu_c / (#cu_c + #co_c) = #r4(sol_c.cr) \
  z^* &= Phi^(-1)(#r4(sol_c.cr)) = #r4(sol_c.z) \
  y^* &= #mean + (#r4(sol_c.z))(#sd) = #r(sol_c.y) \
  Q^* &= #n_ideal + y^* = #r(sol_c.q) approx #result[#calc.round(sol_c.q)]
$

- Waiting list makes shortage cheap $=>$ lower cr $=>$ admit fewer (#calc.round(sol_b.q) $->$ #calc.round(sol_c.q))
]

// ============================================================
#[
= Problem 4 (Max Points 10)

In the formal presentation of the Newsvendor problem, we have shown that the profit maximization problem is equivalent to the minimizing of the following cost function:

$
  C(Q) = E[C_u dot (D - Q)^+ + C_o dot (Q - D)^+] = C_u E["Short"] + C_o E["Left"]
$

Assume that the demand is normally distributed with mean $mu$ and standard deviation $sigma$. By using the characterization (i.e., expression) for the optimal order quantity, $Q^*$, show that the optimal cost can be expressed as $C(Q^*) = A(C_u, C_o) times sigma$, where $A(C_u, C_o)$ is a constant which is a function of the cost parameters $C_u$ and $C_o$ but not of the parameters $(mu, sigma)$ of the demand distribution $D$. What can you infer for the maximum profit that the newsvendor can gain by ordering the optimal quantity?

*Optimal quantity*

- $D = mu + sigma Z$, $Z tilde cal(N)(0, 1)$

$
  Phi(z^*) = C_u / (C_u + C_o), quad Q^* = mu + z^* sigma
$

- $z^*$ depends only on $C_u, C_o$

*Short and left*

- $L(z) = phi(z) - z (1 - Phi(z))$
- $(Q - D)^+ = (Q - D) + (D - Q)^+$

$
  E["Short"] &= sigma E[(Z - z^*)^+] = sigma L(z^*) \
  E["Left"] &= (Q^* - mu) + E["Short"] = sigma (z^* + L(z^*))
$

*Optimal cost*

$
  C(Q^*)
  &= C_u sigma L(z^*) + C_o sigma (z^* + L(z^*)) \
  &= sigma [(C_u + C_o) L(z^*) + C_o z^*]
$

- Use $1 - Phi(z^*) = C_o \/ (C_u + C_o)$:

$
  (C_u + C_o) L(z^*)
  &= (C_u + C_o) phi(z^*) - z^* (C_u + C_o) dot C_o / (C_u + C_o) \
  &= (C_u + C_o) phi(z^*) - C_o z^*
$

- $C_o z^*$ cancels:

$
  C(Q^*) = (C_u + C_o) phi(z^*) dot sigma
$

$
  #result[$display(A(C_u, C_o) = (C_u + C_o) thin phi(Phi^(-1)(C_u / (C_u + C_o))))$]
$

*Maximum profit*

- $C_u = p - c$, $C_o = c - s$
- $E["Sold"] = mu - E["Short"]$, $Q = E["Sold"] + E["Left"]$

$
  Pi(Q)
  &= p E["Sold"] + s E["Left"] - c Q \
  &= (p - c) mu - (p - c) E["Short"] - (c - s) E["Left"] \
  &= C_u mu - C(Q)
$

$
  #result[$Pi(Q^*) = C_u mu - A(C_u, C_o) sigma$]
$

*Takeaways*

- $C_u mu$: profit with perfect information; $A sigma$: cost of uncertainty
- Max profit falls linearly in $sigma$; halve $sigma$ $=>$ halve mismatch cost
- $Pi(Q^*) \/ (C_u mu) = 1 - (A \/ C_u) dot sigma \/ mu$ $=>$ coefficient of variation $sigma \/ mu$ is what matters
- Profitable only if $sigma \/ mu < C_u \/ A$
]

// ============================================================
#[
= Quiz Problem (Max Points 20)

On a given Boston-Barcelona flight, there are 200 seats. Suppose the ticket price is \$475 on average and the number of passengers who reserve a seat but do not show up for departure is normally distributed with mean 30 and standard deviation 15. You decide to overbook the flight and estimate that the average loss from a passenger who will have to be bumped (if the number of passengers exceeds the number of seats) is \$800.

#let seats = 200
#let price = 475
#let bump_cost = 800
#let mean_ns = 30 // mean no-shows
#let sd_ns = 15 // std. dev. of no-shows

- $N tilde cal(N)(mu = #mean_ns, sigma = #sd_ns)$: no-shows
- $Y$ = reservations above #seats
- $N < Y$ $=>$ bumped (overage); $N > Y$ $=>$ empty seat (underage)

_(a) What is the maximum number of reservations that should be accepted? (2 points)_

#let cu_a = price // empty seat
#let co_a = bump_cost // bumped passenger
#let cr_a = critical_ratio(cu_a, co_a)
#let z_a = norm.ppf(cr_a)
#let y_a = mean_ns + z_a * sd_ns
#let res_a = seats + y_a

$
  c_u &= #cu_a, quad c_o = #co_a \
  "cr" &= #cu_a / (#cu_a + #co_a) = #r4(cr_a) \
  z^* &= Phi^(-1)(#r4(cr_a)) = #r4(z_a) \
  Y^* &= mu + z^* sigma = #mean_ns + (#r4(z_a))(#sd_ns) = #r(y_a) \
  "Reservations" &= #seats + Y^* = #r(res_a) approx #result[#calc.round(res_a)]
$

_(b) Suppose you allow 220 reservations. How much money do you expect to pay out in compensation to bumped passengers? (2 points)_

#let res_b = 220
#let y_b = res_b - seats
#let out_b = normal_outcomes(y_b, mean_ns, sd_ns) // short = empty seats, left = bumped
#let payout_b = bump_cost * out_b.left

- Bumped $= (Y - N)^+$ = "leftover"

$
  z &= (Y - mu) / sigma = (#y_b - #mean_ns) / #sd_ns = #r4(out_b.z), quad L(z) = #r4(out_b.L) \
  E[(N - Y)^+] &= sigma L(z) = #r(out_b.short) \
  E["Bumped"] &= (Y - mu) + sigma L(z) = #(y_b - mean_ns) + #r(out_b.short) = #r(out_b.left) \
  E["Payout"] &= #bump_cost times #r(out_b.left) = #result[\$#r(payout_b)]
$

_(c) Suppose you allow 220 reservations. What is the probability that you will have to deal with bumped passengers? (2 points)_

#let prob_c = norm.cdf(out_b.z)

$
  P(N < #y_b) = Phi((#y_b - #mean_ns) / #sd_ns) = Phi(#r4(out_b.z)) = #result[#r4(prob_c)]
$

_(d)–(g): Now assume there is no overbooking, and the high fare is \$675 and the low fare is \$375. Demand for the low fare is abundant while demand for the high fare is normally distributed with a mean of 80 and standard deviation 35._

#let fare_high = 675
#let fare_low = 375
#let mean_h = 80
#let sd_h = 35

- $D_H tilde cal(N)(mu = #mean_h, sigma = #sd_h)$: high-fare demand
- $Q$ = protection level; low fare gets $#seats - Q$ seats, always sold

_(d) What is the probability of selling 200 reservations if you set an optimal protection level (i.e., number of seats reserved) for the full fare? (8 points)_

#let cu_d = fare_high - fare_low // high-fare customer turned away
#let co_d = fare_low // protected seat flies empty
#let cr_d = critical_ratio(cu_d, co_d)
#let z_d = norm.ppf(cr_d)
#let q_exact = mean_h + z_d * sd_h
#let q_d = calc.round(q_exact)
#let z_q = (q_d - mean_h) / sd_h
#let prob_d = 1 - norm.cdf(z_q)

$
  c_u &= r_H - r_L = #cu_d, quad c_o = r_L = #co_d \
  "cr" &= #cu_d / (#cu_d + #co_d) = #r4(cr_d) \
  z^* &= Phi^(-1)(#r4(cr_d)) = #r4(z_d) \
  Q^* &= #mean_h + (#r4(z_d))(#sd_h) = #r(q_exact) approx #q_d
$

- Booking limit for low fare: $#seats - #q_d = #(seats - q_d)$, always filled
- All #seats sold $<=>$ $D_H >= Q^*$

$
  P(D_H >= #q_d) = 1 - Phi((#q_d - #mean_h) / #sd_h) = 1 - Phi(#r4(z_q)) = #result[#r4(prob_d)]
$

- With unrounded $Q^*$: $1 - "cr" = #r4(1 - cr_d)$

_(e) Suppose a protection level of 85 is established. What is the average number of lost high-fare passengers? (2 points)_

#let q_e = 85
#let out_e = normal_outcomes(q_e, mean_h, sd_h)

$
  z &= (#q_e - #mean_h) / #sd_h = #r4(out_e.z), quad L(z) = #r4(out_e.L) \
  E["Lost"] &= sigma L(z) = #sd_h times #r4(out_e.L) = #result[#r(out_e.short)]
$

_(f) Continue to assume a protection level of 85 is established. What is the expected number of unoccupied seats? (2 points)_

- Only protected seats can fly empty

$
  E["Empty"] = E[(Q - D_H)^+] = (Q - mu) + E["Lost"] = #(q_e - mean_h) + #r(out_e.short) = #result[#r(out_e.left)]
$

_(g) Again, assume a protection level of 85 is established. What is the expected revenue from the flight? (2 points)_

#let low_sold = seats - q_e
#let revenue_g = fare_high * out_e.sold + fare_low * low_sold

$
  E["High sold"] &= mu - E["Lost"] = #mean_h - #r(out_e.short) = #r(out_e.sold) \
  "Low sold" &= #seats - #q_e = #low_sold \
  E["Revenue"] &= #fare_high times #r(out_e.sold) + #fare_low times #low_sold = #result[\$#r(revenue_g)]
$
]

// = Practice Problem on SC Coordination (No Points)

// The Orange Company has introduced a new music device called the J-Pod. The J-Pod is sold
// through Good Buy, a major electronics retailer. Good Buy has estimated that demand for the
// J-Pod will depend on the final retail price p according to the demand curve: Demand D
// 3,000,000 - 3,000p. The production cost for Orange is \$110 per J-Pod.

// #let D(p) = 3000000 - 3000 * p
// #let D(w, m) = 3000000 - 3000 * (w + m)
// #let c = 110



// (a) Suppose the two companies try to maximize their profits independently and Good
// buy is stronger in their relationship. What wholesale price should Orange charge for the J-Pod?
// At this wholesale price, what retail price should Good Buy set? What are the profits for Orange
// and Good Buy respectively?

// #let x = lq.linspace(0, 200, num: 200)
// #let y = x.map(D)

// #lq.diagram(
//   height: 20em,
//   width: 30em,
//   xlabel: [$p$],
//   ylabel: [$D$],
//   lq.plot(x, y, stroke: 1pt),
//   lq.vlines(c),
// )

// #let x = (0, 1)
// #let series-1 = (10, 15)
// #let series-2 = (5, 8)

// #let p = 10
// #let q = D(p)

// #lq.diagram(
//   width: 14cm, height: 9cm,
//   xlabel: [Quantity $q$], ylabel: [Price],
//   xlim: (0, 3000000), ylim: (0, 1000),
//   lq.plot((0, 3000000), (1000, 0), mark: none),  // demand: p = 1000 - q/3000
//   lq.rect(0, c, width: q, height: w - c, fill: orange.transparentize(50%)), // Orange's profit
//   lq.rect(0, w, width: q, height: p - w, fill: blue.transparentize(50%)),   // Good Buy's profit
// )

// $
//   p = w + m
// $

// $
//   D 
//   &= 3000000 - 3000p \
//   &= 3000000 - 3000(w + m) \
//   &= 3000 dot 1000 - 3000 dot (w + m) \
//   &= 3000 (1000 - w - m) \ 
// $

// (b) You are hired by Orange as a SCM expert for designing a mechanism to increase the
// profit of Orange using a quantity discount contract. How would you design an all-unit quantity
// discount contract? More specifically, what is the proper range of the wholesale price?

// (c) Now Orange wants you to consider a franchising contract this time. In this contract,
// Orange supplies the products without any margin, and Good Buy pays a fixed franchise fee to
// Orange. How would you design the franchising contract? More specifically, what is the proper
// range of the franchise fee?