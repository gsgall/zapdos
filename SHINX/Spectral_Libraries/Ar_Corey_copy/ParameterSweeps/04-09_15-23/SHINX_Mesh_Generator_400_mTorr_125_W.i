# Generate initial particle distribution for the microwave source

# Define system specific constants for re-use
dom0Scale = 1.0
nu = 2.49e9                     # GHz
T_gas = 300                     # K
em0 = 1e12                      # e/m^3

# Parameters that change during pressure sweep
P_gas = 5.333e+01
Power = 1.250e+02
Nbg = 1.288e+22
mu_ion = 3.610e-01
D_ion = 1.607e-02
Target_File = 'SHINX_EM_Solver_400_mTorr_125_W.i'

# Change during delta sweep
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
        file = ../../Microwave_Source.msh
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
        pressure_dependent_electron_coeff = true
        user_T_gas = '${T_gas}'
        em = em
        mean_en = mean
        property_tables_file = ../../ElectronProperties/electron_moments.txt
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
    [ADPlasmaDielectic]
        type = PlasmaDielectricConstant
        driving_frequency = '${nu}'
        em = em
        electron_neutral_collision_frequency = nu_neutral
        electron_neutral_collision_frequency_gradient = grad_nu_neutral
        block = Plasma
    []
  
    # Electron collission frequency
    [ADCollisionFreq]
        type = DependentCollisionFreq
        field_property_name = field_solver_interface_property
        electrons = em
        mean_energy = mean
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

    # Ground state species for chemistry model
    [Ar_prop]
        type = ADHeavySpecies
        heavy_species_name = Ar
        heavy_species_mass = 6.64e-26
        heavy_species_charge = 0.0
        block = Plasma
    []

[]

# Input reactions (update)
[Reactions]
    species = 'em'
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
    reactions = 'em + Ar -> em + Ar          : EEDF (ar_elastic.txt)
                 em + Ar -> em + Ar_m        : EEDF [-11.5] (ar_excitation.txt)
                 em + Ar -> em + em + Ar_I   : EEDF [-15.8] (ar_ionization.txt)' 
[]

# Set boundary conditions for domain
[BCs]

    ###############################################################
    # Log-molar electron BCs
    ###############################################################

    # Electron boundary conditions
    [em_BC1]
        type = SakiyamaElectronDiffusionBC
        variable = em
        mean_en = mean
        boundary = 'chamber_walls Plasma_Side'
        position_units = '${dom0Scale}'
        electron_energy = mean
    []
    [em_BC2]
        type = DriftDiffusionDoNothingBC
        variable = em
        mu = 0
        diff = 0
        sign = 0
        use_material_props = true
        boundary = 'chamber_bottom'
        position_units = '${dom0Scale}'
    []

    ###############################################################
    # Electron energy BCs
    ###############################################################

    # Electron energy boundary conditions
    [mean_BC1]
        type = SakiyamaEnergyDiffusionBC
        variable = mean
        em = em
        boundary = 'chamber_walls Plasma_Side'
        position_units = '${dom0Scale}'
        electron_energy = mean
    []
    [mean_BC2]
        type = DriftDiffusionDoNothingBC
        variable = mean
        mu = 0
        diff = 0
        sign = 0
        use_material_props = true
        boundary = 'chamber_bottom'
        position_units = '${dom0Scale}'
    []

[]

# Set initial conditions
[ICs]

    ###############################################################
    # Log-molar electron density ICs
    ###############################################################
    
    # Electron density initial condition (main)
    [em_IC]
        type = FunctionIC
        variable = em
        function = initial_em
    []

    # Electron density initial condition (aux)
    [em_aux_IC]
        type = FunctionIC
        variable = em_aux
        function = initial_em
    []

    ###############################################################
    # Log-molar electron density ICs
    ###############################################################

    # Electron energy initial condition (main)
    [mean_IC]
        type = FunctionIC
        variable = mean
        function = initial_mean
    []

    # Electron energy initial condition (aux)
    [mean_aux_IC]
        type = FunctionIC
        variable = mean_aux
        function = initial_mean
    []

[]

# Define functions for calculations
[Functions]

    ###############################################################
    # Log-molar electron density
    ###############################################################

    # Log-molar electron density
    [initial_em]
        type = ParsedFunction
        expression = 'log(${em0} / 6.022e23)'
    []

    ###############################################################
    # Electron energy distribution
    ###############################################################

    # Logarithm of energy profile
    [initial_mean]
        type = ParsedFunction
        symbol_names = 'initial_em'
        symbol_values = 'initial_em'
        expression = 'log(4.0 * 3/2) + initial_em'
    []

    ###############################################################
    # Current power delivery
    ###############################################################

    # Coefficient to change I-power
    [alpha]
        type = ParsedFunction
        symbol_names = 'Q delta_t'
        symbol_values = 'P_tot delta_t'
        expression = 'if(delta_t > 1e-7, ${Power} / Q, 0.1 * (delta_t / 1e-7) * (${Power} / Q))'
    []

[]

# Define problem variables form primary kernels
[Variables]

    ###############################################################
    # Dummy variable - keep EM and Plasma meshes aligned
    ###############################################################

    # Dummy variable to align EM and chemistry solver
    [Dummy]
        block = 'Resonator_Pin Ceramic'
    []

    ###############################################################
    # Electron properties
    ###############################################################

    # Log-molar electrons
    [em]
        block = Plasma
    []

    ###############################################################
    # Electron energy
    ###############################################################

    # Mean electron energy
    [mean]
        block = Plasma
    []

    ###############################################################
    # Electric field
    ############################################################### 

    # Electric Field
    [E_field]
        family = LAGRANGE_VEC
        order = FIRST
        block = Plasma
    []

[]

# Solve for DE quantities
[Kernels]

    ###############################################################
    # Dummy variable - keep EM and Plasma meshes aligned
    ###############################################################

    [Dummy]
        type = NullKernel
        varible = Dummy
        block = 'Resonator_Pin Ceramic'
    []

    ###############################################################
    # Electron properties
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
    # Electron energy properties
    ###############################################################

    # Derivative of electron energy
    [mean_dt]
        type = ElectronTimeDerivative
        variable = mean
        block = Plasma
    []

    # Electron energy advection
    [mean_advection]
        type = EFieldAdvection
        variable = mean
        position_units = '${dom0Scale}'
        block = Plasma
    []

    # Electron energy diffusion
    [mean_diffusion]
        type = CoeffDiffusion
        variable = mean
        position_units = '${dom0Scale}'
        block = Plasma
    []

    # Joule heating terms
    [mean_Q_joule]
        type = JouleHeating
        variable = mean
        em = em
        position_units = '${dom0Scale}'
        block = Plasma
    []

    # Microwave heating
    [mean_Q_microwave]
        type = CoupledHeating
        variable = mean
        heating_term = Q_cond
    []

    ###############################################################
    # Electric field
    ###############################################################

    # Ambipolar electric field
    [E_ambipolar]
        type = AmbipolarEField
        variable = E_field
        em = em
        ion_mobility = '${mu_ion}'
        ion_diffusion = '${D_ion}'
        block = Plasma
    []

[]

# Initiate variables for auxkernels
[AuxVariables]

    ###############################################################
    # Electron densities
    ###############################################################

    # Log-molar electron density (copy)
    [em_aux]
        block = Plasma
    []

    # Electron density
    [ne]
        family = MONOMIAL
        order = CONSTANT
        block = Plasma
    []

    ###############################################################
    # Electron energy
    ###############################################################

    # Logarithm of mean electron energy (copy)
    [mean_aux]
        block = Plasma
    []

    # Conductive heating
    [Q_cond]
        family = MONOMIAL
        order = CONSTANT
        block = Plasma
    []
    
    # Electron temperature
    [Te]
        family = MONOMIAL
        order = CONSTANT
        block = Plasma
    []

    ###############################################################
    # Gas species (update)
    ###############################################################

    # Ground state species
    [Ar]
    []

[]

# Compute secondary quantities
[AuxKernels]

    ###############################################################
    # Electron densities
    ###############################################################

    # Logarithm of electron density
    [em_aux]
        type = ProjectionAux
        variable = em_aux
        v = em
        block = Plasma
        execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
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
    # Electron energies
    ###############################################################

    # Logarithm of energy density
    [mean_aux]
        type = ProjectionAux
        variable = mean_aux
        v = mean
        block = Plasma
        execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
    []

    # Electron temperature
    [Te]
        type = ElectronTemperature
        variable = Te
        electron_density = em
        mean_en = mean
    []

    ###############################################################
    # Gas species (update)
    ###############################################################

    # Ground state densities
    [n_Ar]
        type = FunctionAux
        variable = Ar
        function = 'log(${Nbg} / 6.022e23)'
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
        block = Plasma
        execute_on = 'TIMESTEP_BEGIN'
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
    
[]

# Couple to EM solver through multi-apps
[MultiApps]
    [EM_Heating]
        type = FullSolveMultiApp
        input_files = '${Target_File}'
        execute_on = 'INITIAL TIMESTEP_END'
    []
[]

# Transfer variables between MOOSE scripts
[Transfers]
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
[]

# Set output file types
[Outputs]
   
    # Enable residuals
    print_linear_residuals = true

    # Exodus output
    [exo_out]
      type = Exodus
      execute_on = 'INITIAL TIMESTEP_END'
    []

    # CSV output
    [csv_out]
      type = CSV
      execute_on = 'FINAL'
    []

[]

# Precondition solver before executing
[Preconditioning]

    # Single matrix preconditioning
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
    end_time = 1e-6
    scheme = newmark-beta
    solve_type = 'NEWTON'
    automatic_scaling = true
    compute_scaling_once = false
    line_search = none
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -pc_factor_shift_type -pc_factor_shift_amount'
    petsc_options_value = 'lu       superlu_dist                  NONZERO               1.e-10'
    l_max_its = 50
    nl_abs_tol = 1e-8
    nl_max_its = 15
[]
  
# Enable debugger
[Debug]
    show_var_residual_norms = true
[]
