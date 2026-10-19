#import "/lib/imports.typ": *
#import "/lib/formatting.typ": *
#import "@local/tystats:0.1.0": norm, poisson, expon

#import "@preview/tiptoe:0.4.0"
#import "@preview/komet:0.2.0"

#show: formatting

= Finance of Supply Chain Management

Everything is *stocks* and *flows*

== Accounting Rules

+ Financial (transactions -> accounts)
  - Provides information primarily to people *outside* the company
    - Equity & Debt
    - Credit from suppliers
    - Customers
    - Employees
+ Managerial 
  - Provides information primarily to people *inside* the company
    - internal investment decisions
    - performance monitoring & evaluation

== Concepts of Financial Accounting

- Conservatism: 
- Materiality: 
- Consistency: 
- Economic Entity: 
- Going Concern: 
- Accounting Period: 
- Cost Concept: 

== Principles of Accrual Accounting

Attempt to measure firm performance *regarless of when cash is exchanged*
- Revenue Recognition
  - Earnings process complete
  - Cash collection assured
- Mathcing Principles
  - Match effort to the benefits generted
  - Capitalize expenditure that will benefit future periods, expense as benefit are realized 
  - Recognize liability when efforts benefiting the period require cash payment in the future

== Financial Statements

// + BS: Balance Sheet
  
//   Inventory -> Account Receivables -> Cash

//   - Current assets: Cash, Account Receivables, Inventory
//   - Current liabilities: Account payables, debt

//   Equity (residual sharholders) calculated from Assets - Liabilities

//   Equity last to be payed (first banks, then Account payables, then employees)

//   Non-current assets:
//   - Investments
//   - Goodwill
//   - Fixed assets
//     - Useful service life
//     - Salvage value
//     - Depreciation method (production (use) method, straight line, accelerated)

//   OWC = Min Cash + Account Receivable + Inventory - Account Payable

// + Income Statement (P&L: Profit & Loss)
//   Revenue (-) Expenses = Net Income

//   Sales - COGS = GP - SGA = EBITDA - D&A = EBIT - Interest = EBT - Tax = NP

//   Inventory is not included so CF is used to reconsile BS and P&L

// + CF: Cash Flow
//   Operating, Investing & Financial Activities

#let in-color = green
#let out-color = red

=== Balance Sheet (BS)

$
  underbrace("Assets", "own") = underbrace("Liabilities", "owe") + underbrace("Equity", "shareholders")
$

$
  "Equity" = "Assets" - "Liabilities"
$

#table(
  columns: 2,
  inset: 1em,
  align: center + horizon,
  table.cell(
    [Assets],
    fill: black.transparentize(75%),
  ),
  table.cell(
    [Liabilities],
    fill: black.transparentize(75%),
  ),
  [Cash], [Account\ Payables],
  [Account\ Receivables], [Debt],
  [Inventory], [Equity],
  [PP&E], [],
)

- *Cash*: Money immediately available to spend. 
  
  \$50,000 sitting in the company's checking account.

- *Accounts Receivable*: Money owed by customers for sales already made on credit. 
  
  You deliver \$10,000 of consulting work in March, invoice the client with 30-day terms — that \$10,000 is receivable until they pay.

- *Inventory*: Goods held for sale but not yet sold. 

  A shoe retailer has \$200,000 of unsold shoes sitting in its warehouse.

- *PP&E*: Long-lived physical assets used to run the business. 

  A factory building and its production machinery, carried at \$2M after depreciation.

- *Accounts Payable*: Money owed to suppliers for goods/services already received but not yet paid for. 

  You receive \$5,000 of raw materials from a supplier on 60-day payment terms — that \$5,000 is payable until you pay it.

- *Debt*: Borrowed money owed to lenders, usually with interest. 

  A \$1M bank loan taken out to fund expansion.

- *Equity*: Owners' residual stake — assets minus liabilities. 

  Founders put in \$100,000 and the company has since kept \$400,000 of profit rather than paying it out — equity is \$500,000. 
 
#let asset-color = green
#let liab-color = red
#let equity-color = blue

#sankey-diagram(
  (
    ("Cash", "Assets", 20),
    ("Receivables", "Assets", 30),
    ("Inventory", "Assets", 40),
    ("PP&E", "Assets", 110),

    ("Assets", "Liabilities", 200),

    ("Liabilities", "Payables", 25),
    ("Liabilities", "Debt", 75),
    ("Liabilities", "Equity", 100),
  ),
  layout: layout.auto-linear(
    node-gap: 1.5,
    layer-gap: 3,
    node-width: 0.9,
    min-node-height: 0.6,
  ),
  categories: (
    "Asset":     ("Cash", "Receivables", "Inventory", "PP&E", "Assets"),
    "Liability": ("Liabilities", "Payables", "Debt"),
    "Equity":    ("Equity",),
  ),
  tinter: tinter.dict-tinter((
    "Cash": asset-color, "Receivables": asset-color, "Inventory": asset-color,
    "PP&E": asset-color, "Assets": asset-color,
    "Liabilities": liab-color, "Payables": liab-color, "Debt": liab-color,
    "Equity": equity-color,
  )),
  ribbon-stylizer: ribbon-stylizer.match-to(),
  draw-label: label.default-linear-label-drawer(formatter: (val) => ""),
)

==== Operating Working Capital (OWC)

$
  colorMath("OWC", #orange) = colorMath("Min Cash", #green) + colorMath("Account Receivable", #green) + colorMath("Inventory", #green) - colorMath("Account Payable", #red)
$

#linebreak()
#linebreak()
#linebreak()

#table(
  columns: 5,
  inset: 1em,
  align: center + horizon,
  table.cell(
    [Assets],
    fill: black.transparentize(75%),
  ),
  table.cell(
    [Liabilities],
    fill: black.transparentize(75%),
  ),
  
  table.cell(
    rowspan: 5, 
    stroke: none,
    [$arrow$]
  ),

  table.cell(
    [Assets],
    fill: black.transparentize(75%),
  ),
  table.cell(
    [Liabilities],
    fill: black.transparentize(75%),
  ),

  table.cell(
    [Cash],
    fill: green.transparentize(75%),
  ),
  
  table.cell(
    [Account\ Payables],
    fill: red.transparentize(75%),
  ), 

  table.cell(
    [OWC],
    rowspan: 2,
    fill: orange.transparentize(75%),
  ), 
  
  table.cell(
    [Debt],
    rowspan: 2,
  ), 

  table.cell(
    [Account\ Receivables],
    fill: green.transparentize(75%),
  ), 
  [Debt],
  
  table.cell(
    [Inventory],
    fill: green.transparentize(75%),
  ), 
  table.cell(
    [Equity],
    rowspan: 2,
  ), 

  table.cell(
    [PP&E],
    rowspan: 2,
  ), 
  
  table.cell(
    [Equity],
    rowspan: 2,
  ), 
  [PP&E]
)



=== Income Statement (P&L)

#let top-flush-linear(
  layer-gap: 2,
  node-gap: 1,
  node-width: 0.25,
  base-node-height: 3,
  min-node-height: 0.1,
  vertical: false,
  layers: (:),
  radius: 2pt,
  curve-factor: 0.3,
) = {
  let layer-override = layers
  (
    layouter: (nodes) => {
      let layers = data-processing.assign-layers(nodes, layer-override: layer-override)
      for (layer-index, layer) in layers.enumerate() {
        for node-id in layer { nodes.at(node-id).insert("layer", layer-index) }
      }
      for (node-id, properties) in nodes {
        nodes.at(node-id).insert("size", calc.max(properties.in-size, properties.out-size))
      }
      for (node-id, properties) in nodes {
        nodes.at(node-id).insert("width", node-width)
      }
      let max-node-size = 0
      for (node-id, properties) in nodes { max-node-size = calc.max(max-node-size, properties.size) }
      for (node-id, properties) in nodes {
        let h = calc.max(properties.size / max-node-size * base-node-height, min-node-height)
        nodes.at(node-id).insert("height", h)
      }
      for (node-id, properties) in nodes {
        let x = properties.layer * (node-width + layer-gap) + node-width / 2
        nodes.at(node-id).insert("x", x)
      }
      for layer in layers {
        let offset = 0.0
        for node-id in layer {
          let h = nodes.at(node-id).height
          nodes.at(node-id).insert("y", offset - h / 2)
          offset -= h + node-gap
        }
      }
      let min-y = 99999999
      for (node-id, properties) in nodes {
        min-y = calc.min(min-y, properties.y - properties.height / 2)
      }
      for (node-id, properties) in nodes {
        nodes.at(node-id).insert("y", properties.y - min-y)
      }
      nodes
    },
    drawer: layout.auto-linear(vertical: vertical, radius: radius, curve-factor: curve-factor).drawer,
  )
}

#sankey-diagram(
  (
    ("Sales", "GP", 75),
    ("Sales", "COGS", 25),

    ("GP", "EBITDA", 55),
    ("GP", "SGA", 20),

    ("EBITDA", "EBIT", 45),
    ("EBITDA", "D&A", 10),

    ("EBIT", "EBT", 40),
    ("EBIT", "Interest", 5),

    ("EBT", "NP", 30),
    ("EBT", "Tax", 10),
  ),
  layout: top-flush-linear(
    node-gap: 1.0,
    node-width: 0.9,       // was 0.25 — much thicker bar
    min-node-height: 0.6,  // floor so Interest/D&A are tall enough for a label
  ),
  categories: (
    "In": ("Sales", "GP", "EBITDA", "EBIT", "EBT", "NP"),
    "Out": ("COGS", "SGA", "D&A", "Interest", "Tax")
  ),
  tinter: tinter.dict-tinter(
    (
    "Sales": in-color,
    "GP": in-color,
    "EBITDA": in-color,
    "EBIT": in-color,
    "EBT": in-color,
    "NP": in-color,
    
    "COGS": out-color,
    "SGA": out-color,
    "D&A": out-color,
    "Interest": out-color,
    "Tax": out-color,
    )
  ),
  ribbon-stylizer: ribbon-stylizer.match-to(),
  draw-label: label.default-linear-label-drawer(formatter: (val) => ""),
)

- *Sales*: Revenue — total money brought in from selling goods or services, before any costs are subtracted. Also called "revenue" or the "top line."
- *GP* (Gross Profit): Sales − COGS. What's left after covering the direct cost of producing or delivering what was sold.
- *EBITDA* (Earnings Before Interest, Taxes, Depreciation & Amortization): GP − SGA in this chain. A rough proxy for core operating profitability, stripped of financing costs, taxes, and non-cash charges — often used to compare operating performance across companies with different debt loads or asset ages.
- *EBIT* (Earnings Before Interest & Taxes): EBITDA − D&A. Also called "Operating Income" — profit from core operations after accounting for the wear-down of assets, but still before financing costs and taxes.
- *EBT* (Earnings Before Tax): EBIT − Interest. Pre-tax profit, after the cost of servicing debt.
- *NP* (Net Profit / Net Income): EBT − Tax. The bottom line — what's actually left over for shareholders or retained earnings.
- *COGS* (Cost of Goods Sold): The direct costs of producing or acquiring what was sold — materials, direct labor, manufacturing costs. Excludes overhead, marketing, and admin.
- *SGA* (Selling, General & Administrative): Indirect operating costs to run the business that aren't tied directly to production — sales and marketing, administrative salaries, rent, overhead.
- *D&A* (Depreciation & Amortization): A non-cash expense that spreads the cost of long-lived assets over their useful life — depreciation for tangible assets like PP&E, amortization for intangibles like patents or acquired goodwill.
- *Interest*: Interest expense — the cost of servicing debt, i.e. interest paid on loans and bonds.
- *Tax*: Income tax expense — taxes owed on EBT.

=== Cash Flow (CF)

#sankey-diagram(
  (
    ("Beginning Cash", "Cash Flow", 50),
    ("Operating Activities", "Cash Flow", 70),

    ("Cash Flow", "Ending Cash", 60),
    ("Cash Flow", "Investing Activities", 40),
    ("Cash Flow", "Financing Activities", 20),
  ),
  layout: layout.auto-linear(
    node-gap: 1.5,
    layer-gap: 5,
    node-width: 0.9,
    min-node-height: 0.6,
  ),
  categories: (
    "Kept":  ("Beginning Cash", "Operating Activities", "Ending Cash"),
    "Spent": ("Investing Activities", "Financing Activities"),
  ),
  tinter: tinter.dict-tinter((
    "Beginning Cash": in-color, "Operating Activities": in-color, "Ending Cash": in-color,
    "Investing Activities": out-color, "Financing Activities": out-color, "Cash Flow": in-color
  )),
  ribbon-stylizer: ribbon-stylizer.match-to(),
  draw-label: label.default-linear-label-drawer(formatter: (val) => ""),
)

#example([Ethan's New Firm])[
  On January 1, 2023, Ethan Buell and his friend Ryan started a business to import product X from Germany and sell it in the United States. Product X had been launched successfully in Germany the previous year, and Ethan and Ryan believed it offered a sound business opportunity.
  
  Facts from January 1 to June 30, 2023
  1. On January 1, Ethan and Ryan each deposited \$10,000 in a bank account to start the business.
  2. Also on January 1, the firm borrowed \$20,000 from a local bank at 10% interest per year. The loan is expected to be repaid in installments: 50% on June 30 and 50% at the end of the year.
  3. On the same day, they rented a store for the six-month accounting period and paid the full rent of \$12,000 in advance.
  4. The firm bought equipment needed to operate the store for \$9,000 cash. Ethan and Ryan estimate that the equipment will last three years and will have no residual value.
  5. The first batch of product X cost \$36,000. The firm paid \$15,000 cash and agreed to pay the remainder to the supplier later.
  6. Some defective units from the first batch, costing \$6,000, were returned to the supplier, who agreed to take them back.
  7. On January 1, the firm hired a store assistant. Her salary is \$1,800 per month.
  8. The store opened on January 3.
  9. On April 15, a second batch of product X was purchased for \$48,000 on account.
  10. Sales during the six-month period totaled \$80,000. Customers paid 70% in cash. The cost of the units sold was \$36,000.
  11. The firm paid \$18,000 to the supplier, reducing the balance owed for the first batch.
  12. The firm collected \$8,000 from customers who had initially bought on credit. The remaining customer balance is expected to be collected after June 30.
  13. Utilities for the six-month period totaled \$2,400 and were paid in cash.
  14. During the six-month period, the store assistant was paid \$9,800 cash. The remaining amount will be paid shortly after June 30.
  15. No interest was paid to the bank during the accounting period.
  16. On June 30, the firm recognized the full six months of rent expense and six months of depreciation on the equipment.
  17. On June 30, the firm repaid half of the bank loan principal.
  18. On June 30, Ethan received a call from an important retailer that was interested in buying a large amount of product X regularly.

  #let cash = t-account(
    [Cash],
    [(1) 20], [12 (3)],
    [(2) 20], [9 (4)],
    [(10) 56], [15 (5)],
    [(12) 8], [18 (11)],
    [], [2.4 (13)],
    [], [9.8 (14)],
    [], [10 (17)],
  )
  
  #let prepaid = t-account(
    [Prepaid],
    [(3) 12], [12 (16)],
    [], [],
  )
  
  #let fixed-assets = t-account(
    [Fixed Assets],
    [(4) 9], [1.5 (16)],
    [], [],
  )
  
  #let inventory = t-account(
    [Inventory],
    [(5) 36], [6 (6)],
    [(9) 48], [36 (10)],
    [], [],
    [], [],
  )
  
  #let equity = t-account(
    [Equity],
    [], [20 (1)],
    [], [],
  )
  
  #let bank-debt = t-account(
    [Bank Debt],
    [(17) 10], [20 (2)],
    [], [],
  )
  
  #let ap = t-account(
    [A/P],
    [(6) 6], [21 (5)],
    [(11) 18], [48 (9)],
    [], [],
    [], [],
  )
  
  #let ar = t-account(
    [A/R],
    [(10) 24], [8 (12)],
  )
  
  #let salaries = t-account(
    [Salaries (Accrued not payed)],
    [], [1 (14)],
  )
  
  #let interest = t-account(
    [Interest (Accrued not payed)],
    [], [1 (15)],
  )

  #let expenses = expenses(
    [(10) CoGS], [36],
    [(13) SGA (utilities)], [2.4],
    [(14) SGA (salaries)], [10.8],
    [(15) Interest], [1],
    [(16) Rent], [12],
    [(16) Depreciation], [1.5],
  )

  #let revenue = revenue(
    [(10)], [80],
    [], [],
  )

  #balance-sheet(
    assets: (
      cash,
      prepaid,
      ar,
      fixed-assets,
      inventory
    ),
    liabilities: (
      equity,
      bank-debt,
      ap,
      salaries,
      interest,
    ),
    expenses,
    revenue,
  )

  #balance-sheet-summary(
    cash: 27.8,
    ar: 16,
    inventory: 42,
    ppe: 7.5,
    ap: 47,
    debt: 10,
    equity: 36.3,
  )

  #income-statement(
    revenue: 80,
    cogs: 36,
    sga: 25.2,
    da: 1.5,
    interest: 1,
    tax: 0,
  )

  #statement-cash-flow(
    
  )
]

#pagebreak()

#example([Vending Machines])[

  During his stay in Switzerland in 2012, when he was about to finish his MBA, Sanjay Menon had an idea in mind to start a new business back home in India. In several European airports, he had seen some vending machines selling electronics (like iPods) rather than soft drinks or other inexpensive products. He thought that importing and selling those new-generation vending machines in India could be a good idea, especially when some of his relatives were already involved in the industry of vending services. However, Sanjay did not have much money, so he showed his business plan to his rich uncle Anoop Patnaik, so as to get him involved in the new firm as the main shareholder. 
  - Anoop accepted to invest in the business, so they both went ahead and made a bank deposit of \$120,000 (Sanjay invested \$20,000, his uncle \$100,000) as equity for the new firm. 
  - Additionally, at the end of the year, they borrowed some money from a bank (\$40,000, 10% p.a.) to avoid potential cash tensions. 
  - On December 30, they bought a small warehouse to store the machines, whose price was \$100,000 (\$40,000 the land, \$60,000 the building). Sanjay paid \$80,000 cash; the remaining amount was agreed to be paid on Dec 30 the following year. Both shareholders estimated the life of the warehouse to be 20 additional years. 
  - The same day, Anoop bought some necessary furniture to run the business, paying \$4,000 cash. That furniture was supposed to last five years. 
  
  The last day of the year, Sanjay and Anoop met to assess the situation of the firm. No machines had been sold yet. Sanjay had prepared the cash report shown below.

  - Sanjay also mentioned that there were 20 machines in the warehouse, whose total cost had been \$2,000 each. Anoop read the report and told Sanjay that the information was not sufficient. He then asked for the Balance Sheet of the firm (Dec 31, 2012). Sanjay did not know exactly how to prepare it, but did his best.

  During 2013, Sanjay was in charge of the business, taking care of cash flows (i.e., cash inputs and outputs), but not really paying attention to the financial situation of the firm. Time went by quickly. At the beginning of December 2013, Sanjay got an e-mail from his uncle requiring the following information for year 2013:
  - Balance Sheet (Dec 31)
  - Income Statement
  - Statement of Cash Flows

  Sanjay gathered all the information he was able to find regarding operations during 2013 and summarized it as follows:
  1. The firm imported 170 additional machines (on account, i.e., using trade credit), \$2,000 each.
  2. Fifty machines were sold (cash), at \$3,000 each.
  3. One hundred machines were sold (on account), \$3,300 each.
  4. During 2013, \$250,000 were collected from customers who had not paid cash.
  5. Likewise, the firm paid the cost of 140 machines to the supplier.
  6. General and administrative expenses totaled \$20,000 (paid cash).
  7. The remaining money corresponding to the warehouse was paid.
  8. On Dec 31, 2013, half of the bank debt (i.e., \$20,000) was repaid.
  9. Interest of the loan was paid.

  #let cash = t-account(
    [Cash],
    [], [],
  )
  
  #let ap = t-account(
    [A/P],
    [], [],
  )
  
  #let ar = t-account(
    [A/R],
    [], [],
  )
  
  #let fixed-assets = t-account(
    [PP&D],
    [], [],
  )
  
  #let inventory = t-account(
    [PP&D],
    [], [],
  )
  
  #let equity = t-account(
    [Equity],
    [], [],
  )
  
  #let equity = t-account(
    [Equity],
    [], [],
  )

  #let expenses = expenses(
    [], [],
    [], [],
  )

  #let revenue = revenue(
    [], [],
    [], [],
  )

  #balance-sheet(
    assets: (
      cash,
      ar,
      fixed-assets,
      inventory
    ),
    liabilities: (
      equity,
      ap,
    ),
    expenses,
    revenue,
  )

  #balance-sheet-summary(
    cash: 0,
    ar: 0,
    inventory: 0,
    ppe: 0,
    ap: 0,
    debt: 0,
    equity: 0,
  )


]


Inventory valuation 
1. Product costing

- Direct v. Indicrect Costs
  - Direct: Expenses that directly go into producing goods specific to the operation (direct labor, direct materials, mfg supplies)
  - Indirect: General business expenses for operations shared between operations (indirect labor, rent, utilities)

- Fixed v. Variable Costs
  - Fixed: Does not depend on the volume of activity
  - Variable: Varies in relation to volume

2. Flow assumption




- Absorbtion costing
  - Direct cost 
  - Fixed & variable overhead (indirect costs)
- Direct (variable) costing

== Activity based costing 

(Cost to serve) (activity based costing / pricing)

Depend on complexity of activity, shipments, service

A pricing strategy that sets prices based on the actual overhead and indirect resources a product, service, or customer consumes

Determine how much each customer costs

Normal costing can hide profitable and unprofitable customers

- Amount of money being spent on a customer (focus on large sums)
- Variability of customer behavior (cost to serve variation) (focus on high variability activities). Different use / consumption between customers.

=== Dakota Case Study

Operating expenses: \$5.85M

Cost Pools -> Activities -> Cost Drivers (transactional, time, intensity)

Cost Pools:
+ *Freight* (\$450k)
+ *Warehouse Expenses* (\$2M)
+ *Personnel* (\$2.4M)
+ *Delivery Truck* (\$200k)
+ *Order Entry* (\$800k)

Activities:
- Ship Cartons
- Process Cartons
- Deliver Destops
- Process Manual Orders
- Enter Items Ordered (Manual)
- Process EDI Orders (e.g. validate)

Cost Drivers

Link drivers to customer behavior


== Finance Performance Ratios

Return on equity

$
  "ROE" = "Net Profit" / "Equity"
$

$
  "Shareholder Return" = (Delta "Spot"_(n-1, n) + "DPS") / "Spot"_(n-1) = (Delta "Market Value"_(n-1, n) + "Dividend") / "Market Value"_(n-1)
$

$
  "ROE" = underbrace("Net Profit" / "Sales", "Profit\nMargin") times underbrace("Sales" / "Total Assets", "Asset\nTurnover") times underbrace("Total Assets" / "Equity", "Financial\nLeverage")
$

$
  "ROA" = "EBIT" / "Total Assets" = "EBIT" / "Sales" times "Sales" / "Total Assets"
$

Tradeoff: Profitability v. Asset turnover

Inovative (R&D) v. Asset utilization 

Use machines efficiently v. invoatively 

ROE

#table(
  columns: 3,
  table.header([*Profit Margin*], [*Asset Turnover*], [*Financial Leverage*]),
  [Gross Margin], [Days Inventory], [Payable Period], 
  [Tax Rate], [Collection Period], [Debt / Equit], 
  [% Income Statement], [Inventory Turnover], [Current Ratio], 
  [], [Asset Turnover], [???], 
  [], [% Balance Sheet], [], 
  [], [], [], 
)

Profit Margin

$
  "Net Margin" = "NP" / "Sales"
$

Gross Margin

$
  "Gross Margin" = "GP" / "Sales"  
$

Net Profit: Alot of random costs go into it (Aquisition, Building burned)

Gross Profit: Focus on this, less random stuff goes into it

$
  "Asset Turnover" = "Sales" / "Totoal Assets"
$

We are operations people: remove cash / and intangibles (fixed assets) to get a clearer picture

Days of Inventory 

$
  "DIO" = ("Inventory" times 365) / "COGS"
$

On average how many days inventory lasts in the firm

Inventory Turns

$
  "IT" = "COGS" / "Inventory"
$

On average how many times per year inventory enters and leaves the firm

Use Average (always, for everything) coming from balance sheet

Gross Margin Return on Inventory

$
  "GMROI" = "Gross Profit" / "Inventory" = "GP" / "Sales" times "Sales" / "Inventory"
$

How much gross profit per dollar of inventory

Days of Sales Outstanding 

$
  "DSO" = ("Account Receivable" times 365) / "Sales"
$

On average what is the credit you offer your customer

Days Payable Outstanding 

$
  "DPO" = ("Account Payable" times 365) / ("Purchases" ("CoGS"))
$

On average how long does it take you to pay suppliers?

No purchases: Use CoGS

Cash-to-Cash Cycle (CCC)

$
  "CCC" = "DIO" + "DSO" - "DPO"
$

Time elapsed, on average, between payement to supplier and collection from customers

Cash flow (Diagram)

Current Ratio

$
  "Current Ratio" = "Current Assets" / "Current Liability"
$

Times Interest Earned

$
  "Times Interest Earned" = "EBIT" / "Interest Expense"
$


Financial Leverage

$
  "Financial Leverage" = "Debt" / "Equity" \
  "Financial Leverage" = "Total Assets" / "Equity"
$

FL = 1 if interest is 0

$
  "Financial Leverage" = (% Delta "EBT") / (% Delta "EBIT")
$

Operational Leverage

OL = 1 if no fixed costs

$
  "Operational Leverage" = (% Delta "EBIT") / (% Delta "Sales")
$

Return on Net Asset (ROIC or RONA)

$
  "ROIC" = "NOPAT" / (D + E) \
  "NOPAT" = "EBIT" times (1 - "tax rate")
$

Net operating profit after tax

ROE v. ROIC -> Strip out the Debt (Interest / Leverage)?

Assets generate value, Liabilities finance assets

Leverage boosts ROE, more attractive but riskier

$
  "ROE" = "RONA" + D / E \["RONA" - underbrace(i(1 - t), "Efftective tax rate")]
$

$
  i(1 - t) = ("interest rate" (1 - "tax rate"))
$

// #let q1(value) = [#value#metadata(value)<q1>]
// #let q2(value) = [#value#metadata(value)<q2>]
// #let q3(value) = [#value#metadata(value)<q3>]

// #table(
//   columns: 4,
//   table.header([*Item*], [*Q1*], [*Q2*], [*Q3*]),

//   [Apples],   q1(10), q2(15), q3(12),
//   [Bananas],  q1(8),  q2(9),  q3(11),
//   [Cherries], q1(20), q2(18), q3(22),

//   [*Total*],
//   context [*#query(<q1>).map(e => e.value).sum()*],
//   context [*#query(<q2>).map(e => e.value).sum()*],
//   context [*#query(<q3>).map(e => e.value).sum()*],
// )

- Revenue is the one unambiguous term here — it's the top line, the total amount generated from selling goods or services, before a single cost is subtracted.
- Profit is a generic term for "revenue minus some set of costs," and it's only meaningful once you say which stage you mean
  - Gross Profit (Net Sales - COGS)
  - Operating Profit (Gross Profit - OPEX, i.e. EBIT)
  - Net Profit (the very bottom line, after taxes and everything else)
- Income is generic and stage-dependent 
  - Operating Income (EBIT, Pretax Income, Net Income)
- Earning: Net Income



== Balance Sheet (BS)



== Income Statement (P&L)

Net Sales = Net product sales + Net service sales

Net:
- Sales returns (goods customers sent back)
- Sales allowances (price reductions given for damaged or unsatisfactory goods without a full return)
- Sales discounts (early-payment or volume discounts taken by the customer)

OPEX = Marketing + G&A + Tech & Content + Fulfillment

- OPEX (Operating Expenses) — the recurring costs of running the core business
- Marketing — spend to acquire and retain customers
- G&A (General & Administrative) — corporate overhead that isn't tied to any one function
- Tech & Content — the cost of building and running the technology platform and any content offered to customers
- Fulfillment — the cost of getting an order from warehouse to customer

Gross Profit = Net Sales - COGS

- COGS (Cost of Goods Sold) — the direct cost of the products a company actually sold during the period
  - Purchase price paid to suppliers or manufacturers for the goods sold
  - Inbound freight and shipping to get inventory into the warehouse
  - Outbound shipping and delivery costs to get the product to the customer
  - Packaging materials
  - Write-downs for inventory that's obsolete or unsellable

EBIT = Gross Profit - OPEX

Pretax Income = EBIT - Non-Op (Inc) Loss - Abnormal (Gains)

- EBIT (Earnings Before Interest and Taxes) — operating profit from the core business, before any financing costs or taxes are applied
- Non-Op (Inc) Loss — "Non-Operating (Income) Loss" — the net effect of financial activity outside core operations 
  - Interest expense on debt
  - Interest income earned on cash
  - Foreign-currency gains/losses
  - Earnings from equity stakes in other companies
- Abnormal (Gains) [Losses] — one-time, non-recurring items with nothing to do with ongoing operations
  - Restructuring charges
  - Asset impairments/write-downs
  - Litigation settlements
  - Gain/loss from selling a business unit
- Pretax Income (also called Income Before Taxes, or EBT) — total earnings after both operating results and these non-operating/unusual items are folded in, but before income tax expense is applied

Net Income = Pretax Income - Income Tax Expense

Mkt Cap / EBITDA = Market Cap / EBITDA

ROS = Net Income / Net Sales

Turnover = Net Sales / Total Assets 

Leverage = Total Assets / Equity 

RONA = EBIT / Net Assets 

ROA = Net Income / Total Assets 

ROE = ROS × Turnover × Leverage

== Cash Flow (CF)


#example([Financial Planning (Wilson Lumber)])[
  Industry
  - Lumber (Wholesale)
  - Low / Moderate growth
  - Seasonality / Cyclicality
  - Order winner: Price & availability 

  Market strategy
  - Competes with price
    - OPEX under tight control
    - Fixed Assets under tight control
    - Quantity (large) discounts
      - High availability
  
  Company health
  - Growth ($arrow.t$) 🙂
  - Profitability
    - ROE: 12.7% < 14% Interest 😐
    - Leverage ($arrow.t$) - Current ratio ($arrow.b$) 🙁
  
  Problem
  - Current credit line is tight (\$175k)
    - Foregoes supplier discounts (can no longer compete on price)
      - $"DPO"_1983 = 37.8 quad arrow quad "DPO"_1985 = 47$
      - Discount $arrow$ 2% 10 / net 30
        - 1000
          - Pay on day 10: \$980
          - Pay on day 46: \$1000
        - Use \$980 for 36 days paying \$20
          $
            20 / 980 times 365 / 36 = 20.6%
          $
    - Talking to new bank (\$325k)
  
  Would you lend?
  - Covenants
    - DSO $arrow.b$
    - DPO $arrow.t$
    - DIO $arrow.b$
    - WC
    - OWC
    - Guarantee of personal property
    - Growth?
  
  $
    g = (delta S) / S \
    g dot ("OWC" + "FA") = delta D + delta E \
    g dot (D + E) = delta D + delta E \
  $

  2 cases:
  - $delta D = 0$
    
    $g (D + E) = "NP"$

    $g = "NP" / (D + E)$

  - $D / E$: constant

    $g(D + E) = D "NP" / E + "NP"$

    $g = "NP" / E$ (ROE)
  
]

= Investment Evaluation 

Financial evaluation:
+ Estimate relevant *chash flows*
+ Calculate *figures of merit*
+ Compare figures of merit to *acceptance criteria*

- ARR

Acceptance criteria: > 1

- NPV

- Compounding

$
  overbrace(1, "principle")\(1 + underbrace(0.10, "interest\nrate")\)^2
$

- Discounting

$
  overbrace(1, "principle") / (1 + underbrace(0.10, "interest\nrate")^2)
$

- IRR

Acceptance criteria: 

- BCR

For fractional investment 

Acceptance criteria: 


If conflict between NPV, IRR and BCR, go for NPV.

== Estimation of relevant cash flow

- Cash flow principal
- With-without principle


#example([NPV: Should the new machine be acquired?])[
  Consulting cost: 20000 (5 years)
  Machine cost: 40000 
    - 50% upfront
    - 50% in one year
    - Depreciation 8 years
    - Market value after 5 years: 40% of acquisition cost
    - Recquires increase in OWC of 10000
    - Labor savings: 35000 / year
      - Firing cost / worker: 10000
      - Departement overhead reduced by 5000
  
  - Corporate tax rate: 30%
  - Discount rate: 15%

  #[
    #set text(size: 8pt)

    #let r = 0.15
    #let discount(v, t) = v * calc.pow(1 + r, t)

    #table(
      columns: 7,
      inset: 1em,
      [Relevant Cash Flow], [0], [1], [2], [3], [4], [5], 
      [Machine Cost], [(200)], [(200)], [], [], [], [], 
      [Tax shield from\ depreciation], [], [50 $times$ 0.3 = 15], [15], [15], [15], [15], 
      [Scrap Value (net)], [], [], [], [], [], [0.4 $times$ 400 = 157],
      [Working Capital], [(10)], [], [], [], [], [10], 
      [Salaries], [], [98], [98], [98], [98], [98], 
      [Firing cost], [(28)], [], [], [], [], [], 
      [], [], [], [], [], [], [], 
      [], [], [], [], [], [], [], 
      [], [], [], [], [], [], [], 
      
    )
  ]
]




#set page(width: 15in, height: auto, margin: 0.4in, fill: white)

= P&L

#let INPUT = (fill: rgb("#DCE6F1"), stroke: rgb("#5B7DB1"))
#let FORM  = (fill: rgb("#E2F0D9"), stroke: rgb("#6A9955"))
#let XREF  = (fill: rgb("#E8DAEF"), stroke: rgb("#8E44AD"))
#let OUT   = (fill: rgb("#FDEBD0"), stroke: rgb("#B7472A"))

#let pnl-digraph = fletcher.diagram(
  node-stroke: 0.6pt,
  node-corner-radius: 3pt,
  node-inset: 6pt,
  spacing: (18pt, 26pt),
  edge-stroke: 0.7pt,

  // ---- node coordinates are dot's own layout (x,y in inches, y flipped so
  // row increases downward), not hand-placed or re-derived ----
  node((5.65,0.25), [Net product\ sales], name: <prod>, ..INPUT),
  node((7.10,0.25), [Net service\ sales], name: <serv>, ..INPUT),
  node((5.23,1.19), [COGS], name: <cogs>, ..INPUT),
  node((0.53,1.19), [Marketing], name: <mktg>, ..INPUT),
  node((1.70,1.19), [G&A], name: <gna>, ..INPUT),
  node((2.78,1.19), [Tech &\ Content], name: <tech>, ..INPUT),
  node((4.05,1.19), [Fulfillment], name: <fulf>, ..INPUT),
  node((9.99,3.08), [Non-Op\ (Inc) Loss], name: <nonop>, ..INPUT),
  node((8.69,3.08), [Abnormal\ (Gains)], name: <abn>, ..INPUT),
  node((8.34,4.03), [Income Tax\ Expense], name: <taxexp>, ..INPUT),
  node((8.55,0.25), [Market Cap], name: <mktcap>, ..INPUT),
  node((9.83,0.25), [EBITDA], name: <ebitda>, ..INPUT),
  node((8.53,4.97), [Total Assets\ (from BS)], name: <ta>, ..XREF),
  node((7.15,4.97), [Equity\ (from BS)], name: <eq>, ..XREF),
  node((4.02,3.08), [Net Assets\ (from BS)], name: <na>, ..XREF),
  node((6.38,1.19), [Net Sales], name: <sales>, ..FORM),
  node((2.78,2.14), [OPEX], name: <opex>, ..FORM),
  node((8.20,5.92), [Leverage], name: <lev>, ..XREF),
  node((9.19,1.19), [Mkt Cap /\ EBITDA], name: <capebitda>, ..FORM),
  node((5.23,2.14), [Gross Profit], name: <gp>, ..FORM),
  node((6.94,5.92), [Turnover], name: <turn>, ..XREF),
  node((5.23,3.08), [EBIT], name: <ebit>, ..FORM),
  node((9.90,4.03), [Pretax Income], name: <pretax>, ..FORM),
  node((4.63,4.03), [RONA], name: <rona>, ..XREF),
  node((10.01,4.97), [Net Income], name: <ni>, ..FORM),
  node((10.34,5.92), [ROS], name: <ros>, ..FORM),
  node((9.34,5.92), [ROA], name: <roa>, ..XREF),
  node((8.20,6.86), [ROE], name: <roe>, ..OUT),

  // ---- edges: bend angle fit to dot's actual spline curvature ----
  edge(<prod>, <sales>, "->"),
  edge(<serv>, <sales>, "->"),
  edge(<mktg>, <opex>, "->"),
  edge(<gna>, <opex>, "->"),
  edge(<tech>, <opex>, "->"),
  edge(<fulf>, <opex>, "->"),
  edge(<mktcap>, <capebitda>, "->"),
  edge(<ebitda>, <capebitda>, "->"),
  edge(<eq>, <lev>, "->"),
  edge(<ta>, <lev>, "->"),
  edge(<sales>, <gp>, "->"),
  edge(<cogs>, <gp>, "->"),
  edge(<sales>, <turn>, "->", bend: -26deg),
  edge(<ta>, <turn>, "->"),
  edge(<gp>, <ebit>, "->"),
  edge(<opex>, <ebit>, "->", bend: 5deg),
  edge(<ebit>, <pretax>, "->", bend: 5deg),
  edge(<nonop>, <pretax>, "->"),
  edge(<abn>, <pretax>, "->"),
  edge(<ebit>, <rona>, "->"),
  edge(<na>, <rona>, "->"),
  edge(<pretax>, <ni>, "->"),
  edge(<taxexp>, <ni>, "->"),
  edge(<ni>, <ros>, "->"),
  edge(<sales>, <ros>, "->", bend: 55deg),
  edge(<ni>, <roa>, "->"),
  edge(<ta>, <roa>, "->"),
  edge(<ros>, <roe>, "->", bend: 3deg),
  edge(<turn>, <roe>, "->"),
  edge(<lev>, <roe>, "->"),
)

#grid(
  columns: 1,
  inset: 1em,
  align: (left),
  [
    #pnl-digraph
  ],
  [
    #set text(size: 9pt)

    == Formulas

    Net Sales = Net product sales + Net service sales

    OPEX = Marketing + G&A + Tech & Content + Fulfillment

    Gross Profit = Net Sales - COGS

    EBIT = Gross Profit - OPEX

    Pretax Income = EBIT - Non-Op (Inc) Loss - Abnormal (Gains)

    Net Income = Pretax Income - Income Tax Expense

    Mkt Cap / EBITDA = Market Cap / EBITDA

    ROS = Net Income / Net Sales

    Turnover = Net Sales / Total Assets #text(fill: rgb("#8E44AD"))[(Total Assets imported from the Balance Sheet — shown here as a placeholder, not expanded)]

    Leverage = Total Assets / Equity #text(fill: rgb("#8E44AD"))[(both imported from the Balance Sheet)]

    RONA = EBIT / Net Assets #text(fill: rgb("#8E44AD"))[(Net Assets imported from the Balance Sheet)]

    ROA = Net Income / Total Assets #text(fill: rgb("#8E44AD"))[(Total Assets imported from the Balance Sheet)]

    ROE = ROS × Turnover × Leverage #text(size: 7.5pt, fill: rgb("#777777"))[(DuPont identity)]

    #v(6pt)
    #text(size: 7.5pt, fill: rgb("#777777"))[
      Purple nodes/notes are values that live in the Balance Sheet exhibit, not
      here — Total Assets, Equity and Net Assets are drawn as placeholders so
      Turnover, Leverage, RONA and ROA show where their other input comes from,
      but their own formulas aren't expanded (see the BS section for that).
      Pretax Income's sign convention follows the exhibit's own "(Inc) Loss" /
      "(Gains)" labeling, not re-derived from the source figures just now.
    ]

  ]
)



#set page(width: 15in, height: auto, margin: 0.4in, fill: white)

= BS

#let INPUT = (fill: rgb("#DCE6F1"), stroke: rgb("#5B7DB1"))
#let FORM  = (fill: rgb("#E2F0D9"), stroke: rgb("#6A9955"))
#let OUT   = (fill: rgb("#FDEBD0"), stroke: rgb("#B7472A"))

#let bs-digraph = fletcher.diagram(
  node-stroke: 0.6pt,
  node-corner-radius: 3pt,
  node-inset: 6pt,
  spacing: (18pt, 26pt),
  edge-stroke: 0.7pt,

  // ---- node coordinates are dot's own layout (x,y in inches, y flipped so
  // row increases downward), not hand-placed or re-derived ----
  node((6.21,0.25), [Cash &\ STI], name: <cash>, ..INPUT),
  node((2.26,0.25), [Accounts\ Receivable], name: <ar>, ..INPUT),
  node((0.85,0.25), [Inventories], name: <inv>, ..INPUT),
  node((2.29,1.19), [Total Non-current\ Assets], name: <nca>, ..INPUT),
  node((3.67,0.25), [Payables &\ Accruals], name: <pay>, ..INPUT),
  node((8.62,0.25), [ST Debt], name: <stdebt>, ..INPUT),
  node((5.01,0.25), [Other ST\ Liabilities], name: <otherst>, ..INPUT),
  node((9.78,0.25), [LT Debt], name: <ltdebt>, ..INPUT),
  node((7.40,0.25), [Other LT\ Liabilities], name: <otherlt>, ..INPUT),
  node((4.06,4.03), [Other LT\ Free Financing], name: <otherfree>, ..INPUT),
  node((4.00,1.19), [Total Current\ Assets], name: <tca>, ..FORM),
  node((5.54,1.19), [Total Current\ Liabilities], name: <tcl>, ..FORM),
  node((7.79,1.19), [Total Non-current\ Liabilities], name: <tncl>, ..FORM),
  node((0.85,1.19), [NFO], name: <nfo>, ..FORM),
  node((9.38,1.19), [D, Debt\ (ST + LT)], name: <ddebt>, ..FORM),
  node((3.89,2.14), [TOTAL ASSETS], name: <ta>, ..FORM),
  node((7.01,2.14), [TOTAL\ LIABILITIES], name: <tliab>, ..FORM),
  node((2.18,2.14), [NA, Net Assets], name: <na>, ..FORM),
  node((7.01,3.08), [TOTAL EQUITY], name: <teq>, ..FORM),
  node((8.39,4.03), [TOTAL LIAB\ & EQUITY], name: <tliabeq>, ..OUT),
  node((7.04,4.03), [E, Equity], name: <eequity>, ..FORM),
  node((7.04,4.97), [Financing], name: <financing>, ..FORM),
  node((8.42,2.14), [Net Debt\ (D - Cash)], name: <netdebt>, ..OUT),
  node((5.53,2.14), [Current Ratio], name: <curratio>, ..OUT),
  node((5.65,4.03), [BS Leverage\ (Liab/Eq)], name: <bslev>, ..OUT),
  node((0.60,2.14), [NFO / Sales], name: <nfosales>, ..OUT),

  // ---- edges: bend angle fit to dot's actual spline curvature ----
  edge(<cash>, <tca>, "->"),
  edge(<ar>, <tca>, "->"),
  edge(<inv>, <tca>, "->", bend: -3deg),
  edge(<pay>, <tcl>, "->"),
  edge(<stdebt>, <tcl>, "->", bend: 6deg),
  edge(<otherst>, <tcl>, "->"),
  edge(<ltdebt>, <tncl>, "->"),
  edge(<otherlt>, <tncl>, "->"),
  edge(<ar>, <nfo>, "->"),
  edge(<inv>, <nfo>, "->"),
  edge(<pay>, <nfo>, "->", bend: -8deg),
  edge(<otherst>, <nfo>, "->", bend: -12deg),
  edge(<stdebt>, <ddebt>, "->"),
  edge(<ltdebt>, <ddebt>, "->"),
  edge(<tca>, <ta>, "->"),
  edge(<nca>, <ta>, "->"),
  edge(<tcl>, <tliab>, "->"),
  edge(<tncl>, <tliab>, "->"),
  edge(<nfo>, <na>, "->"),
  edge(<nca>, <na>, "->"),
  edge(<ta>, <teq>, "->"),
  edge(<tliab>, <teq>, "->"),
  edge(<tliab>, <tliabeq>, "->", bend: 27deg),
  edge(<teq>, <tliabeq>, "->"),
  edge(<teq>, <eequity>, "->"),
  edge(<ddebt>, <financing>, "->", bend: 55deg),
  edge(<eequity>, <financing>, "->"),
  edge(<otherfree>, <financing>, "->"),
  edge(<ddebt>, <netdebt>, "->"),
  edge(<cash>, <netdebt>, "->", bend: -39deg),
  edge(<tca>, <curratio>, "->"),
  edge(<tcl>, <curratio>, "->"),
  edge(<tliab>, <bslev>, "->", bend: -28deg),
  edge(<teq>, <bslev>, "->"),
  edge(<nfo>, <nfosales>, "->"),
)

#grid(
  columns: 1,
  inset: 1em,
  align: (left),
  [
    #bs-digraph
  ],
  [
    #set text(size: 9pt)

    == Formulas

    Total Current Assets = Cash & STI + Accounts Receivable + Inventories

    Total Current Liabilities = Payables & Accruals + ST Debt + Other ST Liabilities

    Total Non-current Liabilities = LT Debt + Other LT Liabilities

    D, Debt (ST + LT) = ST Debt + LT Debt

    NFO = Accounts Receivable + Inventories - Payables & Accruals - Other ST Liabilities

    TOTAL ASSETS = Total Current Assets + Total Non-current Assets

    TOTAL LIABILITIES = Total Current Liabilities + Total Non-current Liabilities

    NA, Net Assets = NFO + Total Non-current Assets

    TOTAL EQUITY = TOTAL ASSETS - TOTAL LIABILITIES

    TOTAL LIAB & EQUITY = TOTAL LIABILITIES + TOTAL EQUITY #text(size: 7.5pt, fill: rgb("#777777"))[(tie-out check: should equal TOTAL ASSETS)]

    E, Equity = TOTAL EQUITY #text(size: 7.5pt, fill: rgb("#777777"))[(relabel used in the short-BS identity below)]

    Financing = D, Debt (ST + LT) + E, Equity + Other LT Free Financing

    Net Debt (D - Cash) = D, Debt (ST + LT) - Cash & STI

    Current Ratio = Total Current Assets / Total Current Liabilities

    BS Leverage (Liab/Eq) = TOTAL LIABILITIES / TOTAL EQUITY

    NFO / Sales = NFO / Net Sales #text(fill: rgb("#8E44AD"))[(→ P&L)]

    #v(6pt)
    #text(size: 7.5pt, fill: rgb("#777777"))[
      NA = NFO + Non-current Assets is the "short balance sheet" reformulation
      (net assets = net financial obligations + operating assets), separate from
      the ordinary TOTAL ASSETS = current + non-current identity above it. NFO's
      sign convention (receivables/inventory net of payables/other ST liabilities)
      and the tie-out follow the exhibit as built earlier in this session, not
      re-derived from the source PDF just now — worth a quick sanity check.
    ]

  ]
)

