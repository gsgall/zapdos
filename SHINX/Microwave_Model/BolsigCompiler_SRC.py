import pandas as pd 
import subprocess
import os
import re
import numpy as np

# Runs bolsig minus - Integrated into main network compiler. Do not run.

########################################################################
# Set BOLSIG run parameters 
########################################################################

# Set system parameters
model_name = 'Ar'
N_gas = 3.295e22
T_bg = 300
Na = 6.022e23

# Add aux species for multiple gas chemistries
enable_aux_species = 0
aux_species = [""]
aux_concentration = np.array([1])

# Extract model location
bolsig_loc = os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates')

########################################################################
# Set BOLSIG run parameters
########################################################################

# Read collsions
Extrapolate = 1

# Run conditions
Electric_field = 10
Angular_field_frequency = 0
Cosine_ExB = 0
T_gas = T_bg
T_excitation = T_bg
Energy_transition = 0
Ionization_degree = 0
Gas_density = N_gas
Ion_charge_parameter = 1
Ion_neutral_mass_ratio = 1
e_e_momentum_effects = 3
Energy_sharing = 1
Growth = 1
Maxwell_mean_energy = 0
Grid_number = 400
Manual_grid = 0
Maximum_energy = 1000
Precision = 1e-10
Convergence = 1e-4
Max_iteration = 2000
Normalize_composition = 1

# Energy sweep settings
Variable = 2
min_reduced = 0
min_full = 0.04
max_reduced = 138
max_full = 20
number = 600
type = 1

# Save settings
Format = 5
Conditions = 0
Transport_coefficients = 0
Rate_coefficients = 1
Reverse_rate_coefficients = 0
Energy_loss_coefficients = 0
Distribution_function = 0
Skip_failed = 0
Include_CS = 0

########################################################################
# Modify parameters for mixed gas mixture
########################################################################

# Check multi-gas is on
if enable_aux_species == 1:
    trace_conc = 1 - sum(aux_concentration)
else:
    trace_conc = 1

########################################################################
# Run BOLSIG for reduced model
########################################################################

# Read in source data
Species_key = pd.read_excel(os.path.join(os.getcwd(),'Model_Inputs',f'{model_name}_key.xlsx'), sheet_name='Species_Reduced', engine='openpyxl', header=0)
Bolsig_key = pd.read_excel(os.path.join(os.getcwd(),'Model_Inputs',f'{model_name}_key.xlsx'), sheet_name='EEDF_Reduced', engine='openpyxl', header=0)

# Initiate input file text and associated components
Reduced_input_deck = ''
Species = ''
Gas_composition = ''
final_states = []
num_rxns = 0

# Run and save BOLSIG data for each reaction
for n, row in Bolsig_key.iterrows():

    # Check if it is not in EEDF form
    if row.iloc[7] == 1:

        # Extract collision type
        rxn_key = row.iloc[0]
        R1 = row.iloc[2]
        R2 = row.iloc[3]
        aux = row.iloc[4]
        se_col = row.iloc[6]
        num_rxns += 1
        if rxn_key == 1:
            source_file = f'{row.iloc[2]}_Elastic.txt'
            keyword = 'ELASTIC'
            header = f'ELASTIC\n{R1}\n{aux}'
        elif rxn_key == 2:
            source_file = f'{row.iloc[2]}_Ionization.txt'
            keyword = 'IONIZATION'
            header = f'IONIZATION\n{R1}\n{aux}'
        elif rxn_key == 3:
            source_file = f'{row.iloc[2]}_{row.iloc[3]}.txt'
            keyword = 'EXCITATION'
            final_states.append(R2)
            if se_col == 0:
                header = f'EXCITATION\n{R1}\n{aux}'
            else:
                header = f'EXCITATION\n{R1} <-> {R2}\n{aux}'
                num_rxns += 1

        # Append species for tracking
        if R1 not in Species:
            if R1 in aux_species:
                index = aux_species.index(f'{R1}')
                Species = f'{Species} {R1}'
                Gas_composition = f'{Gas_composition} {aux_concentration[index]}'
            else:
                Species = f'{Species} {R1}' if Species else R1
                Gas_composition = f'{Gas_composition} 0' if Gas_composition else f'{trace_conc}'
        if rxn_key == 3 and se_col == 1 and R2 not in Species:
            if R2 in aux_species:
                index = aux_species.index(f'{R2}')
                Species = f'{Species} {R2}'
                Gas_composition = f'{Gas_composition} {aux_concentration[index]}'
            else:
                Species = f'{Species} {R2}' if Species else R2
                Gas_composition = f'{Gas_composition} 0' if Gas_composition else f'{trace_conc}'
    
        # Open 
        with open(os.path.join(os.getcwd(),'Model_Inputs',f'{model_name}_Rates',source_file),"r") as file:
            f_source = file.readlines()
        scanable  = "".join(f_source)
        cs_match = re.search(r"-+\n(.*?)\n-+", scanable, re.DOTALL)
        cs_data = cs_match.group(1)

        # Modify with new file structure
        Reduced_input_deck += f"{header}\n-----------------------------\n{cs_data}\n-----------------------------\n\n\n"

# Write input CS file
with open(os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates','SourceFiles','Reduced_CS_Data.txt'),"w") as file:
    target = file.writelines(''.join(Reduced_input_deck))

# Prepare BOLSIG readcollisions block
readcollisions_block = f'''{Species}\n{Extrapolate}'''

# Prepare BOLSIG conditions block
conditions_block = f'''\nCONDITIONS\n{Electric_field}\n{Angular_field_frequency}\n{Cosine_ExB}\n{T_gas}
{T_excitation}\n{Energy_transition}\n{Ionization_degree}\n{Gas_density}\n{Ion_charge_parameter}\n{Ion_neutral_mass_ratio}
{e_e_momentum_effects}\n{Energy_sharing}\n{Growth}\n{Maxwell_mean_energy}\n{Grid_number}\n{Manual_grid}\n{Maximum_energy}\n{Precision}
{Convergence}\n{Max_iteration}\n{Gas_composition}\n{Normalize_composition}\n'''

# Prepare BOLSIG runseries block
runseries_block = f'''RUNSERIES\n{Variable}\n{min_reduced}\n{max_reduced}\n{number}\n{type}\n'''

# Prepare BOLSIG saveresults block
saveresults_block = f'''{Format}\n{Conditions}\n{Transport_coefficients}\n{Rate_coefficients}
{Reverse_rate_coefficients}\n{Energy_loss_coefficients}\n{Distribution_function}\n{Skip_failed}
{Include_CS}\n'''

# Write bolsigminus input file
bolsig_loc_lin = bolsig_loc.replace('/','\\')
prompt = f'''READCOLLISIONS\n{bolsig_loc_lin}\\SourceFiles\\Reduced_CS_Data.txt\n{readcollisions_block}\n{conditions_block}\n{runseries_block}\nSAVERESULTS\n{bolsig_loc_lin}\\Temp_Output.txt\n{saveresults_block}'''
with open(os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates','SourceFiles','Reduced_BOLSIG_Input.txt'), "w") as file:
    file.writelines(prompt)

# Run BOLSIG
subprocess.run([os.path.join(bolsig_loc,'bolsigminus.exe'), os.path.join(bolsig_loc,'SourceFiles','Reduced_BOLSIG_Input.txt')],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, stdin=subprocess.DEVNULL)
print(f'Reduced Reaction Network Complete!')

# Read temporary output file
with open(os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates','Temp_Output.txt'),"r") as file:
    scanable = file.readlines()

# Loop over number of output rxns
num_excitation = 0
for n in range(1, num_rxns + 1):

    # Find start of data table
    indx = next(i for i, line in enumerate(scanable) if f"C{n}" in line)

    # Pull reaction information
    rxn_components = scanable[indx].strip().split()
    rxn_type = rxn_components[2]
    R1 = rxn_components[1]

    # Extract data table
    raw_data = scanable[indx+2:indx+2+number]
    processed_data = []
    for line in raw_data:
        Energy, Rate_coeff = line.strip().split('\t')
        x_val = float(Energy)
        y_val = float(Rate_coeff)*Na
        processed_data.append((x_val, y_val))

    # Set output file name
    if rxn_type == 'Elastic':
        target_file = f'{R1}_Elastic.txt'
    elif rxn_type == 'Ionization':
        target_file = f'{R1}_Ionization.txt'
    elif rxn_type == 'Excitation':
        R2 = final_states[num_excitation]
        num_excitation += 1
        target_file = f'{R1}_{R2}.txt'
    elif rxn_type == 'De-excitation':
        R2 = prev_R1
        target_file = f'{R1}_{R2}.txt'

    # Save output file
    with open(os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates','ReducedModel',target_file),"w") as file:
        for x, y in processed_data:
            file.write(f"{x}\t{y}\n")

    # Save previous R1 incase of de-excitation
    prev_R1 = R1

# Update terminal and delete temporary files
os.remove(os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates','Temp_Output.txt'))
print('Reduced Model Data Saved!')

########################################################################
# Run BOLSIG for full CRM
########################################################################

# Read in source data
Species_key = pd.read_excel(os.path.join(os.getcwd(),'Model_Inputs',f'{model_name}_key.xlsx'), sheet_name='Species_Full', engine='openpyxl', header=0)
Bolsig_key = pd.read_excel(os.path.join(os.getcwd(),'Model_Inputs',f'{model_name}_key.xlsx'), sheet_name='EEDF_Full', engine='openpyxl', header=0)

# Initiate input file text and associated components
CRM_input_deck = ''
Species = ''
Gas_composition = ''
final_states = []
num_rxns = 0

# Run and save BOLSIG data for each reaction
for n, row in Bolsig_key.iterrows():

    # Check if it is not in EEDF form
    if row.iloc[7] == 1:

        # Extract collision type
        rxn_key = row.iloc[0]
        R1 = row.iloc[2]
        R2 = row.iloc[3]
        aux = row.iloc[4]
        se_col = row.iloc[6]
        num_rxns += 1
        if rxn_key == 1:
            source_file = f'{row.iloc[2]}_Elastic.txt'
            keyword = 'ELASTIC'
            header = f'ELASTIC\n{R1}\n{aux}'
        elif rxn_key == 2:
            source_file = f'{row.iloc[2]}_Ionization.txt'
            keyword = 'IONIZATION'
            header = f'IONIZATION\n{R1}\n{aux}'
        elif rxn_key == 3:
            source_file = f'{row.iloc[2]}_{row.iloc[3]}.txt'
            keyword = 'EXCITATION'
            final_states.append(R2)
            if se_col == 0:
                header = f'EXCITATION\n{R1}\n{aux}'
            else:
                header = f'EXCITATION\n{R1} <-> {R2}\n{aux}'
                num_rxns += 1

        # Append species for tracking
        if R1 not in Species:
            Species = f'{Species} {R1}' if Species else R1
            Gas_composition = f'{Gas_composition} 0' if Gas_composition else '1'
        if rxn_key == 3 and se_col == 1 and R2 not in Species:
            Species = f'{Species} {R2}' if Species else R2
            Gas_composition = f'{Gas_composition} 0' if Gas_composition else '1'
    
        # Open 
        with open(os.path.join(os.getcwd(),'Model_Inputs',f'{model_name}_Rates',source_file),"r") as file:
            f_source = file.readlines()
        scanable  = "".join(f_source)
        cs_match = re.search(r"-+\n(.*?)\n-+", scanable, re.DOTALL)
        cs_data = cs_match.group(1)

        # Modify with new file structure
        CRM_input_deck += f"{header}\n-----------------------------\n{cs_data}\n-----------------------------\n\n\n"

# Write input CS file
with open(os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates','SourceFiles','CRM_CS_Data.txt'),"w") as file:
    target = file.writelines(''.join(CRM_input_deck))

# Prepare BOLSIG readcollisions block
readcollisions_block = f'''{Species}\n{Extrapolate}'''

# Prepare BOLSIG conditions block
conditions_block = f'''\nCONDITIONS\n{Electric_field}\n{Angular_field_frequency}\n{Cosine_ExB}\n{T_gas}
{T_excitation}\n{Energy_transition}\n{Ionization_degree}\n{Gas_density}\n{Ion_charge_parameter}\n{Ion_neutral_mass_ratio}
{e_e_momentum_effects}\n{Energy_sharing}\n{Growth}\n{Maxwell_mean_energy}\n{Grid_number}\n{Manual_grid}\n{Maximum_energy}\n{Precision}
{Convergence}\n{Max_iteration}\n{Gas_composition}\n{Normalize_composition}\n'''

# Prepare BOLSIG runseries block
runseries_block = f'''RUNSERIES\n{Variable}\n{min_full}\n{max_full}\n{number}\n{type}\n'''

# Prepare BOLSIG saveresults block
saveresults_block = f'''{Format}\n{Conditions}\n{Transport_coefficients}\n{Rate_coefficients}
{Reverse_rate_coefficients}\n{Energy_loss_coefficients}\n{Distribution_function}\n{Skip_failed}
{Include_CS}\n'''

# Write bolsigminus input file
bolsig_loc_lin = bolsig_loc.replace('/','\\')
prompt = f'''READCOLLISIONS\n{bolsig_loc_lin}\\SourceFiles\\CRM_CS_Data.txt\n{readcollisions_block}\n{conditions_block}\n{runseries_block}\nSAVERESULTS\n{bolsig_loc_lin}\\Temp_Output.txt\n{saveresults_block}'''
with open(os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates','SourceFiles','CRM_BOLSIG_Input.txt'), "w") as file:
    file.writelines(prompt)

# Run BOLSIG
subprocess.run([os.path.join(bolsig_loc,'bolsigminus.exe'), os.path.join(bolsig_loc,'SourceFiles','CRM_BOLSIG_Input.txt')],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, stdin=subprocess.DEVNULL)
print(f'Full Reaction Network Complete!')

# Read temporary output file
with open(os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates','Temp_Output.txt'),"r") as file:
    scanable = file.readlines()

# Loop over number of output rxns
num_excitation = 0
for n in range(1, num_rxns + 1):

    # Find start of data table
    indx = next(i for i, line in enumerate(scanable) if f"C{n}" in line)

    # Pull reaction information
    rxn_components = scanable[indx].strip().split()
    rxn_type = rxn_components[2]
    R1 = rxn_components[1]

    # Extract data table
    raw_data = scanable[indx+2:indx+2+number]
    processed_data = []
    for line in raw_data:
        Energy, Rate_coeff = line.strip().split('\t')
        x_val = float(Energy)
        y_val = float(Rate_coeff)*Na
        processed_data.append((x_val, y_val))

    # Set output file name
    if rxn_type == 'Elastic':
        target_file = f'{R1}_Elastic.txt'
    elif rxn_type == 'Ionization':
        target_file = f'{R1}_Ionization.txt'
    elif rxn_type == 'Excitation':
        R2 = final_states[num_excitation]
        num_excitation += 1
        target_file = f'{R1}_{R2}.txt'
    elif rxn_type == 'De-excitation':
        R2 = prev_R1
        target_file = f'{R1}_{R2}.txt'

    # Save output file
    with open(os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates','CRM',target_file),"w") as file:
        for x, y in processed_data:
            file.write(f"{x}\t{y}\n")

    # Save previous R1 incase of de-excitation
    prev_R1 = R1

# Update terminal and delete temporary files
os.remove(os.path.join(os.getcwd(),'Spectral_Libraries',model_name,'ReactionRates','Temp_Output.txt'))
print('Full CRM Data Saved!')