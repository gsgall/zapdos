import mooseutils
import os
import subprocess as sp
from send_msg import send_txt

import asyncio
import re
from email.message import EmailMessage
from typing import Collection, List, Tuple, Union

import aiosmtplib

def run_gas_mix(percent_helium):

  input_file = "./mixing_fluid_air_helium.i"
  mpi=16
  executeable="../zapdos-opt"
  supress_output = False

  with open( input_file, 'r' ) as f:
    input = f.read()

  start_str = "="
  start_idx = input.find(start_str)
  end_str = "\n"
  end_idx = input.find(end_str)

  top_str = input[:start_idx + 1]
  bottom_str = input[end_idx:]

  newinput = top_str + f" {(percent_helium/100):0.4f}" + bottom_str
  with open(input_file, 'w') as f:
    f.write(newinput)

  a = ["-i", input_file]
  new_file_base = f"exodus_files/{(100 - percent_helium):d}_{(percent_helium):d}_air_helium"
  new_exodus_file = new_file_base + ".e"
  print(new_exodus_file)


  mooseutils.run_executable(executeable, *a, mpi=mpi, suppress_output=supress_output)

  os.rename(input_file[:-2] + "_out.e", new_exodus_file)

_num = "9198961197"
_carrier = "at&t"
_email = "moosenotification@gmail.com"
_pword = "usfqdcxafnvwluux"

helium_mixes = [10, 20, 30, 40, 50]

for percent in helium_mixes:

  _subj = "Fluid Mixing Simulation Completed!"
  _msg = f"Helium = {percent:d}%\nAir = {(100 - percent):d}%"
  run_gas_mix(percent)
  # # print(_m/g)
  coro = send_txt(_num, _carrier, _email, _pword, _msg, _subj)
  asyncio.run(coro)

