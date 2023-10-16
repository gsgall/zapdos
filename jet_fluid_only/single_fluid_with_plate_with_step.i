[GlobalParams]
  integrate_p_by_parts = true
[]

[Mesh]
  file = 'jet_mesh_with_step.msh'
  second_order = true
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
[]

[Kernels]
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
    family = LAGRANGE
    block = 'plasma'
  []
  [vel_y]
    order = SECOND
    family = LAGRANGE
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
    boundary = 'quartz_boundary electrode_wall electrode_tip target side_atmosphere lower_atmosphere  upper_atmosphere'
    function_x = 0
    function_y = 0
  []

  [outlet]
    type = INSADMomentumNoBCBC
    variable = velocity
    pressure = p
    boundary = 'axis_of_symmetry'
  []

  [pressure_condition]
    type = PenaltyDirichletBC
    variable = p
    boundary = 'upper_atmosphere lower_atmosphere side_atmosphere'
    value = 101325
    penalty = 1e5
  []
[]

[Functions]
  [max_vel]
    type = ParsedFunction
    expression = '8.5'
  []

  [inlet_r_start]
    type = ParsedFunction
    expression = '0.5 / 1000'
  []

  [inlet_r_end]
    type = ParsedFunction
    expression = '1 / 1000'
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
[]

[Materials]
  [fluid_mats]
    type = ADGenericConstantMaterial
    prop_names = 'rho mu'
    prop_values = '0.1598 1.9e-5'
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
  type = Steady
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'lu NONZERO 1.e-10'
  nl_max_its = 50
  nl_rel_tol = 5e-08
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
