#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Regression models - Logistic regression
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

suppressPackageStartupMessages(require(lme4))
suppressPackageStartupMessages(require(car))
suppressPackageStartupMessages(require(performance))
suppressPackageStartupMessages(require(gtsummary))
suppressPackageStartupMessages(require(ggeffects))
suppressPackageStartupMessages(require(sjPlot))

#  load data  -----------------------------------------------------------------

log_data <- readRDS(file = 'data/analysis/dtb.rds')

# mixed effects logistic regression model -------------------------------------

#  null model with only the random effects

log_model0 <- glmer(
    mortality ~ (1 | site) + (1 | facility_type),
    data = log_data,
    family = binomial(link = 'logit'),
    control = glmerControl(optimizer = 'bobyqa')
)

summary(log_model0)
# AIC 1412.1


# full model with all covariates

log_model1 <-
    glmer(mortality ~ severity
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
          + neoplasm
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
          data = log_data,
          family = binomial(link = 'logit'),
          control = glmerControl(optimizer = 'bobyqa')
)

summary(log_model1)
# AIC 1061.0
tab_model(log_model1)
Anova(log_model1)

tbl_regression(
    log_model1,
    exponentiate = TRUE,
    pvalue_fun = function(x)
        style_pvalue(x, digits = 3)
)

#  reduced model

log_model3 <-
    glmer(mortality ~ severity
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
          data = log_data,
          family = binomial(link = 'logit'),
          control = glmerControl(optimizer = 'bobyqa')
    )

summary(log_model2)

Anova(log_model2)
glance(log_model2)

#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  model performance
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

performance_aic(log_model1)
performance_aic(log_model2)

#  compare both models using LR
# x <- -2*logLik(log_model2)[1] + 2*logLik(log_model3)[1]
# 1 - pchisq(x, df = 2)

performance_lrt(log_model1, log_model2)

r2(model = log_model1)
r2(model = log_model2)

#  view nicely formatted results ----------------------------------------------

tbl_regression(
    x = log_model2,
    exponentiate = TRUE,
    pvalue_fun = function(x)
        style_pvalue(x, digits = 3),
    tidy_fun = broom.mixed::tidy,
) %>%
    add_glance_source_note(
        include = c(logLik, AIC)
    )

#  save regression models  ----------------------------------------------------

attr(log_model1, 'description') <- 'Mixed effects logistic model - full'
attr(log_model2, 'description') <- 'Mixed effects logistic model - reduced with interactions'

log_models <- list(
    `Model 1` = log_model1,
    `Model 2` = log_model2
)

saveRDS(object = log_models, file = 'models/log_models.rds')
