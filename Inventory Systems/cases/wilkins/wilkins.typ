#set text(font: "Helvetica", size: 8pt)
#set par(justify: true)
#set heading(numbering: none)
#show table: it => align(center, it)
#set table(stroke: 0.5pt + gray, inset: 5pt)
#show table.cell.where(y: 0): strong

#let result(content) = box(stroke: blue, fill: blue.transparentize(75%), inset: 0.5em, radius: 0.25em)[#content]

#let r(d, digits: 3) = calc.round(d, digits: digits)

#let _check-inputs(A, F) = {
  assert.eq(A.len(), F.len(), message: "actuals and forecasts must have the same length")
  assert(A.len() > 0, message: "actuals and forecasts must not be empty")
}

#let mape(A, F) = {
  _check-inputs(A, F)
  let errors = A.zip(F).map(((a, f)) => {
    assert(a != 0, message: "MAPE is undefined when an actual value is 0")
    calc.abs((a - f) / a)
  })
  100 * errors.sum() / A.len()
}

#let me(A, F) = {
  _check-inputs(A, F)
  A.zip(F).map(((a, f)) => f - a).sum() / A.len()
}

#h(1fr) Manyara Kevin Omenyi \
#h(1fr) Fabian Hernandez \
#h(1fr) Vladimir Borel \

= Wilkins: Demand Forecasting

== How accurate was the demand forecast for the first quarter of 2005? Please use mean error (ME) and mean absolute per cent error (MAPE) to measure bias and magnitude, respectively.

$
  "MAPE" = 100 / n sum_(t=1)^n abs((A_t - F_t) / A_t)
$

$
  "ME" = 1 / n sum_(t=1)^n (F_t - A_t)
$

#table(
  columns: 3,
  
)


== Create a demand forecast for the PVB product family for Q1-Q4 2005. How does your demand forecast compare to Wilkins' demand forecast?

