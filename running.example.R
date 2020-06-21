library(tidyverse)
library(openxlsx)
library(jsonlite)

setwd("path/to/the/source/functions")

source("fvtt-exports.R")

export.journal("H:/RPG/FoundryVTT/swade-es/journal.xlsx")
export.compendium("H:/RPG/FoundryVTT/swade-es/compendium.xlsx")
