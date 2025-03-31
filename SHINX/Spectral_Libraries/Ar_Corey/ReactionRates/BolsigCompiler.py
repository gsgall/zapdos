import pandas as pd 
import subprocess
import os
import re

########################################################################
# Set BOLSIG run parameters
########################################################################

# Read collsions
Species = 'Ar'
Extrapolate = 1

# Run conditions
Electric_field = 10
Angular_field_frequency = 0
Cosine_ExB = 0
T_gas = 300
T_excitation = 300.
Energy_transition = 0
Ionization_degree = 0
Gas_density = 3.295e22
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
Gas_composition = 1
Normalize_composition = 1

# Energy sweep settings
Variable = 2
min = 0
max = 10
number = 5
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
# Construct BOLSIG input decks
########################################################################

# Read in source data
Bolsig_key = pd.read_excel('Data_Key.xlsx', sheet_name='Bolsig', engine='openpyxl', header=0)
Rate_key = pd.read_excel('Data_Key.xlsx', sheet_name='Rate', engine='openpyxl', header=0)
current_directory = os.getcwd()

# Prepare BOLSIG readcollisions block
readcollisions_block = f'''{Species}\n{Extrapolate}'''

# Prepare BOLSIG conditions block
conditions_block = f'''\nCONDITIONS\n{Electric_field}\n{Angular_field_frequency}\n{Cosine_ExB}\n{T_gas}
{T_excitation}\n{Energy_transition}\n{Ionization_degree}\n{Gas_density}\n{Ion_charge_parameter}\n{Ion_neutral_mass_ratio}
{e_e_momentum_effects}\n{Energy_sharing}\n{Growth}\n{Maxwell_mean_energy}\n{Grid_number}\n{Manual_grid}\n{Maximum_energy}\n{Precision}
{Convergence}\n{Max_iteration}\n{Gas_composition}\n{Normalize_composition}\n'''

# Prepare BOLSIG runseries block
runseries_block = f'''RUNSERIES\n{Variable}\n{min}\n{max}\n{number}\n{type}\n'''

# Prepare BOLSIG saveresults block
saveresults_block = f'''{Format}\n{Conditions}\n{Transport_coefficients}\n{Rate_coefficients}
{Reverse_rate_coefficients}\n{Energy_loss_coefficients}\n{Distribution_function}\n{Skip_failed}
{Include_CS}\n'''

########################################################################
# Calculate rate coefficients for each reaction
########################################################################

# Run and save BOLSIG data for each reaction
for n, row in Bolsig_key.iterrows():

    # Extract collision type
    rxn_key = row.iloc[0]
    if rxn_key == 1:
        source_file = f'SourceFiles\\{row.iloc[2]}_Elastic.txt'
        target_file = f'Elastic{row.iloc[1]}.txt'
    elif rxn_key == 2:
        source_file = f'SourceFiles\\{row.iloc[2]}_Ionization.txt'
        target_file = f'Ionization{row.iloc[1]}.txt'
    elif rxn_key == 3:
        source_file = f'SourceFiles\\{row.iloc[2]}_{row.iloc[3]}.txt'
        target_file = f'Excitation{row.iloc[1]}.txt'
    elif rxn_key == 4:
        source_file = f'SourceFiles\\{row.iloc[2]}_{row.iloc[3]}.txt'
        target_file = f'De-excitation{row.iloc[1]}.txt'

    # Write bolsigminus input file
    prompt = f'''READCOLLISIONS\n{source_file}\n{readcollisions_block}\n{conditions_block}\n{runseries_block}\nSAVERESULTS\nTemp_Output.txt\n{saveresults_block}'''
    with open("BOLSIG_Input.txt", "w") as file:
        file.write(prompt)

    # Run BOLSIG 
    subprocess.run([f"./bolsigminus.exe", f"BOLSIG_Input.txt"],
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, stdin=subprocess.DEVNULL)
    print(f'{target_file} Run Complete!')

    # Format and save BOLSIG file
    with open('Temp_Output.txt','r') as file:
        responce = file.read()
    split_data = re.findall(r'([\d.Ee+-]+)\s+([\d.Ee+-]+)', '\n'.join(responce.splitlines()[9:]))
    energy = [float(m[0]) for m in split_data]
    rate_coeff = [float(m[1]) for m in split_data]
    if rxn_key != 4:
        indx = len(split_data)//2
    else:
        indx = len(split_data)
    with open(target_file,'w') as file:
        for p, q in zip(energy[0:indx],rate_coeff[0:indx]):
            file.write(f"{p:.6e}\t{q:.6e}\n")

    # Delete variables to re-initiate loop
    del split_data, energy, rate_coeff
    os.remove('Temp_Output.txt')
    os.remove('BOLSIG_Input.txt')
    os.remove('bolsiglog.txt')
    
