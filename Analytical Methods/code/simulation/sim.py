from scipy.stats import norm, uniform
import polars as pl
import numpy as np

np.random.seed(0)

T = 100

p_disruption = 0.05

unit_price = 50
discount_price = 40
salvage_value = 20
unit_cost = 40
fixed_order_cost = 200

D_small = uniform.rvs(loc=50, scale=100, size=T)
D_large = uniform.rvs(loc=100, scale=200, size=T)

disruption = uniform.rvs(loc=0, scale=1, size=T) < p_disruption

supplier_fail = np.where(
    disruption, 
    uniform.rvs(loc=0, scale=1) < 0.4, 
    uniform.rvs(loc=0, scale=1) < 0.1,
)

order_cancellation = np.where(
    supplier_fail, 
    uniform.rvs(loc=0, scale=1) < 0.4, 
    uniform.rvs(loc=0, scale=1) < 0.1,
)

accept_discount = np.where(
    order_cancellation,
    uniform.rvs(loc=0, scale=1) < 0.2,
    False
)

df_triadic = pl.DataFrame(
    {
        "demand": D_large,
        "disruption": disruption,
        "supplier_fail": supplier_fail,
        "order_cancellation": order_cancellation,
        "accept_discount": accept_discount,

    }
)

df_triadic = df_triadic.with_columns(
    pl.when(~pl.col("order_cancellation"))
      .then(D_large * (unit_price - unit_cost))
      .when(pl.col("accept_discount"))
      .then(D_large * (discount_price - unit_cost))
      .otherwise(D_large * (salvage_value - unit_cost))
      .alias("profit")
)

print(df_triadic)

print(df_triadic["profit"].mean())

################################################################################
################################################################################

resale_2nd_customer = 35

df_dispersed = pl.DataFrame(
    {

    }
)