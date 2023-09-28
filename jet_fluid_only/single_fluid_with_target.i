[GlobalParams]
  integrate_p_by_parts = false
[]

[Mesh]
  file = 'cost_jet_half.msh'
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

  # [momentum_time_derivative]
  #   type = INSADMomentumTimeDerivative
  #   variable = velocity
  #   block = 'plasma'
  # []

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

# [ICs]
#   [pressure]
#     type = ConstantIC
#     variable = p
#     value = 101325
#     block = 'plasma'
#   []

#   [velocity]
#     type = VectorFunctionIC
#     variable = velocity
#     function_x = 0
#     function_y = channel_func
#     block = 'plasma'
#   []
# []
[BCs]
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
    boundary = 'axis_of_symmetry'
  []

  [wall]
    type = VectorFunctionDirichletBC
    variable = velocity
    boundary = 'electrode target upper_atmosphere atmosphere'
    function_x = 0
    function_y = 0
  []

  [pressure_condition]
    type = PenaltyDirichletBC
    variable = p
    boundary = 'atmosphere upper_atmosphere'
    value = 101325
    penalty = 1e5
  []
[]

[Functions]
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
    value = '-rad_eff'
  []

  [inlet_r_end]
    type = ParsedFunction
    symbol_names = 'rad_eff'
    symbol_values = 'rad_eff'
    value = 'rad_eff'
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
    expression = 'if (x > inlet_r_start & x < inlet_r_end,
                  inlet_func,
                  0)'
  []
[]

[Materials]
  [fluid_mats]
    type = ADGenericConstantMaterial
    prop_names = 'rho mu cp k'
    prop_values = '0.1598 1.9e-5 1 1'
    block = 'plasma'
  []

  # [ins_mat]
  #   type = INSADMaterial
  #   velocity = velocity
  #   pressure = p
  # []
  #   block = 'plasma'

  [ins_mat]
    type = INSADTauMaterial
    velocity = velocity
    pressure = p
    block = 'plasma'
    alpha = 1
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
  nl_max_its = 100
  automatic_scaling = true
  compute_scaling_once = false
  # line_search = none
[]

# [Executioner]
#   type = Transient
#   solve_type = NEWTON
#   petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
#   petsc_options_value = 'lu NONZERO 1.e-10'
#   line_search = none

#   nl_abs_tol = 2e-8
#   nl_max_its = 15

#   l_max_its = 300
#   [TimeStepper]
#     type = IterationAdaptiveDT
#     cutback_factor = 0.4
#     dt = 1e-8
#     growth_factor = 1.2
#     optimal_iterations = 10
#   []
#   steady_state_detection = true
#   # steady_state_tolerance = 1e-3
#   automatic_scaling = true
#   compute_scaling_once = false
# []

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
