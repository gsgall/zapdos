
import mms
fs,ss = mms.evaluate('N_A * exp(log(1 / N_A)) * grad(u)','sin(pi * x * y)', scalars=['N_A'])
mms.print_fparser(fs)

mms.print_hit(ss, 'exact')
mms.print_hit(fs, 'force')
