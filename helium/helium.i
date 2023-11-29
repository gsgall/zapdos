[GlobalParams]
  offset = 20
  potential_units = 'kV'
  use_ad = true
  use_log = true
  use_moles = true
  position_units = 1
  potential = 'potential'
  electron_energy = 'mean_en'
  mean_energy = 'mean_en'
  mean_en = 'mean_en'
  electron_density = 'em'
  em = 'em'
  block = 0
  r = 0.0
  cycle_frequency = 13.56e6
[]


[Mesh]
  [geo]
    type = FileMeshGenerator
    file = 'cost_1d.msh'
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
    input = 'left'
  []
[]

[Problem]
  type = FEProblem
[]


[DriftDiffusionAction]
  [Plasma]
    electrons = 'em'
    charged_particle = 'He+ He_2+'
    Neutrals = 'He* He_2*'
    Is_potential_unique = true
    using_offset = true
    Additional_Outputs = 'ElectronTemperature Current EField'
  []
[]


[Reactions]
  [ZapdosNetwork]
    name = 'network'
    species = 'em He* He+ He_2* He_2+'
    aux_species = 'He'
    reaction_coefficient_format = 'rate'
    include_electrons = true
    equation_constants = 'Tgas'
    equation_values = '345'
    equation_variables = 'e_temp'
    file_location = 'reactions'

    reactions = 'He + em -> He* + em                    : EEDF [-19.8]
                 He + em -> He+ + em + em               : EEDF [-24.6]
                 He* + em -> He+ + em + em              : EEDF [-4.7]
                 He + em -> He + em                     : EEDF [elastic]
                 em + He_2+ -> He* + He                 : 8.9e-15*((e_temp*11604.505)/Tgas)^-1.5
                 He_2* + He_2* -> He + He + He_2+ + em  : 1.5e-15
                 He* + He* -> He_2+ + em                : 1.5e-15
                 He* + He + He -> He_2* + He            : 2e-46
                 He+ + He + He -> He_2+ + He            : 1.1e-43
                 em + em + He+ -> em + He*              : 1.63e-21*(e_temp*11604.505)^-4.5'
  []
[]

[AuxVariables]
  [He]
  []

  [e_power]
    order = CONSTANT
    family = MONOMIAL
  []

  [He_ion_power]
    order = CONSTANT
    family = MONOMIAL
  []

  [He_2_ion_power]
    order = CONSTANT
    family = MONOMIAL
  []

  [total_power]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [He_val]
    type = ConstantAux
    variable = He
    # value = 2.4463141e25
    value = 3.7043332
    execute_on = INITIAL
  []

  [em_powerdep]
    type = ADPowerDep
    variable = e_power
    density_log = em
  []

  [He+_powerdep]
    type = ADPowerDep
    variable = He_ion_power
    density_log = He+
  []

  [He_2+_powerdep]
    type = ADPowerDep
    variable = He_2_ion_power
    density_log = He_2+
  []

  [total_powerdep]
    type = ParsedAux
    variable = total_power
    coupled_variables = 'e_power He_ion_power He_2_ion_power'
    expression = 'e_power + He_ion_power + He_2_ion_power'
  []
[]


[BCs]
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

  [em_physical_right]
    type = HagelaarElectronBC
    variable = em
    boundary = 'right'
  []

  [em_physical_left]
    type = HagelaarElectronBC
    variable = em
    boundary = 'left'
  []

  [He+_physical_right_diffusion]
    type = HagelaarIonDiffusionBC
    variable = He+
    boundary = 'right'
  []

  [He+_physical_right_advection]
    type = HagelaarIonAdvectionBC
    variable = He+
    boundary = 'right'
  []


  [He+_physical_left_diffusion]
    type = HagelaarIonDiffusionBC
    variable = He+
    boundary = 'left'
  []

  [He+_physical_left_advection]
    type = HagelaarIonAdvectionBC
    variable = He+
    boundary = 'left'
  []

  [He*_physical_right_diffusion]
    type = HagelaarIonDiffusionBC
    variable = He*
    boundary = 'right'
  []

  [He*_physical_left_diffusion]
    type = HagelaarIonDiffusionBC
    variable = He*
    boundary = 'left'
  []

  [He_2*_physical_right_diffusion]
    type = HagelaarIonDiffusionBC
    variable = He_2*
    boundary = 'right'
  []

  [He_2*_physical_left_diffusion]
    type = HagelaarIonDiffusionBC
    variable = He_2*
    boundary = 'left'
  []

  [He_2+_physical_right_diffusion]
    type = HagelaarIonDiffusionBC
    variable = He_2+
    boundary = 'right'
  []

  [He_2+_physical_right_advection]
    type = HagelaarIonAdvectionBC
    variable = He_2+
    boundary = 'right'
  []

  [He_2+_physical_left_diffusion]
    type = HagelaarIonDiffusionBC
    variable = He_2+
    boundary = 'left'
  []

  [He_2+_physical_left_advection]
    type = HagelaarIonAdvectionBC
    variable = He_2+
    boundary = 'left'
  []

  [mean_en_physical_right]
    type = EnergyBC2
    variable = mean_en
    boundary = 'right'
    ip = 'He+'
    args = 'He+ He_2+'
  []

  [mean_en_physical_left]
    type = EnergyBC2
    variable = mean_en
    boundary = 'left'
    ip = 'He+'
    args = 'He+ He_2+'
  []
[]


[ICs]
  [em_ic]
    type = ConstantIC
    variable = em
    value = -21
  []
  [He+_ic]
    type = ConstantIC
    variable = He+
    value = -21
  []
  [He*_ic]
    type = ConstantIC
    variable = He*
    value = -21
  []
  [He_2*_ic]
    type = ConstantIC
    variable = He_2*
    value = -24
  []
  [He_2+_ic]
    type = ConstantIC
    variable = He_2+
    value = -24
  []

  [mean_en_ic]
    type = ConstantIC
    variable = mean_en
    value = -20
  []

  [potential_ic]
    type = FunctionIC
    variable = potential
    function = potential_ic_func
  []
[]

[Functions]
  [potential_bc_func]
    type = ParsedFunction
    symbol_names = 'voltage f'
    symbol_values = 'voltage 13.56e6'
    expression = 'voltage * sin(2*pi*f*t) '
  []

  [potential_ic_func]
    type = ParsedFunction
    value = '0.2'
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

  [mean_periodic_power_dep]
    type = MultiplicationPostprocessor
    value = periodic_power
    # coeff is 30e-3 * 1e-3 * 13.56e6
    #  30e-3 * 1e-3  multiplied for the remaining area of the jet
    # 13.56e6 multipilied to take the periodic average
    coeff = '406.8'
  []

  [voltage]
    type = FunctionControlPostprocessor
    value = mean_periodic_power_dep
    initial_value = 0.5
    reference_value = 0.1
    start_cycle = 1e7
    execute_on = 'initial timestep_end'
  []
[]

[Materials]
  [GasBasics]
    type = GasElectronMoments
    interp_trans_coeffs = false
    interp_elastic_coeff = false
    ramp_trans_coeffs = false
    user_p_gas = 1.01325e5
    user_se_coeff = 0
    user_electron_mobility = 0.0352103411399
    user_electron_diffusion_coeff = 0.297951680159
    property_tables_file = reactions/electron_moments.txt
  []

  [gas_species_0]
   type = ADHeavySpecies
   heavy_species_name = He+
   heavy_species_mass = 6.646e-27
   heavy_species_charge = 1.0
   #mobility = 2.16e-3
   #diffusivity = 2.999e-5
   mobility = 1.3009e-3
   diffusivity = 3.8676e-5
  []
  [gas_species_1]
    type = ADHeavySpecies
    heavy_species_name = He*
    heavy_species_mass = 6.646e-27
    heavy_species_charge = 0.0
    mobility = 0
    #diffusivity = 1.64e-4
    diffusivity = 2.02e-4
  []
  [gas_species_2]
    type = ADHeavySpecies
    heavy_species_name = He_2*
    heavy_species_mass = 1.3292e-26
    heavy_species_charge = 0.0
    mobility = 0
    #diffusivity = 4.75e-5
    diffusivity = 5.86e-5
  []
  [gas_species_3]
    type = ADHeavySpecies
    heavy_species_name = He_2+
    heavy_species_mass = 1.3292e-26
    heavy_species_charge = 1.0
    #mobility = 1.83e-3
    #diffusivity = 4.731e-5
    mobility = 2.1092e-3
    diffusivity = 6.2708e-5
  []

  # Note that He neutrals are not a nonlinear variable here.
  # However, some kernels may need the mass, charge, etc. parameters regardless.
  [gas_species_5]
    type = ADHeavySpecies
    heavy_species_name = He
    heavy_species_mass = 6.646e-27
    heavy_species_charge = 0.0
    mobility = 0
    diffusivity = 2.999e-5
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
  end_time = 1e-4
  dtmax = 3.7e-9
  solve_type = NEWTON
  line_search = none
  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda -pc_factor_mat_solver'
  petsc_options_value = 'lu NONZERO 1.e-10 fgmres 1e-3 superlu_dists'
  nl_rel_tol = 1e-4
  nl_abs_tol = 7.6e-5
  dtmin = 1e-14
  l_max_its = 20

  automatic_scaling = true
  compute_scaling_once = false

  [TimeStepper]
    type = IterationAdaptiveDT
    cutback_factor = 0.4
    dt = 1e-11
    growth_factor = 1.2
    optimal_iterations = 20
  []
[]

[Outputs]
  print_perf_log = true
  [out]
    type = Exodus
  []
    csv = true
[]
