#import "@preview/typslides:1.3.4": *
#import "@preview/lilaq:0.6.0" as lq

#show: typslides.with(
  ratio: "16-9",
  theme: "bluey",
  font: "Helvetica",
  font-size: 12pt,
  link-style: "color",
  show-progress: true,
)

#let cols = ("Sales", "CoGS", "Number of stores", "Inventory")

#let years = ( 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025)

#let inditex = (
  (13793, 15946, 16724, 18117, 20900, 23311, 25336, 26145, 28286, 20402, 27716, 32569, 35947, 38632, 39864), 
  (5612, 6416, 6802, 7548, 8811, 10032, 11076, 11329, 12479, 9013, 11902, 14011, 15186, 16288, 16642),
  (5527, 6009, 6340, 6683, 7013,7292,7475,7490,7469, 6829,6477,5815,5692,5563,5460), 
  (1277, 1581, 1677, 1860, 2195, 2549, 2685, 2716, 2269, 2321, 3042, 3191, 2966, 3321, 3249),
)

#let hm = (
  (109999, 120799, 128562, 151419, 180861, 192267, 200004, 210400, 232755, 187031, 198967, 223553, 236035, 234478, 228285), 
  (43852, 48928, 52537, 62367, 77694, 86090, 91914, 99513, 110302, 93487, 93961, 110183, 115139, 109179, 106464),
  ( 2472, 2776, 3132, 3511, 3924, 4351, 4739, 4968,5076, 5018, 4801,4465,4369,4250,4101),
  (13819, 15213, 16695, 19403, 24833, 31732, 33712, 37721, 37823, 38209, 37306, 42495, 37358, 40348, 35427),
)

#let gap = (
  (14549, 15651, 16148, 16435, 15797, 15516, 15855, 16580, 16383, 13800, 16670, 15616, 14889, 15086, 15366),
  (9275, 9480, 9855, 10146, 10077, 9876, 9789, 10258, 10250, 9095, 10033, 10257, 9114, 8859, 9098), 
  (3263, 3407, 3539, 3709, 3721, 3659, 3594, 3666, 3919, 3715, 3399, 3352, 3560, 3569, 3474),
   (1615, 1758, 1928, 1889, 1873, 1830, 1997, 2131, 2156, 2451, 3018, 2389, 1995, 2067, 2207)
)

#let uniqlo = (
  (820349, 928669, 1143003, 1382935, 1681781, 1786473, 1861917, 2130060, 2290548, 2008846, 2132992, 2301122, 2766557, 3103836, 3400539),
  (394581, 453202, 578992, 683161, 832482, 921820, 953302, 1079940, 1170470, 1033000, 1059036, 1094263, 1330257, 1430764, 1571700),
  (1024, 1137, 1299, 1485, 1639, 1795, 1920, 2068, 2196, 2252, 2312, 2345, 2434, 3595, 3570),
  (92750, 98963, 166654, 223223, 260000, 270000, 289600, 464700, 518900, 417529, 394868, 485928, 449328, 474460, 510860),
)

#let data = (Inditex: inditex, "H&M": hm, Gap: gap, Uniqlo: uniqlo)

#let idx(xs) = xs.map(x => 100 * x / xs.first())
#let sales_idx(d) = idx(d.at(0))
#let gm(d)    = d.at(0).zip(d.at(1)).map(((s, c)) => (s - c) / s)
#let dio(d)   = d.at(1).zip(d.at(3)).map(((c, i)) => 365 * i / c)
#let gmroi(d) = d.at(0).zip(d.at(1), d.at(3)).map(((s, c, i)) => (s - c) / i)
#let inv_sales(d) = d.at(3).zip(d.at(0)).map(((i, s)) => i / s)
#let sps_idx(d) = idx(d.at(0).zip(d.at(2)).map(((s, n)) => s / n))
#let stores(d) = d.at(2)

#let compare(title, f) = {
  show lq.selector(lq.legend): set text(size: 12pt)
  show lq.selector(lq.legend): set grid(row-gutter: -1pt)

  let plots = ()
  for (name, d) in data {
    plots.push(lq.plot(years, f(d), label: name))
  }
  
  lq.diagram(
    width: 20em, 
    height: 10em, 
    legend: (position: (100% + .5em, 0%)),
    title: title, 
    ..plots
  )
}


#front-slide(
  title: "Fast Fashion",
  subtitle: [Benchmarking],
  authors: [
    Manyara Kevin Omenyi

    Fabian Hernandez Leiva

    Vladimir Borel
  ]
)

#slide[
  = The scene: a growing sector that splits apart after 2019 

  #grid(
    columns: 2,
    inset: 2em,
    [
      *COVID (2020)*: Store counts show a shift away from continuous store expansion.

      Growth is no longer driven by opening more stores, but by how efficiently companies run their operations.

      Uniqlo is the only one still expanding.

      Up to 2019: 
      
      - *Inditex*, *H&M*, and *Uniqlo* roughly doubled or tripled sales
      
      - *Gap* remained broadly flat.

      Post-2019:

      - Uniqlo: Growth

      - Inditex & H&M: Slowing
      - Gap: Stagnant
    ],
    [
      #compare([Sales index (2011 = 100)], sales_idx)

      #compare([Stores], stores)
    ]
  )
]

#slide[
  = Four different ways to win
  \
  - *Inditex*: it owns most of its value chain, produces close to home in short runs and reacts during the season.

  - *Uniqlo*: it controls design and planning and sells long-lasting basics in large runs.

  - *H&M*: a fast-fashion promise, but production is fully outsourced and mostly far away.

  - *Gap*: four brands, all made by outside suppliers, and it is currently in a turnaround.

  #v(5em)
  - *Question*: do these different models show up in the numbers?
  
]

#slide[
  = Margin and speed: the operating model shows up in the ratios

  #grid(
    columns: 2,
    inset: 2em,
    [
      - *Inditex*: the highest and steadiest margin (about 58%) together with the shortest inventory period (about 71 days)

      - *H&M*: its margin fell while stock sat for about 120-150 days

      - *Uniqlo*: it holds a lot of stock (DIO peaked around 160 days in 2018-22), yet its margin rose to 54%

      - *Gap*: stock moves reasonably fast (about 89 days), but its margin is the lowest at about 41%. That points to a problem?
    ],
    [
      #compare([Gross margin], gm)

      #compare([Days of inventory], dio)
    ]
  )
]

#slide[
  = The punchline: GMROI combines both

  #grid(
    columns: 2,
    inset: 2em,
    [
      - *Inditex* earns about 7$times$ its inventory in gross profit, roughly double the others, and it widened that gap after 2019.

      - *H&M* and *Uniqlo* both fell from 2011 to 2018-19.

      *Conclusion*: 

      - Owning more of the supply chain pays off most when it is used for speed (Inditex) 
      
      - Controlling design and sourcing also works for basics (Uniqlo)
      
      - Relying fully on outside suppliers without a clear position (H&M, Gap) squeezes margin, inventory efficiency (or both)
    ],
    [
      #compare([GMROI], gmroi)
    ],
  )
]







// //////////////////////////////////////
// // INDEX
// //////////////////////////////////////

// #for (i, col) in inditex.enumerate() {
//   lq.diagram(
//     height: 15em,
//     width: 15em,
//     title: [#cols.at(i) (Inditex)],
//     lq.plot(years, col),
//   )
// }

// #let gp_inditex = inditex.at(0).zip(inditex.at(1)).map(sales_cogs => sales_cogs.at(0) - sales_cogs.at(1))
// #lq.diagram(
//   height: 15em,
//   width: 15em,
//   title: [GP (Inditex)],
//   lq.plot(years, gp_inditex),
// )
// #let gm_inditex = gp_inditex.zip(inditex.at(0)).map(gp_sales => gp_sales.at(0) / gp_sales.at(1))
// #lq.diagram(
//   height: 15em,
//   width: 15em,
//   title: [GM (Inditex)],
//   lq.plot(years, gm_inditex),
// )

// //////////////////////////////////////
// // HM
// //////////////////////////////////////

// #for (i, col) in hm.enumerate() {
//   lq.diagram(
//     height: 15em,
//     width: 15em,
//     title: [#cols.at(i) (H&M)],
//     lq.plot(years, col),
//   )
// }
// #let gp_hm = hm.at(0).zip(hm.at(1)).map(sales_cogs => sales_cogs.at(0) - sales_cogs.at(1))
// #lq.diagram(
//   height: 15em,
//   width: 15em,
//   title: [GP (H&M)],
//   lq.plot(years, gp_hm),
// )
// #let gm_hm = gp_hm.zip(hm.at(0)).map(gp_sales => gp_sales.at(0) / gp_sales.at(1))
// #lq.diagram(
//   height: 15em,
//   width: 15em,
//   title: [GM (H&M)],
//   lq.plot(years, gm_hm),
// )

// //////////////////////////////////////
// // GAP
// //////////////////////////////////////

// #for (i, col) in gap.enumerate() {
//   lq.diagram(
//     height: 15em,
//     width: 15em,
//     title: [#cols.at(i) (Gap)],
//     lq.plot(years, col),
//   )
// } 

// #let gp_gap = gap.at(0).zip(gap.at(1)).map(sales_cogs => sales_cogs.at(0) - sales_cogs.at(1))
// #lq.diagram(
//   height: 15em,
//   width: 15em,
//   title: [GP (Gap)],
//   lq.plot(years, gp_gap),
// )
// #let gm_gap = gp_gap.zip(gap.at(0)).map(gp_sales => gp_sales.at(0) / gp_sales.at(1))
// #lq.diagram(
//   height: 15em,
//   width: 15em,
//   title: [GM (GAP)],
//   lq.plot(years, gm_gap),
// )

// //////////////////////////////////////
// // Uniqlo
// //////////////////////////////////////

// #for (i, col) in uniqlo.enumerate() {
//   lq.diagram(
//     height: 15em,
//     width: 15em,
//     title: [#cols.at(i) (Uniqlo)],
//     lq.plot(years, col),
//   )
// }
// #let gp_uniqlo = uniqlo.at(0).zip(uniqlo.at(1)).map(sales_cogs => sales_cogs.at(0) - sales_cogs.at(1))
// #lq.diagram(
//   height: 15em,
//   width: 15em,
//   title: [GP (Uniqlo)],
//   lq.plot(years, gp_uniqlo),
// )
// #let gm_uniqlo = gp_uniqlo.zip(uniqlo.at(0)).map(gp_sales => gp_sales.at(0) / gp_sales.at(1))
// #lq.diagram(
//   height: 15em,
//   width: 15em,
//   title: [GM (Uniqlo)],
//   lq.plot(years, gm_uniqlo),
// )
