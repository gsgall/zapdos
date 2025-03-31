# Performs shooting method for metastable densities in the microwave source.

# Define system specific constants for re-use
nu = 2.45e9                     # GHz
T_gas = 300                     # K
em_shoot = -20                  # log(e/m^3)
mean_shoot = -22                # log(eV/m^3)
E_shoot = 5                     # C
growth_lim = 100

# Parameters that change during pressure sweep
P_gas = 133.322                 # Pa

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
        file = Microwave_Source.msh
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

    # Pin electrode properties
    [Pin_Basic]
        type = GasElectronMoments
        interp_trans_coeffs = false
        interp_elastic_coeff = false
        ramp_trans_coeffs = false 
        user_p_gas = '${P_gas}'
        user_drive_freq = '${nu}'
        user_T_gas = '${T_gas}'
        property_tables_file = ElectronProperties/electron_moments.txt
        block = Resonator_Pin
    []

    # Ceramic dielectric properties
    [Ceramic_Basic]
        type = GasElectronMoments
        interp_trans_coeffs = false
        interp_elastic_coeff = false
        ramp_trans_coeffs = false
        user_p_gas = '${P_gas}'
        user_drive_freq = '${nu}' 
        user_T_gas = '${T_gas}'
        property_tables_file = ElectronProperties/electron_moments.txt
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
        em = '${em_shoot}'
        mean_en = '${mean_shoot}'
        property_tables_file = ElectronProperties/electron_moments.txt
        block = Plasma
    []
  
    ###############################################################
    # Electromagnetic properties
    ###############################################################

    # Feild solver
    [Field_Solver]
        type = FieldSolverMaterial
        electric_field = '${E_shoot}'
        solver = electromagnetic
        block = Plasma
    []
  
    # Plasma wave coefficients
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
      em = '${em_shoot}'
      electron_neutral_collision_frequency = nu_neutral
      electron_neutral_collision_frequency_gradient = grad_nu_neutral
      block = Plasma
    []
  
    # Plasma collision frequency
    [ADCollisionFreq]
        type = DependentCollisionFreq
        field_property_name = field_solver_interface_property
        electrons = '${em_shoot}'
        mean_energy = '${mean_shoot}'
        use_mean_energy = true
        driving_frequency = '${nu}'
        delta = '${delta}'
        file_location = ''
        property_file = ElectronProperties/collision_frequency.txt
        block = Plasma
    []
  
    ###############################################################
    # Metastable species properties (update)
    ###############################################################
    
    # Metastable species
    # INSERT MATERIAL PROPERTIES (F1_2_1)

[]

# Set boundary conditions for domain
[BCs]

    ###############################################################
    # Metastable wall BCs (update)
    ###############################################################

    # Metastable BC1
    # INSERT BC 1 (F1_2_2)

    ###############################################################
    # Metastable vacuum BCs (update)
    ###############################################################

    # Metastable BC2
    # INSERT BC 2 (F1_2_3)

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
    # Species - Representative excited state (update)
    ###############################################################

    # Metastable species density
    # INSERT LOG-MOLAR METASTABLE DENSITY (F1_2_4)

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
    # Shooting method (update)
    ###############################################################

    # SM metastable density
    # INSERT METASTABLE SHOOTING METHOD (F1_2_5)

[]

# Initiate variables for auxkernels
[AuxVariables]

    ###############################################################
    # Shooting method inputs for metastables (update)
    ###############################################################

    # Initial SM density
    # INSERT INITIAL METASTABLE DENSITY (F1_2_6)

    # Final SM density
    # INSERT FINAL METASTABLE DENSITY (F1_2_7)
      
    # SM sensitivity matrix
    # INSERT METASTABLE SENSITIVITY MATRIX (F1_2_8)

    # SM identity matrix
    # INSERT METASTABLE IDENTITY MATRIX (F1_2_9)
  
    # SM residual
    # INSERT METASTABLE RESIDUAL (F1_2_10)

[]

# Compute secondary quantities
[AuxKernels]

    ###############################################################
    # Reset shooting method (update)
    ###############################################################
    
    # SM reset
    # INSERT SM RESET (F1_2_11)
  
    ###############################################################
    # Calculate residuals (update)
    ###############################################################
    
    # SM residual
    # INSERT RESIDUAL CALCULATION (F1_2_12)

[]

# Define stored variables as post-processors
[Postprocessors]

    ###############################################################
    # Relative change in metastable densities (update)
    ###############################################################
    
    # Relative change during shot
    # INSERT METASTABLE RELATIVE CHANGE (F1_2_13)

[]

# Precondition solver before executing
[Preconditioning]

    # Set active preconditioner
    active = 'smp'

    # Single matrix preconditioner
    [smp]
        type = SMP
        full = true
    []
  
    # Finite difference preconditioner
    [fdp]
        type = FDP
        full = true
    []

[]
  
# Set output file types
[Outputs]

    # Enable performance log
    print_perf_log = true
    
    # Set exodus output
    [exo_out]
        type = Exodus
    []

[]

# Set executioner properties (consider extracting numerics)
[Executioner]
    type = Steady
    petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
    solve_type = NEWTON 
    petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
    petsc_options_value = 'lu NONZERO 1.e-10'
    nl_abs_tol = 1e-12
    nl_forced_its = 1
[]  