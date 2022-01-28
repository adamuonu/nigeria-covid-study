rm(list = ls())

suppressPackageStartupMessages(library (tidyverse))
suppressPackageStartupMessages(library (haven))

# list data sets in the processed data folder

study.datasets <-
    list.files(path = 'data/processed',
               all.files = FALSE,
               full.names = TRUE)

# get variable names

(load(file = 'data/varnames.rdata'))

# generate object names
tmp.data <- paste0('t_', 1:length(study.datasets))

# make sure the variable names are in the same order
ordered.var.names <- sort(study.vars)

# read in the data and assign to objects

for (i in 1:length(study.datasets)) {
    f = study.datasets[i]
    x <- readRDS(file = f)
    x <- x[, ordered.var.names]
    assign(tmp.data[i], x)
    rm(x)
}

source(file = 'scripts/site-names.R')

# combine data sets

# numbers were stored as text in some of the data sets
# transform to number or the merge will fail
t_8$adm09_1_E1_C1 <- as.numeric(t_8$adm09_1_E1_C1)
t_5$adm09_1_E1_C1 <- as.numeric(t_5$adm09_1_E1_C1)
t_6$adm18_1_E1_C1 <- as.numeric(t_6$adm18_1_E1_C1)
t_6$adm18_1_E1_C1[t_6$adm18_1_E1_C1 == 9] <- 90
t_4$dis39s1_E3_C5 <- as.numeric(t_4$dis39s1_E3_C5)
#
t_4$adm12s_E1_C1 <- as.numeric(substr(t_4$adm12s_E1_C1, 1, 2))
t_14$adm12s_E1_C1[t_14$adm12s_E1_C1 == '7 months &  2weeks'] <- '30'
t_14$adm12s_E1_C1 <- as.numeric(t_14$adm12s_E1_C1)
t_18$adm17_E1_C1 <- as.numeric(t_18$adm17_E1_C1)
t_20$adm104__E1_C1 <- as.numeric(t_20$adm104__E1_C1)
t_20$adm108__E1_C1 <- as.numeric(t_20$adm108__E1_C1)
t_21$adm14_E1_C1 <- NA

nga.data <-
    bind_rows(
        t_1,
        t_2,
        t_3,
        t_4,
        t_5,
        t_6,
        t_7,
        t_8,
        t_9,
        t_10,
        t_11,
        t_12,
        t_13,
        t_14,
        t_15,
        t_16,
        t_17,
        t_18,
        t_19,
        t_20,
        t_21,
        t_22,
        t_23,
        t_24,
        t_25,
        t_26
    )

# apply human-readable labels to the variables

source(file = 'scripts/label-variables.R')

attr(nga.data, 'description') <-
    'WHO Novel Coronavirus (nCoV) Database - Nigeria. Clinical profile and predictors of outcomes of hospitalized patients with laboratory-confirmed severe acute respiratory syndrome coronavirus 2 in Nigeria'

# export to data formats for further cleaning and analysis

saveRDS(object = nga.data, file = 'data/merged/nga_covid.rds')
write_sav(data = nga.data, path = 'data/merged/nga_covid.sav')
write_dta(data = nga.data,
          path = 'data/merged/nga_covid.dta',
          version = 14)

rm(list = ls())
