# Function to export to journals and compendiums

## Overview

This program helps you creating journal and compendium entries for the spanish translation of Savage Worlds module for FoundryVTT.

## Requirements

* R language, a statistical and graphics program; you can download and install from www.r-project.org
* FoundryVTT
** Savage Worlds Adventure Edition gamesystem: https://gitlab.com/florad-foundry/swade
** Savage Worlds Adventure Edition Spanish module: https://gitlab.com/jvir/foundryvtt-swade-es/
** Babele module: https://gitlab.com/riccisi/foundryvtt-babele
* The zip file of this repository, decompress to any directory.
* An excel file containing the indexes to export journals or compendiums.

## Notes on installation

### How to install required R packages:

```
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(openxlsx)) install.packages("openxlsx")
if(!require(jsonlite)) install.packages("jsonlite")
```

## Compendium exporter

Requires an excel file (see _compendium-example.xlsx_ for an example) with:

One sheet called _index_ with the following columns:

* file: filename of the compendium json.
* label: name of the compendium.
* book: name of the pdf to point to.
* class: leave it as _swade-book fas fa-book_.
* page-offset: offset between real pages and logical pages in the pdf.

One sheet for each json defined in the index sheet.

* id: id of the item in the original compendium.
* name: translation.
* page-start: first page of the pdf to extract.
* page-end: last page of the pdf to extract.

How to use it:

```
library(tidyverse)
library(openxlsx)
library(jsonlite)

setwd("path/to/the/source/functions")
source("fvtt-exports.R")

export.compendium("compendium-example.xlsx")
```

Once the files are created, move to _FoundryVTT/Data/modules/swade-es/compendium_

## Journal exporter

Requires an excel file (see _journal-example.xlsx_ for an example) with:

One sheet called _index_ with the following columns:

* file: filename of the journal txt.
* label: name of the journal (not used currently).
* book: name of the pdf to point to.
* class: leave it as _swade-book_.
* page-offset: offset between real pages and logical pages in the pdf.

One sheet for each txt defined in the index sheet.

* level: level of indent, 1st level, 2nd level, to create bullet lists.
* name: Text of the entry.
* pages: Pages to point to, the format is: comma separated numbers plus hyphen separated values for ranges, for example: 2, 3, 5-10 -> pages 2, 3 and from 5 to 10.

How to use it:

```
library(tidyverse)
library(openxlsx)
library(jsonlite)

setwd("path/to/the/source/functions")
source("fvtt-exports.R")

export.journal("journal-example.xlsx")

```

Once the files are created, open a world in Foundry, go to journal, create a new journal for each text file created, edit each entry, go to source code and paste the contents of the corresponding text file.
