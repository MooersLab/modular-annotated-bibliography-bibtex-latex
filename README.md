![Version](https://img.shields.io/static/v1?label=modular-annotated-bibliography-bibtex-latex&message=0.1&color=brightcolor)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


# Template for making an enhanced annotated and illustrated bibliography with BibTeX in LaTeX

## What is this? Annotated bibliography on steroids
An annotated bibliography summarizes notes about papers being read during a research project.
It is one of several methods for working with the knowledge gleaned from reading.

![Screenshot 2024-10-24 at 1 40 36 PM](https://github.com/user-attachments/assets/edfd7bd6-85db-40e9-9ad0-53ceb1dc3173)



This modular form enables the reuse of entries in annotated bibliographies for related projects.
It has the following enhanced features that the classic annotated bibliography lacks:

- No longer restrained by the annote field in BibTeX which removes whitespaces including blank lines between paragraphs.
- Modular entries for easy reuse in related projects.
- Images.
- Tables.
- Equations.
- Code blocks.
- Hyperlinks: internal and external.
- Bibliographic entries can be reordered for subgrouping by category. 
- Table of contents, hyperlinked to sections
- Index of terms.
- Bibliography includes papers cited outside those listed in the annotated bibliography.
- List of acronyms used.
- List of glossary terms used.
- List of mathematical notation.

![Screenshot 2024-10-24 at 1 41 09 PM](https://github.com/user-attachments/assets/c1fa04fa-7e62-407a-85f3-628f22defc06)


## Why LaTeX

It is the gold standard for typesetting scientific documents.
This template can be used on Overleaf.
It can also be used collaboratively online in Overleaf.


## Drag-N-Drop install instructions for Overleaf.com

This is the fastest way to explore the features of this template.
The files in *overleaf-drag-n-drop.zip* have been configured for running on Overleaf.

1. Download the zip file: Modular-Annotated-Bibliography-BibTeX-Overleaf.zip.
2. Upload this zip file into a new project on Overleaf.

The file mabib0573.tex will compile automatically to a PDF. 
The compile job should be free of warnings.
The index and glossaries should be populated.



## Local installation instructions

### One-time directory creation

The modular bibliographic notes are stored in folders at the top level in the home directory.
The global.bib file is stored in `~/Documents`.
Adjust the location and run the following:

```bash
mkdir ~/glossaries
mkdir ~/bibNotes
mkdir ~/imagesBlaine # Rename 
````

### Bash Function to generate subfolder with required files

Edit the file paths as needed.
Takes a project ID as the only argument.

Run from the top level of your writing project directory.
Upon reuse, delete the `cp -R` commands to avoid overwriting existing files.


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
cp -R ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/glossaries/glossary.tex ~/glossaries/.
cp -R ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/bibNotes ~/glossary/.
cp -R ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/notation.tex ~/glossary/.
cp -R ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/bibNotes/* ~/bibNotes/.
cp -R ~/6112MooersLabGitHubLabRepos/modular-annotated-bibliography-latex/imagesBlaine/* ~/imagesBlaine/.
}
```

### Installation

1. `git clone` this project to your software directory
2. Copy the bash function and paste into your `.bashrc` or `.zshrc` file.
3. `source .bashrc` or `.zshrc`
4. cd project directory
3. `mabibtex <projectID>` to create subfolder for the annotated bibliography files.


## Use
1. Create one tex file per reference in the `bibNotes` folder.
    - Use the supplied examples as templates.
    - Use the citekey from BibLaTeX as the name of the bibNote file.
    - Use a blank line between paragraphs.
    - Note that text-wrapping figures is easier than text-wrapping tables.
    - Skip text-wrapping if it is too tedious.
    - As you work, add
      - figures
      - tables
      - equations
      - URLs (including links to videos)
      - citekeys to references in and out of the annotated bibliography
      - index macros
      - acronyms
      - glossary terms
      - math notation 
3. Use the citekey as the argument of the `\bibentry` macro inside a new subsection heading. This will inject the bibliography entry upon export to PDF.
4. You can cluster citations by topic and subtopic by using the section and subsection macros. You can lower the heading level to the subsubsection level for the bibliographic entry if you need the subsection heading for subgroups.
5. The colored boxes indicate hyperlinks. Comment out the hypperref package in the preamble to disable.
6. The `\glsaddall` command is used to print out the entire contents of a glossary file rather than only the entries that are used in the bibNote files.
7. Compile to HTML to enjoy the output in your web browser.
8. Compile to PDF to print and edit while traveling or otherwise away from the computer.
9. Compiles locally with the full installation of texlive.
10. Compiles in `Textmate.app` with the `Option-R` command.


## Status: 
Ready to use and enjoy on Overleaf. Works without warnings when using pdflatex, version 2024.

Running locally may require troubleshooting your LaTeX setup or your text editor's configuration for LaTeX.

## Coming soon

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

