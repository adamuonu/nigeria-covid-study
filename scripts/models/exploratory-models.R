#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Regression models
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

rm(list = ls())

library(tidyverse)
library(survival)
library(ggfortify)
library(coxme)
library(lme4)
library(gtsummary)
library(sjPlot)
library(sjmisc)
library(sjlabelled)
library(colorspace)

dta <- readRDS(file = 'data/cleaned/covid_data.rds')
dta <- dta %>% filter(!(state %in% c('Delta','Taraba')))
dta <- dta %>% mutate(male = case_when(sex == 'Male' ~ 1, TRUE ~ 0))
attr(dta$male, 'label') <- 'Male'
dta$male <- sjlabelled::add_labels(dta$male, labels = c(`No` = 0, `Yes` = 1))

svars <- c('site', 'state', 'study_time', 'mortality', 'severity', 'age', 'age_group', 'male',
           'health_worker', 'ccdx', 'diabetes', 'hypertension', 'smoking', 'respiratory_dx',
           'neurologic_dx', 'neoplasm',
           'ckd', 'malaria', 'hiv', 'antiviral', 'acei_arb','azithromycin', 'steroid',
           'chloroquine','nsaid', 'coagulate', 'icu', 'nvent', 'ivent', 'o2')


dtb <- dta %>% select(all_of(svars))
dtb$state <- factor(dtb$state)
dtb$site  <- factor(dtb$site)

# create new variables for type of hospital: tertiary, non-tertiary, other treatment facility
dtb$facility_type <- 'Non-tertiary hospital'
dtb$facility_type[grepl('Teaching', dtb$site)] <- 'Tertiary hospital'
dtb$facility_type[grepl('Federal', dtb$site)] <- 'Tertiary hospital'
dtb$facility_type[grepl('College', dtb$site)] <- 'Tertiary hospital'

dtb$facility_type[grepl('Amachara', dtb$site)] <- 'Other treatment facility'
dtb$facility_type[grepl('FCT Home', dtb$site)] <- 'Other treatment facility'
dtb$facility_type[grepl('Ikenne', dtb$site)] <- 'Other treatment facility'
dtb$facility_type[grepl('Thisday', dtb$site)] <- 'Other treatment facility'
dtb$facility_type[grepl('Agbami', dtb$site)] <- 'Other treatment facility'
dtb$facility_type[grepl('Unsari', dtb$site)] <- 'Other treatment facility'

attr(dtb$facility_type, 'label') <- 'Type of facility'

dtb$facility_type <- factor(dtb$facility_type,
                            levels = c('Non-tertiary hospital',
                                       'Tertiary hospital',
                                       'Other treatment facility')
                            )

dtc <- dtb[complete.cases(dtb), ]

dtb$mortality <- factor(dtb$mortality, levels = 0:1, labels = c('No','Yes'))

saveRDS(object = dtb, file = 'data/analysis/dtb.rds')
saveRDS(object = dtc, file = 'data/analysis/dta.rds')


dtb$male <- factor(dtb$male, levels = 0:1, labels = c('No','Yes'))
dtb$health_worker <- factor(dtb$health_worker, levels = 0:1, labels = c('No','Yes'))
dtb$ccdx <- factor(dtb$ccdx, levels = 0:1, labels = c('No','Yes'))
dtb$diabetes <- factor(dtb$diabetes, levels = 0:1, labels = c('No','Yes'))
dtb$hypertension <- factor(dtb$hypertension, levels = 0:1, labels = c('No','Yes'))
dtb$smoking <- factor(dtb$smoking, levels = 0:1, labels = c('No','Yes'))
dtb$respiratory_dx <- factor(dtb$respiratory_dx, levels = 0:1, labels = c('No','Yes'))
dtb$neurologic_dx <- factor(dtb$neurologic_dx, levels = 0:1, labels = c('No','Yes'))
dtb$neoplasm <- factor(dtb$neoplasm, levels = 0:1, labels = c('No','Yes'))
dtb$ckd <- factor(dtb$ckd, levels = 0:1, labels = c('No','Yes'))
dtb$malaria <- factor(dtb$malaria, levels = 0:1, labels = c('No','Yes'))
dtb$hiv <- factor(dtb$hiv, levels = 0:1, labels = c('No','Yes'))
dtb$antiviral <- factor(dtb$antiviral, levels = 0:1, labels = c('No','Yes'))
dtb$acei_arb <- factor(dtb$acei_arb, levels = 0:1, labels = c('No','Yes'))
dtb$azithromycin <- factor(dtb$azithromycin, levels = 0:1, labels = c('No','Yes'))
dtb$steroid <- factor(dtb$steroid, levels = 0:1, labels = c('No','Yes'))
dtb$chloroquine <- factor(dtb$chloroquine, levels = 0:1, labels = c('No','Yes'))
dtb$nsaid <- factor(dtb$nsaid, levels = 0:1, labels = c('No','Yes'))
dtb$coagulate <- factor(dtb$coagulate, levels = 0:1, labels = c('No','Yes'))


attr(dtb$mortality, 'label') <- 'Died'
attr(dtb$male, 'label') <- 'Male'
attr(dtb$health_worker, 'label') <- 'Healthcare worker'
attr(dtb$ccdx, 'label') <- 'Chronic cardiac disease (not hypertension)'
attr(dtb$diabetes, 'label') <- 'Diabetes'
attr(dtb$hypertension, 'label') <- 'Hypertension'
attr(dtb$smoking, 'label') <- 'Current smoking'
attr(dtb$respiratory_dx, 'label') <- 'Respiratory disease'
attr(dtb$neurologic_dx, 'label') <- 'Neurologic disease'
attr(dtb$neoplasm, 'label') <- 'Malignant neoplasm'
attr(dtb$ckd, 'label') <- 'Chronic kidney disease'
attr(dtb$malaria, 'label') <- 'Malaria'
attr(dtb$hiv, 'label') <- 'HIV'
attr(dtb$antiviral, 'label') <- 'Antiviral medication'
attr(dtb$acei_arb, 'label') <- 'ACE-i/ARB'
attr(dtb$azithromycin, 'label') <- 'Azithromycin'
attr(dtb$steroid, 'label') <- 'Corticosteroid'
attr(dtb$chloroquine, 'label') <- 'Chloroquine'
attr(dtb$nsaid, 'label') <- 'NSAIDs'
attr(dtb$coagulate, 'label') <- 'Systemic coagulation'

dtc <- dtb[complete.cases(dtb), ]

saveRDS(object = dtb, file = 'data/analysis/dtbf.rds')
saveRDS(object = dtc, file = 'data/analysis/dtaf.rds')

# dtd <- dta %>% select(!c(admission_time, study_time, spo2, antiviral_med))
# dte <- dtd[complete.cases(dtd), ]


#  Explore Models:
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

options(scipen = 999)

lset <- dtb[!is.na(dtb$age_group), ]

#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Logistic regression model - initial model  ---------------------------------
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fit0 <- glm(mortality ~ severity
            + age_group
            + male
            + health_worker
            + ccdx
            + diabetes
            + hypertension
            + smoking
            + respiratory_dx
            + ckd
            + malaria
            + hiv
            + antiviral
            + acei_arb
            + azithromycin
            + steroid
            + chloroquine
            + coagulate,
            data = lset,
            family = binomial()
            )

tbl_regression(
    fit0,
    exponentiate = TRUE,
    pvalue_fun = function(x)
        style_pvalue(x, digits = 3)
)

#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Logistic regression model - reduced model
#
#  Let's find the most parsimonious model, however do note that by not
#  accounting for the clustering due to sites and also possible site-specific
#  characteristics impact on mortality (doctors, equipment, etc), estimates
#  are likely to be biased.
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MASS::stepAIC(fit0)

fit1 <- glm(mortality ~ severity
            + age_group
            + male
            + health_worker
            + ccdx
            + diabetes
            + respiratory_dx
            + ckd
            + acei_arb
            + azithromycin
            + steroid,
            data = lset,
            family = binomial()
)

car::Anova(fit1)

tbl_regression(
    fit1,
    exponentiate = TRUE,
    pvalue_fun = function(x)
        style_pvalue(x, digits = 3)
)

performance::test_lrt(fit0, fit1)

attr(fit0, 'description') <- 'Initial logistic regression model'
attr(fit1, 'description') <- 'Final logistic regression model'

save(fit0, file = 'models/fit0.rdata')
save(fit1, file = 'models/fit1.rdata')


#  Mixed effects Logistic regression model - initial model  -------------------
#
#  We need to account for effect of site on mortality.
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mfit0 <- glmer(mortality ~ severity
              + age_group
              + male
              + health_worker
              + ccdx
              + diabetes
              + hypertension
              + smoking
              + respiratory_dx
              + ckd
              + malaria
              + hiv
              + antiviral
              + acei_arb
              + azithromycin
              + steroid
              + chloroquine
              + coagulate
              + (1 | site),
              data = lset,
              family = binomial(),
              control = glmerControl(optimizer = 'bobyqa'),
              nAGQ = 15
              )

car::Anova(mfit0)

tbl_regression(
    mfit0,
    exponentiate = TRUE,
    pvalue_fun = function(x)
        style_pvalue(x, digits = 3)
)

#  ~~ reduced model
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  ~~ remove antiviral
#  ~~ remove hiv
#  ~~ remove hypertension
#  ~~ remove azithromycin
#  ~~ remove acei_arb
#  ~~ remove steroid
#  ~~ remove smoking
#  ~~ remove coagulate
#  ~~ remove malaria

mfit1 <- glmer(mortality ~ severity
               + age_group
               + male
               + health_worker
               + ccdx
               + diabetes
               + respiratory_dx
               + ckd
               + chloroquine
               + (1 | site),
               data = lset,
               family = binomial(),
               control = glmerControl(optimizer = 'bobyqa'),
               nAGQ = 15
)

# ~~ with interaction effect

mfit2 <- glmer(mortality ~ severity
               + age_group
               + male
               + health_worker
               + ccdx
               + diabetes
               + respiratory_dx
               + ckd
               + azithromycin
               + chloroquine
               + azithromycin:chloroquine
               + (1 | site),
               data = lset,
               family = binomial(),
               control = glmerControl(optimizer = 'bobyqa'),
               nAGQ = 15
)

car::Anova(mfit1)

tbl_regression(
    mfit1,
    exponentiate = TRUE,
    pvalue_fun = function(x)
        style_pvalue(x, digits = 3)
)


attr(mfit0, 'description') <- 'Initial mixed methods logistic regression model'
attr(mfit1, 'description') <- 'Final mixed methods logistic regression model'
attr(mfit2, 'description') <- 'Final mixed methods logistic regression model with interaction'

save(mfit0, file = 'models/initial_mixed_model.rdata')
save(mfit1, file = 'models/final_mixed_model.rdata')
save(mfit2, file = 'models/final_mixed_model_w_interaction.rdata')


y <- ggeffects::ggeffect(mfit1, terms = c('severity', 'chloroquine'))

plot(y)

#   Survival analysis  --------------------------------------------------------

library(ggpubr)
library(ggthemes)
library(ggsci)
library(see)
library(survminer)

#  Set color palette

ageg_pal <- rainbow_hcl(n = 8, alpha = 0.95)

plot_KM <- function(x) {
    ggsurvplot(fit           = x,
               palette       = 'RdBu',
               legend        = 'right',
               legend.title  = 'Age groups',
               legend.labs   = lbls,
               break.time.by = 7,
               censor        = TRUE,
               censor.shape  = '|',
               censor.size   = 2.5,
               risk.table    = FALSE,
               size          = .9,
               xlab          = 'Days',
               ggtheme       = theme_pubclean()
    )
}

km_agegroup <- survfit(
    Surv(study_time, mortality) ~ age_group,
    data = dtc,
    stype = 1,
    ctype = 1)

op <- par(xaxs = 'i', yaxs = 'i')

lbls <- levels(dtc$age_group)

ggsurvplot(fit = km_agegroup,
           palette       = 'RdBu',
           legend        = 'right',
           legend.title  = 'Age groups',
           legend.labs   = lbls,
           break.time.by = 7,
           pval          = 'p < 0.001',
           censor        = TRUE,
           censor.shape  = '|',
           censor.size   = 2.5,
           risk.table    = FALSE,
           size          = .9,
           xlab          = 'Days',
           #xlim          = c(0, 84),
           #ylim          = c(0, 1),
           axes.offset   = TRUE,
           ggtheme       = theme_light()
           #tables.height = 0.2,
           #tables.theme = theme_cleantable()
           )

plot_KM(x = km_agegroup)

+ male
+ health_worker
+ ccdx
+ diabetes
+ hypertension
+ smoking
+ respiratory_dx
+ ckd
+ malaria
+ hiv
+ antiviral
+ acei_arb
+ azithromycin
+ steroid
+ chloroquine
+ coagulate


#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Mixed effects Cox regression model - initial model
#
#  We need to account for effect of site on mortality.
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cset <- lset[!is.na(lset$study_time), ]

#  remove observations with missing study time
#  Cox regression model not accounting for site effects

cfit0 <-
    coxph(
        Surv(time = study_time, event = mortality, type = 'right') ~ severity
        + age_group
        + male
        + health_worker
        + ccdx
        + diabetes
        + hypertension
        + smoking
        + respiratory_dx
        + ckd
        + malaria
        + hiv
        + antiviral
        + acei_arb
        + azithromycin
        + steroid
        + chloroquine
        + coagulate
        + frailty(site),
        data = cset,
        control = coxph.control(iter.max = 40)
    )

car::Anova(cfit0)

tbl_regression(
    mfit0,
    exponentiate = TRUE,
    pvalue_fun = function(x)
        style_pvalue(x, digits = 3)
)

MASS::stepAIC(cfit0)

cfit1 <-
    coxph(
        Surv(time = study_time, event = mortality, type = "right") ~ severity
        + age_group
        + male
        + ccdx
        + diabetes
        + respiratory_dx
        + ckd
        + malaria
        + acei_arb
        + azithromycin
        + steroid,
      data = cset)

tbl_regression(
    cfit1,
    exponentiate = TRUE,
    pvalue_fun = function(x)
        style_pvalue(x, digits = 3)
)

#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Mixed effects Cox regression
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mcfit0 <-
    coxme(
        Surv(time = study_time, event = mortality, type = 'right') ~ severity
        + age_group
        + male
        + health_worker
        + ccdx
        + diabetes
        + hypertension
        + smoking
        + respiratory_dx
        + ckd
        + malaria
        + hiv
        + antiviral
        + acei_arb
        + azithromycin
        + steroid
        + chloroquine
        + coagulate
        + (1 | site),
        data = cset
    )

car::Anova(mcfit0)


tbl_regression(
    mcfit0,
    exponentiate = TRUE,
    pvalue_fun = function(x)
        style_pvalue(x, digits = 3)
)

performance::performance_aic(mcfit0)

# ~~ remove steroid
# ~~ remove hypertension
# ~~ antiviral
# ~~ azithromycin
# ~~ smoking
# ~~ acei_arb
# ~~ hiv
# ~~ coagulate

mcfit1 <-
    coxme(
        Surv(time = study_time, event = mortality, type = 'right') ~ severity
        + age_group
        + male
        + health_worker
        + ccdx
        + diabetes
        + respiratory_dx
        + ckd
        + malaria
        + azithromycin
        + chloroquine
        + azithromycin:chloroquine
        + (1 | site),
        data = cset
    )

performance::performance_aic(mcfit1)
car::Anova(mcfit1)

# above model has the smallest AIC, removing health worker increases the AIC
# (decreases the likelihood)

stem(exp(ranef(mcfit1)[[1]]))

tbl_regression(
    mcfit1,
    exponentiate = TRUE,
    pvalue_fun = function(x)
        style_pvalue(x, digits = 3)
)
