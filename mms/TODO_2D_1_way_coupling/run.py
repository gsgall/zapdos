import os
import mms

os.system(
    'export PYTHONPATH="${PYTHONPATH}:/Users/graysongall/projects/zapdos/moose/python"'
)

df1 = mms.run_spatial(
    "2D_main.i",
    4,
    mpi=8,
    console=False,
    executable="../../zapdos-opt",
    y_pp=["em_l2Error", "ion_l2Error", "potential_l2Error", "mean_en_l2Error"],
)
fig = mms.ConvergencePlot(xlabel="Element Size ($h$)", ylabel="$L_2$ Error")
fig.plot(
    df1,
    label=["em_l2Error", "ion_l2Error", "potential_l2Error", "mean_en_l2Error"],
    marker="o",
    markersize=8,
)
fig.save("plot.png")
