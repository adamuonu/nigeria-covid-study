#'   ==========================================================================
#'   scripts/03-recode.R
#'
#'   @description Clean, recode, prep, and export the data for analysis
#'   @author:     A. Onu
#'   @date:       2021-09-27
#'   @version:    1.0
#'   ==========================================================================

rm(list = ls())

#  Load libraries  ------------------------------------------------------------

suppressPackageStartupMessages(library (tidyverse))
suppressPackageStartupMessages(library (haven))
suppressPackageStartupMessages(library (ggplot2))
suppressPackageStartupMessages(library (ggpubr))
suppressPackageStartupMessages(library (sjPlot))
suppressPackageStartupMessages(library (sjstats))

#  Load data ------------------------------------------------------------------

nga_covid <- readRDS(file = 'data/merged/nga_covid.rds')

#  Define the primary outcome  ------------------------------------------------

summary(nga_covid$dis46_E3_C5)

#  Drop missing outcomes  -----------------------------------------------------

dta <- nga_covid[!is.na(nga_covid$dis46_E3_C5),]

# dta <- nga_covid

#  Primary outcome  -----------------------------------------------------------
#
#  The primary outcome was mortality.  This was defined as death while on
#  admission for a PCR confirmed infection with SARS-COV-2 virus. This was coded
#  as 0 if the patient survives, or 1 if the patient dies.

dta <- dta %>% mutate(
    mortality = case_when(dis46_E3_C5 == 'Death' ~ 1, TRUE ~ 0)
)

table(dta$mortality, useNA = 'i')

#  Time in study - enrollment date to outcome date ----------------------------

summary(dta$adm01_E1_C1) # enrollment date
summary(dta$dis47_E3_C5) # outcome date

# Query implausible dates

# dta$sno <- 1:nrow(dta)

# future dates shouldn't exist
# x <- subset(dta, (dta$adm01_E1_C1 > as.Date('2021-09-19') | dta$dis47_E3_C5 > as.Date('2021-09-19')))
# View(x[,c('sno','adm01_E1_C1', 'adm13_E1_C1', 'adm14_E1_C1','dis47_E3_C5')])

# impute values ...
# dta$adm01_E1_C1[dta$sno ==  563] <- as.Date('2020-12-20')
# dta$adm01_E1_C1[dta$sno == 1321] <- as.Date('2020-10-13')
# dta$dis47_E3_C5[dta$sno == 1321] <- as.Date('2020-10-20')
# dta$dis47_E3_C5[dta$sno ==  790] <- as.Date('2021-02-11')
# dta$dis47_E3_C5[dta$sno == 1385] <- as.Date('2020-12-30')

# censor implausible dates seen
dta$adm01_E1_C1[dta$adm01_E1_C1 > as.Date('2021-09-19')] <- NA
dta$dis47_E3_C5[dta$dis47_E3_C5 > as.Date('2021-09-19')] <- NA

dta$adm01_E1_C1[dta$adm01_E1_C1 < as.Date('2020-01-01')] <- NA
dta$dis47_E3_C5[dta$dis47_E3_C5 < as.Date('2020-01-01')] <- NA

summary(dta$adm01_E1_C1) # enrollment data
summary(dta$dis47_E3_C5) # outcome date

#x <- subset(dta, (dta$adm01_E1_C1 < as.Date('2020-01-01') | dta$dis47_E3_C5 < as.Date('2020-01-01')))
#View(x[,c('sno','adm01_E1_C1', 'adm13_E1_C1', 'adm14_E1_C1','dis47_E3_C5')])

# impute values for earlier dates ...
# dta$adm01_E1_C1[dta$sno ==  565] <- as.Date('2020-12-24')
# dta$adm01_E1_C1[dta$sno ==  818] <- as.Date('2020-10-05')
# dta$dis47_E3_C5[dta$sno == 1092] <- as.Date('2020-06-14')
# dta$dis47_E3_C5[dta$sno == 1495] <- as.Date('2020-07-30')
# dta$dis47_E3_C5[dta$sno == 2926] <- as.Date('2021-02-25')

# ... from further on following calculation of illness duration
# dta$adm13_E1_C1[dta$sno == 187]  <- as.Date('2021-02-01')
# dta$adm13_E1_C1[dta$sno == 276]  <- as.Date('2021-01-17')
# dta$adm13_E1_C1[dta$sno == 602]  <- as.Date('2021-05-21')
# dta$adm13_E1_C1[dta$sno == 721]  <- as.Date('2021-01-04')
# dta$adm13_E1_C1[dta$sno == 1142] <- as.Date('2021-06-16')
# dta$adm13_E1_C1[dta$sno == 1529] <- as.Date('2021-01-29')


# which outcome dates are earlier than enrollment date
# x <- dta[which(dta$dis47_E3_C5 < dta$adm01_E1_C1),]
# y <- x[,c('sno', 'adm01_E1_C1', 'adm13_E1_C1', 'adm14_E1_C1', 'dis47_E3_C5', 'admsit_E1_C1')]

# View(y)
# There are 686 records where the enrollment date is later than the outcome date
# Most of these errors are from Amachara Isolation Center (241) and Bingham (248)
# Examining the data shows admission dates of 2020 for most with enrollment of 2021
# We can reasonably replace the enrollment dates with the admission dates but...

# dta$dis47_E3_C5[dta$dis47_E3_C5 < dta$adm01_E1_C1] <- NA

dta <- dta %>% mutate(
    enrol_date = if_else(!is.na(dis47_E3_C5) & (adm01_E1_C1 > dis47_E3_C5), adm14_E1_C1, adm01_E1_C1)
)

# ... again
# x <- dta[which(dta$dis47_E3_C5 < dta$enrol_date),]
# y <- x[,c('sno', 'enrol_date', 'adm01_E1_C1','adm13_E1_C1', 'adm14_E1_C1', 'dis47_E3_C5',
#           'admsit_E1_C1')]

# View(y)
# Down to 80 now
# most look like data entry errors with the dates flipped or typo errors
# so ... calculate the duration of illness

dta <- dta %>% mutate(
    study_time = as.numeric( difftime(dis47_E3_C5, enrol_date, units = 'days') )
)

summary(dta$study_time)

# ... and correct the negative values arising from the flipped dates
dta <- dta %>% mutate(
    study_time = ifelse(
        study_time < 0,
        as.numeric( difftime(enrol_date, dis47_E3_C5, units = 'days') ),
        study_time
    )
)
# examine outliers
# we still have some strange values: max exceeds 1 year!
# I think > 12 weeks is a reasonable upper bound

summary(dta$study_time)
dta$study_time[dta$study_time > 84] <- 84

#  Severity of disease  -------------------------------------------------------

#'   This is a composite consisting of any or all of:
#'       a. need for admission in the ICU
#'       b.	use of invasive ventilation
#'       c.	requiring a ≥60% fraction of inspired oxygen (FiO2) to maintain
#'          SaO2 >94%
#'       d.	any use of ventilator to maintain work of breathing
#'
#'  ===========================================================================

## ICU/HDU admission

table(dta$adm83_E1_C1, useNA = 'i')
table(dta$dis38_E3_C5, useNA = 'i')
dta <- dta %>% mutate(icu = case_when((adm83_E1_C1 == 'Yes' |
                                         dis38_E3_C5 == 'Yes') ~ 1, TRUE ~ 0))

## Invasive ventilation

table(dta$adm87_E1_C1, useNA = 'i')
table(dta$dis41_E3_C5, useNA = 'i')
dta <- dta %>% mutate(ivent = case_when((adm87_E1_C1 == 'Yes' |
                                             dis41_E3_C5 == 'Yes') ~ 1, TRUE ~ 0))

## Non-invasive ventilation

table(dta$adm85_E1_C1, useNA = 'i')
table(dta$dis40_E3_C5, useNA = 'i')
dta <- dta %>% mutate(nvent = case_when((adm85_E1_C1 == 'Yes' |
                                             dis40_E3_C5 == 'Yes') ~ 1, TRUE ~ 0))

## Oxygen therapy

table(dta$adm84_E1_C1, useNA = 'i')
table(dta$dis39_E3_C5, useNA = 'i')
dta <- dta %>% mutate(o2 = case_when((adm84_E1_C1 == 'Yes' |
                                          dis39_E3_C5 == 'Yes') ~ 1, TRUE ~ 0))

## Calculate disease severity score

dta <- dta %>% mutate(severity = icu + ivent + nvent + o2)

table(dta$severity, useNA = 'i')

# Study site

dta$admsit_E1_C1 <- str_to_title(dta$admsit_E1_C1)
dta$admsit_E1_C1 <- str_replace(dta$admsit_E1_C1, 'Fct', 'FCT')
#table(dta$admsit_E1_C1)
dta$site <- factor(dta$admsit_E1_C1)

# Facility State

dta$state <- factor(dta$state)
#table(dta$state)

#  Demographics  --------------------------------------------------------------

## Age

dta <- dta %>%
    mutate(
        age = case_when(
            is.na(adm09_1_E1_C1) ~
                round(as.numeric(difftime(adm14_E1_C1, adm08_E1_C1, units = 'day') / 365.25), 0),
            TRUE ~ adm09_1_E1_C1)
        )

## deal with values > 120

dta <- dta %>% mutate(age = case_when(age > 120 ~ age / 10, TRUE ~ age))

#brks <- c(0, 24, 34, 44, 54, 64, 100)
#level_labs <- c('0-24','25-34','35-44','45-54','55-64','≥ 65')
#brks <- c(0, 19, 29, 39, 49, 59, 69, 79, 100)
#level_labs <- c('0-19','20-29','30-39','40-49','50-59','60-69','70-79','≥80')

brks <- c(0, 17, 45, 65, 75, 100)
level_labs <- c('<18', '18-45', '46-65', '66-75', '>75')

dta$age_group <- cut(x = dta$age, breaks = brks, include.lowest = T, labels = level_labs)

## Sex

dta$sex <- factor(dta$adm07_E1_C1)

## Healthcare worker

dta <- dta %>% mutate(health_worker = case_when(adm10_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

#  Co-morbidity  ------------------------------------------------------------

## Chronic cardiac disease (not hypertension)

dta <- dta %>% mutate(ccdx = case_when(adm27_E1_C1 == 'Yes' ~ 1, TRUE ~ 0) )

## Diabetes

dta <- dta %>% mutate(diabetes = case_when(adm28_E1_C1 == 'Yes'~ 1, TRUE ~ 0))

## Hypertension

dta <- dta %>% mutate(hypertension = case_when(adm29_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Current smoking

dta <- dta %>% mutate(smoking = case_when(adm30_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Chronic pulmonary disease

dta <- dta %>% mutate(pulmonary_dx = case_when(adm31_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Active tuberculosis

dta <- dta %>% mutate(tb_active = case_when(adm32_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Previous tuberculosis

dta <- dta %>% mutate(tb_previous = case_when(adm32a_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Asthma

dta <- dta %>% mutate(asthma = case_when(adm33_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Respiratory disease (Defined as presence of any of chronic pulmonary disease,
## active or previous tuberculosis, and asthma)

dta <- dta %>%
    mutate(respiratory_dx = pulmonary_dx + tb_active + tb_previous + asthma) %>%
    mutate(respiratory_dx = case_when(respiratory_dx > 0 ~ 1, TRUE ~ 0))

## Asplenia

dta <- dta %>% mutate(asplenia = case_when(adm34_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Chronic kidney disease

dta <- dta %>% mutate(ckd = case_when(adm35_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Malignant neoplasm

dta <- dta %>% mutate(neoplasm = case_when(adm36_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Chronic liver disease

dta <- dta %>% mutate(chronic_liver_dx = case_when(adm37_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Chronic neurologic disorder

dta <- dta %>% mutate(neurologic_dx = case_when(adm39_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## HIV

dta <- dta %>% mutate(
        hiv = case_when(
        grepl('Yes', adm40_E1_C1) ~ 1,
        dis10_E3_C5 == 11 ~ 1,
        TRUE ~ 0)
)

#  Symptoms  ------------------------------------------------------------------
#   Calculate a symptom score? COVID symptom score?

## History of fever

dta <- dta %>% mutate( fever = case_when(adm45_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Chest in-drawing

dta <- dta %>% mutate( chest_indrawing = case_when(adm46_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Cough

dta <- dta %>% mutate( cough = case_when(adm47_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Headache

dta <- dta %>% mutate( headache = case_when(adm48_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Altered consciousness / confusion

dta <- dta %>% mutate( confusion = case_when(adm49_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Seizures

dta <- dta %>% mutate( seizures = case_when(adm50_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Sore throat

dta <- dta %>% mutate( sore_throat = case_when(adm51_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Abdominal pain

dta <- dta %>% mutate( abd_pain = case_when(adm52_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Runny nose

dta <- dta %>% mutate( runny_nose = case_when(adm53_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Vomiting

dta <- dta %>% mutate( vomiting = case_when(adm54_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Wheezing

dta <- dta %>% mutate( wheezing = case_when(adm55_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Diarrhoea

dta <- dta %>% mutate( diarrhoea = case_when(adm56_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Chest pain

dta <- dta %>% mutate( chest_pain = case_when(adm57_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Conjunctivitis

dta <- dta %>% mutate( conjunctivitis = case_when(adm58_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Muscle aches

dta <- dta %>% mutate( muscle_aches = case_when(adm59_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Skin rash

dta <- dta %>% mutate( skin_rash = case_when(adm60_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Joint pain

dta <- dta %>% mutate( joint_pain = case_when(adm61_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Skin ulcers

dta <- dta %>% mutate( skin_ulcers = case_when(adm62_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Fatigue / malaise

dta <- dta %>% mutate( fatigue = case_when(adm63_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Lymphadenopathy

dta <- dta %>% mutate( lymphadenopathy = case_when(adm64_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Loss of taste

dta <- dta %>% mutate( taste = case_when(adm65_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Inability to walk

dta <- dta %>% mutate( inability_walk = case_when(adm66_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Loss of smell

dta <- dta %>% mutate( smell = case_when(adm67_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Bleeding

dta <- dta %>% mutate( bleeding = case_when(adm68_E1_C1 == 'Yes' ~ 1, TRUE ~ 0))

## Shortness of breath

dta <- dta %>% mutate( breath = case_when(adm69_E1_C1 == 'Yes' ~ 1, TRUE~ 0))

## Ischaemic stroke / intracerebral bleeding

dta <- dta %>% mutate(
    stroke = case_when((adm69a_E1_C1 == 'Yes' | dta$adm69b_E1_C1 == 'Yes') ~ 1, TRUE ~ 0)
)

table(dta$stroke, useNA = 'i')

#  SPO2  ----------------------------------------------------------------------

dta$adm21_E1_C1[dta$adm21_E1_C1 > 100] <- 100
dta$spo2 <- dta$adm21_E1_C1


#  Time to admission from onset of illness  -----------------------------------

# summary(dta$adm13_E1_C1)
#
# dta$t_to_admission <- as.numeric(difftime(dta$adm14_E1_C1, dta$adm13_E1_C1,
# units = 'days'))
# dta$t_to_admission[dta$t_to_admission < 0] <- NA
# summary(dta$t_to_admission)

# dta$t_to_admission[dta$t_to_admission < 0] <- NA

#  Duration on admission   ----------------------------------------------------

summary(dta$adm14_E1_C1)

# x <- subset(dta, dta$adm14_E1_C1 > as.Date('2021-09-19'))
# View(x[,c('sno','adm01_E1_C1', 'adm13_E1_C1', 'adm14_E1_C1','dis47_E3_C5')])

# dta$adm14_E1_C1[dta$sno == 563] <- as.Date('2020-12-30')
# dta$adm14_E1_C1[dta$sno == 1271] <- as.Date('2020-09-30')
# dta$adm14_E1_C1[dta$sno == 1278] <- as.Date('2020-09-23')
# dta$adm14_E1_C1[dta$sno == 1323] <- as.Date('2020-10-05')
# dta$adm14_E1_C1[dta$sno == 1327] <- as.Date('2020-10-12')
# dta$adm14_E1_C1[dta$sno == 1379] <- as.Date('2020-12-20')
# dta$adm14_E1_C1[dta$sno == 1383] <- as.Date('2020-12-20')
# dta$adm14_E1_C1[dta$sno == 1388] <- as.Date('2020-12-31')
# dta$adm14_E1_C1[dta$sno == 1421] <- as.Date('2020-07-08')
# dta$adm14_E1_C1[dta$sno == 1638] <- as.Date('2020-12-01')
#
# dta$adm14_E1_C1[dta$adm14_E1_C1 > as.Date('2021-09-19')] <- NA
#
# x <- subset(dta, dta$adm14_E1_C1 < as.Date('2020-01-01'))
# View(x[,c('sno','adm01_E1_C1', 'adm13_E1_C1', 'adm14_E1_C1','dis47_E3_C5')])
#
# dta$adm14_E1_C1[dta$sno == 1435] <- as.Date('2020-07-15')
# dta$adm14_E1_C1[dta$sno == 2956] <- as.Date('2020-04-12')
# dta$adm14_E1_C1[dta$sno == 3060] <- as.Date('2021-02-18')

dta$adm14_E1_C1[dta$adm14_E1_C1 < as.Date('2020-01-01')] <- NA
dta$adm14_E1_C1[dta$adm14_E1_C1 > as.Date('2021-09-19')] <- NA
dta$dis47_E3_C5[dta$dis47_E3_C5 < dta$adm14_E1_C1] <- NA

summary(dta$adm14_E1_C1)

dta <-
    dta %>% mutate(admission_time = as.numeric( difftime(dis47_E3_C5, adm14_E1_C1, units = 'days')))

summary(dta$admission_time)

dta$admission_time[dta$admission_time >= 84 ] <- 84

#  Malaria  -------------------------------------------------------------------

dta <- dta %>% mutate(malaria = case_when((dis08_E3_C5 == 11 | dis09_E3_C5 == 11) ~ 1, TRUE ~ 0))

#  Complications  -------------------------------------------------------------

## Shock

dta <- dta %>% mutate(shock = case_when(dis11_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Bacteremia

dta <- dta %>% mutate(bacteremia = case_when(dis12_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Seizures

dta <- dta %>% mutate(seizures_c = case_when(dis13_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Bleeding

dta <- dta %>% mutate(bleeding_c = case_when(dis14_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Meningitis/Encephalitis

dta <- dta %>% mutate(meningitis = case_when(dis15_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Endocarditis

dta <- dta %>% mutate(endocarditis = case_when(dis16_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Anaemia

dta <- dta %>% mutate(anaemia = case_when(dis17_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Myocarditis/Pericarditis

dta <- dta %>% mutate(myocarditis = case_when(dis18_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Cardiac arrhythmia

dta <- dta %>% mutate(arrhythmia = case_when(dis19_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Acute renal injury

dta <- dta %>% mutate(aki = case_when(dis20_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Cardiac arrest

dta <- dta %>% mutate(arrest = case_when(dis21_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Pancreatitis

dta <- dta %>% mutate(pancreatitis = case_when(dis22_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Pneumonia

dta <- dta %>% mutate(pneumonia = case_when(dis23_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Liver dysfunction

dta <- dta %>% mutate(liver_dysfn = case_when(dis24_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Bronchiolitis

dta <- dta %>% mutate(bronchiolitis = case_when(dis25_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Cardiomyopathy

dta <- dta %>% mutate(cardiomyopathy = case_when(dis26_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Acute respiratory distress syndrome

dta <- dta %>% mutate(ards = case_when(dis27_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Stroke

dta <-
    dta %>% mutate(
        stroke_c = case_when((dis27a_E3_C5 == 'Yes' | dis27b_E3_C5 == 'Yes') ~ 1, TRUE ~ 0)
        )

#  Medications  ---------------------------------------------------------------

## ARBs/ACE-i

dta <- dta %>% mutate(
    acei_arb = case_when((adm41_E1_C1 == 'Yes' | adm42_E1_C1 == 'Yes') ~ 1, TRUE ~ 0))

## Antiviral

dta <- dta %>% mutate( dis31s1_E3_C5 = str_squish(str_trim(str_to_lower(dis31s1_E3_C5))))
dta <- dta %>% mutate( dis31s2_E3_C5 = str_squish(str_trim(str_to_lower(dis31s2_E3_C5))))
# no antivirals here ... just some other drugs

dta <- dta %>% mutate(antiviral = case_when(dis31_E3_C5 == 'Yes' ~ 1, TRUE ~ 0 ))
dta$antiviral[dta$dis31s1_E3_C5 == 'other'] <- 0

# specific antiviral medication
dta <- dta %>% mutate(antiviral_med = case_when(antiviral == 1 ~ dis31s1_E3_C5,
                                                TRUE ~ 'No antiviral'))
dta$antiviral_med <- factor(dta$antiviral_med,
                            levels = c('No antiviral','ribavirin','lopinavir/ritonavir',
                                       'neuraminidase inhibitor','interferon alpha',
                                       'interferon beta'))

## Antibiotic

dta <- dta %>% mutate(antibiotic = case_when(dis32_E3_C5 == 'Yes' ~ 1, TRUE ~ 0) )

#   ***************************************************************************
# TODO: medications cols? May be?
# dis31s2_E3_C5
dta$dis32s_E3_C5 <- str_squish(str_trim(str_to_lower(dta$dis32s_E3_C5)))

table(dta$dis31s2_E3_C5)
table(dta$dis32s_E3_C5)

# augmentin, azithromycin, metronidazole, levofloxacin, ceftriaxone, cefuroxime,
# ciprofloxacin, amoxicilin, hydroxychloroquine, doxycycline, cefpodoxime,
# ofloxacin, chloroquine, dexamethasone, meropenem, vancomycin, vitamin c, zinc
#
#   ***************************************************************************

## Azithromycin

dta <- dta %>% mutate(
    azithromycin = case_when(dis31s2_E3_C5 == 'arithromycin' ~ 1,
                             dis31s2_E3_C5 == 'arythromycin' ~ 1,
                             dis31s2_E3_C5 == 'azythromycin' ~ 1,
                             grepl('azith', dis31s2_E3_C5)   ~ 1,
                             grepl('azith', dis32s_E3_C5)    ~ 1,
                             dis32s_E3_C5  == 'az' ~ 1,
                             dis32s_E3_C5  == 'azoithromacin'~ 1,
                             grepl('azyth', dis32s_E3_C5)    ~ 1,
                             grepl('azthr', dis32s_E3_C5)    ~ 1,
                             TRUE ~ 0)
)

## Ivermectin

# dta <- dta %>% mutate(
#     ivermectin = case_when(grepl('iverm', dis31s2_E3_C5) ~ 1,
#                            grepl('iverm', dis32s_E3_C5)  ~ 1,
#                            TRUE ~ 0)
# )


## Corticosteroid

dta <- dta %>% mutate(
    steroid = case_when(
        dis33_E3_C5 == 'Yes' ~ 1,
        grepl('dexam', dis31s2_E3_C5) ~ 1,
        grepl('dexam', dis32s_E3_C5) ~ 1,
        dis32s_E3_C5 == 'hydrocetison' ~ 1,
        TRUE ~ 0))

## Corticosteroid agent

dta$dis33s2_E3_C5 <- str_squish(str_trim(str_to_lower(dta$dis33s2_E3_C5)))

dta <- dta %>% mutate(
    steroid_agent = case_when(
        grepl('nil', dis33s2_E3_C5)  ~ 'Not stated',
        grepl('hy', dis33s2_E3_C5)   ~ 'Hydrocortisone',
        grepl('dexa', dis33s2_E3_C5) ~ 'Dexamethasone',
        grepl('pred', dis33s2_E3_C5) ~ 'Prednisolone')
)

dta$steroid_agent[grepl('dexa', dta$dis32s_E3_C5)] <- 'Dexamethasone'
dta$steroid_agent[grepl('hydroc', dta$dis32s_E3_C5)] <- 'Hydrocortisone'


dta$steroid[dta$steroid == 0 & !is.na(dta$steroid_agent)] <- 1
dta$steroid_agent[dta$steroid == 1 &  is.na(dta$steroid_agent)] <- 'Not stated'
dta$steroid_agent[is.na(dta$steroid_agent)] <- 'Not used'

dta$steroid_agent <- factor(dta$steroid_agent,
                            levels = c('Not used', 'Dexamethasone','Hydrocortisone','Prednisolone',
                                       'Not stated'))

## Antifungal

dta <- dta %>% mutate(antifungal = case_when(dis34_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## Antimalarial

dta <- dta %>% mutate(antimalarial = case_when(dis35_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## CQ/HCQ

dta$dis35s_E3_C5 <- str_squish(str_trim(str_to_lower(dta$dis35s_E3_C5)))

dta <- dta %>% mutate(
    chloroquine = case_when(dis35s_E3_C5 == 'chloroquine'         ~ 1,
                            dis35s_E3_C5 == 'choloroquine'        ~ 1,
                            dis32s_E3_C5 == 'c/q'                 ~ 1,
                            dis32s_E3_C5 == 'chloroquine'         ~ 1,
                            dis32s_E3_C5 == 'hydroxylchloroquine' ~ 1,
                            grepl('chloroquine', dis31s2_E3_C5)   ~ 1,
                            dis31s2_E3_C5 == 'hydrochloroquine'   ~ 1,
                            dis31s2_E3_C5 == 'hydroxychloroquine' ~ 1,
                            TRUE ~ 0)
    )

table(dta$chloroquine)

## Experimental agent

# table(dta$dis36_E3_C5, useNA = 'i')

## NSAIDS

dta <- dta %>% mutate(nsaid = case_when(dis37_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

## systemic coagulation

dta <- dta %>% mutate(coagulate = case_when(dis37a_E3_C5 == 'Yes' ~ 1, TRUE ~ 0))

#  Add variable labels

source('scripts/apply-labels.R')

#  Create vector of variables to subset

set.vars <- c('site', 'state', 'mortality', 'study_time', 'admission_time', 'o2', 'icu', 'nvent',
              'ivent', 'severity','age', 'age_group', 'sex', 'health_worker', 'ccdx', 'diabetes',
              'hypertension','smoking', 'pulmonary_dx', 'tb_active', 'tb_previous', 'asthma',
              'respiratory_dx', 'asplenia', 'ckd','neoplasm', 'chronic_liver_dx','neurologic_dx',
              'hiv', 'fever', 'chest_indrawing', 'cough', 'headache','confusion', 'seizures',
              'sore_throat', 'abd_pain', 'runny_nose', 'vomiting', 'wheezing', 'diarrhoea',
              'chest_pain', 'conjunctivitis', 'muscle_aches', 'skin_rash', 'joint_pain',
              'skin_ulcers', 'fatigue', 'lymphadenopathy', 'taste', 'inability_walk',
              'smell', 'bleeding', 'breath', 'stroke', 'spo2', 'malaria', 'shock', 'bacteremia',
              'seizures_c', 'bleeding_c', 'meningitis', 'endocarditis', 'anaemia', 'myocarditis',
              'arrhythmia', 'aki', 'arrest', 'pancreatitis', 'pneumonia', 'liver_dysfn',
              'bronchiolitis', 'cardiomyopathy', 'ards', 'stroke_c', 'acei_arb','antiviral',
              'antiviral_med', 'antibiotic', 'azithromycin', 'steroid', 'steroid_agent',
              'antimalarial', 'chloroquine', 'nsaid', 'coagulate')

#  Subset data set - keeping only variables we are interested in

# covid_data <- dta %>% select( all_of(set.vars))

covid_data <- dta[, set.vars]


#'  ===========================================================================
#'  EXPORT TO OTHER SOFTWARE PACKAGES - SPSS, Stata and SAS
#'  ===========================================================================

write_sav(
    data = covid_data,
    path = 'data/cleaned/covid_data.sav')

write_dta(
    data = covid_data,
    path = 'data/cleaned/covid_data.dta',
    version = 14)

foreign::write.foreign(
    df = covid_data,
    datafile = 'covid_data.csv',
    codefile = 'covid_data.sas',
    package = 'SAS')

saveRDS(
    object = covid_data,
    file = 'data/cleaned/covid_data.rds')

#  Clean up

rm(dta, nga_covid, brks, set.vars, level_labs)

cat(paste('Successfully ran 03-recode.R at', Sys.time()))

#'  ===========================================================================
#'  END OF FILE
#'  ===========================================================================
