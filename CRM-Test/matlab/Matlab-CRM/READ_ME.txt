Hello Grayson, the senior design team, or a mysterious third option.

The files in this folder helps one create the Zapdos/CRANE Input file and rate reaction
output files for an argon CRM. I personal ran everything on Feb. 27, 2025 and the Matlab
files worked, but who knows what the future holds. Below are description of each file
in this folder. If anyone has any question, please contact me at corey.dechant1@gmail.com

- excitation_rate/ - directory to hold the energy dependent reaction rate files 
                     created by "rate_track.mat"

- BSR-Argon.txt - The cross section data of argon need for BOLSIG+ runs

- crane_input.m - Creates a Zapdos/CRANE input file using a CRM approach

- Formating_And_LightEmission.xlsx - An Excel sheet reformating NIST data.
				     The first sheet is imported NIST data...
                                     The second sheet is addition state infromation...
                                     The third sheet is a reformatted lookup based 
                                     on sheets 1 & 2, and is needed for the Matlab scripts.

- Nist.txt - Data download from NIST

- output.dat - BOLSIG+ output data from a previous run (energies from 0.04-20eV)

- rate_track.m - Creates the energy dependent reaction rate files needed 
                 by Zapdos/CRANE

- READ_ME.txt - This->file()