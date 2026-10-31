#import "@preview/lilaq:0.6.0" as lq
#import "@local/tystats:0.1.0": norm, uniform

#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)

#let result(content) = box(stroke: blue, fill: blue.transparentize(75%), inset: 0.5em, radius: 0.25em)[#content]

#let r(d, digits: 3) = calc.round(d, digits: digits)

#h(1fr) Vladimir Borel

= Problem 1

*(a)*

- Demand in the different regions are positively correlated
- Reduces the effect of pooling 

*(b)*

#let S = 5500
#let H = 1.25 // week
#let L = 2 // weeks

#let A = (33, 45, 37, 38, 55, 30, 18, 58, 47, 37, 23, 55)
#let B = (26, 35, 41, 40, 46, 48, 55, 18, 62, 44, 30, 45)
#let C = (44, 34, 22, 55, 48, 72, 62, 28, 27, 95, 35, 45)
#let D = (27, 42, 35, 40, 51, 64, 70, 65, 55, 43, 38, 47)
#let L = (32, 43, 54, 40, 46, 74, 40, 35, 45, 38, 48, 56)

= Problem 2

#let mean = 100
#let sd = 65
#let L = 2 // weeks
#let T = 1 // weeks

*(a)*

#let CSL = 0.97

*(b)*







