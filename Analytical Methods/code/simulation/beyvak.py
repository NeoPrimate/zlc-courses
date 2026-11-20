"""Beyvak Textile: triadic vs dispersed supply chain, Monte Carlo (MZ 510).

Assumptions on the handout's open questions:
- No production (all suppliers down) -> no variable or fixed cost, profit = 0.
- Cancellation only applies to orders that went into production.
- Resale to the other customer needs that customer to be active (no cancel,
  or cancel + accepted discount). If both refuse, both go to salvage.
- Fill rate = units produced / units demanded (supply-side service level).
"""

# %%

import numpy as np
import polars as pl

N_MONTHS = 60
N_REPLICATIONS = 30

P_GLOBAL_DISRUPTION = 0.05
P_RISK_NORMAL_MONTH = 0.1  # supplier failure / cancellation request
P_RISK_GLOBAL_MONTH = 0.4

P_ACCEPT_DISCOUNT_LARGE_CUSTOMER = 0.2
P_ACCEPT_DISCOUNT_SMALL_CUSTOMER = 0.3
P_RESALE_TO_OTHER_CUSTOMER = 0.4

LARGE_CUSTOMER_DEMAND_MIN, LARGE_CUSTOMER_DEMAND_MAX = 100, 200
SMALL_CUSTOMER_DEMAND_MIN, SMALL_CUSTOMER_DEMAND_MAX = 50, 100

FULL_PRICE = 50
DISCOUNTED_PRICE = 40
RESALE_PRICE = 35
SALVAGE_VALUE = 20
VARIABLE_COST_PER_UNIT = 40
FIXED_COST_PER_SUPPLIER_ORDER = 200


def occurs(rng: np.random.Generator, probability, shape) -> np.ndarray:
    return rng.random(shape) < probability


def selling_price(cancel_requested, discount_accepted, resold_to_other_customer=None):
    """Unit price received for one customer's order this month."""
    conditions = [~cancel_requested, discount_accepted]
    prices = [FULL_PRICE, DISCOUNTED_PRICE]
    if resold_to_other_customer is not None:
        conditions.append(resold_to_other_customer)
        prices.append(RESALE_PRICE)
    return np.select(conditions, prices, default=SALVAGE_VALUE)


def simulate(rng: np.random.Generator, n_replications: int, n_months: int) -> pl.DataFrame:
    shape = (n_replications, n_months)

    # global disruption, shared by both designs (identical conditions)
    global_disruption = occurs(rng, P_GLOBAL_DISRUPTION, shape)
    monthly_risk = np.where(global_disruption, P_RISK_GLOBAL_MONTH, P_RISK_NORMAL_MONTH)
    
    ######################################################
    ### triadic SC
    ######################################################

    # supplier status
    large_supplier_up = ~occurs(rng, monthly_risk, shape)
    # orders and production (rejected if the supplier is down)
    large_customer_demand = rng.integers(
        LARGE_CUSTOMER_DEMAND_MIN, LARGE_CUSTOMER_DEMAND_MAX, size=shape, endpoint=True
    )
    triadic_units_produced = np.where(large_supplier_up, large_customer_demand, 0)
    # cancellation -> discount offer -> salvage
    large_customer_cancel_requested = large_supplier_up & occurs(rng, monthly_risk, shape)
    large_customer_discount_accepted = large_customer_cancel_requested & occurs(
        rng, P_ACCEPT_DISCOUNT_LARGE_CUSTOMER, shape
    )
    triadic_price = selling_price(large_customer_cancel_requested, large_customer_discount_accepted)
    # monthly profit
    triadic_supplier_orders = large_supplier_up.astype(int)
    triadic_revenue = triadic_units_produced * triadic_price
    triadic_profit = (
        triadic_revenue
        - VARIABLE_COST_PER_UNIT * triadic_units_produced
        - FIXED_COST_PER_SUPPLIER_ORDER * triadic_supplier_orders
    )

    ######################################################
    ### dispersed SC
    ######################################################

    # each small supplier fails independently
    supplier_1_up = ~occurs(rng, monthly_risk, shape)
    supplier_2_up = ~occurs(rng, monthly_risk, shape)
    dispersed_supplier_orders = supplier_1_up.astype(int) + supplier_2_up
    dispersed_production_started = dispersed_supplier_orders > 0
    # two independent small customers
    customer_1_demand = rng.integers(
        SMALL_CUSTOMER_DEMAND_MIN, SMALL_CUSTOMER_DEMAND_MAX, size=shape, endpoint=True
    )
    customer_2_demand = rng.integers(
        SMALL_CUSTOMER_DEMAND_MIN, SMALL_CUSTOMER_DEMAND_MAX, size=shape, endpoint=True
    )
    dispersed_total_demand = customer_1_demand + customer_2_demand
    dispersed_units_produced = np.where(dispersed_production_started, dispersed_total_demand, 0)
    # each customer may cancel independently
    customer_1_cancel_requested = dispersed_production_started & occurs(rng, monthly_risk, shape)
    customer_2_cancel_requested = dispersed_production_started & occurs(rng, monthly_risk, shape)
    customer_1_discount_accepted = customer_1_cancel_requested & occurs(rng, P_ACCEPT_DISCOUNT_SMALL_CUSTOMER, shape)
    customer_2_discount_accepted = customer_2_cancel_requested & occurs(rng, P_ACCEPT_DISCOUNT_SMALL_CUSTOMER, shape)
    customer_1_cancelled = customer_1_cancel_requested & ~customer_1_discount_accepted
    customer_2_cancelled = customer_2_cancel_requested & ~customer_2_discount_accepted

    # a cancelled order can go to the other customer only if that one is still active
    customer_1_order_resold = (
        customer_1_cancelled & ~customer_2_cancelled & occurs(rng, P_RESALE_TO_OTHER_CUSTOMER, shape)
    )
    customer_2_order_resold = (
        customer_2_cancelled & ~customer_1_cancelled & occurs(rng, P_RESALE_TO_OTHER_CUSTOMER, shape)
    )

    customer_1_price = selling_price(
        customer_1_cancel_requested, customer_1_discount_accepted, customer_1_order_resold
    )
    customer_2_price = selling_price(
        customer_2_cancel_requested, customer_2_discount_accepted, customer_2_order_resold
    )
    # monthly profit
    dispersed_revenue = np.where(
        dispersed_production_started,
        customer_1_demand * customer_1_price + customer_2_demand * customer_2_price,
        0,
    )
    dispersed_profit = (
        dispersed_revenue # profit
        - VARIABLE_COST_PER_UNIT * dispersed_units_produced # variable costs
        - FIXED_COST_PER_SUPPLIER_ORDER * dispersed_supplier_orders # fixed costs
    )

    return pl.DataFrame(
        {
            "replication": np.repeat(np.arange(n_replications), n_months),
            "month": np.tile(np.arange(1, n_months + 1), n_replications),
            "global_disruption": global_disruption.ravel(),
            "triadic_demand": large_customer_demand.ravel(),
            "triadic_units_produced": triadic_units_produced.ravel(),
            "triadic_profit": triadic_profit.ravel(),
            "dispersed_demand": dispersed_total_demand.ravel(),
            "dispersed_units_produced": dispersed_units_produced.ravel(),
            "dispersed_profit": dispersed_profit.ravel(),
        }
    )


def summarise(monthly_results: pl.DataFrame) -> pl.DataFrame:
    """Per-replication KPIs for both designs."""
    kpi_columns = [
        expr
        for design in ("triadic", "dispersed")
        for expr in (
            pl.col(f"{design}_profit").mean().alias(f"{design}_avg_monthly_profit"),
            pl.col(f"{design}_profit").std().alias(f"{design}_profit_std"),
            pl.col(f"{design}_profit").min().alias(f"{design}_worst_month"),
            (pl.col(f"{design}_profit") < 0).mean().alias(f"{design}_share_loss_months"),
            (pl.col(f"{design}_units_produced").sum() / pl.col(f"{design}_demand").sum()).alias(
                f"{design}_fill_rate"
            ),
        )
    ]
    return (
        monthly_results.group_by("replication")
        .agg(kpi_columns)
        .with_columns(
            preferred_design=pl.when(
                pl.col("dispersed_avg_monthly_profit") > pl.col("triadic_avg_monthly_profit")
            )
            .then(pl.lit("dispersed"))
            .otherwise(pl.lit("triadic"))
        )
        .sort("replication")
    )

# %%

rng = np.random.default_rng(0)
monthly_results = simulate(rng, N_REPLICATIONS, N_MONTHS)
replication_kpis = summarise(monthly_results)

print("Single 60-month run (replication 0):")
print(replication_kpis.filter(pl.col("replication") == 0))

#%%

print(f"\nAverage over {N_REPLICATIONS} replications:")
kpi_names = ["avg_monthly_profit", "profit_std", "worst_month", "share_loss_months", "fill_rate"]

print(
    pl.DataFrame(
        {
            "kpi": kpi_names,
            "triadic": [replication_kpis[f"triadic_{k}"].mean() for k in kpi_names],
            "dispersed": [replication_kpis[f"dispersed_{k}"].mean() for k in kpi_names],
        }
    )
)

# %%

print("\nPreferred design by average profit, count over replications:")

print(
    replication_kpis["preferred_design"].value_counts()
)

# %%

long_run = summarise(simulate(np.random.default_rng(1), 1, 1_000_000))
print("\nLong run, 1M months:")

print(
    long_run.select(pl.exclude("replication"))
)


# %%
