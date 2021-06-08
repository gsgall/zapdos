dom0Scale = 25.4e-3

[GlobalParams]
    ## Issue was that the v in kV was lowercased
    potential_units = kV
    use_moles = true
[]

[Mesh]
    [./file]
        type = FileMeshGenerator
        file = 'Lymberopoulos.msh'
    [../]
    [./left]
        type = SideSetsFromNormalsGenerator
        normals = '-1 0 0'
        new_boundary = 'left'
        input = file # file where the mesh is coming from
    [../]
    [./right]
        type = SideSetsFromNormalsGenerator
        normals = '1 0 0'
        new_boundary = 'right'
        input = left # uses left because it is building off of the left point
    [../]
[]

[Problem]
    type = FEProblem
[]

# This file only includes the metastables data because it is only running those calculations
[Variables]
    [./Ar*]
    [../]
[]

[AuxVariables]
    [Ar*S]
    [../]

    [Ar*T]
    [../]

    [SM_Ar*]
    [../]

    #Resets the sensativity matrix at the beginning of each acceleration
    [SM_Ar*Reset]
        initial_condition = 1.0
    [../]
[]

[Kernels]
    [./Shoot_Method]
        type = ShootMethodLog
        variable = Ar*
        density_at_start_cycle = Ar*S
        density_at_end_cycle = Ar*T
        sensitivity_variable = SM_Ar*
    [../]
[]

[AuxKernels]
    # Resets the sensativity matrix at the start of every run
    [./Constant_SM_Ar*Reset]
        type = ConstantAux
        variable = SM_Ar*Reset
        value = 1.0 # value to set at the beginning of the time step
        execute_on = 'TIMESTEP_BEGIN'
    [../]
[]

# BCs are the same as in the original but only include meta stable conditions
# Why are these BCs different than in the original file
[BCs]
    [Ar*_right]
        type = ADDirichletBC
        variable = Ar*
        boundary = 'right'
        value = -50.0
    [../]


    [Ar*_left]
        type = ADDirichletBC
        variable = Ar*
        boundary = 'left'
        value = -50.0
    [../]
[]

# Ask about what this does
[Postprocessors]
    [./Meta_Relative_Diff]
        type = RelativeElementL2Difference
        variable = Ar*
        other_variable = Ar*S
        execute_on = 'TIMESTEP_END'
    [../]
[]


[Preconditioning]
    [./smp]
        type = SMP
        full = true
    [../]
[]

[Executioner]
    type = Steady
    petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
    solve_type = NEWTON

    petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
    petsc_options_value = 'lu NONZERO 1.e-10'

    abort_on_solve_fail = true
[]

[Outputs]
    perf_graph = true
    [./out]
        type = Exodus
    [../]
[]
