dom0Scale = 25.4e-3

[GlobalParams]
    ## Issue was that the v in kV was lowercased
    potential_units = kV
    use_moles = true
[]

[Mesh]
    [./file]
        type = FileMeshGenerator
        # We are reading the other file for the mesh and to get the data for the metastables
        file = 'Lymberopoulos.msh'
    [../]
    [./left]
        type = SideSetsFromNormalsGenerator
        normals = '-1 0 0'
        new_boundary = 'left'
        input = file # file where the mesh is coming from
    [../]
    [./right]
        type = SideSetsFromNormalsGenerator
        normals = '1 0 0'
        new_boundary = 'right'
        input = left # uses left because it is building off of the left point
    [../]
[]

[Problem]
    type = FEProblem
[]

# We have to read the data from the other file for the shooting steps
[Variables]
    [./em]
    [../]

    [./Ar+]
    [../]

    [./Ar*]
    [../]

    [./mean_en]
    [../]

    [./potential]
    [../]

    [SM_Ar*]
    [../]
[]

[Kernels]
    ## Electron Kernels
    [./em_time_derivative]
        type = ADTimeDerivative
        variable = em
    [../]

    [./em_advection]
        type = ADEFieldAdvection
        variable = em
        potential = potential
        position_units = ${dom0Scale}
    [../]

    [./em_diffusion]
        type = ADCoeffDiffusion
        variable = em
        position_units = ${dom0Scale}
    [../]


    # Ion Kernels
    [./Ar+_time_derivative]
        type = ADTimeDerivative
        variable = Ar+
    [../]

    [Ar+_advection]
        type = ADEFieldAdvection
        variable = Ar+
        potential = potential
        position_units = ${dom0Scale}
    [../]

    [Ar+_diffusion]
        type = ADCoeffDiffusion
        variable = Ar+
        position_units = ${dom0Scale}
    [../]

    # Metastable Kernels
    [./Ar*_time_derivative]
        type = ADTimeDerivative
        variable = Ar*
    [../]
    # There is no advection term for metastables because they are a neutral species
    [Ar*_diffusion]
        type = ADCoeffDiffusion
        variable = Ar*
        position_units = ${dom0Scale}
    [../]

    ## Voltage Kernels
    [./potential_diffusion]
        #what is the difference bewteen this and the regular ADDiffusion
        type = ADCoeffDiffusionLin
        variable = potential
        position_units = ${dom0Scale}
    [../]

    #Charge sources for poissons equation
    [./Ar+_charge_source]
        type = ChargeSourceMoles_KV
        variable = potential
        charged = Ar+
    [../]

    [./em_charge_source]
        type = ChargeSourceMoles_KV
        variable = potential
        charged = em
    [../]

    #electorn energy equations
    [./mean_en_time_derivative]
        ## why is this one in log form but the others are not
        type = ADTimeDerivativeLog
        variable = mean_en
    [../]

    [mean_en_advection]
        type = ADEFieldAdvection
        variable = mean_en
        potential = potential
        position_units = ${dom0Scale}
    [../]

    [mean_en_diffusion]
        type = ADCoeffDiffusion
        variable = mean_en
        position_units = ${dom0Scale}
    [../]

    [./mean_en_diffusion_correction]
        type = ADThermalConductivityDiffusion
        variable = mean_en
        em = em
        position_units = ${dom0Scale}
    [../]

    [./mean_en_joule_heating]
        type = ADJouleHeating
        variable = mean_en
        potential = potential
        em = em
        position_units = ${dom0Scale}
    [../]

    ## Reaction Kernels for metastable in shoot method
    [./SM_Ar*_time_derivative]
        type = MassLumpedTimeDerivative
        variable = SM_Ar*
        enable = false
    [../]

    [./SM_Ar*_diffusion]
        type = ADCoeffDiffusionForShootMethod
        variable = SM_Ar*
        density = Ar*
        position_units = ${dom0Scale}
        enable = false
    [../]

    [./SM_Ar*_ionization]
        type = ADEEDFReactionLogForShootMethod
        variable = SM_Ar*
        electron = em
        density = Ar*
        reaction = 'Ar* + em -> Ar+ + em + em'
        coefficient = -1
        enable = false
        number = 2
    [../]

    [./SM_Ar*_collisions]
        type = ADEEDFReactionLogForShootMethod
        variable = SM_Ar*
        electron = em
        density = Ar*
        reaction = 'Ar* + em -> Ar + em'
        coefficient = -1
        enable = false
        number = 3
    [../]

    [./SM_Ar*_quenching]
        type = ADReactionSecondOrderLogForShootMethod
        variable = SM_Ar*
        density = Ar*
        v = em
        reaction = 'Ar* + em -> Ar_r + em'
        coefficient = -1
        enable = false
        number = 4
    [../]

    [./SM_Ar*_pooling]
        type = ADReactionSecondOrderLogForShootMethod
        variable = SM_Ar*
        density = Ar*
        v = Ar*
        reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
        coefficient = -2
        enable = false
        number = 5
    [../]

    [./SM_Ar*_2B_quenching]
        type = ADReactionSecondOrderLogForShootMethod
        variable = SM_Ar*
        density = Ar*
        v = Ar
        reaction = 'Ar* + Ar -> Ar + Ar'
        coefficient = -1
        enable = false
        number = 6
    [../]

    [./SM_Ar*_3B_quenching]
        type = ADReactionThirdOrderLogForShootMethod
        variable = SM_Ar*
        density = Ar*
        v = Ar
        w = Ar
        reaction = 'Ar* + Ar + Ar -> Ar_2 + Ar'
        coefficient = -1
        enable = false
        number = 7
    [../]

    # all variables need a kernel and since this veriable is only calulated before every acceleration
    # it needs a place holder between the cycles so it is still there but does nothing
    # That is why it is a null kernel
    [./SM_Ar*_Null]
        type = NullKernel
        variable = SM_Ar*
    [../]

[]


[Reactions]
    [./Argon]
        species = 'Ar+ Ar* em'
        aux_species = 'Ar'
        reaction_coefficient_format = 'rate'
        gas_species = 'Ar'
        electron_energy = 'mean_en'
        electron_density = 'em'
        include_electrons = true
        file_location = 'rate_coefficients_lymberopoulos'
        potential = 'potential'
        use_log = true
        position_units = ${dom0Scale}
        block = 0
        use_ad = true
        reactions = 'Ar + em -> Ar* + em          : EEDF [-11.56] (ar_excitation.txt)
                     Ar + em -> Ar+ + em + em     : EEDF [-15.7] (ar_ionization.txt)
                     Ar* + em -> Ar+ + em + em    : EEDF [-4.14] (ar_excited_ionization.txt)
                     Ar* + em -> Ar + em          : EEDF [11.56] (ar_deexcitation.txt)
                     Ar* + em -> Ar_r + em        : 1.2044e11
                     Ar* + Ar* -> Ar+ + Ar + em   : 373372804
                     Ar* + Ar -> Ar + Ar          : 1.8066e03
                     Ar* + Ar + Ar -> Ar_2 + Ar   : 3.9893e04'
    [../]
[]

[AuxVariables]
    [./Ar]
    [../]

    [./Ar*S]
    [../]

    [./SM_Ar*Reset]
        initial_condition = 1.0
    [../]

    [./Ar*_density]
        order = CONSTANT
        family = MONOMIAL
    [../]

    [./Ar+_density]
        order = CONSTANT
        family = MONOMIAL
    [../]

    [./em_density]
        order = CONSTANT
        family = MONOMIAL
    [../]

    [./Te]
        order = CONSTANT
        family = MONOMIAL
    [../]

    [./reaction_1_rate]
        order = CONSTANT
        family = MONOMIAL
    [../]
[]


[AuxKernels]
    [./Ar_value]
        type = ConstantAux
        variable = Ar
        #value = -2.92862
        function = 'log(3.22e22 / 6.02e23)'
        execute_on = INITIAL
    [../]

# stores the value of the Ar* for the acceleration scheme
# It is a quoteint because moose does not have a way to copy the value
# denom is set to 1 so that we can just make a copy
    [./Ar*S_for_Shooting]
        type = QuotientAux
        variable = Ar*S
        numerator = Ar*
        denominator = 1.0
        enable = false
        execute_on = 'TIMESTEP_END'
    [../]

    [./SM_Ar*Reset_Value]
        type = ConstantAux
        variable = SM_Ar*Reset
        value = 1.0
        execute_on = 'INITIAL'
    [../]

    [./Ar*_density]
        type = DensityMoles
        variable = Ar*_density
        density_log = Ar*
    [../]

    [./Ar+_density]
        type = DensityMoles
        variable = Ar+_density
        density_log = Ar+
    [../]

    [./em_density]
        type = DensityMoles
        variable = em_density
        density_log = em
    [../]

    [./Te]
        type = ElectronTemperature
        variable = Te
        electron_density = em
        mean_en = mean_en
    [../]
[]


[BCs]
    # BCs for RF source use FunctionDirichletBC
    [./potential_left]
        type = ADFunctionDirichletBC
        variable = potential
        boundary = 'left'
        function = potential_bc_function
        preset = false
    [../]

    [./potential_right]
        type = ADDirichletBC
        variable = potential
        boundary = 'right'
        value = 0
        preset = false
    [../]

    [./em_left]
        type = ADLymberopoulosElectronBC
        ks = 1.19e5
        gamma = 0.01
        ion = Ar+
        potential = potential
        position_units = ${dom0Scale}
        variable = em
        boundary = 'left'
    [../]
    #

    [./em_right]
        type = ADLymberopoulosElectronBC
        ks = 1.19e5
        gamma = 0.01
        ion = Ar+
        potential = potential
        position_units = ${dom0Scale}
        variable = em
        boundary = 'right'
    [../]

    [./mean_en_left]
        type = ADElectronTemperatureDirichletBC
        variable = mean_en
        em = em
        value = 0.5
        boundary = 'left'
    [../]


    [./mean_en_right]
        type = ADElectronTemperatureDirichletBC
        variable = mean_en
        em = em
        value = 0.5
        boundary = 'right'
    [../]

    [./Ar+_left_Advection]
        type = ADLymberopoulosIonBC
        potential = potential
        position_units = ${dom0Scale}
        variable = Ar+
        boundary = 'left'
    [../]


    [./Ar+_right_Advection]
        type = ADLymberopoulosIonBC
        potential = potential
        position_units = ${dom0Scale}
        variable = Ar+
        boundary = 'right'
    [../]

    [./Ar*_left]
        type = ADDirichletBC
        value = -50
        variable = Ar*
        boundary = 'left'
    [../]

    [./Ar*_right]
        type = ADDirichletBC
        value = -50
        variable = Ar*
        boundary = 'right'
    [../]
[]


[ICs]
    [./em_ic]
        type = FunctionIC
        variable = em
        function = density_ic_function
    [../]

    [./Ar*_ic]
        type = FunctionIC
        variable = Ar*
        function = density_ic_function
    [../]

    [./Ar+_ic]
        type = FunctionIC
        variable = Ar+
        function = density_ic_function
    [../]

    [./mean_en_ic]
        type = FunctionIC
        variable = mean_en
        function = energy_density_ic_function
    [../]

    [./potential_ic]
        type = FunctionIC
        variable = potential
        function = potential_ic_function
    [../]
[]


[Functions]
    [./density_ic_function]
        type = ParsedFunction
        value = 'log((1e13 + 1e15 * (1 - (x / 1))^2 * (x / 1)^2) / 6.022e23)'
    [../]

    [./energy_density_ic_function]
        type = ParsedFunction
        value = 'log((3.0 / 2.0) * 1.0) + log((1e13 + 1e15 * (1 - (x / 1))^2 * (x / 1)^2) / 6.022e23)'
    [../]

    [./potential_ic_function]
        type = ParsedFunction
        value = '0.100 * (1 - x)'
    [../]

    [./potential_bc_function]
        type = ParsedFunction
        value = '0.100 * sin(2 * 3.1415926 * 13.56e6 * t)'
    [../]
[]

[Materials]
    [./GasBasics]
        type = ADGasElectronMoments
        em = em
        mean_en = mean_en
        user_electron_mobility = 30.0
        user_electron_diffusion_coeff = 119.8757763975
        potential_units = kV
        property_tables_file = rate_coefficients_lymberopoulos/electron_moments.txt
    [../]

    [./Non_AD_Gas_Constants]
        type = GenericConstantMaterial
        prop_names = 'T_gas p_gas N_A k_boltz e'
        prop_values = '300 101325 6.02e23 1.38e-23 1.6e-19'
        block = 0
    [../]

    [./AD_Constants]
        type = ADGenericConstantMaterial
        prop_names = 'diffpotential'
        prop_values = '8.85e-12'
        block = 0
    [../]

    [./Argon_Ions]
        # charged particles need mobility and diffusivity
        # mobility accounts for affects from electric fields
        # diffusivity accounts for the motion of the particles
        type = ADHeavySpeciesMaterial
        heavy_species_name = Ar+
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 1.0
        mobility = 0.144409938
        diffusivity = 6.428571e-3
    [../]

    [./Argon_Metastables]
        # Meta Stables need to have diffusivity but not mobility because they are being tracked
        # but they are still a neutral species so there are not affects from the electric fields
        type = ADHeavySpeciesMaterial
        heavy_species_name = Ar*
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 0.0
        diffusivity = 7.515528e-3
    [../]

    [./Argon_Neutrals]
        # neutral species do not mobility or diffusivity becuase we are not keeping track of them
        type = ADHeavySpeciesMaterial
        heavy_species_name = Ar
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 0.0
    [../]
[]

[MultiApps]
    [./Shooting]
        type = FullSolveMultiApp
        input_files = 'Lymberopoulos_replica_shooting.i'
        execute_on = 'TIMESTEP_END'
        enable = false
    [../]
[]


[Transfers]
    [./SM_Ar*Reset_to_Shooting]
        type = MultiAppCopyTransfer
        direction = to_multiapp
        multi_app = Shooting
        source_variable = SM_Ar*Reset
        variable = SM_Ar*Reset
        enable = false
    [../]

    [./Ar*_to_Shooting]
        type = MultiAppCopyTransfer
        direction = to_multiapp
        multi_app = Shooting
        source_variable = Ar*
        variable = Ar*
        enable = false
    [../]

    [./Ar*S_to_Shooting]
        type = MultiAppCopyTransfer
        direction = to_multiapp
        multi_app = Shooting
        source_variable = Ar*S
        variable = Ar*S
        enable = false
    [../]

    [./Ar*T_to_Shooting]
        type = MultiAppCopyTransfer
        direction = to_multiapp
        multi_app = Shooting
        source_variable = Ar*
        variable = Ar*T
        enable = false
    [../]

    [./SMDeriv_to_Shooting]
        type = MultiAppCopyTransfer
        direction = to_multiapp
        multi_app = Shooting
        source_variable = SM_Ar*
        variable = SM_Ar*
        enable = false
    [../]

    [./Ar*New_from_Shooting]
        type = MultiAppCopyTransfer
        direction = from_multiapp
        multi_app = Shooting
        source_variable = Ar*
        variable = Ar*
        enable = false
    [../]

    [./SM_Ar*Reset_from_Shooting]
        type = MultiAppCopyTransfer
        direction = from_multiapp
        multi_app = Shooting
        source_variable = SM_Ar*Reset
        variable = SM_Ar*
        enable = false
    [../]

    [./Ar*Relative_Diff]
        type = MultiAppPostprocessorTransfer
        direction = from_multiapp
        multi_app = Shooting
        from_postprocessor = Meta_Relative_Diff
        to_postprocessor = Meta_Relative_Diff
        reduction_type = minimum
        enable = false
    [../]
[]

[PeriodicControllers]
    [./Shooting]
        # Storing the value for meta stables before the acceleration
        Enable_at_cycle_start = '*::Ar*S_for_Shooting'
        # Carries out the meta stable calculations during the acceleration
        # This should have all of the kernels for the metastables
        Enable_during_cycle = '*::SM_Ar*_time_derivative
                               *::SM_Ar*_diffusion
                               *::SM_Ar*_ionization
                               *::SM_Ar*_collisions
                               *::SM_Ar*_pooling
                               *::SM_Ar*_quenching
                               *::SM_Ar*_2B_quenching
                               *::SM_Ar*_3B_quenching'

        #This allows for the SM to be reset and helps transer the informaiton back to where it needs to be
        Enable_at_cycle_end ='MultiApps::Shooting
                              *::SM_Ar*Reset_to_Shooting
                              *::Ar*_to_Shooting
                              *::Ar*S_to_Shooting *::Ar*T_to_Shooting
                              *::SMDeriv_to_Shooting
                              *::Ar*New_from_Shooting
                              *::SM_Ar*Reset_from_Shooting
                              *::Ar*Relative_Diff'
        #same as RF frequency
        cycle_frequency = 13.56e6
        starting_cycle = 50
        cycles_between_controls = 50
        cycles_per_controls = 1
        num_controller_set = 2000
        name = Shooting
    [../]
[]

[Postprocessors]
    [./Meta_Relative_Diff]
        type = Receiver
    [../]
[]


[Preconditioning]
    [./smp]
      type = SMP
      full = true
    [../]
[]


[Executioner]
    type = Transient
    end_time = 7.3746e-05
    petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
    solve_type = NEWTON
    petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda'
    petsc_options_value = 'lu NONZERO 1.e-10 fgmres 1e-3'
    nl_rel_tol = 1e-08
    dtmin = 1e-14
    l_max_its = 20
    line_search = none

    ## These are needed for the time sclaes of plasmas
    scheme = bdf2
    dt = 1e-9
    automatic_scaling = true
    compute_scaling_once = false
[]

[Outputs]
    perf_graph = true
    [./out]
        type = Exodus
    [../]
[]
