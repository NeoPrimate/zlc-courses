

#set text(font: "Helvetica", size: 8pt)

#show table: it => align(center, it)

#set math.mat(delim: "[")
#set math.vec(delim: "[")

#let mc(x) = text(fill: red, x)

#outline()

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

- $J = {"Jumbo", "Collegiate", "Mini"}$: products
- $E = {F T, P T}$: employee types

*Params*

- $pi_j = [28, 32, 24]$: gross profit of product $j$ (\$ / unit)
- $d_j = [1600, 900, 1200]$: max weekly sales of $j$
- $f_j = [7600, 9200, 6800]$: weekly fixed cost if $j$ is produced
- $a^L_j = [0.5, 0.75, 35\/60]$: labour hours per unit of $j$
- $a^N_j = [4, 3, 2]$: nylon per unit of $j$ (ft²)
- $b^N = 9000$: nylon available per week (ft²)
- $c_e = [16, 12]$: hourly wage of type $e$ (\$ / h)
- $tau_e = [40, 20]$: weekly hours per employee of type $e$

*Vars*

- $x_j in ZZ_(>=0)$: units of $j$ produced per week
- $y_j in {0, 1}$: 1 if any $j$ is produced
- $n_e in ZZ_(>=0)$: employees of type $e$

*Model*

$
  max quad
  &sum_(j in J) pi_j x_j - && quad &&"gross profit" \
  &sum_(e in E) c_e tau_e n_e - &&&&"labour cost" \
  &sum_(j in J) f_j y_j &&&&"fixed cost" \
  "s.t." quad
  &sum_(j in J) a^N_j x_j <= b^N &&&&"nylon" \
  &sum_(j in J) a^L_j x_j <= sum_(e in E) tau_e n_e &&&&"labour hours" \
  &n_(F T) >= 25 &&&&"union minimum" \
  &n_(F T) >= 2 n^(P T) &&&&"union ratio" \
  &x_j <= d_j y_j quad &&forall j in J quad &&"demand + setup"
$

== P4

*Sets*

- $J$: products
- $G$: markets
- $L$: rows of investment table

*Params*

- $pi_j = [10, 8, 6]$: marginal profit for product $p$
- $f^E = 50$: fixed cost of entering market (\$)
- $b^E = 250$: max fixed fee (\$)
- $f_l$: investment cost of level $l$
- $k^0 = 500$: capacity (units)
- $k_l$: resulting total capacity
- $r = 500$: wants to send out at least 500 items in total
- $d_(alpha S) = 200$: Demand for Alpha in Spain is at most 200 units
- $r_P = 50$: at least 50 units of each product must be sent to Portugal
- $b = 1000$: max budget for extension (\$)
- $M = 840$
- total quantity of Alpha produced must be equally distributed between both countries

*Vars*

- $x_(j g)$: quantity of product $p$ sent to market $m$
- $y_(j g)$: product $j$ introduced in market $g$
- $y_l$: choose level $l$

*Model*

$
  max quad
  &sum_(j in J) sum_(g in G) pi_j x_(j g)
   - f^E sum_(j in J) sum_(g in G) y_(j g)
   - sum_(l in L) f_l y_l \
  "s.t." quad
  &f^E sum_(j in J) sum_(g in G) y_(j g) <= b^E \
  &x_(j g) <= M y_(j g) &&forall j in J, g in G \
  &sum_(j in J) sum_(g in G) x_(j g) >= r \
  &sum_(j in J) sum_(g in G) x_(j g) <= sum_(l in L) k_l y_l \
  &sum_(l in L) y_l = 1 \
  &x_(alpha S) <= d_(alpha S) \
  &x_(alpha S) = x_(alpha P) \
  &x_(j P) >= r_P &&forall j in J \
  &x_(j g) >= 0 &&forall j in J, g in G \
  &y_(j g) in {0, 1} &&forall j in J, g in G \
  &y_l in {0, 1} &&forall l in L
$

= Quiz 1

*Sets*

- $P = {1, 2, 3}$: plants ($p$)
- $F = {1, 2}$: fuel types ($f$)

*Params*

- $p = 121$: sale price of electricity (\$ / MWh)
- $k_f = [75, 90]$: available fuel of type $f$ (Mg)
- $l = 230$: person-hours for maintenance (h)
- $c_p = [0, 12, 29]$: CO2 emittend by plant $p$
- $g_p = [20, 32, 40]$: power produced by plant $p$
- $m_p = [20, 13, 18]$: maintenance required by plant $p$
- $r_(p f)$: fuel $f$ required by plant $p$
- $a = 200$: emition limit (Mg)
- $b = 55$: penalty
- $M = $


*Vars*

- $x_p$: days of operation of plant $p$
- $e$: CO2 above the emitions above the 200 Mg limit

*Constr*

- cannot emit more than 200Mg of CO2 in this period

*Model*

(a)

$
  max quad 
  &p sum_(p in P) x_p g_p  \
  "s.t." quad
  &sum_(p in P) x_p c_p <= a quad && quad &&"CO2" \
  & sum_(p in P) r_(p f) x_p <= k_f &&forall f in F &&"fuel" \
  &sum_(p in P) m_p x_p <= l && &&"maintenance"\
  &x_p >= 0 &&forall p in P \
$

(b)

$
  max quad 
  &p sum_(p in P) x_p g_p - b e  \
  "s.t." quad
  &sum_(p in P) x_p c_p - e <= a quad && quad &&"CO2" \
  & sum_(p in P) r_(p f) x_p <= k_f &&forall f in F &&"fuel" \
  &sum_(p in P) m_p x_p <= l && &&"maintenance"\
  &x_p >= 0 &&forall p in P \
  &e >= 0 \
$

= Quiz 2

*Sets*

- $J = {1, ..., 6}$ ($j$): sectors where a station can be built
- $T = J$ ($t$): sectors that must be protected

*Params*

- $tau_(j t)$: drive time from sector $j$ to sector $t$ (min; not symmetric)
- $overline(tau) = 12$: max allowed drive time (min)
- $P_j$: population of sector $j$
- $overline(P) = 50 000$: min population to build a station
- $c_j = 1$: cost of a station (equal in every sector)

*Vars*

- $y_j in {0, 1}$: 1 if a station is built in sector $j$
- $z_(j t) in {0, 1}$: 1 if the station in $j$ serves sector $t$

*Model*

$
  min quad
  &sum_(j in J) c_j y_j && quad &&"number of stations" \
  "s.t." quad
  &sum_(j in J) z_(j t) >= 1 quad &&forall t in T quad &&"every sector served" \
  &z_(j t) <= y_j &&forall j in J, t in T &&"only from a built station" \
  &tau_(j t) z_(j t) <= overline(tau) &&forall j in J, t in T &&"within 12 min (forces" z_(j t) = 0 "if" tau_(j t) > overline(tau)")" \
  &(P_j - overline(P)) y_j >= 0 &&forall j in J &&"population rule (forces" y_j = 0 "if" P_j < overline(P)")" \
  &y_j, z_(j t) in {0, 1} &&forall j in J, t in T
$

= LP Example

*Sets*

- $J (j)$: piece types (45, 37, 24 cm)
- $P (p)$: maximal cutting patterns: all $p$ with $sum_(j in J) ell_j a_(j p) <= k$
  to which no further piece can be added

*Params*

- $k = 100$: standard length (cm)
- $ell_j$: length of piece $j$ (cm)
- $d_j$: pieces of $j$ ordered (7, 13, 8)
- $a_(j p)$: pieces $j$ in pattern $p$
- $c_p = k - sum_(j in J) ell_j a_(j p)$: trim waste of pattern $p$ (cm)

*Vars*

- $n_p >= 0$: standard dowels cut with pattern $p$ (integer in practice)
- $e_j >= 0$: surplus pieces of type $j$ (cut but not ordered)

*Model*

Min number of dowels (part b):

$
  min quad
  &sum_(p in P) n_p && quad &&"standard dowels used" \
  "s.t." quad
  &sum_(p in P) a_(j p) n_p >= d_j quad &&forall j in J quad &&"demand"
$

Min total waste (part c):

$
  min quad
  &sum_(p in P) c_p n_p + sum_(j in J) ell_j e_j && quad &&"trim waste + overproduction" \
  "s.t." quad
  &sum_(p in P) a_(j p) n_p - e_j = d_j quad &&forall j in J quad &&"demand with surplus"
$

= IP Example

*Sets*

- $M = {alpha, beta, gamma}$: candidate countries
- $P = {M, W, C}$

*Params*

- $c_m = [10000, 13000, 8000]$: cost of entering candidate country $m$
- $pi_p = {5, 8, 6}$: average profit margin for clothes category $p$
- $k = 140000$: max number of items that can be manufactured and shipped

*Constrs*

- Can only start operations in 2 of the 3 countries
- Alpha: number of items from each dep must be equal
- Beta: 
  - Women's at most 60% of total
  - Children's & Men's same proportion
- Gamma: No dep more than 40% of total

*Vars*

- $x_(p m)$: number of items $p$ sent to country $m$
- $y_m$: 1 if candidate country $m$ is chosen, 0 otherwise

*Model*

$
  max quad 
  &sum_(p in p) sum_(m in M) pi_p x_(p m) - \
  &sum_(m in M) c_m y_m \
  "s.t." quad 
  &sum_(m in M) y_m <= 2 \
  &sum_(p in p) sum_(m in M) x_(p m) <= k \
  &sum_(p in P) x_(p m) <= M y_m quad &&forall m in M \
  & \
  &x_(M alpha) = x_(W alpha) \
  &x_(W alpha) = x_(C alpha) \
  & \
  &x_(W beta) - 0.6 sum_(p' in P) x_(p' beta) <= 0 quad&& forall p in P \
  &x_(beta C) = x_(beta M) \
  & \
  &x_(p gamma) - 0.4 sum_(p' in P) x_(p' gamma) <= 0 quad && forall p \
  & \
$

= Extra Problem Set 1

== 1

*Sets*

- $I = {C, P, O}$: crops ($i$)

*Params*

- $l = 500$: available land (hectares)
- $k^0 = 1000000$: base amount of water given by government ($m^3$ / year)
- $k^+ = 300000$: available water to purchase above $k^0$ ($m^3$)
- $c = 0.04$: price of water above $k^0$ (\$ / $m^3$)
- $pi_i = [200, 400, 300]$: revenue for crop $i$ (\$ / hecatare)
- $r_i = [3500, 6700, 2000]$: water requirement (m3 / hectare)

*Vars*

- $x_i$: quantity of crop $i$ to produce (hectares)
- $w$: quantity of additional water to purchase ($m^3$)

*Constrs*

- no single crop should occupy more than 50% of the total area planted
- no single crop should occupy less than 10% of the total area planted

*Model*

$
  max quad 
  &sum_(i in I) pi_i x_i - c w \
  "s.t." quad 
  & \
  &sum_(i in I) r_i x_i <= k^0 + w \
  &sum_(i in I) x_i <= l \
  &w <= k^+ \
  &x_j >= 0.1 sum_i x_i quad &&forall j in I \
  &x_j <= 0.5 sum_i x_i quad &&forall j in I  \
  &x_i >= 0 quad &&forall i in I \
  &w >= 0 \
$

== 2

*Sets*

- $R = {C, P, N}$: origin of coffee ($r$)
- $J = {R, P}$: coffee grade ($j$)

*Params*

- $c_r = [1.20, 1.00, 0.90]$: cost for coffee coming from $r$ (\$ / kg)
- $p_j = [1.30, 1.60]$: sale price of grade $j$ (\$ / kg)
- $d_j = [200000, 130000]$: demand for grade $j$ (kg)
- $q_(r j)^min$: min fraction of $r$ in $j$
- $q_(r j)^max$: max fraction of $r$ in $j$

*Constr*

- Regular
  - >= 10% colombian
  - >= 20% peruvian
- Premium
  - >= 50% colombian
  - <= 15% nigerian

*Vars*

- $x_(r j) >= 0$: amount of $r$ used in $j$

*Model*

$
  max quad 
  &sum_(j in J) p_j sum_(r in R) x_(r j) - sum_(r in R) c_r sum_(j in J) x_(r j) \
  "s.t." quad 
  &sum_(r in R) x_(r j) <= d_j quad &&forall j in J \

  &x_(C R) >= 0.10 sum_(r' in R) x_(r' R) quad && &&"regular colombian" \

  &x_(P R) >= 0.20 sum_(r' in R) x_(r' R) quad && &&"regular peruvian" \

  &x_(C P) >= 0.50 sum_(r' in R) x_(r' P) quad && &&"premium colombian" \

  &x_(N P) <= 0.15 sum_(r' in R) x_(r' P) quad && &&"premium nigerian" \

  &x_(r j) >= 0 \
  & \
  & \
$

== 4

1. What happens when the price of type 2 spindles increases by \$2 per spindle?

- allowable increase: 3.5, 2 <= 3.5
- 6 (4 + 2: new price) x 6 (number of Type 2 produced) = 36
- z increases by 2 x 6 = 12

2. Suppose the varnishing shop is available for production for 53.5 minutes (5 minutes less). What would you say about the optimal solution and profit?



3. Suppose the cutting machine can operate up to 162 cuts per hour now. What would you say about the optimal solution and the profit?



4. The demand for type 1 spindle has been going up while there has been less demand for type 2 spindle recently. In order to “manage demand”, Wood Products Limited has decided to change prices. They plan to increase the price of type 1 by \$0.4, and decrease the price of type also by \$0.4. How do you think this will impact the profit?


What changed? 
- A price (objective coefficient)
  - Look in the Variable Cells table
- A resource amount (right-hand side)
  - Look in the Constraints table
- Is the change inside the allowable range? 
  - If yes, the report tells you the effect
  - If not, re-solve