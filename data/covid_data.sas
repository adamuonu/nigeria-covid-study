* Written by R;
*  foreign::write.foreign(df = covid_data, datafile = "covid_data.csv",  ;

PROC FORMAT;
value site 
     1 = "Amachara Isolation Centre" 
     2 = "Bingham University Teaching Hospital" 
     3 = "FCT Home Base Care" 
     4 = "Federal Medical Center Idi Aba Abeokuta" 
     5 = "Federal Medical Center, Asaba" 
     6 = "Federal Medical Centre Birnin-Kebbi" 
     7 = "Federal Medical Centre, Owo" 
     8 = "Federal Medical Centre, Yola" 
     9 = "General Hospital Abakaliki" 
     10 = "General Hospital Minna" 
     11 = "General Hospital Riyom" 
     12 = "Ikenne Isolation Centre" 
     13 = "Infectious Disease Center, Specialist Hospital Yola" 
     14 = "Infectious Disease Hospital, Olodo" 
     15 = "Infectious Diseases Hospital, Akure" 
     16 = "Jos University Teaching Hospital" 
     17 = "Kapital Klub Isolation And Treatment Centre" 
     18 = "Lagos University Teaching Hospital" 
     19 = "Obafemi Awolowo University Teaching Hospital" 
     20 = "Olabisi Onabanjo University Teaching Hospital" 
     21 = "Plateau State Specialist Hospital" 
     22 = "Taraba State Specialist Hospital" 
     23 = "Thisday Dome Treatment Centre" 
     24 = "Treatment Centre, Agbami" 
     25 = "University College Hospital, Ibadan" 
     26 = "University Of Abuja Teaching Hospital" 
     27 = "University Of Ilorin Teaching Hospital" 
     28 = "Unsari" 
;

value state 
     1 = "Abia" 
     2 = "Adamawa" 
     3 = "Delta" 
     4 = "Ebonyi" 
     5 = "Federal Capital Territory" 
     6 = "Kebbi" 
     7 = "Kwara" 
     8 = "Lagos" 
     9 = "Niger" 
     10 = "Ogun" 
     11 = "Ondo" 
     12 = "Osun" 
     13 = "Oyo" 
     14 = "Plateau" 
     15 = "Taraba" 
;

value age_grop 
     1 = "<18" 
     2 = "18-45" 
     3 = "46-65" 
     4 = "66-75" 
     5 = ">75" 
;

value sex 
     1 = "Male" 
     2 = "Female" 
     3 = "Not specified" 
;

value antvrl_m 
     1 = "No antiviral" 
     2 = "ribavirin" 
     3 = "lopinavir/ritonavir" 
     4 = "neuraminidase inhibitor" 
     5 = "interferon alpha" 
     6 = "interferon beta" 
;

value strd_gnt 
     1 = "Not used" 
     2 = "Dexamethasone" 
     3 = "Hydrocortisone" 
     4 = "Prednisolone" 
     5 = "Not stated" 
;

DATA  rdata ;
INFILE  "covid_data.csv" 
     DSD 
     LRECL= 182 ;
INPUT
 site
 state
 mortality
 study_time
 admission_time
 o2
 icu
 nvent
 ivent
 severity
 age
 age_group
 sex
 health_worker
 ccdx
 diabetes
 hypertension
 smoking
 pulmonary_dx
 tb_active
 tb_previous
 asthma
 respiratory_dx
 asplenia
 ckd
 neoplasm
 chronic_liver_dx
 neurologic_dx
 hiv
 fever
 chest_indrawing
 cough
 headache
 confusion
 seizures
 sore_throat
 abd_pain
 runny_nose
 vomiting
 wheezing
 diarrhoea
 chest_pain
 conjunctivitis
 muscle_aches
 skin_rash
 joint_pain
 skin_ulcers
 fatigue
 lymphadenopathy
 taste
 inability_walk
 smell
 bleeding
 breath
 stroke
 spo2
 malaria
 shock
 bacteremia
 seizures_c
 bleeding_c
 meningitis
 endocarditis
 anaemia
 myocarditis
 arrhythmia
 aki
 arrest
 pancreatitis
 pneumonia
 liver_dysfn
 bronchiolitis
 cardiomyopathy
 ards
 stroke_c
 acei_arb
 antiviral
 antiviral_med
 antibiotic
 azithromycin
 steroid
 steroid_agent
 antimalarial
 chloroquine
 nsaid
 coagulate
;
FORMAT site site. ;
FORMAT state state. ;
FORMAT age_group age_grop. ;
FORMAT sex sex. ;
FORMAT antiviral_med antvrl_m. ;
FORMAT steroid_agent strd_gnt. ;
RUN;
