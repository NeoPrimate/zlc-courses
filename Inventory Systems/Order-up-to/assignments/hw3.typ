#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)
#import "@local/tystats:0.1.0": norm, poisson

#let r(num, digits: 2) = calc.round(num, digits: digits)
#let result(content) = box(stroke: blue, fill: blue.transparentize(75%), inset: 0.5em, radius: 0.25em)[#content]

= Problem 1 (Max Points 35)

Weekly demand for Vespa (Scooters) at a retail store in Zaragoza is normally distributed, with a mean of 15 and a standard deviation of 7. As this is the only Vespa retailer in Aragon, any unmet demand is backordered. The store manager follows a periodic review policy with an inventory review period of one week and targets for a customer service level (CSL or in-stock probability) of 90%. The manufacturer of Vespa currently takes three weeks to fill an order. The store operates 52 weeks per year.

#let week_per_year = 52
#let mu_D = 15 // units / week
#let sigma_D = 7 // units / week
#let T = 1 // week
#let L = 3 // weeks
#let service = 0.90 // %

- Demand : $D tilde N(#mu_D, #sigma_D)$
- Review period ($T$): #T
- Lead Time ($L$): #L
- Service Level: #service

(a) What should the store's order-up-to (OUT) level be? (5 points)

#let mu_DL1 = mu_D * (L + 1)
#let sigma_DL1 = sigma_D * calc.sqrt(L + 1)

#let z = norm.ppf(service)
#let S = mu_DL1 + z * sigma_DL1

$
  mu_(L+1) = mu dot (L+1) = #mu_DL1 \
  sigma_(L+1) = sigma dot sqrt(L+1) = #sigma_DL1 \
  z = Phi^(-1) (#service) = #r(z) \
  S = mu_(L+1) + z sigma_(L+1) = #result[#r(S)]
$

(b) What is the expected backorder? (5 points)

#let z = (S - mu_DL1) / sigma_DL1
#let loss = norm.pdf(z) - z * (1 - norm.cdf(z))
#let e_backorder = sigma_DL1 * loss

$
  z = (S - mu_(L+1)) / sigma_(L+1) = #r(z) \
  L(z) = phi(z) - z (1 - Phi(z)) = #r(loss) \
  E["Backorder"] = sigma_(L+1) L(z) = #result[#r(e_backorder)] \
$

(c) What is the expected on-order inventory? (Recall, your on-order inventory is also called pipeline inventory). (5 points)

#let e_onorder = L * mu_D

$
  E["OnOrder"] 
  &= L dot E["Demand"] \
  &= #L dot #mu_D \
  &= #result[#e_onorder]
$

(d) What is the expected on-hand inventory? (5 points)

#let e_onhand = S - mu_DL1 + e_backorder

$
  E["OnHand"] 
  &= S - E[D_(L+1)] + E["Backorder"] \
  &= #r(S) - #r(mu_DL1) + #r(e_backorder) \
  &= #result[#r(e_onhand)]
$

(e) What fill rate (FR) does the store achieve? (5 points)

#let fill_rate = 1 - e_backorder / mu_D

$
  "Fill Rate" 
  &= 1 - E["Backorder"] / mu \
  &= 1 - #r(e_backorder) / #mu_D \
  &= #result[#r(fill_rate, digits: 4)]
$

(f~g) The purchasing cost is €2,000 per vehicle, while the store manager has estimated that the penalty per unit backordered is €250 and the annual inventory carrying cost is around 25%.

#let c = 2000
#let b = 250
#let h = 0.25 

#let H = c * h / week_per_year

(f) If the manager wishes to minimize holding and backorder penalty costs, what should be her target in-stock probability (CSL)? (5 points)

#let cu = b
#let co = H

#let cr = cu / (cu + co)

$
  P(D_(L+1) lt.eq S) = c_u / (c_u + c_o) = b / (b + h) = #result[#r(cr, digits: 3)]
$

(g) What should its OUT level be in this case? (5 points)

#let z = norm.ppf(cr)
#let S = mu_DL1 + z * sigma_DL1

$
  mu_(L+1) = mu dot (L+1) = #mu_DL1 \
  sigma_(L+1) = sigma dot sqrt(L+1) = #sigma_DL1 \
  z = Phi^(-1) (#r(cr, digits: 3)) = #r(z) \
  S = mu_(L+1) + z sigma_(L+1) = #result[#r(S)]
$

= Problem 2 (Max Points 30)

You are the owner of an online book retail store named RosaPanter.com. Consider your inventory of a bestseller book called “The wisdom of crowds” by James Surowiecki. You order the book from an oversea printing office with a shipping lead time of four weeks and you order weekly. Average quarterly demand is normally distributed with a mean of 415 books and standard deviation of 154 books. The holding cost per book per week is \$0.75. You estimate that your backorder penalty cost is \$50 per book backordered. Assume there are 4.33 weeks per month. (Note: Consider one quarter having 13 weeks)

#let weeks_per_month = 4.33
#let weeks_per_quarter = 13

#let mu_D = 415 / weeks_per_quarter
#let sigma_D = 154 / calc.sqrt(weeks_per_quarter)
#let L = 4 // weeks
#let H = 0.75 // $ / unit
#let b = 50 // $ / unit

#let mu_DL1 = mu_D * (L+1)
#let sigma_DL1 = sigma_D * calc.sqrt(L + 1)

- Demand: $D tilde N(mu_D, sigma_D)$
- Lead Time ($L$): #L
- Holding Cost ($H$): #H
- Backorder Penalty ($b$): #b

(a) Suppose your order up-to (OUT) level is 400 books. After receiving your weekly delivery from your supplier at the beginning of a week you note that have 150 books on-hand and 120 books still on-order. How many books will you order this week? (5 points)

#let S = 400
#let on_hand = 150
#let on_order = 120
#let I_p = on_hand + on_order

$
  I_P 
  &= "OnHand" + "OnOrder" \
  &= #on_hand + #on_order \
  &= #I_p \

$

#let Q = S - I_p

$
  Q 
  &= S - I_p \
  &= #S - #I_p
  &= #result[#Q]
$


(b) Suppose your OUT level is 500 books. What is your expected on-order inventory in books? Round to the closest integer. (5 points)

#let S = 500

#let e_onorder = L * mu_D

$
  E["OnOrder"] 
  &= L dot E["Demand"] \
  &= #L dot #mu_D \
  &= #result[#r(e_onorder)]
$


(c) If you wish to minimize inventory holding costs while maintaining a 99.25% in-stock probability, then what should your OUT level be? (5 points)

#let p_instock = 0.9925
#let z = norm.ppf(p_instock)
#let S = mu_DL1 + z * sigma_DL1

$
  P(D_(L+1) lt.eq S) = #p_instock \
  F(z) = #p_instock \
  z = #r(z) \
  S = #result[#r(S)]
$

(d) If you wish to minimize inventory holding costs while maintaining a 99.25% fill rate, then what should your OUT level be? (5 points)

#let fill_rate = 0.9925
#let loss = ((1 - fill_rate) * mu_D) / sigma_DL1
#let z = (1 - fill_rate) * mu_D
#let z = 2.43
#let S = mu_DL1 + z * sigma_DL1

$
  1 - E["backorder"] / mu = #fill_rate \
  1 - E["backorder"] / #r(mu_D) = #fill_rate \
  E["backorder"] = (1 - #fill_rate) #r(mu_D) \
  L(z) = ((1 - #fill_rate) mu) / sigma_(L+1) \
$

$
  S 
  &= mu_(L+1) + z dot sigma_(L+1) \
  &= #r(mu_DL1) + z * #r(sigma_DL1) \
  &= #result[#r(S)]
$  

(e) If you wish to minimize holding and backorder penalty costs, then what should your OUT level be? (5 points)

#let cu = b
#let co = H

#let cr = cu / (cu + co)

$
  P(D_(L+1) lt.eq S) = c_u / (c_u + c_o) = b / (b + h) = #r(cr, digits: 3)
$

#let z = norm.ppf(cr)
#let S = mu_DL1 + z * sigma_DL1

$
  mu_(L+1) = mu dot (L+1) = #r(mu_DL1) \
  sigma_(L+1) = sigma dot sqrt(L+1) = #r(sigma_DL1) \
  z = Phi^(-1) (#r(cr, digits: 3)) = #r(z) \
  S = mu_(L+1) + z sigma_(L+1) = #result[#r(S)]
$

(f) Now consider your inventory of another book called “A Culture of Conspiracy: Apocalyptic Visions in Contemporary America” written by Michael Barkun, (a much less popular book). RosaPanter.com will order the book from a local printing office daily and the printing office delivers book with a lead time of 2 days. Average demand has a Poisson distribution with mean 1.0 book per day. The holding cost per book per day is \$0.05 and the backorder penalty cost is about \$5 per book short. What is your optimal OUT level? (5 points)


#let L = 2
#let lam_D = 1
#let H = 0.05
#let b = 5

#let lam_DL1 = lam_D * (L + 1)

#let cu = b
#let co = H
#let cr = cu / (cu + co)

$ 
  D_(L+1) tilde "Poisson"(#lam_DL1) 
$

$ 
  "CR" 
  &= b / (b + h) \
  &= #r(cr, digits: 4) 
$

#let S = poisson.ppf(cr, lam_DL1)

$ 
  S^* = #result[#r(S)]
$

= Problem 3 (Max Points 15)

In the order up-to model, assume that the mean of demand in a period remains the same and the order up-to level is kept at a constant level. If the demand uncertainty - i.e., the standard deviation of demand in each period - increases, then

+ The expected inventory at the end of each period would increase.
+ The expected inventory at the end of each period would decrease.
+ The expected inventory at the end of each period would remain unchanged.
+ The expected inventory at the end of each period may go up or down.

Please explain why. Please generalize your answer to any demand distribution (although you can assume normal distribution for gaining some insight).

$
  E["OnHand"] 
  &= S - E[D_(L+T)] + sigma_(L+T) L(z) \
  &= S - mu_(L+T) + sigma_(L+T) L(z) \
$

- Only the last term depends on $sigma$:
  - $sigma_(L+T)$
  - $z = (S - mu)/sigma$

- When $S > mu$ $z$ falls, which pushes $L(z)$ up
- When $S < mu$, $z$ rises, which pushes $L(z)$ down

So when $S < mu$ the two effects pull in opposite directions.
But the $sigma$ effect always dominates.

So, the expected inventory at the end of each period would increase.


= Problem 4 (Max Points 20)

Motorola obtains cell phones from its contract manufacturer located in China to serve the US market from a warehouse located in Memphis, Tennessee. Daily demand at the Memphis warehouse is normally distributed, with a mean of 5,000 and a standard deviation of 2,500. The warehouse aims for a CSL of 97%. The company is debating whether to use sea or air transportation from China. Sea transportation results in a lead time of 36 days and costs \$0.50 per phone. Air transportation results in a lead time of 4 days and costs \$1.50 per phone. Each phone costs \$100, and Motorola uses an annual holding cost of 20%. To begin with, assume that Motorola takes ownership of the inventory upon delivery. Given lot sizes by sea and air, Motorola would have to place an order every 20 days using sea transport but could order daily
using air transport.

#let mu_D = 5000
#let sigma_D = 2500

#let service = 0.97

#let L_sea = 36
#let f_sea = 0.50
#let T_sea = 20

#let L_air = 4
#let f_air = 1.50
#let T_air = 1

#let c = 100
#let h = 0.20

#let mu_DLT_air = mu_D * (L_air + T_air)
#let sigma_DLT_air = sigma_D * calc.sqrt(L_air + T_air)

#let mu_DLT_sea = mu_D * (L_sea + T_sea)
#let sigma_DLT_sea = sigma_D * calc.sqrt(L_sea + T_sea)

- $D tilde N(#mu_D, #sigma_D)$
- Service level: #service
- $L_"sea"$ = #L_sea
- $f_"sea"$: #f_sea
- $T_"sea"$: #T_sea
- $L_"air"$ = #L_air
- $f_"air"$: #f_air
- $T_"air"$: #T_air
- $h$: #h
- $c$: #c

$
  mu_(L+1)^"sea" = mu (L_"sea" + T_"sea") = #mu_DLT_sea \
  sigma_(L+1)^"sea" = sigma sqrt(L_"sea" + T_"sea") = #calc.round(sigma_DLT_sea, digits: 2) \
$
$
  mu_(L+1)^"air" = mu (L_"air" + T_"air") = #mu_DLT_air \
  sigma_(L+1)^"air" = sigma sqrt(L_"air" + T_"air") = #calc.round(sigma_DLT_air, digits: 2) \
$

(a) Assume that Motorola follows a periodic review policy. What order-up-to (OUT) level and safety inventory should the warehouse aim for when using sea or air transportation? How many days of safety stock will Motorola carry under each policy? You can assume that $E["backorder"] = 0$ in your calculation of safety stock. (8 points)

#let z = norm.ppf(service)

#let S_sea = mu_DLT_sea + z * sigma_DLT_sea
#let S_air = mu_DLT_air + z * sigma_DLT_air

#let SS_sea = S_sea - mu_DLT_sea
#let SS_air = S_air - mu_DLT_air

#let days_sea = SS_sea / mu_D
#let days_air = SS_air / mu_D

$
  z = Phi^(-1) (#service) \
$

$
  S_"sea" = mu_(L+1)^"sea" + z sigma_(L+1)^"sea" = #result[#calc.round(S_sea, digits: 2)] \
  S_"air" = mu_(L+1)^"air" + z sigma_(L+1)^"air" = #result[#calc.round(S_air, digits: 2)] \
$

Since $E["Backorders"] = 0$:

$
  E["OnHand"]= S - E[D_(L+1)] + cancel(E["Backorder"])
$

$
  "SS"_"sea" = S_"sea" - mu_(L+1)^"sea" = #result[#calc.round(SS_sea, digits: 2)] \
  "SS"_"air" = S_"air" - mu_(L+1)^"air" = #result[#calc.round(SS_air, digits: 2)] \
$

$
  "DaysSS" = "SS"_"sea" / mu = #result[#calc.round(days_sea, digits: 2)] \
  "DaysSS" = "SS"_"air" / mu = #result[#calc.round(days_air, digits: 2)] \
$

(b) How many days of cycle inventory does Motorola carry under each policy? (2 points)

#let Q_sea = T_sea * mu_D
#let Q_air = T_air * mu_D

#let days_cycle_inventory_sea = Q_sea / 2 / mu_D
#let days_cycle_inventory_air = Q_air / 2 / mu_D

$
  Q_"sea" &= T_"sea" mu_D = #calc.round(Q_sea, digits: 1) \
  Q_"air" &= T_"air" mu_D = #calc.round(Q_air, digits: 1) \
  \
  "Days"_"sea" &= (Q_"sea" \/ 2) / mu_D = T_"sea" / 2
    = #result[#calc.round(days_cycle_inventory_sea, digits: 1)] \
  "Days"_"air" &= (Q_"air" \/ 2) / mu_D = T_"air" / 2
    = #result[#calc.round(days_cycle_inventory_air, digits: 1)] \
$

(c) Under a periodic review policy, do you recommend sea or air transportation? Does your answer change if Motorola has ownership of the inventory while it is in transit? (10 points)

#let days_year = 365
#let D_annual = mu_D * days_year
#let H = h * c // holding cost per phone per year

// Average inventory at the warehouse = cycle inventory + safety stock
#let I_sea = Q_sea / 2 + SS_sea
#let I_air = Q_air / 2 + SS_air

#let hold_sea = H * I_sea
#let hold_air = H * I_air

#let trans_sea = f_sea * D_annual
#let trans_air = f_air * D_annual

#let TC_sea = hold_sea + trans_sea
#let TC_air = hold_air + trans_air

*Case 1: ownership upon delivery*

$
  D_"annual" = mu_D dot #days_year = #D_annual, quad H = h c = #H \
$

$
  macron(I)_"sea" &= Q_"sea" / 2 + "SS"_"sea" = #calc.round(I_sea, digits: 2) \
  macron(I)_"air" &= Q_"air" / 2 + "SS"_"air" = #calc.round(I_air, digits: 2) \
$

$
  "TC"_"sea" &= H macron(I)_"sea" + f_"sea" D_"annual"
    = #calc.round(hold_sea, digits: 0) + #calc.round(trans_sea, digits: 0)
    = #result[#calc.round(TC_sea, digits: 0)] \
  "TC"_"air" &= H macron(I)_"air" + f_"air" D_"annual"
    = #calc.round(hold_air, digits: 0) + #calc.round(trans_air, digits: 0)
    = #result[#calc.round(TC_air, digits: 0)] \
$

Sea is cheaper by #calc.round(TC_air - TC_sea, digits: 0) per year → *sea*. The extra \$1/phone for air (#calc.round(trans_air - trans_sea, digits: 0)/yr) outweighs the holding-cost savings (#calc.round(hold_sea - hold_air, digits: 0)/yr).

*Case 2: ownership while in transit*

Pipeline inventory $mu_D L$:

#let P_sea = mu_D * L_sea
#let P_air = mu_D * L_air

#let TC_sea_t = TC_sea + H * P_sea
#let TC_air_t = TC_air + H * P_air

$
  "Pipeline"_"sea" &= mu_D L_"sea" = #P_sea, quad H dot "Pipeline"_"sea" = #calc.round(H * P_sea, digits: 0) \
  "Pipeline"_"air" &= mu_D L_"air" = #P_air, quad H dot "Pipeline"_"air" = #calc.round(H * P_air, digits: 0) \
$

$
  "TC"'_"sea" &= #result[#calc.round(TC_sea_t, digits: 0)] \
  "TC"'_"air" &= #result[#calc.round(TC_air_t, digits: 0)] \
$

Air is cheaper by #calc.round(TC_sea_t - TC_air_t, digits: 0) per year → *air*. The 32-day longer sea lead time is 160,000 extra phones in transit, which costs more in holding costs than air's higher freight.

= Quiz Problem (Max Points 20)

ACold Inc. is a frozen food distributor with 10 warehouses across the country. Iven Tory, one of the warehouse managers, wants to make sure that the inventory policies used by the warehouse are minimizing inventory while still maintaining quick delivery to ACold's customers. Since the warehouse carries hundreds of different products, Iven decided to study one. He picked the “peperoni special” from Caruso's Frozen Pizza (CFP). Demand for peperoni special averages 400 per day with a standard deviation of 150. Iven places his orders daily and orders from CFP arrive four days later. Further, it costs ACold \$0.01 per day to keep a unit of pizza in inventory, while a back order is estimated to cost ACold \$0.45 per unit.

#let mu_D = 400 // day
#let sigma_D = 150 // day

#let L = 4 // days
#let T = 1 // day
#let H = 0.01 // day
#let b = 0.45 // unit

#let mu_DLT = mu_D * (L + T)
#let sigma_DLT = sigma_D * calc.sqrt(L + T)

#let cu = b
#let co = H * T

#let cr = cu / (cu + co)

#let z = norm.ppf(cr)

#let S = mu_DLT + z * sigma_DLT

(a) What base-stock level (i.e., order-up-to level) should Iven choose for CFPs if his goal is to minimize holding and backorder costs? (2 points)

$
  c_u = b = #r(cu) \
  c_o = H dot T = #r(co) \
  "cr" = c_u / (c_u + c_o) = #r(cr) \
  z = Phi^(-1) ("cr") = #r(z) \
  S = mu_(L + T) + z sigma_(L + T) = #result[#r(S)] \
$

(b) What base-stock level minimizes inventory while maintaining a 95% in-stock probability? (2 points)

#let service = 0.95
#let z = norm.ppf(service)
#let S = mu_DLT + z * sigma_DLT

$
  z = Phi^(-1)(#service) = #r(z) \
  S = mu_(L + T) + z sigma_(L + T) = #result[#r(S)] \
$

(c) Suppose the base-stock level 2,800 is chosen. What is the annual holding cost assuming 260 days per year? Here, use the exact formula for safety stock. (6 points)

#let days_per_year = 260
#let S = 2800

#let z = (S - mu_DLT) / sigma_DLT

#let loss = norm.pdf(z) - z * (1 - norm.cdf(z))
#let e_backorder = sigma_DLT * loss
#let ss = S - mu_DLT + e_backorder
#let avg_cycle_inv =  mu_D / 2
#let H_annual = H * days_per_year * (ss + avg_cycle_inv)

$
  S = #r(S) \
  E["Backorder"] = sigma_(L+T) L(z) = #r(e_backorder) \
  "SafetyStock" = S - mu_(L+T) + E["Backorder"] = #r(ss) \
  "Annual holding cost" = H dot #days_per_year dot "SS" = #result[#r(H_annual)]
$

(d) After implementing a new managerial accounting system, Iven has realized that there is a fixed cost of \$20 every time an order is placed with CFP. He wonders whether he can improve his overall costs by changing the frequency of placing orders with CFP (i.e., by changing the review period of CFP inventory), while targeting for an in-stock probability of 97%. He considers review periods of one, two, three, and four days as candidates. What would you recommend? How does your recommendation relate to the EOQ model's recommendation? (10 points)

#let fixed_cost = 20 // order
#let service = 0.97
#let z = norm.ppf(service)

#let Ts = (1, 2, 3, 4)

#let TC(T) = {
  let sigma_p = sigma_D * calc.sqrt(L + T)
  let ss      = z * sigma_p
  let cycle   = (mu_D * T) / 2
  let order   =  fixed_cost / T
  H * (ss + cycle) + order
}

#table(columns: 2, [T], [Daily cost],
  ..Ts.map(T => ([#T], [#r(TC(T))])).flatten())

$T = 3$ minimizes daily cost.
The two forces are: 
- Setup cost per day (decreases as $T$ increases)
- Holding cost (increases as $T$ increases)
  - Cycle stock $mu_D T \/ 2$
  - Safety stock $z sigma_D sqrt(L + T)$ (unaccounted for in EOQ, it only balances setup cost and cycle stock)

One cost falls with $T$ and the other two rise, so their sum has a minimum

#let Q = calc.sqrt((2 * fixed_cost * mu_D) / H)
#let T_eoq = Q / mu_D

$
  Q^* = sqrt((2 K mu_D) / H) = #r(Q) \
  T = Q / mu_D = #result[#r(T_eoq)]
$

$T_"eoq"$ is well above 3

Ignoring safety stock (a cost that grows with $T$) make EOQ recommend too long of a review period.


