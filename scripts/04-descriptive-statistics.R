#'  ===========================================================================
#'  04-descriptive-statistics.R
#'
#'  @description Generate descriptive statistics
#'  @author:     A. Onu
#'  @date:       2021-09-27
#'  ===========================================================================

rm(list = ls())

options(scipen = 999)

#  Load required packages  ----------------------------------------------------

# suppressPackageStartupMessages(require(tableone))
suppressPackageStartupMessages(require(tidyverse))
suppressPackageStartupMessages(require(gtsummary))

#  Load data  -----------------------------------------------------------------

dta <- readRDS(file = 'data/cleaned/covid_data.rds')

#  Demographics  --------------------------------------------------------------

sub_dta <- dta %>% select(mortality,
                            admission_time,
                            age,
                            age_group,
                            sex,
                            health_worker,
                            ccdx,
                            diabetes,
                            hypertension,
                            smoking,
                            respiratory_dx,
                            ckd,
                            hiv,
                            malaria,
                            antiviral,
                            acei_arb,
                            azithromycin,
                            steroid,
                            chloroquine,
                            nsaid,
                            coagulate,
                            severity)

table_1 <-
    tbl_summary(data = sub_dta, by = 'mortality', missing = 'ifany', missing_text = "Missing") %>%
    add_p(test.args = age_group ~ list(simulate.p.value = TRUE, B = 5000),
          pvalue_fun = function(x) style_pvalue(x, digits = 3)) %>%
    modify_header(label = "**Variables**") %>%
    modify_caption(caption = "Patient characteristics") %>%
    bold_labels()

table_1



