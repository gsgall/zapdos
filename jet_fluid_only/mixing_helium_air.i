pressure = 101325
helium_fraction = 0.0000

[GlobalParams]
  integrate_p_by_parts = false
[]

[Mesh]
  file = 'single_fluid_with_target_out.e'
  second_order = true
  rz_coord_axis = Y
  coord_type = RZ
[]

[Variables]
  [velocity]
    order = SECOND
    family = LAGRANGE_VEC
    block = 'plasma'
  []

  [p]
    initial_from_file_var = 'p'
    order = FIRST
    family = LAGRANGE
    block = 'plasma'
  []

  # [lambda]
  #   # initial_from_file_var = 'lambda'
  #   family = SCALAR
  #   order = FIRST
  # []

  [w_he]
    # initial_from_file_var = 'w_he'
    order = FIRST
    family = LAGRANGE
    block = 'plasma'
  []
[]

[Kernels]
  # [mean_zero_pressure]
  #   type = ScalarLagrangeMultiplier
  #   variable = p
  #   lambda = lambda
  # []

  [w_he_time]
    type = ADTimeDerivative
    variable = w_he
    block = 'plasma'
  []

  [w_he_diffusion]
    type = ADMatDiffusion
    variable = w_he
    diffusivity = 'D'
    block = 'plasma'
  []

  [w_he_advection]
    type = ConservativeAdvection
    variable = w_he
    velocity = velocity
  []

  [mass]
    type = INSADMass
    variable = p
    block = 'plasma'
  []

  [momentum_time_derivative]
    type = INSADMomentumTimeDerivative
    variable = velocity
    block = 'plasma'
  []

  [momentum_convection]
    type = INSADMomentumAdvection
    variable = velocity
    block = 'plasma'
  []

  [momentum_viscous]
    type = INSADMomentumViscous
    variable = velocity
    block = 'plasma'
  []

  [momentum_pressure]
    type = INSADMomentumPressure
    variable = velocity
    pressure = p
    block = 'plasma'
  []

  [supg]
    type = INSADMomentumSUPG
    variable = velocity
    velocity = velocity
    block = 'plasma'
  []
  # [gravity]
  #   type = INSADGravityForce
  #   variable = velocity
  #   gravity = '0 -9.81 0'
  # []
[]

# [ScalarKernels]
#   [mean_zero_pressure_lm]
#     type = AverageValueConstraint
#     variable = lambda
#     pp_name = pressure_integral
#     value = 0
#   []
# []

[AuxVariables]
  [vel_x]
    order = SECOND
    block = 'plasma'
    initial_from_file_var = 'vel_x'
  []
  [vel_y]
    order = SECOND
    block = 'plasma'
    initial_from_file_var = 'vel_y'
  []
[]

[AuxKernels]
  [vel_x]
    type = VectorVariableComponentAux
    variable = vel_x
    vector_variable = velocity
    component = 'x'
  []
  [vel_y]
    type = VectorVariableComponentAux
    variable = vel_y
    vector_variable = velocity
    component = 'y'
  []
[]

[ICs]
  [velocity_ic]
    type = CoupledVectorValueFunctionIC
    variable = velocity
    v = 'vel_x vel_y'
    function_x = 'vel_x_ic'
    function_y = 'vel_y_ic'
    function_z = 'vel_z_ic'
  []

  [w_he]
    type = FunctionIC
    variable = w_he
    function = w_he_ic
    block = 'plasma'
  []
[]

[BCs]
  [w_he_inlet]
    type = DirichletBC
    boundary = 'inlet'
    variable = w_he
    value = 1
    preset = false
  []

  [w_he_atmosphere]
    type = DirichletBC
    variable = w_he
    boundary = 'atmosphere'
    value = ${helium_fraction}
    preset = false
  []

  [inlet]
    type = VectorFunctionDirichletBC
    variable = velocity
    boundary = 'inlet'
    function_x = 0
    function_y = 'inlet_func'
  []

  [no_bc]
    type = INSADMomentumNoBCBC
    variable = velocity
    pressure = p
    boundary = 'axis_of_symmetry atmosphere'
  []

  [no_slip]
    type = VectorFunctionDirichletBC
    variable = velocity
    boundary = 'electrode target'
    function_x = 0
    function_y = 0
  []

  [pressure_pin]
    type = DirichletBC
    variable = p
    boundary = 'pressure_pin'
    value = ${pressure}
    preset = false
  []
[]

[Functions]
  [vel_x_ic]
    type = ParsedFunction
    expression = 'x'
  []

  [vel_y_ic]
    type = ParsedFunction
    expression = 'y'
  []

  [vel_z_ic]
    type = ParsedFunction
    expression = '0'
  []

  # convert flow rate to m^3/s
  [flow_rate_m3_s]
    type = ParsedFunction
    # flow rate in slm
    # other dimensions in m
    symbol_names = 'flow_rate mins_to_sec l_to_m3'
    symbol_values = '1.0      60          1e3'
    expression = 'flow_rate / (l_to_m3 * mins_to_sec)'
  []

  [rad_eff]
    type = ParsedFunction
    symbol_names = 'channel_width channel_depth'
    symbol_values = '1e-3 1e-3'
    expression = 'sqrt( channel_width * channel_depth / pi )'
  []
  # converting volumetric flow rate to velocity using
  # cross sectional area
  [max_vel]
    type = ParsedFunction
    symbol_names = 'flow_rate       channel_width channel_depth'
    symbol_values = 'flow_rate_m3_s 1e-3          1e-3'
    expression = 'flow_rate / (channel_width * channel_depth)'
  []

  [inlet_r_start]
    type = ParsedFunction
    symbol_names = 'rad_eff'
    symbol_values = 'rad_eff'
    expression = '-rad_eff'
  []

  [inlet_r_end]
    type = ParsedFunction
    symbol_names = 'rad_eff'
    symbol_values = 'rad_eff'
    expression = 'rad_eff'
  []

  [inlet_r_center]
    type = ParsedFunction
    symbol_names = 'inlet_r_start inlet_r_end'
    symbol_values = 'inlet_r_start inlet_r_end'
    expression = '( inlet_r_start + inlet_r_end ) / 2'
  []

  [inlet_func]
    type = ParsedFunction
    symbol_names = 'inlet_r_start inlet_r_end inlet_r_center max_vel'
    symbol_values = 'inlet_r_start inlet_r_end inlet_r_center max_vel'
    expression = '-max_vel * ( ( x - inlet_r_start ) * ( x - inlet_r_end ) / ( ( inlet_r_center - inlet_r_start ) * ( inlet_r_center - inlet_r_end ) ) )'
  []

  [channel_func]
    type = ParsedFunction
    symbol_names = 'inlet_func inlet_r_end inlet_r_start'
    symbol_values = 'inlet_func inlet_r_end inlet_r_start'
    expression = 'if (x > inlet_r_start & x < inlet_r_end & y > 0,
                  inlet_func,
                  0)'
  []

  [w_he_ic]
    type = ParsedFunction
    symbol_names = 'inlet_func inlet_r_end inlet_r_start'
    symbol_values = 'inlet_func inlet_r_end inlet_r_start'
    expression = 'if (x > inlet_r_start & x < inlet_r_end + 1e-4,
                  1,
                  ${helium_fraction})'
  []
[]

[Materials]
  [ins_mat]
    type = INSADTauMaterial
    velocity = velocity
    pressure = p
    block = 'plasma'
    alpha = 1
  []
  # helium material properties
  # Diffusion coefficient from https://iopscience.iop.org/article/10.1088/0963-0252/23/3/035007/pdf
  [diffusion_coeff]
    type = ADGenericConstantMaterial
    prop_names = 'D'
    prop_values = '7.2e-5'
  []

  # air density from https://www.earthdata.nasa.gov/topics/atmosphere/atmospheric-pressure/air-mass-density#:~:text=Pure%2C%20dry%20air%20has%20a,a%20pressure%20of%20101.325%20kPa.
  # helium density from https://www.engineeringtoolbox.com/helium-density-specific-weight-temperature-pressure-d_2090.html
  # nitrogen density from https://www.engineeringtoolbox.com/nitrogen-N2-density-specific-weight-temperature-pressure-d_2039.html
  # Gas Temperature assumed to be 300K
  [effective_density]
    type = ADParsedMaterial
    property_name = 'rho'
    coupled_variables = 'w_he'
    constant_names = 'rho_he rho_air rho_nitrogen rho_oxygen'
    constant_expressions = '0.1598  1.293 1.126 1.283'
    expression = 'w_he * rho_he + ( 1 - w_he ) * (rho_nitrogen * 0.8 + rho_oxygen * 0.2)'
    block = 'plasma'
  []
  # viscosities from https://www.engineeringtoolbox.com/gases-absolute-dynamic-viscosity-d_1888.html
  # Gas Temperature Assumed to be 20 C
  [effective_viscosity]
    type = ADParsedMaterial
    property_name = 'mu'
    coupled_variables = 'w_he'
    constant_names = 'mu_he mu_air mu_nitrogen mu_oxygen'
    constant_expressions = '1.96e-5 1.82e-5 1.76e-5 2.04e-5'
    expression = 'w_he * mu_he + ( 1 - w_he ) * (mu_nitrogen * 0.8 + mu_oxygen * 0.2)'
    block = 'plasma'
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  []
[]

# [Postprocessors]
#   [pressure_integral]
#     type = ElementIntegralVariablePostprocessor
#     variable = p
#     execute_on = linear
#   []
# []

[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -pc_factor_mat_solver'
  petsc_options_value = 'lu NONZERO 1.e-10 superlu_dists'
  # petsc_options_value = 'lu NONZERO 1.e-7 mumps'
  # petsc_options_value = 'lu NONZERO 1.e-7 strumpack'
  line_search = 'none'
  # scheme = newmark-beta
  nl_abs_tol = 2e-8
  nl_max_its = 15
  # l_tol = 1e-06
  l_max_its = 300
  [TimeStepper]
    type = IterationAdaptiveDT
    cutback_factor = 0.4
    dt = 1e-8
    growth_factor = 1.2
    optimal_iterations = 10
  []
  steady_state_detection = true
  steady_state_tolerance = 1e-07
  # off_diagonals_in_auto_scaling = true
  automatic_scaling = true
  compute_scaling_once = false

  # dtmax = 1e-3
[]

[Outputs]
  console = true
  [out]
    type = Exodus
  []

  [out_nl]
    type = Exodus
    execute_on = 'NONLINEAR'
  []

  [out_l]
    type = Exodus
    execute_on = 'LINEAR'
  []
[]
