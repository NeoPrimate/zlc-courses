// =====================================================================
//  MZ 510 · Analytical Methods — LP / IP formulation cheatsheet
//  One concept = one compact form: Sets · Params · Vars · Model (+ variants)
//  red (mc) = what is NEW relative to the base model named after "←"
//  Every symbol is defined in its block (or in the base it points to).
//  Notation legend at the top; one letter = one concept everywhere.
// =====================================================================

#set document(title: "MZ 510 LP/IP cheatsheet")
#set page(paper: "a4", margin: (x: 1mm, y: 1mm), columns: 2)
#set columns(gutter: 0.35cm)
#set text(size: 6pt)
#set par(leading: 0.42em, spacing: 0.5em, justify: false)

// ---------- macros ----------------------------------------------------
#let mc(x) = text(fill: red, x)                               // new / unique part
#let nm(x) = text(size: 5.3pt, style: "italic", x)              // name of a term / constraint
#let accent = rgb("#2f6db3")

// Display equations: left-aligned, inline-size sums (limits on the side)
#show math.equation.where(block: true): it => {
  if it.has("label") { it } else {
    block(above: 2.5pt, below: 2.5pt, align(left,
      pad(left: 4pt, [#math.equation(block: true, math.inline(it.body))<_c>])))
  }
}

#let model(title, base: none, cues: none, body) = block(
  width: 100%, breakable: true, above: 4pt, below: 2pt,
  inset: (left: 4pt, rest: 1.5pt), stroke: (left: 1.1pt + accent), {
  text(size: 6.6pt, weight: "bold", fill: accent.darken(30%), title)
  if base != none { h(3pt); text(fill: luma(110))[← #base] }
  linebreak()
  if cues != none { text(size: 5.3pt, fill: luma(85), style: "italic")[cues: #cues]; linebreak() }
  body
})

// definition list: label column + bullet grid (cols = 1 or 2)
#let defs(title, cols: 2, ..xs) = block(above: 1.8pt, below: 1.8pt, breakable: true, {
  set text(top-edge: "bounds", bottom-edge: "bounds")
  grid(columns: (0.95cm, 1fr), column-gutter: 2pt,
    text(weight: "bold", title),
    grid(columns: (1fr,) * cols, column-gutter: 7pt, row-gutter: 1.9pt,
      ..xs.pos().map(x => { set par(leading: 0.35em); par(hanging-indent: 5pt)[• #x] })))})
#let SETS(cols: 2, ..xs) = defs("Sets", cols: cols, ..xs)
#let PARS(cols: 2, ..xs) = defs("Params", cols: cols, ..xs)
#let VARS(cols: 2, ..xs) = defs("Vars", cols: cols, ..xs)
#let VAR(t) = block(above: 3pt, below: 2.5pt, text(weight: "bold", fill: accent.darken(30%))[▸ #t])
#let sec(t) = block(above: 5pt, below: 2pt, width: 100%, fill: luma(232), inset: 2.5pt,
  text(size: 7.2pt, weight: "bold", t))

// ---------- tiny diagram helper (no packages) --------------------------
//  dg(w, h, nodes, arcs)   coordinates in cm, origin top-left
//  node: id: (x, y, label, kind)  kind: "c" circle · "t" text only · "d" dummy (red dashed) · "b" binary (red)
//  arc:  (a: id, b: id, l: label, k: "n" | "r" (red dashed) | "u" (undirected), via: ((x,y),..), lp: 0.5)
#let dg-r = 0.2
#let dg(w, h, nodes, arcs) = {
  let rad(id) = { let n = nodes.at(id); if n.at(3) == "t" { 0.17 } else { dg-r } }
  let clip(id, tx, ty) = {
    let n = nodes.at(id)
    let (dx, dy) = (tx - n.at(0), ty - n.at(1))
    let L = calc.sqrt(dx * dx + dy * dy)
    (n.at(0) + rad(id) * dx / L, n.at(1) + rad(id) * dy / L)
  }
  let P(p) = (p.at(0) * 1cm, p.at(1) * 1cm)
  align(center, box(width: w * 1cm, height: h * 1cm, {
    for e in arcs {
      let k = e.at("k", default: "n")
      let st = if k == "r" { (paint: red, thickness: 0.6pt, dash: "dashed") } else { 0.5pt + luma(60) }
      let via = e.at("via", default: ())
      let A = (nodes.at(e.a).at(0), nodes.at(e.a).at(1))
      let B = (nodes.at(e.b).at(0), nodes.at(e.b).at(1))
      let first = if via.len() > 0 { via.first() } else { B }
      let last = if via.len() > 0 { via.last() } else { A }
      let pts = (clip(e.a, ..first),) + via + (clip(e.b, ..last),)
      for i in range(pts.len() - 1) {
        place(top + left, line(start: P(pts.at(i)), end: P(pts.at(i + 1)), stroke: st))
      }
      if k != "u" {
        let (p, q) = (pts.at(-2), pts.at(-1))
        let (dx, dy) = (q.at(0) - p.at(0), q.at(1) - p.at(1))
        let L = calc.sqrt(dx * dx + dy * dy)
        let (ux, uy) = (dx / L, dy / L)
        let (s, wd) = (0.13, 0.055)
        let base = (q.at(0) - s * ux, q.at(1) - s * uy)
        place(top + left, polygon(fill: if k == "r" { red } else { luma(60) }, stroke: none,
          P(q), P((base.at(0) + wd * uy, base.at(1) - wd * ux)), P((base.at(0) - wd * uy, base.at(1) + wd * ux))))
      }
      let l = e.at("l", default: none)
      if l != none {
        let lp = e.at("lp", default: 0.5)
        let (p, q) = if via.len() > 0 { (via.first(), via.last()) } else { (pts.first(), pts.last()) }
        let m = if "at" in e { e.at } else if via.len() > 0 and via.len() < 2 { via.first() } else {
          (p.at(0) + lp * (q.at(0) - p.at(0)), p.at(1) + lp * (q.at(1) - p.at(1))) }
        place(top + left, dx: (m.at(0) - 1) * 1cm, dy: (m.at(1) - 0.2) * 1cm,
          box(width: 2cm, height: 0.4cm, align(center + horizon,
            box(fill: white, inset: 0.6pt, text(5.2pt, fill: if k == "r" { red } else { black }, l)))))
      }
    }
    for (id, n) in nodes {
      let (x, y, lab, kind) = n
      if kind == "t" {
        place(top + left, dx: (x - 1.2) * 1cm, dy: (y - 0.2) * 1cm,
          box(width: 2.4cm, height: 0.4cm, align(center + horizon, text(5.4pt, lab))))
      } else {
        let st = if kind == "d" { (paint: red, thickness: 0.6pt, dash: "dashed") }
          else if kind == "b" { 0.8pt + red } else { 0.5pt + black }
        place(top + left, dx: (x - dg-r) * 1cm, dy: (y - dg-r) * 1cm,
          circle(radius: dg-r * 1cm, stroke: st, fill: white, inset: 0pt,
            align(center + horizon, text(5.4pt, fill: if kind == "d" { red } else { black }, lab))))
      }
    }
  }))
}

// piecewise cost sketch: pts in unit square (0..1), drawn in a w×h cm box
#let pw-plot(w, h, pts, title) = box(width: w * 1cm, height: (h + 0.35) * 1cm, {
  let P(p) = ((0.15 + p.at(0) * (w - 0.3)) * 1cm, (h - 0.1 - p.at(1) * (h - 0.25)) * 1cm)
  place(top + left, line(start: P((0, 0)), end: P((1.05, 0)), stroke: 0.4pt))
  place(top + left, line(start: P((0, 0)), end: P((0, 1.05)), stroke: 0.4pt))
  for i in range(pts.len() - 1) {
    place(top + left, line(start: P(pts.at(i)), end: P(pts.at(i + 1)), stroke: 0.9pt + red))
  }
  for p in pts { let q = P(p); place(top + left, dx: q.at(0) - 1.2pt, dy: q.at(1) - 1.2pt, circle(radius: 1.2pt, fill: black)) }
  place(top + left, dx: P((1.0, 0)).at(0) - 2pt, dy: P((0, 0)).at(1), text(5pt)[$x$])
  place(top + left, dx: 0pt, dy: 0pt, text(5pt)[$f(x)$])
  place(top + left, dx: 0pt, dy: h * 1cm, box(width: w * 1cm, align(center, text(5.2pt, title))))
})


// ---------- diagrams (edit coordinates in cm) --------------------------
#let D-cover = dg(5.6, 1.9, (
    r1: (1.2, 0.25, $1$, "c"), r2: (1.2, 0.72, $2$, "c"), r3: (1.2, 1.19, $3$, "c"), r4: (1.2, 1.66, $4$, "c"),
    o1: (4.0, 0.45, $1$, "c"), o2: (4.0, 0.95, $2$, "c"), o3: (4.0, 1.45, $3$, "c"),
    lr: (0.35, 0.95, [need $t$ \ $>= r_t$], "t"), lo: (4.95, 0.95, [option $j$ \ cost $c_j$], "t"),
  ), (
    (a: "o1", b: "r1", k: "u"), (a: "o1", b: "r2", k: "u", l: $a_(t j)$, lp: 0.35), (a: "o2", b: "r2", k: "u"),
    (a: "o2", b: "r3", k: "u"), (a: "o3", b: "r3", k: "u"), (a: "o3", b: "r4", k: "u"), (a: "o1", b: "r4", k: "u"),
  ))

#let D-prod = dg(6.4, 1.7, (
    i0: (0.35, 0.85, $I_0$, "t"),
    t1: (1.4, 0.85, $1$, "c"), t2: (2.9, 0.85, $2$, "c"), t3: (4.4, 0.85, $t$, "c"),
    x1: (1.4, 0.12, $x^R_1, x^O_1$, "t"), x2: (2.9, 0.12, $x^R_2, x^O_2$, "t"), x3: (4.4, 0.12, $x^R_t, x^O_t$, "t"),
    d1: (1.4, 1.58, $d_1$, "t"), d2: (2.9, 1.58, $d_2$, "t"), d3: (4.4, 1.58, $d_t$, "t"),
    ie: (5.25, 0.85, [], "t"), iel: (5.95, 0.85, $I_(|T|) >= I^"end"$, "t"),
  ), (
    (a: "i0", b: "t1"), (a: "t1", b: "t2", l: $I_1$), (a: "t2", b: "t3", l: $I_2 dots$), (a: "t3", b: "ie"),
    (a: "x1", b: "t1"), (a: "x2", b: "t2"), (a: "x3", b: "t3"),
    (a: "t1", b: "d1"), (a: "t2", b: "d2"), (a: "t3", b: "d3"),
  ))

#let D-trans = dg(5.6, 1.75, (
    a: (1.3, 0.25, $1$, "c"), b: (1.3, 0.85, $2$, "c"), c: (1.3, 1.45, $m$, "c"),
    p: (4.2, 0.25, $1$, "c"), q: (4.2, 0.85, $2$, "c"), r: (4.2, 1.45, $n$, "c"),
    sa: (0.5, 0.25, $s_1$, "t"), sb: (0.5, 0.85, $s_2$, "t"), sc: (0.5, 1.45, $s_m$, "t"),
    dp: (5.0, 0.25, $d_1$, "t"), dq: (5.0, 0.85, $d_2$, "t"), dr: (5.0, 1.45, $d_n$, "t"),
  ), (
    (a: "a", b: "p", l: $c_(11)$), (a: "a", b: "q"), (a: "a", b: "r"), (a: "b", b: "p"), (a: "b", b: "q"),
    (a: "b", b: "r"), (a: "c", b: "p"), (a: "c", b: "q"), (a: "c", b: "r", l: $c_(m n)$),
  ))

#let D-dummy = dg(6.4, 1.75, (
    a: (1.3, 0.3, $1$, "c"), b: (1.3, 1.1, $2$, "c"),
    p: (4.2, 0.25, $1$, "c"), q: (4.2, 0.85, $2$, "c"), z: (4.2, 1.45, $j^*$, "d"),
    sa: (0.5, 0.3, $s_1$, "t"), sb: (0.5, 1.1, $s_2$, "t"),
    dp: (5.0, 0.25, $d_1$, "t"), dq: (5.0, 0.85, $d_2$, "t"), dz: (5.4, 1.45, text(fill: red)[dummy $S - D$], "t"),
  ), (
    (a: "a", b: "p"), (a: "a", b: "q"), (a: "b", b: "p"), (a: "b", b: "q"),
    (a: "a", b: "z", k: "r"), (a: "b", b: "z", k: "r", l: $c = 0$, lp: 0.55),
  ))

#let D-assign = dg(5.6, 1.75, (
    a: (1.3, 0.25, $1$, "c"), b: (1.3, 0.85, $2$, "c"), c: (1.3, 1.45, $n$, "c"),
    p: (4.2, 0.25, $1$, "c"), q: (4.2, 0.85, $2$, "c"), r: (4.2, 1.45, $n$, "c"),
    sa: (0.45, 0.85, [agent \ supply 1], "t"), dp: (5.05, 0.85, [task \ demand 1], "t"),
  ), (
    (a: "a", b: "p", l: $c_(11)$), (a: "a", b: "q"), (a: "a", b: "r"), (a: "b", b: "p"), (a: "b", b: "q"),
    (a: "b", b: "r"), (a: "c", b: "p"), (a: "c", b: "q"), (a: "c", b: "r"),
  ))

#let D-tship = dg(6.0, 1.7, (
    a: (1.1, 0.4, $1$, "c"), b: (1.1, 1.2, $2$, "c"),
    m: (3.0, 0.4, $3$, "c"), n: (3.0, 1.2, $4$, "c"),
    p: (4.9, 0.25, $5$, "c"), q: (4.9, 0.8, $6$, "c"), r: (4.9, 1.35, $7$, "c"),
    la: (0.35, 0.8, [$b_i > 0$ \ supply], "t"), lm: (3.0, 1.6, [$b_i = 0$ (through)], "t"), lp: (5.6, 0.8, [$b_i < 0$ \ demand], "t"),
  ), (
    (a: "a", b: "m", l: $c_(i j)$), (a: "a", b: "n"), (a: "b", b: "m"), (a: "b", b: "n"),
    (a: "a", b: "p", via: ((1.45, 0.05), (4.55, 0.05))),
    (a: "m", b: "p"), (a: "m", b: "q"), (a: "n", b: "q"), (a: "n", b: "r"), (a: "m", b: "n"),
  ))

#let D-sp = dg(5.8, 1.5, (
    n1: (0.7, 1.05, $1$, "c"), n2: (1.8, 1.05, $2$, "c"), n3: (2.9, 1.05, $3$, "c"), n4: (4.0, 1.05, $4$, "c"), n5: (5.1, 1.05, text(4.3pt)[$T#h(-0.5pt)+#h(-0.5pt)1$], "c"),
    ls: (0.7, 1.45, [$b_1 = 1$], "t"), lt: (5.1, 1.45, [$b_(T+1) = -1$], "t"),
  ), (
    (a: "n1", b: "n2"), (a: "n2", b: "n3"), (a: "n3", b: "n4"), (a: "n4", b: "n5"),
    (a: "n1", b: "n3", via: ((1.25, 0.45), (2.35, 0.45)), l: $c_(13)$),
    (a: "n2", b: "n4", via: ((2.35, 0.25), (3.45, 0.25))),
    (a: "n3", b: "n5", via: ((3.45, 0.55), (4.55, 0.55)), l: $c_(3, T+1)$),
  ))

#let D-maxflow = dg(4.8, 2.2, (
    s: (0.6, 0.85, $alpha$, "c"), a: (2.1, 0.3, $2$, "c"), b: (2.1, 1.4, $3$, "c"), t: (3.6, 0.85, $omega$, "c"),
  ), (
    (a: "s", b: "a", l: $k_(alpha 2)$), (a: "s", b: "b"), (a: "a", b: "b"), (a: "a", b: "t"), (a: "b", b: "t", l: $k_(3 omega)$),
    (a: "t", b: "s", k: "r", via: ((4.2, 0.85), (4.2, 1.95), (0.1, 1.95), (0.1, 0.85)), l: [return arc $v = x_(omega alpha)$], at: (2.15, 1.95)),
  ))

#let D-loc = dg(6.6, 2.15, (
    h1: (0.6, 0.45, $h$, "c"), h2: (0.6, 1.25, $h$, "c"),
    i1: (2.2, 0.45, $p$, "b"), i2: (2.2, 1.25, $p$, "b"),
    e1: (3.8, 0.45, $w$, "b"), e2: (3.8, 1.25, $w$, "b"),
    j1: (5.4, 0.25, $j$, "c"), j2: (5.4, 0.85, $j$, "c"), j3: (5.4, 1.45, $j$, "c"),
    lh: (0.6, 1.88, [supplier $s_h$], "t"), li: (2.2, 1.88, text(fill: red)[plant $y^P_p$, $f^P_p$], "t"),
    le: (3.8, 1.88, text(fill: red)[WH $y^W_w$, $f^W_w$], "t"), lj: (5.4, 1.88, [customer $d_j$], "t"),
  ), (
    (a: "h1", b: "i1"), (a: "h1", b: "i2"), (a: "h2", b: "i1"), (a: "h2", b: "i2"),
    (a: "i1", b: "e1"), (a: "i1", b: "e2"), (a: "i2", b: "e1"), (a: "i2", b: "e2"),
    (a: "e1", b: "j1"), (a: "e1", b: "j2"), (a: "e1", b: "j3"), (a: "e2", b: "j2"), (a: "e2", b: "j3"), (a: "e2", b: "j1"),
  ))

#let D-tsp = dg(6.2, 2.1, (
    a: (1.25, 0.25, $1$, "c"), b: (2.05, 0.8, $2$, "c"), c: (1.75, 1.6, $3$, "c"), d: (0.75, 1.6, $4$, "c"), e: (0.45, 0.8, $5$, "c"),
    p: (3.6, 0.35, $1$, "c"), q: (4.3, 1.4, $2$, "c"), r: (2.9, 1.4, $3$, "c"),
    u: (5.4, 0.35, $4$, "c"), v: (5.4, 1.4, $5$, "c"),
    l1: (1.25, 1.06, [tour ✓], "t"), l2: (4.2, 1.92, text(fill: red)[2 subtours ✗ (forbidden)], "t"),
  ), (
    (a: "a", b: "b"), (a: "b", b: "c"), (a: "c", b: "d"), (a: "d", b: "e"), (a: "e", b: "a"),
    (a: "p", b: "q", k: "r"), (a: "q", b: "r", k: "r"), (a: "r", b: "p", k: "r"),
    (a: "u", b: "v", k: "r", via: ((5.65, 0.875),)), (a: "v", b: "u", k: "r", via: ((5.15, 0.875),)),
  ))

#let D-piece = align(center, {
  pw-plot(3.0, 1.5, ((0, 0), (0.4, 0.15), (0.7, 0.42), (1, 1)), [*convex* (diseconomies): LP segments])
  h(0.4cm)
  pw-plot(3.0, 1.5, ((0, 0), (0.33, 0.55), (0.66, 0.85), (1, 1)), [*concave* (economies): $lambda_ell$ + binaries])
})


#align(center, text(9pt, weight: "bold")[MZ 510 — LP & IP formulation cheatsheet])
#v(-3pt)
#align(center, text(5.4pt, fill: luma(90))[
  #mc[red] = new w.r.t. the base model (← base) · names in _italics_ · ▸ = variant (lists only what it adds) · _cues_ = wording that signals the model · §6 = recognition guide])

#block(fill: luma(246), inset: 3pt, radius: 2pt, width: 100%, {
  set text(size: 5.5pt)
  text(weight: "bold")[Notation legend] + [ — one letter = one concept; superscripts separate same-letter items ($f^P$ plant vs $f^W$ WH fixed cost)]
  v(1pt)
  grid(columns: (1fr, 1fr, 1fr), column-gutter: 6pt, row-gutter: 2pt,
    [*Vars:* $x$ quantity / flow], [$y in {0,1}$ decision (open, select)], [$z in {0,1}$ helper (served by, AND)],
    [$n in ZZ_(>=0)$ number of (people, trucks)], [$I$ inventory], [$u$ order (MTZ) / utilisation],
    [$v$ max-flow value], [$t$ start time], [$e >= 0$ excess / shortage / lateness],
    [*Params:* $k$ capacity], [$d$ demand], [$s$ supply],
    [$c$ unit (variable) cost, incl. transport], [$f$ fixed cost], [$h$ holding cost],
    [$p$ price], [$pi$ unit profit / margin / score], [$a$ use per unit · $b$ availability],
    [$r$ requirement], [$q$ fraction / share], [$tau$ time (transit, processing)],
    [$delta$ due date · $rho$ release time], [$w$ weight · $ell$ length], [$M$ big M (smallest valid bound)],
  )
  v(1pt)
  [*Sets:* uppercase set, lowercase index ($P\/p$ plants, $W\/w$ warehouses, $J\/j$ customers / products, $T\/t$ periods); never a set named $I$.]
})

// =====================================================================
#sec[1 · General LP]
// =====================================================================

#model([1.1 Product mix / resource allocation], cues: [limited resources (hours, material, budget, fuel), "how much of each to make", maximise profit / revenue, "at most X can be sold"])[
  #SETS([$J$ ($j$): products / activities], [$R$ ($r$): resources])
  #PARS([$pi_j$: unit profit (price − var. cost, or price × output per unit)], [$a_(r j)$: use of $r$ per unit of $j$],
    [$b_r$: availability of $r$], [$d_j$: max sales of $j$])
  #VARS([$x_j >= 0$: units of $j$ (or time activity $j$ runs)])
  $
    max quad &sum_j pi_j x_j && quad &&#nm[profit / revenue] \
    "s.t." quad &sum_j a_(r j) x_j <= b_r quad &&forall r quad &&#nm[resource capacity] \
    &x_j <= d_j &&forall j &&#nm[demand (market) cap]
  $
  #VAR[Several plants, same % of capacity used]
  #SETS([#mc[$P$ ($p$): plants]], [$J$ ($j$): products])
  #PARS([#mc[$k_p$: capacity of plant $p$ (units)]], [#mc[$k^A_p$: second plant limit, e.g. storage area]],
    [#mc[$a_j$: area per unit of $j$]], [$pi_j$: unit profit; $d_j$: max sales])
  #VARS([#mc[$x_(p j) >= 0$: units of $j$ at plant $p$]], [#mc[$u in [0, 1]$: common utilisation share] (alt.)])
  $
    max quad &sum_p sum_j pi_j x_(p j) && quad &&#nm[profit] \
    "s.t." quad &sum_j x_(p j) <= k_p quad &&forall p quad &&#nm[plant capacity] \
    &sum_j a_j x_(p j) <= k^A_p &&forall p &&#nm[storage space] \
    &sum_p x_(p j) <= d_j &&forall j &&#nm[demand] \
    &mc(1/k_p sum_j x_(p j) = 1/k_1 sum_j x_(1 j)) &&forall p != 1 &&#nm[same % of capacity] \
    &"or" mc(sum_j x_(p j) = k_p u) &&forall p &&#nm[same share $u$ (helper)]
  $
  #VAR[Assemble a product from parts: max complete units]
  #SETS([#mc[$J$ ($j$): parts]], [#mc[$L$ ($ell$): departments / machines]])
  #PARS([#mc[$r_j$: parts $j$ needed per product]], [$a_(j ell)$: hours per part $j$ in $ell$], [$b_ell$: hours available in $ell$])
  #VARS([#mc[$x_(j ell) >= 0$: parts $j$ made in $ell$]], [#mc[$x^F >= 0$: finished products]])
  $
    max quad &mc(x^F) && quad &&#nm[complete units] \
    "s.t." quad &mc(sum_ell x_(j ell) >= r_j x^F) quad &&forall j quad &&#nm[parts requirement] \
    &sum_j a_(j ell) x_(j ell) <= b_ell &&forall ell &&#nm[department hours]
  $
]

#model([1.2 Allocation with average / ratio / share limits], cues: [split a budget, "average risk / quality ≤", "at least X % in", "no more than the amount in", money left over earns a fixed rate])[
  #SETS([$J$ ($j$): investment / allocation categories])
  #PARS([$pi_j$: return rate of $j$], [$pi^0$: return of the leftover option], [$sigma_j$: risk (or quality) score of $j$], [$overline(sigma)$: max average score],
    [$b$: budget], [$q$: min share of category $k$])
  #VARS([$x_j >= 0$: amount put in $j$], [$x^0 >= 0$: amount left in the leftover option])
  $
    max quad &sum_j pi_j x_j + pi^0 x^0 && quad &&#nm[total return] \
    "s.t." quad &sum_j x_j + x^0 = b &&&&#nm[budget] \
    &sum_j (sigma_j - overline(sigma)) x_j <= 0 quad &&&&#nm[average score (linearised ratio)] \
    &x_k >= q sum_j x_j &&&&#nm[min share of k] \
    &x_2 + x_3 <= x_1 &&&&#nm[relative limit (e.g. A + B ≤ C)]
  $
  *Ratio trick* ($a_j$: score of $j$, $c$: limit): $(sum_j a_j x_j)\/(sum_j x_j) <= c$ ⟺ $sum_j (a_j - c) x_j <= 0$ (valid because the denominator is $>= 0$). Check whether the average is over *all* money or only the invested part. Average return per \$ = objective / $b$.
]

#model([1.3 Blending], cues: [mix inputs into products, "contains at least / at most X % of", inputs bought at a price, products sold at a price])[
  #SETS([$R$ ($r$): raw inputs], [$J$ ($j$): products / blends])
  #PARS([$c_r$: purchase cost of $r$], [$s_r$: max supply of $r$], [$p_j$: sale price of $j$], [$d_j$: max demand of $j$],
    [$q_(r j)$: min fraction of $r$ in $j$], [$q^max_(r j)$: max fraction of $r$ in $j$])
  #VARS([$x_(r j) >= 0$: amount of $r$ used in $j$])
  $
    max quad &sum_j p_j sum_r x_(r j) - sum_r c_r sum_j x_(r j) && quad &&#nm[sales revenue − purchase cost] \
    "s.t." quad &sum_j x_(r j) <= s_r &&forall r &&#nm[supply] \
    &sum_r x_(r j) <= d_j &&forall j &&#nm[demand] \
    &x_(r j) >= q_(r j) sum_(r') x_(r' j) quad &&forall r, j quad &&#nm[min fraction (quality)] \
    &x_(r j) <= q^max_(r j) sum_(r') x_(r' j) &&forall r, j &&#nm[max fraction]
  $
  2 inputs: $x_(1 j) >= q (x_(1 j) + x_(2 j))$ ⟺ $(1-q) x_(1 j) - q x_(2 j) >= 0$. Helper totals $x^T_j = sum_r x_(r j)$ keep rows short (§4). Extra input bought at a stepped price ⇒ 3.6.
]

#model([1.4 Covering: diet · shift scheduling · set covering], cues: ["at least / minimum required", "each … must be covered / served", "within X minutes / adjacent", minimise cost or number used])[
  #D-cover
  #SETS([$T$ ($t$): needs (nutrients / periods / areas)], [$J$ ($j$): options (foods / shifts / sites)])
  #PARS([$c_j$: unit cost of option $j$], [$a_(t j)$: amount of need $t$ covered by one unit of $j$], [$r_t$: requirement of need $t$])
  #VARS([$x_j$: amount of option $j$ — only the *domain* changes between variants])
  $
    min quad &sum_j c_j x_j && quad &&#nm[cost (or count, $c_j = 1$)] \
    "s.t." quad &sum_j a_(t j) x_j >= r_t quad &&forall t quad &&#nm[requirement covered]
  $
  #VAR[Diet / nutrition (continuous)] $x_j >= 0$: amount of food $j$; $a_(t j)$: nutrient $t$ per unit of $j$; $r_t$: minimum intake.
  #VAR[Staffing with overlapping shifts]
  #VARS([#mc[$n_j in ZZ_(>=0)$: people *starting* shift $j$] (replaces $x_j$)])
  $a_(t j) = 1$ if shift $j$ works in period $t$. Shift = 2 consecutive periods ⇒ #mc[$n_(t-1) + n_t >= r_t$]; round-the-clock ⇒ cyclic ($n_0 = n_(|T|)$).
  #VAR[Workers do a combination of shifts, priced per combination]
  #SETS([#mc[$Q$: allowed pairs $(j, j')$, $j < j'$]])
  #PARS([#mc[$c_(j j')$: daily pay of pair, + bonus if not consecutive ($j' > j + 1$)]])
  #VARS([#mc[$n_(j j') in ZZ_(>=0)$: workers doing shifts $j$ and $j'$]])
  $
    min quad &sum_((j, j') in Q) c_(j j') n_(j j') && quad &&#nm[labour cost] \
    "s.t." quad &mc(sum_((j, j') in Q: t in {j, j'}) n_(j j') >= r_t) quad &&forall t quad &&#nm[workers on duty in period t]
  $
  #VAR[Locate sites so every area is reached within a time / distance]
  #SETS([$J$ ($j$): candidate sites], [$T$ ($t$): areas to protect / serve])
  #PARS([#mc[$tau_(j t)$: travel time $j -> t$ (may be asymmetric)]], [#mc[$overline(tau)$: max allowed time]],
    [#mc[$"pop"_j$: eligibility data (e.g. population); $overline("pop")$: threshold]], [$c_j$: site cost (1 if equal)])
  #VARS([#mc[$y_j in {0,1}$: open site $j$]], [#mc[$z_(j t) in {0,1}$: site $j$ serves $t$]])
  $
    min quad &sum_j c_j y_j && quad &&#nm[number / cost of sites] \
    "s.t." quad &sum_j z_(j t) >= 1 quad &&forall t quad &&#nm[every area served] \
    &z_(j t) <= y_j &&forall j, t &&#nm[only from an open site] \
    &mc(tau_(j t) z_(j t) <= overline(tau)) &&forall j, t &&#nm[within time (forces $z = 0$ if $tau > overline(tau)$)] \
    &mc(("pop"_j - overline("pop")) y_j >= 0) &&forall j &&#nm[eligibility rule (forces $y_j = 0$)]
  $
  Short form (no $z$): $sum_j a_(t j) y_j >= 1$ with $a_(t j) = 1$ if $j$ reaches $t$ (in time, same / adjacent area). \
  *Partitioning* ("exactly once", e.g. pick routes so each location is on exactly one): $sum_j a_(t j) y_j = 1$, often + $sum_j y_j = b$ (number of vehicles). *Max covering* (limited sites): $max sum_t w_t z_t$, $z_t <= sum_j a_(t j) y_j$, $sum_j y_j <= b$ ($w_t$: weight of area $t$).
]

#model([1.5 Cutting stock (patterns)], cues: [cut standard lengths / rolls into pieces, "number of standard pieces used", "waste / trim loss"])[
  #SETS([$J$ ($j$): piece types], [$P$ ($p$): cutting patterns — list all $p$ with $sum_j ell_j a_(j p) <= k$])
  #PARS([$k$: standard length], [$ell_j$: length of piece $j$], [$d_j$: pieces of $j$ ordered], [$a_(j p)$: pieces $j$ in pattern $p$],
    [$c_p = k - sum_j ell_j a_(j p)$: trim waste of $p$])
  #VARS([$n_p in ZZ_(>=0)$: standard pieces cut with pattern $p$], [(b) #mc[$e_j >= 0$: surplus pieces of $j$]])
  $
    "(a)" min quad &sum_p n_p && quad &&#nm[standard pieces used] \
    "s.t." quad &sum_p a_(j p) n_p >= d_j quad &&forall j quad &&#nm[demand] \
    "(b)" min quad &mc(sum_p c_p n_p + sum_j ell_j e_j) &&&&#nm[trim waste + overproduction] \
    "s.t." quad &mc(sum_p a_(j p) n_p - e_j = d_j) &&forall j &&#nm[demand with surplus]
  $
  (b) ≡ (a): total waste $= k sum_p n_p - sum_j ell_j d_j$ is a constant plus the objective of (a), so both give the same optimum.
]

#model([1.6 Multi-period production & inventory], cues: [several periods / months / quarters, "carried over", "ending inventory of at least", regular vs overtime, holding cost])[
  #D-prod
  #SETS([$T = {1, ..., |T|}$ ($t$): periods])
  #PARS([$d_t$: demand in $t$], [$k^R_t, k^O_t$: regular / overtime capacity], [$c^R_t, c^O_t$: unit costs], [$h_t$: holding cost per unit],
    [$I_0$: initial stock], [$I^"end"$: required final stock], [(b) #mc[$c^B$: backorder cost per unit]])
  #VARS([$x^R_t, x^O_t >= 0$: regular / overtime production], [$I_t >= 0$: end inventory], [(b) #mc[$I^+_t, I^-_t >= 0$: stock / backlog]])
  $
    min quad &sum_t (c^R_t x^R_t + c^O_t x^O_t) + sum_t h_t I_t && quad &&#nm[production + holding cost] \
    "s.t." quad &I_(t-1) + x^R_t + x^O_t - d_t = I_t quad &&forall t quad &&#nm[inventory balance] \
    &x^R_t <= k^R_t, quad x^O_t <= k^O_t &&forall t &&#nm[regular / overtime capacity] \
    &I_(|T|) >= I^"end" &&&&#nm[ending stock]
  $
  Costs rising by a fraction $q$ per period: $c_t = c_1 (1 + q)^(t-1)$; holding as a fraction $q'$ of production cost: $h_t = q' c_t$. "Demand met on time" ⇒ no backlog.
  #VAR[(b) Backlog allowed] replace $I_t$ by #mc[$I^+_t - I^-_t$] in the balance; cost #mc[$h_t I^+_t + c^B I^-_t$] #nm[(holding + shortage)];; usually #mc[$I^-_(|T|) = 0$].
  #VAR[Several products sharing one capacity]
  #SETS([#mc[$J$ ($j$): products]])
  #PARS([$d_(j t)$, $c_(j t)$, $h_(j t)$, $I_(j 0)$, $I^"end"_j$: per product], [#mc[$k_t$: shared capacity]])
  #VARS([$x_(j t) >= 0$: production], [$I_(j t) >= 0$: inventory])
  $
    min quad &sum_(j, t) (c_(j t) x_(j t) + h_(j t) I_(j t)) && quad &&#nm[production + holding cost] \
    "s.t." quad &I_(j, t-1) + x_(j t) - d_(j t) = I_(j t) quad &&forall j, t quad &&#nm[balance per product] \
    &mc(sum_j x_(j t) <= k_t) &&forall t &&#nm[shared capacity] \
    &I_(j |T|) >= I^"end"_j &&forall j &&#nm[ending stock]
  $
  #VAR[Repeating cycle, consumption depends on the level (refuelling)]
  #SETS([$T$ ($t$): stops / legs in a loop, #mc[$t = 0 equiv |T|$]])
  #PARS([$c_t$: price at stop $t$], [$ell_t$: length of leg $t$], [$k$: tank capacity], [$r$: min reserve on arrival], [$g$: extra burn per unit carried (from the burn formula)])
  #VARS([$x_t >= 0$: amount bought at $t$], [#mc[$I^S_t, I^E_t >= 0$: level at start / end of leg $t$]])
  $
    min quad &sum_t c_t x_t && quad &&#nm[purchase cost] \
    "s.t." quad &mc(I^S_t = I^E_(t-1) + x_t) quad &&forall t quad &&#nm[balance (loop closes, no start/end)] \
    &mc(I^S_t - I^E_t = ell_t (1 + g (I^S_t + I^E_t) \/ 2)) &&forall t &&#nm[burn ∝ average level: still linear] \
    &I^S_t <= k, quad I^E_t >= r &&forall t &&#nm[tank · reserve]
  $
  #VAR[Production planning written as a transportation problem]
  #SETS([#mc[sources $(t, m)$: period $t$, mode $m in {R, O}$]], [destinations: periods $t' in T$])
  #PARS([$k^m_t$: capacity], [$c^m_t$: unit cost], [$h$: holding rate per period (% of cost)],
    [#mc[$d'_t$: net demand, $d'_1 = d_1 - I_0$, $d'_(|T|) = d_(|T|) + I^"end"$]])
  #VARS([#mc[$x_(t m t') >= 0$: made in $t$ with $m$ for period $t'$]])
  $
    min quad &sum_(t, m, t') mc(c^m_t (1 + h (t' - t))) x_(t m t') && quad &&#nm[production + holding cost] \
    "s.t." quad &sum_(t') x_(t m t') <= k^m_t quad &&forall t\, m quad &&#nm[capacity (supply)] \
    &sum_(t, m) x_(t m t') >= d'_(t') &&forall t' &&#nm[net demand] \
    &mc(x_(t m t') = 0) &&forall t' < t &&#nm[no backorders (or $c = M$)]
  $
  Use when holding cost is a % of *the cost in the period the unit was made*. Capacity > net demand ⇒ #mc[dummy period, $c = 0$] (2.0).
]

#model([1.7 Allocate time across price levels (markdowns)], base: [1.1, time as the resource], cues: [season of X weeks, demand depends on the price level, leftover sold at a salvage / outlet price])[
  #SETS([$L$ ($ell$): price levels])
  #PARS([$p_ell$: price at level $ell$], [$d_ell$: demand per week at $p_ell$], [$tau$: season length (weeks)],
    [$s$: stock available], [$p^0$: salvage / outlet price])
  #VARS([$x_ell >= 0$: weeks sold at level $ell$ (integer if whole weeks)])
  $
    max quad &sum_ell p_ell d_ell x_ell + p^0 (s - sum_ell d_ell x_ell) && quad &&#nm[in-season + salvage revenue] \
    "s.t." quad &sum_ell x_ell <= tau &&&&#nm[season length] \
    &sum_ell d_ell x_ell <= s &&&&#nm[stock available]
  $
  The order of the weeks doesn't change revenue ⇒ schedule the levels from high to low (markdowns).
]

// =====================================================================
#sec[2 · Network models (totally unimodular ⇒ LP gives integer solutions)]
// =====================================================================

#model([2.0 Balanced vs unbalanced · dummy nodes (applies to all of §2)], cues: [total supply ≠ total demand, "meet demand as much as possible", shortage penalty, a route that does not exist])[
  #D-dummy
  #PARS([$s_p$: supply of source $p$], [$d_j$: demand of destination $j$], [$S = sum_p s_p$: total supply], [$D = sum_j d_j$: total demand],
    [$c^e_j$: shortage penalty per unit at $j$], [$M$: big cost (forbidden arc)])
  #VARS([$x_(p j) >= 0$: flow (2.1)], [#mc[$x_(p, "dum")$, $x_("dum", j) >= 0$: flow to / from a dummy]], [#mc[$e_j >= 0$: shortage at $j$] (penalty form)])
  #table(columns: (auto, 1fr), inset: 2pt, stroke: 0.4pt + luma(180),
    [*Balanced* $S = D$], [All rows *equalities*: $sum_j x_(p j) = s_p$ #nm[(supply)], $sum_p x_(p j) = d_j$ #nm[(demand)].],
    [*Supply > demand* $S > D$], [(a) supply rows $<=$, demand rows $=$ (or $>=$); *or* (b) #mc[*dummy destination*] with #mc[$d_"dum" = S - D$], cost #mc[$c_(p, "dum") = 0$] (or idle cost) ⇒ all rows $=$. $x_(p, "dum")$ = *unused capacity*.],
    [*Demand > supply* $S < D$], [Plain model *infeasible*. (a) #mc[*dummy source*] with #mc[$s_"dum" = D - S$], cost #mc[$c_("dum", j) = c^e_j$] (0 if none) ⇒ $x_("dum", j)$ = *unmet demand*; *or* (b) demand rows $<=$, supply rows $=$ ("meet demand as much as possible"); *or* (c) #mc[shortage variable]: $sum_p x_(p j) + e_j = d_j$, cost $c^e_j e_j$ ("penalty per unit short").],
    [*Forbidden pairs*], [$c_(p j) = M$ or $x_(p j) = 0$ — incl. a destination that must be served in full (no dummy flow / no $e_j$ for it).],
    [*Assignment* (2.2)], [More agents than tasks ⇒ #mc[dummy tasks] ($c = 0$) or agent rows $<= 1$. More tasks ⇒ #mc[dummy agents] (task not done) or task rows $<= 1$.],
    [*Transshipment* (2.3)], [$b_i$ = net supply of node $i$. $sum_i b_i > 0$ ⇒ #mc[dummy sink] with $b_"dum" = -sum_i b_i$, arcs from every source, $c = 0$; or supply nodes $<= b_i$. $sum_i b_i < 0$ ⇒ dummy source with penalty.],
    [*Production as transp.* (1.6)], [Capacity > net demand ⇒ #mc[dummy period], $c = 0$. Back-in-time arcs: $c = M$.],
  )
  *Exam tip:* state the case ($S$ vs $D$), then use inequalities *or* a dummy, not both. Report dummy flows as idle capacity / unmet demand.
]

#model([2.1 Transportation], cues: [sources with capacities ship to destinations with demands, cost per unit per route, "from … to …" cost table])[
  #D-trans
  #SETS([$P$ ($p$): sources (plants, refineries)], [$J$ ($j$): destinations])
  #PARS([$s_p$: supply of $p$], [$d_j$: demand of $j$], [$c_(p j)$: unit transport cost $p -> j$ (cost per mile × miles if given as distance)])
  #VARS([$x_(p j) >= 0$: units shipped $p -> j$])
  $
    min quad &sum_p sum_j c_(p j) x_(p j) && quad &&#nm[transport cost] \
    "s.t." quad &sum_j x_(p j) <= s_p quad &&forall p quad &&#nm[supply] \
    &sum_p x_(p j) >= d_j &&forall j &&#nm[demand]
  $
  Balanced / unbalanced, dummy nodes, shortages, forbidden arcs: see 2.0.
  #VAR[Transportation with budget, minimum service %, deadlines]
  #SETS([$P$: modes / sources], [$J$: customer classes], [#mc[$F subset P times J$: pairs too slow for the deadline]])
  #PARS([$s_p$: capacity of mode $p$ (vehicles × load; $oo$ if unlimited)], [$d_j$: demand of class $j$], [#mc[$q_j$: min fraction of $d_j$ served]], [#mc[$b$: budget]])
  $
    &mc(sum_p x_(p j) >= q_j d_j) quad &&forall j quad &&#nm[service level] \
    &mc(sum_(p, j) c_(p j) x_(p j) <= b) &&&&#nm[budget] \
    &mc(x_(p j) = 0) &&forall (p, j) in F &&#nm[deadline (lead time too long)]
  $
  "Is it feasible?" ⇒ check whether the minimum cost exceeds $b$ (or drop the budget row and compare).
]

#model([2.2 Assignment], base: [2.1 with $s_p = d_j = 1$], cues: ["each … to exactly one", one-to-one matching, cost / time table agent × task])[
  #D-assign
  #SETS([$P$ ($p$): agents (people, machines)], [$J$ ($j$): tasks])
  #PARS([$c_(p j)$: cost / time if $p$ does $j$])
  #VARS([$y_(p j) in {0,1}$: $p$ does $j$ (LP relaxation already integral)])
  $
    min quad &sum_p sum_j c_(p j) y_(p j) && quad &&#nm[total cost / time] \
    "s.t." quad &sum_j y_(p j) <= 1 quad &&forall p quad &&#nm[each agent at most once ($= 1$ if balanced)] \
    &sum_p y_(p j) = 1 &&forall j &&#nm[each task covered]
  $
  More agents than tasks: agent rows $<= 1$, task rows $= 1$ (see 2.0).
]

#model([2.3 Transshipment / min-cost flow], base: [2.1 + intermediate nodes], cues: ["through / via" warehouses, pumps, hubs; flows in and out of intermediate points; network drawing])[
  #D-tship
  #SETS([$N$ ($i, j$): nodes], [$A subset N times N$: arcs $(i, j)$])
  #PARS([$b_i$: net supply ($> 0$ source, $< 0$ sink, $0$ transshipment)], [$c_(i j)$: unit cost on arc], [$k_(i j)$: arc capacity])
  #VARS([$x_(i j) >= 0$: flow on arc $(i, j)$])
  $
    min quad &sum_((i,j) in A) c_(i j) x_(i j) && quad &&#nm[flow cost] \
    "s.t." quad &mc(sum_(j: (i,j) in A) x_(i j) - sum_(j: (j,i) in A) x_(j i) = b_i) quad &&forall i in N quad &&#nm[flow conservation (out − in)] \
    &x_(i j) <= k_(i j) &&forall (i, j) in A &&#nm[arc capacity]
  $
  If $sum_i b_i != 0$: see 2.0. Any arc is allowed (source → sink directly, or between intermediate nodes). "Where to add capacity / how much to invest" ⇒ shadow price of the supply row (§5).
  #VAR[Path form, layered networks only — use arc form *or* path form]
  #SETS([$P$ ($p$): suppliers], [$W$ ($w$): transshipment nodes], [$J$ ($j$): customers])
  #PARS([$s_p$: supply], [$d_j$: demand], [$c^P_(p w)$, $c^W_(w j)$: unit costs per leg], [$k_w$: node capacity; $c_w$: handling cost per unit])
  #VARS([#mc[$x_(p w j) >= 0$: units $p -> w -> j$]])
  $
    min quad &sum_(p, w, j) (c^P_(p w) + c^W_(w j) + c_w) x_(p w j) && quad &&#nm[path cost] \
    "s.t." quad &sum_(w, j) x_(p w j) <= s_p quad &&forall p quad &&#nm[supply] \
    &sum_(p, w) x_(p w j) >= d_j &&forall j &&#nm[demand] \
    &sum_(p, j) x_(p w j) <= k_w &&forall w &&#nm[node capacity (if any)]
  $
  No conservation rows: they are built into the path.
]

#model([2.4 Shortest path · equipment replacement], base: [2.3], cues: [cheapest / shortest route from A to B, "keep or replace each year", trade-in value depends on age])[
  #D-sp
  #SETS([$N$ ($i, j$): nodes], [$A$: arcs $(i, j)$])
  #PARS([#mc[$b_"start" = 1$, $b_"end" = -1$, $b_i = 0$ otherwise]], [$c_(i j)$: arc length / cost])
  #VARS([$y_(i j) in {0,1}$: arc used (relax to $>= 0$, TU)])
  $
    min quad &sum_((i,j) in A) c_(i j) y_(i j) && quad &&#nm[path length] \
    "s.t." quad &sum_(j: (i,j) in A) y_(i j) - sum_(j: (j,i) in A) y_(j i) = b_i quad &&forall i in N quad &&#nm[flow conservation (+1 / 0 / −1)]
  $
  #VAR[Equipment replacement] nodes = years $1..T+1$; arc $(i, j)$, $i < j$: buy at start of $i$, trade in at start of $j$; $c_(i j)$ = price + maintenance for ages $0..j-i-1$ − trade-in at age $j-i$. Shortest path from 1 to $T+1$.
]

#model([2.5 Maximum flow], base: [2.3], cues: ["maximum amount that can be sent / per hour", capacities on links, no costs])[
  #D-maxflow
  #SETS([$N$ ($i, j$): nodes, source $alpha$, sink $omega$], [$A$: arcs])
  #PARS([$k_(i j)$: arc capacity])
  #VARS([$x_(i j) >= 0$: flow on arc], [#mc[$v >= 0$: total flow $alpha -> omega$]])
  $
    max quad &mc(v) && quad &&#nm[throughput] \
    "s.t." quad &sum_j x_(alpha j) - sum_j x_(j alpha) mc(- v) = 0 &&&&#nm[source] \
    &sum_j x_(i j) - sum_j x_(j i) = 0 quad &&forall i != alpha, omega quad &&#nm[conservation] \
    &sum_j x_(omega j) - sum_j x_(j omega) mc(+ v) = 0 &&&&#nm[sink] \
    &x_(i j) <= k_(i j) &&forall (i, j) &&#nm[arc capacity]
  $
  Same as: artificial arc $omega -> alpha$, $max x_(omega alpha)$, conservation everywhere; or $max sum_j x_(alpha j)$. *Two-way links* (lines, roads): arcs $(i, j)$ and $(j, i)$, each $<= k_(i j)$, or shared #mc[$x_(i j) + x_(j i) <= k_(i j)$].
]

// =====================================================================
#sec[3 · Integer programs]
// =====================================================================

#model([3.1 Fixed charge (setup / start-up / lease / entry cost)], base: [1.1], cues: ["if any … are produced, a fixed cost of", lease a machine, start-up cost, entry fee per market, "only if"])[
  #SETS([$J$ ($j$): products / orders], [$R$ ($r$): resources])
  #PARS([$pi_j$: unit margin (price − variable cost)], [$a_(r j)$: use of $r$ per unit of $j$], [$b_r$: availability of $r$], [$d_j$: max sales / order size],
    [#mc[$f_j$: fixed cost if $j$ is produced]], [#mc[$M$: big M = max possible $x_j$]])
  #VARS([$x_j in ZZ_(>=0)$ (or $>= 0$): units of $j$], [#mc[$y_j in {0,1}$: 1 if $j$ is produced]])
  $
    max quad &sum_j pi_j x_j mc(- sum_j f_j y_j) && quad &&#nm[margin] #mc[#nm[− fixed cost]] \
    "s.t." quad &sum_j a_(r j) x_j <= b_r quad &&forall r quad &&#nm[resources] \
    &mc(x_j <= M y_j) &&forall j &&#nm[produce only if set up]
  $
  $M$ = smallest valid bound, may differ per $j$: $min_r b_r \/ a_(r j)$ (most you could make), or $d_j$ (max sales / order). Capacity given as "% of capacity per unit": row $sum_j a_j x_j <= 100 %$.
  #VAR[Fixed charge + workforce sizing (full- / part-time, union rules)]
  #PARS([#mc[$a^L_j$: labour hours per unit]], [$a^N_j$, $b^N$: material per unit / available],
    [#mc[$c^"FT", c^"PT"$: wage per hour]], [#mc[$tau^"FT", tau^"PT"$: hours per week per worker]], [#mc[$n^min$: min full-time; $q$: full-time per part-time]])
  #VARS([$x_j$, $y_j$ as above], [#mc[$n^"FT", n^"PT" in ZZ_(>=0)$: full- / part-time staff]])
  $
    max quad &sum_j pi_j x_j - sum_j f_j y_j mc(- (c^"FT" tau^"FT" n^"FT" + c^"PT" tau^"PT" n^"PT")) && quad &&#nm[profit − fixed −] #mc[#nm[labour cost]] \
    "s.t." quad &sum_j a^N_j x_j <= b^N &&&&#nm[material] \
    &mc(sum_j a^L_j x_j <= tau^"FT" n^"FT" + tau^"PT" n^"PT") quad &&&&#nm[labour hours] \
    &mc(n^"FT" >= n^min\, quad n^"FT" >= q n^"PT") &&&&#nm[union minimum · ratio] \
    &x_j <= d_j y_j &&forall j &&#nm[demand + setup ($M = d_j$)]
  $
  Keep units consistent (all hours or all minutes).
  #VAR[Fixed fee to enter a market + assortment rules]
  #SETS([$J$ ($j$): product lines / departments], [#mc[$G$ ($g$): candidate markets]])
  #PARS([$pi_j$: margin], [#mc[$f_g$: entry cost of market $g$]], [$k$: total capacity], [#mc[$M = k$]], [$b$: max markets entered], [$q$: max share])
  #VARS([#mc[$x_(j g) >= 0$: items of $j$ sent to $g$]], [#mc[$y_g in {0,1}$: enter market $g$]])
  $
    max quad &sum_(j, g) pi_j x_(j g) - sum_g f_g y_g && quad &&#nm[margin − entry cost] \
    "s.t." quad &sum_(j, g) x_(j g) <= k &&&&#nm[capacity] \
    &mc(sum_j x_(j g) <= M y_g) quad &&forall g quad &&#nm[ship only if entered] \
    &sum_g y_g <= b &&&&#nm[at most b markets] \
    &x_(1 g) = x_(2 g) = x_(3 g) &&&&#nm["equal numbers" in g] \
    &x_(j g) - q sum_(j') x_(j' g) <= 0 &&&&#nm["at most q % of the total" (cross-multiplied)]
  $
]

#model([3.2 Knapsack / capital budgeting], base: [1.1, $x in {0,1}$ or $ZZ$], cues: ["select which projects", yes/no investments, cash needed per year, NPV, indivisible items])[
  #SETS([$J$ ($j$): projects / items], [$T$ ($t$): years / resources])
  #PARS([$pi_j$: value (NPV, profit) of $j$], [$a_(t j)$: cash used by $j$ in year $t$], [$b_t$: cash available in $t$])
  #VARS([$y_j in {0,1}$: select $j$ (or $n_j in ZZ_(>=0)$: how many to buy)])
  $
    max quad &sum_j pi_j y_j && quad &&#nm[total NPV / profit] \
    "s.t." quad &sum_j a_(t j) y_j <= b_t quad &&forall t quad &&#nm[budget per year]
  $
  Conditions between projects ("at most two", "only if", "not both") ⇒ §4. *LP relaxation* (drop integrality) gives a bound: ≥ IP optimum for max, ≤ for min. *Rounding the LP solution can be infeasible or far from optimal* ⇒ solve the IP (branch & bound).
]

#model([3.3 Assign items to several roles with an "in both" count], base: [3.2], cues: ["exactly k must take part in both", choose members per event / role, score table])[
  #SETS([$G$ ($g$): candidates], [$E$ ($e$): roles / events (here 2: $A$, $B$)])
  #PARS([$pi_(g e)$: score of $g$ in $e$], [$r$: members per role], [#mc[$r^2$: members in both roles]])
  #VARS([$y_(g e) in {0,1}$: $g$ takes role $e$], [#mc[$z_g in {0,1}$: $g$ takes both]])
  $
    max quad &sum_g sum_e pi_(g e) y_(g e) && quad &&#nm[total score] \
    "s.t." quad &sum_g y_(g e) = r quad &&forall e quad &&#nm[members per role] \
    &mc(sum_g z_g = r^2 &&&&#nm[exactly r² in both]) \
    &mc(z_g <= y_(g e) &&forall g\, e &&#nm[both ⇒ each]) \
    &mc(z_g >= y_(g A) + y_(g B) - 1 quad &&forall g &&#nm[each ⇒ both])
  $
  Without the last row $z_g$ could be 0 for someone in both roles ⇒ more than $r^2$ "doubles".
]

#model([3.4 Facility location (plant & warehouse)], base: [2.3], cues: [open / close facilities, fixed annual operating cost, several levels (plants → warehouses → customers), "is it economical to keep all"])[
  #D-loc
  #SETS([$H$ ($h$): suppliers], [$P$ ($p$): plants], [$W$ ($w$): warehouses], [$J$ ($j$): customers])
  #PARS([$s_h$: supplier capacity], [$k^P_p$, $k^W_w$: plant / WH capacity], [$d_j$: demand], [$c^H_(h p), c^P_(p w), c^W_(w j)$: unit costs per leg],
    [#mc[$f^P_p$, $f^W_w$: fixed (annual) costs]])
  #VARS([$x^H_(h p), x^P_(p w), x^W_(w j) >= 0$: flows per leg], [#mc[$y^P_p$, $y^W_w in {0,1}$: open plant / WH]])
  $
    min quad &mc(sum_p f^P_p y^P_p + sum_w f^W_w y^W_w) + && quad &&#mc[#nm[fixed cost]] \
    &sum_(h,p) c^H_(h p) x^H_(h p) + sum_(p,w) c^P_(p w) x^P_(p w) + sum_(w,j) c^W_(w j) x^W_(w j) quad &&&&#nm[transport (+ production)] \
    "s.t." quad &sum_p x^H_(h p) <= s_h &&forall h &&#nm[supplier capacity] \
    &sum_w x^W_(w j) >= d_j &&forall j &&#nm[demand] \
    &sum_h x^H_(h p) - sum_w x^P_(p w) >= 0 &&forall p &&#nm[plant balance (out ≤ in)] \
    &sum_p x^P_(p w) - sum_j x^W_(w j) >= 0 &&forall w &&#nm[WH balance] \
    &sum_w x^P_(p w) <= k^P_p mc(y^P_p) &&forall p &&#nm[plant capacity] #mc[#nm[(if open)]] \
    &sum_j x^W_(w j) <= k^W_w mc(y^W_w) &&forall w &&#nm[WH capacity] #mc[#nm[(if open)]]
  $
  #VAR[Max number of open facilities + single sourcing of a customer] no suppliers; $c^P_(p w)$ may include production.
  #PARS([#mc[$M = sum_j d_j$: big M when a WH has no capacity]], [#mc[$hat(j)$: customer that must be single-sourced]], [$b$: max plants open])
  #VARS([#mc[$z_w in {0,1}$: WH $w$ serves customer $hat(j)$]])
  $
    &sum_w x^P_(p w) <= k^P_p y^P_p quad &&forall p quad &&#nm[plant capacity (if open)] \
    &sum_p x^P_(p w) = sum_j x^W_(w j) &&forall w &&#nm[WH conservation] \
    &mc(sum_j x^W_(w j) <= M y^W_w) &&forall w &&#nm[ship only if WH open] \
    &sum_w x^W_(w j) >= d_j &&forall j &&#nm[demand] \
    &mc(sum_p y^P_p <= b) &&&&#nm[at most b plants] \
    &mc(x^W_(w hat(j)) <= M z_w) quad (M = d_(hat(j))) &&forall w &&#nm[customer ĵ only from chosen WH] \
    &mc(sum_w z_w = 1) &&&&#nm[single sourcing (customer ĵ)]
  $
  Objective as above without the supplier term. Costs can be scaled (e.g. in k€) as long as all terms use the same unit.
  #VAR[Keep or close existing facilities (one level)] facilities → markets only:
  #PARS([$f^W_w$, $k^W_w$, $c^W_(w j)$, $d_j$ as above])
  #VARS([$x^W_(w j) >= 0$; $y^W_w in {0,1}$])
  $min sum_w f^W_w y^W_w + sum_(w,j) c^W_(w j) x^W_(w j)$ s.t. #nm[demand] $sum_w x^W_(w j) >= d_j$, #nm[capacity] $sum_j x^W_(w j) <= k^W_w y^W_w$ (no capacity given ⇒ $M$). "Is it worth keeping all?" ⇒ solve with all $y^W_w = 1$ (plain transportation) vs $y^W_w$ free and compare. At least $ceil(sum_j d_j \/ k^W)$ must stay open (equal capacities $k^W$). Opening rules ("if A then B", "at most 2", "A or B") ⇒ §4.
  #VAR[Path variables + single sourcing + exactly b open]
  #PARS([$k^P_p$: plant capacity], [$d_j$: demand], [#mc[$c_(p w j)$: unit cost $p -> w -> j$]], [#mc[$c^W_w$: handling cost per unit at $w$]],
    [$f^W_w$: fixed cost of $w$], [#mc[$b$: number of facilities to open]])
  #VARS([#mc[$x_(p w j) >= 0$: units $p -> w -> j$]], [$y^W_w in {0,1}$: open $w$], [#mc[$z_(w j) in {0,1}$: $w$ serves $j$]])
  $
    min quad &sum_(p,w,j) (c_(p w j) + c^W_w) x_(p w j) + sum_w f^W_w y^W_w && quad &&#nm[transport + handling + fixed] \
    "s.t." quad &sum_(w, j) x_(p w j) <= k^P_p quad &&forall p quad &&#nm[plant capacity] \
    &mc(sum_p x_(p w j) = d_j z_(w j)) &&forall w, j &&#nm[demand from the chosen facility] \
    &mc(sum_w z_(w j) = 1) &&forall j &&#nm[single sourcing] \
    &z_(w j) <= y^W_w &&forall w, j &&#nm[only an open facility] \
    &sum_w y^W_w = b &&&&#nm[exactly b open]
  $
]

#model([3.5 Capacity bought in steps from a table + entry fees], base: [1.1], cues: [table "investment → resulting capacity", "in multiples of", fee per product per market, "send at least / equally split"])[
  #SETS([$J$ ($j$): products], [$G$ ($g$): markets], [#mc[$L$ ($ell$): rows of the investment table]])
  #PARS([$pi_j$: unit margin], [#mc[$k_ell$: total capacity at level $ell$]], [#mc[$f_ell$: investment cost of level $ell$]],
    [#mc[$f^E$: entry fee per product per market; $b^E$: fee budget]], [$r$: min total volume], [$d_(j g)$: demand cap],
    [$r_g$: min per product in market $g$], [$M$: big M (largest capacity)])
  #VARS([$x_(j g) >= 0$: units of $j$ to $g$], [#mc[$y_ell in {0,1}$: choose level $ell$]], [#mc[$y_(j g) in {0,1}$: $j$ introduced in $g$]])
  #text(weight: "bold", fill: accent.darken(30%))[Alternative A — one binary per level (exact for any capacity table)]
  $
    max quad &sum_(j, g) pi_j x_(j g) mc(- sum_ell f_ell y_ell - f^E sum_(j,g) y_(j g)) && quad &&#nm[margin] #mc[#nm[− investment − entry fees]] \
    "s.t." quad &mc(sum_ell y_ell = 1 &&&&#nm[choose one level]) \
    &sum_(j,g) x_(j g) <= mc(sum_ell k_ell y_ell) &&&&#nm[capacity] \
    &mc(x_(j g) <= M y_(j g) &&forall j\, g &&#nm[sell only if entered]) \
    &mc(f^E sum_(j,g) y_(j g) <= b^E &&&&#nm[fee budget]) \
    &sum_(j,g) x_(j g) >= r &&&&#nm[min volume] \
    &x_(j g) <= d_(j g); quad x_(j 1) = x_(j 2) "(equal split)" &&&&#nm[demand; split rules] \
    &x_(j g) >= r_g &&forall j &&#nm[min per product in g]
  $
  #text(weight: "bold", fill: accent.darken(30%))[Alternative B — one integer per block; replaces $y_ell$, use A *or* B]
  #SETS([#mc[$S$ ($s$): blocks where each step adds the same capacity]])
  #PARS([$k_0$: base capacity], [#mc[$k_s$: capacity gained per step in block $s$]], [#mc[$b_s$: max steps in block $s$]], [#mc[$f^S$: cost per step]])
  #VARS([#mc[$n_s in ZZ_(>=0)$: steps taken in block $s$]], [$x_(j g)$, $y_(j g)$ as in A])
  $
    max quad &sum_(j,g) pi_j x_(j g) mc(- f^S sum_s n_s) - f^E sum_(j,g) y_(j g) && quad &&#nm[margin] #mc[#nm[− investment]] #nm[− fees] \
    "s.t." quad &sum_(j,g) x_(j g) <= mc(k_0 + sum_s k_s n_s) &&&&#nm[capacity] \
    &mc(n_s <= b_s) quad &&forall s quad &&#nm[block width]
  $
  Plus all rows of A except the $y_ell$ ones. *B is valid only if* each extra step buys *less* capacity than the previous block ($k_1 > k_2 > dots$): the solver then fills the blocks in order by itself (same idea as convex segments, 3.6). If the gain per step rises or jumps ⇒ use A.
  #VAR[Share a fixed number of units among items, value table per count]
  #VARS([#mc[$y_(ell j) in {0,1}$: item $j$ gets $ell$ units]])
  $max sum_(ell, j) pi_(ell j) y_(ell j)$ ($pi_(ell j)$: value table) s.t. #nm[one count per item] $sum_ell y_(ell j) = 1$; #nm[total units] $sum_(ell, j) ell y_(ell j) = b$. Needed when the value per extra unit is not constant.
]

#model([3.6 Piecewise-linear cost: diseconomies (convex) vs economies (concave)], cues: ["first X units cost …, next Y units cost …", free quota then pay, volume discount, penalty above a threshold])[
  #D-piece
  *Which case?* Unit cost *rises* with volume (convex, diseconomies) ⇒ simple segments, *no binaries*. Unit cost *falls* (concave, volume discount) ⇒ $lambda$ / $y$ formulation *with binaries*.
  #VAR[Convex cost (unit cost rises ⇒ no binaries)]
  #SETS([$S$ ($s$): cost segments])
  #PARS([$k_s$: width of segment $s$], [$c_s$: unit cost in $s$, $c_1 < c_2 < dots$])
  #VARS([#mc[$x_s >= 0$: amount in segment $s$]], [$x = sum_s x_s$: total])
  $
    "cost" = &mc(sum_s c_s x_s) quad "with" quad x = sum_s x_s\, quad 0 <= x_s <= k_s &&&&#nm[the LP fills cheap segments first]
  $
  #VAR[Free quota, then pay per extra unit (water allowance, emission credits)]
  #SETS([$J$ ($j$): activities], [$R$ ($r$): other resources])
  #PARS([$pi_j$: revenue per unit], [$a_(r j)$, $b_r$: other resource use / availability], [#mc[$a^Q_j$: use of the quota resource per unit]],
    [#mc[$k_1$: free quota; $k_2$: max extra (∞ if unlimited)]], [#mc[$c_2$: price per extra unit]])
  #VARS([$x_j >= 0$: level of activity $j$], [#mc[$x_1, x_2 >= 0$: free / paid use]])
  $
    max quad &sum_j pi_j x_j mc(- c_2 x_2) && quad &&#nm[revenue − extra cost] \
    "s.t." quad &sum_j a_(r j) x_j <= b_r quad &&forall r quad &&#nm[other resources] \
    &mc(sum_j a^Q_j x_j = x_1 + x_2) &&&&#nm[quota resource balance] \
    &mc(x_1 <= k_1\, quad x_2 <= k_2) &&&&#nm[free part · extra part]
  $
  Same as: $x^T$ = total use of the quota resource, $x^T >= sum_j a^Q_j x_j$, $x^T >= k_1$, cost $c_2 (x^T - k_1)$. Area / mix shares on the activities ⇒ helper variable + ratio rows (§4).
  #VAR[Convex cost inside a sourcing network]
  #SETS([$P$ ($p$): plants], [$J$ ($j$): demand points], [$S$ ($s$): segments])
  #PARS([$d_j$: demand], [$c_(p j)$: transport cost], [#mc[$k_(p s)$: width of segment $s$ at plant $p$]], [#mc[$c_(p s)$: unit cost in segment $s$ (rising)]])
  #VARS([$x_(p j) >= 0$: shipped $p -> j$], [#mc[$x_(p s) >= 0$: output of $p$ in segment $s$]])
  $
    min quad &mc(sum_(p, s) c_(p s) x_(p s)) + sum_(p, j) c_(p j) x_(p j) && quad &&#nm[production (piecewise) + transport] \
    "s.t." quad &mc(sum_j x_(p j) = sum_s x_(p s)) quad &&forall p quad &&#nm[output = shipments] \
    &mc(x_(p s) <= k_(p s)) &&forall p\, s &&#nm[segment width] \
    &sum_p x_(p j) >= d_j &&forall j &&#nm[demand]
  $
  #VAR[Concave cost / volume discount (binaries needed)]
  #SETS([$L = {1..m}$ ($ell$): breakpoints; segments $ell = 1..m-1$])
  #PARS([$beta_ell$: breakpoint (quantity)], [$f(beta_ell)$: total cost at $beta_ell$])
  #VARS([#mc[$lambda_ell >= 0$: weight on breakpoint $ell$] (slides: $z$)], [#mc[$y_ell in {0,1}$: $x$ lies in segment $ell$]])
  $
    f(x) &= mc(sum_ell lambda_ell f(beta_ell)) && quad &&#nm[cost replaced in objective] \
    x &= mc(sum_ell lambda_ell beta_ell) &&&&#nm[x as a combination of breakpoints] \
    &mc(sum_ell lambda_ell = 1\, quad sum_ell y_ell = 1) &&&&#nm[convex comb.; one segment] \
    &mc(lambda_1 <= y_1\, quad lambda_ell <= y_(ell-1) + y_ell\, quad lambda_m <= y_(m-1)) &&&&#nm[only the 2 ends of the chosen segment]
  $
  *Buying extra input at a stepped price inside a blend (1.3: $x_(r j)$ input $r$ in product $j$, $s_r$ supply):* $x$ = amount of input $r$ bought, supply row #mc[$sum_j x_(r j) <= s_r + x$], objective $- sum_ell lambda_ell f(beta_ell)$, + the four rows above.
]

#model([3.7 Single-machine scheduling with due dates], cues: [jobs on one machine, processing times, due dates, "total delay / lateness", "cannot overlap"])[
  #SETS([$J$ ($i, j$): jobs])
  #PARS([$tau_j$: processing time], [$delta_j$: due date], [$M$: big M ($>= sum_j tau_j$)])
  #VARS([$t_j >= 0$: start time of $j$], [$e_j >= 0$: delay (lateness) of $j$], [#mc[$y_(i j) in {0,1}$: 1 if $i$ before $j$]])
  $
    min quad &sum_j e_j && quad &&#nm[total delay (tardiness)] \
    "s.t." quad &mc(t_i + tau_i <= t_j + M(1 - y_(i j))) quad &&forall i < j quad &&#nm[either $i$ before $j$ …] \
    &mc(t_j + tau_j <= t_i + M y_(i j)) &&forall i < j &&#nm[… or $j$ before $i$ (no overlap)] \
    &e_j >= t_j + tau_j - delta_j &&forall j &&#nm[delay = max(0, completion − due)]
  $
  #VAR[Positional alternative]
  #VARS([#mc[$z_(j ell) in {0,1}$: job $j$ in position $ell$]], [$C_ell >= 0$: completion of position $ell$; $e_ell >= 0$ its delay])
  $
    &sum_ell z_(j ell) = 1 quad forall j\, quad sum_j z_(j ell) = 1 quad forall ell quad &&&&#nm[assignment (2.2)] \
    &C_ell = sum_(ell' <= ell) sum_j tau_j z_(j ell')\, quad e_ell >= C_ell - sum_j delta_j z_(j ell) &&&&#nm[completion · delay]
  $
]

#model([3.8 Travelling salesman (TSP)], base: [2.2], cues: [visit every city once and return, shortest tour, "sequence of visits"])[
  #D-tsp
  #SETS([$N$ ($i, j$): nodes, node 1 = origin], [$Q subset N$: any subset (subtour)])
  #PARS([$c_(i j)$: distance $i -> j$])
  #VARS([$y_(i j) in {0,1}$: $j$ visited right after $i$], [#mc[$u_i$: visit order (MTZ)]])
  $
    min quad &sum_i sum_j c_(i j) y_(i j) && quad &&#nm[tour length] \
    "s.t." quad &sum_i y_(i j) = 1 quad &&forall j quad &&#nm[enter once] \
    &sum_j y_(i j) = 1 &&forall i &&#nm[leave once] \
    &mc(sum_(i,j in Q) y_(i j) <= |Q| - 1 &&forall Q subset N\, |Q| > 1 &&#nm[subtour elimination (DFJ)])
  $
  #VAR[MTZ instead of DFJ] #mc[$u_1 = 1$, $2 <= u_i <= |N|$ $(i >= 2)$, $u_i - u_j + 1 <= (|N| - 1)(1 - y_(i j)) space forall i, j != 1$].
]

#model([3.9 Consolidate orders on pre-defined routes vs. common carrier], base: [2.2 + 3.1], cues: [orders with release dates and deadlines, list of possible truck routes with fixed cost and capacity, LTL / common carrier alternative])[
  #SETS([$J$ ($j$): orders], [$R$ ($r$): pre-defined routes], [$T = {1..|T|}$ ($t$): days], [#mc[$N_r$: stops of route $r$]])
  #PARS([$"dest"_j$: destination of $j$], [$w_j$: weight], [#mc[$rho_j$: release day]], [#mc[$delta_j$: deadline]], [#mc[$f_r$: trip fixed cost]],
    [$k_r$: truck capacity], [$tau_(j r)$: days to deliver $j$ on $r$], [$c_j$: carrier cost of $j$; $tau'_j$ carrier days])
  #VARS([#mc[$z_(j r t) in {0,1}$: $j$ on route $r$ starting day $t$]], [#mc[$y_(r t) in {0,1}$: route $r$ run on day $t$]],
    [#mc[$z^L_j in {0,1}$: $j$ by carrier (only if $rho_j + tau'_j <= delta_j$)]])
  $
    min quad &mc(sum_r sum_t f_r y_(r t)) + mc(sum_j c_j z^L_j) && quad &&#nm[trip fixed cost + carrier cost] \
    "s.t." quad &sum_(j: rho_j <= t <= delta_j - tau_(j r)\, "dest"_j in N_r) w_j z_(j r t) <= k_r mc(y_(r t)) quad &&forall r\, t quad &&#nm[capacity, only if route runs] \
    &sum_(r: "dest"_j in N_r) sum_(t: rho_j <= t <= delta_j - tau_(j r)) z_(j r t) + mc(z^L_j) = 1 &&forall j &&#nm[each order shipped once]
  $
  Index ranges = *time windows* (released, on time) and *route covers the destination*. No carrier ⇒ drop $z^L_j$; days without trips (weekends) ⇒ $y_(r t) = 0$.
]

#model([3.10 Batch shipping + per-unit option + transit inventory + one local source], base: [2.3 + 3.1], cues: [containers (full loads) vs per-unit shipping, lead time in days and an interest rate, rebalance between locations, choose one site for local production])[
  #SETS([$J$ ($j, j'$): locations (demand + candidate sites)], [$L$ ($ell$): batch / container types])
  #PARS([$d_j$: demand], [$p^0$: purchase price], [$c_(j ell)$: freight per batch], [$k_ell$: units per batch],
    [$c^L_j$: per-unit freight], [$tau_j$: transit time (days)], [$h$: annual interest (holding) rate], [$c^R_(j j')$: transfer cost per unit],
    [$c^D_j$: local unit cost], [$k^D$: fixed local volume])
  #VARS([#mc[$n_(j ell) in ZZ_(>=0)$: batches]], [$x^L_j in ZZ_(>=0)$: per-unit shipments], [$x^R_(j j') >= 0$: transfers],
    [#mc[$y_j in {0,1}$: local site]], [#mc[$x^D_j >= 0$: local production]])
  $
    min quad &sum_(j,ell) (p^0 k_ell + c_(j ell)) n_(j ell) + sum_j (p^0 + c^L_j) x^L_j && quad &&#nm[purchase + freight (batch, per unit)] \
    &mc(+ sum_j h/365 p^0 tau_j (sum_ell k_ell n_(j ell) + x^L_j)) &&&&#mc[#nm[pipeline (in-transit) holding]] \
    &+ sum_(j,j') c^R_(j j') x^R_(j j') + mc(sum_j c^D_j x^D_j) &&&&#nm[transfers] #mc[#nm[\+ production]] \
    "s.t." quad &sum_ell k_ell n_(j ell) + x^L_j + mc(x^D_j) + sum_(j') x^R_(j' j) >= d_j + sum_(j') x^R_(j j') quad &&forall j quad &&#nm[flow balance (in ≥ demand + out)] \
    &mc(sum_j y_j = 1\, quad x^D_j = k^D y_j) &&forall j &&#nm[one site, produces exactly k#super[D]]
  $
  *Pipeline cost* = unit value × (annual rate / 365) × days in transit × units. Batches are integer; the per-unit option covers the rest. Build it up: direct shipping only → add transfers → add the local site.
]

// =====================================================================
#sec[4 · Logical-constraint toolbox]
// =====================================================================
#[
#set text(size: 5.5pt)
#text(size: 5.4pt)[Symbols: $y_A, y_B, y_C, y_j in {0,1}$ decisions (projects, sites, items $A, B, C$); $z in {0,1}$ helper; $x >= 0$ quantity; $g_1(x), g_2(x)$ linear expressions; $b_1, b_2$ right-hand sides; $M$ big M = smallest valid upper bound.]
#table(columns: (auto, 1fr), inset: 2pt, stroke: 0.4pt + luma(180),
  table.cell(colspan: 2, fill: luma(244))[*Between binary decisions*],
  [*At least one*], [$sum_j y_j >= 1$ · two items ("either A or B"): $y_A + y_B >= 1$],
  [*At most one* (mutually exclusive)], [$sum_j y_j <= 1$ · two items: $y_A + y_B <= 1$],
  [*Exactly / at most / at least $b$ of $n$*], [$sum_j y_j = b$ · $<= b$ · $>= b$ #nm[(max plants, choose one level)]],
  [*If $A$ then $B$* ($A$ only if $B$)], [$y_A <= y_B$],
  [*If $A$ then not $B$*], [$y_A + y_B <= 1$],
  [*Both or neither*], [$y_A = y_B$],
  [*If $A$ or $B$ then $C$*], [$y_A <= y_C$, $y_B <= y_C$ (or $y_A + y_B <= 2 y_C$)],
  [*If $A$ and $B$ then $C$*], [$y_C >= y_A + y_B - 1$],
  [*$z$ = AND ("both")*], [$z <= y_A$, $z <= y_B$, $z >= y_A + y_B - 1$ #nm[(3.3)]],
  [*$z$ = OR ("at least one")*], [$z >= y_A$, $z >= y_B$, $z <= y_A + y_B$],
  table.cell(colspan: 2, fill: luma(244))[*Linking continuous and binary*],
  [*If $x > 0$ then pay $f$ / open*], [$x <= M y$, cost $f y$ #nm[(fixed charge)]],
  [*Min lot $r$ if produced*], [$r y <= x <= M y$ #nm[(semi-continuous)]],
  [*Either–or*], [$g_1(x) <= b_1 + M y$, $g_2(x) <= b_2 + M(1 - y)$ #nm[(machine scheduling)]],
  [*If $g_1(x) > 0$ then $g_2(x) >= 0$*], [$g_1(x) <= M y$, $-g_2(x) <= M(1 - y)$],
  [*At least $b$ of $m$ constraints hold*], [$g_i(x) <= b_i + M(1 - z_i)$ for each constraint $i$, $sum_i z_i >= b$],
  [*Single sourcing*], [$x_(w j) <= M z_(w j)$ with $M = d_j$, $sum_w z_(w j) = 1$],
  [*Integer from binaries*], [$x = sum_ell ell y_ell$, $sum_ell y_ell = 1$ (discrete levels, step costs)],
  [*Choosing $M$* (big M, all models)], [smallest valid bound: $min_r b_r \/ a_(r j)$, max order $d_j$, total demand $sum_j d_j$, $sum_j tau_j$],
  table.cell(colspan: 2, fill: luma(244))[*Linearising*],
  [*Max / abs / excess*], [$e >= g_1(x) - g_2(x)$, $e >= 0$ (= max(0, ·)) · $|g_1(x)| = e^+ + e^-$ with $g_1(x) = e^+ - e^-$],
  [*Helper (definition) variable*], [$x^T = sum_j x_j$ (total area, total blend), then ratios use $x^T$: $x_j - 0.5 x^T <= 0$, $x_j - 0.1 x^T >= 0$ ],
  [*Ratio / average / share*], [$sum_j a_j x_j <= c sum_j x_j$ · $x_k >= q sum_j x_j$ · equal %: $x^T_p \/ k_p = x^T_1 \/ k_1$],
  [*Piecewise / non-linear cost*], [convex: segments, no binaries · concave: $lambda_ell$ weights + $y_ell$ segment binaries (3.6)],
  [*Parameter test as a constraint*], [$("pop"_j - overline("pop")) y_j >= 0$ (forces $y_j = 0$ if $"pop"_j < overline("pop")$) · $tau_(j t) z_(j t) <= overline(tau)$ (forces $z_(j t) = 0$ if $tau_(j t) > overline(tau)$) #nm[(1.4)]],
  [*Forbid / force*], [$x_(p j) = 0$ (infeasible arc) · $y_j = 0$ if a rule fails],
)
]

// =====================================================================
#sec[5 · Sensitivity report (Excel Solver)]
// =====================================================================
#[
#set text(size: 5.5pt)
#text(size: 5.4pt)[Symbols: $c_j$ objective coefficient of $x_j$; $x^*_j$ optimal value; $b_r$ right-hand side of constraint $r$; SP shadow price; $Delta$ change; $z^*$ optimal objective.]
#table(columns: (auto, 1fr), inset: 2pt, stroke: 0.4pt + luma(180),
  [*Final value*], [Variable: $x^*_j$ · Constraint: resource *used* (LHS) at the optimum.],
  [*Reduced cost*], [Change in $z^*$ per unit increase of a *zero-valued* variable = how much $c_j$ must improve before $x_j$ enters.],
  [*Allowable inc./dec. (objective $c_j$)*], [Range of $c_j$ where the *optimal solution does not change*; $Delta z^* = Delta c_j dot x^*_j$. Outside: re-solve.],
  [*Shadow price (constraint)*], [$Delta z^*$ per unit increase of $b_r$: $Delta z^* = "SP" times Delta b_r$. Value of one more unit of a scarce resource. Non-binding ⇒ SP = 0.],
  [*Allowable inc./dec. (RHS $b_r$)*], [Range where the *shadow price stays valid* — *not* where the solution stays the same: $x^*$ values change.],
  [*100 % rule: objective*], [$sum_j Delta_j \/ "allowable"_j <= 1$ (allow. inc. for increases, dec. for decreases) ⇒ *optimal solution unchanged*; $Delta z^* = sum_j Delta_j x^*_j$.],
  [*100 % rule: RHS*], [Same sum over changed $b_r <= 1$ ⇒ *shadow prices unchanged*; $Delta z^* = sum_r "SP"_r Delta_r$.],
  [*Graphical (2 vars)*], [Plot constraints, feasible region, iso-profit line; optimum at a corner point.],
)
]

#v(2pt)
#block(fill: luma(244), inset: 3pt, radius: 2pt, width: 100%, text(size: 5.4pt)[
  *Recipe.* Sets → params (units) → vars (index, domain) → named objective terms → one named constraint family per sentence. %, ratios → cross-multiply; "if / only if / at most k", fixed fees → binaries (§4).
])

// =====================================================================
#sec[6 · Recognition guide: wording → model]
// =====================================================================
#[
#set text(size: 5.5pt)
#table(columns: (1fr, auto), inset: 2pt, stroke: 0.4pt + luma(180),
  table.header([*If the problem says…*], [*Use*]),
  [limited hours / material / budget; "how much of each to make"; maximise profit], [1.1 resource rows],
  ["at most X can be sold", sales forecast], [1.1 demand cap],
  ["each plant uses the same %" of its capacity], [1.1 ▸ same % (helper $u$)],
  ["units of part A, B per product"; maximise number of complete products], [1.1 ▸ assembly],
  ["average … must not exceed"; "at least / no more than X % of the total"], [1.2 · §4 ratio (cross-multiply)],
  ["contains at least X %"; mix inputs into products], [1.3 blending],
  ["at least N needed in each period"; overlapping shifts], [1.4 staffing],
  ["each area must be within X minutes / adjacent"; fewest sites], [1.4 set covering],
  ["each … on exactly one route / in exactly one group"], [1.4 partitioning],
  [cut standard lengths into pieces; trim waste], [1.5 cutting stock],
  [months / quarters; "carried over"; ending inventory; overtime], [1.6 balance rows],
  ["backorders allowed", "shortages carried to next month"], [1.6 ▸ backlog],
  [a repeating loop (route, cycle); usage depends on the amount carried], [1.6 ▸ cyclic],
  [season of X weeks; demand depends on the price], [1.7 price levels],
  [total supply ≠ total demand; "as much as possible"; penalty per unit short], [2.0 dummy / shortage],
  [sources with capacities → destinations with demands; cost table], [2.1 transportation],
  [budget limit; "at least X % of class served"; deadline / lead time], [2.1 ▸ service levels],
  ["each person to exactly one task"], [2.2 assignment],
  ["through / via" hubs, warehouses, pumps], [2.3 transshipment],
  [shortest / cheapest route; "replace or keep each year"], [2.4 shortest path],
  ["maximum that can be sent", link capacities only], [2.5 max flow],
  ["if any are produced / opened, a fixed cost"; lease; start-up], [3.1 fixed charge, $x <= M y$],
  [full-time / part-time workers; union rules], [3.1 ▸ workforce],
  [fixed fee to enter a market / introduce a product], [3.1 ▸ market entry · 3.5],
  [select projects; yes/no; cash per year], [3.2 knapsack],
  ["exactly k in both" events / roles], [3.3 · §4 AND],
  [open / close plants or warehouses; fixed annual cost; several levels], [3.4 location],
  ["at most k facilities"; "only from one warehouse"], [3.4 ▸ max open · single sourcing],
  ["investment → resulting capacity" table; in multiples of], [3.5 levels (A) or blocks (B)],
  ["first X units cost …, next …"; free allowance then pay], [3.6 convex (no binaries)],
  [volume discount; price drops after X units], [3.6 concave (binaries)],
  [jobs, processing times, due dates; total delay], [3.7 either-or with $M$],
  [visit each city once and return], [3.8 TSP],
  [orders with release / deadline; candidate truck routes; carrier option], [3.9 consolidation],
  [containers vs per-unit; lead time + interest rate], [3.10 batches + pipeline cost],
  ["if A then B", "not both", "at least one of", "at most k of"], [§4 binary logic],
  ["either … or …", "if this then that" on amounts], [§4 big M],
  ["what if price / capacity changes", "how much would you pay for one more"], [§5 sensitivity],
)
]