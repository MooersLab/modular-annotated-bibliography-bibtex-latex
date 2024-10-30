import os
import sys

"""
Purpose: read a list of citekeys as strings from the file "papersAboutCoding.tex", 
reformat for use in main.tex, and write them to "citations.tex".
The approach supports customizing the order of the entries in the annotated bibliography.
This list of citekeys can be ordered by categories instead of alphabetical order.

The script is run from the command line and takes two arguments: 
the filename of the list of citekeys and the output filename.

This script contains two functions that are called from the if __main__ section below.
The first function format_citations() takes a list of strings from an itemized list in LaTeX and 
formats each string to enable the inclusion of the associated bibliographic entry in the subsection heading 
and the bibNote in the annotation below.

This script includes error handling to check if the file papersAboutCoding.tex exists. 
If the file is not found, it prints an error message and proceeds with an empty list of strings.
This script includes the create_bib_notes_file function, 
which creates a new file in the ./bibNotes (or ~/bibNotes) directory, 
if it does not already exist.

This script takes the input and output filenames as command line arguments. 
Run it from the command line like this:

python script.py papersAboutCoding.tex citations.tex

Blaine Mooers, PhD
Department of Biochemistry and Physiology
College of Medicine
University of Oklahoma Health Sciences Center
Oklahoma City, OK

2024 October 29
"""

def format_citations(strings):
    """Assume that the citekeys (the strings) are in an itemized list without the flanking begin and end statements. 
    The leading \\item and whitespace are stripped when the strings are read from the file to .
    
    The written subsection heading will be unnumbered to reduce clutter.
    Because the subsection is unnumbered, it is ignored for inclusion in the table of contents by default.
    We have to add it via the addconents macro on the line below the headline.
    The corresponding annotation file is imported from the bibNotes folder in the third line.
    """
    formatted_strings = []
    for s in strings:
        ss = s.lstrip("\\item ")
        formatted_string = f'\\subsection*{{\\bibentry{{{ss}}}}}\n\\addcontentsline{{toc}}{{subsection}}{{{ss}}}\n\\input{{{ss}.tex}}\n\n'
        formatted_strings.append(formatted_string)
    return formatted_strings

def create_bib_notes_file(string):
    """Writes out the bibNotes to the bibNotes folder. 
    This folder could a subfolder or a global folder. 
    If the latter, replace the '.' with a '~'. 
    This function will create a bibNotes folder if it does not exist.
    It will not overwrite existing bibNotes with the same citekey."""
    
    directory = "./bibNotes"
    if not os.path.exists(directory):
        os.makedirs(directory)
    
    file_path = os.path.join(directory, f"{string}.tex")
    if not os.path.exists(file_path):
        with open(file_path, 'w') as file:
            file.write(f'%{string}.tex\n\n')


# *********************** __main__ **************************
if __name__ == "__main__":

    # Check if the correct number of command line arguments are provided
    if len(sys.argv) != 3:
        print("The input filename is a list citekeys as LaTeX \\items ")
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
        ss = s.lstrip("\\item ")
        create_bib_notes_file(ss)
    
    print(f"Formatted citations have been written to {output_filename} and bib notes files have been created in ./bibNotes directory if they did not already exist.")
