[GlobalParams]
  integrate_p_by_parts = true
[]

[Mesh]
  file = 'jet_mesh.msh'
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

  [bouyancy_force]
    type = INSADGravityForce
    variable = velocity
    gravity = '0 -9.81 0'
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
    boundary = 'quartz_boundary electrode_wall electrode_tip inner_quartz_boundary target lower_atmosphere upper_atmosphere'
    function_x = 0
    function_y = 0
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

[Functions]
  [max_vel]
    type = ParsedFunction
    value = '8.4'
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
