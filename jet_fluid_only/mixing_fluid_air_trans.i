[GlobalParams]
  integrate_p_by_parts = true
[]

[Mesh]
  file = 'mixing_fluid_air_trans_ic.e'
  second_order = true
[]

[Problem]
  coord_type = RZ
  rz_coord_axis = Y
[]

[Variables]
  [velocity]
    order = SECOND
    family = LAGRANGE_VEC
    block = 'plasma'
  []

  [p]
    initial_from_file_var = 'p'
    order = SECOND
    family = LAGRANGE
    block = 'plasma'
  []

  # Mass Fraction of He
  [w_he]
    initial_from_file_var = 'w_he'
    order = SECOND
    family = LAGRANGE
    block = 'plasma'
  []
[]

[Kernels]
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

  [bouyancy_force]
    type = INSADGravityForce
    variable = velocity
    gravity = '0 -9.81 0'
  []
[]

[AuxVariables]
  [vel_x]
    order = SECOND
    block = 'plasma'
    initial_from_file_var = vel_x
  []
  [vel_y]
    order = SECOND
    block = 'plasma'
    initial_from_file_var = vel_y
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
    boundary = 'upper_atmosphere lower_atmosphere'
    value = 0
    preset = false
  []

  [inlet]
    type = VectorFunctionDirichletBC
    variable = velocity
    boundary = 'inlet'
    function_x = 0
    function_y = 'inlet_func'
    # preset = false
  []

  [wall]
    type = VectorFunctionDirichletBC
    variable = velocity
    boundary = 'quartz_boundary electrode_wall electrode_tip inner_quartz_boundary target upper_atmosphere lower_atmosphere'
    function_x = 0
    function_y = 0
    # preset = false
  []

  [outlet]
    type = INSADMomentumNoBCBC
    variable = velocity
    pressure = p
    boundary = 'upper_axis_of_symmetry axis_of_symmetry'
  []

  [pressure_condition]
    type = DirichletBC
    variable = p
    boundary = 'upper_atmosphere lower_atmosphere'
    value = 101325
    preset = false
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

  # [w_he_ic]
  #   type = BoundingBoxIC
  #   variable = w_he
  #   x1 = 0
  #   x2 = 1.2e-3
  #   y1 = 7e-3
  #   y2 = 21e-3
  #   inside = 1
  #   outside = 0
  #   int_width = 0.25e-3
  # []

  [w_he_ic]
    type = FunctionIC
    variable = w_he
    function = 'if (x < 1.25e-3 & y > 4.1e-3,
                    1,
                    (0.5 - 0.5 * tanh(9750 * x - 12.5)) * (0.5 + 0.5 * tanh(1500 * y  - 3))
                    )'
    block = 'plasma'
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

  [max_vel]
    type = ParsedFunction
    value = '8.5'
  []

  [inlet_r_start]
    type = ParsedFunction
    value = '0.5 / 1000'
  []

  [inlet_r_end]
    type = ParsedFunction
    value = '1 / 1000'
  []

  [inlet_r_center]
    type = ParsedFunction
    vars = 'inlet_r_start inlet_r_end'
    vals = 'inlet_r_start inlet_r_end'
    value = '( inlet_r_start + inlet_r_end ) / 2'
  []

  [inlet_func]
    type = ParsedFunction
    vars = 'inlet_r_start inlet_r_end inlet_r_center max_vel'
    vals = 'inlet_r_start inlet_r_end inlet_r_center max_vel'
    value = '-max_vel * ( ( x - inlet_r_start ) * ( x - inlet_r_end ) / ( ( inlet_r_center - inlet_r_start ) * ( inlet_r_center - inlet_r_end ) ) )'
  []
[]

[Materials]
  # Material Property from https://www.engineeringtoolbox.com/air-diffusion-coefficient-gas-mixture-temperature-d_2010.html
  # [mass_frac_mat]
  #   type = ADParsedMaterial
  #   property_name = 'D'
  #   coupled_variables = 'w_he'
  #   # constant_names = 'rho_he rho_air rho_nitrogen rho_oxygen D_he_air'
  #   # constant_expressions = '0.1598  1.293 1.126 1.283 0.697e-4'
  #   # expression = 'D_he_air * (w_he * rho_he + ( 1 - w_he ) * (rho_nitrogen * 0.8 + rho_oxygen * 0.2))'
  #   constant_names = 'D_he_air'
  #   constant_expressions = '7.2e-5'
  #   expression = 'D_he_air'
  #   block = 'plasma'
  # []
  # Diffusion Coefficient from
  # https://iopscience.iop.org/article/10.1088/0963-0252/23/3/035007/pdf
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

  [ins_mat]
    type = INSADMaterial
    velocity = velocity
    pressure = p
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

[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'lu NONZERO 1.e-10'
  line_search = none

  nl_abs_tol = 1e-8
  nl_max_its = 15

  l_max_its = 300
  [TimeStepper]
    type = IterationAdaptiveDT
    cutback_factor = 0.4
    dt = 1e-8
    growth_factor = 1.2
    optimal_iterations = 10
  []
  steady_state_detection = true
  # steady_state_tolerance = 1e-3
  automatic_scaling = true
  compute_scaling_once = false
[]

[UserObjects]
  [soln]
    type = SolutionUserObject
    mesh = 'single_fluid_with_plate_out.e'
    system_variables = 'p vel_x vel_y'
  []
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
