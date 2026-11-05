#set text(
  font: "Helvetica", 
  size: 8pt
)

#show math.overbrace: it => {
  if it.body.func() == math.equation { return it }
  let strut = box(height: 2.4em, width: 0pt)
  math.overbrace($strut #it.body$, it.annotation)
}

#let mc(x) = text(fill: red, x)

= Defining the problem

*Sets*

- $S$: Number of potential silos

- $R$: Number of farms to be served

- $T$: Time periods within the planning horizon

*Indices*

- $j in S$

- $r in R$

- $t, w in T$

*Parameters*

- $A_(j r t)$: (variable) *transportation cost* (per quintal) from silo $j$ to farm $r$, in period $t$

- $"CLC"_(j r)$: (fixed) *cost low capacity* for silo $j$ in period $t$

- $"CHC"_(j r)$: (fixed) *cost high capacity* for silo $j$ in period $t$

- $Q^L_(j t)$: capacity (*quintals*, *low* level) of silo $j$ in period $t$

- $Q^H_(j t)$: capacity (*quintals*, *high* level) of silo $j$ in period $t$

- $D_(r t)$: *demand* of farm $r$ within period $t$

- $"FSP"_t$: forage *selling price* in period $t$

- $"CCF"_(j t)$: *closing cost* of silo $j$ in period $t$

- $"SV"_(j t)$: *salvage value* of silo $j$ in period $t$

- $G_(j t)$: (variable) average *marginal cost* of processing one quintal in the silo $j$, in period $t$

*Decision Variables*

- $"IA"_(j t) = cases(
  1 #[if silo $j$ is initially activated in period $t$],
  0 #[otherwise]
)$

- $"FC"_(j t) = cases(
  1 #[if silo $j$ is closes in period $t$],
  0 #[otherwise],
)$

- $Y_(j t) = cases(
  1 #[if silo $j$ is active in period $t$],
  0 #[otherwise],
)$

- $"LC"_(j t) = cases(
  1 #[if silo $j$ operates at low capacity in period $t$],
  0 #[otherwise],
)$

- $"HC"_(j t) = cases(
  1 #[if silo $j$ operates at high capacity in period $t$],
  0 #[otherwise],
)$

- $S_(j r t)$: material flow (quintals) from silo $j$ to farm $r$ in period $t$

*Model*

Maximize revenue (Income - Cost)

$
  max quad
  \
  &cases(
    reverse: #true, gap: #0.75em,
    sum_(t in T) "FSP"_t sum_(j in S) sum_(r in R) S_(j r t) + quad quad &&#[sales],
    sum_(j in S) sum_(r in T) "SV"_(j t) "FC"_(j t) - quad quad &&#[salvage],

  ) quad #[revenue]
  \
  &cases(
    reverse: #true, gap: #0.75em,
    &sum_(j in S) sum_(r in R) sum_(t in T) A_(j r t) S_(j r t) - quad quad &&#[transport (variable)], 
    &sum_(j in S) sum_(t in T) "CLC"_(j t) "LC"_(j t) - quad quad &&#[setup LO cap (fixed)],
    &sum_(j in S) sum_(t in T) "CHC"_(j t) "HC"_(j t) - quad quad &&#[setup HI cap (fixed)],
    &sum_(i in S) sum_(t in T) G_(j t) sum_(r in R) S_(j r t) quad quad &&#[production (variable)],
  ) quad #[costs]
  \
  "s.t." quad
  &sum_(s in S) A_(s r t) S_(s r t) gt.eq D_(r t) quad &&forall r in R, t in T quad &&#[demand] \
  &sum_(r in R) S_(s r t) lt.eq Q^L_(j t) quad &&forall s in S, t in T quad &&#[supply (LO)] \
  &sum_(r in R) S_(s r t) lt.eq Q^H_(j t) quad &&forall s in S, t in T quad &&#[supply (HI)] \
  & \
$


