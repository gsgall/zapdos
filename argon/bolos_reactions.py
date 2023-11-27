from bolos import parser, grid, solver
import numpy as np
import matplotlib.pyplot as plt
import scipy.constants as co
from collections import OrderedDict
import os

# compute parameters needed for solver given common system inputs
p = 1.01e5
T = 300
N = p/(co.k*T)
xAr = 1.0
# Set-up the electric field values we want to compute for
EStart = 1.0e+04
EFin = 1.0e+07
nEf = 200 # number of Electric field nodes
mult = (EFin/EStart)**(1.0/(nEf - 1.0))
EArray = np.zeros(nEf)
tdArray = np.zeros(nEf)
mu = np.zeros(nEf)
Diff = np.zeros(nEf)
alpha = np.zeros(nEf)
alphaEx = np.zeros(nEf)
alphaEl = np.zeros(nEf)
eta = np.zeros(nEf)
mean_energy = np.zeros(nEf)
kArIz = np.zeros(nEf)
kArEx = np.zeros(nEf)
kArEl = np.zeros(nEf)

EArray[0] = EStart
tdArray[0] = EStart/(N*1.0e-21)
for i in range(0,nEf-1):
    EArray[i+1]=EArray[i]*mult
    tdArray[i+1]=EArray[i+1]/(N*1.0e-21)

# Set-up the electron energy grid we want to compute the electron
# energy distribution on
en_start = 0.0
en_fin = 60.0
en_bins = 200
gr = grid.QuadraticGrid(en_start,en_fin,en_bins)
boltzmann = solver.BoltzmannSolver(gr)
# with open('/mnt/Data/AlexApps/pythonForBolos/LXCat-June2013.txt') as fp:
with open(os.path.expandvars('argon_xsec.txt')) as fp:
    processes = parser.parse(fp)
boltzmann.load_collisions(processes)
boltzmann.target['Ar'].density = xAr - 1e-3
boltzmann.target['Ar*'].density = 1e-3

boltzmann.kT = T * co.k / solver.ELECTRONVOLT
for i in range(0,nEf):
    EField = EArray[i]
    En = EField/N
    boltzmann.EN = En
    boltzmann.init()
    fMaxwell = boltzmann.maxwell(5.0)
    if i==0:
        f = boltzmann.converge(fMaxwell,maxn=100,rtol=1e-5)
    else:
        f = boltzmann.converge(f,maxn=100,rtol=1e-6)
    mean_energy[i] = boltzmann.mean_energy(f)
    mu[i] = boltzmann.mobility(f)/N
    Diff[i] = boltzmann.diffusion(f)/N
    # kArIz[i] = boltzmann.rate(f,"Ar -> Ar^+")
    # kArEx[i] = boltzmann.rate(f,"Ar -> Ar*(11.5eV)")
#     alpha[i] = 1.0/(mu[i]*En)*(xAr*kArIz[i])
#     alphaEx[i] = 1.0/(mu[i]*En)*(xAr*kArEx[i])
#     for target,proc in boltzmann.iter_elastic():
#         kArEl[i] = boltzmann.rate(f,proc)
#     alphaEl[i] = 1.0/(mu[i]*En)*(xAr*kArEl[i])

# for i in range(len(alpha)):
#     if alpha[i] < 1e-4:
#         alpha[i] = 0.
#     if alphaEx[i] < 1e-4:
#         alphaEx[i] = 0.
#     if alphaEl[i] < 1e04:
#         alphaEl[i] = 0.

# mean_energy = np.insert(mean_energy,0,0.)
# alpha = np.insert(alpha,0,0.)
# alphaEx = np.insert(alphaEx,0,0.)
# alphaEl = np.insert(alphaEl,0,0.)

# D_Path = os.path.expandvars('/home/lindsayad/bolos/')
# f = D_Path + "td_argon_mean_en.txt"
# with open(f,'w') as write_file:
#     for i in range(0,nEf):
#         write_file.write('{0:.18e} {1:.18e} {2:.18e} {3:.18e} {4:.18e} {5:.18e}\n'.format(mean_energy[i], alpha[i], alphaEx[i], alphaEl[i], mu[i], Diff[i]))
#     write_file.closed
