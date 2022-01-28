#   ============================================================================
#   label variables
#   ============================================================================

require(sjlabelled)

attr(dta$site, 'label') <- 'Facility Name'
attr(dta$state, 'label') <- 'State'
attr(dta$mortality, 'label') <- 'Died'
attr(dta$study_time, 'label') <- 'Days from enrollment to outcome'
attr(dta$admission_time, 'label') <-
    'Days from admission to outcome'
attr(dta$o2, 'label') <- 'Oxygen therapy'
attr(dta$icu, 'label') <- 'ICU or HDU admission'
attr(dta$nvent, 'label') <- 'Non-invasive ventilation'
attr(dta$ivent, 'label') <- 'Invasive ventilation'
attr(dta$severity, 'label') <- 'Severity score'
attr(dta$age, 'label') <- 'Age'
attr(dta$age_group, 'label') <- 'Age group'
attr(dta$sex, 'label') <- 'Sex'
attr(dta$health_worker, 'label') <- 'Health care worker'
attr(dta$ccdx, 'label') <-
    'Chronic cardiac disease (not hypertension)'
attr(dta$diabetes, 'label') <- 'Diabetes'
attr(dta$hypertension, 'label') <- 'Hypertension'
attr(dta$smoking, 'label') <- 'Current smoking'
attr(dta$pulmonary_dx, 'label') <- 'Chronic pulmonary disease'
attr(dta$tb_active, 'label') <- 'Tuberculosis (active)'
attr(dta$tb_previous, 'label') <- 'Tuberculosis (previous)'
attr(dta$asthma, 'label') <- 'Asthma'
attr(dta$respiratory_dx, 'label') <- 'Respiratory disease'
attr(dta$asplenia, 'label') <- 'Asplenia'
attr(dta$ckd, 'label') <- 'Chronic kidney disease'
attr(dta$neoplasm, 'label') <- 'Malignant neopllasm'
attr(dta$chronic_liver_dx, 'label') <- 'Chronic liver disease'
attr(dta$neurologic_dx, 'label') <- 'Chronic neurologic disease'
attr(dta$hiv, 'label') <- 'HIV'
attr(dta$fever, 'label') <- 'History of fever'
attr(dta$chest_indrawing, 'label') <- 'Lower chest indrawing'
attr(dta$cough, 'label') <- 'Cough'
attr(dta$headache, 'label') <- 'Headache'
attr(dta$confusion, 'label') <- 'Altered consciousness/confusion'
attr(dta$seizures, 'label') <- 'Seizures'
attr(dta$sore_throat, 'label') <- 'Sore throat'
attr(dta$abd_pain, 'label') <- 'Abdominal pain'
attr(dta$runny_nose, 'label') <- 'Runny nose'
attr(dta$vomiting, 'label') <- 'Vomiting/nausea'
attr(dta$wheezing, 'label') <- 'Wheezing'
attr(dta$diarrhoea, 'label') <- 'Diarrhoea'
attr(dta$chest_pain, 'label') <- 'Chest pain'
attr(dta$conjunctivitis, 'label') <- 'Conjunctivitis'
attr(dta$muscle_aches, 'label') <- 'Muscle aches'
attr(dta$skin_rash, 'label') <- 'Skin rash'
attr(dta$joint_pain, 'label') <- 'Joint pain (arthralgia)'
attr(dta$skin_ulcers, 'label') <- 'Skin ulcers'
attr(dta$fatigue, 'label') <- 'Fatigue/malaise'
attr(dta$lymphadenopathy, 'label') <- 'Lymphadenopathy'
attr(dta$taste, 'label') <- 'Loss of taste'
attr(dta$inability_walk, 'label') <- 'Inability to walk'
attr(dta$smell, 'label') <- 'Loss of smell'
attr(dta$bleeding, 'label') <- 'Bleeding'
attr(dta$breath, 'label') <- 'Shortness of breath'
attr(dta$stroke, 'label') <- 'Stroke'
attr(dta$spo2, 'label') <- 'Oxygen saturation'
attr(dta$malaria, 'label') <- 'Malaria'
attr(dta$shock, 'label') <- 'Complication: shock'
attr(dta$bacteremia, 'label') <- 'Complication: bacteraemia'
attr(dta$seizures_c, 'label') <- 'Complication: seizures'
attr(dta$bleeding_c, 'label') <- 'Complication: bleeding'
attr(dta$meningitis, 'label') <-
    'Complication: meningitis/encephalitis'
attr(dta$endocarditis, 'label') <- 'Complication: endocarditis'
attr(dta$anaemia, 'label') <- 'Complication: anaemia'
attr(dta$myocarditis, 'label') <-
    'Complication: myocarditis/pericarditis'
attr(dta$arrhythmia, 'label') <- 'Complication: cardiac arrhythmia'
attr(dta$aki, 'label') <- 'Complication: acute renal injury'
attr(dta$arrest, 'label') <- 'Complication: cardiac arrest'
attr(dta$pancreatitis, 'label') <- 'Complication: pancreatitis'
attr(dta$pneumonia, 'label') <- 'Complication: pneumonia'
attr(dta$liver_dysfn, 'label') <- 'Complication: liver dysfunction'
attr(dta$bronchiolitis, 'label') <- 'Complication: bronchiolitis'
attr(dta$cardiomyopathy, 'label') <- 'Complication: cardiomyopathy'
attr(dta$ards, 'label') <-
    'Complication: acute respiratory distress syndrome'
attr(dta$stroke_c, 'label') <- 'Stroke'
attr(dta$acei_arb, 'label') <- 'ACE-i/ARB'
attr(dta$antiviral, 'label') <- 'Antiviral'
attr(dta$antiviral_med, 'label') <- 'Antiviral medication'
attr(dta$antibiotic, 'label') <- 'Antibiotic'
attr(dta$azithromycin, 'label') <- 'Azithromycin'
attr(dta$steroid, 'label') <- 'Corticosteroid'
attr(dta$steroid_agent, 'label') <- 'Corticosteroid agent'
attr(dta$antimalarial, 'label') <- 'Antimalarial'
attr(dta$chloroquine, 'label') <- 'CQ/HCQ'
attr(dta$nsaid, 'label') <- 'NSAIDs'
attr(dta$coagulate, 'label') <- 'Systemic anticoagulation'

#  add value labels

dta$age_group <-
    add_labels(dta$age_group,
               labels = c(`<18` = '<18 years',
                          `18-45` = '18-45 years',
                          `46-65` = '46-65 years',
                          `66-75` = '66-75 years',
                          `>75` = '>75 years'))
dta$mortality <-
    add_labels(dta$mortality, labels = c(`No` = 0, `Yes` = 1))
dta$o2 <- add_labels(dta$o2, labels = c(`No` = 0, `Yes` = 1))
dta$icu <- add_labels(dta$icu, labels = c(`No` = 0, `Yes` = 1))
dta$nvent <- add_labels(dta$nvent, labels = c(`No` = 0, `Yes` = 1))
dta$ivent <- add_labels(dta$ivent, labels = c(`No` = 0, `Yes` = 1))

dta$health_worker <-
    add_labels(dta$health_worker, labels = c(`No` = 0, `Yes` = 1))
dta$ccdx <- add_labels(dta$ccdx, labels = c(`No` = 0, `Yes` = 1))
dta$diabetes <-
    add_labels(dta$diabetes, labels = c(`No` = 0, `Yes` = 1))
dta$hypertension <-
    add_labels(dta$hypertension, labels = c(`No` = 0, `Yes` = 1))
dta$smoking <-
    add_labels(dta$smoking, labels = c(`No` = 0, `Yes` = 1))
dta$pulmonary_dx <-
    add_labels(dta$pulmonary_dx, labels = c(`No` = 0, `Yes` = 1))
dta$tb_active <-
    add_labels(dta$tb_active, labels = c(`No` = 0, `Yes` = 1))
dta$tb_previous <-
    add_labels(dta$tb_previous, labels = c(`No` = 0, `Yes` = 1))
dta$asthma <-
    add_labels(dta$asthma, labels = c(`No` = 0, `Yes` = 1))
dta$respiratory_dx <-
    add_labels(dta$respiratory_dx, labels = c(`No` = 0, `Yes` = 1))
dta$asplenia <-
    add_labels(dta$asplenia, labels = c(`No` = 0, `Yes` = 1))
dta$ckd <- add_labels(dta$ckd, labels = c(`No` = 0, `Yes` = 1))
dta$neoplasm <-
    add_labels(dta$neoplasm, labels = c(`No` = 0, `Yes` = 1))
dta$chronic_liver_dx <-
    add_labels(dta$chronic_liver_dx, labels = c(`No` = 0, `Yes` = 1))
dta$neurologic_dx <-
    add_labels(dta$neurologic_dx, labels = c(`No` = 0, `Yes` = 1))
dta$hiv <- add_labels(dta$hiv, labels = c(`No` = 0, `Yes` = 1))
dta$fever <- add_labels(dta$fever, labels = c(`No` = 0, `Yes` = 1))
dta$chest_indrawing <-
    add_labels(dta$chest_indrawing, labels = c(`No` = 0, `Yes` = 1))
dta$cough <- add_labels(dta$cough, labels = c(`No` = 0, `Yes` = 1))
dta$headache <-
    add_labels(dta$headache, labels = c(`No` = 0, `Yes` = 1))
dta$confusion <-
    add_labels(dta$confusion, labels = c(`No` = 0, `Yes` = 1))
dta$seizures <-
    add_labels(dta$seizures, labels = c(`No` = 0, `Yes` = 1))
dta$sore_throat <-
    add_labels(dta$sore_throat, labels = c(`No` = 0, `Yes` = 1))
dta$abd_pain <-
    add_labels(dta$abd_pain, labels = c(`No` = 0, `Yes` = 1))
dta$runny_nose <-
    add_labels(dta$runny_nose, labels = c(`No` = 0, `Yes` = 1))
dta$vomiting <-
    add_labels(dta$vomiting, labels = c(`No` = 0, `Yes` = 1))
dta$wheezing <-
    add_labels(dta$wheezing, labels = c(`No` = 0, `Yes` = 1))
dta$diarrhoea <-
    add_labels(dta$diarrhoea, labels = c(`No` = 0, `Yes` = 1))
dta$chest_pain <-
    add_labels(dta$chest_pain, labels = c(`No` = 0, `Yes` = 1))
dta$conjunctivitis <-
    add_labels(dta$conjunctivitis, labels = c(`No` = 0, `Yes` = 1))
dta$muscle_aches <-
    add_labels(dta$muscle_aches, labels = c(`No` = 0, `Yes` = 1))
dta$skin_rash <-
    add_labels(dta$skin_rash, labels = c(`No` = 0, `Yes` = 1))
dta$joint_pain <-
    add_labels(dta$joint_pain, labels = c(`No` = 0, `Yes` = 1))
dta$skin_ulcers <-
    add_labels(dta$skin_ulcers, labels = c(`No` = 0, `Yes` = 1))
dta$fatigue <-
    add_labels(dta$fatigue, labels = c(`No` = 0, `Yes` = 1))
dta$lymphadenopathy <-
    add_labels(dta$lymphadenopathy, labels = c(`No` = 0, `Yes` = 1))
dta$taste <- add_labels(dta$taste, labels = c(`No` = 0, `Yes` = 1))
dta$inability_walk <-
    add_labels(dta$inability_walk, labels = c(`No` = 0, `Yes` = 1))
dta$smell <- add_labels(dta$smell, labels = c(`No` = 0, `Yes` = 1))
dta$bleeding <-
    add_labels(dta$bleeding, labels = c(`No` = 0, `Yes` = 1))
dta$breath <-
    add_labels(dta$breath, labels = c(`No` = 0, `Yes` = 1))
dta$stroke <-
    add_labels(dta$stroke, labels = c(`No` = 0, `Yes` = 1))
dta$spo2 <- add_labels(dta$spo2, labels = c(`No` = 0, `Yes` = 1))
dta$malaria <-
    add_labels(dta$malaria, labels = c(`No` = 0, `Yes` = 1))
dta$shock <- add_labels(dta$shock, labels = c(`No` = 0, `Yes` = 1))
dta$bacteremia <-
    add_labels(dta$bacteremia, labels = c(`No` = 0, `Yes` = 1))
dta$seizures_c <-
    add_labels(dta$seizures_c, labels = c(`No` = 0, `Yes` = 1))
dta$bleeding_c <-
    add_labels(dta$bleeding_c, labels = c(`No` = 0, `Yes` = 1))
dta$meningitis <-
    add_labels(dta$meningitis, labels = c(`No` = 0, `Yes` = 1))
dta$endocarditis <-
    add_labels(dta$endocarditis, labels = c(`No` = 0, `Yes` = 1))
dta$anaemia <-
    add_labels(dta$anaemia, labels = c(`No` = 0, `Yes` = 1))
dta$myocarditis <-
    add_labels(dta$myocarditis, labels = c(`No` = 0, `Yes` = 1))
dta$arrhythmia <-
    add_labels(dta$arrhythmia, labels = c(`No` = 0, `Yes` = 1))
dta$aki <- add_labels(dta$aki, labels = c(`No` = 0, `Yes` = 1))
dta$arrest <-
    add_labels(dta$arrest, labels = c(`No` = 0, `Yes` = 1))
dta$pancreatitis <-
    add_labels(dta$pancreatitis, labels = c(`No` = 0, `Yes` = 1))
dta$pneumonia <-
    add_labels(dta$pneumonia, labels = c(`No` = 0, `Yes` = 1))
dta$liver_dysfn <-
    add_labels(dta$liver_dysfn, labels = c(`No` = 0, `Yes` = 1))
dta$bronchiolitis <-
    add_labels(dta$bronchiolitis, labels = c(`No` = 0, `Yes` = 1))
dta$cardiomyopathy <-
    add_labels(dta$cardiomyopathy, labels = c(`No` = 0, `Yes` = 1))
dta$ards <- add_labels(dta$ards, labels = c(`No` = 0, `Yes` = 1))
dta$stroke_c <-
    add_labels(dta$stroke_c, labels = c(`No` = 0, `Yes` = 1))
dta$acei_arb <-
    add_labels(dta$acei_arb, labels = c(`No` = 0, `Yes` = 1))
dta$antiviral <-
    add_labels(dta$antiviral, labels = c(`No` = 0, `Yes` = 1))
dta$antiviral_med <-
    add_labels(dta$antiviral_med, labels = c(`No` = 0, `Yes` = 1))
dta$antibiotic <-
    add_labels(dta$antibiotic, labels = c(`No` = 0, `Yes` = 1))
dta$azithromycin <-
    add_labels(dta$azithromycin, labels = c(`No` = 0, `Yes` = 1))
dta$steroid <-
    add_labels(dta$steroid, labels = c(`No` = 0, `Yes` = 1))
dta$steroid_agent <-
    add_labels(dta$steroid_agent, labels = c(`No` = 0, `Yes` = 1))
dta$antimalarial <-
    add_labels(dta$antimalarial, labels = c(`No` = 0, `Yes` = 1))
dta$chloroquine <-
    add_labels(dta$chloroquine, labels = c(`No` = 0, `Yes` = 1))
dta$nsaid <- add_labels(dta$nsaid, labels = c(`No` = 0, `Yes` = 1))
dta$coagulate <-
    add_labels(dta$coagulate, labels = c(`No` = 0, `Yes` = 1))
