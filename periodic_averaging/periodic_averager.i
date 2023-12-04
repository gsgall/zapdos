# dom0Scale = 25.4e-3

[Mesh]
  file = 'Lymberopoulos_paper.msh'
[]

[Problem]
  type = FEProblem
[]

[Variables]
  [u]
  []
[]

[Kernels]
  [null_kernel]
    type = NullKernel
    variable = u
  []
[]

[AuxVariables]
  [v]
  []
[]

[AuxKernels]
  [func_kernel]
    type = FunctionAux
    variable = v
    function = ic
  []
[]

[Functions]
  [ic]
    type = ParsedFunction
    expression = '-4 * x * (x-1)'
  []
[]


[PeriodicControllers]
  [Shooting]
    starting_cycle = 0
    cycle_frequency = 0.1
    cycles_between_controls = 0
    num_controller_set = 2000
    name = Shooting
  []
[]




[Postprocessors]
  [a]
    type = ElementIntegralVariablePostprocessor
    variable = v
    execute_on = 'initial timestep_end'
  []

  [periodic_a]
    type = PeriodicTimeIntegratedPostprocessor
    value = a
    cycle_frequency = 0.1
    execute_on = 'initial timestep_end'
  []

  [mean_a]
    type = MultiplicationPostprocessor
    value = periodic_a
    coeff = 0.1
    execute_on = 'timestep_end'
  []
[]


[Executioner]
  type = Transient
  end_time = 100
  start_time = -2e-2
  dt = 1e-2
  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda'
  petsc_options_value = 'lu NONZERO 1.e-10 fgmres 1e-3'
  solve_type = NEWTON
  line_search = 'none'
[]

[Outputs]
  # perf_graph = true
  [out]
    type = Exodus
  []
  csv = true
[]
