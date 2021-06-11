dom0Scale = 25.4e-3

[GlobalParams]
    ## Issue was that the v in kV was lowercased
    potential_units = kV
    use_moles = true
[]

[Mesh]
    [./file]
        type = FileMeshGenerator
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

[DriftDiffusionAction]
    [./Plasma]
        electrons = em
        charged_particle = Ar+
        Neutrals = Ar*
        potential = potential
        Is_potential_unique = true
        mean_energy = mean_en
        position_units = ${dom0Scale}
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
[]


[AuxKernels]
    [./Ar_value]
        type = ConstantAux
        variable = Ar
        value = -2.928623
        execute_on = INITIAL
    [../]
[]


[BCs]
    # BCs for RF source use FunctionDirichletBC
    [./potential_left]
        type = FunctionDirichletBC
        variable = potential
        boundary = 'left'
        function = potential_bc_function
        preset = false
    [../]

    [./potential_right]
        type = DirichletBC
        variable = potential
        boundary = 'right'
        value = 0
        preset = false
    [../]

    [./em_left]
        type = LymberopoulosElectronBC
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
        type = LymberopoulosElectronBC
        ks = 1.19e5
        gamma = 0.01
        ion = Ar+
        potential = potential
        position_units = ${dom0Scale}
        variable = em
        boundary = 'right'
    [../]

    [./mean_en_left]
        type = ElectronTemperatureDirichletBC
        variable = mean_en
        em = em
        value = 0.5
        boundary = 'left'
    [../]


    [./mean_en_right]
        type = ElectronTemperatureDirichletBC
        variable = mean_en
        em = em
        value = 0.5
        boundary = 'right'
    [../]

    [./Ar+_left_Advection]
        type = LymberopoulosIonBC
        potential = potential
        position_units = ${dom0Scale}
        variable = Ar+
        boundary = 'left'
    [../]


    [./Ar+_right_Advection]
        type = LymberopoulosIonBC
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
        value = '0.100 * (25.4e-3 - x)'
    [../]

    [./potential_bc_function]
        type = ParsedFunction
        value = '0.100 * sin(2 * 3.1415926 * 13.56e6 * t)'
    [../]
[]

[Materials]
    [./GasBasics]
        type = GasElectronMoments
        interp_trans_coeffs = false
        interp_elastic_coeff = false
        ramp_trans_coeffs = false
        user_p_gas = 133.322
        user_T_gas = 300
        em = em
        potential = potential
        mean_en = mean_en
        user_electron_mobility = 30.0
        user_electron_diffusion_coeff = 119.8757763975
        property_tables_file = rate_coefficients_lymberopoulos/electron_moments.txt
        position_units = ${dom0Scale}
    [../]

    [./Argon_Ions]
        # charged particles need mobility and diffusivity5rf
        # mobility accounts for affects from electric fields
        # diffusivity accounts for the motion of the particles
        type = ADHeavySpecies
        heavy_species_name = Ar+
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 1.0
        mobility = 0.144409938
        diffusivity = 6.428571e-3
    [../]

    [./Argon_Metastables]
        # Meta Stables need to have diffusivity but not mobility because they are being tracked
        # but they are still a neutral species so there are not affects from the electric fields
        type = ADHeavySpecies
        heavy_species_name = Ar*
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 0.0
        diffusivity = 7.515528e-3
    [../]

    [./Argon_Neutrals]
        # neutral species do not mobility or diffusivity becuase we are not keeping track of them
        type = ADHeavySpecies
        heavy_species_name = Ar
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 0.0
    [../]
[]

[Preconditioning]
    [./smp]
      type = SMP
      full = true
    [../]
[]


#New postprocessor that calculates the inverse of the plasma frequency
[Postprocessors]
    [./InversePlasmaFreq]
        type = PlasmaFrequencyInverse
        variable = em
        use_moles = true
        execute_on = 'INITIAL TIMESTEP_BEGIN'
    [../]
[]

[Executioner]
    type = Transient
    end_time = 3e-7
    petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
    solve_type = NEWTON
    petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda'
    petsc_options_value = 'lu NONZERO 1.e-10 fgmres 1e-3'
    nl_rel_tol = 1e-08
    dtmin = 1e-14
    l_max_its = 20

    #Time steps based on the inverse of the plasma frequency
    [./TimeStepper]
        type = PostprocessorDT
        postprocessor = InversePlasmaFreq
    [../]
#        ## These are needed for the time sclaes of RF plasmas
#    scheme = bdf2
#    dt = 1e-9
#    automatic_scaling = true
#    compute_scaling_once = false
[]

[Outputs]
    perf_graph = true
  [./out]
    type = Exodus
  [../]
[]
