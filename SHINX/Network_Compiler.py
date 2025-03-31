import numpy as np
import os
import pandas as pd
import shutil
import subprocess

#################################################################################
# Define Target Model
#################################################################################

# Target model components
model_name = 'ArgonCRM'

# Constant system settings
Gas_mixture = ["Ar"]
Mixture_proportions = np.array([1])
T_gas = 300
nu = 2.40e9

# Initiate runs
run_pressure_power_sweep = 0

#################################################################################
# Update Bolsig Compiler script
#################################################################################

# Open BOLSIG compiler script
with open(os.path.join('Microwave_Model','BolsigCompiler_SRC.py'),"r") as file:
    fb_source = file.readlines()

# Update BOLSIG input params - general
fb_mod = fb_source
fb_mod[13] = f'model_name ="{model_name}"\n'
fb_mod[15] = f'T_bg = {T_gas}\n'

# Update BOLSIG to handle multi-species models
if len(Mixture_proportions) > 1:
    fb_mod[19] = f'enable_aux_species = 1\n'
    aux_species = "aux_species = ["
    aux_proportions = "aux_concentration = np.array(["
    for n in len(Mixture_proportions):
        if n == 0:
            aux_species = f'{aux_species}"{Gas_mixture[n]}"'
            aux_proportions = f'{aux_proportions}{Mixture_proportions[n]}'
        else:
            aux_species = f'{aux_species} "{Gas_mixture[n]}"'
            aux_proportions = f'{aux_proportions} {Mixture_proportions[n]}'
    aux_species = f'{aux_species}]\n'
    aux_proportions = f'{aux_proportions}])\n'
    fb_mod[20] = aux_species
    fb_mod[21] = aux_proportions

#################################################################################
# Reduced model scripts
#################################################################################

# Read species names from data key
Species_key = pd.read_excel(os.path.join('Model_Inputs',f'{model_name}_key.xlsx'), 
                            sheet_name='Species_Reduced', engine='openpyxl', header=0)

# Read in source files
with open(os.path.join('Microwave_Model','SHINX_Chemistry_Solver_SRC.i'),"r") as file:
    f1_source = file.readlines()
with open(os.path.join('Microwave_Model','SHINX_Mesh_Generator_SRC.i'),"r") as file:
    f2_source = file.readlines()
with open(os.path.join('Microwave_Model','SHINX_Microwave_Model_SRC.i'),"r") as file:
    f3_source = file.readlines()
f1_mod = f1_source
f2_mod = f2_source
f3_mod = f3_source

# Update fixed simulation params
f1_mod[3] = f'nu = {nu}\n'
f1_mod[4] = f'T_gas = {T_gas}\n'
f2_mod[4] = f'nu = {nu}\n'
f2_mod[5] = f'T_gas = {T_gas}\n'
f3_mod[4] = f'nu = {nu}\n'
f3_mod[5] = f'T_gas = {T_gas}\n'

# Initialize variables
j = 0
k = 0

# Initialize reactions
RXN_gas_species = ""
RXN_species_aux = ""
RXN_species = "em"

# Initialize moose blocks
F2_1_1 = F2_1_2 = F2_1_3 = ""
F3_1_1 = F3_1_2 = F3_1_3 = ""

F1_2_1 = F1_2_2 = F1_2_3 = ""
F1_2_4 = F1_2_5 = F1_2_6 = ""
F1_2_7 = F1_2_8 = F1_2_9 = ""
F1_2_10 = F1_2_11 = F1_2_12 = ""
F1_2_13 = ""

F3_2_1 = F3_2_2 = F3_2_3 = ""
F3_2_4 = F3_2_5 = F3_2_6 = ""
F3_2_7 = F3_2_8 = F3_2_9 = ""
F3_2_10 = F3_2_11 = F3_2_12 = ""
F3_2_13 = F3_2_14 = F3_2_15 = ""
F3_2_16 = F3_2_17 = F3_2_18 = ""
F3_2_19 = F3_2_20 = F3_2_21 = ""
F3_2_22 = F3_2_23 = F3_2_24 = ""
F3_2_25 = F3_2_26 = F3_2_27 = ""
F3_2_28 = F3_2_29 = ""

F3_2_30 = "\tEnable_at_cycle_start = '"
F3_2_31 = "\tEnable_during_cycle = '"
F3_2_32 = "\tEnable_at_cycle_end = 'MultiApps::Shooting\n\t\t\t     "


# Loop over species key
for n, row in Species_key.iterrows():

    # Add ground states (Files: 2 3)
    if row.iloc[1] == 1:

        # Extract species name
        species = row.iloc[0]
        mass = row.iloc[2]

        # Extract species concentration
        index = Gas_mixture.index(species)
        conc = Mixture_proportions[index]

        # File 2 updates
        F2_1_1 += f"\t[{species}_prop]\n\t\ttype = ADHeavySpecies\n\t\theavy_species_name = {species}\n\t\theavy_species_mass = {mass}\n\t\theavy_species_charge = 0.0\n\t\tblock = Plasma\n\t[]\n"
        F2_1_2 += f"\t[{species}]\n\t[]\n"
        F2_1_3 += f"\t[n_{species}]\n\t\ttype = FunctionAux\n\t\tvariable = {species}\n\t\tfunction = '{conc} * log(${{Nbg}} / 6.022e23)'\n\t\texecute_on = INITIAL\n\t\tblock = Plasma\n\t[]\n"

        # File 3 updates
        F3_1_1 += f"\t[{species}_prop]\n\t\ttype = ADHeavySpecies\n\t\theavy_species_name = {species}\n\t\theavy_species_mass = {mass}\n\t\theavy_species_charge = 0.0\n\t\tblock = Plasma\n\t[]\n"
        F3_1_2 += f"\t[{species}]\n\t[]\n"
        F3_1_3 += f"\t[{species}]\n\t\ttype = FunctionAux\n\t\tvariable = {species}\n\t\tfunction = '{conc} * log(${{Nbg}} / 6.022e23)'\n\t\texecute_on = INITIAL\n\t\tblock = Plasma\n\t[]\n"

        # Save components for reactions block
        RXN_species_aux += f" {species}"
        RXN_gas_species += f" {species}"

        # Track iteration
        j += 1

    # Add excited species (Files: 1 3)
    elif row.iloc[1] == 2:

        # Extract species name
        species = row.iloc[0]
        mass = row.iloc[2]

        # File 1 updates
        F1_2_1 +=  f'    [{species}_prop]\n\t\ttype = ADHeavySpecies\n\t\theavy_species_name = {species}\n\t\theavy_species_mass = {mass}\n\t\theavy_species_charge = 0.0\n\t\tdiffusivity = 3.7577e-02\n\t\tmobility = 0.0\n\t[]\n'
        F1_2_2 +=  f"\t[{species}_BC1]\n\t\ttype = PenaltyDirichletBC\n\t\tvariable = {species}\n\t\tboundary = 'Chamber_Walls'\n\t\tvalue = -50\n\t\tpenalty = 1\n\t[]\n"
        F1_2_3 +=  f"\t[{species}_BC2]\n\t\ttype = ADPenaltyShootingMethodBC\n\t\tvariable = {species}\n\t\tdensity_at_start_cycle = {species}_i\n\t\tdensity_at_end_cycle = {species}_f\n\t\tsensitivity_variable = {species}_SM\n\t\tgrowth_limit = '${{growth_lim}}'\n\t\tboundary = 'Chamber_Bottom Plasma_Side'\n\t[]\n"
        F1_2_4 +=  f"\t[{species}]\n\t\tblock = Plasma\n\t[]\n"
        F1_2_5 +=  f"\t[{species}_shot]\n\t\ttype = ShootMethodLog\n\t\tvariable = {species}\n\t\tdensity_at_start_cycle = {species}_i\n\t\tdensity_at_end_cycle = {species}_f\n\t\tsensitivity_variable = {species}_SM\n\t\tgrowth_limit = '${{growth_lim}}'\n\t\tblock = Plasma\n\t[]\n"
        F1_2_6 +=  f"\t[{species}_i]\n\t\tblock = Plasma\n\t[]\n"
        F1_2_7 +=  f"\t[{species}_f]\n\t\tblock = Plasma\n\t[]\n"
        F1_2_8 +=  f"\t[{species}_SM]\n\t\tblock = Plasma\n\t[]\n"
        F1_2_9 +=  f"\t[{species}_ID]\n\t\tinitial_condition = 1.0\n\t\tblock = Plasma\n\t[]\n"
        F1_2_10 += f"\t[{species}_r]\n\t\tblock = Plasma\n\t[]\n"
        F1_2_11 += f"\t[{species}_reset]\n\t\ttype = ConstantAux\n\t\tvariable = {species}_ID\n\t\tvalue = 1.0\n\t\texecute_on = 'TIMESTEP_BEGIN'\n\t\tblock = Plasma\n\t[]\n"
        F1_2_12 += f"\t[{species}_r]\n\t\ttype = DebugResidualAux\n\t\tvariable = {species}_r\n\t\tdebug_variable = {species}\n\t[]\n"
        F1_2_13 += f"\t[{species}_delta]\n\t\ttype = RelativeElementL2Difference\n\t\tvariable = {species}\n\t\tother_variable = {species}_i\n\t\tblock = Plasma\n\t[]\n"

        # File 3 updates
        F3_2_1 +=  f"\t[{species}_prop]\n\t\ttype = ADHeavySpecies\n\t\theavy_species_name = {species}\n\t\theavy_species_mass = {mass}\n\t\theavy_species_charge = 0.0\n\t\tdiffusivity = 3.7577e-02\n\t\tmobility = 0.0\n\t[]\n"
        F3_2_2 +=  f"\t[{species}_BC1]\n\t\ttype = PenaltyDirichletBC\n\t\tvariable = {species}\n\t\tboundary = 'Chamber_Walls'\n\t\tvalue = -50\n\t\tpenalty = 1\n\t[]\n"
        F3_2_3 +=  f"\t[{species}_BC2]\n\t\ttype = DriftDiffusionDoNothingBC\n\t\tvariable = {species}\n\t\tmu = 0\n\t\tdiff = 0\n\t\tsign = 0\n\t\tuse_material_props = true\n\t\tboundary = 'Chamber_Bottom Plasma_Side'\n\t\t\n\t\tposition_units = '${{dom0Scale}}'\n\t[]\n"
        F3_2_4 +=  f"\t[{species}_SM_BC]\n\t\ttype = DirichletBC\n\t\tvariable = {species}\n\t\tboundary = 'Chamber_Bottom Plasma_Side'\n\t\tvalue = 0\n\t\tpreset = false\n\t\tenable = false\n\t[]\n"
        F3_2_5 +=  f"\t[{species}]\n\t\tinitial_from_file_var = {species}\n\t\tinitial_from_file_timestep = LATEST\n\t\tblock = Plasma\n\t[]\n"
        F3_2_6 +=  f"\t[{species}_SM]\n\t\tinitial_condition = 1.0\n\t\tinitial_from_file_var = {species}_SM\n\t\tinitial_from_file_timestep = LATEST\n\t\tblock = Plasma\n\t[]\n"
        F3_2_7 +=  f"\t[{species}_dt]\n\t\ttype = ElectronTimeDerivative\n\t\tvariable = {species}\n\t\tblock = Plasma\n\t[]\n"
        F3_2_8 +=  f"\t[{species}_diffusion]\n\t\ttype = CoeffDiffusion\n\t\tvariable = {species}\n\t\tposition_units = '${{dom0Scale}}'\n\t\tblock = Plasma\n\t[]\n"
        F3_2_9 +=  f"\t[{species}_SM_dt]\n\t\ttype = MassLumpedTimeDerivative\n\t\tvariable = {species}_SM\n\t\tenable = false\n\t\tblock = Plasma\n\t[]\n"
        F3_2_10 += f"\t[{species}_SM_diffusion]\n\t\ttype = CoeffDiffusionForShootMethod\n\t\tvariable = {species}_SM\n\t\tdensity = {species}\n\t\tposition_units = '${{dom0Scale}}'\n\t\tenable = false\n\t\tblock = Plasma\n\t[]\n"
        F3_2_11 += f"\t[{species}_SM_Null]\n\t\ttype = NullKernel\n\t\tvariable = {species}_SM\n\t\tblock = Plasma\n\t[]\n"
        F3_2_12 += f"\t[{species}_aux]\n\t\tinitial_from_file_var = {species}_aux\n\t\tinitial_from_file_timestep = LATEST\n\t\tblock = Plasma\n\t[]\n"
        F3_2_13 += f"\t[n_{species}]\n\t\torder = CONSTANT\n\t\tfamily = MONOMIAL\n\t\tblock = Plasma\n\t[]\n"
        F3_2_14 += f"\t[{species}_i]\n\t\tinitial_from_file_var = {species}_i\n\t\tinitial_from_file_timestep = LATEST\n\t\tblock = Plasma\n\t[]\n"
        F3_2_15 += f"\t[{species}_ID]\n\t\tinitial_condition = 1.0\n\t\tinitial_from_file_var = {species}_ID\n\t\tinitial_from_file_timestep = LATEST\n\t\tblock = Plasma\n\t[]\n"
        F3_2_16 += f"\t[{species}_aux]\n\t\ttype = SelfAux\n\t\tvariable = {species}_aux\n\t\tv = {species}\n\t\texecute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'\n\t\tblock = Plasma\n\t[]\n"
        F3_2_17 += f"\t[n_{species}]\n\t\ttype = DensityMoles\n\t\tvariable = n_{species}\n\t\tdensity_log = {species}\n\t\tblock = Plasma\n\t\texecute_on = 'INITIAL LINEAR TIMESTEP_END'\n\t[]\n"
        F3_2_18 += f"\t[{species}_i]\n\t\ttype = QuotientAux\n\t\tvariable = {species}_i\n\t\tnumerator = {species}\n\t\tdenominator = 1.0\n\t\tenable = false\n\t\texecute_on = 'TIMESTEP_END'\n\t\tblock = Plasma\n\t[]\n"
        F3_2_19 += f"\t[{species}_ID]\n\t\ttype = ConstantAux\n\t\tvariable = {species}_ID\n\t\tvalue = 1.0\n\t\texecute_on = INITIAL\n\t\tblock = Plasma\n\t[]\n"
        F3_2_20 += f"\t[{species}_delta]\n\t\ttype = Receiver\n\t[]\n"
        F3_2_21 += f"\t[{species}_aux_to_EM]\n\t\ttype = MultiAppCopyTransfer\n\t\tto_multi_app = EM_Heating\n\t\tsource_variable = {species}_aux\n\t\tvariable = {species}_aux\n\t[]\n"
        F3_2_22 += f"\t[{species}_ID_to_Shooting]\n\t\ttype = MultiAppCopyTransfer\n\t\tdirection = to_multiapp\n\t\tmulti_app = Shooting\n\t\tsource_variable = {species}_ID\n\t\tvariable = {species}_ID\n\t\tenable = false\n\t[]\n"
        F3_2_23 += f"\t[{species}_to_Shooting]\n\t\ttype = MultiAppCopyTransfer\n\t\tdirection = to_multiapp\n\t\tmulti_app = Shooting\n\t\tsource_variable = {species}\n\t\tvariable = {species}\n\t\tenable = false\n\t[]\n"
        F3_2_24 += f"\t[{species}_i_to_Shooting]\n\t\ttype = MultiAppCopyTransfer\n\t\tdirection = to_multiapp\n\t\tmulti_app = Shooting\n\t\tsource_variable = {species}_i\n\t\tvariable = {species}_i\n\t\tenable = false\n\t[]\n"
        F3_2_25 += f"\t[{species}_f_to_Shooting]\n\t\ttype = MultiAppCopyTransfer\n\t\tdirection = to_multiapp\n\t\tmulti_app = Shooting\n\t\tsource_variable = {species}\n\t\tvariable = {species}_f\n\t\tenable = false\n\t[]\n"
        F3_2_26 += f"\t[{species}_SM_to_Shooting]\n\t\ttype = MultiAppCopyTransfer\n\t\tdirection = to_multiapp\n\t\tmulti_app = Shooting\n\t\tsource_variable = {species}_SM\n\t\tvariable = {species}_SM\n\t\tenable = false\n\t[]\n"
        F3_2_27 += f"\t[{species}_from_Shooting]\n\t\ttype = MultiAppCopyTransfer\n\t\tdirection = from_multiapp\n\t\tmulti_app = Shooting\n\t\tsource_variable = {species}\n\t\tvariable = {species}\n\t\tenable = false\n\t[]\n"
        F3_2_28 += f"\t[{species}_ID_from_Shooting]\n\t\ttype = MultiAppCopyTransfer\n\t\tdirection = from_multiapp\n\t\tmulti_app = Shooting\n\t\tsource_variable = {species}_ID\n\t\tvariable = {species}_ID\n\t\tenable = false\n\t[]\n"
        F3_2_29 += f"\t[{species}_meta_delta_temp]\n\t\ttype = MultiAppPostprocessorTransfer\n\t\tdirection = from_multiapp\n\t\tmulti_app = Shooting\n\t\tfrom_postprocessor = {species}_delta\n\t\tto_postprocessor = {species}_delta\n\t\treduction_type = minimum\n\t\tenable = false\n\t[]\n"
        F3_2_30 += f"*::{species} "
        F3_2_31 += f"*::{species}_SM_dt *::{species}_SM_diffusion *::{species}_SM_BC\n\t\t\t     "
        F3_2_32 += f"*::{species}_ID_to_Shooting *::{species}_to_Shooting\n\t\t\t     *::{species}_i_to_Shooting *::{species}_f_to_Shooting\n\t\t\t     *::{species}_SM_to_Shooting *::{species}_from_Shooting\n\t\t\t     *::Ar001_ID_from_Shooting *::Ar001_meta_delta\n\t\t\t     "

        # Add species to reaction block
        RXN_species += f" {species}"
        
        # Track iteration
        k += 1

    # Add linebreaks to help with formating
    if j % 5 == 0:
        RXN_species_aux += f"\n\t\t\t\t"
        RXN_gas_species += f"\n\t\t\t\t"
    if k % 5  == 0:
        RXN_species += f"\n\t\t\t\t"

#################################################################################
# Build reaction network - reduced model
#################################################################################

# Reaction types
# 1 - Elastic collision
# 2 - Ionization
# 3 - Excitation
# 4 - Pooling
# 5 - 2B Quenching


# Function to write reaction
def get_2BRXN_Reduced(type,I1,I2,n,SE):

    # Elastic
    if type == 1:
        string = f"em + {I1} -> em + {I2} : "
    # Ionization
    elif type == 2:
        string = f"em + {I1} -> em + em + {I2} : "
    # Excitation/De-excitation
    elif type == 3:
        string = f"em + {I1} -> em + {I2} : "
        if SE == 1:
            rev_string = f"em + {I2} -> em + {I1} : "
    # Pooling
    elif type == 4:
        base = I1[:-2]
        string = f"{I1} + {I2} -> {base} + {base}_I + em : "
    # Quenching
    elif type == 5:
        base = I1[:-2]
        string = f"{I1} + {I2} -> {I2} + {base}_I + em : "

    # Format start of string
    if n == 0:
        result = [f"{string}"]
    elif SE == 1:
        result = [f"\t\t\t\t {string}", f"\t\t\t\t {rev_string}"]
    else:
        result = [f"\t\t\t\t {string}"]        

    # Return string
    return result

def get_2BSM_Reduced(type,I1,I2,n,SE):
    
    # Generate EEDF Block
    if n == 1:

        # Ioniization
        if type == 2:
            block = f"\t[{I1}_SM_Ionization]\n\t\ttype = EEDFReactionLogForShootMethod\n\t\tvariable = {I1}_SM\n\t\telectron = em\n\t\tdensity = {I1}\n\t\treaction = 'em + {I1} -> em + em + {I2}'\n\t\tcoefficient = -1\n\t\tenable = false\n\t\tblock = Plasma\n\t[]\n"
            rxn_name = f"*::{I1}_SM_Ionization\n\t\t\t     "
        # Excitation
        elif type == 3:
            block = f"\t[{I1}_SM_Excitation]\n\t\ttype = EEDFReactionLogForShootMethod\n\t\tvariable = {I1}_SM\n\t\telectron = em\n\t\tdensity = {I1}\n\t\treaction = 'em + {I1} -> em + {I2}'\n\t\tcoefficient = -1\n\t\tenable = false\n\t\tblock = Plasma\n\t[]\n"
            rxn_name = f"*::{I1}_SM_Excitation\n\t\t\t     "
            if SE == 1:
                block += f"\t[{I2}_SM_De-excitation]\n\t\ttype = EEDFReactionLogForShootMethod\n\t\tvariable = {I2}_SM\n\t\telectron = em\n\t\tdensity = {I2}\n\t\treaction = 'em + {I2} -> em + {I1}'\n\t\tcoefficient = -1\n\t\tenable = false\n\t\tblock = Plasma\n\t[]\n"
                rxn_name += f"*::{I2}_SM_De-excitation\n\t\t\t     "
        
    # Input rate dependant for 2 body collisions (single species)
    elif n == 2:

        # Pooling
        if type == 4:
            if I1 == I2:
                base = I1[:-2]
                block = f"\t[{I1}_SM_Pooling]\n\t\ttype = ReactionSecondOrderLogForShootMethod\n\t\tvariable = {I1}_SM\n\t\tdensity = {I1}\n\t\tv = {I2}\n\t\treaction = '{I1} + {I2} -> {base} + {base}_I + em'\n\t\tcoefficient = -2\n\t\tenable = false\n\t\tblock = Plasma\n\t[]\n"
                rxn_name = f"*::{I1}_SM_Pooling\n\t\t\t    "
            else:
                base = I1[:-2]
                block = f"\t[{I1}_SM_Pooling]\n\t\ttype = ReactionSecondOrderLogForShootMethod\n\t\tvariable = {I1}_SM\n\t\tdensity = {I1}\n\t\tv = {I2}\n\t\treaction = '{I1} + {I2} -> {base} + {base}_I + em'\n\t\tcoefficient = -1\n\t\tenable = false\n\t\tblock = Plasma\n\t[]\n\t[{I2}_SM_Pooling]\n\t\ttype = ReactionSecondOrderLogForShootMethod\n\t\tvariable = {I2}_SM\n\t\tdensity = {I2}\n\t\tv = {I1}\n\t\treaction = '{I1} + {I2} -> {base} + {base}_I + em'\n\t\tcoefficient = -1\n\t\tenable = false\n\t\tblock = Plasma\n\t[]\n"
                rxn_name = f"*::{I1}_SM_Pooling\n\t\t\t    *::{I2}_SM_Pooling\n\t\t\t    "
        # Quenching
        elif type == 5:
            base = I1[:-2]
            block = f"\t[{I1}_Quenching]\n\t\ttype = ReactionSecondOrderLogForShootMethod\n\t\tvariable = {I1}_SM\n\t\tdensity = {I1}\n\t\tv = {I2}\n\t\treaction = '{I1} + {I2} -> {I2} + {base}_I + em'\n\t\tcoefficient = -1\n\t\tenable = false\n\t\tblock = Plasma\n\t[]\n"
            rxn_name = f"*::{I1}_SM_Pooling\n\t\t\t     "

    # Return blocks 
    return [block,rxn_name]

# Construct reactions block
EEDF_RXNS = pd.read_excel(os.path.join('Model_Inputs',f'{model_name}_key.xlsx'),
               sheet_name='EEDF_Reduced', engine='openpyxl', header=0)

# Initialize variables
F2_RXN = ""
F3_RXN = ""
F3_SM_RXN = ""

for n, row in EEDF_RXNS.iterrows():

    # Extract RXN parameters
    type = row.iloc[0]
    src_indx = row.iloc[1]
    R = row.iloc[2]
    P = row.iloc[3]
    Eth = row.iloc[4]
    SE_col = row.iloc[6]

    # Construct rate equation
    rate_eqn = get_2BRXN_Reduced(type,R,P,n,SE_col)

    # Construct temporary input
    if type == 1:
        src_file = f"{R}_Elastic.txt"
        RXN_temp = f"{rate_eqn[0]} EEDF ({src_file})\n"
    elif type == 2:
        src_file = f"{R}_Ionization.txt"
        RXN_temp = f"{rate_eqn[0]} EEDF [{Eth}] ({src_file})\n"
    elif type == 3:
        src_file = f"{R}_{P}.txt"
        RXN_temp = f"{rate_eqn[0]} EEDF [{Eth}] ({src_file})\n"
        if SE_col == 1:
            src_file = f"{P}_{R}.txt"
            RXN_temp += f"{rate_eqn[1]} EEDF [-{Eth}] ({src_file})\n"

    # Append reaction to main script
    F3_RXN += RXN_temp

    # Append ground state reactions to mesh generator
    if len(R) <= 2:
        F2_RXN += RXN_temp

    # Create shooting method inputs for metastable reactions - Reactant 1
    if (len(R) > 2 and R[-2:] != "_I") or (len(P) > 2 and P[-2:] != "_I"):
        
        # Create SM input
        [F3_RXN_SM_temp,F3_2_31_temp] = get_2BSM_Reduced(type,R,P,1,SE_col)

        # Update SM reactions
        F3_SM_RXN += F3_RXN_SM_temp
        F3_2_31 += F3_2_31_temp

# Add constant rate reactions
Constant_RXNS = pd.read_excel(os.path.join('Model_Inputs',f'{model_name}_key.xlsx'),
               sheet_name='Constant_Reduced', engine='openpyxl', header=0)

# Loop over inputs
for n, row in Constant_RXNS.iterrows():

    # Extract RXN parameters
    type = row.iloc[0]
    src_indx = row.iloc[1]
    R1 = row.iloc[2]
    R2 = row.iloc[3]
    rate = row.iloc[4]

    # Get reaction equation
    rate_eqn = get_2BRXN_Reduced(type,R1,R2,1,0)

    # Construct temporary input
    RXN_temp = f"{rate_eqn[0]} {rate}\n"

    # Append reaction to main script
    F3_RXN += RXN_temp

    # Create shooting method inputs if 
    if (len(R1) > 2 and R1[-2:] != "_I") or (len(R2) > 2 and R2[-2:] != "_I"):
        
        # Create SM input
        [F3_RXN_SM_temp,F3_2_31_temp] = get_2BSM_Reduced(type,R1,R2,2,0)

        # Update SM reactions
        F3_SM_RXN += F3_RXN_SM_temp
        F3_2_31 += F3_2_31_temp


# Construct the reaction blocks
F2_Reactions = f"[Reactions]\n\tspecies = 'em'\n\taux_species = '{RXN_species_aux}'\n\treaction_coefficient_format = ''\n\tgas_species = '{RXN_gas_species}'\n\telectron_density = 'em'\n\telectron_energy = 'mean'\n\tinclude_electrons = true\n\tfile_location = 'ReactionRates/Reduced'\n\tuse_log = true\n\tuse_ad = true\n\tposition_units = '${{dom0Scale}}'\n\tblock = 0\n\treactions = '{F2_RXN[:-2]}'\n[]\n"
F3_Reactions = f"[Reactions]\n\tspecies = '{RXN_species}'\n\taux_species = '{RXN_species_aux}'\n\treaction_coefficient_format = ''\n\tgas_species = '{RXN_gas_species}'\n\telectron_density = 'em'\n\telectron_energy = 'mean'\n\tinclude_electrons = true\n\tfile_location = 'ReactionRates/Reduced'\n\tuse_log = true\n\tuse_ad = true\n\tposition_units = '${{dom0Scale}}'\n\tblock = 0\n\treactions = '{F3_RXN[:-2]}'\n[]\n"

# Construct controllers
F3_2_30 = F3_2_30 + "'\n"
F3_2_31 = F3_2_31[:-9] + "'\n"
F3_2_32 = F3_2_32[:-9] + "'\n"
F3_SM_RXN = F3_SM_RXN[:-1] + "\n"

#################################################################################
# Update files - reduced model
#################################################################################

# Set variables to loop over and insert
F1_vars = ['F1_2_1', 'F1_2_2', 'F1_2_3', 'F1_2_4', 'F1_2_5', 'F1_2_6', 
           'F1_2_7', 'F1_2_8', 'F1_2_9', 'F1_2_10', 'F1_2_11', 'F1_2_12', 
           'F1_2_13']
F2_vars = ['F2_1_1', 'F2_1_2', 'F2_1_3','F2_Reactions']
F3_vars = ['F3_1_1', 'F3_1_2', 'F3_1_3','F3_2_1', 'F3_2_2', 'F3_2_3', 'F3_2_4',
           'F3_2_5', 'F3_2_6', 'F3_2_7', 'F3_2_8', 'F3_2_9', 'F3_2_10', 'F3_2_11', 
           'F3_2_12', 'F3_2_13', 'F3_2_14', 'F3_2_15', 'F3_2_16', 'F3_2_17', 
           'F3_2_18', 'F3_2_19', 'F3_2_20', 'F3_2_21', 'F3_2_22', 'F3_2_23', 
           'F3_2_24', 'F3_2_25', 'F3_2_26', 'F3_2_27', 'F3_2_28', 'F3_2_29', 
           'F3_2_30', 'F3_2_31', 'F3_2_32', 'F3_Reactions', 'F3_SM_RXN']

# Preset variables
var1_indices = {}
var2_indices = {}
var3_indices = {}

# Search for each variable in F1_source
for i, line in enumerate(f1_source):
    for var in F1_vars:
        if var in line and var not in var1_indices:
            var1_indices[var] = i
            f1_mod[i] = f"{eval(var)}"

# Search for each variable in F2_source
for i, line in enumerate(f2_source):
    for var in F2_vars:
        if var in line and var not in var2_indices:
            var2_indices[var] = i
            f2_mod[i] = f"{eval(var)}"

# Search for each variable in F3_source
for i, line in enumerate(f3_source):
    for var in F3_vars:
        if f'({var})' in line and var not in var3_indices:
            var3_indices[var] = i
            f3_mod[i] = f"{eval(var)}"


#################################################################################
# Full model scripts
#################################################################################

# Read species names from data key
Species_key = pd.read_excel(os.path.join('Model_Inputs',f'{model_name}_key.xlsx'), 
                            sheet_name='Species_Full', engine='openpyxl', header=0)

# Read in source files
with open(os.path.join('Microwave_Model','SHINX_CRM_SRC.i'),"r") as file:
    f4_source = file.readlines()
f4_mod = f4_source

# Update fixed simulation params
f4_mod[3] = f'T_gas = {T_gas}\n'

# Initialize variables
j = 0
k = 0

# Initialize reactions
RXN_gas_species = ""
RXN_species_aux = ""
RXN_species = ""

# Initialize moose blocks
F4_1_1 = ""
F4_1_2 = ""
F4_2_1 = ""
F4_2_2 = ""
F4_2_3 = ""
F4_3_1 = ""
F4_3_2 = ""

# Loop over species key
for n, row in Species_key.iterrows():

    # Add ground states (Files: 2 3)
    if row.iloc[1] == 1:
        
        # Extract species name
        species = row.iloc[0]
        
        # Extract species concentration
        species_base = species[:-3]
        index = Gas_mixture.index(species_base)
        conc = Mixture_proportions[index]

        # Update file 4
        F4_1_1 += f"\t[{species}_aux]\n\t\tblock = Plasma\n\t[]\n"
        F4_1_2 += f"\t[{species}_aux]\n\t\ttype = FunctionAux\n\t\tvariable = {species}_aux\n\t\tfunction = '{conc} * log({{Nbg}}/6.022e23)'\n\t\texecute_on = INITIAL\n\t\tblock = Plasma\n\t[]\n"

        # Save components for reactions block
        RXN_species_aux += f" {species}"
        RXN_gas_species += f" {species}"

        # Update tracking
        j += 1

    elif row.iloc[1] == 2:

        # Extract species name
        species = row.iloc[0]
        
        # Update file 4
        F4_2_1 += f"\t[{species}]\n\t\tblock = Plasma\n\t\tinitial_condition = -20.0\n\t[]\n"
        F4_2_2 += f"\t[n_{species}]\n\t\tblock = Plasma\n\t[]\n"
        F4_2_3 += f"\t[n_{species}]\n\t\ttype = ParsedAux\n\t\tvariable = n_{species}\n\t\tcoupled_variables = {species}\n\t\texpression = 'exp({species}) * 6.022e23'\n\t\tblock = Plasma\n\t[]\n"

        # Add species to reaction block
        RXN_species += f" {species}"

        # Update tracking
        k += 1

    # Add linebreaks to help with formating
    if j % 5 == 0:
        RXN_species_aux += f"\n\t\t\t\t"
        RXN_gas_species += f"\n\t\t\t\t"
    if k % 5  == 0:
        RXN_species += f"\n\t\t\t\t"

# Read in photon reactions
Constant_RXNS = pd.read_excel(os.path.join('Model_Inputs',f'{model_name}_key.xlsx'),
               sheet_name='Decay', engine='openpyxl', header=0)

# Loop over EEDF reactions
for n, row in EEDF_RXNS.iterrows():

    # Extract components
    I = row.iloc[1]
    a = row.iloc[3]
    lam = row.iloc[4]

    # Write in blocks
    F4_3_1 = f"\t[L_{lam}]\n\t\tblock = Plasma\n\t[]\n"
    F4_3_2 = f"\t[n_L_{lam}]\n\t\ttype = ParsedAux\n\t\tvariable = L_{lam}\n\t\tcoupled_variables = n_{I}\n\t\texpression = '(6.626e-34 * 3e8 / {lam}e-9) * {a} * n_{I}'\n\t\tblock = Plasma\n\t[]\n"

#################################################################################
# Build reaction network - reduced model
#################################################################################

# Reaction types
# 1 - Elastic collision
# 2 - Ionization
# 3 - Excitation
# 4 - Pooling
# 5 - 2B Quenching

# Function to write reaction
def get_2BRXN_Full(type,I1,I2,n,SE):

    # Elastic
    if type == 1:
        string = f"em + {I1} -> em + {I2} : "
    # Ionization
    elif type == 2:
        string = f"em + {I1} -> em + em + {I2} : "
    # Excitation/De-excitation
    elif type == 3:
        string = f"em + {I1} -> em + {I2} : "
        if SE == 1:
            rev_string = f"em + {I2} -> em + {I1} : "
    # Pooling
    elif type == 4:
        base = I1[:-3]
        string = f"{I1} + {I2} -> {base}000 + {base}00I + em : "
    # Quenching
    elif type == 5:
        base = I1[:-3]
        string = f"{I1} + {I2} -> {I2} + {base}00I + em : "

    # Format start of string
    if n == 0:
        result = [f"{string}"]
    elif SE == 1:
        result = [f"\t\t {string}", f"\t\t {rev_string}"]
    else:
        result = [f"\t\t {string}"]        

    # Return string
    return result

# Construct reactions block
EEDF_RXNS = pd.read_excel(os.path.join('Model_Inputs',f'{model_name}_key.xlsx'),
               sheet_name='EEDF_Full', engine='openpyxl', header=0)

# Initialize variables
F4_RXN = ""

# Loop over EEDF reactions
for n, row in EEDF_RXNS.iterrows():

    # Extract RXN parameters
    type = row.iloc[0]
    src_indx = row.iloc[1]
    R = row.iloc[2]
    P = row.iloc[3]
    Eth = row.iloc[4]
    SE_col = row.iloc[6]

    # Construct rate equation
    rate_eqn = get_2BRXN_Full(type,R,P,n,SE_col)

    # Construct temporary input
    if type == 1:
        src_file = f"{R}_Elastic.txt"
        RXN_temp = f"{rate_eqn[0]} EEDF ({src_file})\n"
    elif type == 2:
        src_file = f"{R}_Ionization.txt"
        RXN_temp = f"{rate_eqn[0]} EEDF [{Eth}] ({src_file})\n"
    elif type == 3:
        src_file = f"{R}_{P}.txt"
        RXN_temp = f"{rate_eqn[0]} EEDF [{Eth}] ({src_file})\n"
        if SE_col == 1:
            src_file = f"{P}_{R}.txt"
            RXN_temp += f"{rate_eqn[1]} EEDF [-{Eth}] ({src_file})\n"

    # Append reaction to main script
    F4_RXN += RXN_temp

# Add constant rate reactions
Constant_RXNS = pd.read_excel(os.path.join('Model_Inputs',f'{model_name}_key.xlsx'),
               sheet_name='Constant_Full', engine='openpyxl', header=0)

# Loop over inputs
for n, row in Constant_RXNS.iterrows():

    # Extract RXN parameters
    type = row.iloc[0]
    src_indx = row.iloc[1]
    R1 = row.iloc[2]
    R2 = row.iloc[3]
    rate = row.iloc[4]

    # Get reaction equation
    rate_eqn = get_2BRXN_Full(type,R1,R2,1,0)

    # Construct temporary input
    RXN_temp = f"{rate_eqn[0]} {rate}\n"

    # Append reaction to main script
    F4_RXN += RXN_temp

# Construct the reaction blocks
F4_Reactions = f"[Reactions]\n\tspecies = '{RXN_species}'\n\taux_species = '{RXN_species_aux}'\n\treaction_coefficient_format = 'rate'\n\tgas_species = '{RXN_gas_species}'\n\telectron_density = 'em'\n\telectron_energy = 'mean'\n\tinclude_electrons = true\n\tfile_location = 'ReactionRates/CRM'\n\tuse_log = true\n\tuse_ad = true\n\tposition_units = 1.0\n\tblock = 0\n\treactions = '{F3_RXN[:-2]}'\n[]"

#################################################################################
# Update files - Full model
#################################################################################

# Set variables to loop over and insert
F4_vars = ['F4_1_1', 'F4_1_2', 'F4_2_1', 'F4_2_2', 'F4_2_3', 'F4_3_1', 
           'F4_3_2','F4_Reactions']

# Preset variables
var4_indices = {}

# Search for each variable in F1_source
for i, line in enumerate(f4_source):
    for var in F4_vars:
        if var in line and var not in var4_indices:
            var4_indices[var] = i
            f4_mod[i] = f"{eval(var)}"

#################################################################################
# Write files
#################################################################################

# Copy main script files
Target_directory = os.path.join(os.getcwd(),'Spectral_Libraries',model_name)
with open(os.path.join(Target_directory,'SHINX_Chemistry_Solver.i'), "w") as f1_target:
    f1_target.write(''.join(f1_mod))
with open(os.path.join(Target_directory,'SHINX_Mesh_Generator.i'), "w") as f2_target:
    f2_target.write(''.join(f2_mod))
with open(os.path.join(Target_directory,'SHINX_Microwave_Model.i'), "w") as f3_target:
    f3_target.write(''.join(f3_mod))
with open(os.path.join(Target_directory,'SHINX_CRM.i'), "w") as f4_target:
    f4_target.write(''.join(f4_mod))

# Copy RR Tree
shutil.copytree(os.path.join('Microwave_Model','Model_Tree'), Target_directory,dirs_exist_ok=True)
with open(os.path.join(Target_directory,'ReactionRates','BolsigCompiler.py'), "w") as fb_target:
    fb_target.write(''.join(fb_mod))

# Execute Bolsig
subprocess.run(["python", os.path.join(Target_directory,'ReactionRates','BolsigCompiler.py')])
