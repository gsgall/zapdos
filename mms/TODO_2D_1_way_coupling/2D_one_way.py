#!/usr/bin/env python3

import mms

df = mms.run_spatial(
    "2D_main.i",
    4,
    y_pp=["em_l2Error", "ion_l2Error", "potential_l2Error", "mean_en_l2Error"],
)
print(df)
fig = mms.ConvergencePlot(xlabel="Element Size ($h$)", ylabel="$L_2$ Error")
fig.plot(
    df,
    label=["em_l2Error", "ion_l2Error", "potential_l2Error", "mean_en_l2Error"],
    marker="o",
    markersize=8,
    num_fitted_points=5,
)
fig.save("2D_one_way.png")
