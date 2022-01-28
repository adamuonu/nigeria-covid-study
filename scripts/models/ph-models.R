#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Regression models - Cox proportional hazards regression
#
#  We will first use mixed effects logistic regression to assess predictors of
#  mortality in hospitalized COVID-19 patients with site and facility type
#  as random intercepts.
#  However, because logistic regression does not account for baseline hazard,
#  we will also explore Cox regression with the site and facility type added as
#  shared frailty terms(coxph package) and also compare that approach to mixed
#  effects Cox regression (coxme package).
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

rm(list = ls())

options(scipen = 999)

#  load required packages -----------------------------------------------------

suppressPackageStartupMessages(require(survival))
suppressPackageStartupMessages(require(coxme))
suppressPackageStartupMessages(require(car))
suppressPackageStartupMessages(require(performance))
suppressPackageStartupMessages(require(gtsummary))
suppressPackageStartupMessages(require(ehahelper))
suppressPackageStartupMessages(require(broom))

#  load data  -----------------------------------------------------------------

cox_data <- readRDS(file = 'data/analysis/dta.rds')

# mixed effects cox regression model ------------------------------------------

#  null model with only the random effects

cox_model0 <- coxph(
    Surv(time = study_time, event = mortality, type = 'right') ~
        frailty(site, distribution = 'gaussian'), data = cox_data)

summary(cox_model0) # AIC 1419.5

# full model with all covariates

cox_model1 <-
    coxme(Surv(time = study_time, event = mortality, type = 'right') ~ severity
          # demographics
          + age_group
          + male
          + health_worker
          # comorbidities
          + ccdx
          + diabetes
          + hypertension
          + smoking
          + respiratory_dx
          + ckd
          + malaria
          + hiv
          # medications
          + antiviral
          + acei_arb
          + azithromycin
          + steroid
          + chloroquine
          + nsaid
          + coagulate
          + azithromycin:chloroquine
          + (1 | site)
          + (1 | facility_type),
          data = cox_data
)

summary(cox_model1)
# AIC 1083.1

Anova(cox_model1)

#  reduced model

cox_model2 <-
    coxme(Surv(time = study_time, event = mortality, type = 'right') ~ severity
          # demographics
          + age_group
          + male
          + health_worker
          # comorbidities
          + ccdx
          + diabetes
          + respiratory_dx
          + ckd
          + malaria
          # medications
          + azithromycin
          + chloroquine
          + azithromycin:chloroquine
          + (1 | site)
          + (1 | facility_type),
          data = cox_data
    )

summary(cox_model2)
performance_aic(cox_model2)

cox_model2 <-
    coxme(Surv(time = study_time, event = mortality, type = 'right') ~ severity
          # demographics
          + age_group
          + male
          + health_worker
          # comorbidities
          + ccdx
          + diabetes
          + respiratory_dx
          + ckd
          + malaria
          # medications
          + azithromycin
          + chloroquine
          + azithromycin:chloroquine
          + (1 | site)
          + (1 | facility_type),
          data = cox_data
    )

summary(cox_model2)
Anova(cox_model2)


#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  model performance
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

performance_aic(cox_model1)
performance_aic(cox_model2)

#  compare both models using LR
# x <- -2*logLik(log_model2)[1] + 2*logLik(log_model3)[1]
# 1 - pchisq(x, df = 2)

lmtest::lrtest(cox_model1, cox_model2)

#  view nicely formatted results ----------------------------------------------

# cox_fit2 <- tidy(cox_model2, exponentiate = TRUE)
# cox_fit3 <- tidy(cox_model3)

library(parameters)

md <- model_parameters(model = cox_model2, exponentiate = TRUE, summary = TRUE)
md <- tidy(md)

tbl_regression(
    x = cox_model2,
    exponentiate = TRUE,
    pvalue_fun = function(x) style_pvalue(x, digits = 3)
) %>%
    add_glance_source_note(
        label = list(nobs ~ "Number of observations", nevent ~ "Number of events"),
        include = c(nobs, nevent, logLik, AIC)
    )


#  save regression models  ----------------------------------------------------

attr(cox_model1, 'description') <- 'Mixed effects cox model - full'
attr(cox_model2, 'description') <- 'Mixed effects cox model - reduced with interactions'

coxph_models <- list(
    `Model 1` = cox_model1,
    `Model 2` = cox_model2
)

saveRDS(object = coxph_models, file = 'models/coxph_models.rds')
