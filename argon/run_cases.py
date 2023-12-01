import mooseutils
import os
import subprocess as sp
from send_msg import send_txt

import asyncio
import re
from email.message import EmailMessage
from typing import Collection, List, Tuple, Union

import aiosmtplib


def run_power(power):
    input_file = "./argon_regulation.i"
    mpi = 16
    executeable = "../zapdos-opt"
    supress_output = False

    a = [
        "-i",
        input_file,
        f"Outputs/out/file_base={power:0.4f}W_out",
        f"Outputs/csv_out/file_base={power:0.4f}W_out",
        f"Postprocessors/voltage/reference_value={power:0.4f}",
    ]

    mooseutils.run_executable(executeable, *a, mpi=mpi, suppress_output=supress_output)


_num = "9198961197"
_carrier = "at&t"
_email = "moosenotification@gmail.com"
_pword = "usfqdcxafnvwluux"

# powers = [0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4]
powers = [0.1]

for power in powers:
    _subj = "Power Regulation Simulation Complete!"
    _msg = f"Power = {power:0.2f} [W]\n"
    run_power(power)
    coro = send_txt(_num, _carrier, _email, _pword, _msg, _subj)
    asyncio.run(coro)
