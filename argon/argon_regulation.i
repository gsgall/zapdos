
dom0Scale = 25.4e-3

[GlobalParams]
  potential_units = kV
  use_moles = true
  cycle_frequency = 13.56e6
[]

[Mesh]
  [geo]
    type = FileMeshGenerator
    file = 'argon_base_out.e'
  []
  [left]
    type = SideSetsFromNormalsGenerator
    normals = '-1 0 0'
    new_boundary = 'left'
    input = geo
  []
  [right]
    type = SideSetsFromNormalsGenerator
    normals = '1 0 0'
    new_boundary = 'right'
    input = left
  []
[]

[Problem]
  type = FEProblem
[]

[DriftDiffusionAction]
  [Plasma]
    electrons = em
    charged_particle = Ar+
    Neutrals = Ar*
    potential = potential
    Is_potential_unique = true
    mean_energy = mean_en
    position_units = ${dom0Scale}
    Additional_Outputs = 'ElectronTemperature Current EField'
  []
[]

[Reactions]
  [Argon]
    name = 'test'
    species = 'em Ar+ Ar*'
    aux_species = 'Ar'
    reaction_coefficient_format = 'rate'
    gas_species = 'Ar'
    electron_energy = 'mean_en'
    electron_density = 'em'
    include_electrons = true
    file_location = 'reactions'
    potential = 'potential'
    use_log = true
    use_ad = false
    track_rates = true
    position_units = ${dom0Scale}
    block = 0
    convert_to_moles = true
    reactions = 'em + Ar -> em + Ar         : EEDF [elastic] (reaction0)
                 em + Ar -> em + Ar*        : EEDF [-11.56]  (reaction1)
                 em + Ar -> em + em + Ar+   : EEDF [-15.7]   (reaction2)
                 em + Ar* -> em + em + Ar+  : EEDF [-4.14]   (reaction3)'
  []
[]
[AuxVariables]
  [x_node]
  []

  [Ar]
  []

  [e_power]
    order = CONSTANT
    family = MONOMIAL
  []

  [Ar_ion_power]
    order = CONSTANT
    family = MONOMIAL
  []

  [total_power]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [x_ng]
    type = Position
    variable = x_node
    position_units = ${dom0Scale}
  []

  [Ar_val]
    type = FunctionAux
    variable = Ar
    function = 'log(3.22e22/6.022e23)'
    execute_on = INITIAL
  []

  [em_powerdep]
    type = ADPowerDep
    variable = e_power
    potential = potential
    density_log = em
    position_units = ${dom0Scale}
  []

  [Ar+_powerdep]
    type = ADPowerDep
    variable = Ar_ion_power
    potential = potential
    density_log = Ar+
    position_units = ${dom0Scale}
  []

  [total_powerdep]
    type = ParsedAux
    variable = total_power
    coupled_variables = 'e_power Ar_ion_power'
    expression = 'e_power + Ar_ion_power'
  []
[]

[BCs]
  #Voltage Boundary Condition
  [potential_left]
    type = FunctionDirichletBC
    variable = potential
    boundary = 'left'
    function = potential_bc_func
    preset = false
  []
  [potential_dirichlet_right]
    type = DirichletBC
    variable = potential
    boundary = 'right'
    value = 0
    preset = false
  []

  #Boundary conditions for electons
  [em_physical_right]
    type = LymberopoulosElectronBC
    variable = em
    boundary = 'right'
    gamma = 0.01
    ks = 1.19e5
    ion = Ar+
    potential = potential
    position_units = ${dom0Scale}
  []
  [em_physical_left]
    type = LymberopoulosElectronBC
    variable = em
    boundary = 'left'
    gamma = 0.01
    ks = 1.19e5
    ion = Ar+
    potential = potential
    position_units = ${dom0Scale}
  []

  #Boundary conditions for ions
  [Ar+_physical_right_advection]
    type = LymberopoulosIonBC
    variable = Ar+
    potential = potential
    boundary = 'right'
    position_units = ${dom0Scale}
  []
  [Ar+_physical_left_advection]
    type = LymberopoulosIonBC
    variable = Ar+
    potential = potential
    boundary = 'left'
    position_units = ${dom0Scale}
  []

  #Boundary conditions for mean energy
  [mean_en_physical_right]
    type = ElectronTemperatureDirichletBC
    variable = mean_en
    em = em
    value = 0.5
    boundary = 'right'
  []
  [mean_en_physical_left]
    type = ElectronTemperatureDirichletBC
    variable = mean_en
    em = em
    value = 0.5
    boundary = 'left'
  []
  # metastable boundary conditions
  [Ar*_physical_right_diffusion]
    type = LogDensityDirichletBC
    variable = Ar*
    boundary = 'right'
    value = 100
  []
  [Ar*_physical_left_diffusion]
    type = LogDensityDirichletBC
    variable = Ar*
    boundary = 'left'
    value = 100
  []
[]


[UserObjects]
  [exo_soln]
    type = SolutionUserObject
    mesh = 'argon_base_out.e'
    system_variables = 'em Ar+ Ar* mean_en potential'
    timestep = LATEST
  []
[]

[ICs]
  [em_ic]
    type = SolutionIC
    variable = em
    from_variable = 'em'
    solution_uo = exo_soln
    # variable = em
    # function = density_ic_func
  []
  [Ar+_ic]
    type = SolutionIC
    variable = Ar+
    from_variable = 'Ar+'
    solution_uo = exo_soln
  []
  [Ar*_ic]
    type = SolutionIC
    variable = Ar*
    from_variable = 'Ar*'
    solution_uo = exo_soln
  []
  [mean_en_ic]
    type = SolutionIC
    variable = mean_en
    from_variable = 'mean_en'
    solution_uo = exo_soln
  []

  [potential_ic]
    type = SolutionIC
    variable = potential
    from_variable = 'potential'
    solution_uo = exo_soln
  []
[]

[Functions]
  [potential_bc_func]
    type = ParsedFunction
    symbol_names = 'V f'
    symbol_values = 'voltage 13.56e6'
    expression = 'V*sin(2*pi*f*t)'
  []
  [potential_ic_func]
    type = ParsedFunction
    expression = '0.100 * (25.4e-3 - x)'
  []
  [density_ic_func]
    type = ParsedFunction
    expression = 'log((1e13 + 1e15 * (1-x/1)^2 * (x/1)^2)/6.022e23)'
  []
  [energy_density_ic_func]
    type = ParsedFunction
    expression = 'log(3./2.) + log((1e13 + 1e15 * (1-x/1)^2 * (x/1)^2)/6.022e23)'
  []
[]


[PeriodicControllers]
  [Periods]
    starting_cycle = 0
    cycles_between_controls = 0
    num_controller_set = 2000
    name = Periods
  []
[]

[Postprocessors]
  [integrated_power]
    type = ElementIntegralVariablePostprocessor
    variable = total_power
    execute_on = 'initial timestep_end'
  []

  [periodic_power]
    type = PeriodicTimeIntegratedPostprocessor
    value = integrated_power
    execute_on = 'initial timestep_end'
  []

  [mean_periodic_power]
    type = MultiplicationPostprocessor
    value = periodic_power
    # coeff is 30e-3 * 1e-3 * 13.56e6
    #  30e-3 * 1e-3  multiplied for the remaining area of the jet
    # 13.56e6 multipilied to take the periodic average

    coeff = '406.8'
  []

  [multi_period]
    type = MultiPeriodAverager
    value = mean_periodic_power
    number_of_periods = 5
    execute_on = 'initial timestep_begin'
  []

  [voltage]
    type = FunctionControlPostprocessor
    value = multi_period
    initial_value = 0.1
    reference_value = 0.25
    start_cycle = 10
    cycles_between_modification = 10
    execute_on = 'initial timestep_end'
  []

  [total_electron_desity]
    type = ElementIntegralVariablePostprocessor
    variable = em_density
    execute_on = 'initial timestep_end'
  []

  [total_Ar+_desity]
    type = ElementIntegralVariablePostprocessor
    variable = Ar+_density
    execute_on = 'initial timestep_end'
  []

  [total_Ar*_desity]
    type = ElementIntegralVariablePostprocessor
    variable = Ar*_density
    execute_on = 'initial timestep_end'
  []
[]

[Materials]
  [GasBasics]
    type = GasElectronMoments
    interp_trans_coeffs = false
    interp_elastic_coeff = false
    ramp_trans_coeffs = false
    user_p_gas = 133.322
    em = em
    potential = potential
    mean_en = mean_en
    user_electron_mobility = 30.0
    user_electron_diffusion_coeff = 119.8757763975
    property_tables_file = reactions/electron_moments.txt
  []
  [gas_species_0]
    type = ADHeavySpecies
    heavy_species_name = Ar+
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 1.0
    mobility = 0.144409938
    diffusivity = 6.428571e-3
  []
  [gas_species_1]
    type = ADHeavySpecies
    heavy_species_name = Ar*
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 0.0
    diffusivity = 7.515528e-3
  []
  [gas_species_2]
    type = ADHeavySpecies
    heavy_species_name = Ar
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 0.0
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
  end_time = 7.3746e-5
  dt = 1e-9
  dtmin = 1e-14
  scheme = bdf2
  solve_type = NEWTON

  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -snes_linesearch_minlambda'
  petsc_options_value = 'lu NONZERO 1.e-10 1e-3'

  nl_rel_tol = 1e-08
  l_max_its = 20
[]

[Outputs]
  perf_graph = true
  [out]
    type = Exodus
  []
  csv = true
[]
