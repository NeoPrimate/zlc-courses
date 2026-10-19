#set text(
  font: "Helvetica", 
  size: 8pt
)
#show table: it => align(center, it)
#import "@local/tystats:0.1.0": norm, expon, poisson, uniform

#h(1fr) Fabian Hernandez Leiva\
#h(1fr) Manyara Kevin Omenyi\
#h(1fr) Vladimir Borel\

= Obermeyer

_Using the sample data given in Exhibit 10, make a recommendation for how many units of each style Wally Obermeyer should order during the initial phase of production._
_Assume that all ten styles in the sample problem are made in Hong Kong (at this point, ignore the minimum production constraints), and that Obermeyer's initial production commitment must be at least 10,000 units._
_Ignore price differences among styles in your analysis._
_This is a group assignment (groups of 3 + one group of 4 or two groups of 2). Please have only one group member upload your answers._

#let forecasts = (
  ("Gail", 1017, 194),
  ("Isis", 1042, 323),
  ("Entice", 1358, 248),
  ("Assault", 2525, 340),
  ("Teri", 1100, 381),
  ("Electra", 2150, 404),
  ("Stephanie", 1113, 524),
  ("Educed", 4017, 556),
  ("Anita", 3296, 1047),
  ("Delphne", 2383, 697),
)

#let p = 112.50

#let profit_margin = 0.24
#let salvage_margin = 0.08

#let cu = p * profit_margin
#let co = p * salvage_margin

#let cr = cu / (cu + co)

#let z = norm.ppf(cr)

#let Qs = forecasts.map(name_mean_sd => (name_mean_sd.at(0), norm.ppf(cr, mean: name_mean_sd.at(1), std_dev: name_mean_sd.at(2) * 2)))

#let old_table = table(
  columns: 2,
  inset: 1em,
  align: left,

  table.header([*Style*], [*$Q^*$*]),
  
  ..Qs.map(name_Q => (
    [#name_Q.at(0)], 
    [#calc.round(name_Q.at(1), digits: 2)]
  )).flatten(),

  [*Total*], [#calc.round(Qs.map(name_Q => name_Q.at(1)).sum(), digits: 2)]
)

#let min_units = 10000
#let average_forecast = forecasts.map(name_mean_sd => name_mean_sd.at(1)).sum()
#let sd_forecast = forecasts.map(name_mean_sd => name_mean_sd.at(2)).sum() * 2
#let z = (min_units - average_forecast) / sd_forecast

== Problem

We must commit at least 10,000 units of the 10 sample parkas 
before the Las Vegas trade show, with the remaining
~10,000 units produced after the show.

== Demand model

Demand for each style $i$ is normal:

- $mu_i$
- $sigma_i$ = 2 $times$ standard deviation

== Economics

Each parka sold earns 24% of the wholesale price, and each unsold parka
loses 8%. The critical ratio is


$ C_u / (C_u + C_o) = 0.24 / (0.24 + 0.08) = #calc.round(cr, digits: 2) $


== Approach: equal risk across styles

The units made now should be the ones we are most confident of selling.

$ Q_i = mu_i + z sigma_i, quad sum_i Q_i = 10000 $

$
  mu + z sigma &= #min_units \
$
$
  #average_forecast + z dot #sd_forecast = #min_units \
  z = (#min_units - #average_forecast) / #sd_forecast \
  = #calc.round(z, digits: 4)
$

This gives $z = #calc.round(z, digits: 4)$.

#let new_Q = forecasts.map(name_mean_sd => (name_mean_sd.at(0), (name_mean_sd.at(1) + z * 2 * name_mean_sd.at(2))))

#let new_table = table(
  columns: 2,
  inset: 1em,
  align: left,

  table.header([*Style*], [*New $Q^*$*]),
  
  ..new_Q.map(name_Q => (
    [#name_Q.at(0)], 
    [#calc.round(name_Q.at(1), digits: 2)]
  )).flatten(),

  [*Total*], [#calc.round(new_Q.map(name_Q => name_Q.at(1)).sum(), digits: 2)]
)

#grid(
  columns: (1fr, 1fr),
  inset: 1em,
  [
    #old_table
  ],
  [
    #new_table
  ]
)

== Recommendation

Wally should commit the quantities in the table above (total 10,000
units), rounded to whole units. Stephanie comes out at roughly one unit,
so its production should be deferred entirely until after Las Vegas.

== Interpretation

- High-consensus styles (Seduced, Assault, Gail, Entice) are
  produced mostly up front: their demand is predictable, so early
  production carries little risk.
- High-disagreement styles (Stephanie, Anita, Teri, Isis) are cut
  back hardest: their demand is uncertain, so most of their production
  is postponed until the trade show provides better information.
- The approach turns the committee's disagreement into a
  production-sequencing rule: make the safe units now, wait on the
  risky ones. The flexible post-show capacity is kept for the styles
  where information is worth the most.
