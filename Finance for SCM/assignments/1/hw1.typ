#set heading(numbering: "1.a.")
#set text(font: "Helvetica", size: 8pt)
#show table: it => align(center, it)

#h(1fr) Vladimir Borel

= Problem 1. Inditex's financial report (Max Points 30) 

1. _Look at the balance sheet. Calculate the Net Operating Assets (NOA) for the last fiscal year (NOA = Accounts Receivable + Inventory - Accounts Payable). Consider as receivables (payables) only the “Trade and other Receivables (Payables)” in the firm's Balance Sheet._

Net Operating Assets (NOA): net amount of money tied up in the day-to-day trading cycle of buying stock, selling it and collecting payment.

#table(
  columns: 2,
  inset: 0.5em,
  align: (left, right),
  [Trade and other receivables], [1166],
  [Inventories], [3249],
  [Trade and other payables], [8269],
  [NOA], [#(1166 + 3249 - 8269)],
)

How much funding the operating cycle needs. 
- Positive value means the company has to finance it
- Negative value means suppliers are financing it

2. _Based on the firm's NOA figure, what can you infer about the company's financing needs to run its operations?_

The company doesn't need outside financing for its day-to-day operations. Its operating cycle funds itself.

Suppliers are paying for all of the inventory and customer credit (trade and other receivables), leaving about €3.9 billion of extra funding on top.

- No borrowing needed for working capital
- Growth pays for itself
- Long-term assets are financed from equity and retained cash flow
- Main risk: dependence on supplier terms

3. _Look at the income statement. Now express each line as a percentage of total net sales. What do you see?_


#table(
  columns: (auto, auto, auto, auto),
  align: (left, right, right, right),
  stroke: none,
  inset: (x: 6pt, y: 4pt),
  table.hline(),
  table.header(
    [*(% of net sales)*], [*2025*], [*2024*], [*Δ (pp)*],
  ),
  table.hline(stroke: 0.5pt),
  [Net sales],                          [100.0%],  [100.0%],  [—],
  [Cost of sales],                      [(41.7%)], [(42.2%)], [+#calc.round((-41.7) - (-42.2), digits: 4)],
  table.hline(stroke: 0.5pt),
  [*Gross profit*],                     [*58.3%*], [*57.8%*], [*+#calc.round(58.3 - 57.8, digits: 4)*],
  [Operating expenses],                 [(29.8%)], [(29.9%)], [+#calc.round((-29.8) - (-29.9), digits: 4)],
  [Other losses and income, net],       [(0.2%)],  [(0.2%)],  [#calc.round((-0.2) - (-0.2), digits: 4)],
  table.hline(stroke: 0.5pt),
  [*EBITDA*],                           [*28.3%*], [*27.8%*], [*+#calc.round(28.3 - 27.8, digits: 4)*],
  [Amortisation and depreciation],      [(8.2%)],  [(8.2%)],  [#calc.round((-8.2) - (-8.2), digits: 4)],
  table.hline(stroke: 0.5pt),
  [*EBIT*],                             [*20.1%*], [*19.6%*], [*+#calc.round(20.1 - 19.6, digits: 4)*],
  [Financial results],                  [(0.2%)],  [(0.2%)],  [#calc.round((-0.2) - (-0.2), digits: 4)],
  [Results of equity-method companies], [0.3%],    [0.3%],    [#calc.round(0.3 - 0.3, digits: 4)],
  table.hline(stroke: 0.5pt),
  [*Profit before taxes*],              [*20.1%*], [*19.6%*], [*+#calc.round(20.1 - 19.6, digits: 4)*],
  [Income tax],                         [(4.5%)],  [(4.4%)],  [#calc.round((-4.5) - (-4.4), digits: 4)],
  table.hline(stroke: 0.5pt),
  [*Net profit*],                       [*15.6%*], [*15.2%*], [*+#calc.round(15.6 - 15.2, digits: 4)*],
  [Attributable to non-controlling interests], [0.0%], [0.0%], [#calc.round(0.0 - 0.0, digits: 4)],
  table.hline(stroke: 0.5pt),
  [*Attributable to the parent*],       [*15.6%*], [*15.2%*], [*+#calc.round(15.6 - 15.2, digits: 4)*],
  table.hline(),
)

Everything to be steadily increasing. Gross margin is very high ($tilde 58%$); operating expenses are the largest cost ($tilde 30%$); financial results are tiny, which shows there's almost no debt; and the +0.4pp improvement in net margin comes entirely from gross margin.

#h(2.5em) a. _What is the amount of assets depreciated?_

#table(
  columns: 3,
  align: (left, right, right),
  inset: 0.5em,
  [], [*2025*], [*2024*],
  [Amortisation and depreciation (€M)], [3270], [3174],
  [% of net sales], [8.2%], [8.2%],
)
  
#h(2.5em) b. _How large is the net margin? How large is it compared to H&M's?_

$
  "Net margin" = "Net profit" / "Net sales"   
$

$
  "Net margin"_"Inditex" = 6220 / 39864 approx #calc.round(6220 / 39864, digits: 4)
$

$ 
  "Net margin"_"H&M" = 12085 / 228285 approx #calc.round(12085 / 228285, digits: 4)
$

Inditex's net margin (15.6%) is about 3 times H&M's (5.3%, Dec 2024 to Nov 2025).

4. _Look at the statement of cash flows. What can you infer about the sources and usages of cash in Inditex?_

#table(
  columns: 3,
  inset: 0.5em,
  align: (left, right, right),
  [],	[*2025*],	[*2024*],
  [CFO],	[9,232],	[9,288],
  [Capex (PP&E + intangibles)], [(2,712)], [(2,672)],
  [Lease payments], [(1,834)], [(1,802)],
  [*FCF after leases*],	[4,686], [4,814],
  [Dividends],	[(5,235)], [(4,797)],
  [Net placed in current financial investments],	[(545)],	[(705)],
  [Other investing, debt and small items],	[36],	[80],
  [Rounding in the reported statement],	[—], [1],
  [*Change in cash*], [(1,058)],	[(607)],
)

1. Operations are the only real source of cash
2. Working capital used cash this year
3. The uses of cash, as a share of CFO
  - Dividends: 56.7%
  - Capex: 29.4%
  - Leases: 19.9%
  - Financial investments: 5.9%
 
= Problem 2. Financial accounting rules (Max Points 10) 

#h(2.5em) a. _Who decides what “a material impact” is? How important is the reputation of the auditing firm for an outsider that reads the financial report?_

*Material impact*: error, omission or event important enough, that it could change the decisions of someone reading the financial statements (investor, lender, analyst)

1. Management
2. Auditor

The auditor's reputation matters a lot, because an outsider can't check the numbers personally. The audit opinion is what makes the report credible, and the auditor's reputation stands in for how good that audit was (Arthur Andersen with Enron).

#h(2.5em) b. _Why would it make sense to value inventory at the lower of cost or market? What is the underlying accounting principle that motivates this decision?_

Conservatism (prudence): expect no gains, but recognise probable losses. 
Inventory is recorded at cost when it's bought.

Valuing inventory at the lower of cost or market stops the balance sheet from showing inventory at more than the company can actually get for it. If goods lose value before they're sold, the loss is recognised straight away instead of being hidden until the sale.
 
= Problem 3. Inventory cost flow assumption I (Max Points 10) 

_Problem 11 in Chapter 8_

#table(
  columns: 5,
  inset: 0.5em,
  stroke: none,
  align: left,
  table.hline(),
  [], [], [*Units*], [*Unit Cost (\$)*], [*Total*],
  table.hline(),
  [Beginning inventory], [], [20], [40], [800],
  [\ Purchases], [], [], [], [],
  [], [\#1], [20], [50], [1000],
  [], [\#2], [10], [55], [550],
  [], [\#3], [70], [59], [4130],
  [], [\#4], [20], [64], [1280],
  table.hline(),
  [], [*Total*], [*140*], [], [*7760*],
  table.hline(),
)

Only 60 units were sold, and each method stops taking cost layers once it reaches 60.

1. *FIFO* (oldest units are sold first)

#table(
  columns: 3,
  [Layer], [Units], [Cost],
  [Beginning], [20 $times$ 40], [800],
  [\#1], [20 $times$ 50], [1000],
  [\#2], [10 $times$ 55], [550],
  [\#3], [10 $times$ 59], [590],
  [*COGS*], [60], [2940],
)

2. *LIFO* (newest units are sold first)

#table(
  columns: 3,
  [Layer], [Units], [Cost],
  [\#4], [20 $times$ 64], [1280],
  [\#3], [40 $times$ 59], [2360],
  [*COGS*], [60], [3640],
)

3. *Weighted average*

- $"Average cost" = 7760 div 140 = #calc.round(7760 / 140, digits: 2)$
- $"COGS" = 60 times 55.43 = #calc.round(60 * 55.43, digits: 2)$
 
= Problem 4.  Inventory cost flow assumption II (Max Points 20)  

_Problem 13 in Chapter 8_

#figure(
  table(
    columns: 4,
    align: left,
    stroke: none,
    table.hline(),
    [], [], [*2018*], [*2017*],
    table.hline(),
    [*Assets*], [], [], [],
    [], [Cash], [52], [40],
    [], [A/R], [156], [143],
    [], [Inventories], [302], [285],
    [], [Fixed assets], [290], [282],
    [], [*TOTAL*], [800], [750],
    table.hline(),
    [*Equities*], [], [], [],
    [], [A/P], [85], [92],
    [], [Debt], [190], [222],
    [], [Equity], [525], [436],
    [], [*TOTAL*], [800], [750],
    table.hline(),
  ),
  caption: [Balance Sheet]
)

#figure(
  table(
    columns: 3,
    inset: 0.5em,
    align: left,
    stroke: none,
    table.hline(),
    [], [2018], [2017],
    table.hline(),
    [Revenue], [1100], [1000],
    [COGS], [600], [550],
    [Gross Profit], [500], [450],
    [SGA], [210], [200],
    [Depreciation], [85], [80],
    [Interest], [24], [22],
    [EBT], [181], [148],
    [Taxes], [72], [59],
    [NP], [109], [89],
    table.hline(),
  ),
  caption: [Income Statement]
)

a. _What would gross profit have been in 2018 had the firm used the FIFO assumption? Show your work._

The LIFO reserve (the FIFO - LIFO difference in inventory) was 80 in 2018 and 60 in 2017,
so it increased by $80 - 60 = 20$ during 2018.

Using the inventory identity $"COGS" = "Beginning inv." + "Purchases" - "Ending inv."$,
purchases are the same under both methods, so:

$ "COGS"_"FIFO" = "COGS"_"LIFO" - Delta "Reserve" = 600 - 20 = 580 $

$ "Gross profit"_"FIFO" = 1100 - 580 = 520 $

#table(
  columns: 3,
  stroke: none,
  inset: 0.5em,
  align: (left, right, right),
  table.hline(),
  table.header([], [*LIFO*], [*FIFO*]),
  table.hline(),
  [Revenue], [1100], [1100],
  [COGS], [600], [580],
  table.hline(),
  [*Gross profit*], [*500*], [*520*],
  table.hline(),
)

Gross profit would have been *520*, i.e. 20 higher than under LIFO. Prices were
rising, so the costs LIFO charges to COGS are higher than under FIFO.

b. _How many taxes did the firm save in 2018 because of the LIFO assumption?_

Under LIFO, COGS is higher by the increase in the LIFO reserve, so pre-tax income
is lower by the same amount:

$ Delta "EBT" = Delta "Reserve" = 80 - 60 = 20 $

The effective tax rate in 2018 is

$ t = "Taxes" / "EBT" = 72 / 181 approx 39.8% approx 40% $

Tax savings from LIFO:

$ "Tax savings" = Delta "Reserve" times t = 20 times 0.40 approx 8 $

The firm saved about *8* in taxes in 2018. Net profit is lower by
$20 times (1 - 0.40) = 12$, while cash flow is higher by 8.

c. _Under which method (FIFO or LIFO) is it easier to manipulate net profit? Why? What is/are the levers managers have in order to do so?_

Net profit is easier to manipulate with *LIFO*. Under LIFO, COGS is based on the most recent purchases, so decisions made at year-end directly change the cost of goods sold. Under FIFO, COGS is based on the oldest units, which were bought earlier and are already fixed; year-end purchases only change ending inventory, not COGS

*Levers under LIFO:*

+ *Timing of year-end purchases.* Buying more at high prices just before year-end
  raises COGS, which lowers profit and taxes. Delaying or cutting purchases does the
  opposite
+ *LIFO liquidation.* If inventory is allowed to fall below its opening level,
  old, low-cost layers are charged to COGS. This lowers COGS and raises profit
  without any real operating improvement
 
= Problem 5. Inventory valuation in manufacturing (Max Points 30) 

_Problem 14 (only part a) in Chapter 8_

*1. Raw materials*

#table(
  columns: 4,
  stroke: none,
  inset: 0.5em,
  align: (left, right, right, right),
  table.hline(),
  table.header([], [*Units*], [*Unit cost*], [*Total*]),
  table.hline(),
  [Beginning], [30], [20], [600],
  [Purchase 1], [50], [22], [1100],
  [Purchase 2], [40], [25], [1000],
  table.hline(stroke: 0.5pt),
  [*Available*], [*120*], [], [*2700*],
  [Used (30 × 20 + 50 × 22)], [(80)], [], [(1700)],
  table.hline(stroke: 0.5pt),
  [*Ending RM*], [*40*], [25], [*1000*],
  table.hline(),
)

*2. Assembly and finishing*

80 units of RM → 40 assembled items (2 RM each). By FIFO the first 15 items
use the \$20 RM (RM cost \$40 per item), and the next 25 use the \$22 RM
(RM cost \$44 per item).

- Assembly labour: $40 times 10 = 400$
- Finishing labour: $30 times 5 = 150$
- Overhead: $(30 + 10 times 0.5) times 2 = 70$, i.e. \$2 per FG and \$1 per WIP item

#table(
  columns: 7,
  stroke: none,
  inset: 0.5em,
  align: (left, right, right, right, right, right, right),
  table.hline(),
  table.header([*Batch*], [*Units*], [*RM*], [*Assembly*], [*Finishing*], [*OH*], [*Total*]),
  table.hline(),
  [FG batch A], [15], [40], [10], [5], [2], [57 × 15 = 855],
  [FG batch B], [15], [44], [10], [5], [2], [61 × 15 = 915],
  [WIP], [10], [44], [10], [—], [1], [55 × 10 = 550],
  table.hline(),
)

- Cost of goods manufactured (transferred to FG): $855 + 915 = 1770$
- *Ending WIP* $= 550$

*3. Finished goods, COGS and gross profit*

$ "COGS" = 15 times 57 + 10 times 61 = 855 + 610 = 1465 $
$ "Ending FG" = 5 times 61 = 305 $
$ "Sales" = 25 times 120 = 3000 $
$ "Gross profit" = 3000 - 1465 = 1535 $

#table(
  columns: 2,
  stroke: none,
  inset: 0.5em,
  align: (left, right),
  table.hline(),
  table.header([*FIFO*], [*\$*]),
  table.hline(),
  [RM inventory], [1000],
  [WIP inventory], [550],
  [FG inventory], [305],
  [COGS], [1465],
  [*Gross profit*], [*1535*],
  table.hline(),
)

*Check:* $600 + 2100 + 550 + 70 = 3320 = 1000 + 550 + 305 + 1465$
