# Simulate OES spectra for a given reactor SS condition

# Define system specific constants for re-use
T_gas = 300                     # K
Nbg = 3.22e22					# atoms/m^3

# Parameters that change during pressure power sweep
P_gas = 133.322                 # Pa 
Target_File = 'argon_CRM-SS-1000mTorr-125W'
Source_File = 'SHINX_Microwave_Model_SRC_EM_Heating0.e'

# Define global variables
[GlobalParams]
	potential_units = V
	use_moles = true
[]

# Define problem as finite element problem
[Problem]
	type = FEProblem
[]

# Generate mesh
[Mesh]

	# Use SS microwave heating solution as input mesh
	[fmg]
		type = FileMeshGenerator
		file = '${Source_File}'
		use_for_exodus_restart = true
	[]

	# Set mesh properties
	coord_type = RZ
	rz_coord_axis = Y

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
	  	user_T_gas = '${T_gas}'
	  	property_tables_file = ElectronProperties/electron_moments.txt
	  	block = Resonator_Pin
	[]

	# Ceramic properties
	[Ceramic_Basic]
	  	type = GasElectronMoments
	  	interp_trans_coeffs = false
	  	interp_elastic_coeff = false
	  	ramp_trans_coeffs = false
	  	user_p_gas = '${P_gas}'
	  	user_T_gas = '${T_gas}'
	  	property_tables_file = ElectronProperties/electron_moments.txt
	  	block = Ceramic
	[]

	# Plasma properties
	[Plasma_Basic]
		type = GasElectronMoments
		interp_trans_coeffs = false
		interp_elastic_coeff = false
		ramp_trans_coeffs = false
		user_p_gas = '${P_gas}'
		user_T_gas = '${T_gas}'
		property_tables_file = ElectronProperties/electron_moments.txt
		block = Plasma
	[]

[]

# Input reactions (update)
# INSERT REACTIONS BLOCK (F4_Reactions)

# Define problem variables for primary kernels
[Variables]

	###############################################################
    # Dummy variable - keep EM and Plasma meshes aligned
    ###############################################################

    # Dummy variable to align EM and chemistry solver

	[Dummy]
		block = 'Resonator_Pin Ceramic'
	[]

	###############################################################
    # Excited states (update)
    ###############################################################

	# Excited state log-molar densities
	# INSERT EXCITED STATES (F4_2_1)

[]

# Solve for DE quantities
[Kernels]

	###############################################################
    # Dummy variable - keep EM and Plasma meshes aligned
    ###############################################################
	[Dummy]
		type = NullKernel
		variable = Dummy
		block = 'Resonator_Pin Ceramic'
	[]

[]

# Initiate variables for auxkernels
[AuxVariables]

	###############################################################
    # Electron density distributions
    ###############################################################

	# Log-molar electron density
	[em]
		block = Plasma
		initial_from_file_var = em_aux
		initial_from_file_timestep = LATEST
	[]

	# Log-molar electron energy
	[mean]
		block = Plasma
		initial_from_file_var = mean_aux
		initial_from_file_timestep = LATEST
	[]

	###############################################################
    # Background gas density (update)
    ###############################################################

	# Neutral gases
	# INSERT NEUTRAL GASES (F4_1_1)
	

	###############################################################
    # Excited state number densities (update)
    ###############################################################

	# Number densities of excited states
	# INSERT EXCITED SPECIES DENSITIES (F4_2_2)

	###############################################################
    # Photon properties
    ###############################################################
	
	# Counts of photon emissions
	# INSERT PHOTONS (F4_3_1)

[]

# Compute secondary quantities
[AuxKernels]

	###############################################################
    # Background gas density (update)
    ###############################################################

	# Neutral backgroung gas density
	# INSERT BACKGROUND GAS DENSITIES (F4_1_2)

	###############################################################
    # Excited state densities (update)
    ###############################################################

	# Excited state densities
	# INSERT EXCITED STATE DENSITY (F4_2_3)

	###############################################################
    # Attenuated photon densities
    ###############################################################

	# Attenuated photon densities
	# INSERT PHOTON DENSITIES (F4_3_2)

[]

# Set output file types
[Outputs]

	# Output to exodus file
	[out]
		file_base = '${Target_File}'
		type = Exodus
	[]

[]

# Precondition solver before executing
[Preconditioning]

	# Single matrix pre-conditioner
	[smp]
		type = SMP
		full = true
	[]

[]

# Set executioner properties (consider extracting numerics)
[Executioner]
	type = Steady
	solve_type = 'NEWTON'
	automatic_scaling = true
	compute_scaling_once = false
	petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
	petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -pc_factor_shift_type -pc_factor_shift_amount'
	petsc_options_value = 'lu       superlu_dist                  NONZERO               1.e-10'
	nl_rel_tol = 1e-14
[]