#!/usr/bin/env python3
import os
#export PYTHONPATH="${PYTHONPATH}:/Users/graysongall/projects/zapdos/moose/python"
import mms
n = 4
console = True
executable='../../zapdos-opt'
mpi = '10'
y_pp=['vel_x_l2Error', 'vel_y_l2Error', 'p_l2Error', 'em_l2Error','ion_l2Error','potential_l2Error','mean_en_l2Error']
df = mms.run_spatial('2D_main.i', n, y_pp = y_pp, mpi=mpi)

fig = mms.ConvergencePlot(xlabel='Element Size ($h$)', ylabel='$L_2$ Error')
fig.plot(df, label=y_pp, marker='o', markersize=8, num_fitted_points=5)
fig.save('2D_two_way.png')
