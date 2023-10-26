[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 8
  xmin = 0
  xmax = 1
[]

[Variables]
  [n]
  []
[]

[Kernels]
  # Diffusion must be added for the sake of numeric stability FEM cannot handle advection all on its own
  [density_advection]
    type = BackgroundFluxVector
    variable = n
    velocity = '1 0 0'
  []

  [diffusion]
    type = CoeffDiffusion
    variable = n
    position_units = 1.0
  []

  [force]
    type = BodyForce
    variable = n
    function = force
  []
[]

[Functions]
  [diffn]
    type = ConstantFunction
    value = 1.0
  []
  [exact]
    type = ParsedFunction
    value = 'log(0.25*cos(2*x*pi) + 1)'
  []
  [force]
    type = ParsedFunction
    value = '-0.5*pi*sin(2*x*pi) + 1.0*pi^2*cos(2*x*pi)'
  []
[]

[BCs]
  [all]
    type = FunctionDirichletBC
    variable = n
    function = exact
    boundary = 'left right'
  []
[]

[Materials]
  [Material_Coeff]
    type = ADGenericFunctionMaterial
    prop_names = 'diffn'
    prop_values = 'diffn'
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
    variable = n
    function = exact
  []
  [h]
    type = AverageElementSize
  []
[]

[Outputs]
  exodus = true
  csv = true
[]
