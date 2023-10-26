mu = 1.5
rho = 2.5

[GlobalParams]
  gravity = '0 0 0'
  pspg = true
  convective_term = true
  integrate_p_by_parts = true
  laplace = true
  u = vel_x
  v = vel_y
  pressure = p
  alpha = 1e-6
  order = FIRST
  family = LAGRANGE
[]

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 1.0
    ymin = 0
    ymax = 1.0
    elem_type = QUAD9
    nx = 4
    ny = 4
  []
  [corner_node]
    type = ExtraNodesetGenerator
    new_boundary = 'pinned_node'
    nodes = '0'
    input = gen
  []
[]

[Variables]
  [vel_x]
  []

  [vel_y]
  []

  [p]
  []
[]

[Kernels]
  # mass
  [mass]
    type = INSMass
    variable = p
    x_vel_forcing_func = vel_x_charge_source
    y_vel_forcing_func = vel_y_charge_source
  []

  [x_momentum_time]
    type = INSMomentumTimeDerivative
    variable = vel_x
    component = 0
  []

  # x-momentum, space
  [x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_x
    component = 0
    forcing_func = vel_x_charge_source
  []

  [x_momentum_charge_transfer]
    type = ChargeMomentumTransfer
    variable = vel_x
    component = 0
    charge = 1.0
    potential = potential
    species = ion
  []

  [y_momentum_time]
    type = INSMomentumTimeDerivative
    variable = vel_y
    component = 1
  []

  # y-momentum, space
  [y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_y
    component = 1
    forcing_func = vel_y_charge_source
  []

  [y_momentum_charge_transfer]
    type = ChargeMomentumTransfer
    variable = vel_y
    component = 1
    charge = 1.0
    potential = potential
    species = ion
  []

  [p_source]
    type = BodyForce
    function = p_source_func
    variable = p
  []
[]

[BCs]
  [vel_x]
    type = FunctionDirichletBC
    boundary = 'left right top bottom'
    function = vel_x_func
    variable = vel_x
  []
  [vel_y]
    type = FunctionDirichletBC
    boundary = 'left right top bottom'
    function = vel_y_func
    variable = vel_y
  []
  [p]
    type = FunctionDirichletBC
    boundary = 'left right top bottom'
    function = p_func
    variable = p
  []
[]

[ICs]
  [vel_x]
    type = FunctionIC
    function = vel_x_func
    variable = vel_x
  []
  [vel_y]
    type = FunctionIC
    function = vel_y_func
    variable = vel_y
  []
  [p]
    type = FunctionIC
    function = p_func
    variable = p
  []

[]

[AuxVariables]
  [ion]
  []

  [potential]
  []
[]

[AuxKernels]
  [ion_val]
    type = FunctionAux
    variable = ion
    function = ion_fun
  []

  [potential_val]
    type = FunctionAux
    variable = potential
    function = potential_fun
  []
[]

[Functions]
  [vel_x_charge_source]
    type = ParsedFunction
    vars = 'vel_x_source_func'
    vals = 'vel_x_source_func'
    value = 'vel_x_source_func + y*pi*cos(x*y*pi)'
  []

  [vel_y_charge_source]
    type = ParsedFunction
    vars = 'vel_y_source_func'
    vals = 'vel_y_source_func'
    value = 'vel_y_source_func + x*pi*cos(x*y*pi)'
  []

  [vel_x_source_func]
    type = ParsedFunction
    value = '-${mu}*(-0.028*pi^2*x^2*sin(0.2*pi*x*y) - 0.028*pi^2*y^2*sin(0.2*pi*x*y) - 0.1*pi^2*sin(0.5*pi*x) - 0.4*pi^2*sin(pi*y)) + ${rho}*(0.14*pi*x*cos(0.2*pi*x*y) + 0.4*pi*cos(pi*y))*(0.6*sin(0.8*pi*x) + 0.3*sin(0.3*pi*y) + 0.2*sin(0.3*pi*x*y) + 0.3) + ${rho}*(0.14*pi*y*cos(0.2*pi*x*y) + 0.2*pi*cos(0.5*pi*x))*(0.4*sin(0.5*pi*x) + 0.4*sin(pi*y) + 0.7*sin(0.2*pi*x*y) + 0.5) + 0.1*pi*y*cos(0.2*pi*x*y) + 0.25*pi*cos(0.5*pi*x)'
  []
  [vel_y_source_func]
    type = ParsedFunction
    value = '-${mu}*(-0.018*pi^2*x^2*sin(0.3*pi*x*y) - 0.018*pi^2*y^2*sin(0.3*pi*x*y) - 0.384*pi^2*sin(0.8*pi*x) - 0.027*pi^2*sin(0.3*pi*y)) + ${rho}*(0.06*pi*x*cos(0.3*pi*x*y) + 0.09*pi*cos(0.3*pi*y))*(0.6*sin(0.8*pi*x) + 0.3*sin(0.3*pi*y) + 0.2*sin(0.3*pi*x*y) + 0.3) + ${rho}*(0.06*pi*y*cos(0.3*pi*x*y) + 0.48*pi*cos(0.8*pi*x))*(0.4*sin(0.5*pi*x) + 0.4*sin(pi*y) + 0.7*sin(0.2*pi*x*y) + 0.5) + 0.1*pi*x*cos(0.2*pi*x*y) + 0.3*pi*cos(0.3*pi*y)'
  []
  [p_source_func]
    type = ParsedFunction
    value = '-0.06*pi*x*cos(0.3*pi*x*y) - 0.14*pi*y*cos(0.2*pi*x*y) - 0.2*pi*cos(0.5*pi*x) - 0.09*pi*cos(0.3*pi*y)'
  []
  [vel_x_func]
    type = ParsedFunction
    value = '0.4*sin(0.5*pi*x) + 0.4*sin(pi*y) + 0.7*sin(0.2*pi*x*y) + 0.5'
  []
  [vel_y_func]
    type = ParsedFunction
    value = '0.6*sin(0.8*pi*x) + 0.3*sin(0.3*pi*y) + 0.2*sin(0.3*pi*x*y) + 0.3'
  []
  [p_func]
    type = ParsedFunction
    value = '0.5*sin(0.5*pi*x) + 1.0*sin(0.3*pi*y) + 0.5*sin(0.2*pi*x*y) + 0.5'
  []
  [vxx_func]
    type = ParsedFunction
    value = '0.14*pi*y*cos(0.2*pi*x*y) + 0.2*pi*cos(0.5*pi*x)'
  []
  [px_func]
    type = ParsedFunction
    value = '0.1*pi*y*cos(0.2*pi*x*y) + 0.25*pi*cos(0.5*pi*x)'
  []

  [ion_fun]
    type = ParsedFunction
    vars = 'N_A x_max y_max f'
    vals = 'N_A x_max y_max f'
    value = 'log((sin(pi*(y/y_max)) + 1.0 + 0.9*cos(pi/2*(x/x_max))) / N_A)'
  []
  #The manufactured electron density solution
  [potential_fun]
    type = ParsedFunction
    vars = 'ee diffpotential x_max y_max f'
    vals = 'ee diffpotential x_max y_max f'
    value = '-(ee*(2*x_max^2*cos((pi*x)/(2*x_max)) + y_max^2*cos((pi*y)/y_max)*sin(2*pi*f*t)))/(5*diffpotential*pi^2)'
  []

  #Scaling factors to scale the known solutios to a mesh
  [x_max]
    type = ConstantFunction
    value = 1.0
  []

  [y_max]
    type = ConstantFunction
    value = 1.0
  []

  #The frequency of oscillation
  [f]
    type = ConstantFunction
    value = 1.0
  []
  #Elementary Charge
  [ee]
    type = ConstantFunction
    value = 1.0
  []
  #Permittivity of Free Space - "Potential diffusion coeff."
  [diffpotential]
    type = ConstantFunction
    value = 0.01
  []

  [N_A]
    type = ParsedFunction
    value = '6.022e23'
  []

[]

[Materials]
  [const]
    type = GenericFunctionMaterial
    prop_names = 'N_A'
    prop_values = 'N_A'
  []

  [const]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'rho mu'
    prop_values = '${rho}  ${mu}'
  []
[]

[Preconditioning]
  active = 'smp'
  [smp]
    type = SMP
    full = true
  []

  [fdp]
    type = FDP
    full = true
  []
[]

[Executioner]
  type = Transient
  start_time = 0
  end_time = 51
  #dt = 0.05
  #dt = 0.025
  dt = 0.01
  #dt = 0.008
  #dt = 0.005
  automatic_scaling = true
  compute_scaling_once = false
  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  solve_type = NEWTON
  line_search = none
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'lu NONZERO 1.e-10'
  scheme = bdf2
  nl_abs_tol = 1e-8
[]

[Postprocessors]
  [vel_x_l2Error]
    type = ElementL2Error
    variable = vel_x
    function = vel_x_func
  []

  [vel_y_l2Error]
    type = ElementL2Error
    variable = vel_y
    function = vel_y_func
  []

  [p_l2Error]
    type = ElementL2Error
    variable = p
    function = p_func
  []

  [h]
    type = AverageElementSize
  []
[]

[Outputs]
  csv = true
[]
