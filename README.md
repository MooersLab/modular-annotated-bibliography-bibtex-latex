![Version](https://img.shields.io/static/v1?label=modular-annotated-bibliography-bibtex-latex&message=0.1&color=brightcolor)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


# Template for making an enhanced annotated and illustrated bibliography with BibTeX in LaTeX

## What is this? Annotated bibliography on steroids
An annotated bibliography summarizes notes about papers being read during a research project.
It is one of several methods for working with the knowledge gleaned from reading.

![Screenshot 2024-10-24 at 1 40 36 PM](https://github.com/user-attachments/assets/edfd7bd6-85db-40e9-9ad0-53ceb1dc3173)



This modular form enables the reuse of entries in annotated bibliographies for related projects.
It has the following enhanced features that the classic annotated bibliography lacks:

- No longer restrained by the annote field in BibTeX.
- Modular entries for easy reuse in related projects
- Images
- Tables
- Equations
- Code blocks
- Hyperlinks: internal and external
- Bibliographic entries can be reordered for subgrouping by category. 
- Table of contents, hyperlinked to sections
- Index of terms
- Bibliography includes papers cited outside of those listed in the annotated bibliography.
- List of acronyms used
- List of glossary terms used
- List of mathematical notation

![Screenshot 2024-10-24 at 1 41 09 PM](https://github.com/user-attachments/assets/c1fa04fa-7e62-407a-85f3-628f22defc06)


## Why LaTeX

It is the gold standard for typesetting scientific documents.
This template can be used on Overleaf.
It can also be used collaboratively online in Overleaf.


## PDF of Annotated Bibliography
When exported to a PDF, the org file reads the BibTeX file with formatting set by the *apacannx.bst* file. 
The top of the output PDF looks like the following:


## One time directory creation

The modular bibliographic notes are stored in folders at the top level in the home directory.
The global.bib file is stored in `~/Documents`.
Adjust the location and 

```bash
mkdir ~/gloasaries
mkdir ~/bibNotes
mkdir ~/imagesBlaine
````

## Bash Function to generate subfolder with required files

Edit the file paths as needed.
Takes a project ID as the only argument.

Run from the top level of your writing project directory.


```bash
function mabibtex {
echo "Create a modular annotated bibliography subfolder and populate with required files with project number in the title."
if [ $# -lt 1 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo "Usage1: mabibtex projectIndexNumber"
  return 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "$0: too many projectIndexNumber"
  echo "Usage1: mabibtex projectIndexNumber"
  return 2
fi
projectID="$1"
mkdir mabib$1
cp ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/compile.sh ./mabib$1/.
cp ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/apacannx.bst ./mabib$1/.
cp ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/mab0519.bib ./mabib$1/mab$1.bib
cp ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/mab0519.tex ./mabib$1/mab$1.tex
cp -R ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/glossaries/glossary.tex ~/gloasaries/.
cp -R ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/bibNotes ~/gloasary/.
cp -R ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/notation.tex ~/gloasary/.
cp -R ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/bibNotes/* ~/bibNotes/.
cp -R ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/imagesBlaine/* ~/imagesBlaine/.
}
```


## Installation

1. git clone this project to your software directory
2. Copy one of the bash function and paste into your .bashr or .zshrc file.
3. source .bashrc
4. cd project directory
3. mabibtex <projectID> to create subfolder 


## Status: 
Ready to use and enjoy!

## Coming soon

- Variant for biblatex.
- Variants for org-mde.
- Variants for typst.

## Sources of funding

- NIH: R01 CA242845
- NIH: R01 AI088011
- NIH: P30 CA225520 (PI: R. Mannel)
- NIH: P20 GM103640 and P30 GM145423 (PI: A. West)

## Update history

| Version           |  Changes                                                                                                            | Date                      |
|:------------------|:--------------------------------------------------------------------------------------------------------------------|:--------------------------| 
| 0.1               | Initial commit.                                                                                                     | 2024  October 24          |

