# Main script for microwave source CRM

# Define system specific constants for re-use
dom0Scale = 1.0
nu = 2.49e9                     # GHz
T_gas = 300                     # K

# Values that change during pressure-power sweep
P_gas = 133.322                 # Pa 
Power = 25                      # W
Nbg = 3.22e22                   # Ar/m^3
mu_ion = 0.144409938            # Ion mobility
D_ion = 6.428571e-3             # Ion diffusion
Source_File = 'SHINX_Mesh_Generator_exo_out.e'
Target_File_1 = 'SHINX_EM_Solver.i'
Target_File_2 = 'SHINX_Chemistry_Solver.i'

# Values that change during delta sweep
delta = 20                      

# Define global variables
[GlobalParams]
    potential_units = V
    use_moles = true
[]

# Define problem type as finite element problem
[Problem]
    type = FEProblem
[]

# Generate mesh
[Mesh]
    
    # Provide chamber mesh
    [fmg]
        type = FileMeshGenerator
        file = '${Source_File}'
    []

    # Set boundaries between plasma and ceramic subdomain
    [Interface_Ceramic]
        type = SideSetsBetweenSubdomainsGenerator
        primary_block = 'Ceramic'
        paired_block = 'Plasma'
        new_boundary = 'Ceramic_Side'
        input = fmg
    []
    [Interface_Plasma]
        type = SideSetsBetweenSubdomainsGenerator
        primary_block = 'Plasma'
        paired_block = 'Ceramic'
        new_boundary = 'Plasma_Side'
        input = Interface_Ceramic
    []

    # Set mesh properties
    coord_type = RZ
    rz_coord_axis = Y
    second_order = true

[]

# Define material properties
[Materials]

    ###############################################################
    # Reactor materials
    ###############################################################

    # Pin properties
    [Pin_Basic]
        type = GasElectronMoments
        interp_trans_coeffs = false
        interp_elastic_coeff = false
        ramp_trans_coeffs = false  
        user_p_gas = '${P_gas}'
        user_drive_freq = '${nu}'
        user_T_gas = '${T_gas}'
        property_tables_file = ../../ElectronProperties/electron_moments.txt
        block = Resonator_Pin
    []

    # Ceramic properties
    [Ceramic_Basic]
        type = GasElectronMoments
        interp_trans_coeffs = false
        interp_elastic_coeff = false
        ramp_trans_coeffs = false
        user_p_gas = '${P_gas}'
        user_drive_freq = '${nu}'
        user_T_gas = '${T_gas}'
        property_tables_file = ../../ElectronProperties/electron_moments.txt
        block = Ceramic
    []

    # Plasma properties
    [Plasma_Basic]
        type = GasElectronMoments
        interp_trans_coeffs = true
        interp_elastic_coeff = false
        ramp_trans_coeffs = false
        user_p_gas = '${P_gas}'
        user_drive_freq = '${nu}'
        user_T_gas = '${T_gas}'
        pressure_dependent_electron_coeff = true
        em = em
        mean_en = mean_en
        property_tables_file = ../../ElectronProperites/electron_moments.txt
        block = Plasma
    []
  
    ###############################################################
    # Electromagnetic properties
    ###############################################################
  
    # Electric feild potential
    [Field_Solver]
        type = FieldSolverMaterial
        electric_field = E_field
        solver = electromagnetic
        block = Plasma
    []
  
    # Plasma wave coefficient
    [ADWaveCoeffPlasma]
        type = WaveEquationCoefficient
        prop_name_real = plasma_wave_coeff_real
        prop_name_imaginary = plasma_wave_coeff_imag
        k_real = ang_freq
        mu_rel_real = mu_vacuum
        mu_rel_imag = 0
        eps_rel_real = plasma_dielectric_constant_real
        eps_rel_imag = plasma_dielectric_constant_imag
        block = Plasma
    []

    # Plasma dielectric constant
    [ADPlasmaDielectric]
        type = PlasmaDielectricConstant
        driving_frequency = '${nu}'
        em = em
        electron_neutral_collision_frequency = nu_neutral
        electron_neutral_collision_frequency_gradient = grad_nu_neutral
        block = Plasma
    []
  
    # Electron neutral collision frequency
    [ADCollisionFreq]
        type = DependentCollisionFreq
        field_property_name = field_solver_interface_property
        electrons = em
        mean_energy = mean_en
        use_mean_energy = true
        driving_frequency = '${nu}'
        delta = '${delta}'
        file_location = ''
        property_file = ../../ElectronProperties/collision_frequency.txt
        block = Plasma
    []

    ###############################################################
    # Gas species (update)
    ###############################################################

    # Ground state species
    [Ar_prop]
        type = ADHeavySpecies
        heavy_species_name = Ar
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 0.0
        block = Plasma
    []

    # Metastable species
    [Ar_m_prop]
        type = ADHeavySpecies
        heavy_species_name = Ar_m
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 0.0
        diffusivity = 3.7577e-02
        mobility = 0.0
    []

[]

# Input reactions (update)
[Reactions]
    species = 'em Ar_m'
    aux_species = 'Ar'
    reaction_coefficient_format = ''
    gas_species = 'Ar'
    electron_density = 'em'
    electron_energy = 'mean'
    include_electrons = true
    file_location = 'ReactionRates/ReducedModel'
    use_log = true
    use_ad = true
    position_units = '${dom0Scale}'
    block = 0
    reactions = 'em + Ar -> em + Ar                 : EEDF (ar_elastic.txt)
                 em + Ar -> em + Ar_m               : EEDF [-11.5] (ar_excitation.txt)
                 em + Ar -> em + em + Ar_I          : EEDF [-15.8] (ar_ionization.txt)
                 em + Ar_m -> em + Ar               : EEDF [11.56] (ar_deexcitation.txt)
                 em + Ar_m -> em + em + Ar_I        : EEDF [-4.14] (ar_excited_ionization.txt)
                 em + Ar_m -> em + Ar_r             : 1.2044e11
                 Ar_m + Ar_m -> Ar + Ar + em        : 373364000
                 Ar_m + Ar -> Ar + Ar               : 1806.6
                 Ar_m + Ar + Ar -> Ar_2 + Ar        : 39890.9324'

[]

# Set boundary conditions for domain
[BCs]

    ###############################################################
    # Log-molar electron BCs
    ###############################################################

    [em_BC1]
        type = SakiyamaElectronDiffusionBC
        variable = em
        mean_en = mean_en
        boundary = 'Chamber_Walls  Plasma_Side'
        position_units = '${dom0Scale}'
    []
    [em_BC2]
        type = DriftDiffusionDoNothingBC
        variable = em
        mu = 0
        diff = 0
        sign = 0
        use_material_props = true
        boundary = 'Chamber_Bottom'
        position_units = '${dom0Scale}'
    []
    
    ###############################################################
    # Electron energy BCs
    ###############################################################

    [mean_BC1]
        type = SakiyamaEnergyDiffusionBC
        variable = mean_en
        em = em
        boundary = 'Chamber_Walls Plasma_Side'
        position_units = '${dom0Scale}'
    []
    [mean_BC2]
        type = DriftDiffusionDoNothingBC
        variable = mean_en
        mu = 0
        diff = 0
        sign = 0
        use_material_props = true
        boundary = 'Chamber_Bottom'
        position_units = '${dom0Scale}'
    []
  
    ###############################################################
    # Metastable boundary conditions (update)
    ###############################################################

    [Ar_m_BC1]
        type = PenaltyDirichletBC
        variable = Ar_m
        boundary = 'Chamber_Walls'
        value = -50
        penalty = 1
    []
    [Ar_m_BC2]
        type = DriftDiffusionDoNothingBC
        variable = Ar_m
        mu = 0
        diff = 0
        sign = 0
        use_material_props = true
        boundary = 'Chamber_Bottom Plasma_Side'
        position_units = '${dom0Scale}'
    []
  
    ###############################################################
    # Metastable boundary conditions - SM (update)
    ###############################################################

    [Ar_m_SM_BC]
        type = DirichletBC
        variable = Ar_m
        boundary = 'Chamber_Bottom Plasma_Side'
        value = 0
        preset = false
        enable = false
    []

[]

# Define functions for calculations
[Functions]
  
    ###############################################################
    # Current power delivery
    ###############################################################

    # Coefficient to change I-power
    [alpha]
      type = ParsedFunction
      symbol_names = 'Q delta_t'
      symbol_values = 'P_tot delta_t'  
      expression = '${Power} / Q'
    []

[]
  
# Define problem variables form primary kernels
[Variables]

    ###############################################################
    # Dummy variable to keep meshes align
    ###############################################################

    [Dummy]
        block = 'Resonator_Pin Ceramic'
    []
  
    ###############################################################
    # Log-molar electron density
    ###############################################################

    [em]
        initial_from_file_var = em
        initial_from_file_timestep = LATEST
        block = Plasma
    []

    ###############################################################
    # Electron energy distributions
    ###############################################################

    [mean_en]
        initial_from_file_var = mean_en
        initial_from_file_timestep = LATEST
        block = Plasma
    []

    ###############################################################
    # Shooting method inputs for metastables
    ###############################################################

    [E_field]
        family = LAGRANGE_VEC
        order = FIRST
        block = Plasma
    []

    ###############################################################
    # Metastable species (update)
    ###############################################################
  
    [Ar_m]
        initial_from_file_var = Ar_m
        initial_from_file_timestep = LATEST
        block = Plasma
    []

    ###############################################################
    # Shooting method inputs for metastables (update)
    ###############################################################

    [Ar_m_SM]
        initial_condition = 1.0
        initial_from_file_var = Ar_m_SM
        initial_from_file_timestep = LATEST
        block = Plasma
    []

[]

# Solve for DE quantities
[Kernels]

    ###############################################################
    # Dummy variable to keep meshes align
    ###############################################################  

    # Dummy variable to align meshes
    [Dummy]
        type = NullKernel
        variable = Dummy
        block = 'Resonator_Pin Ceramic'
    []
  
    ###############################################################
    # Log-molar electron density
    ###############################################################
  
    # Electron time derivative 
    [em_dt]
        type = ElectronTimeDerivative
        variable = em
        block = Plasma
    []

    # Electron advection
    [em_advection]
        type = EFieldAdvection
        variable = em
        position_units = '${dom0Scale}'
        block = Plasma
    []

    # Electron diffusion
    [em_diffusion]
        type = CoeffDiffusion
        variable = em
        position_units = '${dom0Scale}'
        block = Plasma
    []
  
    ###############################################################
    # Electron energy distribution
    ###############################################################

    # Electron energy time derivative
    [mean_dt]
        type = ElectronTimeDerivative
        variable = mean_en
        block = Plasma  
    []

    # Electron energy advection
    [mean_en_advection]
        type = EFieldAdvection
        variable = mean_en
        position_units = '${dom0Scale}'
        block = Plasma
    []

    # Electron energy diffusion
    [mean_en_diffusion]
        type = CoeffDiffusion
        variable = mean_en
        position_units = '${dom0Scale}'
        block = Plasma
    []
    
    # Joule heating
    [mean_Q_joule]
        type = JouleHeating
        variable = mean_en
        em = em
        position_units = '${dom0Scale}'
        block = Plasma
    []

    # Microwave heating
    [mean_Q_microwave]
        type = CoupledHeating
        variable = mean_en
        heating_term = Q_cond
    []
    
    ###############################################################
    # Electric field
    ###############################################################

    # Ambipolar electric field
    [ambipolar_Efield]
        type = AmbipolarEField
        variable = E-field
        em = em
        ion_mobility = '${mu_ion}'
        ion_diffusion = '${D_ion}'
        block = Plasma
    []

    ###############################################################
    # Metastable properties (update)
    ###############################################################

    # Metastable time derivative
    [Ar_m_dt]
        type = ElectronTimeDerivative
        variable = Ar_m
        block = Plasma
    []

    # Metastable diffusion
    [Ar_m_diffusion]
        type = CoeffDiffusion
        variable = Ar_m
        position_units = '${dom0Scale}'
        block = Plasma
    []

    ###############################################################
    # Metastable senstivity matrix properties (update)
    ###############################################################

    # Metastable SM time derivative
    [Ar_m_SM_dt]
        type = MassLumpedTimeDerivative
        variable = Ar_m_SM
        enable = false
        block = Plasma
    []

    # Metastable SM diffusion
    [Ar_m_SM_diffusion]
        type = CoeffDiffusionForShootMethod
        variable = Ar_m_SM
        density = Ar_m
        position_units = '${dom0Scale}'
        enable = false
        block = Plasma
    []

    # Loss of metastable for SM from stepwise ionization
    [Ar_m_SM_stepwise_ionization]
        type = EEDFReactionLogForShootMethod
        variable = Ar_m_SM
        electron = em
        density = Ar_m
        reaction = 'em + Ar_m -> em + em + Ar_I'
        coefficient = -1
        enable = false
        block = Plasma
    []

    # Loss of metastable for SM from superelastic collisions
    [Ar_m_SM_collisions]
        type = EEDFReactionLogForShootMethod
        variable = Ar_m_SM
        electron = em
        density = Ar_m
        reaction = 'em + Ar_m -> em + Ar'
        coefficient = -1
        enable = false
        block = Plasma
    []

    # Loss of metastable for SM from quenching
    [Ar_m_SM_quenching]
        type = ReactionSecondOrderLogForShootMethod
        variable = Ar_m_SM
        density = Ar_m
        v = em
        reaction = 'em + Ar_m -> em + Ar_r'
        coefficient = -1
        enable = false
        block = Plasma
    []

    # Loss of metastable for SM from metastable pooling
    [Ar_m_SM_pooling]
        type = ReactionSecondOrderLogForShootMethod
        variable = Ar_m_SM
        density = Ar_m
        v = Ar_m
        reaction = 'Ar_m + Ar_m -> Ar_I + Ar + em'
        coefficient = -2
        enable = false
        block = Plasma
    []

    # Loss of metastable for SM from 2-body quenching
    [Ar_m_SM_2B_quenching]
        type = ReactionSecondOrderLogForShootMethod
        variable = Ar_m_SM
        density = Ar_m
        v = Ar
        reaction = 'Ar_m + Ar -> Ar + Ar'
        coefficient = -1
        enable = false
        block = Plasma
    []

    # Loss of metastable for SM from 3-body quenching
    [Ar_m_SM_3B_quenching]
      type = ReactionThirdOrderLogForShootMethod
      variable = Ar_m_SM
      density = Ar_m
      v = Ar
      w = Ar
      reaction = 'Ar_m + Ar + Ar -> Ar_2 + Ar'
      coefficient = -1
      enable = false
      block = Plasma
    []
  
    # Metastable SM Null kernel
    [Ar_m_SM_Null]
      type = NullKernel
      variable = Ar_m_SM
      block = Plasma
    []
  
[]

# Initiate variables for auxkernels
[AuxVariables]

    ###############################################################
    # Electron number density
    ###############################################################  

    # Log-molar electron density
    [em_aux]
        initial_from_file_var = em_aux
        initial_from_file_timestep = LATEST
        block = Plasma
    []

    # Electron number density
    [ne]
        order = CONSTANT
        family = MONOMIAL
        block = Plasma
    []

    ###############################################################
    # Electron energy
    ###############################################################  

    # Electron energy (copy)
    [mean_aux]
        initial_from_file_var = mean_aux
        initial_from_file_timestep = LATEST
        block = Plasma
    []

    # Electron temperature
    [Te]
        order = CONSTANT
        family = MONOMIAL
        block = Plasma
    []

    # Conductive heating
    [Q_cond]
        family = MONOMIAL
        order = CONSTANT
        block = Plasma
    []

    ###############################################################
    # Gas species (update)
    ###############################################################

    # Log-molar ground state density
    [Ar]
    []

    # Metastable density
    [Ar_m_aux]
        initial_from_file_var = Ar_m_aux
        initial_from_file_timestep = LATEST
        block = Plasma
    []

    # Metastable density
    [n_Ar_m]
        order = CONSTANT
        family = MONOMIAL
        block = Plasma
    []

    ###############################################################
    # Gas species - SM (update)
    ###############################################################

    # Initial metastable densities for SM
    [Ar_m_i]
        initial_from_file_var = Ar_m_i
        initial_from_file_timestep = LATEST
        block = Plasma
    []

    # Identity matrix for metastable SM
    [Ar_m_ID]
        initial_condition = 1.0
        initial_from_file_var = Ar_m_ID
        initial_from_file_timestep = LATEST
        block = Plasma
    []
  
[]

# Compute secondary quantities
[AuxKernels]

    ###############################################################
    # Electron number density
    ############################################################### 

    # Log-molar electron density
    [em_aux]
        type = SelfAux
        variable = em_aux
        v = em
        execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
        block = Plasma
    []

    # Electron density
    [ne]
        type = DensityMoles
        variable = ne
        density_log = em
        block = Plasma
        execute_on = 'INITIAL LINEAR TIMESTEP_END'
    []

    ###############################################################
    # Electron energy
    ###############################################################
    
    # Electron energy (copy)
    [mean_aux]
        type = SelfAux
        variable = mean_aux
        v = mean_en
        block = Plasma
        execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
    []

    # Electron temperature
    [Te]
        type = ElectronTemperature
        variable = Te
        electron_density = em
        mean_en = mean_en
        execute_on = 'INITIAL LINEAR TIMESTEP_END'
        block = Plasma
    []
  
    ###############################################################
    # Gas species (update)
    ###############################################################

    # Log-molar ground state density
    [Ar]
        type = FunctionAux
        variable = Ar
        function = 'log(${Nbg} / 6.022e23)'
        execute_on = INITIAL
        block = Plasma
    []

    # Log-molar metastable density
    [Ar_m_aux]
        type = SelfAux
        variable = Ar_m_aux
        v = Ar_m
        execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
        block = Plasma
    []
  
    # Metastable density
    [n_Ar_m]
      type = DensityMoles
      variable = n_Ar_m
      density_log = Ar_m
      block = Plasma
      execute_on = 'INITIAL LINEAR TIMESTEP_END'
    []

    ###############################################################
    # Gas species - SM (update)
    ###############################################################

    # Initial metastable densities for SM
    [Ar_m_i]
        type = QuotientAux
        variable = Ar_m_i
        numerator = Ar_m
        denominator = 1.0
        enable = false
        execute_on = 'TIMESTEP_END'
        block = Plasma
    []
  
    # Identity matrix for metastable SM
    [Ar_m_ID]
        type = ConstantAux
        variable = Ar_m_ID
        value = 1.0
        execute_on = INITIAL
        block = Plasma
    []

[]  

# Define stored variables as post-processors
[Postprocessors]

    ###############################################################
    # Electromagnetic solver inputs
    ###############################################################

    # Introduce timestep
    [delta_t]
        type = FunctionValuePostprocessor
        function = 't'
    []

    # Current from previous timestep
    [I_old]
        type = Receiver
    []

    # Heating parameter
    [alpha]
        type = FunctionValuePostprocessor
        function = alpha
    []

    # Average pin power
    [pin_power]
        type = Receiver
    []
  
    # Average plasma power
    [P_avg]
        type = ElementAverageValue
        variable = Q_cond
        block = Plasma
    []
  
    # Total plasma power
    [P_tot]
        type = ElementIntegralVariablePostprocessor
        variable = Q_cond
        execute_on = 'TIMESTEP_BEGIN'
        block = Plasma
    []
  
    # Plasma volume
    [V]
        type = VolumePostprocessor
        block = Plasma
    []
  
    # em and Te at POI
    [em_12below]
        type = PointValue
        point = '0 0.228 0'
        variable = em_aux
    []
    [Te_12below]
        type = PointValue
        point = '0 0.228 0'
        variable = Te
    []
  
    ###############################################################
    # Relative change in metastable densities (update)
    ###############################################################

    # Metastable differences
    [Ar_m_delta]
        type = Receiver
    []

[]

# Couple to EM solver and shooting method through multi-apps
[MultiApps]

    # Electromagnetics solver
    [EM_Heating]
      type = FullSolveMultiApp
      input_files = 
      execute_on = 'INITIAL TIMESTEP_END'
      # execute_on = 'INITIAL'
    []
  
    # Shooting method for metastables
    [Shooting]
      type = FullSolveMultiApp
      input_files = 
      execute_on = 'TIMESTEP_END'
      enable = false
    []

[]

# Transfer variables between MOOSE scripts
[Transfers]

    ###############################################################
    # Electromagnetic solver inputs (update)
    ###############################################################

    [delta_t_to_EM]
        type = MultiAppPostprocessorTransfer
        to_multi_app = EM_Heating
        from_postprocessor = delta_t
        to_postprocessor = delta_t
    []
    [alpha_to_EM]
        type = MultiAppPostprocessorTransfer
        to_multi_app = EM_Heating
        from_postprocessor = alpha
        to_postprocessor = alpha
    []
    [em_aux_to_EM]
        type = MultiAppCopyTransfer
        to_multi_app = EM_Heating
        source_variable = em_aux
        variable = em_aux
    []
    [mean_aux_to_EM]
        type = MultiAppCopyTransfer
        to_multi_app = EM_Heating
        source_variable = mean_aux
        variable = mean_aux
    []
    [Q_cond_from_EM]
        type = MultiAppCopyTransfer
        from_multi_app = EM_Heating
        source_variable = Q_cond
        variable = Q_cond
    []
    [Pin_from_EM]
        type = MultiAppPostprocessorTransfer
        from_multi_app = EM_Heating
        from_postprocessor = pin_power
        to_postprocessor = pin_power
        reduction_type = average
    []
    [I_current_to_I_old]
        type = MultiAppPostprocessorTransfer
        from_multi_app = EM_Heating
        from_postprocessor = I_current
        to_postprocessor = I_old
        reduction_type = average
    []
    [I_old_to_I_old]
        type = MultiAppPostprocessorTransfer
        to_multi_app = EM_Heating
        from_postprocessor = I_old
        to_postprocessor = I_old
    []
    [Ar_m_aux_to_EM]
        type = MultiAppCopyTransfer
        to_multi_app = EM_Heating
        source_variable = Ar_m_aux
        variable = Ar_m_aux
    []
  
    ###############################################################
    # Transfer to shooting method solver (update)
    ###############################################################

    [Ar_m_ID_to_Shooting]
        type = MultiAppCopyTransfer
        direction = to_multiapp
        multi_app = Shooting
        source_variable = Ar_m_ID
        variable = Ar_m_ID
        enable = false
    []
    [Ar_m_to_Shooting]
        type = MultiAppCopyTransfer
        direction = to_multiapp
        multi_app = Shooting
        source_variable = Ar_m
        variable = Ar_m
        enable = false
    []
    [Ar_m_i_to_Shooting]
        type = MultiAppCopyTransfer
        direction = to_multiapp
        multi_app = Shooting
        source_variable = Ar_m_i
        variable = Ar_m_i
        enable = false
    []
    [Ar_m_f_to_Shooting]
        type = MultiAppCopyTransfer
        direction = to_multiapp
        multi_app = Shooting
        source_variable = Ar_m
        variable = Ar_m_f
        enable = false
    []
    [Ar_m_SM_to_Shooting]
        type = MultiAppCopyTransfer
        direction = to_multiapp
        multi_app = Shooting
        source_variable = Ar_m_SM
        variable = Ar_m_SM
        enable = false
    []
    [Ar_m_from_Shooting]
        type = MultiAppCopyTransfer
        direction = from_multiapp
        multi_app = Shooting
        source_variable = Ar_m
        variable = Ar_m
        enable = false
    []
    [Ar_m_ID_from_Shooting]
        type = MultiAppCopyTransfer
        direction = from_multiapp
        multi_app = Shooting
        source_variable = Ar_m_ID
        variable = Ar_m_ID
        enable = false
    []
    [Ar_m_delta_from_Shooting]
        type = MultiAppPostprocessorTransfer
        direction = from_multiapp
        multi_app = Shooting
        from_postprocessor = Ar_m_delta
        to_postprocessor = Ar_m_delta
        reduction_type = minimum
        enable = false
    []

[]

# The Action that adds the TimePeriod Controls to turn off and on the MultiApps (update)
[PeriodicControllers]
    [Shooting]
        Enable_at_cycle_start = '*::Ar_m_i_for_Shooting'
  
        Enable_during_cycle = '*::Ar_m_SM_time_deriv *::Ar_m_SM_diffusion *::Ar_m_SM_stepwise_ionization
                             *::Ar_m_SM_collisions *::Ar_m_SM_quenching *::Ar_m_SM_pooling
                             *::Ar_m_SM_2B_quenching *::Ar_m_SM_3B_quenching *::Ar_m_SM_BC'
        Enable_at_cycle_end = 'MultiApps::Shooting
                             *::Ar_m_ID_to_Shooting *::Ar_m_to_Shooting
                             *::Ar_m_i_to_Shooting *::Ar_m_f_to_Shooting
                             *::Ar_m_SM_to_Shooting *::Ar_m_from_Shooting
                             *::Ar_m_ID_from_Shooting *::Ar_m_meta_delta'
        cycle_frequency = 50e6  
        starting_cycle = 24
        cycles_between_controls = 24
        num_controller_set = 2000
        name = Shooting

    []
[]
  
# Set output file types
[Outputs]
    
    # Set output log settings
    print_linear_residuals = true
    checkpoint = true
    
    # Output to exodus file on successful run
    [exo_out]
      type = Exodus
      execute_on = 'INITIAL TIMESTEP_END'
    []

    # Output on fail run for debugging
    [fail_out]
      type = Exodus
      # execute_on = 'INITIAL TIMESTEP_END'
      execute_on = 'FAILED'
    []

[]

# Precondition solver before executing
[Preconditioning]

    # Single matrix pre-conditioner
    [SMP]
      type = SMP
      full = true
    []

[]

# Set executioner properties (consider extracting numerics)
[Executioner]
    type = Transient
    dt = 1e-9
    dtmin = 1e-15
    start_time = 1e-5
    end_time = 2e-5
    scheme = newmark-beta
    solve_type = 'NEWTON'
    automatic_scaling = true
    compute_scaling_once = false
    line_search = none
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -pc_factor_shift_type -pc_factor_shift_amount'
    petsc_options_value = 'lu       superlu_dist                  NONZERO               1.e-10'
    l_max_its = 50
    nl_abs_tol = 1e-5
    nl_max_its = 25
[]

# Enable debugger
[Debug]
    show_var_residual_norms = true
[] 
