[GlobalParams]
  integrate_p_by_parts = true
[]

[Mesh]
  file = 'jet_mesh.msh'
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
    order = SECOND
    family = LAGRANGE
    block = 'plasma'
  []

  # [dummy_quartz]
  #   block = 'quartz'
  # []
[]

[Kernels]
  # [do_nothing_quartz]
  #   type = NullKernel
  #   variable = dummy_quartz
  #   block = 'quartz'
  # []

  [mass]
    type = INSADMass
    variable = p
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
[]

[AuxVariables]
  [vel_x]
    order = SECOND
    block = 'plasma'
  []
  [vel_y]
    order = SECOND
    block = 'plasma'
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

[BCs]
  [inlet]
    type = VectorFunctionDirichletBC
    variable = velocity
    boundary = 'inlet'
    function_x = 0
    function_y = 'inlet_func'
  []

  [wall]
    type = VectorFunctionDirichletBC
    variable = velocity
    boundary = 'quartz_boundary electrode_boundary inner_quartz_boundary'
    function_x = 0
    function_y = 0
  []

  [outlet]
    type = INSADMomentumNoBCBC
    variable = velocity
    pressure = p
    boundary = 'axis_of_symmetry atmosphere target upper_atmosphere'
  []

  [pressure_condition]
    type = DirichletBC
    variable = p
    boundary = 'atmosphere target upper_atmosphere'
    value = 101325
    preset = false
  []
[]

[Functions]
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
    value = 'max_vel * ( ( x - inlet_r_start ) * ( x - inlet_r_end ) / ( ( inlet_r_center - inlet_r_start ) * ( inlet_r_center - inlet_r_end ) ) )'
  []
[]

[Materials]
  # [dummy_quartz]
  #   type = ADGenericConstantMaterial
  #   prop_names = 'do_nothing_quatz'
  #   prop_values = 0.0
  #   block = 'quartz'
  # []

  [fluid_mats]
    type = ADGenericConstantMaterial
    prop_names = 'rho mu'
    prop_values = '0.1598 1.9e-5'
    block = 'plasma'
  []
  # [effective_density]
  #   type = ParsedMaterial
  #   # property_name = 'rho'
  #   f_name = 'rho'
  #   coupled_variables = 'm_he'
  #   constant_names = 'rho_he rho_air'
  #   constant_expressions = '0.1598 0.1598'
  #   function = 'm_he * rho_he + ( 1 - m_he ) * rho_air'
  #   block = 'plasma'
  # []

  # [effective_viscosity]
  #   type = ParsedMaterial
  #   property_name = 'mu'
  #   coupled_variables = 'm_he'
  #   constant_names = 'mu_he mu_air'
  #   constant_expressions = '1.9e-5 1.9e-5'
  #   expression = 'm_he * mu_he + ( 1 - m_he ) * mu_air'
  #   block = 'plasma'
  # []

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
  type = Steady
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'lu NONZERO 1.e-10'
  # nl_rel_tol = 1e-7
  nl_max_its = 50
  automatic_scaling = true
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
