import os
import datetime
import copy
import mooseutils
import numpy as np
import astropy.units as u
import shutil

# Set original directory
code_source = "Spectral_Libraries/Ar_Corey"

# Set pressure values (mTorr/W)
Pressure = np.array([400])*u.mTorr
Power = np.array([125])*u.W

# Set auto-run settings (default to 1)
run_sim = 0

#################################################################################
#                           NO EDITS BELOW THIS POINT                           #
#################################################################################

#################################################################################
# DEFINE VALUES FOR RUNNING PRESSURE-POWER SWEEP
#################################################################################

# Fetch script names
file1 = "SHINX_Mesh_Generator.i"
file2 = "SHINX_Chemistry_Solver.i"
file3 = "SHINX_EM_Solver.i"
file4 = "SHINX_Microwave_Model.i"
file5 = "SHINX_CRM.i"

# Create output settings
timestamp = datetime.datetime.now().strftime("%m-%d_%H-%M")
target_directory = f"{code_source}/ParameterSweeps/{timestamp}"
os.makedirs(target_directory,exist_ok = True)

# Open source files
with open(os.path.join(code_source,file1),"r") as file:
    f1_source = file.readlines()
with open(os.path.join(code_source,file2),"r") as file:
    f2_source = file.readlines()
with open(os.path.join(code_source,file3),"r") as file:
    f3_source = file.readlines()
with open(os.path.join(code_source,file4),"r") as file:
    f4_source = file.readlines()
with open(os.path.join(code_source,file5),"r") as file:
    f5_source = file.readlines()

# Calculate secondary values
P = Pressure.to(u.Pa)
mu_ion = 0.144409938 / Pressure.to(u.Torr)
D_ion = 6.428571e-3 / Pressure.to(u.Torr)
Nbg = 3.22e22 * Pressure.to(u.Torr)

#################################################################################
# CREATE INPUT DECK
#################################################################################

# Loop over pressure and power values
for m in range(len(Power)):
    for n in range(len(Pressure)):

        # Create modified files
        file1_target = f"{file1.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.i"
        file2_target = f"{file2.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.i"
        file3_target = f"{file3.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.i"
        file4_target = f"{file4.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.i"
        file5_target = f"{file5.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.i"
        
        # Update mesh generator values
        f1_modified = f1_source[:]
        f1_modified[9] = f"P_gas = {P.value[n]:.3e}\n"
        f1_modified[10] = f"Power = {Power.value[m]:.3e}\n"
        f1_modified[11] = f"Nbg = {Nbg.value[n]:.3e}\n"
        f1_modified[12] = f"mu_ion = {mu_ion.value[n]:.3e}\n"
        f1_modified[13] = f"D_ion = {D_ion.value[n]:.3e}\n"
        f1_modified[14] = f"Target_File = '{file3_target}'\n"       

        # Update chemistry solver values
        f2_modified = f2_source[:]
        f2_modified[11] = f"P_gas = {P.value[n]:.3e}\n"

        # Update EM solver values
        f3_modified = f3_source[:]
        f3_modified[7] = f"P_gas = {P.value[n]:.3e}\n"
              
        # Update main script values
        f4_modified = f4_source[:]
        f4_modified[8] = f"P_gas = {P.value[n]:.3e}\n"
        f4_modified[9] = f"Power = {Power.value[m]:.3e}\n"
        f4_modified[10] = f"Nbg = {Nbg.value[n]:.3e}\n"
        f4_modified[11] = f"mu_ion = {mu_ion.value[n]:.3e}\n"
        f4_modified[12] = f"D_ion = {D_ion.value[n]:.3e}\n"
        f4_modified[13] = f"Source_File = '{file1_target.replace('.i','')}_exo_out.e'\n"
        f4_modified[14] = f"Target_File = '{file3_target}'\n"
        f4_modified[15] = f"Target_File = '{file2_target}'\n"

        # Update CRM script with modified values
        f5_modified = f5_source[:]
        f5_modified[7] = f"P_gas = {P.value[n]:.3e}\n"
        f5_modified[8] = f"Target_File = 'CRM_SS_{Pressure}mTorr_{Power}W'"
        f5_modified[9] = f"Source_File = '{file4_target.replace('i','')}_EM_Heating0.e'\n"

        # Save modified files
        with open(os.path.join(target_directory,file1_target),"w") as file:
            file.write(''.join(f1_modified))
        with open(os.path.join(target_directory,file2_target),"w") as file:
            file.write(''.join(f2_modified))
        with open(os.path.join(target_directory,file3_target),"w") as file:
            file.write(''.join(f3_modified))
        with open(os.path.join(target_directory,file4_target),"w") as file:
            file.write(''.join(f4_modified))
        with open(os.path.join(target_directory,file5_target),"w") as file:
            file.write(''.join(f5_modified))

#################################################################################
# RUN PRESSURE-POWER SWEEP
#################################################################################

# Move to simulation environment
if run_sim == 1:
    os.chdir(code_source)
    target_directory = f"ParameterSweeps/{timestamp}"


# Compute initial distribution
if run_sim == 1:
    for m in range(len(Power)):
        for n in range(len(Pressure)):
    
            # Create command prompt
            input_file = [f"{target_directory}/{file1.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.i"]
            cli_args = ['-i'] + input_file
            a = copy.copy(cli_args)

            # Run mesh generator
            executable = mooseutils.find_moose_executable_recursive(os.getcwd())
            out  = mooseutils.run_executable(executable,*a, mpi=14, suppress_output=False)

            # Save output data
            data = np.genfromtxt(f"{target_directory}/Data/IC/{file1.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.csv",skip_header=1,delimiter=',')

# Run transient
if run_sim == 1:
    for m in range(len(Power)):
        for n in range(len(Pressure)):
    
            # Create command prompt
            input_file = [f"{target_directory}/{file4.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.i"]
            cli_args = ['-i'] + input_file
            a = copy.copy(cli_args)

            # Run mesh generator
            executable = mooseutils.find_moose_executable_recursive(os.getcwd())
            out  = mooseutils.run_executable(executable,*a, mpi=14, suppress_output=False)

            # Save output data
            data = np.genfromtxt(f"{target_directory}/Data/Transient/{file4.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.csv",skip_header=1,delimiter=',')

# Run CRM
if run_sim == 1:
    for m in range(len(Power)):
        for n in range(len(Pressure)):
    
            # Create command prompt
            input_file = [f"{target_directory}/{file5.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.i"]
            cli_args = ['-i'] + input_file
            a = copy.copy(cli_args)

            # Run mesh generator
            executable = mooseutils.find_moose_executable_recursive(os.getcwd())
            out  = mooseutils.run_executable(executable,*a, mpi=14, suppress_output=False)

            # Save output data
            data = np.genfromtxt(f"{target_directory}/Data/CRM/{file5.replace('.i','')}_{Pressure.value[n]:.0f}_mTorr_{Power.value[m]:.0f}_W.csv",skip_header=1,delimiter=',')

# Exit simulation environment
os.chdir("../../")