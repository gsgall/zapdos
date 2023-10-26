import mms
import os

os.system("export PYTHONPATH=\"${PYTHONPATH}:/Users/graysongall/projects/zapdos/moose/python\"")
y_pp_base = ['vel_x_l2Error_Base', 'vel_y_l2Error_Base', 'p_l2Error_Base']
y_pp = ['vel_x_l2Error', 'vel_y_l2Error', 'p_l2Error']
n = 4
console = True
executable='../../zapdos-opt'

df1 = mms.run_spatial('pspg_mms_test.i', n, console=console, executable=executable, y_pp=y_pp_base)
df2 = mms.run_spatial('ChargeMomentumTransfer.i', n, console=console,  executable=executable, y_pp=y_pp)

fig = mms.ConvergencePlot(xlabel='Element Size ($h$)', ylabel='$L_2$ Error')
fig.plot(df1, label=y_pp_base, marker='o', markersize=8)
fig.plot(df2, label=y_pp, marker='o', markersize=8)
fig.save('Converge.png')
