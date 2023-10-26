[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 8
  xmin = 0
  xmax = 1
[]

[Variables]
  [ion]
  []
[]

[Kernels]
  # Diffusion must be added for the sake of numeric stability FEM cannot handle advection all on its own
  [ion_v_advection]
    type = BackgroundFluxScalar
    variable = ion
    u = 1
    v = 0
  []

  [ion_diffusion]
    type = CoeffDiffusion
    variable = ion
    position_units = 1.0
  []

  [ion_force]
    type = BodyForce
    variable = ion
    function = ion_force
  []
[]

[Functions]
  [diffion]
    type = ConstantFunction
    value = 1.0
  []
  [ion_exact]
    type = ParsedFunction
    value = 'log(0.25*cos(2*x*pi) + 1)'
  []
  [ion_force]
    type = ParsedFunction
    value = '-0.5*pi*sin(2*x*pi) + 1.0*pi^2*cos(2*x*pi)'
  []
[]

[BCs]
  [all]
    type = FunctionDirichletBC
    variable = ion
    function = ion_exact
    boundary = 'left right'
  []
[]

[Materials]
  [Material_Coeff]
    type = ADGenericFunctionMaterial
    prop_names = 'diffion'
    prop_values = 'diffion'
  []
[]

[Executioner]
  type = Steady
  automatic_scaling = true
  compute_scaling_once = false
  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  solve_type = 'NEWTON'
  line_search = none
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'lu NONZERO 1.e-10'
[]

[Postprocessors]
  [error]
    type = ElementL2Error
    variable = ion
    function = ion_exact
  []
  [h]
    type = AverageElementSize
  []
[]

[Outputs]
  exodus = true
  csv = true
[]
