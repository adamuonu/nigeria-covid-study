rm(list = ls())

library(survival)
library(survminer)
library(ggplot2)
#library(ggfortify)
library(ggthemes)
library(ggpubr)
library(ggsci)
library(sjPlot)
library(RColorBrewer)

#  ~~ Data set for survival analysis (observations missing time variable dropped)

dta <- readRDS('data/analysis/dta.rds')

St <- with(dta, Surv(time = study_time, event = mortality, type = 'right'))

# -- Generate K-M estimates ----

# km_age <- survfit(St ~ age_group, data = dta)
# km_male <- survfit(St ~ male, data = dta)
# km_hcw <- survfit(St ~ health_worker, data = dta)
# km_ccdx <- survfit(St ~ ccdx, data = dta)
# km_dm <- survfit(St ~ diabetes, data = dta)
# km_htn <- survfit(St ~ hypertension, data = dta)
# km_smk <- survfit(St ~ smoking, data = dta)
# km_res <- survfit(St ~ respiratory_dx, data = dta)
# km_neo <- survfit(St ~ neoplasm, data = dta)
# km_ckd <- survfit(St ~ckd, data = dta)
# km_hiv <- survfit(St ~hiv, data = dta)
# km_malr <- survfit(St ~ malaria, data = dta)
# km_antv <- survfit(St ~ antiviral, data = dta)
# km_acei <- survfit(St ~ acei_arb, data = dta)
# km_azt <- survfit(St ~azithromycin, data = dta)
# km_ster <- survfit(St ~ steroid, data = dta)
# km_chq <- survfit(St ~chloroquine, data = dta)
# km_nsd <- survfit(St ~nsaid, data = dta)
# km_coag <- survfit(St ~ coagulate, data = dta)

#  Generate K-M plots ----

# km.pal <- c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E")
#
# km_autoplot <- function(x, name, lbls = c('No', 'Yes')) {
#
#     x_diff = survdiff(St ~ get(x), data = dta)
#     x_fit  = survfit(St ~ get(x), data = dta)
#     x_stat = broom::glance(x_diff)
#
#     p.val <- ifelse(
#         x_stat$p.value < 0.001, "< 0.001", paste0(" == ", format(round(x_stat$p.value, 3), nsmall = 3)))
#
#     annotate_pval <- paste0(
#         "\u3c7[", x_stat$df, "]^2 == ", round(x_stat$statistic, 1), "~italic(p) ", p.val)
#
#     p <-
#         autoplot(
#             object        = x_fit,
#             surv.connect  = F,
#             surv.size     = 0.5,
#             surv.alpha    = 0.7,
#             censor.colour = 'strata',
#             censor.alpha  = 0.7,
#             conf.int      = F,
#             xlab          = 'Days from enrollment',
#             ylab          = 'Survival probability'
#             ) +
#         ggtitle(label = name, ) +
#         #theme_sjplot() +
#         theme(plot.title = element_text(size = 11, face = 'bold'),
#               legend.position = c(0.15, 0.2),
#               legend.title    = element_blank(),
#               legend.key.size = unit(0.8, 'lines'),
#               legend.text     = element_text(size = 10, face = 'italic')) +
#         scale_y_continuous(labels = scales::percent, limits = c(0.3, 1)) +
#         scale_color_npg( labels = lbls) +
#         annotate(geom = 'text', x = 65, y = 0.4, parse = TRUE,
#                  label = annotate_pval, size = 3)
#
#     return(p)
# }

ggkm <- function(x,
                 lbls = c('No', 'Yes'),
                 name = '') {
    p <-
        ggsurvplot(
            fit              = x,
            data             = dta,
            censor.size      = 3,
            pval             = T,
            pval.method      = T,
            pval.coord       = c(65, 0.40),
            pval.size        = 3,
            pval.method.size = 3,
            pval.method.coord = c(65, 0.44),
            ggtheme          = theme_gray(),
            palette          = 'jama',
            break.time.by    = 7,
            ylim             = c(0.3, 1),
            surv.scale       = 'percent',
            legend.title     = name,
            legend           = c(0.15, 0.2),
            legend.labs      = lbls,
            xlab             = 'Days from enrollment',
            font.main        = 9,
            font.x           = 9,
            font.y           = 9,
            font.legend      = 8,
            size             = 0.5
        )

    return(p)
}

#  demographics ----

age_fit <- survfit(St ~ age_group, data = dta)
age_km  <- ggkm(x = age_fit, lbls = levels(dta$age_group), name = 'Age (years)')

male_fit <- survfit(St ~ male, data = dta)
male_km <- ggkm(x = male_fit, lbls = c('Female', 'Male'), name = 'Sex')

hcw_fit <- survfit(St ~ health_worker, data = dta)
hcw_km <- ggkm(x = hcw_fit, name = 'Healthcare worker')

#  comorbidity  ----
ccdx_fit <- survfit(St ~ health_worker, data = dta)
ccdx_km <- ggkm(x = ccdx_fit, name = 'Chronic cardiac disease')

dm_fit <- survfit(St ~ diabetes, data = dta)
dm_km <- ggkm(x = dm_fit, name = 'Diabetes')

htn_fit <- survfit(St ~ hypertension, data = dta)
htn_km <- ggkm(x = htn_fit, name = 'Hypertension')

smk_fit <- survfit(St ~ smoking, data = dta)
smk_km <- ggkm(x = smk_fit, name = 'Current smoking')

res_fit <- survfit(St ~ respiratory_dx, data = dta)
res_km <- ggkm(x = res_fit, name = 'Respiratory disease')

neo_fit <- survfit(St ~ neoplasm, data = dta)
neo_km <- ggkm(x = neo_fit, name = 'Malignant neoplasm')

ckd_fit <- survfit(St ~ ckd, data = dta)
ckd_km <- ggkm(x = ckd_fit, name = 'Chronic kidney disease')

hiv_fit <- survfit(St ~ hiv, data = dta)
hiv_km <- ggkm(x = hiv_fit, name = 'HIV')

malr_fit <- survfit(St ~ malaria, data = dta)
malr_km <- ggkm(x = ccdx_fit, name = 'Malaria')

#  medications ----

antv_fit <- survfit(St ~ antiviral, data = dta)
antv_km <- ggkm(x = antv_fit, name = 'Antiviral medication')

acei_fit <- survfit(St ~ acei_arb, data = dta)
acei_km  <- ggkm(x = acei_fit, name = 'ACE-i/ARB')

azt_fit <- survfit(St ~ azithromycin, data = dta)
azt_km  <- ggkm(x = azt_fit, name = 'Azithromycin')

ster_fit <- survfit(St ~ steroid, data = dta)
ster_km  <- ggkm(x = ster_fit, name = 'Steroid')

chq_fit <- survfit(St ~ chloroquine, data = dta)
chq_km  <- ggkm(x = chq_fit, name = 'Chloroquine/\nHydroxchloroquine')

nsd_fit <- survfit(St ~ nsaid, data = dta)
nsd_km  <- ggkm(x = nsd_fit, name = 'NSAIDs')

coag_fit <- survfit(St ~ coagulate, data = dta)
coag_km <- ggkm(x = coag_fit, name = 'Systemic coagulation')

#  save objects ----

splots <- list(
    'age group'              = age_km,
    sex                      = male_km,
    'health worker'          = hcw_km,
    'cardiac disease'        = ccdx_km,
    diabetes                 = dm_km,
    hypertension             = htn_km,
    smoking                  = smk_km,
    'respiratory disease'    = res_km,
    neoplasm                 = neo_km,
    'chronic kidney disease' = ckd_km,
    hiv                      = hiv_km,
    malaria                  = malr_km,
    antiviral                = antv_km,
    'ace inhibitors'         = acei_km,
    azithromycin             = azt_km,
    steroid                  = ster_km,
    chloroquine              = chq_km,
    nsaids                   = nsd_km,
    coagulation              = coag_km
)


saveRDS(object = splots, file = 'graphics/KM_plots.rds')

