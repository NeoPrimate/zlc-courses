#import "/lib/imports.typ": *
#import "/lib/formatting.typ": *
#show: formatting

= Case Study 1. Amazon

With such a small profit margin, how do you grow that much?

To sell \$100:

*Assets*

$
  "PPE" = "PPE"_2017 / "Sales"_2017 = \$27
$
$
  "Inventory" = "Inventory"_2017 / "Sales"_2017 = \$9
$
$
  "A/R" = "A/R"_2017 / "Sales"_2017 = \$7
$

*Liabilities*

29% is financed by suppliers

$
  "A/P" = "A/P"_2017 / "Sales"_2017 = \$29
$

$
  "CCC" 
  &= "DIO" + "DSO" - "DPO" \
  &= (macron(I) times 365) / "CoGS" + (macron("A/R") times 365) / "Sales" - (macron("A/P") times 365) / "CoGS" = - 90 "days"
$

- *Lower is better*. Less cash is tied up in working capital, so the business needs less outside financing
- A *negative* CCC means customers pay you before you pay your suppliers, so suppliers are effectively funding your operations

$
  "ROE" =  "NP" / E = "NP" / "Sales" times "Sales" / "TA" times "TA" / E
$