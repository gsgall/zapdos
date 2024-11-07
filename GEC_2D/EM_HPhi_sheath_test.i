[Mesh]
  [./cmg]
    type = CartesianMeshGenerator
    dim = 2
    dx = '0.5'
    dy = '0.002 0.04 0.002'
    ix = '200'
    iy = '5 20 5'
    subdomain_id = '0
                    1
                    0'
  [../]
  second_order = true
[]

[Problem]
  type = FEProblem
  coord_type = RZ
  rz_coord_axis = Y
[]

[GlobalParams]
  driving_frequency = 275e6
[]

[Variables]
  [./HPhi_real]
    family = LAGRANGE
    order = SECOND
  [../]
  [./HPhi_imag]
    family = LAGRANGE
    order = SECOND
  [../]
  [./Er_real]
    family = LAGRANGE
    order = SECOND
  [../]
  [./Er_imag]
    family = LAGRANGE
    order = SECOND
  [../]
  [./Ez_real]
    family = LAGRANGE
    order = SECOND
  [../]
  [./Ez_imag]
    family = LAGRANGE
    order = SECOND
  [../]
[]

[AuxVariables]
  [./em]
    #initial_condition = 18.42068 #1e8
    #initial_condition = 20.72327 #1e9
    #initial_condition = 23.0259 #1e10
    #initial_condition = 25.32844 #1e11
    initial_condition = 27.63102 #1e12
    #initial_condition = 36.8414 # exp(36.8414) = ~10^16 m^-3 = ~10^10 cm^-3
    block = 1
  [../]
[]

[Kernels]
  [./wave_equation_real]
    type = HPhiCylindricalPlasmaWaveEquation
    variable = HPhi_real
    component = real
    real_field = HPhi_real
    imaginary_field = HPhi_imag
  [../]
  [./wave_equation_imag]
    type = HPhiCylindricalPlasmaWaveEquation
    variable = HPhi_imag
    component = imaginary
    real_field = HPhi_real
    imaginary_field = HPhi_imag
  [../]
  [./Er_eqn_real]
    type = HPhiCylindricalPlasmaEr
    variable = Er_real
    component = real
    real_field = Er_real
    imaginary_field = Er_imag
    real_Hphi = HPhi_real
    imaginary_HPhi = HPhi_imag
  [../]
  [./Er_eqn_imag]
    type = HPhiCylindricalPlasmaEr
    variable = Er_imag
    component = imaginary
    real_field = Er_real
    imaginary_field = Er_imag
    real_Hphi = HPhi_real
    imaginary_HPhi = HPhi_imag
  [../]
  [./Ez_eqn_real]
    type = HPhiCylindricalPlasmaEz
    variable = Ez_real
    component = real
    real_field = Ez_real
    imaginary_field = Ez_imag
    real_Hphi = HPhi_real
    imaginary_HPhi = HPhi_imag
  [../]
  [./Ez_eqn_imag]
    type = HPhiCylindricalPlasmaEz
    variable = Ez_imag
    component = imaginary
    real_field = Ez_real
    imaginary_field = Ez_imag
    real_Hphi = HPhi_real
    imaginary_HPhi = HPhi_imag
  [../]
[]

[BCs]
  [./h_phi_real_current] # Magnetic field into the page at the edge of the domain (based on applied rf current)
    type = ADFunctionDirichletBC
    variable = HPhi_real
    function = HPhi0
    boundary = right
  [../]
  [./h_phi_imag_right]
    type = ADDirichletBC
    variable = HPhi_imag
    value = 0
    boundary = right
  [../]
[]

[Functions]
  [./HPhi0] # Irf = 2*pi*x*HPhi0
    type = ParsedFunction
    value = '1/(2*pi*x)'
  [../]
[]

[Materials]
  [./plasma_dielectric]
    type = PlasmaDielectricConstant
    electron_neutral_collision_frequency = 200e6
    em = em
    block = 1
    output_properties = 'plasma_dielectric_constant_real plasma_dielectric_constant_imag'
  [../]
  [./sheath_val]
    type = ADGenericConstantMaterial
    prop_names = 'plasma_dielectric_constant_real plasma_dielectric_constant_imag'
    prop_values = '1 0'
    block = 0
  [../]
  [./sheath_grad]
    type = ADGenericConstantVectorMaterial
    prop_names = 'plasma_dielectric_constant_real_grad plasma_dielectric_constant_imag_grad'
    prop_values = '0 0 0 0 0 0'
    block = 0
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'lu NONZERO 1.e-10'
  automatic_scaling = true
  compute_scaling_once = false
[]

[Outputs]
  #exodus = true
  [./exodus]
    type = Exodus
    file_base = 'out_1e12'
  [../]
  perf_graph = true
[]
