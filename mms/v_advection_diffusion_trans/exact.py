#!/usr/bin/env python3

import mms
fs,ss = mms.evaluate('u * exp(u) + div(exp(u) * (e_i + 0 * e_j + 0 * e_k) - 1 * exp(u) * grad(u))', 'log((0.25*cos(2*pi*x*t) + 1))')
mms.print_fparser(fs)

mms.print_hit(ss, 'exact')
mms.print_hit(fs, 'force')
