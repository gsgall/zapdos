import mms
df1 = mms.run_spatial('scalar_test.i', 4, console=False, executable='../../zapdos-opt')
df2 = mms.run_spatial('vector_test.i', 4, console=False, executable='../../zapdos-opt')
fig = mms.ConvergencePlot(xlabel='Element Size ($h$)', ylabel='$L_2$ Error')
fig.plot(df1, label='Scalar', marker='o', markersize=8)
fig.plot(df2, label='Vector', marker='o', markersize=8)
fig.save('plot.png')
