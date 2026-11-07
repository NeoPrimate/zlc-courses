

#set text(font: "Helvetica", size: 8pt)

#show table: it => align(center, it)

#set math.mat(delim: "[")
#set math.vec(delim: "[")

#let mc(x) = text(fill: red, x)

= Sample MidTerm

== P1

*Sets*

- $L = {1, 2, 3}$: plants
- $P = {S, M, L}$: products


*Params*

- $pi_p = [300, 360, 420]$: profit of product $p$
- $k_l = [750, 900, 450]$: capacity of plant $l$
- $s_l = [13000, 12000, 5000]$: storage capacity plant $l$
- $f_p = [12, 15, 20]$: size of product $p$
- $d_p = [750, 1200, 900]$: demand for product $p$

- Plants should use the *same percentage of their excess capacity* to produce the new product

*Vars*

- $x_(p l)$: quantity of product $p$ to produce in plant $l$
- $y$: share of excess capacity used

*Model*

$
  max quad 
  &sum_(p in P) sum_(l in L) x_(p l) pi_p \
  "s.t." quad
  &sum_(p in P) x_(p l) <= k_l quad &&forall l in L quad &&"plant production capacity" \
  &sum_(p in P) x_(p l) f_p <= s_l quad &&forall l in L quad &&"plant storage capacity" \
  &sum_(l in L) x_(p l) <= d_p quad &&forall p in P quad &&"demand" \
  &(sum_(p in P) x_(p l)) / k_l = y &&forall l in L quad &&"equal share" \
  &x_(p l) >= 0 quad &&forall p in P, l in L \
  &y >= 0 \
$

== P2

*Sets*

- $P = {1, 2, 3, 4, 5}$: plants
- $W = {1, 2, 3}$: WHs
- $C = {1, 2, 3, 4}$: customers

*Params*

- $k_p$: capacity of plant $p$ (tons)
- $c^P_(p w)$: unit production + shipping cost from plant $p$ to WH $w$
- $c^W_(w c)$: unit shipping cost from WH $w$ to customer $c$
- $d_c$: annual demand of customer $c$ (tons)
- $f^P_p$: fixed annual cost of operating plant $p$
- $f^W_w$: fixed annual cost of operating WH $w$
- #mc[$M = sum_(c in C) d_c = 900$: max flow through a WH]

*Vars*

- $x^P_(p w) >= 0$: tons shipped from plant $p$ to WH $w$
- $x^W_(w c) >= 0$: tons shipped from WH $w$ to customer $c$
- $y^P_p in {0, 1}$: 1 if plant $p$ is open
- $y^W_w in {0, 1}$: 1 if WH $w$ is open
- #mc[$z_w in {0, 1}$: 1 if WH $w$ serves customer 3]

*Model*

$
  min quad
  &sum_(p in P) sum_(w in W) c^P_(p w) x^P_(p w) + && quad &&"production + inbound cost" \
  &sum_(w in W) sum_(c in C) c^W_(w c) x^W_(w c) + &&&&"outbound cost" \
  &sum_(p in P) f^P_p y^P_p + &&&&"plant fixed cost" \
  &sum_(w in W) f^W_w y^W_w &&&&"WH fixed cost" \
  "s.t." quad
  &sum_(w in W) x^P_(p w) <= k_p mc(y^P_p) quad &&forall p in P quad &&"capacity (if open)" \
  &sum_(p in P) x^P_(p w) = sum_(c in C) x^W_(w c) &&forall w in W &&"conservation" \
  &mc(sum_(c in C) x^W_(w c) <= M y^W_w &&forall w in W &&"ship only if WH open") \
  &sum_(w in W) x^W_(w c) >= d_c &&forall c in C &&"demand" \
  &sum_(p in P) y^P_p <= 4 &&&&"at most 4 plants" \
  &mc(x^W_(w 3) <= d_3 z_w &&forall w in W &&"cust. 3 only from chosen WH") \
  &mc(sum_(w in W) z_w = 1 &&&&"single sourcing (cust. 3)") \
  &x^P_(p w), x^W_(w c) >= 0, quad y^P_p, y^W_w, mc(z_w) in {0, 1}
$

== P3

*Sets*

- $P = {J, C, M}$
- $E = {F, P}$

*Params*

- $h_e = [40, 20]$: minimum hours worked for employee type $e$ (weekly)
- $s_e = [16, 12]$: hourly salary of employee type $e$ (\$ / hour)
- $k = 9000$: shipment of the material (sq. ft. / weekly)
- $r_p$: textile requirement for producing product $p$ (sq. ft. / unit)
- $f_p$: weekly fixed cost for producing product $p$ (\$)
- $d_p$: weekly demand for product $p$ (units / week)
- $l_p$: labor required to produce product $p$ (minutes / unit)
- $pi_p$: profit incurred for selling product $p$ (\$ / unit)

- the number of full-time employees can never drop below 25
- at least two full-time employees on the payroll for each part-time employee

*Vars*

- $x_(p e)$: quantity of product $p$ to produce
- $$: number of full time employees
- $$: number of part time employees

*Model*

$
  max quad 
  & \
  "s.t." quad
  & \
  & \
  & \
  & \
  & \
  & \
$






