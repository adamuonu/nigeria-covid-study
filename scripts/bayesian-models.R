#'  ---------------------------------------------------------------------------
#'  Bayesian models
#'  ---------------------------------------------------------------------------

rm(list = ls())

suppressPackageStartupMessages(library(brms))
suppressPackageStartupMessages(library(sjPlot))
suppressPackageStartupMessages(library(sjmisc))
suppressPackageStartupMessages(library(sjstats))
suppressPackageStartupMessages(library(ggeffects))
suppressPackageStartupMessages(library(broom))
suppressPackageStartupMessages(library(broom.mixed))
suppressPackageStartupMessages(library(performance))
suppressPackageStartupMessages(library(bayestestR))
suppressPackageStartupMessages(library(gtsummary))

options(scipen = 999)
options(mc.cores = parallel::detectCores())

seed = 123456

dta <- readRDS(file = 'data/analysis/dta.rds')

#  Set priors  ----------------------------------------------------------------

priors <-
    c(prior(normal(0, 1), class = Intercept),
      prior(normal(0, 1), class = b),
      prior(cauchy(0, 1), class = sd))

#  Run bayesian regression ----------------------------------------------------

bfit0 <- brm(
    mortality ~ severity
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
    data = dta,
    family = bernoulli(link = 'logit'),
    prior = priors,
    iter = 2000,
    warmup = 1000,
    chains = 4,
    cores = 4,
    seed = seed
    #     control = list(adapt_delta = .9)
)

print(bfit0, digits = 3)
shinystan::launch_shinystan(bfit0)
tab_model(bfit0, digits = 3, prefix.labels = 'varname', show.intercept = FALSE)
p_map(bfit0)

#  --azithromycin
#  --antiviral

bfit1 <- brm(
    mortality ~ severity
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
    + acei_arb
    + steroid
    + chloroquine
    + coagulate
    + (1 | site),
    data = dta,
    family = bernoulli(link = 'logit'),
    prior = priors,
    iter = 2000,
    warmup = 1000,
    chains = 4,
    cores = 4,
    seed = seed
    #     control = list(adapt_delta = .9)
)

p_map(bfit1)
tab_model(bfit1, digits = 3, prefix.labels = 'varname', show.intercept = FALSE)


# Model Performance                                                         ----
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# https://easystats.github.io/performance/index.html
#
# For mixed models, the conditional and marginal r-squared are returned.
# The marginal r-squared considers only the variance of the fixed effects and
# indicates how much of the model’s variance is explained by the fixed effects
# part only. The conditional r-squared takes both the fixed and random effects
# into account and indicates how much of the model’s variance is explained by
# the “complete” model.
#
# Similar to r-squared, the ICC provides information on the explained variance
# and can be interpreted as “the proportion of the variance explained by the
# grouping structure in the population” (Hox 2010).

library(performance)


##  /////////////////////////////////////////////////////////////////////////////
##  Marginal effects plots ----
##
##  To better understand the relationship of the predictors with the response,
##  I recommend the conditional_effects method:
##  /////////////////////////////////////////////////////////////////////////////

plot_model(model = r1_2a, colors = "black")

plot_model(model = r1_2a, type = "pred",
           terms = c("hml32","v025","v024"),
           ri.nr = c(1,2),
           se = TRUE,
           colors = 'gs',
           grid = TRUE,
           bpe = "mean",
           bpe.style = "dot",
           ppd = TRUE)
