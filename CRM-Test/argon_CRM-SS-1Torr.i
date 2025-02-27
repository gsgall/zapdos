[GlobalParams]
	potential_units = V
	use_moles = true
[]

[Mesh]
	[fmg]
		type = FileMeshGenerator
		# Power Pressure Change
		#file = microwave-loosely-coupled-main-Plasma-150W-Meta_300mTorr_out_EM_Heating0.e
		file = microwave-loosely-coupled-main-Plasma-125W-Meta_1000mTorr_out_EM_Heating0.e
		use_for_exodus_restart = true
	[]
	coord_type = RZ
	rz_coord_axis = Y
[]

[Outputs]
	[out]
		file_base = argon_CRM-SS-1000mTorr-125W
		type = Exodus
	[]
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
	[n_1s5_nl]
		block = Plasma
	[]
	[n_1s4_nl]
		block = Plasma
	[]
	[n_1s3_nl]
		block = Plasma
	[]
	[n_1s2_nl]
		block = Plasma
	[]
	[n_2p10_nl]
		block = Plasma
	[]
	[n_2p9_nl]
		block = Plasma
	[]
	[n_2p8_nl]
		block = Plasma
	[]
	[n_2p7_nl]
		block = Plasma
	[]
	[n_2p6_nl]
		block = Plasma
	[]
	[n_2p5_nl]
		block = Plasma
	[]
	[n_2p4_nl]
		block = Plasma
	[]
	[n_2p3_nl]
		block = Plasma
	[]
	[n_2p2_nl]
		block = Plasma
	[]
	[n_2p1_nl]
		block = Plasma
	[]
	[n_3d12_nl]
		block = Plasma
	[]
	[n_3d11_nl]
		block = Plasma
	[]
	[n_3d10_nl]
		block = Plasma
	[]
	[n_3d9_nl]
		block = Plasma
	[]
	[n_3d8_nl]
		block = Plasma
	[]
	[n_3d7_nl]
		block = Plasma
	[]
	[n_2s5_nl]
		block = Plasma
	[]
	[n_2s4_nl]
		block = Plasma
	[]
	[n_3d6_nl]
		block = Plasma
	[]
	[n_3d5_nl]
		block = Plasma
	[]
	[n_3d4_nl]
		block = Plasma
	[]
	[n_3d3_nl]
		block = Plasma
	[]
	[n_3d2_nl]
		block = Plasma
	[]
	[n_2s3_nl]
		block = Plasma
	[]
	[n_2s2_nl]
		block = Plasma
	[]
	[n_3d1_nl]
		block = Plasma
	[]
	[n_3p10_nl]
		block = Plasma
	[]
	[n_3p9_nl]
		block = Plasma
	[]
	[n_3p8_nl]
		block = Plasma
	[]
	[n_3p7_nl]
		block = Plasma
	[]
	[n_3p6_nl]
		block = Plasma
	[]
	[n_3p5_nl]
		block = Plasma
	[]
	[n_3p4_nl]
		block = Plasma
	[]
	[n_3p3_nl]
		block = Plasma
	[]
	[n_3p2_nl]
		block = Plasma
	[]
	[n_3p1_nl]
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
	[WL_696.543]
		block = Plasma
	[]
	[WL_706.722]
		block = Plasma
	[]
	[WL_714.704]
		block = Plasma
	[]
	[WL_727.294]
		block = Plasma
	[]
	[WL_738.398]
		block = Plasma
	[]
	[WL_750.387]
		block = Plasma
	[]
	[WL_751.465]
		block = Plasma
	[]
	[WL_763.511]
		block = Plasma
	[]
	[WL_772.376]
		block = Plasma
	[]
	[WL_772.421]
		block = Plasma
	[]
	[WL_794.818]
		block = Plasma
	[]
	[WL_800.616]
		block = Plasma
	[]
	[WL_801.479]
		block = Plasma
	[]
	[WL_810.369]
		block = Plasma
	[]
	[WL_811.531]
		block = Plasma
	[]
	[WL_826.452]
		block = Plasma
	[]
	[WL_840.821]
		block = Plasma
	[]
	[WL_842.465]
		block = Plasma
	[]
	[WL_852.144]
		block = Plasma
	[]
	[WL_866.794]
		block = Plasma
	[]
	[WL_912.297]
		block = Plasma
	[]
	[WL_922.450]
		block = Plasma
	[]
[]

[AuxKernels]
	[n_gs_val]
		type = FunctionAux
		variable = n_gs
		function = 'log(3.22e22/6.022e23)'
		execute_on = INITIAL
		block = Plasma
	[]
	[n_1s5_nl_val]
		type = ParsedAux
		variable = n_1s5_nl
		coupled_variables = n_1s5
		expression = 'exp(n_1s5) * 6.022e23'
		block = Plasma
	[]
	[n_1s4_nl_val]
		type = ParsedAux
		variable = n_1s4_nl
		coupled_variables = n_1s4
		expression = 'exp(n_1s4) * 6.022e23'
		block = Plasma
	[]
	[n_1s3_nl_val]
		type = ParsedAux
		variable = n_1s3_nl
		coupled_variables = n_1s3
		expression = 'exp(n_1s3) * 6.022e23'
		block = Plasma
	[]
	[n_1s2_nl_val]
		type = ParsedAux
		variable = n_1s2_nl
		coupled_variables = n_1s2
		expression = 'exp(n_1s2) * 6.022e23'
		block = Plasma
	[]
	[n_2p10_nl_val]
		type = ParsedAux
		variable = n_2p10_nl
		coupled_variables = n_2p10
		expression = 'exp(n_2p10) * 6.022e23'
		block = Plasma
	[]
	[n_2p9_nl_val]
		type = ParsedAux
		variable = n_2p9_nl
		coupled_variables = n_2p9
		expression = 'exp(n_2p9) * 6.022e23'
		block = Plasma
	[]
	[n_2p8_nl_val]
		type = ParsedAux
		variable = n_2p8_nl
		coupled_variables = n_2p8
		expression = 'exp(n_2p8) * 6.022e23'
		block = Plasma
	[]
	[n_2p7_nl_val]
		type = ParsedAux
		variable = n_2p7_nl
		coupled_variables = n_2p7
		expression = 'exp(n_2p7) * 6.022e23'
		block = Plasma
	[]
	[n_2p6_nl_val]
		type = ParsedAux
		variable = n_2p6_nl
		coupled_variables = n_2p6
		expression = 'exp(n_2p6) * 6.022e23'
		block = Plasma
	[]
	[n_2p5_nl_val]
		type = ParsedAux
		variable = n_2p5_nl
		coupled_variables = n_2p5
		expression = 'exp(n_2p5) * 6.022e23'
		block = Plasma
	[]
	[n_2p4_nl_val]
		type = ParsedAux
		variable = n_2p4_nl
		coupled_variables = n_2p4
		expression = 'exp(n_2p4) * 6.022e23'
		block = Plasma
	[]
	[n_2p3_nl_val]
		type = ParsedAux
		variable = n_2p3_nl
		coupled_variables = n_2p3
		expression = 'exp(n_2p3) * 6.022e23'
		block = Plasma
	[]
	[n_2p2_nl_val]
		type = ParsedAux
		variable = n_2p2_nl
		coupled_variables = n_2p2
		expression = 'exp(n_2p2) * 6.022e23'
		block = Plasma
	[]
	[n_2p1_nl_val]
		type = ParsedAux
		variable = n_2p1_nl
		coupled_variables = n_2p1
		expression = 'exp(n_2p1) * 6.022e23'
		block = Plasma
	[]
	[n_3d12_nl_val]
		type = ParsedAux
		variable = n_3d12_nl
		coupled_variables = n_3d12
		expression = 'exp(n_3d12) * 6.022e23'
		block = Plasma
	[]
	[n_3d11_nl_val]
		type = ParsedAux
		variable = n_3d11_nl
		coupled_variables = n_3d11
		expression = 'exp(n_3d11) * 6.022e23'
		block = Plasma
	[]
	[n_3d10_nl_val]
		type = ParsedAux
		variable = n_3d10_nl
		coupled_variables = n_3d10
		expression = 'exp(n_3d10) * 6.022e23'
		block = Plasma
	[]
	[n_3d9_nl_val]
		type = ParsedAux
		variable = n_3d9_nl
		coupled_variables = n_3d9
		expression = 'exp(n_3d9) * 6.022e23'
		block = Plasma
	[]
	[n_3d8_nl_val]
		type = ParsedAux
		variable = n_3d8_nl
		coupled_variables = n_3d8
		expression = 'exp(n_3d8) * 6.022e23'
		block = Plasma
	[]
	[n_3d7_nl_val]
		type = ParsedAux
		variable = n_3d7_nl
		coupled_variables = n_3d7
		expression = 'exp(n_3d7) * 6.022e23'
		block = Plasma
	[]
	[n_2s5_nl_val]
		type = ParsedAux
		variable = n_2s5_nl
		coupled_variables = n_2s5
		expression = 'exp(n_2s5) * 6.022e23'
		block = Plasma
	[]
	[n_2s4_nl_val]
		type = ParsedAux
		variable = n_2s4_nl
		coupled_variables = n_2s4
		expression = 'exp(n_2s4) * 6.022e23'
		block = Plasma
	[]
	[n_3d6_nl_val]
		type = ParsedAux
		variable = n_3d6_nl
		coupled_variables = n_3d6
		expression = 'exp(n_3d6) * 6.022e23'
		block = Plasma
	[]
	[n_3d5_nl_val]
		type = ParsedAux
		variable = n_3d5_nl
		coupled_variables = n_3d5
		expression = 'exp(n_3d5) * 6.022e23'
		block = Plasma
	[]
	[n_3d4_nl_val]
		type = ParsedAux
		variable = n_3d4_nl
		coupled_variables = n_3d4
		expression = 'exp(n_3d4) * 6.022e23'
		block = Plasma
	[]
	[n_3d3_nl_val]
		type = ParsedAux
		variable = n_3d3_nl
		coupled_variables = n_3d3
		expression = 'exp(n_3d3) * 6.022e23'
		block = Plasma
	[]
	[n_3d2_nl_val]
		type = ParsedAux
		variable = n_3d2_nl
		coupled_variables = n_3d2
		expression = 'exp(n_3d2) * 6.022e23'
		block = Plasma
	[]
	[n_2s3_nl_val]
		type = ParsedAux
		variable = n_2s3_nl
		coupled_variables = n_2s3
		expression = 'exp(n_2s3) * 6.022e23'
		block = Plasma
	[]
	[n_2s2_nl_val]
		type = ParsedAux
		variable = n_2s2_nl
		coupled_variables = n_2s2
		expression = 'exp(n_2s2) * 6.022e23'
		block = Plasma
	[]
	[n_3d1_nl_val]
		type = ParsedAux
		variable = n_3d1_nl
		coupled_variables = n_3d1
		expression = 'exp(n_3d1) * 6.022e23'
		block = Plasma
	[]
	[n_3p10_nl_val]
		type = ParsedAux
		variable = n_3p10_nl
		coupled_variables = n_3p10
		expression = 'exp(n_3p10) * 6.022e23'
		block = Plasma
	[]
	[n_3p9_nl_val]
		type = ParsedAux
		variable = n_3p9_nl
		coupled_variables = n_3p9
		expression = 'exp(n_3p9) * 6.022e23'
		block = Plasma
	[]
	[n_3p8_nl_val]
		type = ParsedAux
		variable = n_3p8_nl
		coupled_variables = n_3p8
		expression = 'exp(n_3p8) * 6.022e23'
		block = Plasma
	[]
	[n_3p7_nl_val]
		type = ParsedAux
		variable = n_3p7_nl
		coupled_variables = n_3p7
		expression = 'exp(n_3p7) * 6.022e23'
		block = Plasma
	[]
	[n_3p6_nl_val]
		type = ParsedAux
		variable = n_3p6_nl
		coupled_variables = n_3p6
		expression = 'exp(n_3p6) * 6.022e23'
		block = Plasma
	[]
	[n_3p5_nl_val]
		type = ParsedAux
		variable = n_3p5_nl
		coupled_variables = n_3p5
		expression = 'exp(n_3p5) * 6.022e23'
		block = Plasma
	[]
	[n_3p4_nl_val]
		type = ParsedAux
		variable = n_3p4_nl
		coupled_variables = n_3p4
		expression = 'exp(n_3p4) * 6.022e23'
		block = Plasma
	[]
	[n_3p3_nl_val]
		type = ParsedAux
		variable = n_3p3_nl
		coupled_variables = n_3p3
		expression = 'exp(n_3p3) * 6.022e23'
		block = Plasma
	[]
	[n_3p2_nl_val]
		type = ParsedAux
		variable = n_3p2_nl
		coupled_variables = n_3p2
		expression = 'exp(n_3p2) * 6.022e23'
		block = Plasma
	[]
	[n_3p1_nl_val]
		type = ParsedAux
		variable = n_3p1_nl
		coupled_variables = n_3p1
		expression = 'exp(n_3p1) * 6.022e23'
		block = Plasma
	[]
	[WL_696.543_val]
		type = ParsedAux
		variable = WL_696.543
		coupled_variables = n_2p2_nl
		expression = '(6.626e-34 * 3e8 / 696.543e-9) * 6.40e+06 * n_2p2_nl'
		block = Plasma
	[]
	[WL_706.722_val]
		type = ParsedAux
		variable = WL_706.722
		coupled_variables = n_2p3_nl
		expression = '(6.626e-34 * 3e8 / 706.722e-9) * 3.80e+06 * n_2p3_nl'
		block = Plasma
	[]
	[WL_714.704_val]
		type = ParsedAux
		variable = WL_714.704
		coupled_variables = n_2p4_nl
		expression = '(6.626e-34 * 3e8 / 714.704e-9) * 6.30e+05 * n_2p4_nl'
		block = Plasma
	[]
	[WL_727.294_val]
		type = ParsedAux
		variable = WL_727.294
		coupled_variables = n_2p2_nl
		expression = '(6.626e-34 * 3e8 / 727.294e-9) * 1.83e+06 * n_2p2_nl'
		block = Plasma
	[]
	[WL_738.398_val]
		type = ParsedAux
		variable = WL_738.398
		coupled_variables = n_2p3_nl
		expression = '(6.626e-34 * 3e8 / 738.398e-9) * 8.50e+06 * n_2p3_nl'
		block = Plasma
	[]
	[WL_750.387_val]
		type = ParsedAux
		variable = WL_750.387
		coupled_variables = n_2p1_nl
		expression = '(6.626e-34 * 3e8 / 750.387e-9) * 4.50e+07 * n_2p1_nl'
		block = Plasma
	[]
	[WL_751.465_val]
		type = ParsedAux
		variable = WL_751.465
		coupled_variables = n_2p5_nl
		expression = '(6.626e-34 * 3e8 / 751.465e-9) * 4.00e+07 * n_2p5_nl'
		block = Plasma
	[]
	[WL_763.511_val]
		type = ParsedAux
		variable = WL_763.511
		coupled_variables = n_2p6_nl
		expression = '(6.626e-34 * 3e8 / 763.511e-9) * 2.45e+07 * n_2p6_nl'
		block = Plasma
	[]
	[WL_772.376_val]
		type = ParsedAux
		variable = WL_772.376
		coupled_variables = n_2p7_nl
		expression = '(6.626e-34 * 3e8 / 772.376e-9) * 5.20e+06 * n_2p7_nl'
		block = Plasma
	[]
	[WL_772.421_val]
		type = ParsedAux
		variable = WL_772.421
		coupled_variables = n_2p2_nl
		expression = '(6.626e-34 * 3e8 / 772.421e-9) * 1.17e+07 * n_2p2_nl'
		block = Plasma
	[]
	[WL_794.818_val]
		type = ParsedAux
		variable = WL_794.818
		coupled_variables = n_2p4_nl
		expression = '(6.626e-34 * 3e8 / 794.818e-9) * 1.86e+07 * n_2p4_nl'
		block = Plasma
	[]
	[WL_800.616_val]
		type = ParsedAux
		variable = WL_800.616
		coupled_variables = n_2p6_nl
		expression = '(6.626e-34 * 3e8 / 800.616e-9) * 4.90e+06 * n_2p6_nl'
		block = Plasma
	[]
	[WL_801.479_val]
		type = ParsedAux
		variable = WL_801.479
		coupled_variables = n_2p8_nl
		expression = '(6.626e-34 * 3e8 / 801.479e-9) * 9.30e+06 * n_2p8_nl'
		block = Plasma
	[]
	[WL_810.369_val]
		type = ParsedAux
		variable = WL_810.369
		coupled_variables = n_2p7_nl
		expression = '(6.626e-34 * 3e8 / 810.369e-9) * 2.50e+07 * n_2p7_nl'
		block = Plasma
	[]
	[WL_811.531_val]
		type = ParsedAux
		variable = WL_811.531
		coupled_variables = n_2p9_nl
		expression = '(6.626e-34 * 3e8 / 811.531e-9) * 3.30e+07 * n_2p9_nl'
		block = Plasma
	[]
	[WL_826.452_val]
		type = ParsedAux
		variable = WL_826.452
		coupled_variables = n_2p2_nl
		expression = '(6.626e-34 * 3e8 / 826.452e-9) * 1.53e+07 * n_2p2_nl'
		block = Plasma
	[]
	[WL_840.821_val]
		type = ParsedAux
		variable = WL_840.821
		coupled_variables = n_2p3_nl
		expression = '(6.626e-34 * 3e8 / 840.821e-9) * 2.23e+07 * n_2p3_nl'
		block = Plasma
	[]
	[WL_842.465_val]
		type = ParsedAux
		variable = WL_842.465
		coupled_variables = n_2p8_nl
		expression = '(6.626e-34 * 3e8 / 842.465e-9) * 2.15e+07 * n_2p8_nl'
		block = Plasma
	[]
	[WL_852.144_val]
		type = ParsedAux
		variable = WL_852.144
		coupled_variables = n_2p4_nl
		expression = '(6.626e-34 * 3e8 / 852.144e-9) * 1.39e+07 * n_2p4_nl'
		block = Plasma
	[]
	[WL_866.794_val]
		type = ParsedAux
		variable = WL_866.794
		coupled_variables = n_2p7_nl
		expression = '(6.626e-34 * 3e8 / 866.794e-9) * 2.43e+06 * n_2p7_nl'
		block = Plasma
	[]
	[WL_912.297_val]
		type = ParsedAux
		variable = WL_912.297
		coupled_variables = n_2p10_nl
		expression = '(6.626e-34 * 3e8 / 912.297e-9) * 1.89e+07 * n_2p10_nl'
		block = Plasma
	[]
	[WL_922.450_val]
		type = ParsedAux
		variable = WL_922.450
		coupled_variables = n_2p6_nl
		expression = '(6.626e-34 * 3e8 / 922.450e-9) * 5.00e+06 * n_2p6_nl'
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

	nl_rel_tol = 1e-14
[]

[Preconditioning]
	[smp]
		type = SMP
		full = true
	[]
[]

[Materials]
	[Pin_Basic]
	  type = GasElectronMoments
	  interp_trans_coeffs = false
	  interp_elastic_coeff = false
	  ramp_trans_coeffs = false
  
	  # Pressure dependent coefficents default 1 Torr: Need to change during pressure sweep
	  user_p_gas = 133.3
  
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
	  user_p_gas = 133.3
  
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
		user_p_gas = 133.3
	
		user_T_gas = 300
		property_tables_file = electron_moments.txt
		block = Plasma
	[]
[]