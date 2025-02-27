[GlobalParams]
	potential_units = V
	use_moles = true
[]

[Mesh]
	[fmg]
		type = FileMeshGenerator
		# Power Pressure Change
		file = microwave-loosely-coupled-main-Plasma-150W-Meta_300mTorr_out_EM_Heating0.e
		use_for_exodus_restart = true
	[]
	coord_type = RZ
	rz_coord_axis = Y
[]

[Problem]
	type = FEProblem
[]

[Variables]
	[Dummy]
		block = 'Resonator_Pin Ceramic'
	[]
	[n_1s5]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_1s4]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_1s3]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_1s2]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2p10]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2p9]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2p8]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2p7]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2p6]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2p5]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2p4]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2p3]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2p2]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2p1]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d12]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d11]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d10]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d9]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d8]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d7]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2s5]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2s4]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d6]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d5]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d4]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d3]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d2]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2s3]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_2s2]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3d1]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3p10]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3p9]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3p8]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3p7]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3p6]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3p5]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3p4]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3p3]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3p2]
		block = Plasma
		initial_condition = -20.0
	[]
	[n_3p1]
		block = Plasma
		initial_condition = -20.0
	[]
[]

[Kernels]
	[Dummy]
		type = NullKernel
		variable = Dummy
		block = 'Resonator_Pin Ceramic'
	[]
[]

[Reactions]
	[Gas]
		species = 'n_1s5 n_1s4 n_1s3 n_1s2 n_2p10 n_2p9 n_2p8 n_2p7 n_2p6 n_2p5 n_2p4 n_2p3 n_2p2 n_2p1 n_3d12 n_3d11 n_3d10 n_3d9 n_3d8 n_3d7 n_2s5 n_2s4 n_3d6 n_3d5 n_3d4 n_3d3 n_3d2 n_2s3 n_2s2 n_3d1 n_3p10 n_3p9 n_3p8 n_3p7 n_3p6 n_3p5 n_3p4 n_3p3 n_3p2 n_3p1'
		aux_species = 'n_gs'
		reaction_coefficient_format = 'rate'
		gas_species = 'n_gs'
		electron_energy = 'mean_en'
		electron_density = 'em'
		include_electrons = true
		position_units = 1.0
		file_location = 'excitation_rates'
		use_log = true
		use_ad = true
		block = Plasma
		# n_2p1 + em -> n_2p4 + em	 : EEDF (2p1_To_2p4)
		reactions = 'n_1s5 + em -> Ar+ + em + em	 : EEDF (test_ion_1)
					 n_1s3 + em -> Ar+ + em + em	 : EEDF (1s3-Ionization)
					 n_gs + em -> n_1s5 + em  	 : EEDF (gs_To_1s5) 
		             n_1s5 + em -> n_gs + em  	 : EEDF (1s5_To_gs)
		             n_gs + em -> n_1s4 + em  	 : EEDF (gs_To_1s4) 
		             n_1s4 + em -> n_gs + em  	 : EEDF (1s4_To_gs)
		             n_gs + em -> n_1s3 + em  	 : EEDF (gs_To_1s3) 
		             n_1s3 + em -> n_gs + em  	 : EEDF (1s3_To_gs)
		             n_gs + em -> n_1s2 + em  	 : EEDF (gs_To_1s2) 
		             n_1s2 + em -> n_gs + em  	 : EEDF (1s2_To_gs)
		             n_gs + em -> n_2p10 + em  	 : EEDF (gs_To_2p10) 
		             n_2p10 + em -> n_gs + em  	 : EEDF (2p10_To_gs)
		             n_gs + em -> n_2p9 + em  	 : EEDF (gs_To_2p9) 
		             n_2p9 + em -> n_gs + em  	 : EEDF (2p9_To_gs)
		             n_gs + em -> n_2p8 + em  	 : EEDF (gs_To_2p8) 
		             n_2p8 + em -> n_gs + em  	 : EEDF (2p8_To_gs)
		             n_gs + em -> n_2p7 + em  	 : EEDF (gs_To_2p7) 
		             n_2p7 + em -> n_gs + em  	 : EEDF (2p7_To_gs)
		             n_gs + em -> n_2p6 + em  	 : EEDF (gs_To_2p6) 
		             n_2p6 + em -> n_gs + em  	 : EEDF (2p6_To_gs)
		             n_gs + em -> n_2p5 + em  	 : EEDF (gs_To_2p5) 
		             n_2p5 + em -> n_gs + em  	 : EEDF (2p5_To_gs)
		             n_gs + em -> n_2p4 + em  	 : EEDF (gs_To_2p4) 
		             n_2p4 + em -> n_gs + em  	 : EEDF (2p4_To_gs)
		             n_gs + em -> n_2p3 + em  	 : EEDF (gs_To_2p3) 
		             n_2p3 + em -> n_gs + em  	 : EEDF (2p3_To_gs)
		             n_gs + em -> n_2p2 + em  	 : EEDF (gs_To_2p2) 
		             n_2p2 + em -> n_gs + em  	 : EEDF (2p2_To_gs)
		             n_gs + em -> n_2p1 + em  	 : EEDF (gs_To_2p1) 
		             n_2p1 + em -> n_gs + em  	 : EEDF (2p1_To_gs)
		             n_gs + em -> n_3d12 + em  	 : EEDF (gs_To_3d12) 
		             n_3d12 + em -> n_gs + em  	 : EEDF (3d12_To_gs)
		             n_gs + em -> n_3d11 + em  	 : EEDF (gs_To_3d11) 
		             n_3d11 + em -> n_gs + em  	 : EEDF (3d11_To_gs)
		             n_gs + em -> n_3d10 + em  	 : EEDF (gs_To_3d10) 
		             n_3d10 + em -> n_gs + em  	 : EEDF (3d10_To_gs)
		             n_gs + em -> n_3d9 + em  	 : EEDF (gs_To_3d9) 
		             n_3d9 + em -> n_gs + em  	 : EEDF (3d9_To_gs)
		             n_gs + em -> n_3d8 + em  	 : EEDF (gs_To_3d8) 
		             n_3d8 + em -> n_gs + em  	 : EEDF (3d8_To_gs)
		             n_gs + em -> n_3d7 + em  	 : EEDF (gs_To_3d7) 
		             n_3d7 + em -> n_gs + em  	 : EEDF (3d7_To_gs)
		             n_gs + em -> n_2s5 + em  	 : EEDF (gs_To_2s5) 
		             n_2s5 + em -> n_gs + em  	 : EEDF (2s5_To_gs)
		             n_gs + em -> n_2s4 + em  	 : EEDF (gs_To_2s4) 
		             n_2s4 + em -> n_gs + em  	 : EEDF (2s4_To_gs)
		             n_gs + em -> n_3d6 + em  	 : EEDF (gs_To_3d6) 
		             n_3d6 + em -> n_gs + em  	 : EEDF (3d6_To_gs)
		             n_gs + em -> n_3d5 + em  	 : EEDF (gs_To_3d5) 
		             n_3d5 + em -> n_gs + em  	 : EEDF (3d5_To_gs)
		             n_gs + em -> n_3d4 + em  	 : EEDF (gs_To_3d4) 
		             n_3d4 + em -> n_gs + em  	 : EEDF (3d4_To_gs)
		             n_gs + em -> n_3d3 + em  	 : EEDF (gs_To_3d3) 
		             n_3d3 + em -> n_gs + em  	 : EEDF (3d3_To_gs)
		             n_gs + em -> n_3d2 + em  	 : EEDF (gs_To_3d2) 
		             n_3d2 + em -> n_gs + em  	 : EEDF (3d2_To_gs)
		             n_gs + em -> n_2s3 + em  	 : EEDF (gs_To_2s3) 
		             n_2s3 + em -> n_gs + em  	 : EEDF (2s3_To_gs)
		             n_gs + em -> n_2s2 + em  	 : EEDF (gs_To_2s2) 
		             n_2s2 + em -> n_gs + em  	 : EEDF (2s2_To_gs)
		             n_gs + em -> n_3d1 + em  	 : EEDF (gs_To_3d1) 
		             n_3d1 + em -> n_gs + em  	 : EEDF (3d1_To_gs)
		             n_gs + em -> n_3p10 + em  	 : EEDF (gs_To_3p10) 
		             n_3p10 + em -> n_gs + em  	 : EEDF (3p10_To_gs)
		             n_gs + em -> n_3p9 + em  	 : EEDF (gs_To_3p9) 
		             n_3p9 + em -> n_gs + em  	 : EEDF (3p9_To_gs)
		             n_gs + em -> n_3p8 + em  	 : EEDF (gs_To_3p8) 
		             n_3p8 + em -> n_gs + em  	 : EEDF (3p8_To_gs)
		             n_gs + em -> n_3p7 + em  	 : EEDF (gs_To_3p7) 
		             n_3p7 + em -> n_gs + em  	 : EEDF (3p7_To_gs)
		             n_gs + em -> n_3p6 + em  	 : EEDF (gs_To_3p6) 
		             n_3p6 + em -> n_gs + em  	 : EEDF (3p6_To_gs)
		             n_gs + em -> n_3p5 + em  	 : EEDF (gs_To_3p5) 
		             n_3p5 + em -> n_gs + em  	 : EEDF (3p5_To_gs)
		             n_gs + em -> n_3p4 + em  	 : EEDF (gs_To_3p4) 
		             n_3p4 + em -> n_gs + em  	 : EEDF (3p4_To_gs)
		             n_gs + em -> n_3p3 + em  	 : EEDF (gs_To_3p3) 
		             n_3p3 + em -> n_gs + em  	 : EEDF (3p3_To_gs)
		             n_gs + em -> n_3p2 + em  	 : EEDF (gs_To_3p2) 
		             n_3p2 + em -> n_gs + em  	 : EEDF (3p2_To_gs)
		             n_gs + em -> n_3p1 + em  	 : EEDF (gs_To_3p1) 
		             n_3p1 + em -> n_gs + em  	 : EEDF (3p1_To_gs)
		             n_1s5 + em -> n_1s4 + em	 : EEDF (1s5_To_1s4)
		             n_1s5 + em -> n_1s3 + em	 : EEDF (1s5_To_1s3)
		             n_1s5 + em -> n_1s2 + em	 : EEDF (1s5_To_1s2)
		             n_1s5 + em -> n_2p10 + em	 : EEDF (1s5_To_2p10)
		             n_1s5 + em -> n_2p9 + em	 : EEDF (1s5_To_2p9)
		             n_1s5 + em -> n_2p8 + em	 : EEDF (1s5_To_2p8)
		             n_1s5 + em -> n_2p7 + em	 : EEDF (1s5_To_2p7)
		             n_1s5 + em -> n_2p6 + em	 : EEDF (1s5_To_2p6)
		             n_1s5 + em -> n_2p5 + em	 : EEDF (1s5_To_2p5)
		             n_1s5 + em -> n_2p4 + em	 : EEDF (1s5_To_2p4)
		             n_1s5 + em -> n_2p3 + em	 : EEDF (1s5_To_2p3)
		             n_1s5 + em -> n_2p2 + em	 : EEDF (1s5_To_2p2)
		             n_1s5 + em -> n_2p1 + em	 : EEDF (1s5_To_2p1)
		             n_1s4 + em -> n_1s5 + em	 : EEDF (1s4_To_1s5)
		             n_1s4 + em -> n_1s3 + em	 : EEDF (1s4_To_1s3)
		             n_1s4 + em -> n_1s2 + em	 : EEDF (1s4_To_1s2)
		             n_1s4 + em -> n_2p10 + em	 : EEDF (1s4_To_2p10)
		             n_1s4 + em -> n_2p9 + em	 : EEDF (1s4_To_2p9)
		             n_1s4 + em -> n_2p8 + em	 : EEDF (1s4_To_2p8)
					 n_1s4 + em -> n_2p7 + em	 : EEDF (1s4_To_2p7)
		             n_1s4 + em -> n_2p6 + em	 : EEDF (1s4_To_2p6)
		             n_1s4 + em -> n_2p5 + em	 : EEDF (1s4_To_2p5)
		             n_1s4 + em -> n_2p4 + em	 : EEDF (1s4_To_2p4)
		             n_1s4 + em -> n_2p3 + em	 : EEDF (1s4_To_2p3)
		             n_1s4 + em -> n_2p2 + em	 : EEDF (1s4_To_2p2)
		             n_1s4 + em -> n_2p1 + em	 : EEDF (1s4_To_2p1)
					 n_1s3 + em -> n_1s5 + em	 : EEDF (1s3_To_1s5)
		             n_1s3 + em -> n_1s4 + em	 : EEDF (1s3_To_1s4)
		             n_1s3 + em -> n_1s2 + em	 : EEDF (1s3_To_1s2)
		             n_1s3 + em -> n_2p10 + em	 : EEDF (1s3_To_2p10)
		             n_1s3 + em -> n_2p9 + em	 : EEDF (1s3_To_2p9)
		             n_1s3 + em -> n_2p8 + em	 : EEDF (1s3_To_2p8)
		             n_1s3 + em -> n_2p7 + em	 : EEDF (1s3_To_2p7)
		             n_1s3 + em -> n_2p6 + em	 : EEDF (1s3_To_2p6)
		             n_1s3 + em -> n_2p5 + em	 : EEDF (1s3_To_2p5)
		             n_1s3 + em -> n_2p4 + em	 : EEDF (1s3_To_2p4)
		             n_1s3 + em -> n_2p3 + em	 : EEDF (1s3_To_2p3)
		             n_1s3 + em -> n_2p2 + em	 : EEDF (1s3_To_2p2)
		             n_1s3 + em -> n_2p1 + em	 : EEDF (1s3_To_2p1)
					 n_1s2 + em -> n_1s5 + em	 : EEDF (1s2_To_1s5)
		             n_1s2 + em -> n_1s4 + em	 : EEDF (1s2_To_1s4)
		             n_1s2 + em -> n_1s3 + em	 : EEDF (1s2_To_1s3)
		             n_1s2 + em -> n_2p10 + em	 : EEDF (1s2_To_2p10)
		             n_1s2 + em -> n_2p9 + em	 : EEDF (1s2_To_2p9)
		             n_1s2 + em -> n_2p8 + em	 : EEDF (1s2_To_2p8)
		             n_1s2 + em -> n_2p7 + em	 : EEDF (1s2_To_2p7)
		             n_1s2 + em -> n_2p6 + em	 : EEDF (1s2_To_2p6)
		             n_1s2 + em -> n_2p5 + em	 : EEDF (1s2_To_2p5)
		             n_1s2 + em -> n_2p4 + em	 : EEDF (1s2_To_2p4)
		             n_1s2 + em -> n_2p3 + em	 : EEDF (1s2_To_2p3)
		             n_1s2 + em -> n_2p2 + em	 : EEDF (1s2_To_2p2)
		             n_1s2 + em -> n_2p1 + em	 : EEDF (1s2_To_2p1)
					 n_2p10 + em -> n_1s5 + em	 : EEDF (2p10_To_1s5)
		             n_2p10 + em -> n_1s4 + em	 : EEDF (2p10_To_1s4)
		             n_2p10 + em -> n_1s3 + em	 : EEDF (2p10_To_1s3)
		             n_2p10 + em -> n_1s2 + em	 : EEDF (2p10_To_1s2)
		             n_2p10 + em -> n_2p9 + em	 : EEDF (2p10_To_2p9)
		             n_2p10 + em -> n_2p8 + em	 : EEDF (2p10_To_2p8)
		             n_2p10 + em -> n_2p7 + em	 : EEDF (2p10_To_2p7)
		             n_2p10 + em -> n_2p6 + em	 : EEDF (2p10_To_2p6)
		             n_2p10 + em -> n_2p5 + em	 : EEDF (2p10_To_2p5)
		             n_2p10 + em -> n_2p4 + em	 : EEDF (2p10_To_2p4)
		             n_2p10 + em -> n_2p3 + em	 : EEDF (2p10_To_2p3)
		             n_2p10 + em -> n_2p2 + em	 : EEDF (2p10_To_2p2)
		             n_2p10 + em -> n_2p1 + em	 : EEDF (2p10_To_2p1)
					 n_2p9 + em -> n_1s5 + em	 : EEDF (2p9_To_1s5)
		             n_2p9 + em -> n_1s4 + em	 : EEDF (2p9_To_1s4)
		             n_2p9 + em -> n_1s3 + em	 : EEDF (2p9_To_1s3)
		             n_2p9 + em -> n_1s2 + em	 : EEDF (2p9_To_1s2)
		             n_2p9 + em -> n_2p10 + em	 : EEDF (2p9_To_2p10)
		             n_2p9 + em -> n_2p8 + em	 : EEDF (2p9_To_2p8)
		             n_2p9 + em -> n_2p7 + em	 : EEDF (2p9_To_2p7)
		             n_2p9 + em -> n_2p6 + em	 : EEDF (2p9_To_2p6)
		             n_2p9 + em -> n_2p5 + em	 : EEDF (2p9_To_2p5)
		             n_2p9 + em -> n_2p4 + em	 : EEDF (2p9_To_2p4)
		             n_2p9 + em -> n_2p3 + em	 : EEDF (2p9_To_2p3)
		             n_2p9 + em -> n_2p2 + em	 : EEDF (2p9_To_2p2)
		             n_2p9 + em -> n_2p1 + em	 : EEDF (2p9_To_2p1)
		             n_2p8 + em -> n_1s5 + em	 : EEDF (2p8_To_1s5)
		             n_2p8 + em -> n_1s4 + em	 : EEDF (2p8_To_1s4)
		             n_2p8 + em -> n_1s3 + em	 : EEDF (2p8_To_1s3)
		             n_2p8 + em -> n_1s2 + em	 : EEDF (2p8_To_1s2)
		             n_2p8 + em -> n_2p10 + em	 : EEDF (2p8_To_2p10)
		             n_2p8 + em -> n_2p9 + em	 : EEDF (2p8_To_2p9)
		             n_2p8 + em -> n_2p7 + em	 : EEDF (2p8_To_2p7)
		             n_2p8 + em -> n_2p6 + em	 : EEDF (2p8_To_2p6)
		             n_2p8 + em -> n_2p5 + em	 : EEDF (2p8_To_2p5)
		             n_2p8 + em -> n_2p4 + em	 : EEDF (2p8_To_2p4)
		             n_2p8 + em -> n_2p3 + em	 : EEDF (2p8_To_2p3)
		             n_2p8 + em -> n_2p2 + em	 : EEDF (2p8_To_2p2)
		             n_2p8 + em -> n_2p1 + em	 : EEDF (2p8_To_2p1)
					 n_2p7 + em -> n_1s5 + em	 : EEDF (2p7_To_1s5)
		             n_2p7 + em -> n_1s4 + em	 : EEDF (2p7_To_1s4)
		             n_2p7 + em -> n_1s3 + em	 : EEDF (2p7_To_1s3)
		             n_2p7 + em -> n_1s2 + em	 : EEDF (2p7_To_1s2)
		             n_2p7 + em -> n_2p10 + em	 : EEDF (2p7_To_2p10)
		             n_2p7 + em -> n_2p9 + em	 : EEDF (2p7_To_2p9)
		             n_2p7 + em -> n_2p8 + em	 : EEDF (2p7_To_2p8)
		             n_2p7 + em -> n_2p6 + em	 : EEDF (2p7_To_2p6)
		             n_2p7 + em -> n_2p5 + em	 : EEDF (2p7_To_2p5)
		             n_2p7 + em -> n_2p4 + em	 : EEDF (2p7_To_2p4)
		             n_2p7 + em -> n_2p3 + em	 : EEDF (2p7_To_2p3)
		             n_2p7 + em -> n_2p2 + em	 : EEDF (2p7_To_2p2)
		             n_2p7 + em -> n_2p1 + em	 : EEDF (2p7_To_2p1)
		             n_2p6 + em -> n_1s5 + em	 : EEDF (2p6_To_1s5)
		             n_2p6 + em -> n_1s4 + em	 : EEDF (2p6_To_1s4)
		             n_2p6 + em -> n_1s3 + em	 : EEDF (2p6_To_1s3)
		             n_2p6 + em -> n_1s2 + em	 : EEDF (2p6_To_1s2)
		             n_2p6 + em -> n_2p10 + em	 : EEDF (2p6_To_2p10)
		             n_2p6 + em -> n_2p9 + em	 : EEDF (2p6_To_2p9)
		             n_2p6 + em -> n_2p8 + em	 : EEDF (2p6_To_2p8)
		             n_2p6 + em -> n_2p7 + em	 : EEDF (2p6_To_2p7)
		             n_2p6 + em -> n_2p5 + em	 : EEDF (2p6_To_2p5)
		             n_2p6 + em -> n_2p4 + em	 : EEDF (2p6_To_2p4)
		             n_2p6 + em -> n_2p3 + em	 : EEDF (2p6_To_2p3)
		             n_2p6 + em -> n_2p2 + em	 : EEDF (2p6_To_2p2)
		             n_2p6 + em -> n_2p1 + em	 : EEDF (2p6_To_2p1)
		             n_2p5 + em -> n_1s5 + em	 : EEDF (2p5_To_1s5)
		             n_2p5 + em -> n_1s4 + em	 : EEDF (2p5_To_1s4)
		             n_2p5 + em -> n_1s3 + em	 : EEDF (2p5_To_1s3)
		             n_2p5 + em -> n_1s2 + em	 : EEDF (2p5_To_1s2)
		             n_2p5 + em -> n_2p10 + em	 : EEDF (2p5_To_2p10)
		             n_2p5 + em -> n_2p9 + em	 : EEDF (2p5_To_2p9)
		             n_2p5 + em -> n_2p8 + em	 : EEDF (2p5_To_2p8)
		             n_2p5 + em -> n_2p7 + em	 : EEDF (2p5_To_2p7)
		             n_2p5 + em -> n_2p6 + em	 : EEDF (2p5_To_2p6)
		             n_2p5 + em -> n_2p4 + em	 : EEDF (2p5_To_2p4)
		             n_2p5 + em -> n_2p3 + em	 : EEDF (2p5_To_2p3)
		             n_2p5 + em -> n_2p2 + em	 : EEDF (2p5_To_2p2)
		             n_2p5 + em -> n_2p1 + em	 : EEDF (2p5_To_2p1)
					 n_2p4 + em -> n_1s5 + em	 : EEDF (2p4_To_1s5)
		             n_2p4 + em -> n_1s4 + em	 : EEDF (2p4_To_1s4)
		             n_2p4 + em -> n_1s3 + em	 : EEDF (2p4_To_1s3)
		             n_2p4 + em -> n_1s2 + em	 : EEDF (2p4_To_1s2)
		             n_2p4 + em -> n_2p10 + em	 : EEDF (2p4_To_2p10)
		             n_2p4 + em -> n_2p9 + em	 : EEDF (2p4_To_2p9)
		             n_2p4 + em -> n_2p8 + em	 : EEDF (2p4_To_2p8)
		             n_2p4 + em -> n_2p7 + em	 : EEDF (2p4_To_2p7)
		             n_2p4 + em -> n_2p6 + em	 : EEDF (2p4_To_2p6)
		             n_2p4 + em -> n_2p5 + em	 : EEDF (2p4_To_2p5)
		             n_2p4 + em -> n_2p3 + em	 : EEDF (2p4_To_2p3)
		             n_2p4 + em -> n_2p2 + em	 : EEDF (2p4_To_2p2)
		             n_2p4 + em -> n_2p1 + em	 : EEDF (2p4_To_2p1)
					 n_2p3 + em -> n_1s5 + em	 : EEDF (2p3_To_1s5)
		             n_2p3 + em -> n_1s4 + em	 : EEDF (2p3_To_1s4)
		             n_2p3 + em -> n_1s3 + em	 : EEDF (2p3_To_1s3)
		             n_2p3 + em -> n_1s2 + em	 : EEDF (2p3_To_1s2)
		             n_2p3 + em -> n_2p10 + em	 : EEDF (2p3_To_2p10)
		             n_2p3 + em -> n_2p9 + em	 : EEDF (2p3_To_2p9)
		             n_2p3 + em -> n_2p8 + em	 : EEDF (2p3_To_2p8)
		             n_2p3 + em -> n_2p7 + em	 : EEDF (2p3_To_2p7)
		             n_2p3 + em -> n_2p6 + em	 : EEDF (2p3_To_2p6)
		             n_2p3 + em -> n_2p5 + em	 : EEDF (2p3_To_2p5)
		             n_2p3 + em -> n_2p4 + em	 : EEDF (2p3_To_2p4)
		             n_2p3 + em -> n_2p2 + em	 : EEDF (2p3_To_2p2)
		             n_2p3 + em -> n_2p1 + em	 : EEDF (2p3_To_2p1)
					 n_2p2 + em -> n_1s5 + em	 : EEDF (2p2_To_1s5)
		             n_2p2 + em -> n_1s4 + em	 : EEDF (2p2_To_1s4)
		             n_2p2 + em -> n_1s3 + em	 : EEDF (2p2_To_1s3)
		             n_2p2 + em -> n_1s2 + em	 : EEDF (2p2_To_1s2)
		             n_2p2 + em -> n_2p10 + em	 : EEDF (2p2_To_2p10)
		             n_2p2 + em -> n_2p9 + em	 : EEDF (2p2_To_2p9)
		             n_2p2 + em -> n_2p8 + em	 : EEDF (2p2_To_2p8)
		             n_2p2 + em -> n_2p7 + em	 : EEDF (2p2_To_2p7)
		             n_2p2 + em -> n_2p6 + em	 : EEDF (2p2_To_2p6)
		             n_2p2 + em -> n_2p5 + em	 : EEDF (2p2_To_2p5)
		             n_2p2 + em -> n_2p4 + em	 : EEDF (2p2_To_2p4)
		             n_2p2 + em -> n_2p3 + em	 : EEDF (2p2_To_2p3)
		             n_2p2 + em -> n_2p1 + em	 : EEDF (2p2_To_2p1)
					 n_2p1 + em -> n_1s5 + em	 : EEDF (2p1_To_1s5)
		             n_2p1 + em -> n_1s4 + em	 : EEDF (2p1_To_1s4)
		             n_2p1 + em -> n_1s3 + em	 : EEDF (2p1_To_1s3)
		             n_2p1 + em -> n_1s2 + em	 : EEDF (2p1_To_1s2)
		             n_2p1 + em -> n_2p10 + em	 : EEDF (2p1_To_2p10)
		             n_2p1 + em -> n_2p9 + em	 : EEDF (2p1_To_2p9)
		             n_2p1 + em -> n_2p8 + em	 : EEDF (2p1_To_2p8)
		             n_2p1 + em -> n_2p7 + em	 : EEDF (2p1_To_2p7)
		             n_2p1 + em -> n_2p6 + em	 : EEDF (2p1_To_2p6)
		             n_2p1 + em -> n_2p5 + em	 : EEDF (2p1_To_2p5)
		             n_2p1 + em -> n_2p3 + em	 : EEDF (2p1_To_2p3)
		             n_2p1 + em -> n_2p2 + em	 : EEDF (2p1_To_2p2)
					 n_2p2 -> n_1s5 	 : 6.40e+06
		             n_2p3 -> n_1s5 	 : 3.80e+06
		             n_2p4 -> n_1s5 	 : 6.30e+05
		             n_2p2 -> n_1s4 	 : 1.83e+06
		             n_2p3 -> n_1s4 	 : 8.50e+06
		             n_2p1 -> n_1s2 	 : 4.50e+07
		             n_2p5 -> n_1s4 	 : 4.00e+07
		             n_2p6 -> n_1s5 	 : 2.45e+07
		             n_2p7 -> n_1s5 	 : 5.20e+06
		             n_2p2 -> n_1s3 	 : 1.17e+07
		             n_2p4 -> n_1s3 	 : 1.86e+07
		             n_2p6 -> n_1s4 	 : 4.90e+06
		             n_2p8 -> n_1s5 	 : 9.30e+06
		             n_2p7 -> n_1s4 	 : 2.50e+07
		             n_2p9 -> n_1s5 	 : 3.30e+07
		             n_2p2 -> n_1s2 	 : 1.53e+07
		             n_2p3 -> n_1s2 	 : 2.23e+07
		             n_2p8 -> n_1s4 	 : 2.15e+07
		             n_2p4 -> n_1s2 	 : 1.39e+07
		             n_2p7 -> n_1s3 	 : 2.43e+06
		             n_2p10 -> n_1s5 	 : 1.89e+07
		             n_2p6 -> n_1s2 	 : 5.00e+06'
	[]
[]

[AuxVariables]
	[n_gs]
		block = Plasma
	[]
	[em]
		block = Plasma
		initial_from_file_var = ne_log
		initial_from_file_timestep = LATEST
	[]
	[mean_en]
		block = Plasma
		initial_from_file_var = mean_log
		initial_from_file_timestep = LATEST
	[]
[]

[AuxKernels]
	[n_gs_val]
		type = FunctionAux
		variable = n_gs
		# Pressure Dependent
		function = 'log(9.6600e+21 / 6.022e23)'
		execute_on = INITIAL
		block = Plasma
	[]
[]

[Executioner]
	#type = Transient
	#end_time = 1e-6
	#dt = 1e-9
	#dtmin = 1e-14
	#scheme = newmark-beta

	type = Steady
	solve_type = 'NEWTON'
	#line_search = 'none'

	automatic_scaling = true
	compute_scaling_once = false

	petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
	petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -pc_factor_shift_type -pc_factor_shift_amount'
	petsc_options_value = 'lu       superlu_dist                  NONZERO               1.e-10'
[]

[Preconditioning]
	[smp]
		type = SMP
		full = true
	[]
[]

[Outputs]
	[out]
		type = Exodus
	[]
[]

[Materials]
	[Pin_Basic]
	  type = GasElectronMoments
	  interp_trans_coeffs = false
	  interp_elastic_coeff = false
	  ramp_trans_coeffs = false
  
	  # Pressure dependent coefficents default 1 Torr: Need to change during pressure sweep
	  user_p_gas = 26.665
  
	  user_T_gas = 300
	  property_tables_file = electron_moments.txt
	  block = Resonator_Pin
	[]
	[Ceramic_Basic]
	  type = GasElectronMoments
	  interp_trans_coeffs = false
	  interp_elastic_coeff = false
	  ramp_trans_coeffs = false
  
	  # Pressure dependent coefficents default 1 Torr: Need to change during pressure sweep
	  user_p_gas = 26.665
  
	  user_T_gas = 300
	  property_tables_file = electron_moments.txt
	  block = Ceramic
	[]
	[Plasma_Basic]
		type = GasElectronMoments
		interp_trans_coeffs = false
		interp_elastic_coeff = false
		ramp_trans_coeffs = false
	
		# Pressure dependent coefficents default 1 Torr: Need to change during pressure sweep
		user_p_gas = 26.665
	
		user_T_gas = 300
		property_tables_file = electron_moments.txt
		block = Plasma
	[]
[]