#import "/lib/imports.typ": *
#import "/lib/formatting.typ": *
#import "@local/tystats:0.1.0": norm, poisson, expon

#import "@preview/tiptoe:0.4.0"
#import "@preview/komet:0.2.0"

#show: formatting

= Math Review

== Functions

$
  f: &X &arrow &Y \
  &x &arrow &f(x) \
$

independent $arrow$ dependent

=== Linear Functions

$
  y = a x + b
$

Where:
- $a$: slope
- $b$: intercept
$
  "Profit" 
  &= "Revenue" - "Cost" \
  &= (p) dot V - (F + c dot V) \
  &= (p - c) dot V - F \
$

=== Asymptotes

+ Horizontal
  - $y = a$
+ Oblique
  - $y = a x + b$
+ Vertical
  - $x = C$

#let f(x) = calc.sin(x) / x
#let x = lq.linspace(-25, 25, num: 100)

#lq.diagram(
  xlim: (-25, 25),
  lq.plot(x, f, mark: none, stroke: blue),
  lq.hlines(0)
)

Hotizontal and Oblique Asymptotes

$
  f(x) = A + B x + theta (x)
$

Where:
- $lim_(x arrow infinity) theta (x) = 0$

$
  f(x) / x 
  &= (A + B x + theta (x)) / x \
  &= A / x + B + (theta (x)) / x \ 
  &= 0 + B + 0 \
  &= B
$

Since $x = infinity$

+ If the limit exists and it is a real number then $exists$ asymptote 
  - If $B = 0$ aymptote is horizontal
  - If $B eq.not 0$ aymptote is oblique
+ If limit is $infinity$ or $-infinity$ asymptote does not exist

Then

$
  f(x) - B x 
  &= A + cancel(B x) + theta (x) - cancel(B x) \
  &= A + theta (x) arrow.long_(x arrow infinity) A
$

Horizontal & Oblique

$
  f(x) = A x + B + theta(x), quad "where" lim_(x arrow infinity) theta(x) = 0
$

- Computation of $A$

$
  f(x) / x = A + B / x + theta(x) / x
$
$
  A = lim_(x arrow infinity) f(x) / x
$

- Computation of $B$
$
  f(x) - A x = B + theta(x)
$
$
  B = lim_(x arrow infinity) (f(x) - A x)
$

- Asymptote: $y = A x + B$

=== Sandwich rule

$
  (-1) / f(x) < ... < 1 / f(x)
$

=== Veritcal Asymptotes

$
  x = C
$

Find $x = C$ such that $lim_(x arrow C) f(x) = infinity$

*Exercise*

1. Horizontal & Oblique

$
  f(x) = (2 x^2 + x + 7) / (x - 6) + (-x^2 + 5x + 5) / (x + 3)
$

$
  lim_(x arrow infinity) f(x) 
  &= lim_(x arrow infinity) ((2 x^2 + x + 7) / (x - 6) + (-x^2 + 5x + 5) / (x + 3)) / x \
  &= lim_(x arrow infinity) (2 x^2 + x + 7) / (x (x - 6)) + (-x^2 + 5x + 5) / (x (x + 3)) \
  &= lim_(x arrow infinity) underbrace((2 x^2 + x + 7) / (x^2 - 6 x), 2) + underbrace((-x^2 + 5x + 5) / (x^2 + 3 x), -1) \
  &= 2 - 1 \
  &= 1 \
  & = A in RR
$

$
  
$

$
  A = 1 eq.not 0 arrow.double "oblique asymptote"
$

D d R q (table)

$
  B 
  &= lim_(x arrow infinity) (f(x) - A x) \
  &= lim_(x arrow infinity) underbrace((2x^2 + x + 7) / (x - 6), 2x + 13 + 85 / (x - 6)) + underbrace((-x^2 + 5x + 5) / (x + 3), -x + 8 - 19 / (x + 3)) - x \
  &= lim_(x arrow infinity) cancel(2x) + 13 + underbrace(86 / (x - 6), 0) cancel(- x) + underbrace(8 - 19 / (x + 3), 0) cancel(- x) = 21 \
$

Therefore:

$
  A = 1 \ 
  B = 21 \
  y = x + 21
$

2. Vertical

$
  f(x) = (2 x^2 + x + 7) / (x - 6) + (-x^2 + 5x + 5) / (x + 3)
$

$
  lim_(x arrow 6) f(x) = infinity arrow.double x = 6 \
  lim_(x arrow -3) f(x) = infinity arrow.double x = -3 \
$

3 asymptotes
- $y = x + 21$
- $x = 6$
- $x = -3$

== Continuity

A function $f : D arrow RR$ is said to be *contnuous* as $x_0 in D$ if there exists $lim_(x arrow x_0) f(x) = f(x_0)$, that is, if $forall epsilon gt 0$ there exists $delta gt 0$ such that:

$
  forall x in D quad "with" quad ||x - x_0|| lt delta quad arrow.double quad ||f(x) - f(x_0)|| lt epsilon
$

- A function is continuous in an interval iff it is continuous in evert oint in that interval
- Sum perserves continuity
- Product perserves continuity
- Quotient perserves continuity (unless denominator is zero)
- Composition perserves continuity
- Polynomial, exponentials, sin, cos, odd roots are continuous
- Log and even roots are continuous in their domains

== Convexity

$
  f(lambda x + (1 - lambda) y) lt.eq lambda f(x) + (1 - lambda) f(y), quad 0 lt.eq lambda lt.eq 1, quad x, y in "Dom" f
$

Any local minima of a convex function is also a global minima

$
  min quad &f(x) \
  s.t. quad &g_i(x) lt.eq 0 quad i = 1, dots, m \
  &h_i(x) eq 0 quad i = 1, dots, n \
$

$
  max f(x) quad arrow.l.r quad min -f(x)
$

= Derivatives

$
  f: S arrow RR, quad (dif f) / (dif x) (x_0) = f'(x_0) = lim_(x arrow x_0) (f(x) - f(x_0)) / (x - x_0),quad x_0 in D
$

*Instintanous rate of change* at a given point

Slope of the tangent line at that point

Differentiation rules

$
  [x^a]' = a x^(a - 1)
$

$
  [alpha dot f(x) + beta dot g(x)]' = alpha dot f'(x) + beta dot g'(x)
$

$
  [f(x) dot g(x)]' = f'(x) dot g(x) + f(x) dot g'(x)
$

$
  [f(x) / g(x)]' = (f'(x) dot g(x) - f(x) dot g'(x)) / g(x)
$

$
  [f(g(x))]' = f'(g(x)) dot g'(x)
$

If $f'(x) gt.eq 0$ for all $x in (a, b)$, $f(x)$ is increasing in $(a, b)$

$
  f' gt.eq 0 arrow.double f "increasing" \
  f' lt.eq 0 arrow.double f "decreasing" \
$

== Optimization

$
  
  f("units") = 500000 + 75 dot "units" \
  D("price") = 20000 - 80 dot "price" \
$

$
  "profit" = "revenue" - "cost"
$

$
  C("price") = 500000 + 75 dot (20000 - 80 dot "price")
$

$
  P(p) 
  &= p dot D(p) - C(p) \ 
  &= p dot (20000 - 80 p) - [500000 _ 75 dot (20000 - 80p)] \
  &= -80p^2 + 26000p - 2000000 \
$

Solve: 

$
  max quad P(p) = -80p^2 + 26000p - 2000000
$

Local max / min in $x_0 in (a, b)$ is $f'(x) = 0$

$x_0$ is a *critical point*

If $x_0$ is a critical point of $f(x)$ ($f'(x_0) = 0$), then:
- $f$ has a local min at $x_0$ with a value if $f''(x_0) lt 0$
- $f$ has a local max at $x_0$ with a value if $f''(x_0) gt 0$

If $f''(x_0) = 0$: undertermined (recursively / iteratively derive until positive or negative)

Extreme points can be:
- Non differentiable points (absolute function)
- Bundaries (end of the interval) of the function

Weierstrass Theorem

Is a function is continuous on an interval $[a, b]$, then $f$ must attain a maximum and minium, each at least once. That is, there exists $c$ and $d$ in $[a, b]$ such that:

$
  f(c) gt.eq f(x) gt.eq f(d) forall x in [a, b]
$

3 possibilities:
- f is not differentiable in $x_0$
- $f'(x_0) = 0$
- $x_0$ is an end of interval $[a, b]$ ($x_0 = a$ or $x_0 = b$)

$
  max quad P(p) = -80p^2 + 26000p - 2000000
$

#let f(x) = -80 * calc.pow(x, 2) + 26000 * x - 200000
#let crit = 162.5
#let x = lq.linspace(crit - 200, crit + 200, num: 100)

#let df(x) = -160 * x + 26000

#let ddf(x) = -160

#grid(
  columns: 1,
  gutter: 1em,
  [
    #lq.diagram(
      xaxis: (
        subticks: none,
        ticks: ((crit, box(inset: (top: 0em), text(size: 0.7em)[$crit$])),),
      ),
      yaxis: (subticks: none, ticks: none),
      lq.plot(x, f, mark: none, stroke: blue),
      lq.vlines(crit, stroke: red)
    )
  ],
  [
    #lq.diagram(
      xaxis: (
        subticks: none,
        ticks: ((crit, box(inset: (top: 0em), text(size: 0.7em)[$crit$])),),
      ),
      yaxis: (subticks: none, ticks: none),
      lq.plot(x, df, mark: none, stroke: blue),
      lq.hlines(0, stroke: black),
      lq.vlines(crit, stroke: red),
    )
  ],
  [
    #lq.diagram(
      xaxis: (subticks: none, ticks: none),
      yaxis: (
        subticks: none,
        ticks: ((-160, box(inset: (top: 0em), text(size: 0.7em)[$-160$])),),
      ),
      lq.plot(x, ddf, mark: none, stroke: blue),
    )
  ]
)

== EOQ

- $D$: Constant demand rate (units per unit time)
- $K$: Fixed Ordering cost (\$ per order)
- $h$: holding cost (\$ per inventory unit per unit time)
- $Q = x / D$: ordering cycle of the pattern

How much to order?

Total cost per unit time

$
  "TCU" 
  &= ("total holding cost per cycle" + "total ordering cost per cycle") / Q \
  &= (h dot x / 2 dot Q + K) / Q \
  &= (h dot x / 2 cancel(dot Q)) / cancel(Q) + K / Q \
$

$
  Q = x / D
$

$
  "TCU"(x) 
  &= h dot x / 2 + K / (x / D) \
  &= h dot x / 2 + (D k) / x \ 
$

$
  min quad "TCU"(x) = h dot x / 2 + (D k) / x
$

Solve:

$
  "TCU"'(x) = h / 2 - (D dot K) / x^2 = 0
$

$
  (D dot K) / x^2 = h / 2 \
  x^2 = (2 D K) / h \
  x^* = plus.minus sqrt((2 D K) / h)
$

$
  "TCU"''(x) = 2 dot (D dot K) / x^3 \
  "TCU"''(x^*) gt 0 \
$

$
  Q^* = x^* / D = sqrt((2 K) / (D h))
$

Global minimum for $"TCU"(x)$ when $x gt.eq 0$

= Lagrange Multipliers

Cobb-Douglas function

$
  f(x, y) = 200 dot x^(2/3) y^(1/3)
$

Use Largangian to find extremum points

= Integrals

- Definite
- Indefinite

$
  dif / (dif x) integral^x_a f(t) dif t = f(x) 
$

Indefinite integral:

$
  integral f(x) dif x = F(x) + C
$

with $F'(x) = f(x)$


Barrow's rule:

$
  integral^b_a f(x) dif x = F(a) - F(b)
$

== Integration Rules

Immediate integral rules (tables)

Integration by *parts*

$
  integral u dot dif v = u dot v - integral v dot dif u
$

Integration by *change*

$
  integral f(x) dif x
$

Chnage of variables:

$
  x = x(u) \
  dif x = x'(u) dif u
$

$
  integral f(x(u)) dot x'(u) dif u
$

= Probability

== Random (Uncertain) Events

- *Experiment*: process of generating observations
- *Sample space* ($S$): all possible observations, or outcomes, of an experiment 

$
  S = {H, T} \
  S = {1, 2, 3, 4, 5, 6}
$

- *Event*: set of outcomes contained in the sample space $S$

$
  A = {1, 3, 5} \
  B = {2, 4, 5} \
$

Probability: the proportion of times that the outcome would occur if we observed the random process an infinite number of times (*asynmptotically*)

Let $S$ be a s sample space and $A$ an event in $S$. The probability of $A$, $P(A)$, satifies the following properties:
- $0 lt.eq P(A) lt.eq 1$
- $P(S) = 1$
- If $A$ and $B$ are mutually exclusive:

$
  P(A union B) = P(A) + P(B)
$

If an expirement has $n$ equally likely outcomes, and $s$ of these outcomes are labeled success, then the probability of a siccessful outcomes is $s / n$

$
  A union B = {x | x in A or x in B}
$

$
  A inter B = {x | x in A and x in B}
$

$
  P(A union B) = P(A) + P(B) - P(A inter B)
$

If $A$ and $B$ are independent:

$
  P(A inter B) = P(A) dot P(B)
$

Independent v. Mutually Exclusive
- Independent: 
- Mutually exclusive: 

== Conditional Probability

Probability that event $A$ occurs given that event $B$ has occurred

$
  P(A | B)
$

If $A$ and $B$ are independent:

$
  P(A | B) = P(A)
$

For independent OR non-independent:

$
  P(A | B) = P(A inter B) / P(B)
$

If $A$ and $B$ are independent events:

$
  P(A) = P(A inter B) / P(B) \
  P(A inter B) = P(A) dot P(B) \
$

Discrete v. Continuous

== Probability Distribution

A fuction that provides the probabilities of occurrence of different possible outcomes in an experiment 

$
  f(x) = P(X = x)
$

PMF

$
  P(X = x) \
$

CDF

$
  P(X lt.eq x) \
$

PDF



=== Discrete Distributions

==== Uniform

==== Binomial

$
  P(X = k) = binom(n, k) p^k (1 - p)^(n - k)
$

#example[
  A retail knows that 10% of all orders placed get returned each week. The retail store usually sends 50 orders a week. If $X = "number of returned orders a week"$, $P(X gt 5)$.

  $
    X ~ "Binom"(50, 0.1)
  $

  $
    P(X gt 5) \
  $

  $x$ can take the values $X = {0, 1, 2, dots, 50}$

  $
    P(X gt 5) = P(X = 5) + P(X = 7) + dots + P(X = 50)
  $

  - $n = 50$
  - $p = 0.1$

  $
    binom(50, 6) 0.1^6 (1 - 0.1)^(50 - 6) + binom(50, 7) 0.1^7 (1 - 0.1)^(50 - 7) + dots + binom(50, 50) 0.1^50 (1 - 0.1)^(50 - 50)
  $

  $
    1 - P(X lt.eq 5) = 1 [P(X = 0) + P(X = 1) + dots + P(X = 5)]
  $
]

==== Bernoulli

Binomial with $n = 1$

==== Negative Binomial 

- Trial with two possible outcomes
- Success or failure
- We know the probability of success- We repeat the experiment until a known number of successes happedn (indpendent trials) ($k$)
- What is the probability of needing exactly a given number of trials ($n$)?

$
  P(X = n) = binom(n - 1, k - 1) p^k (1 - p)^(n-k), quad n gt.eq k
$

#example[
  Rolling a die until a score of 6 is obtained $k = 3$ times

  $
    X ~ "NBin"(k = 3, p = 1\/6)
  $

  $
    P(X = n) = binom(n-1, 2) p^3 (1 - p)^(n-3), quad n gt.eq 3
  $
]

==== Poisson

- Suppose events distributed in a contunuum
- On average the rate of such an event is $lambda$
- We observe a portion of length $t$ in such continuum
- What is the probability of counting exactly a given number ($k$)?

$
  P(X = k) = ((lambda t)^k e^(-lambda t)) / k!
$

#example[
  An electronic company that the number of components that fail before 100 hours is a Poisson random variable. If the average rate of failure is 0.08 per hour.

  a. What is the probability that a component fails in 25 hours? 

  $
    P(X = 1) = ((0.08 times 25)^1 e^(-0.08 times 25)) / 1!
  $

  ```py
  from scipy.stats import poisson

  k = 1
  mu = 0.08
  t = 25

  poisson.pmf(k, mu * t, loc=0)
  ```

  b. What is the probability that no more than 2 components fail in 50 hours?

  $
    P(X < 2) 
    &= ((lambda t)^k e^(-lambda t)) / k! \
    &= ((0.08 times 50)^0 e^(-0.08 times 50)) / 0! + ((0.08 times 50)^1 e^(-0.08 times 50)) / 1! + ((0.08 times 50)^2 e^(-0.08 times 50)) / 2!
  $

  ```py
  from scipy.stats import poisson

  k = 2
  mu = 0.08
  t = 50

  poisson.cdf(k, mu * t, loc=0)
  ```

  c. What is the probability that at least 10 components fail in 125 hours?

  $
    P(X gt.eq 10) = ((lambda t)^k e^(-lambda t)) / k!
  $

  ```py
  from scipy.stats import poisson

  k = 10
  mu = 0.08
  t = 125

  1 - poisson.cdf(k - 1, mu * t, loc=0)
  ```
]

=== Continuous Distributions

PDF properties

1.

$
  P(a lt.eq X lt.eq b) = integral_a^b f(x) dif x quad quad "for" a lt.eq b
$

2.

$
  f(x) gt.eq 0 forall x
$

3.

$
  integral_(-infinity)^infinity f(x) dif x = 1
$

==== Uniform

$
  X ~ cal(U)(a, b)
$

$
  f(x) = cases(
    1 / (b-a) quad quad &"if" x in [a, b],
    0 quad quad &"otherwise"
  )
$

==== Exponential

$
  X ~ "Exp"()
$

$
  f(x) = lambda e^(-lambda x)
$

CDF

==== Normal

PDF



CDF

Z-Score

$
  Z = (X - mu) / sigma ~ cal(N)(0, 1)
$


== Beyes Rule

If $A_1, A_2, dots, A_n$ are mutually exclusive and exhaustive events and $B$ is an event, then:

$
  P(B) 
  &= P(B inter A_1) + P(B inter A_2) + dots + P(B inter A_n) \
  &= P(A_1) dot P(B | A_1) + P(A_2) dot P(B | A_2) + dots + P(A_n) dot P(B | A_n) \
  &= sum_(k=1)^n P(A_k) dot P(B | A_k)
$

$
  P(A_i | B) = (P(B | A_i) dot P(A_i)) / (sum_(k=1)^n P(A_k) dot P(B | A_k))
$

=== Expected value

Discrete

$
  E[X] 
  &= sum_(i=1)^n X_ dot P(X = X_i)i \
  &= p_1 dot X_1 + p_2 dot X_2 + dots + p_n X_n \
$

Continuous

$
  E[X] = integral_(-infinity)^infinity x dot f(x) dif x \
$

=== Variance

$
  "Var"[X] = E[X^2] - (E[X])^2
$

Known Variances:

- Binomial

$
  "Var"[X] = n p (1 - p)
$

