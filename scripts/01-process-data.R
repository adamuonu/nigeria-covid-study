#   ***********************************************************************************************
#   File name:  process-data-NGA-10130.R
#
#               The data sets for the different sites have varying number of variables.
#
#   Project:    Clinical profile and predictors of outcomes of hospitalized patients with laboratory
#               confirmed severe acute respiratory syndrome coronavirus 2 in Nigeria: A retrospective
#               analysis of the 13 high burden states
#
#   Date:       2021-08-12
#   Version:    2.0
#   Author:     Dr. A. Onu (PhD)
#
#   ***********************************************************************************************

rm(list = ls())

source('scripts/00-as_factor.R')

# raw.datasets <-
#     list.files(path = 'data/raw',
#                all.files = FALSE,
#                full.names = TRUE)

source_files <-
    list.files(path = 'scripts/processing',
               all.files = FALSE,
               full.names = TRUE)

# set counter
counter <- 1
len     <- length(source_files)


while (counter <= len) {
    source(source_files[counter])
    cat(paste('Processed', counter, 'file(s)...... \n'))
    counter <- counter+1
}

