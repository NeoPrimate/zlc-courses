import numpy as np
from scipy import stats

T = 100

loading_time = np.array([5, 10, 15])
p_loading_time  = np.array([0.3, 0.5, 0.2])

weighing_time = np.array([5, 10, 15])
p_weighing_time  = np.array([0.3, 0.5, 0.2])

travel_time = np.array([12, 16])
p_travel_time  = np.array([0.7, 0.3])

load_dist = stats.rv_discrete(name="loading_time", values=(loading_time, p_loading_time))
weigh_dist = stats.rv_discrete(name="weighing_time", values=(weighing_time, p_weighing_time))
travel_dist = stats.rv_discrete(name="travel_time", values=(travel_time, p_travel_time))

### System State





### Events

EW # end of weighing

EL # end of loading

ALQ # arrival at loader queu

### Statistics

BL # busy time of loaders

BS # busy time of scale

### Model

LQt0 = 3
Lt0 = 2
WQt0 = 0
Wt = 0

rng = np.random.default_rng(42)

max_iter = 100
clock = 0

# 
FEL = {}
for _ in range(max_iter):
    FEL["EL1"] = clock + load_dist.rvs(random_state=rng)
    FEL["EL2"] = clock + load_dist.rvs(random_state=rng)
    FEL["EW"]  = clock + weigh_dist.rvs(random_state=rng)

    # number of trucks in the queu to be loaded
    LQt = 

    # number of trucks being loaded
    Lt = 

    # number of trucks in queu to be weighed
    WQt = 

    # number of trucks being weighed
    Wt = 

    t_min = min(FEL.values())
    t_evts = {k: v for k, v in FEL.items() if v == t_min}
    clock = t_min[0]

    for evt in t_evts:
        del FEL[evt]