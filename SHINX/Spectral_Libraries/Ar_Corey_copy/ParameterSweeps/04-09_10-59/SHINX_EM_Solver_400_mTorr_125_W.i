# Solve for electric field distribution for the microwave source

# Define system specific constants for re-use
nu = 2.49e9                     # GHz
T_gas = 300                     # K

# Parameters that change during pressure-power sweep
P_gas = 5.333e+01

# Parameters that change during delta sweep
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
    second_order = true
    coord_type = RZ
    rz_coord_axis = Y

[]

# Assign material properties
[Materials]
    
    ###############################################################
    # Chamber properties
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
        em = em_aux
        mean_en = mean_aux
        property_tables_file = ../../ElectronProperties/electron_moments.txt
        block = Plasma
    []

    # Steel properties
    [ADFunctionMaterials]
        type = ADGenericFunctionMaterial
        prop_names = 'steel_prop'
        prop_values = 'omegaMu_steel'
        block = Resonator_Pin
    []
    
    ###############################################################
    # Electromagnetic properties
    ###############################################################
  
    # Electric feild potential
    [Field_Solver]
        type = FieldSolverMaterial
        electric_field = E_real
        solver = electromagnetic
    []
  
    # Permeability pin electrode
    [ADWaveCoeffPin]
        type = WaveEquationCoefficient
        prop_name_real = pin_wave_coeff_real
        prop_name_imaginary = pin_wave_coeff_real
        k_real = ang_freq
        k_imag = 0
        mu_rel_real = mu_vacuum
        mu_rel_imag = 0
        eps_rel_real = 8.85e-12
        eps_rel_imag = 0
        block = Resonator_Pin
    []
  
    # Permeability of ceramic
    [ADWaveCoeffCeramic]
        type = WaveEquationCoefficient
        prop_name_real = ceramic_wave_coeff_real
        prop_name_imaginary = ceramic_wave_coeff_imag
        k_real = ang_freq
        mu_rel_real = mu_vacuum
        mu_rel_imag = 0
        eps_rel_real = 8.05714e-11
        eps_rel_imag = 0
        block = Plasma
    []
  
    # Wave propogation properties of plasma
    [ADPlasmaDielectic]
        type = PlasmaDielectricConstant
        driving_frequency = '${nu}'
        em = em_aux
        electron_neutral_collision_frequency = nu_neutral
        electron_neutral_collision_frequency_gradient = grad_nu_neutral
        block = Plasma
    []

    # Electron collission frequency
    [ADCollisionFreq]
        type = DependentCollisionFreq
        field_property_name = field_solver_interface_property
        electrons = em_aux
        mean_energy = mean_aux
        use_mean_energy = true
        driving_frequency = '${nu}'
        delta = '${delta}'
        file_location = ''
        property_file = ../../ElectronProperties/collision_frequency.txt
        block = Plasma
    []
  
    # Wave propogation properties
    [ADWaveCoeff]
        type = WaveEquationCoefficient
        prop_name_real = wave_coeff_real
        prop_name_imaginary = wave_coeff_imag
        k_real = ang_freq
        k_imag = 0
        mu_rel_real = mu_vacuum
        mu_rel_imag = 0
        eps_rel_real = 8.85e-12
        eps_rel_imag = 0
        block = Plasma
    []

[]

# Set boundary conditions for domain
[BCs]

    ###############################################################
    # Electric field BCs (real/imaginary)
    ###############################################################
  
    # Absorb all components of E-feild at chamber edges
    [E_field_BC1]
      type = VectorEMRobinBC
      variable = E_real
      component = real
      beta = beta
      coupled_field = E_imag
      mode = absorbing
      boundary = 'ceramic_hat chamber_walls chamber_bottom'
    []
    [E_field_BC2]
      type = VectorEMRobinBC
      variable = E_imag
      component = imaginary
      beta = beta
      coupled_field = E_real
      mode = absorbing
      boundary = 'ceramic_hat chamber_walls chamber_bottom'
    []

[]

# Define functions for calculations
[Functions]

    ###############################################################
    # Drive current
    ###############################################################
  
    # Calculate new current
    [I_new]
        type = ParsedFunction
        symbol_names = 'alpha I_old delta_t'
        symbol_values = 'alpha I_old delta_t'
        expression = 'if(delta_t > 0.0, sqrt(alpha) * I_old,-1e12 * 1.02e-5)'
    []

    # Apply new current assuming non imaginary component
    [I_real]
        type = ParsedVectorFunction
        symbol_names = 'I_new'
        symbol_values = 'I_new'
        expression_y = 'I_new'
    []
    [I_imag]   # Defaults to (0,0,0)
        type = ParsedVectorFunction
        expression_x = 0
        expression_y = 0
        expression_z = 0
    []

    ###############################################################
    # Wave properties
    ###############################################################
  
    # Define wavenumber (beta)
    [beta]
        type = ParsedFunction
        expression = '2*pi*${nu}/3e8'
    []

    # Frequency x magnetic permeability of stainless steele
    [omegaMu_steel]
        type = ParsedFunction
        expression = '(2*pi*${nu})*(4*pi*1e-7)'
    []

[]

# Define problem variables form primary kernels
[Variables]

    ###############################################################
    # Electric feild
    ###############################################################
  
    # Electric feild
    [E_real]
        family = NEDELEC_ONE
        order = FIRST
    []
    [E_imag]
        family = NEDELEC_ONE
        order = FIRST
    []

[]

# Solve for DE quantities
[Kernels]

    ###############################################################
    # Port needle electric feild
    ###############################################################

    # Calculate real components
    [pin_curl_real]
        type = CurlCurlField
        variable = E_real
        block = Resonator_Pin
    []
    [pin_coeff_real]
        type = ADVectorMatReaction
        variable = E_real
        mat_prop_coef = pin_wave_coeff_real
        positive = false
        block = Resonator_Pin
    []
    [pin_source_real] 
        type = VectorCurrentSource
        variable = E_real
        component = real
        source_real = I_real
        source_imag = I_imag
        block = Resonator_Pin
    []

    # Calculate imaginary components
    [pin_curl_imag]
        type = CurlCurlField
        variable = E_imag
        block = Resonator_Pin
    []
    [pin_coeff_imag]
        type = ADVectorMatReaction
        variable = E_imag
        mat_prop_coef = pin_wave_coeff_real                         
        positive = false
        block = Resonator_Pin
    []
    [pin_source_imag] 
        type = VectorCurrentSource
        variable = E_imag
        component = imaginary
        source_real = I_real
        source_imag = I_imag
        function_coefficient = omegaMu_steel
        block = Resonator_Pin
    []

    ###############################################################
    # Aluminum oxide electric feild
    ###############################################################

    # Calculate real components
    [ceramic_curl_real]
        type = CurlCurlField
        variable = E_real
        block = Ceramic
    []
    [ceramic_coeff_real]
        type = ADVectorMatReaction
        variable = E_real
        mat_prop_coef = ceramic_wave_coeff_real
        positive = false
        block = Ceramic
    []

    # Calculate imaginary components
    [ceramic_curl_imag]
        type = CurlCurlField
        variable = E_imag
        block = Ceramic
    []
    [ceramic_coeff_imag]
        type = ADVectorMatReaction
        variable = E_imag
        mat_prop_coef = ceramic_wave_coeff_real                 # Same question
        positive = false
        block = Ceramic
    []

    ###############################################################
    # Vacuum electric feild
    ###############################################################

    # Calculate real components
    [vacuum_curl_real]
        type = CurlCurlField
        variable = E_real
        block = Plasma
    []
    [vacuum_coeff_real]
        type = ADVectorMatReaction
        variable = E_real
        mat_prop_coef = ceramic_wave_coeff_real
        positive = false
        block = Plasma
    []
    [vacuum_current_real]
        type = ADConductiveCurrent
        variable = E_real
        component = real
        E_real = E_real
        E_imag = E_imag
        conductivity_real = plasma_conductivity_real
        conductivity_imag = plasma_conductivity_imag
        ang_freq = ang_freq
        permeability = mu_vacuum
        block = Plasma
    []

    # Calculate imaginary components
    [vacuum_curl_imag]
        type = CurlCurlField
        variable = E_imag
        block = Plasma
    []
    [vacuum_coeff_imag]
        type = ADVectorMatReaction
        variable = E_imag
        mat_prop_coef = wave_coeff_real                     # Same question
        positive = false
        block = Plasma
    []
    [vacuum_current_imag]
        type = ADConductiveCurrent
        variable = E_imag
        component = imaginary
        E_real = E_real
        E_imag = E_imag
        conductivity_real = plasma_conductivity_real
        conductivity_imag = plasma_conductivity_imag
        ang_freq = ang_freq
        permeability = mu_vacuum
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
    
    # Electron number density
    [ne]
        family = MONOMIAL
        order = FIRST
        block = Plasma
    []

    ###############################################################
    # Electron energies
    ###############################################################
  
    # Logarithm of mean electron energy (copy)
    [mean_aux]
        block = Plasma
    []

    # Electron temperature
    [Te]
        family = MONOMIAL
        order = FIRST
        block = Plasma
    []
    
    # Conductive heating of the plasma
    [Q_cond]
        family = MONOMIAL
        order = CONSTANT
        block = Plasma
    []

    # Pin heating
    [Q_pin]
        family = MONOMIAL
        order = CONSTANT
        block = Resonator_Pin
    []
    
[]

# Compute secondary quantities
[AuxKernels]

    ###############################################################
    # Electron properties
    ###############################################################

    # Electron number density
    [ne]
        type = DensityMoles
        variable = ne
        density_log = em_aux
        use_moles = true
        block = Plasma
    []

    ###############################################################
    # Electron properties
    ###############################################################

    # Electron temperature
    [Te]
        type = ElectronTemperature
        variable = Te
        electron_density = em_aux
        mean_en = mean_aux
        block = Plasma
    []

    # Microwave heating of plasma
    [Q_microwave]
        type = AuxComplexHeating
        variable = Q_cond
        E_real = E_real
        E_imag = E_imag
        conductivity = plasma_conductivity_real
        block = Plasma
    []

    # Heating of pin element
    [Q_pin]
        type = SourceCurrentHeating
        variable = Q_pin
        E_real = E_real
        E_imag = E_imag
        source_real = I_real
        source_imag = I_imag
        block = Resonator_Pin
    []

[]

# Define stored variables as post-processors
[Postprocessors]

    # Introduce time step
    [delta_t]
        type = Receiver
    []

    # Current from previous timestep
    [I_old]
        type = Receiver
    []

    # Current from current timestep
    [I_current]
        type = FunctionValuePostprocessor
        function = I_new
    []

    # Heating parameter
    [alpha]
        type = Receiver
    []

    # Average pin power
    [pin_power]
        type = ElementAverageValue
        variable = Q_pin
        block = Resonator_Pin
        execute_on = 'TIMESTEP_END'
    []

[]

# Set output file types
[Outputs]
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
    exodus = true
    print_linear_residuals = true
[]

# Set executioner properties (consider extracting numerics)
[Executioner]
    type = Steady
    solve_type = 'NEWTON'
    automatic_scaling = true
    compute_scaling_once = false
    line_search = none
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -pc_factor_shift_type -pc_factor_shift_amount'
    petsc_options_value = 'lu       superlu_dist                  NONZERO               1.e-10'
    l_max_its = 50
    nl_abs_tol = 1e-2
    nl_forced_its = 1
[]
  
# Enable debugger
[Debug]
    show_var_residual_norms = true
[]