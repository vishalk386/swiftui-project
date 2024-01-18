#!/bin/sh

#  file_reduce.py
#  TestImage-Shinkman
#
#  Created by Vishal Kamble on 26/09/23.
#  


import sys
import subprocess
from docx2txt import process
from pptx import Presentation

def reduce_docx_file_size(input_file, output_file):
    process(input_file, output_file)

def reduce_pptx_file_size(input_file, output_file):
    prs = Presentation(input_file)
    # Implement logic to reduce slide content here
    prs.save(output_file)

if __name__ == "__main__":
    action = sys.argv[1]
    input_file = sys.argv[2]
    output_file = sys.argv[3]

    if action == "reduce_docx":
        reduce_docx_file_size(input_file, output_file)
    elif action == "reduce_pptx":
        reduce_pptx_file_size(input_file, output_file)
