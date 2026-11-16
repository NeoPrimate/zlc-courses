#h(1fr) Fabián Hernández Leiva \
#h(1fr) Manyara Kevin Omenyi \
#h(1fr) Vladimir Borel \

#title("Wilson Lumber Case Study")

+ *For fiscal year 1984, calculate: sales growth, ROE, Net Margin, Working Capital, Days Receivable, Days Payable, Days Inventory, Leverage, and the following percentages with respect to Sales: CGS, (SGA+D&A), Inventory, Fixed Assets, Interest, Taxes, Total Assets.* \

  #block(width: 100%)[
  #set text(size: 9pt)

  #table(
    columns: (2.2fr, 3fr, 1fr),
    align: (left, left, right),
    inset: 6pt,
    stroke: 0.4pt + luma(180),
    fill: (x, y) => if y == 0 { luma(235) } else if y == 9 { luma(245) } else { none },

    table.header(
      [*Metric*], [*Calculation*], [*1984*],
    ),

    [Sales growth], [Sales#sub[1984] / Sales#sub[1983] − 1], [34.0%],
    [ROE], [Net profit / average equity], [13.57%],
    [Net margin], [Net profit / sales], [1.65%],
    [Working capital (USD '000)], [Current assets − current liabilities], [169],
    [Days receivable], [Accounts receivable / sales × 365], [36.52],
    [Days payable], [Accounts payable / CGS × 365], [40.00],
    [Days inventory], [Inventory / CGS × 365], [69.57],
    [Leverage (times)], [Average total assets / average equity], [2.56],

    table.cell(colspan: 3)[*As % of sales*],

    [CGS], [CGS / sales], [72%],
    [SGA + D&A], [(SGA + D&A) / sales], [24%],
    [Inventory], [Inventory / sales], [15%],
    [Fixed assets], [Net fixed assets / sales], [5.8%],
    [Interest], [Interest expense / sales], [1.22%],
    [Taxes], [Income taxes / sales], [0.32%],
    [Total assets], [Total assets / sales], [35%],
  )
]

+ *How would you rate the financial situation of Lumber Company at the end of fiscal year 1984?* \
  
  The Lumber Company at the end of fiscal year 1984 is making a thin net margin (roughly same as before) despite sales growth of 34%.
  COGS take up the bulk of the sales (72.4% in 1984). That means, for every 100 dollars of sales, the company spent 72.4 dollars on COGS. The sales have been increasing each year.  However, the net margin has slightly reduced from 1.70% to 1.65%. Working capital is increasing year on year. Current assets exceed current loabilities by 169,000 dollars. In 1984, the company has a return on equity (ROE) of 13.57%. Each dollar of average equity supports 2.56 dollarsof average assets, which means that 1.56 dollars was financed by liabilities which includes supplier credit and borrowing.

  In sumary, the company is growing, but its liabilities are increasing as well forcing it so seek additional liabilities to fund its operations.

  *Why has Mr. Wilson had to borrow additional money?* \
  Wilson is borrowing money because his cash is going towards supporting more inventory and accounts receivable. The company took about 70 days to sell inventory, 36,52 to collect receivables, and 40 days to pay suppliers. His cash conversion cycle is 66 days. In fact, inventory exceeds fixed assets almost 2.65 times. Also, the total of receivable and inventory grew by 131,000 dollars from 1983 to 1984. 

  *If you were George Dodge, would you lend additional money to Mr. Wilson?*

  Yes. The company is growing and has a slight positive net margin, but seems to have an issue with inventory management and collections of receivables. However, I woudn't make it unsecured. I would lend the money subject to a number of conditions: \

  + Provide a cashflow statement forecast to crosscheck what their peak financing needs are versus their requested amount of 325,000 and whether the are capable of paying it back.
  + I would seek security over the inventory, receivables, and the fixed assets in case of default.
  + I would seek a personal guarantee from Mr. Wilson against his personal assets.
  + I would minimize withdrawal of cash, additional borrowing and any capital investments will need to be approved.
  + I would also advise them to improve their inventory management and collection of receivables to reduce their cash conversion cycle, if that is possible in their business model. \

+ *Look at Cash in 1984. Is the level of cash reasonable given the risk of the industry?* \
  Cash end of 1984 decreased from 34 to 29 despite sales increasing 34%. The 29,000 dollars represents only 1.54% of sales and about 6 days of sales. Net margin is only 1.65% which is very slim, leaving very little room for disruption that affects demand for lumber. The cash appears relatively low in comparison to the risks posed by economic downturns and shortage of home mortage. The cash conversion cycle is 66 days. So, any delays in collection risks making the company depend on suppliers and financiers for credit.

+ *Calculate the ratios in question 1 for 1982, 1983 and first quarter of 1985.*

  #block(width: 100%)[
    #set text(size: 9pt)

    #table(
      columns: (2.6fr, 1fr, 1fr, 1fr, 1.2fr),
      align: (left, right, right, right, right),
      inset: 6pt,
      stroke: 0.4pt + luma(180),
      fill: (x, y) => if y == 0 { luma(235) } else { none },

      table.header(
        [*Metric*],
        [*1982*],
        [*1983*],
        [*1984*],
        [*Q1 1985*],
      ),

      [Sales growth],
      [56%], [19%], [34%], [23%],

      [ROE (annualised)],
      [N/A], [11.94%], [13.57%], [9.72%],

      [Net margin],
      [1.77%], [1.70%], [1.65%], [1.20%],

      [Net working capital (USD '000)],
      [144], [155], [169], [171],

      [Days receivable],
      [N/A], [35.64], [36.52], [42.08],

      [Days payable],
      [N/A], [37.84], [40.00], [45.33],

      [Days inventory],
      [62.97], [71.73], [69.57], [85.13],

      [Leverage (times)],
      [N/A], [2.32], [2.56], [2.87],

      [CGS / sales],
      [72%], [71%], [72%], [73%],

      [(SGA + D&A) / sales],
      [25%], [26%], [24%], [24%],

      [Inventory / sales],
      [14%], [16%], [15%], [19%],

      [Fixed assets / sales],
      [7.6%], [7.0%], [5.8%], [5.6%],

      [Interest / sales],
      [0.76%], [0.99%], [1.22%], [1.39%],

      [Taxes / sales],
      [0.42%], [0.36%], [0.32%], [0.20%],

      [Total assets / sales],
      [35%], [37%], [35%], [38%],

      [*Cash conversion cycle (days)*],
      [*N/A*], [*69.54*], [*66.09*], [*81.88*],
    )
  ]
  \

+ *How much additional debt will Mr. Wilson need for 1985 & 1986? (make reasonable assumptions here)*


  #block(width: 100%)[
    #set text(size: 9pt)

    #table(
      columns: (3.2fr, 1fr, 1fr, 1fr),
      align: (left, right, right, right),
      inset: 6pt,
      stroke: 0.4pt + luma(180),
      fill: (x, y) => if y == 0 { luma(235) } else { none },

      table.header(
        [
          *Forecast item (USD '000)* \
          
        ],
        [*1984 actual*],
        [*1985 forecast*],
        [*1986 forecast*],
      ),

      [
        *Sales* \
        #text(size: 8pt)[
          1985: 2,500, from the case forecast. \
          1986: 2,500 × 1.25 = 3,125. \
          Assumption: sales grow by 25% in 1986.
        ]
      ],
      [1,884.00], [2,500.00], [3,125.00],

      [
        *Total assets* \
        #text(size: 8pt)[
          Forecast sales × (653 / 1,884). \
          Assumption: assets remain at 34.66% of sales,
          maintaining the 1984 ratio.
        ]
      ],
      [653.00], [866.51], [1,083.13],

      [
        *Accounts payable + accrued expenses* \
        #text(size: 8pt)[
          Forecast sales × ((179 + 27) / 1,884). \
          Assumption: liabilities remain 10.93% of sales, maintaining the 1984 ratio.
        ]
      ],
      [206.00], [273.35], [341.69],

      [
        *Annual net profit retained* \
        #text(size: 8pt)[
          Forecast sales × (31 / 1,884). \
          Assumptions: net margin remains at approximately
          1.65%; all profits are retained, no dividend payout.
        ]
      ],
      [31.00], [41.14], [51.42],

      [
        *Closing equity* \
        #text(size: 8pt)[
          Previous year's closing equity
          + current year's retained profit. \
          Assumption: no new owner equity or other
          direct changes to equity.
        ]
      ],
      [244.00], [285.14], [336.56],

      [
        *Total borrowing required* \
        #text(size: 8pt)[
          Total assets − accounts payable
          − accrued expenses − closing equity. \
          Assumption: borrowing finances the gap.
        ]
      ],
      [*203.00*], [*308.02*], [*404.88*],

      [
        *Mortgage balance, including current portion* \
        #text(size: 8pt)[
          Previous year's mortgage balance − 5. \
          Starting balance: 35 + 5 = 40 in 1984. \
          Assumption: scheduled annual principal
          repayments of 5 continue. No new mortgage taken up.
        ]
      ],
      [40.00], [35.00], [30.00],

      [
        *Bank loan required* \
        #text(size: 8pt)[
          Total borrowing required − mortgage balance. \
          Assumption: the bank facility covers the
          remaining year-end borrowing requirement.
        ]
      ],
      [*163.00*], [*273.02*], [*374.88*],

      [
        *Additional bank debt vs. prior year* \
        #text(size: 8pt)[Bank loan required − prior year's bank loan.]
      ],
      [—], [*110.02*], [*101.86*],
    )
  ]

  Since sales grow faster than profits and supplier credit can fund, he must borrow the difference from the bank. The bank loan rises from 163k at the end of 1984 to about 273k at the end of 1985 and 375k at the end of 1986. So he needs about 110k of new bank loans in 1985 and 102k in 1986, about 212k in total.

  