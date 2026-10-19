#import "/lib/imports.typ": *
#import "/lib/formatting.typ": *
#show: formatting

== Newsvendor

How much of a single-period product should you order (or produce) when demand is uncertain, given that ordering too much or too little both cost you money.

=== Critical ratio

$
  F(Q^*) = c_u / (c_u + c_o) quad in (0,1)
$

Where:
- $c_u$: underage cost
- $c_o$: overage cost
- $F$: cumulative distribution function of demand

You pick $Q^*$ so that the probability demand is at or below $Q^*$ equals that ratio

- If *underage* is more expensive (stockouts are costly, leftovers are cheap), the ratio is close to $1$, so you stock a *high* quantile of demand — order a lot to avoid running out
- If *overage* is more expensive (stockouts are cheap, leftovers are costly), the ratio is close to $0$, so you stock a *low* quantile of demand — order conservatively to avoid leftovers

#example[
  #let mu_D = 100
  #let sigma_D = 25
  #let x = lq.linspace(mu_D - sigma_D * 2.5, mu_D + sigma_D * 2.5, num: 200)
  #let f(x) = tystats.norm.pdf(x, mean: mu_D, std_dev: sigma_D)
  #let y = x.map(f)

  #let c_u = 5
  #let c_o = 20
  #let crit = c_u / (c_u + c_o)
  #let crit = calc.round(crit, digits: 3)

  #let Q_star = tystats.norm.ppf(crit, mean: mu_D, std_dev: sigma_D)
  #let Q_star = calc.round(Q_star, digits: 3)

  #let x_crit = lq.linspace(mu_D - sigma_D * 2.5, Q_star)
  #let y_crit = x_crit.map(f)

  $
    c_u = #c_u \
    c_o = #c_o \
  $

  $
    "crit" 
    &= c_u / (c_u + c_o) \ 
    &= #c_u / (#c_u + #c_o) \ 
    &= #crit
  $

  $
    Q^* = F^(-1)("crit") = #Q_star
  $

  #lq.diagram(
    width: 25em,
    height: 20em,
    xlabel: [$D$],
    ylabel: [$p$],
    xaxis: (
    ticks: (
      (Q_star, box(inset: (top: 0em), text(size: 0.7em)[$Q^*$ \ #Q_star])),
      (mu_D, box(inset: (top: 0em), text(size: 0.7em)[$mu_D$ \ #mu_D])),
    ),
    subticks: none,
  ),
    yaxis: (
      ticks: none,
      subticks: none,
    ),
    lq.plot(x, y, mark: none, stroke: blue),
    lq.vlines(mu_D, stroke: (paint: blue, dash: "dashed", thickness: 1pt)),
    lq.vlines(Q_star, stroke: (paint: red, dash: "dashed", thickness: 1pt)),
    lq.fill-between(x_crit, y_crit, fill: red.transparentize(75%)),
    lq.place((Q_star + (sigma_D * 2.5)) / 2, f(Q_star) / 5, box(inset: (top: 0em), text(size: 0.7em)[crit =\ #crit]))
  )

  Marginal balance

  #let F(x) = tystats.norm.cdf(x, mean: mu_D, std_dev: sigma_D)

  #let g_o(Q) = c_o * F(Q)          // expected marginal cost of raising Q
  #let g_u(Q) = c_u * (1 - F(Q))    // expected marginal benefit of raising Q

  #let y_o = x.map(g_o)
  #let y_u = x.map(g_u)

  #let m_star = calc.round(c_u * c_o / (c_u + c_o), digits: 3)

  $
    c_o dot F(Q^*) = c_u dot (1 - F(Q^*)) = #m_star
  $

  #lq.diagram(
    width: 25em,
    height: 20em,
    xlabel: [$Q$],
    ylabel: [Expected marginal cost],
    xaxis: (
      ticks: (
        (Q_star, box(inset: (top: 0em), text(size: 0.7em)[$Q^*$ \ #Q_star])),
        (mu_D, box(inset: (top: 0em), text(size: 0.7em)[$mu_D$ \ #mu_D])),
      ),
      subticks: none,
    ),
    legend: (position: left + top, dx: 0em),
    lq.plot(x, y_o, mark: none, stroke: red, label: [$c_o dot F(Q)$ (overage)]),
    lq.plot(x, y_u, mark: none, stroke: blue, label: [$c_u dot (1 - F(Q))$ (underage)]),
    lq.vlines(Q_star, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
    lq.hlines(m_star, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
    lq.scatter((Q_star,), (m_star,), color: black),
  )

  Total expected cost

  #let phi(z) = tystats.norm.pdf(z, mean: 0, std_dev: 1)
  #let Phi(z) = tystats.norm.cdf(z, mean: 0, std_dev: 1)
  #let L(z) = phi(z) - z * (1 - Phi(z))          // unit normal loss function

  #let z(Q) = (Q - mu_D) / sigma_D
  #let E_short(Q) = sigma_D * L(z(Q))            // E[(D - Q)^+]
  #let E_over(Q)  = sigma_D * (L(z(Q)) + z(Q))   // E[(Q - D)^+]

  #let cost_u(Q) = c_u * E_short(Q)
  #let cost_o(Q) = c_o * E_over(Q)
  #let C(Q) = cost_u(Q) + cost_o(Q)

  #let y_cost_u = x.map(cost_u)
  #let y_cost_o = x.map(cost_o)
  #let y_cost   = x.map(C)

  #let C_star = calc.round(C(Q_star), digits: 3)

  $
    C(Q^*) = #C_star
  $

  #lq.diagram(
    width: 25em,
    height: 20em,
    xlabel: [$Q$],
    ylabel: [Expected cost],
    xaxis: (
      ticks: (
        (Q_star, box(inset: (top: 0em), text(size: 0.7em)[$Q^*$ \ #Q_star])),
        (mu_D, box(inset: (top: 0em), text(size: 0.7em)[$mu_D$ \ #mu_D])),
      ),
      subticks: none,
    ),
    legend: (position: left + top, dx: 0em),
    lq.plot(x, y_cost_u, mark: none, stroke: (paint: blue, dash: "dashed"), label: [$c_u dot E[(D-Q)^+]$]),
    lq.plot(x, y_cost_o, mark: none, stroke: (paint: red, dash: "dashed"), label: [$c_o dot E[(Q-D)^+]$]),
    lq.plot(x, y_cost, mark: none, stroke: (paint: black, thickness: 1.5pt), label: [$C(Q)$]),
    lq.vlines(Q_star, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
    lq.scatter((Q_star,), (C(Q_star),), color: black),
  )
]

$
  C(Q) = c_u dot E[(D - Q)^+] + c_o dot E[(Q - D)^+]
$

Differentiate with respect to Q and set it to zero. 

Raising $Q$ by one more unit costs you $c_o$ with probability $F(Q)$ (the extra unit goes unsold) and saves you $c_u$ with probability $1 - F(Q)$ (the extra unit prevents a stockout)

#line(length: 100%)

// ============================================================
// Global setup -- one problem, used everywhere
// ============================================================
#let mu_D = 100
#let sigma_D = 25
#let x_min = mu_D - 2.5 * sigma_D
#let x_max = mu_D + 2.5 * sigma_D

#let c_u = 5
#let c_o = 20
#let crit = c_u / (c_u + c_o)

#let f(D) = tystats.norm.pdf(D, mean: mu_D, std_dev: sigma_D)
#let F(D) = tystats.norm.cdf(D, mean: mu_D, std_dev: sigma_D)

#let Q_star = tystats.norm.ppf(crit, mean: mu_D, std_dev: sigma_D)
#let Q_star_r = calc.round(Q_star, digits: 3)
#let F_Qstar = calc.round(F(Q_star), digits: 3)
#let inv_F_Qstar = calc.round(1 - F_Qstar, digits: 3)

#let D_range = lq.linspace(x_min, x_max, num: 200)
#let y_density = D_range.map(f)

#let shortfall(D) = calc.max(D - Q_star, 0)
#let overage(D)   = calc.max(Q_star - D, 0)
#let y_short = D_range.map(shortfall)
#let y_over  = D_range.map(overage)

#let shortfall_integrand(D) = shortfall(D) * f(D)
#let overage_integrand(D)   = overage(D) * f(D)
#let y_short_int = D_range.map(shortfall_integrand)
#let y_over_int  = D_range.map(overage_integrand)

#align(center)[#text(weight: "bold", size: 1.1em)[Chapter 1 -- at the answer $Q^*$, how does demand play out? (x-axis: D)]]
#v(0.5em)

// ---- 1. the switch ----
#lq.diagram(
  width: 25em,
  height: 20em,
  xlabel: [$D$], ylabel: [Units],
  xaxis: (ticks: ((Q_star, box(inset:(top:0em),text(size:0.7em)[$Q^*$ \ #Q_star_r])),), subticks: none),
  legend: (position: top + right, dx: 0em),
  lq.plot(D_range, y_short, mark: none, stroke: blue + 2pt, label: [$(D-Q^*)^+$]),
  lq.plot(D_range, y_over,  mark: none, stroke: red + 2pt,  label: [$(Q^*-D)^+$]),
  lq.vlines(Q_star, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
)

#v(1em)

// ---- 2. the density split ----
#let x_F_Q = lq.linspace(x_min, Q_star, num: 200)
#let y_F_Q = x_F_Q.map(f)
#let x_inv_F_Q = lq.linspace(Q_star, x_max, num: 200)
#let y_inv_F_Q = x_inv_F_Q.map(f)
#let label_pos_F = (x_min + Q_star) / 2
#let label_pos_inv_F = (Q_star + x_max) / 2

#lq.diagram(
  width: 25em,
  height: 20em,
  xlabel: [$D$], ylabel: [$p$],
  xaxis: (
    ticks: (
      (Q_star, box(inset:(top:0em),text(size:0.7em)[$Q^*$ \ #Q_star_r])),
      (mu_D, box(inset:(top:0em),text(size:0.7em)[$mu_D$ \ #mu_D])),
    ), subticks: none,
  ),
  yaxis: (ticks: none, subticks: none),
  lq.plot(D_range, y_density, mark: none, stroke: black),
  lq.fill-between(x_F_Q, y_F_Q, fill: red.transparentize(75%)),
  lq.fill-between(x_inv_F_Q, y_inv_F_Q, fill: blue.transparentize(75%)),
  lq.place(label_pos_F, f(label_pos_F)/2, box(inset:(top:0em),text(size:0.7em)[$F(Q^*)$ =\ #F_Qstar])),
  lq.place(label_pos_inv_F, f(label_pos_inv_F)/2, box(inset:(top:0em),text(size:0.7em)[$1-F(Q^*)$ =\ #inv_F_Qstar])),
)

#let mini-density-icon(which: "left") = box(baseline: 2pt)[
  #lq.diagram(
    width: 14pt, height: 8pt,
    margin: 0%,
    xaxis: none,
    yaxis: none,
    lq.fill-between(
      if which == "left" { x_F_Q } else { x_inv_F_Q },
      if which == "left" { y_F_Q } else { y_inv_F_Q },
      fill: if which == "left" { red.transparentize(75%) } else { blue.transparentize(75%) },
      stroke: none,
    ),
  )
]

$ #mini-density-icon(which: "left") + #mini-density-icon(which: "right") = 1 $
$ F(Q^*) = #mini-density-icon(which: "left") = 0.2 $

#v(1em)

// ---- 3. the integrand ----
#lq.diagram(
  width: 25em,
  height: 20em,
  xlabel: [$D$], ylabel: [Expected-value density],
  xaxis: (ticks: ((Q_star, box(inset:(top:0em),text(size:0.7em)[$Q^*$ \ #Q_star_r])),), subticks: none),
  legend: (position: top + right, dx: 0em),
  lq.plot(D_range, y_short_int, mark: none, stroke: blue + 2pt, label: [$(D-Q^*)^+ dot f(D)$]),
  lq.plot(D_range, y_over_int,  mark: none, stroke: red + 2pt,  label: [$(Q^*-D)^+ dot f(D)$]),
  lq.fill-between(D_range, y_short_int, fill: blue.transparentize(75%)),
  lq.fill-between(D_range, y_over_int,  fill: red.transparentize(75%)),
  lq.vlines(Q_star, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
)

#pagebreak()

#align(center)[#text(weight: "bold", size: 1.1em)[Chapter 2 -- why $Q^*$ specifically? (x-axis: Q)]]
#v(0.5em)

#let Q_range = D_range
#let z(Q) = (Q - mu_D) / sigma_D
#let L(z) = tystats.norm.pdf(z, mean: 0, std_dev: 1) - z*(1 - tystats.norm.cdf(z, mean: 0, std_dev: 1))
#let E_short(Q) = sigma_D * L(z(Q))
#let E_over(Q)  = sigma_D * (L(z(Q)) + z(Q))
#let cost_u(Q) = c_u * E_short(Q)
#let cost_o(Q) = c_o * E_over(Q)
#let C(Q) = cost_u(Q) + cost_o(Q)

#let y_cost_u = Q_range.map(cost_u)
#let y_cost_o = Q_range.map(cost_o)
#let y_cost   = Q_range.map(C)

// ---- 4. total cost ----
#lq.diagram(
  width: 25em,
  height: 20em,
  xlabel: [$Q$], ylabel: [Expected cost],
  xaxis: (
    ticks: (
      (Q_star, box(inset:(top:0em),text(size:0.7em)[$Q^*$ \ #Q_star_r])),
      (mu_D, box(inset:(top:0em),text(size:0.7em)[$mu_D$ \ #mu_D])),
    ), subticks: none,
  ),
  legend: (position: top + right, dx: 0em),
  lq.plot(Q_range, y_cost_u, mark: none, stroke: (paint: blue, dash: "dashed"), label: [$c_u dot E[(D-Q)^+]$]),
  lq.plot(Q_range, y_cost_o, mark: none, stroke: (paint: red, dash: "dashed"),  label: [$c_o dot E[(Q-D)^+]$]),
  lq.plot(Q_range, y_cost,   mark: none, stroke: (paint: black, thickness: 1.5pt), label: [$C(Q)$]),
  lq.vlines(Q_star, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
  lq.scatter((Q_star,), (C(Q_star),), color: black),
)

#v(1em)

// ---- 5. marginal balance ----
#let g_o(Q) = c_o * F(Q)
#let g_u(Q) = c_u * (1 - F(Q))
#let y_go = Q_range.map(g_o)
#let y_gu = Q_range.map(g_u)
#let m_star = calc.round(c_u * c_o / (c_u + c_o), digits: 3)

#lq.diagram(
  width: 25em,
  height: 20em,
  xlabel: [$Q$], ylabel: [Expected marginal cost],
  xaxis: (
    ticks: (
      (Q_star, box(inset:(top:0em),text(size:0.7em)[$Q^*$ \ #Q_star_r])),
      (mu_D, box(inset:(top:0em),text(size:0.7em)[$mu_D$ \ #mu_D])),
    ), subticks: none,
  ),
  legend: (position: top + right, dx: 0em),
  lq.plot(Q_range, y_go, mark: none, stroke: red,  label: [$c_o dot F(Q)$]),
  lq.plot(Q_range, y_gu, mark: none, stroke: blue, label: [$c_u dot (1-F(Q))$]),
  lq.vlines(Q_star, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
  lq.hlines(m_star, stroke: (paint: gray, dash: "dashed", thickness: 1pt)),
  lq.scatter((Q_star,), (m_star,), color: black),
)

#line(length: 100%)

At the optimum these marginal effects balance:

$
  c_o dot F(Q*) = c_u dot (1 - F(Q^*))
$

Solving for $F(Q^*)$ gives $F(Q^*) = c_u / (c_u + c_o)$

Diferentiation:

$
  C(Q) = c_u dot E[(D - Q)^+] + c_o dot E[(Q - D)^+]
$

$
  (dif C(Q)) / (dif Q) = dif / (dif Q) [c_u dot E[(D - Q)^+] + c_o dot E[(Q - D)^+]]
$

1. $E[(D-Q)^+]$ as an integral

$
  (D - Q)^+ = cases(
    D - Q quad quad &"if" D > Q,
    0 quad quad &"otherwise"
  )
$

$
  integral_Q^infinity (d - Q) dot f(d) dif d
$

2. $E[(Q-D)^+]$ as an integral

$
  (Q - D)^+ = cases(
    Q - D quad quad &"if" D < Q,
    0 quad quad &"otherwise"
  )
$

$
  integral_(-infinity)^Q (Q - d) dot f(d) dif d
$

3. Substitute both back into $C(Q)$

$
  C(Q) = c_u dot integral_Q^infinity (d - Q) dot f(d) dif d + c_o dot integral_(-infinity)^Q (Q - d) dot f(d) dif d
$

4. Leibniz's rule

For an integral whose limits *and* integrand both depend on the
differentiation variable:

$
  (dif) / (dif Q) integral_(a(Q))^(b(Q)) g(d, Q) dif d
  = g(b(Q), Q) dot b'(Q) - g(a(Q), Q) dot a'(Q)
    + integral_(a(Q))^(b(Q)) (dif g) / (dif Q) dif d
$

5. Differentiate the first term, $c_u dot integral_Q^infinity (d - Q) dot f(d) dif d$

Here $a(Q) = Q$, $b(Q) = infinity$ (constant, so $b'(Q) = 0$), and
$g(d, Q) = (d - Q) dot f(d)$.

$
  g(Q, Q) = (Q - Q) dot f(Q) = 0 quad quad "(boundary term vanishes)"
$

$
  (dif g) / (dif Q) = (dif) / (dif Q) [(d - Q) dot f(d)] = -f(d)
$

$
  (dif) / (dif Q) E[(D-Q)^+]
  = 0 - 0 + integral_Q^infinity (-f(d)) dif d
  = -(1 - F(Q))
$

6. Diferentiate the second term, $c_o dot integral_(-infinity)^Q (Q - d) dot f(d) dif d$

Here $a(Q) = -infinity$ (constant, $a'(Q) = 0$), $b(Q) = Q$, and
$g(d, Q) = (Q - d) dot f(d)$.

$
  g(Q, Q) = (Q - Q) dot f(Q) = 0 quad quad "(boundary term vanishes)"
$

$
  (dif g) / (dif Q) = (dif) / (dif Q) [(Q - d) dot f(d)] = f(d)
$

$
  (dif) / (dif Q) E[(Q-D)^+]
  = 0 + 0 + integral_(-infinity)^Q f(d) dif d
  = F(Q)
$

7. Assemble $(dif C(Q)) / (dif Q)$

$
  (dif C(Q)) / (dif Q) = c_u dot [-(1 - F(Q))] + c_o dot F(Q)
  = -c_u (1 - F(Q)) + c_o dot F(Q)
$

8. Set the derivative to zero and solve

$
  -c_u (1 - F(Q)) + c_o dot F(Q) &= 0 \
  c_o dot F(Q) &= c_u dot (1 - F(Q)) \
  c_o dot F(Q) &= c_u - c_u dot F(Q) \
  c_o dot F(Q) + c_u dot F(Q) &= c_u \
  F(Q) dot (c_o + c_u) &= c_u \
  F(Q) &= c_u / (c_u + c_o)
$

Calling this solution $Q^*$:

$
  F(Q^*) = c_u / (c_u + c_o)
  quad quad "i.e." quad quad
  Q^* = F^(-1) (c_u / (c_u + c_o))
$

9. Confirm it's a minimum, not a maximum

$
  (dif C(Q)) / (dif Q) = (c_u + c_o) dot F(Q) - c_u
$

$
  (dif^2 C(Q)) / (dif Q^2) = (c_u + c_o) dot F'(Q) = (c_u + c_o) dot f(Q) >= 0
$

Since $c_u, c_o > 0$ and $f(Q) >= 0$ (a density), $C(Q)$ is convex
everywhere, so the critical point is a global minimum.