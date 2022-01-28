#   ===============================================================================================
#   Import and clean the data
#   At the end I should have a cleaned and recoded dataset for analysis
#
#   @author:    Dr. A. Onu (PhD)
#   @date:      2021-09-19
#   @version:   1.0.0
#   ===============================================================================================


suppressPackageStartupMessages(library (tidyverse))
suppressPackageStartupMessages(library (haven))
suppressPackageStartupMessages(library (lubridate))
suppressPackageStartupMessages(library (ggplot2))
suppressPackageStartupMessages(library (sjPlot))

tmp.data <-
    read_tsv (
        file = 'data/raw/TAB_NGA10166.tsv', # change here
        trim_ws = TRUE,
        skip = 24,
        progress = FALSE,
        show_col_types = FALSE
    )


savedas = 'NGA10166.rds' # change here
savedfilename = paste0('data/processed/', savedas)

study.vars <-
    c(
        'admsit_E1_C1',
        'adm01_E1_C1',
        # clinical inclusion criteria
        'adm03_E1_C1',
        'adm04_E1_C1',
        'adm05_E1_C1',
        'adm06_E1_C1',
        # demographics
        'adm07_E1_C1',
        'adm08_E1_C1',
        'adm09_1_E1_C1',
        'adm09_2_E1_C1',
        'adm10_E1_C1',
        'adm11_E1_C1',
        'adm12_E1_C1',
        'adm12s_E1_C1',
        # date of onset & admission vital signs
        'adm13_E1_C1',
        'adm14_E1_C1',
        'adm15_E1_C1',
        'adm16_E1_C1',
        'adm17_E1_C1',
        'adm18_1_E1_C1',
        'adm18_2_E1_C1',
        'adm19_E1_C1',
        'adm20_E1_C1',
        'adm21_E1_C1',
        'adm21s1_E1_C1',
        'adm21s2_E1_C1',
        'adm22_E1_C1',
        'adm23_E1_C1',
        'adm25_E1_C1',
        'adm26_E1_C1',
        # comorbidities
        'adm27_E1_C1',
        'adm28_E1_C1',
        'adm29_E1_C1',
        'adm30_E1_C1',
        'adm31_E1_C1',
        'adm32_E1_C1',
        'adm32a_E1_C1',
        'adm33_E1_C1',
        'adm35_E1_C1',
        'adm34_E1_C1',
        'adm37_E1_C1',
        'adm36_E1_C1',
        'adm39_E1_C1',
        'adm38_E1_C1',
        'adm38s_E1_C1',
        'adm40_E1_C1',
        'adm40a_E1_C1',
        # pre-admission & chronic medication
        'adm41_E1_C1',
        'adm42_E1_C1',
        'adm43_E1_C1',
        'adm44_E1_C1',
        'adm44s_E1_C1',
        # signs & symptoms on admission
        'adm45_E1_C1',
        'adm46_E1_C1',
        'adm47_E1_C1',
        'adm48s1_E1_C1',
        'adm48s2_E1_C1',
        'adm48_E1_C1',
        'adm49_E1_C1',
        'adm50_E1_C1',
        'adm51_E1_C1',
        'adm52_E1_C1',
        'adm53_E1_C1',
        'adm54_E1_C1',
        'adm55_E1_C1',
        'adm56_E1_C1',
        'adm57_E1_C1',
        'adm58_E1_C1',
        'adm59_E1_C1',
        'adm60_E1_C1',
        'adm61_E1_C1',
        'adm62_E1_C1',
        'adm63_E1_C1',
        'adm64_E1_C1',
        'adm65_E1_C1',
        'adm66_E1_C1',
        'adm67_E1_C1',
        'adm68_E1_C1',
        'adm69_E1_C1',
        'adm69a_E1_C1',
        'adm69b_E1_C1',
        'adm70_E1_C1',
        'adm70s_E1_C1',
        # medication
        'adm71_E1_C1',
        'adm72_E1_C1',
        'adm73_E1_C1',
        'adm73s1_E1_C1',
        'adm73s2_E1_C1',
        'adm74_E1_C1',
        'adm74s1_E1_C1',
        'adm74s2_E1_C1',
        'adm74s3_E1_C1',
        'adm75_E1_C1',
        'adm75s_E1_C1',
        'adm76_E1_C1',
        'adm77_E1_C1',
        'adm77s_E1_C1',
        'adm78_E1_C1',
        'adm79_E1_C1',
        'adm80_E1_C1',
        'adm81_E1_C1',
        'adm82_E1_C1',
        # supportive care
        'adm83_E1_C1',
        'adm84_E1_C1',
        'adm84s1_E1_C1',
        'adm84s2_E1_C1',
        'adm84s3_E1_C1',
        'adm85_E1_C1',
        'adm87_E1_C1',
        'adm89_E1_C1',
        'adm86_E1_C1',
        'adm88_E1_C1',
        'adm90__E1_C1',
        # laboratory results on admission
        'adm90s__E1_C1',
        'adm91_1_E1_C1',
        'adm91s_1_E1_C1',
        'adm92__E1_C1',
        'adm92s__E1_C1',
        'adm93__E1_C1',
        'adm93s__E1_C1',
        'adm94__E1_C1',
        'adm94s__E1_C1',
        'adm95__E1_C1',
        'adm95s__E1_C1',
        'adm96__E1_C1',
        'adm96s__E1_C1',
        'adm97__E1_C1',
        'adm97s__E1_C1',
        'adm99__E1_C1',
        'adm99s__E1_C1',
        'adm100__E1_C1',
        'adm100s__E1_C1',
        'adm101__E1_C1',
        'adm101s__E1_C1',
        'adm102__E1_C1',
        'adm104__E1_C1',
        'adm104s__E1_C1',
        'adm105__E1_C1',
        'adm105s__E1_C1',
        'adm106__E1_C1',
        'adm106s__E1_C1',
        'adm108__E1_C1',
        'adm108s__E1_C1',
        'adm107__E1_C1',
        'adm107s__E1_C1',
        'adm110__E1_C1',
        'adm110s__E1_C1',
        'adm112__E1_C1',
        'adm112s__E1_C1',
        'adm113__E1_C1',
        'adm113s__E1_C1',
        # diagnostic / pathogen testing
        'dis01_E3_C5',
        'dis01s_E3_C5',
        'dis02_E3_C5',
        'dis03_E3_C5',
        'dis04_E3_C5',
        'dis04s1_E3_C5',
        'dis05_E3_C5',
        'dis06_E3_C5',
        'dis06s_E3_C5',
        'dis07_E3_C5',
        'dis08_E3_C5',
        'dis09_E3_C5',
        'dis10_E3_C5',
        # shock
        'dis11_E3_C5',
        'dis12_E3_C5',
        'dis13_E3_C5',
        'dis14_E3_C5',
        'dis15_E3_C5',
        'dis16_E3_C5',
        'dis17_E3_C5',
        'dis18_E3_C5',
        'dis19_E3_C5',
        'dis20_E3_C5',
        'dis21_E3_C5',
        'dis22_E3_C5',
        'dis23_E3_C5',
        'dis24_E3_C5',
        'dis25_E3_C5',
        'dis26_E3_C5',
        'dis27_E3_C5',
        'dis27a_E3_C5',
        'dis27b_E3_C5',
        'dis28_E3_C5',
        'dis28s_E3_C5',
        # medication
        'dis29_E3_C5',
        'dis30_E3_C5',
        'dis31_E3_C5',
        'dis31s1_E3_C5',
        'dis31s2_E3_C5',
        'dis33_E3_C5',
        'dis33s1_E3_C5',
        'dis33s2_E3_C5',
        'dis33s3_E3_C5',
        'dis32_E3_C5',
        'dis32s_E3_C5',
        'dis34_E3_C5',
        'dis35_E3_C5',
        'dis35s_E3_C5',
        'dis36_E3_C5',
        'dis37_E3_C5',
        'dis37a_E3_C5',
        'dis37as_E3_C5',
        # supportive care
        'dis38_E3_C5',
        'dis38s1_E3_C5',
        'dis38s2_E3_C5',
        'dis38s4_E3_C5',
        'dis39_E3_C5',
        'dis39s1_E3_C5',
        'dis39s2_E3_C5',
        'dis39s3_E3_C5',
        'dis39s4_E3_C5',
        'dis40_E3_C5',
        'dis40s_E3_C5',
        'dis41_E3_C5',
        'dis42_E3_C5',
        'dis43_E3_C5',
        'dis45_E3_C5',
        'dis44_E3_C5',
        # outcome
        'dis46_E3_C5',
        'dis47_E3_C5',
        'dis47s_E3_C5',
        'dis48_E3_C5'
    )

var.names <- names(tmp.data)

dvars <- study.vars[!(study.vars %in% var.names)] # find the missing columns

tmp.data <- tmp.data %>% `is.na<-`(dvars) # add the missing columns

pre.data <- tmp.data[, study.vars]

attach(pre.data)

nominal <- function(x) {
    factor(x,
           levels = 1:3,
           labels = c('Yes', 'No', 'Unknown'))
}

attr(pre.data$admsit_E1_C1, 'label') <- 'Facility name'
attr(pre.data$adm01_E1_C1, 'label')  <- 'Date of enrollment'

# clinical inclusion criteria

table(adm03_E1_C1)
pre.data$adm03_E1_C1 <- nominal(adm03_E1_C1)
attr(pre.data$adm03_E1_C1, 'label') <-
    'A history of self-reported fever or measured fever of ≥ 38°C:'

table(adm04_E1_C1)
pre.data$adm04_E1_C1 <- nominal(adm04_E1_C1)
attr(pre.data$adm04_E1_C1, 'label') <- 'Cough'

table(adm05_E1_C1)
pre.data$adm05_E1_C1 <- nominal(adm05_E1_C1)
attr(pre.data$adm05_E1_C1, 'label') <- 'Dyspnoea'

table(adm06_E1_C1)
pre.data$adm06_E1_C1 <- nominal(adm06_E1_C1)
attr(pre.data$adm06_E1_C1, 'label') <-
    'Clinical suspicion despite not meeting criteria'

# demographics

table(adm07_E1_C1)
pre.data$adm07_E1_C1 <-
    factor(
        adm07_E1_C1,
        levels = 1:3,
        labels = c('Male', 'Female', 'Not specified')
    )
attr(pre.data$adm07_E1_C1, 'label') <- 'Sex at birth'

summary(adm08_E1_C1)
attr(pre.data$adm08_E1_C1, 'label') <- 'Date of birth'

summary(adm09_1_E1_C1)
attr(pre.data$adm09_1_E1_C1, 'label') <- 'Age in years'

table(adm10_E1_C1)
pre.data$adm10_E1_C1 <- nominal(adm10_E1_C1)
attr(pre.data$adm10_E1_C1, 'label') <- 'Healthcare worker'

table(adm11_E1_C1)
pre.data$adm11_E1_C1 <- nominal(adm11_E1_C1)
attr(pre.data$adm11_E1_C1, 'label') <- 'Laboratory worker'

table(adm12_E1_C1)
pre.data$adm12_E1_C1 <- nominal(adm12_E1_C1)
attr(pre.data$adm12_E1_C1, 'label') <- 'Pregnant'

#table(adm12s_E1_C1)
#pre.data$adm12s_E1_C1 <- as.numeric(substr(adm12s_E1_C1, 1, 2))

# date of onset & admission vital signs

summary(adm13_E1_C1)
attr(pre.data$adm13_E1_C1, 'label') <- 'Symptom onset'

summary(adm14_E1_C1)
#adm01_E1_C1[adm14_E1_C1 == as.Date('2999-06-23')]
pre.data$adm14_E1_C1[adm14_E1_C1 == as.Date('2999-06-23')] <-
    as.Date('2020-06-23')
attr(pre.data$adm14_E1_C1, 'label') <- 'Admission date'

summary(adm15_E1_C1)
attr(pre.data$adm15_E1_C1, 'label') <- 'Temperature'

summary(adm16_E1_C1)
attr(pre.data$adm16_E1_C1, 'label') <- 'Heart rate'

summary(adm17_E1_C1)
attr(pre.data$adm17_E1_C1, 'label') <- 'Respiratory rate'

summary(adm18_1_E1_C1)
attr(pre.data$adm18_1_E1_C1, 'label') <- 'BP - Systolic'

summary(adm18_2_E1_C1)
attr(pre.data$adm18_2_E1_C1, 'label') <- 'BP - Diastolic'

table(adm19_E1_C1)
pre.data$adm19_E1_C1 <- nominal(adm19_E1_C1)
attr(pre.data$adm19_E1_C1, 'label') <- 'Severe dehydration'

table(adm20_E1_C1)
pre.data$adm20_E1_C1 <- nominal(adm20_E1_C1)
attr(pre.data$adm20_E1_C1, 'label') <-
    'Sternal capillary refill time > 2 seconds'

summary(adm21_E1_C1)
attr(pre.data$adm21_E1_C1, 'label') <- 'Oxygen saturation'

table(adm21s1_E1_C1)
pre.data$adm21s1_E1_C1 <-
    factor(
        adm21s1_E1_C1,
        levels = 1:3,
        labels = c('Room air', 'Oxygen therapy', 'Unknown')
    )
attr(pre.data$adm21s1_E1_C1, 'label') <-
    'Oxygen saturation on room air/oxygen therapy'

table(adm21s2_E1_C1)
pre.data$adm21s2_E1_C1 <-
    factor(adm21s2_E1_C1,
           levels = 1:4,
           labels = c('A', 'V', 'P', 'U'))
attr(pre.data$adm21s2_E1_C1, 'label') <- 'AVPU - ADM'

summary(adm22_E1_C1)
attr(pre.data$adm22_E1_C1, 'label') <- 'Glasgow Coma Score'

table(adm23_E1_C1)
pre.data$adm23_E1_C1 <- nominal(adm23_E1_C1)
attr(pre.data$adm23_E1_C1, 'labels') <- 'Malnutrition'

attr(pre.data$adm25_E1_C1, 'label') <- 'Height'
summary(adm26_E1_C1)
attr(pre.data$adm26_E1_C1, 'label') <- 'Weight'

# comorbidities

table(adm27_E1_C1)
pre.data$adm27_E1_C1 <- nominal(adm27_E1_C1)
attr(pre.data$adm27_E1_C1, 'label') <- 'Chronic cardiac disease'

table(adm28_E1_C1)
pre.data$adm28_E1_C1 <- nominal(adm28_E1_C1)
attr(pre.data$adm28_E1_C1, 'label') <- 'Diabetes'

table(adm29_E1_C1)
pre.data$adm29_E1_C1 <- nominal(adm29_E1_C1)
attr(pre.data$adm29_E1_C1, 'label') <- 'Hypertension'

table(adm30_E1_C1)
pre.data$adm30_E1_C1 <- nominal(adm30_E1_C1)
attr(pre.data$adm30_E1_C1, 'label') <- 'Current smoking'

table(adm31_E1_C1)
pre.data$adm31_E1_C1 <- nominal(adm31_E1_C1)
attr(pre.data$adm31_E1_C1, 'label') <- 'Chronic pulmonary disease'

table(adm32_E1_C1)
pre.data$adm32_E1_C1 <- nominal(adm32_E1_C1)
attr(pre.data$adm32_E1_C1, 'label') <- 'Tuberculosis (active)'

table(adm32a_E1_C1)
pre.data$adm32a_E1_C1 <- nominal(adm32a_E1_C1)
attr(pre.data$adm32a_E1_C1, 'label') <- 'Tuberculosis (previous)'

table(adm33_E1_C1)
pre.data$adm33_E1_C1 <- nominal(adm33_E1_C1)
attr(pre.data$adm33_E1_C1, 'label') <- 'Asthma'

table(adm35_E1_C1)
pre.data$adm35_E1_C1 <- nominal(adm35_E1_C1)
attr(pre.data$adm35_E1_C1, 'label') <- 'Chronic kidney disease'

table(adm34_E1_C1)
pre.data$adm34_E1_C1 <- nominal(adm34_E1_C1)
attr(pre.data$adm34_E1_C1, 'label') <- 'Asplenia'

table(adm37_E1_C1)
pre.data$adm37_E1_C1 <- nominal(adm37_E1_C1)
attr(pre.data$adm37_E1_C1, 'label') <- 'Chronic liver disease'

table(adm36_E1_C1)
pre.data$adm36_E1_C1 <- nominal(pre.data$adm36_E1_C1)
attr(pre.data$adm36_E1_C1, 'label') <- 'Malignant neoplasm'

table(adm39_E1_C1)
pre.data$adm39_E1_C1 <- nominal(adm39_E1_C1)
attr(pre.data$adm39_E1_C1, 'label') <-
    'Chronic neurological disorder'

table(adm38_E1_C1)
pre.data$adm38_E1_C1 <- nominal(adm38_E1_C1)
attr(pre.data$adm38_E1_C1, 'label') <- 'Other comorbidity'

#table(adm38s_E1_C1)
attr(pre.data$adm38s_E1_C1, 'label') <- 'Other comorbidity: specify'

table(adm40_E1_C1)
pre.data$adm40_E1_C1 <-
    factor(
        adm40_E1_C1,
        levels = 1:4,
        labels = c('Yes - on ART', 'Yes - not on ART', 'No', 'Unknown')
    )
attr(pre.data$adm40_E1_C1, 'label') <- 'HIV'

#table(adm40a_E1_C1)
#attr(pre.data$adm40a_E1_C1, 'label') <- 'ART regimen'

# pre-admission & chronic medication

table(adm41_E1_C1)
pre.data$adm41_E1_C1 <- nominal(adm41_E1_C1)
attr(pre.data$adm41_E1_C1, 'label') <- 'ACE inhibitors - ADM'

table(adm42_E1_C1)
pre.data$adm42_E1_C1 <- nominal(adm42_E1_C1)
attr(pre.data$adm42_E1_C1, 'label') <- 'ARBs - ADM'

table(adm43_E1_C1)
pre.data$adm43_E1_C1 <- nominal(adm43_E1_C1)
attr(pre.data$adm43_E1_C1, 'label') <- 'NSAID'

table(adm44_E1_C1)
pre.data$adm44_E1_C1 <-
    factor(
        adm44_E1_C1,
        levels = 1:4,
        labels = c('CQ/HCQ', 'Azithromycin', 'LPV/RTV', 'Other')
    )
attr(pre.data$adm44_E1_C1, 'label') <- 'Antiviral'

#table(adm44s_E1_C1)
#attr(pre.data$adm44_E1_C1, 'label') <- 'Antiviral: other'

# signs & symptoms on admission

table(adm45_E1_C1)
pre.data$adm45_E1_C1 <- nominal(adm45_E1_C1)
attr(pre.data$adm45_E1_C1, 'label') <- 'History of fever'

table(adm46_E1_C1)
pre.data$adm46_E1_C1 <- nominal(adm46_E1_C1)
attr(pre.data$adm46_E1_C1, 'label') <- 'Lower chest indrawing'

table(adm47_E1_C1)
pre.data$adm47_E1_C1 <- nominal(adm47_E1_C1)
attr(pre.data$adm47_E1_C1, 'label') <- 'Cough'

table(adm48s1_E1_C1)
pre.data$adm48s1_E1_C1 <- nominal(adm48s1_E1_C1)
attr(pre.data$adm48s1_E1_C1, 'label') <-
    'If yes, with sputum production'

table(adm48s2_E1_C1)
pre.data$adm48s2_E1_C1 <- nominal(adm48s2_E1_C1)
attr(pre.data$adm48s2_E1_C1, 'label') <- 'If yes, with haemoptysis'

table(adm48_E1_C1)
pre.data$adm48_E1_C1 <- nominal(adm48_E1_C1)
attr(pre.data$adm48_E1_C1, 'label') <- 'Headache'

table(adm49_E1_C1)
pre.data$adm49_E1_C1 <- nominal(adm49_E1_C1)
attr(pre.data$adm49_E1_C1, 'label') <-
    'Altered consciousness/confusion'

table(adm50_E1_C1)
pre.data$adm50_E1_C1 <- nominal(adm50_E1_C1)
attr(pre.data$adm50_E1_C1, 'label') <- 'Seizures'

table(adm51_E1_C1)
pre.data$adm51_E1_C1 <- nominal(adm51_E1_C1)
attr(pre.data$adm51_E1_C1, 'label') <- 'Sore throat'

table(adm52_E1_C1)
pre.data$adm52_E1_C1 <- nominal(adm52_E1_C1)
attr(pre.data$adm52_E1_C1, 'label') <- 'Abdominal pain'

table(adm53_E1_C1)
pre.data$adm53_E1_C1 <- nominal(adm53_E1_C1)
attr(pre.data$adm53_E1_C1, 'label') <- 'Runny nose'

table(adm54_E1_C1)
pre.data$adm54_E1_C1 <- nominal(adm54_E1_C1)
attr(pre.data$adm54_E1_C1, 'label') <- 'Vomiting/nausea'

table(adm55_E1_C1)
pre.data$adm55_E1_C1 <- nominal(adm55_E1_C1)
attr(pre.data$adm55_E1_C1, 'label') <- 'Wheezing'

table(adm56_E1_C1)
pre.data$adm56_E1_C1 <- nominal(adm56_E1_C1)
attr(pre.data$adm56_E1_C1, 'label') <- 'Diarrhoea'

table(adm57_E1_C1)
pre.data$adm57_E1_C1 <- nominal(adm57_E1_C1)
attr(pre.data$adm57_E1_C1, 'label') <- 'Chest pain'

table(adm58_E1_C1)
pre.data$adm58_E1_C1 <- nominal(adm58_E1_C1)
attr(pre.data$adm58_E1_C1, 'label') <- 'Conjunctivitis'

table(adm59_E1_C1)
pre.data$adm59_E1_C1 <- nominal(adm59_E1_C1)
attr(pre.data$adm59_E1_C1, 'label') <- 'Muscle aches'

table(adm60_E1_C1)
pre.data$adm60_E1_C1 <- nominal(adm60_E1_C1)
attr(pre.data$adm60_E1_C1, 'label') <- 'Skin rash'

table(adm61_E1_C1)
pre.data$adm61_E1_C1 <- nominal(adm61_E1_C1)
attr(pre.data$adm61_E1_C1, 'label') <- 'Joint pain'

table(adm62_E1_C1)
pre.data$adm62_E1_C1 <- nominal(adm62_E1_C1)
attr(pre.data$adm62_E1_C1, 'label') <- 'Skin ulcers'

table(adm63_E1_C1)
pre.data$adm63_E1_C1 <- nominal(adm63_E1_C1)
attr(pre.data$adm63_E1_C1, 'label') <- 'Fatigue/malaise'

table(adm64_E1_C1)
pre.data$adm64_E1_C1 <- nominal(adm64_E1_C1)
attr(pre.data$adm64_E1_C1, 'label') <- 'Lymphadenopathy'

table(adm65_E1_C1)
pre.data$adm65_E1_C1 <- nominal(adm65_E1_C1)
attr(pre.data$adm65_E1_C1, 'label') <- 'Loss of taste'

table(adm66_E1_C1)
pre.data$adm66_E1_C1 <- nominal(adm66_E1_C1)
attr(pre.data$adm66_E1_C1, 'label') <- 'Inability to walk'

table(adm67_E1_C1)
pre.data$adm67_E1_C1 <- nominal(adm67_E1_C1)
attr(pre.data$adm67_E1_C1, 'label') <- 'Loss of smell'

table(adm68_E1_C1)
pre.data$adm68_E1_C1 <- nominal(adm68_E1_C1)
attr(pre.data$adm68_E1_C1, 'label') <- 'Bleeding'

table(adm69_E1_C1)
pre.data$adm69_E1_C1 <- nominal(adm69_E1_C1)
attr(pre.data$adm69_E1_C1, 'label') <- 'Shortness of breath'

table(adm69a_E1_C1)
pre.data$adm69a_E1_C1 <- nominal(adm69a_E1_C1)
attr(pre.data$adm69a_E1_C1, 'label') <- 'Stroke: ischaemic stroke'

table(adm69b_E1_C1)
pre.data$adm69b_E1_C1 <- nominal(adm69b_E1_C1)
attr(pre.data$adm69b_E1_C1, 'label') <-
    'Stroke: intracerebral bleeding'

table(adm70_E1_C1)
pre.data$adm70_E1_C1 <- nominal(adm70_E1_C1)
attr(pre.data$adm70_E1_C1, 'label') <- 'Other symptom'

#table(adm70s_E1_C1)
#attr(pre.data$adm70_E1_C1, 'label') <- 'Other symptom: specify'

# medication

table(adm71_E1_C1)
pre.data$adm71_E1_C1 <- nominal(adm71_E1_C1)
attr(pre.data$adm71_E1_C1, 'label') <- 'Oral/orogastric fluids'

table(adm72_E1_C1)
pre.data$adm72_E1_C1 <- nominal(adm72_E1_C1)
attr(pre.data$adm72_E1_C1, 'label') <- 'Intravenous fluids'

table(adm73_E1_C1)
pre.data$adm73_E1_C1 <- nominal(adm73_E1_C1)
attr(pre.data$adm73_E1_C1, 'label') <- 'Antiviral'

table(adm73s1_E1_C1) # cross check
pre.data$adm73s1_E1_C1 <- factor(
    adm73s1_E1_C1,
    levels = 1:6,
    labels = c(
        'Ribavirin',
        'Lopinavir/Ritonavir',
        'Neuraminidase inhibitor',
        'Interferon alpha',
        'Interferon beta',
        'Other'
    )
)
attr(pre.data$adm73s1_E1_C1, 'label') <- 'If yes, which antiviral'

table(adm73s2_E1_C1)
attr(pre.data$adm73s2_E1_C1, 'label') <- 'Other antiviral: specify'

table(adm74_E1_C1)
pre.data$adm74_E1_C1 <- nominal(adm74_E1_C1)
attr(pre.data$adm74_E1_C1, 'label') <- 'Corticosteroid'

table(adm74s1_E1_C1)
pre.data$adm74s1_E1_C1 <-
    factor(
        adm74s1_E1_C1,
        levels = 1:3,
        labels = c('Oral', 'Intravenous', 'Inhaled')
    )
attr(pre.data$adm74s1_E1_C1, 'label') <- 'If yes, route'

table(adm74s2_E1_C1)
attr(pre.data$adm74s2_E1_C1, 'label') <- 'If yes, agent'

table(adm74s3_E1_C1) # need to be converted to number
attr(pre.data$adm74s3_E1_C1, 'label') <- 'maximum daily dose'

table(adm75_E1_C1)
pre.data$adm75_E1_C1 <- nominal(adm75_E1_C1)
attr(pre.data$adm75_E1_C1, 'label') <- 'Antibiotic'

table(adm75s_E1_C1)
attr(pre.data$adm75s_E1_C1, 'label') <- 'Antibiotic: specify'

table(adm76_E1_C1)
pre.data$adm76_E1_C1 <- nominal(adm76_E1_C1)
attr(pre.data$adm76_E1_C1, 'label') <- 'Antifungal agent'

table(adm77_E1_C1)
pre.data$adm77_E1_C1 <- nominal(adm77_E1_C1)
attr(pre.data$adm77_E1_C1, 'label') <- 'Antimalarial agent'

table(adm77s_E1_C1)
attr(pre.data$adm77s_E1_C1, 'label') <-
    'Antimalarial agent: specify'

table(adm78_E1_C1)
pre.data$adm78_E1_C1 <- nominal(adm78_E1_C1)
attr(pre.data$adm78_E1_C1, 'label') <- 'Experimental agent'

table(adm79_E1_C1)
pre.data$adm79_E1_C1 <- nominal(adm79_E1_C1)
attr(pre.data$adm79_E1_C1, 'label') <- 'NSAID'

table(adm80_E1_C1)
pre.data$adm80_E1_C1 <- nominal(adm80_E1_C1)
attr(pre.data$adm80_E1_C1, 'label') <- 'ACE inhibitors'

table(adm81_E1_C1)
pre.data$adm81_E1_C1 <- nominal(adm81_E1_C1)
attr(pre.data$adm81_E1_C1, 'label') <- 'ARBs'

table(adm82_E1_C1)
pre.data$adm82_E1_C1 <- nominal(adm82_E1_C1)
attr(pre.data$adm82_E1_C1, 'label') <- 'Systemic anticoagulation'

# supportive care

table(adm83_E1_C1)
pre.data$adm83_E1_C1 <- nominal(adm83_E1_C1)
attr(pre.data$adm83_E1_C1, 'label') <- 'ICU/HDU admission'

table(adm84_E1_C1)
pre.data$adm84_E1_C1 <- nominal(adm84_E1_C1)
attr(pre.data$adm84_E1_C1, 'label') <- 'Oxygen therapy'

table(adm84s1_E1_C1)
pre.data$adm84s1_E1_C1 <- factor(
    adm84s1_E1_C1,
    levels = 1:5,
    labels = c('1-5 L/min', '6-10 L/min', '11-15 L/min', '>15 L/min', 'Unknown')
)
attr(pre.data$adm84s1_E1_C1, 'label') <- 'Oxygen flow'

table(adm84s2_E1_C1)
pre.data$adm84s2_E1_C1 <- factor(
    adm84s2_E1_C1,
    levels = 1:4,
    labels = c('Piped', 'Cylinder', 'Concentrator', 'Unknown')
)
attr(pre.data$adm84s2_E1_C1, 'label') <- 'Oxygen source'

table(adm84s3_E1_C1)
pre.data$adm84s3_E1_C1 <- factor(
    adm84s3_E1_C1,
    levels = 1:6,
    labels = c(
        'Nasal prongs',
        'HF nasal cannula',
        'Mask',
        'Mask with reservoir',
        'CPAP/NIV mask',
        'Unknown'
    )
)
attr(pre.data$adm84s3_E1_C1, 'label') <- 'Oxygen interface'

table(adm85_E1_C1)
pre.data$adm85_E1_C1 <- nominal(adm85_E1_C1)
attr(pre.data$adm85_E1_C1, 'label') <-
    'Noninvasive ventilation (BIPAP/CPAP)'

table(adm87_E1_C1)
pre.data$adm87_E1_C1 <- nominal(adm87_E1_C1)
attr(pre.data$adm87_E1_C1, 'label') <- 'Invasive ventilation'

table(adm89_E1_C1)
pre.data$adm89_E1_C1 <- nominal(adm89_E1_C1)
attr(pre.data$adm89_E1_C1, 'label') <-
    'Extracorporeal (ECMO) support'

table(adm86_E1_C1)
pre.data$adm86_E1_C1 <- nominal(adm86_E1_C1)
attr(pre.data$adm86_E1_C1, 'label') <- 'Prone position'

table(adm88_E1_C1)
pre.data$adm88_E1_C1 <- nominal(adm88_E1_C1)
attr(pre.data$adm88_E1_C1, 'label') <- 'Inotropes/vasopressors'


# laboratory results on admission

summary(adm90__E1_C1)
attr(pre.data$adm90__E1_C1, 'label') <- 'Haemoglobin'

table(adm90s__E1_C1)

summary(adm91_1_E1_C1)
attr(pre.data$adm91_1_E1_C1, 'label') <- 'Creatinine'

table(adm91s_1_E1_C1)

summary(adm92__E1_C1)
attr(pre.data$adm92__E1_C1, 'label') <- 'WBC count'

table(adm92s__E1_C1)

summary(adm93__E1_C1)
attr(pre.data$adm93__E1_C1, 'label') <- 'Sodium'

table(adm93s__E1_C1) # remove

summary(adm94__E1_C1)
attr(pre.data$adm94__E1_C1, 'label') <- 'Haematocrit'

table(adm94s__E1_C1) # remove

summary(adm95__E1_C1)
attr(pre.data$adm95__E1_C1, 'label') <- 'Potassium'

table(adm95s__E1_C1) # remove

summary(adm96__E1_C1)
attr(pre.data$adm96__E1_C1, 'label') <- 'Platelets'

table(adm96s__E1_C1)

summary(adm97__E1_C1)
attr(pre.data$adm97__E1_C1, 'label') <- 'Procalcitonin'

table(adm97s__E1_C1) # remove

summary(adm99__E1_C1)
attr(pre.data$adm99__E1_C1, 'label') <- 'CRP'

table(adm99s__E1_C1) # remove

summary(adm100__E1_C1)
attr(pre.data$adm100__E1_C1, 'label') <- 'PT'

table(adm100s__E1_C1) # remove

summary(adm101__E1_C1)
attr(pre.data$adm101__E1_C1, 'label') <- 'LDH'

table(adm101s__E1_C1) # remove?

summary(adm102__E1_C1)
attr(pre.data$adm102__E1_C1, 'label') <- 'INR'

summary(adm104__E1_C1)
attr(pre.data$adm104__E1_C1, 'label') <- 'ALT/SGPT'

table(adm104s__E1_C1) # remove

summary(adm105__E1_C1)
attr(pre.data$adm105__E1_C1, 'label') <- 'Troponin'

table(adm105s__E1_C1)

summary(adm106__E1_C1)
attr(pre.data$adm106__E1_C1, 'label') <- 'Total bilirubin'

table(adm106s__E1_C1)

summary(adm108__E1_C1)
attr(pre.data$adm108__E1_C1, 'label') <- 'AST/SGOT'

table(adm108s__E1_C1)

summary(adm107__E1_C1)
attr(pre.data$adm107__E1_C1, 'label') <- 'ESR'

table(adm107s__E1_C1)

summary(adm110__E1_C1)
attr(pre.data$adm110__E1_C1, 'label') <- 'Urea'

table(adm110s__E1_C1)

summary(adm112__E1_C1)

table(adm112s__E1_C1)

summary(adm113__E1_C1)
attr(pre.data$adm113__E1_C1, 'label') <- 'IL-6'

table(adm113s__E1_C1)


# diagnostic / pathogen testing

table(dis01_E3_C5)
pre.data$dis01_E3_C5 <- nominal(dis01_E3_C5)
attr(pre.data$dis01_E3_C5, 'label') <- 'CXR/CT done'

table(dis01s_E3_C5)
pre.data$dis01s_E3_C5 <- nominal(dis01s_E3_C5)
attr(pre.data$dis01s_E3_C5, 'label') <-
    'If yes, infiltrates present'

table(dis02_E3_C5)
pre.data$dis02_E3_C5 <- nominal(dis02_E3_C5)
attr(pre.data$dis02_E3_C5, 'label') <-
    'Was pathogen testing done during this illness episode'

table(dis03_E3_C5)
pre.data$dis03_E3_C5 <-
    factor(dis02_E3_C5, levels = 1:3, c('Positive', 'Negative', 'Not done'))
attr(pre.data$dis03_E3_C5, 'label') <- 'Influenza virus'

table(dis04_E3_C5)
pre.data$dis04_E3_C5 <-
    factor(dis04_E3_C5, levels = 1:3, c('Positive', 'Negative', 'Not done'))
attr(pre.data$dis04_E3_C5, 'label') <- 'Coronavirus'

table(dis04s1_E3_C5)
pre.data$dis04s1_E3_C5 <-
    factor(dis04s1_E3_C5, levels = 1:3, c('MERS-CoV', 'SARS-CoV-2', 'Other'))
attr(pre.data$dis04s1_E3_C5, 'label') <- 'If positive, specify type'

table(dis05_E3_C5)
pre.data$dis05_E3_C5 <-
    factor(dis05_E3_C5,
           levels = 1:3,
           labels('Positive', 'Negative', 'Not done'))
attr(pre.data$dis05_E3_C5, 'label') <- 'Other respiratory pathogen'

table(dis06_E3_C5)
pre.data$dis06_E3_C5 <-
    factor(dis06_E3_C5,
           levels = 1:3,
           labels('Positive', 'Negative', 'Not done'))
attr(pre.data$dis06_E3_C5, 'label') <- 'Viral haemorrhagic fever'

table(dis06s_E3_C5)
attr(pre.data$dis06s_E3_C5, 'label') <- 'If positive, specify virus'

table(dis07_E3_C5)
pre.data$dis07_E3_C5 <- nominal(dis07_E3_C5)
attr(pre.data$dis07_E3_C5, 'label') <-
    'Other pathogen of public health interest detected'

table(dis08_E3_C5)
pre.data$dis08_E3_C5 <-
    factor(dis08_E3_C5,
           levels = 1:3,
           labels('Positive', 'Negative', 'Not done'))
attr(pre.data$dis08_E3_C5, 'labels') <- 'Falciparum malaria'

table(dis09_E3_C5)
pre.data$dis09_E3_C5 <-
    factor(dis09_E3_C5,
           levels = 1:3,
           labels('Positive', 'Negative', 'Not done'))
attr(pre.data$dis09_E3_C5, 'label') <- 'Nonfalciparum malaria'

table(dis10_E3_C5)
pre.data$dis10_E3_C5 <-
    factor(dis10_E3_C5,
           levels = 1:3,
           labels('Positive', 'Negative', 'Not done'))
attr(pre.data$dis10_E3_C5, 'label') <- 'HIV'

# complications

table(dis11_E3_C5)
pre.data$dis11_E3_C5 <- nominal(dis11_E3_C5)
attr(pre.data$dis11_E3_C5, 'label') <- 'Shock'

table(dis12_E3_C5)
pre.data$dis12_E3_C5 <- nominal(dis12_E3_C5)
attr(pre.data$dis12_E3_C5, 'label') <- 'Bacteraemia'

table(dis13_E3_C5)
pre.data$dis13_E3_C5 <- nominal(dis13_E3_C5)
attr(pre.data$dis13_E3_C5, 'label') <- 'Seizure'

table(dis14_E3_C5)
pre.data$dis14_E3_C5 <- nominal(dis14_E3_C5)
attr(pre.data$dis14_E3_C5, 'label') <- 'Bleeding'

table(dis15_E3_C5)
pre.data$dis15_E3_C5 <- nominal(dis15_E3_C5)
attr(pre.data$dis15_E3_C5, 'label') <- 'Meningitis/Encephalitis'

table(dis16_E3_C5)
pre.data$dis16_E3_C5 <- nominal(dis16_E3_C5)
attr(pre.data$dis16_E3_C5, 'label') <- 'Endocarditis'

table(dis17_E3_C5)
pre.data$dis17_E3_C5 <- nominal(dis17_E3_C5)
attr(pre.data$dis17_E3_C5, 'label') <- 'Anaemia'

table(dis18_E3_C5)
pre.data$dis18_E3_C5 <- nominal(dis18_E3_C5)
attr(pre.data$dis18_E3_C5, 'label') <- 'Myocarditis/Pericarditis'

table(dis19_E3_C5)
pre.data$dis19_E3_C5 <- nominal(dis19_E3_C5)
attr(pre.data$dis19_E3_C5, 'label') <- 'Cardiac arrhythmia'

table(dis20_E3_C5)
pre.data$dis20_E3_C5 <- nominal(dis20_E3_C5)
attr(pre.data$dis20_E3_C5, 'label') <- 'Acute renal injury'

table(dis21_E3_C5)
pre.data$dis21_E3_C5 <- nominal(dis21_E3_C5)
attr(pre.data$dis21_E3_C5, 'label') <- 'Cardiac arrest'

table(dis22_E3_C5)
pre.data$dis22_E3_C5 <- nominal(dis22_E3_C5)
attr(pre.data$dis22_E3_C5, 'label') <- 'Pancreatitis'

table(dis23_E3_C5)
pre.data$dis23_E3_C5 <- nominal(dis23_E3_C5)
attr(pre.data$dis23_E3_C5, 'label') <- 'Pneumonia'

table(dis24_E3_C5)
pre.data$dis24_E3_C5 <- nominal(dis24_E3_C5)
attr(pre.data$dis24_E3_C5, 'label') <- 'Liver dysfunction'


table(dis25_E3_C5)
pre.data$dis25_E3_C5 <- nominal(dis25_E3_C5)
attr(pre.data$dis25_E3_C5, 'label') <- 'Bronchiolitis'

table(dis26_E3_C5)
pre.data$dis26_E3_C5 <- nominal(dis26_E3_C5)
attr(pre.data$dis26_E3_C5, 'label') <- 'Cardiomyopathy'

table(dis27_E3_C5)
pre.data$dis27_E3_C5 <- nominal(dis27_E3_C5)
attr(pre.data$dis27_E3_C5, 'label') <-
    'Acute respiratory distress syndrome'

table(dis27a_E3_C5)
pre.data$dis27a_E3_C5 <- nominal(dis27a_E3_C5)
attr(pre.data$dis27a_E3_C5, 'label') <- 'Stroke: Ischaemic stroke'

table(dis27b_E3_C5)
pre.data$dis27b_E3_C5 <- nominal(dis27b_E3_C5)
attr(pre.data$dis27b_E3_C5, 'label') <-
    'Stroke: intracerebral haemorrhage'

table(dis28_E3_C5)
pre.data$dis28_E3_C5 <- nominal(dis28_E3_C5)
attr(pre.data$dis28_E3_C5, 'label') <- 'Other complication'

table(dis28s_E3_C5)
attr(pre.data$dis28s_E3_C5, 'label') <-
    'Other complication: specify'

# medication

table(dis29_E3_C5)
pre.data$dis29_E3_C5 <- nominal(dis29_E3_C5)
attr(pre.data$dis29_E3_C5, 'label') <- 'Oral/orogastric fluids'

table(dis30_E3_C5)
pre.data$dis30_E3_C5 <- nominal(dis30_E3_C5)
attr(pre.data$dis30_E3_C5, 'label') <- 'Intravenous fluids'

table(dis31_E3_C5)
pre.data$dis31_E3_C5 <- nominal(dis31_E3_C5)
attr(pre.data$dis31_E3_C5, 'label') <- 'Antiviral'

table(dis31s1_E3_C5)
pre.data$dis31s1_E3_C5 <- factor(
    dis31s1_E3_C5,
    levels = 1:6,
    labels = c(
        'Ribavirin',
        'Lopinavir/Ritonavir',
        'Neuraminidase inhibitor',
        'Interferon alpha',
        'Interferon beta',
        'Other'
    )
)
attr(pre.data$dis31s1_E3_C5, 'label') <- 'Antiviral: If yes,'

table(dis31s2_E3_C5)
attr(pre.data$dis31s2_E3_C5, 'label') <-
    'Antiviral: if other, specify'

table(dis33_E3_C5)
pre.data$dis33_E3_C5 <- nominal(dis33_E3_C5)
attr(pre.data$dis33_E3_C5, 'label') <- 'Corticosteroid'

table(dis33s1_E3_C5)
pre.data$dis33s1_E3_C5 <-
    factor(
        dis33s1_E3_C5,
        levels = 1:3,
        labels = c('Oral', 'Intravenous', 'Inhaled')
    )
attr(pre.data$dis33s1_E3_C5, 'label') <- 'If yes, route'

table(dis33s2_E3_C5)
attr(pre.data$dis33s2_E3_C5, 'label') <- 'If yes, agent'

table(dis33s3_E3_C5) # convert to number
attr(pre.data$dis33s3_E3_C5, 'label') <-
    'If yes, maximum daily dose'

table(dis32_E3_C5)
pre.data$dis32_E3_C5 <- nominal(dis32_E3_C5)
attr(pre.data$dis32_E3_C5, 'label') <- 'Antibiotic'

table(dis32s_E3_C5)
attr(pre.data$dis32s_E3_C5, 'label') <-
    'Antibiotic: if yes, specify'

table(dis34_E3_C5)
pre.data$dis34_E3_C5 <- nominal(dis34_E3_C5)
attr(pre.data$dis34_E3_C5, 'label') <- 'Antifungal agent'

table(dis35_E3_C5)
pre.data$dis35_E3_C5 <- nominal(dis35_E3_C5)
attr(pre.data$dis35_E3_C5, 'label') <- 'Antimalarial agent'

table(dis35s_E3_C5)
attr(pre.data$dis35s_E3_C5, 'label') <-
    'Antimalarial agent: if yes, specify'

table(dis36_E3_C5)
pre.data$dis36_E3_C5 <- nominal(dis36_E3_C5)
attr(pre.data$dis36_E3_C5, 'label') <- 'Experimental agent'

table(dis37_E3_C5)
pre.data$dis37_E3_C5 <- nominal(dis37_E3_C5)
attr(pre.data$dis37_E3_C5, 'label') <- 'NSAID'

table(dis37a_E3_C5)
pre.data$dis37a_E3_C5 <- nominal(dis37a_E3_C5)
attr(pre.data$dis37a_E3_C5, 'label') <- 'Systemic anticoagulation'

table(dis37as_E3_C5)
attr(pre.data$dis37as_E3_C5, 'label') <-
    'Systemic anticoagulation: if yes, specify'

# supportive care

table(dis38_E3_C5)
pre.data$dis38_E3_C5 <- nominal(dis38_E3_C5)
attr(pre.data$dis38_E3_C5, 'label') <- 'ICU/HDU admission'

summary(dis38s1_E3_C5)
attr(pre.data$dis38s1_E3_C5, 'label') <- 'If yes, total duration'

summary(dis38s2_E3_C5)
attr(pre.data$dis38s2_E3_C5, 'label') <-
    'If yes, date of ICU admission'

summary(dis38s4_E3_C5)
attr(pre.data$dis38s4_E3_C5, 'label') <-
    'If yes, date of ICU discharge'

table(dis39_E3_C5)
pre.data$dis39_E3_C5 <- nominal(dis39_E3_C5)
attr(pre.data$dis39_E3_C5, 'label') <- 'Oxygen therapy'

table(dis39s1_E3_C5) # change to number
attr(pre.data$dis39s1_E3_C5, 'label') <- 'If yes, duration'

table('dis39s2_E3_C5')
pre.data$dis39s2_E3_C5 <- factor(
    dis39s2_E3_C5,
    levels = 1:4,
    labels = c('1-5 L/min', '6-10 L/min', '11-15 L/min', '>15 L/min')
)
attr(pre.data$dis39s2_E3_C5, 'label') <- 'If yes, oxygen flow'

table(dis39s3_E3_C5)
pre.data$dis39s3_E3_C5 <- factor(
    dis39s3_E3_C5,
    levels = 1:3,
    labels = c('Piped', 'Cylinder', 'Concentrator')
)
attr(pre.data$dis39s3_E3_C5, 'label') <- 'If yes, source of oxygen'

table(dis39s4_E3_C5)
pre.data$dis39s4_E3_C5 <- factor(
    dis39s4_E3_C5,
    levels = 1:5,
    labels = c(
        'Nasal prongs',
        'HF nasal cannula',
        'Mask',
        'Mask with reservoir',
        'CPAP/NIV mask'
    )
)
attr(pre.data$dis39s4_E3_C5, 'labels') <- 'If yes, interface'

table(dis40_E3_C5)
pre.data$dis40_E3_C5 <- nominal(dis40_E3_C5)
attr(pre.data$dis40_E3_C5, 'labels') <- 'Noninvasive ventilation'

table(dis40s_E3_C5) # change to number
attr(pre.data$dis40_E3_C5, 'label') <- 'If yes, duration'

table(dis41_E3_C5)
pre.data$dis41_E3_C5 <- nominal(dis41_E3_C5)
attr(pre.data$dis41_E3_C5, 'label') <- 'Invasive ventilation'


table(dis42_E3_C5)
pre.data$dis42_E3_C5 <- nominal(dis42_E3_C5)
attr(pre.data$dis42_E3_C5, 'label') <-
    'Extracorporeal (ECMO) support'

table(dis43_E3_C5)
pre.data$dis43_E3_C5 <- nominal(dis43_E3_C5)
attr(pre.data$dis43_E3_C5, 'label') <- 'Prone position'

table(dis45_E3_C5)
pre.data$dis45_E3_C5 <- nominal(dis45_E3_C5)
attr(pre.data$dis45_E3_C5, 'label') <- 'Inotropes/vasopressors'

table(dis44_E3_C5)
pre.data$dis44_E3_C5 <- nominal(dis44_E3_C5)
attr(pre.data$dis44_E3_C5, 'label') <-
    'Renal replacement therapy or dialysis'

# outcome

table('dis46_E3_C5')
pre.data$dis46_E3_C5 <- factor(
    dis46_E3_C5,
    levels = 1:6,
    labels = c(
        'Discharged alive',
        'Hospitalized',
        'Transfer to other facility',
        'Death',
        'Palliative discharge',
        'Unknown'
    )
)

attr(pre.data$dis46_E3_C5, 'label') <- 'Outcome'

summary(dis47_E3_C5)
attr(pre.data$dis47_E3_C5, 'label') <- 'Outcome date'

table(dis47s_E3_C5)
attr(pre.data$dis47s_E3_C5, 'label') <- 'Outcome date unknown'

table(dis48_E3_C5)
pre.data$dis48_E3_C5 <- factor(
    dis48_E3_C5,
    levels = 1:4,
    labels = c('Same as before illness', 'Worse', 'Better', 'Unknown')
)

attr(pre.data$dis48_E3_C5, 'label') <-
    'If discharged alive, ability to self care at discharge versus before illness'

saveRDS(object = pre.data, file = savedfilename)

detach(pre.data)

#rm(list = ls())
