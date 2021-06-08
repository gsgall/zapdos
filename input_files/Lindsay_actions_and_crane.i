dom0Scale = 1e-3 # scaling for block 0
dom1Scale = 1e-7 # scaling for block 1

[GlobalParams]
    offset = 20.0 # off set for log stabilization, prevents log(0)
    potential_units = kV # units for potential
    use_moles = true
[]

[Mesh]
    [./file]
        type = FileMeshGenerator
        file = 'liquidNew.msh' # msh file being used
    [../]

    [./water_to_air]
        # interface allows for one directional fluxes
        # interface going from air to water
        type = SideSetsBetweenSubdomainsGenerator
        primary_block = '0' # block where the flux is coming from
        paired_block = '1' # block where the flux is going to
        new_boundary = 'master0_interface'
        input = file # first input is where the msh is coming and it is then named air_to_water
    [../]

    [./air_to_water]
        ##TODO swtich this to air_to_water
        # interface going from water to air
        type = SideSetsBetweenSubdomainsGenerator
        primary_block = '1' #the block where the physics is happening
        paired_block = '0'#the block that is affecting the physics in the primary block
        new_boundary = 'master1_interface'
        input = water_to_air # modifying air_to_water and then naming it water_to_air
    [../]

    [./left]
        type = SideSetsFromNormalsGenerator
        normals = '-1 0 0'
        new_boundary = 'left'
        input = air_to_water # modifying water_to_air naming it left
    [../]

    [./right]
        type = SideSetsFromNormalsGenerator
        normals = '1 0 0'
        new_boundary = 'right'
        input = left # modiifying left naming it right
    [../]
[]


[Problem]
    type = FEProblem
[]


[Preconditioning]
    [./smp]
      type = SMP
      full = true
      ksp_norm = none
    [../]
[]


[UserObjects]
    [./data_provider]
        type = ProvideMobility
        electrode_area = 5.02e-7
        ballast_resist = 1e6
        e = 1.6e-19
    [../]
[]

#The potential needs to be defined outside of the Action,
#since it is present in both Blocks
#Declare any variable that is present in mulitple blocks in the variables section
[Variables]
    [./potential]
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
        value = 0
        execute_on = INITIAL
    [../]
[]

[DriftDiffusionAction]
    [./Plasma]
        electrons = em
        charged_particle = Ar+
        potential = potential
        Is_potential_unique = false # set becuase both areas use the same potential
        mean_energy = mean_en # used for electron energy dependant coefficients
        using_offset = true #helps prevent the log(0)
        position_units = ${dom0Scale}
        block = 0
        Additional_Outputs = 'ElectronTemperature Current EField'
    [../]
    # treats water as a dense plasma
    [./Water]
      charged_particle = 'emliq OH-'
      potential = potential
      Is_potential_unique = false
      using_offset = true #helps prevent the log(0)
      position_units = ${dom1Scale}
      block = 1
      Additional_Outputs = 'Current EField'
    [../]
[]

[Reactions]
    [./Argon]
        species = 'Ar+ em'
        aux_species = 'Ar'
        reaction_coefficient_format = 'townsend'
        gas_species = 'Ar'
        electron_energy = 'mean_en'
        electron_density = 'em'
        include_electrons = true
        file_location = 'rate_coefficients_lindsay'
        potential = 'potential'
        use_log = true # always include this becuse zapdos does not currently support non log options
        position_units = ${dom0Scale}
        block = 0
        reactions = 'Ar + em -> Ar* + em          : EEDF [-11.5] (ar_excitation.txt)
                     Ar + em -> Ar+ + em + em     : EEDF [-15.76] (ar_ionization.txt)
                     Ar + em -> Ar + em           : EEDF [elastic] (ar_elastic.txt)'
    [../]

    [./Water]
        species = 'emliq OH-'
        reaction_coefficient_format = 'rate'
        electron_energy = 'mean_en'
        electron_density = 'emliq'
        include_electrons = true
        potential = 'potential'
        use_log = true
        position_units = ${dom1Scale}
        block = 1
        reactions = 'emliq -> H+ + OH- : 1064
                     emliq + emliq -> H2 + OH- + OH- : 313600000'
    [../]
[]

[InterfaceKernels]
    # interface conditions allow one this to go another
    # These account for electrons going into the water
    # if you want to account for electrons going out of the water into the air then you would need there to be interface conditions for master interface 0
    [./em_advection]
        type = InterfaceAdvection
        mean_en_neighbor = mean_en
        potential_neighbor = potential
        neighbor_var = em

        #the main variable being affected. The em is going into the water so em -> emliq
        # this affects emliq
        variable = emliq
        boundary = master1_interface
        position_units = ${dom1Scale}
        neighbor_position_units = ${dom0Scale}
    [../]

    [./em_diffusion]
        type = InterfaceLogDiffusionElectrons
        mean_en_neighbor = mean_en
        neighbor_var = em
        variable = emliq
        boundary = master1_interface
        position_units = ${dom1Scale}
        neighbor_position_units = ${dom0Scale}
    [../]
[]

[BCs]
    # boundary conditions capture physics happening in one block only
    # potential starts in the air
    [./potential_left]
        # DC potential BC
        type = NeumannCircuitVoltageMoles_KV
        variable = potential
        boundary = left
        function = potential_bc_function
        ip = Ar+
        data_provider = data_provider
        em = em
        mean_en = mean_en
        r = 0 # does r = 0 mean that all of that variable are reflected
        position_units = ${dom0Scale}
    [../]

    # ground
    [./potential_right]
        type = DirichletBC
        variable = potential
        boundary = 'right'
        value = 0
        preset = false
    [../]

    # electron energy at the potential
    [./mean_en_left]
        type = HagelaarEnergyBC
        variable = mean_en
        boundary = 'left'
        potential = potential
        em = em
        ip = Ar+
        r = 0
        position_units = ${dom0Scale}
    [../]

    # secondary electron energy at the potential
    [./secondary_mean_en_left]
        type = SecondaryElectronEnergyBC
        variable = mean_en
        boundary = 'left'
        potential = potential
        em = em
        ip = Ar+
        r = 0
        position_units = ${dom0Scale}
    [../]

    # electron energy being reflected from the water
    [./mean_en_water]
        type = HagelaarEnergyBC
        variable = mean_en
        boundary = 'master0_interface'
        potential = potential
        em = em
        ip = Ar+
        r = 0.99 # does this mean that there is a lot of reflection or very little?
        position_units = ${dom0Scale}
    [../]

    # electron density at the potential
    [./em_left]
        type = HagelaarElectronBC
        variable = em
        boundary = 'left'
        potential = potential
        mean_en = mean_en
        r = 0
        position_units = ${dom0Scale}
    [../]

    [./secondary_em_left]
        type = SecondaryElectronBC
        variable = em
        boundary = 'left'
        potential = potential
        ip = Ar+
        mean_en = mean_en
        r = 0
        position_units = ${dom0Scale}
    [../]

    # electron density at the water
    [./em_water]
        type = HagelaarElectronBC
        variable = em
        boundary = 'master0_interface'
        potential = potential
        mean_en = mean_en
        r = 0.99
        position_units = ${dom0Scale}
    [../]


    [Ar+_Diffusion_left]
        type = HagelaarIonDiffusionBC
        variable = Ar+
        boundary = 'left'
        r = 0
        position_units = ${dom0Scale}
    [../]

    [Ar+_Advection_left]
        type = HagelaarIonAdvectionBC
        variable = Ar+
        boundary = 'left'
        potential = potential
        r = 0
        position_units = ${dom0Scale}
    [../]
    # We assume that argon interacts at the water but does get absobed enough to get a BC at the ground

    [Ar+_Diffusion_water]
        type = HagelaarIonDiffusionBC
        variable = Ar+
        boundary = 'master0_interface'
        r = 0
        position_units = ${dom0Scale}
    [../]

    [Ar+_Advection_water]
        type = HagelaarIonAdvectionBC
        variable = Ar+
        boundary = 'master0_interface'
        potential = potential
        r = 0
        position_units = ${dom0Scale}
    [../]
    ## Water conditions only exist on the right because the right is the only one in water
    # liquid electrons only have BCs at the right because they don't exist in the air and we are assuming they do not diffuse into the air
    [./emliq_right]
        type = DCIonBC
        variable = emliq
        boundary = 'right'
        potential = potential
        position_units = ${dom1Scale}
    [../]

    [./OH-_right]
        type = DCIonBC
        variable = OH-
        boundary = 'right'
        potential = potential
        position_units = ${dom1Scale}
    [../]
[]

[ICs]
    [./potential_ic]
        type = FunctionIC
        variable = potential
        function = potential_ic_function # potential IC function is not 0 for stability of the solution
        # if there is no block ID then the condition will apply to all the block in the mesh
    [../]

    [./mean_en_ic]
        type = ConstantIC
        variable = mean_en
        value = -20
        block = 0
    [../]
    [./em_ic]
        type = ConstantIC
        variable = em
        value = -21
        block = 0
    [../]

    [./Ar+_ic]
        type = ConstantIC
        variable = Ar+
        value = -21
        block = 0
    [../]

## Water ICs
    [./emliq_ic]
        type = ConstantIC
        variable = emliq
        value = -21
        block = 1
    [../]

    [./OH-_ic]
        type = ConstantIC
        variable = OH-
        value = -15.6
        block = 1
    [../]
[]

[Functions]
    [./potential_bc_function]
        type = ParsedFunction
        value = '-1.25' #value needs to be negative becuase the elctrode is seen as the anode
    [../]

    [./potential_ic_function]
        type = ParsedFunction
        value = '-1.25 * (1.0001e-3 - x)' # the potential needs a small spark for solution stability
    [../]

    [./potential_bc_func]
      type = ParsedFunction
      # value = '1.25*tanh(1e6*t)'
      value = -1.25
    [../]
    
    [./potential_ic_func]
      type = ParsedFunction
      value = '-1.25 * (1.0001e-3 - x)'
    [../]
[]


[Materials]
    [./Argon_electrons]
        type = GasElectronMoments
        # will be used for water as well
        interp_trans_coeffs = true #set true for variable mu and diff
        interp_elastic_coeff = true #set true for variable mu and diff
        ramp_trans_coeffs = false
        user_p_gas = 101325
        user_T_gas = 300
        user_se_coeff = 0.05 ## changing this from default to 0.05 caused the solve to fail
        em = em
        potential = potential
        mean_en = mean_en
        ## This is not read when user provides mobility and diffusivity
        property_tables_file = rate_coefficients_lindsay/electron_moments.txt
        position_units = ${dom0Scale}
        block = 0
    [../]

    [./Argon_ions]
        # charged particles need mobility and diffusivity
        # mobility accounts for affects from electric fields
        # diffusivity accounts for the motion of the particles
        type = HeavySpeciesMaterial
        heavy_species_name = Ar+
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 1.0
        mobility = 1.8939e-04
        diffusivity = 5.2463e-06
        block = 0
    [../]

    [./Argon_neutrals]
        # neutral species do not mobility or diffusivity becuase we are not keeping track of them
        type = HeavySpeciesMaterial
        heavy_species_name = Ar
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 0.0
        block = 0
    [../]
    # this block is only being used to get the constants for the rest of the species in the block
    # using constant water properties becuase eps is different in the Waster.C file than in GasElectronMoments
    # that difference also changes the diffpotential value
    [./water_properties]
        type = GenericConstantMaterial
        prop_names = 'eps T_gas p_gas user_se_coeff N_A e  k_boltz diffpotential'
        prop_values = '7.0800e-10 300 101325 0.05 6.02e23 1.6e-19 1.38e-23 7.0800e-10'
        block = 1
    [../]

    [./Hydrated_electrons]
        type = HeavySpeciesMaterial
        heavy_species_name = emliq
        heavy_species_mass = 9.109e-31
        heavy_species_charge = -1
        mobility =  1.7391e-07
        diffusivity = 4.5e-9
        block = 1
    [../]

    [./OH-]
        type = HeavySpeciesMaterial
        heavy_species_name = OH-
        heavy_species_mass = 2.8246e-23
        heavy_species_charge = -1
        mobility = 2.0367e-7
        diffusivity = 5.27e-9
        block = 1
    [../]
[]

[Executioner]
    type = Transient
    end_time = 1e-1
    petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
    solve_type = NEWTON
    petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda'
    petsc_options_value = 'lu NONZERO 1.e-10 preonly 1e-3'
    nl_rel_tol = 1e-4
    nl_abs_tol = 7.6e-5
    dtmin = 1e-12
    l_max_its = 20
    [./TimeStepper]
    # interative time stepper is used for DC discharge because we can take larger and larger steps due to the steady state behaiour
        type = IterationAdaptiveDT
        cutback_factor = 0.4
        dt = 1e-11
        growth_factor = 1.2
        optimal_iterations = 15
    [../]
[]

[Outputs]
    perf_graph = true
  [./out]
    type = Exodus
  [../]
[]
