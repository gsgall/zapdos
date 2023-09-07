[GlobalParams]
  gravity = '0 0 0'
  laplace = true
  integrate_p_by_parts = false
  supg = true
  pspg = true
  alpha = 1
[]

[Mesh]
    [./Jet_Mesh]
        type = FileMeshGenerator
        file = 'jet_mesh.msh'
    [../]
    [./corner_node]
      type = ExtraNodesetGenerator
      new_boundary = 'pinned_node'
      coord = '0 0.8 0'
      input = Jet_Mesh
    [../]
    second_order = true
[]

[Variables]
    [./vel_x]
        order = SECOND
        family = LAGRANGE
        block = 'gas'
        initial_condition = 1e-15
    [../]

    [./vel_y]
        order = SECOND
        family = LAGRANGE
        block = 'gas'
        initial_condition = 1e-15
    [../]

    [./p]
        order = FIRST
        family = LAGRANGE
        block = 'gas'
        initial_condition = 101325
    [../]
[]

[Kernels]
    [./mass]
        type = INSMass
        variable = p
        u = vel_x
        v = vel_y
        p = p
        block = 'gas'
    [../]

    [./x_momentum_time]
      type = INSMomentumTimeDerivative
      variable = vel_x
    [../]

    [./x_momentum_space]
        type = INSMomentumLaplaceForm
        variable = vel_x
        u = vel_x
        v = vel_y
        p = p
        component = 0
        block = 'gas'
    [../]

    [./y_momentum_time]
      type = INSMomentumTimeDerivative
      variable = vel_y
    [../]

    [./y_momentum_space]
        type = INSMomentumLaplaceForm
        variable = vel_y
        u = vel_x
        v = vel_y
        p = p
        component = 1
        block = 'gas'
    [../]
[]

[BCs]
    [./x_no_slip]
        type = DirichletBC
        variable = vel_x
        boundary = 'top_electrode bottom_electrode ground'
        value = 0.0
    [../]

    [./y_no_slip]
        type = DirichletBC
        variable = vel_y
        boundary = 'inlet top_electrode bottom_electrode ground'
        value = 0.0
    [../]

    [./x_inlet]
        type = FunctionDirichletBC
        variable = vel_x
        boundary = 'inlet'
        function = 'inlet_func'
    [../]

    [./pressure]
        type = PenaltyDirichletBC
        variable = p
        boundary = 'walls outlet'
        #boundary = 'pinned_node'
        value = 101325
        penalty = 1e6
        preset = false
    [../]

    [./u_out_a]
      type = INSMomentumNoBCBCLaplaceForm
      boundary = 'walls outlet'
      variable = vel_x
      u = vel_x
      v = vel_y
      pressure = p
      component = 0
    [../]
    [./v_out_a]
      type = INSMomentumNoBCBCLaplaceForm
      boundary = 'walls outlet'
      variable = vel_y
      u = vel_x
      v = vel_y
      pressure = p
      component = 1
    [../]

    #[./pressure_out]
    #    type = MassFreeBC
    #    variable = p
    #    boundary = 'outlet'
    #    vel_x = vel_x
    #    vel_y = vel_y
    #[../]
    #[./u_out_b]
    #  type = MomentumFreeBC
    #  boundary = 'outlet'
    #  variable = vel_x
    #  vel_x = vel_x
    #  vel_y = vel_y
    #  pressure = p
    #  component = 0
    #[../]
    #[./v_out_b]
    #  type = MomentumFreeBC
    #  boundary = 'outlet'
    #  variable = vel_y
    #  vel_x = vel_x
    #  vel_y = vel_y
    #  pressure = p
    #  component = 1
    #[../]
[]

[Functions]
    [./inlet_func]
        type = ParsedFunction
        value = '(1.67e-3 / 2e-6) * (-100 * ( y - 2.2 )^2 + 1)'# * tanh(2 * 3.1415 * t)'
        #value = '1 * (-100 * ( y - 2.2 )^2 + 1)'
    [../]
[]

[Materials]
    # Assume temperature of 300K
    # Argon Viscosity
    # https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=907539
    # Argon Density
    # https://www.engineeringtoolbox.com/argon-density-specific-weight-temperature-pressure-d_2089.html
    [./gas_properties]
        type = GenericConstantMaterial
        block = 'gas'
        prop_names = 'rho mu'
        #prop_values = '1  1'
        prop_values = '1.603  22.7e-6'
    [../]
[]

[Preconditioning]
    [./SMP_PJFNK]
        type = SMP
        full = true
    [../]
[]

[Executioner]
    type = Transient
    solve_type = NEWTON
    petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
    petsc_options_value = 'lu NONZERO 1.e-10'
    line_search = none

    nl_abs_tol = 1e-8
    nl_max_its = 15

    l_max_its = 300
    [./TimeStepper]
      type = IterationAdaptiveDT
      cutback_factor = 0.4
      dt = 1e-8
      growth_factor = 1.2
     optimal_iterations = 10
    [../]
    steady_state_detection = true
    automatic_scaling = true
    compute_scaling_once = false
[]

[Outputs]
    [./out]
        type = Exodus
    [../]
    file_base = 'argon_outlet-Free-Loose'
    #[./out_nl]
    #    type = Exodus
    #    execute_on = 'NONLINEAR'
    #[../]
[]
