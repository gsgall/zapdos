
import mms
fs,ss = mms.evaluate('div(exp(u) * ((0.4*sin(0.5*pi*x) + 0.4*sin(pi*y) + 0.7*sin(0.2*pi*x*y) + 0.5) * e_i + (0.6*sin(0.8*pi*x) + 0.3*sin(0.3*pi*y) + 0.2*sin(0.3*pi*x*y) + 0.3) * e_j + 0 * e_k))','log((sin(pi*(y/y_max)) + 1.0 + 0.9*cos(pi/2*(x/x_max))) / N_A)', scalars=['N_A', 'y_max', 'x_max'])
mms.print_fparser(fs)

mms.print_hit(ss, 'exact')
mms.print_hit(fs, 'force')
