# clean up site names

table(t_1$admsit_E1_C1, useNA = 'i')
t_1$state <- 'Osun'

table(t_2$admsit_E1_C1, useNA = 'i')
t_2$admsit_E1_C1 <- str_to_title(str_squish(str_trim(t_2$admsit_E1_C1)))
t_2$admsit_E1_C1[t_2$admsit_E1_C1 == 'Oouth'] <- 'Olabisi Onabanjo University Teaching Hospital'
t_2$state <- 'Ogun'

table(t_3$admsit_E1_C1, useNA = 'i')
t_3$admsit_E1_C1 <- str_to_title(str_squish(str_trim(t_3$admsit_E1_C1)))
t_3$state <- 'Taraba'

table(t_4$admsit_E1_C1, useNA = 'i')
t_4$admsit_E1_C1 <- str_to_title(str_squish(str_trim(t_4$admsit_E1_C1)))
t_4$admsit_E1_C1[grepl('Owo', t_4$admsit_E1_C1)] <- 'Federal Medical Centre, Owo'
t_4$admsit_E1_C1[grepl('Akure', t_4$admsit_E1_C1)] <- 'Infectious Diseases Hospital, Akure'
t_4$state <- 'Ondo'

table(t_5$admsit_E1_C1, useNA = 'i')
t_5$admsit_E1_C1 <- 'Plateau State Specialist Hospital'
t_5$state <- 'Plateau'

table(t_6$admsit_E1_C1, useNA = 'i')
t_6$admsit_E1_C1 <- 'Jos University Teaching Hospital'
t_6$state <- 'Plateau'

table(t_7$admsit_E1_C1, useNA = 'i')
t_7$admsit_E1_C1 <- 'Bingham University Teaching Hospital'
t_7$state <- 'Plateau'

table(t_8$admsit_E1_C1, useNA = 'i')
t_8$admsit_E1_C1 <- 'General Hospital Riyom'
t_8$state <- 'Plateau'

table(t_9$admsit_E1_C1, useNA = 'i')
t_9$state <- 'Delta'


table(t_10$admsit_E1_C1, useNA = 'i')
t_10$admsit_E1_C1 <- 'Infectious Disease Center, Specialist Hospital Yola'
t_10$state <- 'Adamawa'

table(t_11$admsit_E1_C1, useNA = 'i')
t_11$admsit_E1_C1 <- 'Federal Medical Centre, Yola'
t_11$state <- 'Adamawa'

table(t_12$admsit_E1_C1, useNA = 'i')
t_12$admsit_E1_C1 <- 'Kapital Klub Isolation and Treatment Centre'
t_12$state <- 'Federal Capital Territory'

table(t_13$admsit_E1_C1, useNA = 'i')
t_13$state <- 'Federal Capital Territory'

table(t_14$admsit_E1_C1, useNA = 'i')
t_14$admsit_E1_C1 <- 'Thisday Dome Treatment Centre'
t_14$state <- 'Federal Capital Territory'

table(t_15$admsit_E1_C1, useNA = 'i')
t_15$state <- 'Federal Capital Territory'

table(t_16$admsit_E1_C1, useNA = 'i')
t_16$admsit_E1_C1 <- 'University of Abuja Teaching Hospital'
t_16$state <- 'Federal Capital Territory'

table(t_17$admsit_E1_C1, useNA = 'i')
t_17$admsit_E1_C1 <- 'General Hospital Minna'
t_17$state <- 'Niger'

table(t_18$admsit_E1_C1, useNA = 'i')
t_18$admsit_E1_C1 <- 'Amachara Isolation Centre'
t_18$state <- 'Abia'

table(t_19$admsit_E1_C1, useNA = 'i')
t_19$admsit_E1_C1 <- 'General Hospital Abakaliki'
t_19$state <- 'Ebonyi'

table(t_20$admsit_E1_C1, useNA = 'i')
t_20$admsit_E1_C1 <- 'Federal Medical Centre Birnin-Kebbi'
t_20$state <- 'Kebbi'

table(t_21$admsit_E1_C1, useNA = 'i')
t_21$admsit_E1_C1 <- 'State Specialist Hospital Damaturu'
t_21$state <- 'Yobe'

table(t_22$admsit_E1_C1, useNA = 'i')
t_22$admsit_E1_C1 <- 'Lagos University Teaching Hospital'
t_22$state <- 'Lagos'

table(t_23$admsit_E1_C1, useNA = 'i')
t_23$admsit_E1_C1 <- 'University College Hospital, Ibadan'
t_23$state <- 'Oyo'

table(t_24$admsit_E1_C1, useNA = 'i')
t_24$admsit_E1_C1 <- 'Infectious Disease Hospital, Olodo'
t_24$state <- 'Oyo'

table(t_25$admsit_E1_C1, useNA = 'i')
t_25$admsit_E1_C1 <- 'Treatment Centre, Agbami'
t_25$state <- 'Oyo'

table(t_26$admsit_E1_C1, useNA = 'i')
t_26$admsit_E1_C1 <- 'University of Ilorin Teaching Hospital'
t_26$state <- 'Kwara'

