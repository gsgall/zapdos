
import mms
fs,ss = mms.evaluate('N_A * log((sin(pi*(y/y_max)) + 1.0 + 0.9*cos(pi/2*(x/x_max))) / N_A) * grad(u)','-(ee*(2*x_max**2*cos((pi*x)/(2*x_max)) + y_max**2*cos((pi*y)/y_max)*sin(2*pi*f*t)))/(5*diffpotential*pi**2)', scalars=['N_A', 'x_max', 'y_max', 'ee', 'f', 'diffpotential'])
mms.print_fparser(fs)
mms.print_hit(ss, 'exact')
mms.print_hit(fs, 'force')


s,ss = mms.evaluate('u * exp(u) + div(exp(u) * (e_i + 0 * e_j + 0 * e_k) - 1 * exp(u) * grad(u))', 'log((0.25*cos(2*pi*x*t) + 1))')
mms.print_fparser(fs)
mms.print_hit(ss, 'exact')
mms.print_hit(fs, 'force')
