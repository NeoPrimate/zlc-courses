#set heading(numbering: "1.1.")
#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)
#import "@local/tystats:0.1.0": norm, expon, poisson, uniform

#let mu_A = 300
#let sigma_A = 90

#let mu_B = 200
#let sigma_B = 80

#let mu_C = 500
#let sigma_C = 120

#let K = 400
#let H = 0.5
#let L = 2
#let CSL = 0.95

#let z = norm.ppf(CSL)

#let EOQ(D) = calc.sqrt((2 * D * K) / H)

////////////////////////////////
// LOCATION POOLING
////////////////////////////////

// DECENTRALIZED

#let Q_A = EOQ(mu_A)
#let Q_B = EOQ(mu_B)
#let Q_C = EOQ(mu_C)

#let SS(sigma) = z * sigma * calc.sqrt(L)

#let SS_A = SS(sigma_A)
#let SS_B = SS(sigma_B)
#let SS_C = SS(sigma_C)

#let CycleStock_A = Q_A / 2
#let CycleStock_B = Q_B / 2
#let CycleStock_C = Q_C / 2

#let I_A = SS_A + CycleStock_A
#let I_B = SS_B + CycleStock_B
#let I_C = SS_C + CycleStock_C

#let holding_cost = H * (I_A + I_B + I_C)

#let ordering_cost_A = (K * mu_A / Q_A)
#let ordering_cost_B = (K * mu_B / Q_B)
#let ordering_cost_C = (K * mu_C / Q_C)
#let ordering_cost = ordering_cost_A + ordering_cost_B + ordering_cost_C

#let transport_cost_A = mu_A * (1 + 0.4) 
#let transport_cost_B = mu_B * (1 + 0.4) 
#let transport_cost_C = mu_C * (1 + 0.4) 
#let transport_cost = transport_cost_A + transport_cost_B + transport_cost_C

#let TC_dec = holding_cost + ordering_cost + transport_cost

// CENTRALIZED

#let sigma_P = calc.sqrt(calc.pow(sigma_A, 2) + calc.pow(sigma_B, 2) + calc.pow(sigma_C, 2))

#let SS_P = z * sigma_P * calc.sqrt(L)

#let D_P = mu_A + mu_B + mu_C

#let Q_P = calc.sqrt((2 * K * D_P) / H)

#let CycleStock_P = Q_P / 2

#let I_P = SS_P + CycleStock_P

#let holding_cost_P = I_P * H

#let ordering_cost_P = K * D_P / Q_P

#let transport_cost_P = 0.8 * D_P + 1.20 * mu_A + 0.40 * mu_B + 1.00 * mu_C

////////////////////////////////
// PRODUCT POOLING
////////////////////////////////

// Demand
#let mu_A = 1000
#let sigma_A = 400

#let mu_B = 1000
#let sigma_B = 400

#let rho = 0

#let p = 50
#let c = 20
#let v = 10

#let cu = p - c
#let co = c - v
#let CR = cu / (cu + co)
#let z = norm.ppf(CR)

#let Q_A = mu_A + z * sigma_A
#let Q_B = mu_B + z * sigma_B

#let Q = Q_A + Q_B

#let mu_P = mu_A + mu_B
#let sigma_P = calc.sqrt((calc.pow(sigma_A, 2) + calc.pow(sigma_A, 2)))

#let Q_P = mu_P + z * sigma_P

#let profit_np = (p - c) * (mu_A + mu_B) - (cu + co) * norm.pdf(z) * (sigma_A + sigma_B)
#let profit_p = (p - c) * (mu_P) - (cu + co) * norm.pdf(z) * sigma_P

////////////////////////////////
// EXP SMOOTH
////////////////////////////////

#let D1 = 120
#let D2 = 135
#let D3 = 128
#let D4 = 150
#let D5 = 142

#let a = 0.2
#let F1 = 120

#let F(Dt, Ft) = a * Dt + (1 - a) * Ft

#let F2 = a * D1 + (1 - a) * F1
#let F3 = a * D2 + (1 - a) * F2
#let F4 = a * D3 + (1 - a) * F3
#let F5 = a * D4 + (1 - a) * F4
#let F6 = a * D5 + (1 - a) * F5

#let e2 = F2 - D2
#let e3 = F3 - D3
#let e4 = F4 - D4
#let e5 = F5 - D5

#let MFE = 1 / 4 * (e2 + e3 + e4 + e5)
#let MAD = 1 / 4 * (calc.abs(e2) + calc.abs(e3) + calc.abs(e4) + calc.abs(e5))

#if calc.abs(MFE) <= 0.5 * MAD [
  No bias
] else [
  Bias
]

////////////////////////////////
// HOLTZ
////////////////////////////////

#let D1 = 120
#let D2 = 135
#let D3 = 128
#let D4 = 150

#let a = 0.5
#let b = 0.3

#let L1 = 118 
#let T1 = 6
#let F1 = 124

#let L2 = a * D1 + (1 - a) * F1
#let T2 = b * (L2 - L1) + (1 - b) * T1
#let F2 = L2 + T2

#let L3 = a * D2 + (1 - a) * F2
#let T3 = b * (L3 - L2) + (1 - b) * T2
#let F3 = L3 + T3

#let L4 = a * D3 + (1 - a) * F3
#let T4 = b * (L4 - L3) + (1 - b) * T3
#let F4 = L4 + T4

#let L5 = a * D4 + (1 - a) * F4
#let T5 = b * (L5 - L4) + (1 - b) * T4
#let F5 = L5 + T5

#let F6 = L5 + 2 * T5


Setup: quarterly demand, so $p = 4$. You're at the start of period 1, with these values from the static method:

$L_1 = 100$, $T_1 = 5$
$S_1 = 0.8$, $S_2 = 1.1$, $S_3 = 1.3$, $S_4 = 0.8$
$alpha = 0.2$, $beta = 0.1$, $gamma = 0.3$

Q1. What is $F_1$?

Q2. You observe $D_1 = 90$.

(a) Which $t$ are you at now, and which period is "$t-1$"?
(b) Compute $L_2$ and $T_2$.
(c) Which seasonal factor do you update, and under which index do you store it? Compute it.
(d) Compute $F_2$.

Q3. You observe $D_2 = 130$. Compute $L_3$, $T_3$, the new seasonal factor (name its index) and $F_3$.

Q4. Still at the start of period 3 (data through $D_2$):

(a) Forecast period 5. What is $h$, and which $S$ do you use?
(b) Forecast period 7. What is $h$, and which $S$ do you use? Careful: think about which seasonal estimates exist yet.

Q5. Your slide's boxed formula is $F_(t+k) = (L_t + k T_t) S_(t+k)$. With $t = 3$ and $k = 2$, which period does it actually forecast?

Traps to watch for:

The $S$ in the level update, and the $L$ in the seasonal update. The seasonal update uses the old level, not the one you just computed.
Where the updated $S$ gets stored.
Using an $S$ that hasn't been updated yet.

Send me your answers (even just the numbers) and I'll check them. If something is off, I'll show you which index went wrong rather than just giving the right number.


= Holt ($alpha$, $beta$)
#table(
  columns: 6,
  [$t$], [$D_t$], [$L_t$], [$T_t$], [$S_t$], [$F_t$],
  [1], [$D_1$], [$L_1$], [$T_1$], [$S_1$], [$F_1 = $],
  [2], [$D_2$], [$L_2 = $], [$T_2 = $], [$S_t = $], [$F_2 = $],
  [3], [$D_3$], [], [], [], [],
  [4], [], [], [], [], [],
)