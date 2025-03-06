clc
clear

% Tracked species and ground state Ar
SpeciesKey = {'Ar',... 
              'Ar(1s5)',... 
              'Ar(1s4)',... 
              'Ar(1s3)',... 
              'Ar(1s2)',... 
              'Ar(2p10)',... 
              'Ar(2p9)',... 
              'Ar(2p8)',... 
              'Ar(2p7)',... 
              'Ar(2p6)',... 
              'Ar(2p5)',... 
              'Ar(2p4)',... 
              'Ar(2p3)',... 
              'Ar(2p2)',... 
              'Ar(2p1)',... 
              'Ar(3d12)',... 
              'Ar(3d11)',... 
              'Ar(3d10)',... 
              'Ar(3d9)',...
              'Ar(3d8)',... 
              'Ar(3d7)',... 
              'Ar(2s5)',... 
              'Ar(2s4)',... 
              'Ar(3d6)',... 
              'Ar(3d5)',... 
              'Ar(3d4)',... 
              'Ar(3d3)',... 
              'Ar(3d2)',... 
              'Ar(2s3)',... 
              'Ar(2s2)',... 
              'Ar(3d1)',... 
              'Ar(3p10)',... 
              'Ar(3p9)',... 
              'Ar(3p8)',... 
              'Ar(3p7)',... 
              'Ar(3p6)',... 
              'Ar(3p5)',... 
              'Ar(3p4)',... 
              'Ar(3p3)',... 
              'Ar(3p2)',... 
              'Ar(3p1)'};

Species = ["gs" 
           "1s5"
           "1s4"
           "1s3"
           "1s2"
           "2p10"
           "2p9"
           "2p8"
           "2p7"
           "2p6"
           "2p5"
           "2p4"
           "2p3"
           "2p2"
           "2p1"
           "3d12"
           "3d11"
           "3d10"
           "3d9"
           "3d8"
           "3d7"
           "2s5"
           "2s4"
           "3d6"
           "3d5"
           "3d4"
           "3d3"
           "3d2"
           "2s3"
           "2s2"
           "3d1"
           "3p10"
           "3p9"
           "3p8"
           "3p7"
           "3p6"
           "3p5"
           "3p4"
           "3p3"
           "3p2"
           "3p1"];

fileID = fopen('argon_CRM.i','w');
mesh(fileID)
problem(fileID)
variables(fileID,Species)
kernels(fileID,Species)
crane(fileID,SpeciesKey,Species)
aux_varNkernels(fileID,Species)
executioner(fileID)
preconditioning(fileID)
output(fileID)
fclose(fileID);
[temp,temp,lightdata] = xlsread('Formating_And_LightEmission.xlsx','Light Emission');

%Funtions

% Funtion to write the mesh block
function mesh(fileID)
    fprintf(fileID,'[Mesh]\n');
    fprintf(fileID,'\t[fmg]\n');
    fprintf(fileID,'\t\ttype = FileMeshGenerator\n');
    fprintf(fileID,'\t\tfile = 2D-RF-OnePlate-100mTorr-SO-050V-NewMesh-bias_out-cont01.e\n');
    fprintf(fileID,'\t\tuse_for_exodus_restart = true\n');
    fprintf(fileID,'\t[]\n');
    fprintf(fileID,'\tcoord_type = RZ\n');
    fprintf(fileID,'\trz_coord_axis = Y\n');
    fprintf(fileID,'[]\n\n');
end

function problem(fileID)
    fprintf(fileID,'[Problem]\n');
    fprintf(fileID,'\ttype = FEProblem\n');
    fprintf(fileID,'[]\n\n');
end

function variables(fileID,array)
    IC = -20;
    fprintf(fileID,'[Variables]\n');

    fprintf(fileID,'\t[Dummy]\n');
    fprintf(fileID,'\t\tblock = ''Resonator_Pin Ceramic''\n');
    fprintf(fileID,'\t[]\n');

    for i=2:length(array)
        name = array(i);
        fprintf(fileID,'\t[n_%s]\n', name);
        fprintf(fileID,'\t\tblock = Plasma\n');
        fprintf(fileID,'\t\tinitial_condition = %.1f\n', IC);
        fprintf(fileID,'\t[]\n');
    end
    fprintf(fileID,'[]\n\n');
end

function aux_varNkernels(fileID,Species)
    IC = 1;
    fprintf(fileID,'[AuxVariables]\n');

    fprintf(fileID,'\t[n_%s]\n', Species(1));
    fprintf(fileID,'\t\tblock = Plasma\n');
    fprintf(fileID,'\t[]\n');

    for i = 2:length(Species)
        fprintf(fileID,'\t[n_%s_nl]\n', Species(i));
        fprintf(fileID,'\t\tblock = Plasma\n');
        fprintf(fileID,'\t[]\n');
    end

    fprintf(fileID,'\t[em]\n');
    fprintf(fileID,'\t\tblock = Plasma\n');
    fprintf(fileID,'\t\tinitial_from_file_var = ne_log\n');
    fprintf(fileID,'\t\tinitial_from_file_timestep = LATEST\n');
    fprintf(fileID,'\t[]\n');

    fprintf(fileID,'\t[mean_en]\n');
    fprintf(fileID,'\t\tblock = Plasma\n');
    fprintf(fileID,'\t\tinitial_from_file_var = mean_log\n');
    fprintf(fileID,'\t\tinitial_from_file_timestep = LATEST\n');
    fprintf(fileID,'\t[]\n');

    %Light Emission Variables
    [temp,temp,lightdata] = xlsread('Formating_And_LightEmission.xlsx','Light Emission');
    for i = 2:length(lightdata)
        fprintf(fileID,'\t[WL_%.3f]\n',lightdata{i,1});
        fprintf(fileID,'\t\tblock = Plasma\n');
        fprintf(fileID,'\t[]\n');
    end


    fprintf(fileID,'[]\n\n');

    fprintf(fileID,'[AuxKernels]\n');

    fprintf(fileID,'\t[n_%s_val]\n', Species(1));
    fprintf(fileID,'\t\ttype = FunctionAux\n');
    fprintf(fileID,'\t\tvariable = n_%s\n', Species(1));
    fprintf(fileID,'\t\tfunction = ''log(3.22e21/6.02e23)''\n');
    fprintf(fileID,'\t\texecute_on = INITIAL\n');
    fprintf(fileID,'\t\tblock = Plasma\n');
    fprintf(fileID,'\t[]\n');

    for i = 2:length(Species)
        fprintf(fileID,'\t[n_%s_nl_val]\n', Species(i));
        fprintf(fileID,'\t\ttype = ParsedAux\n');
        fprintf(fileID,'\t\tvariable = n_%s_nl\n', Species(i));
        fprintf(fileID,'\t\tcoupled_variables = n_%s\n', Species(i));
        fprintf(fileID,'\t\texpression = ''exp(n_%s) * 6.022e23''\n', Species(i));
        fprintf(fileID,'\t\tblock = Plasma\n');
        fprintf(fileID,'\t[]\n');
    end

     %Light Emission Calculation
    [temp,temp,lightdata] = xlsread('Formating_And_LightEmission.xlsx','Light Emission');
    for i = 2:length(lightdata)
        fprintf(fileID,'\t[WL_%.3f_val]\n',lightdata{i,1});
        fprintf(fileID,'\t\ttype = ParsedAux\n');
        fprintf(fileID,'\t\tvariable = WL_%.3f\n', lightdata{i,1});
        fprintf(fileID,'\t\tcoupled_variables = n_%s_nl\n', lightdata{i,9});
        fprintf(fileID,'\t\texpression = ''(6.626e-34 * 3e8 / %.3fe-9) * %.2e * n_%s_nl''\n', lightdata{i,1},lightdata{i,10},lightdata{i,9});
        fprintf(fileID,'\t\tblock = Plasma\n');
        fprintf(fileID,'\t[]\n');
    end

    fprintf(fileID,'[]\n\n');
end

function kernels(fileID,array)
    fprintf(fileID,'[Kernels]\n');

    fprintf(fileID,'\t[Dummy]\n');
    fprintf(fileID,'\t\ttype = NullKernel\n');
    fprintf(fileID,'\t\tvariable = Dummy\n');
    fprintf(fileID,'\t\tblock = ''Resonator_Pin Ceramic''\n');
    fprintf(fileID,'\t[]\n');

    for i=2:length(array)
        name = array(i);
        fprintf(fileID,'\t[n_%s_time_deriv]\n', name);
        fprintf(fileID,'\t\ttype = TimeDerivativeLog\n');
        fprintf(fileID,'\t\tvariable = n_%s\n', name);
        fprintf(fileID,'\t\tblock = Plasma\n');
        fprintf(fileID,'\t[]\n');
    end
    fprintf(fileID,'[]\n\n');
end

function crane(fileID,SpeciesKey,Species)
    fprintf(fileID,'[Reactions]\n');
    fprintf(fileID,'\t[Gas]\n');
    fprintf(fileID,'\t\tspecies = ''');
    for i=2:length(Species)
        name = Species(i);
        if i == 2
            fprintf(fileID,'n_%s', name);
        else
            fprintf(fileID,' n_%s', name);
        end
    end
    fprintf(fileID,'''\n');

    fprintf(fileID,'\t\taux_species = ''');
    fprintf(fileID,'n_%s', Species(1));
    fprintf(fileID,'''\n');

    fprintf(fileID,'\t\treaction_coefficient_format = ''rate''\n');
    
    fprintf(fileID,'\t\tgas_species = ''');
    fprintf(fileID,'n_%s', Species(1));
    fprintf(fileID,'''\n');
    
    fprintf(fileID,'\t\telectron_energy = ''mean_en''\n');
    fprintf(fileID,'\t\telectron_density = ''em''\n');
    fprintf(fileID,'\t\tinclude_electrons = true\n');
    fprintf(fileID,'\t\tposition_units = 1.0\n');
    fprintf(fileID,'\t\tfile_location = ''excitation_rates''\n');

    fprintf(fileID,'\t\tuse_log = false\n');
    fprintf(fileID,'\t\tuse_ad = true\n');
    fprintf(fileID,'\t\tblock = Plasma\n');
    fprintf(fileID,'\t\treactions = ''');
    SpeciesMap = containers.Map(SpeciesKey,Species);
    %Ground State Reactions
    for i = 2:length(Species)
        if i>2
            fprintf(fileID,'\t\t             ');
        end
        reaction_string = append('n_',Species(1),' + em -> n_',Species(i),' + em');
        reaction_name = append(Species(1),'_To_',Species(i));
        fprintf(fileID,reaction_string);
        fprintf(fileID,'  \t : EEDF (');
        fprintf(fileID,reaction_name);
        fprintf(fileID,') \n');
        fprintf(fileID,'\t\t             ');
        reaction_string = append('n_',Species(i),' + em -> n_',Species(1),' + em');
        reaction_name = append(Species(i),'_To_',Species(1));
        fprintf(fileID,reaction_string);
        fprintf(fileID,'  \t : EEDF (');
        fprintf(fileID,reaction_name);
        fprintf(fileID,')\n');
    end
    %1s <-> 1s, 2p <-> 2p, 1s <-> 2p Reactions
    for i = 2:15
        for j = 2:15
            if i ~= j
                fprintf(fileID,'\t\t             ');
                reaction_string = append('n_',Species(i),' + em -> n_',Species(j),' + em');
                reaction_name = append(Species(i),'_To_',Species(j));
                fprintf(fileID,reaction_string);
                fprintf(fileID,'\t : EEDF (');
                fprintf(fileID,reaction_name);
                fprintf(fileID,')\n');
            end
        end
    end
    %Light Emission
    [temp,temp,lightdata] = xlsread('Formating_And_LightEmission.xlsx','Light Emission');
    for i = 2:length(lightdata)
        fprintf(fileID,'\t\t             ');
        reaction_string = append('n_',lightdata{i,9},' -> n_',lightdata{i,8},' ');
        reaction_name = lightdata{i,10};
        fprintf(fileID,reaction_string);
        fprintf(fileID,'\t : ');
        fprintf(fileID,'%.2e', reaction_name);
        fprintf(fileID,'\n');
    end
    %Metastable Ionization (1s3 & 1s5 states)
        fprintf(fileID,'\t\t             ');
        reaction_string = append('n_1s5 + em -> Ar+ + em + em');
        reaction_name = append('1s5-Ionization');
        fprintf(fileID,reaction_string);
        fprintf(fileID,'\t : EEDF (');
        fprintf(fileID,reaction_name);
        fprintf(fileID,')\n');

        fprintf(fileID,'\t\t             ');
        reaction_string = append('n_1s3 + em -> Ar+ + em + em');
        reaction_name = append('1s3-Ionization');
        fprintf(fileID,reaction_string);
        fprintf(fileID,'\t : EEDF (');
        fprintf(fileID,reaction_name);
        fprintf(fileID,')''\n');

    fprintf(fileID,'\t[]\n');
    fprintf(fileID,'[] \n \n');
end

% Funtion to write the executioner block
function executioner(fileID)
    fprintf(fileID,'[Executioner]\n');
    fprintf(fileID,'\ttype = Transient\n');
    
    fprintf(fileID,'\tend_time = 1e-6\n');
    fprintf(fileID,'\tdt = 1e-9\n');
    fprintf(fileID,'\tdtmin = 1e-14\n');
    fprintf(fileID,'\tscheme = newmark-beta\n');
    
    fprintf(fileID,'\tsolve_type = ''NEWTON''\n');
    fprintf(fileID,'\n');
    fprintf(fileID,'\tautomatic_scaling = true\n');
    fprintf(fileID,'\tcompute_scaling_once = false\n');
    fprintf(fileID,'\n');
    fprintf(fileID,'\tpetsc_options = ''-snes_converged_reason -snes_linesearch_monitor''\n');
    fprintf(fileID,'\tpetsc_options_iname = ''-pc_type -pc_factor_mat_solver_package -pc_factor_shift_type -pc_factor_shift_amount''\n');
    fprintf(fileID,'\tpetsc_options_value = ''lu       superlu_dist                  NONZERO               1.e-10''\n');
    fprintf(fileID,'[]\n\n');
end

% Funtion to write the preconditioning block
function preconditioning(fileID)
    fprintf(fileID,'[Preconditioning]\n');
    fprintf(fileID,'\t[smp]\n');
    fprintf(fileID,'\t\ttype = SMP\n');
    fprintf(fileID,'\t\tfull = true\n');
    fprintf(fileID,'\t[]\n');
    fprintf(fileID,'[]\n\n');
end

% Funtion to write the output block
function output(fileID)
    fprintf(fileID,'[Outputs]\n');
    fprintf(fileID,'\t[out]\n');
    fprintf(fileID,'\t\ttype = Exodus\n');
    fprintf(fileID,'\t[]\n');
    fprintf(fileID,'[]\n\n');
end