dom0Scale = 1

[GlobalParams]
  offset = 20
  potential_units = kV
  use_moles = true
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
    input = left
  []
[]

[Problem]
  type = FEProblem
[]

[DriftDiffusionAction]
  [Plasma]
    electrons = 'em'
    charged_particle = 'Ar+ Ar_2+'
    Neutrals = Ar*
    mean_energy = mean_en
    potential = potential
    Is_potential_unique = true
    using_offset = true
    # offset = 30
    position_units = ${dom0Scale}
    Additional_Outputs = 'ElectronTemperature Current EField'
  []
[]

[Reactions]
  [ZapdosRateNetwork]
    name = 'rate'
    species = 'em Ar* Ar+ Ar_2+'
    aux_species = 'Ar'
    gas_species = 'Ar'
    reaction_coefficient_format = 'rate'
    electron_energy = 'mean_en'
    electron_density = 'em'
    include_electrons = true
    file_location = 'reactions'
    potential = 'potential'
    use_ad = true
    use_log = true
    position_units = ${dom0Scale}
    block = 0
    reactions = 'em + Ar -> em + Ar                  : EEDF [elastic]
                 em + Ar -> em + Ar*                 : EEDF [-11.5]
                 em + Ar -> em + em + Ar+            : EEDF [-15.761]
                 em + Ar* -> em + em + Ar+           : EEDF [-4.30]'
  []

  [ZapdosTownsendNetwork]
    name = 'town'
    species = 'em Ar* Ar+ Ar_2+'
    aux_species = 'Ar'
    gas_species = 'Ar'
    reaction_coefficient_format = 'townsend'
    electron_energy = 'mean_en'
    electron_density = 'em'
    include_electrons = true
    potential = 'potential'
    use_ad = true
    use_log = true
    position_units = ${dom0Scale}
    block = 0
    equation_constants = 'Tgas'
    equation_values = '345'
    equation_variables = 'e_temp'
    reactions = 'Ar_2+ + em -> Ar* + Ar              : {8.5e-7*((e_temp/1.5)*11600/300.0)^(-0.67)}
                 Ar_2+ + Ar -> Ar+ + Ar + Ar         : {(6.06e-6/Tgas)*exp(-15130.0/Tgas)}
                 Ar* + Ar* -> Ar_2+ + em             : {6.0e-10}
                 Ar+ + em + em -> Ar + em            : {8.75e-27*((e_temp/1.5)^(-4.5))}
                 Ar* + Ar + Ar -> Ar + Ar + Ar       : {1.399e-32}
                 Ar+ + Ar + Ar -> Ar_2+ + Ar         : {2.25e-31*(Tgas/300.0)^(-0.4)}'
  []
[]

[AuxVariables]
  [Ar]
  []
[]

[AuxKernels]
  [Ar_val]
    type = ConstantAux
    variable = Ar
    # value = 2.4463141e25
    value = 3.7043332
    execute_on = INITIAL
  []
[]

[BCs]
  [potential_left]
    type = FunctionDirichletBC
    variable = potential
    boundary = 'left'
    function = potential_bc_func
  []

  [potential_dirichlet_right]
    type = DirichletBC
    variable = potential
    boundary = 'right'
    value = 0
  []

  [em_physical_right]
    type = HagelaarElectronBC
    variable = em
    boundary = 'right'
    potential = potential
    mean_en = mean_en
    r = 0.0
    position_units = ${dom0Scale}
  []

  [em_physical_left]
    type = HagelaarElectronBC
    variable = em
    boundary = 'left'
    potential = potential
    mean_en = mean_en
    r = 0
    position_units = ${dom0Scale}
  []

  [Ar+_physical_right_diffusion]
    type = HagelaarIonDiffusionBC
    variable = Ar+
    boundary = 'right'
    r = 0
    position_units = ${dom0Scale}
  []

  [Ar+_physical_right_advection]
    type = HagelaarIonAdvectionBC
    variable = Ar+
    boundary = 'right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  []

  [Ar+_physical_left_diffusion]
    type = HagelaarIonDiffusionBC
    variable = Ar+
    boundary = 'left'
    r = 0
    position_units = ${dom0Scale}
  []
  [Ar+_physical_left_advection]
    type = HagelaarIonAdvectionBC
    variable = Ar+
    boundary = 'left'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  []

  [Ar*_physical_right_diffusion]
    type = HagelaarIonDiffusionBC
    variable = Ar*
    boundary = 'right'
    r = 0
    position_units = ${dom0Scale}
  []

  [Ar*_physical_left_diffusion]
    type = HagelaarIonDiffusionBC
    variable = Ar*
    boundary = 'left'
    r = 0
    position_units = ${dom0Scale}
  []

  [Ar_2+_physical_right_diffusion]
    type = HagelaarIonDiffusionBC
    variable = Ar_2+
    boundary = 'right'
    r = 0
    position_units = ${dom0Scale}
  []
  [Ar_2+_physical_right_advection]
    type = HagelaarIonAdvectionBC
    variable = Ar_2+
    boundary = 'right'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  []
  [Ar_2+_physical_left_diffusion]
    type = HagelaarIonDiffusionBC
    variable = Ar_2+
    boundary = 'left'
    r = 0
    position_units = ${dom0Scale}
  []
  [Ar_2+_physical_left_advection]
    type = HagelaarIonAdvectionBC
    variable = Ar_2+
    boundary = 'left'
    potential = potential
    r = 0
    position_units = ${dom0Scale}
  []

  [mean_en_physical_right]
    type = HagelaarEnergyAdvectionBC
    variable = mean_en
    boundary = 'right'
    position_units = 1
    potential = potential
    ip = Ar+
    r = 0
    # em = em
    # args = 'Ar+ Ar_2+'
  []
  [mean_en_physical_left]
    type = HagelaarEnergyAdvectionBC
    variable = mean_en
    # time_units = 1
    boundary = 'left'
    position_units = 1
    potential = potential
    ip = Ar+
    r = 0
    # em = em
    # args = 'Ar+ Ar_2+'
  []

[]

[ICs]
  [em_ic]
    type = ConstantIC
    variable = em
    value = -21
  []
  [Ar+_ic]
    type = ConstantIC
    variable = Ar+
    value = -21
  []
  [Ar*_ic]
    type = ConstantIC
    variable = Ar*
    value = -21
  []
  [Ar_2+_ic]
    type = ConstantIC
    variable = Ar_2+
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
    expression = '0.5*cos(2*3.1415926*13.56e6*t)'
  []
  [potential_ic_func]
    type = ParsedFunction
    expression = '0.2*cos(0)'
  []
[]

[Materials]
  [GasBasics]
    type = GasElectronMoments
    interp_trans_coeffs = false
    interp_elastic_coeff = true
    ramp_trans_coeffs = false
    user_p_gas = 1.01325e5
    em = em
    potential = potential
    mean_en = mean_en
    user_se_coeff = 0
    property_tables_file = reactions/electron_moments.txt
  []
  [gas_species_0]
    type = ADHeavySpecies
    heavy_species_name = Ar+
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 1.0
  []
  [gas_species_1]
    type = ADHeavySpecies
    heavy_species_name = Ar*
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 0.0
  []
  [gas_species_4]
    type = ADHeavySpecies
    heavy_species_name = Ar_2+
    heavy_species_mass = 1.32670418e-25
    heavy_species_charge = 1.0
  []
  [gas_species_7]
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
  end_time = 1e-3
  dtmax = 3.7e-9
  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda'
  petsc_options_value = 'lu NONZERO 1.e-10 fgmres 1e-3'
  nl_rel_tol = 1e-4
  nl_abs_tol = 7.6e-5
  dtmin = 1e-14
  l_max_its = 20

  [TimeStepper]
    type = IterationAdaptiveDT
    cutback_factor = 0.4
    dt = 1e-11
    growth_factor = 1.2
    optimal_iterations = 20
  []
[]

[Outputs]
  [out]
    type = Exodus
  []
[]
