import os
import sys

"""
Purpose: read the strings from the file "paperAboutCoding.md" and write them in a useful format to "citations.typ

This script defines a function format_citations() that takes a list of strings and formats each string according to your specified format. 
This script includes error handling to check if the file paperAboutCoding.md exists. 
If the file is not found, it prints an error message and proceeds with an empty list of strings.
This script includes the create_bib_notes_file function, which ensures that a new file is created in the ./bibNotes directory 
if it does not already exist, with the specified content on the first line.

This script takes the input and output filenames as command line arguments. 
You can run it from the command line like this:

python script.py paperAboutCoding.md citations.typ
"""

def format_citations(strings):
    "Assumes that the strings are in a markdown list. The leading dash and whitespace are stripped."
    formatted_strings = []
    for s in strings:
        ss = s.lstrip("\item ")
        formatted_string = f'=== #cite(label("{ss}"), form: "full")\n#include "./bibNotes/{ss}.typ"\n\n'
        formatted_strings.append(formatted_string)
    return formatted_strings

def create_bib_notes_file(string):
    directory = "./bibNotes"
    if not os.path.exists(directory):
        os.makedirs(directory)
    
    file_path = os.path.join(directory, f"{string}.typ")
    if not os.path.exists(file_path):
        with open(file_path, 'w') as file:
            file.write("#include \"../template.typ\": *\n\n")

# Check if the correct number of command line arguments are provided
if len(sys.argv) != 3:
    print("The input filename needs a list of \\items ")
    print("Usage: python script.py <input_filename> <output_filename>")
    sys.exit(1)

input_filename = sys.argv[1]
output_filename = sys.argv[2]

# Read the strings from the input file
try:
    with open(input_filename, 'r') as file:
        strings = file.read().splitlines()
except FileNotFoundError:
    print(f"The file '{input_filename}' was not found.")
    sys.exit(1)

# Format the strings
formatted = format_citations(strings)

# Write the formatted strings to the output file
with open(output_filename, 'w') as file:
    for f in formatted:
        file.write(f + '\n\n')

# Create bib notes files if they do not exist
for s in strings:
    ss = s.lstrip("- ")
    create_bib_notes_file(ss)

print(f"Formatted citations have been written to {output_filename} and bib notes files have been created in ./bibNotes directory if they did not already exist.")
