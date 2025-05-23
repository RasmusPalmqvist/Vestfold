library(tidyverse)

theme_set(theme_bw()) #set ggplot2 theme
setwd("C:/Users/eve1509/OneDrive - Vestfold og Telemark fylkeskommune/Github/Telemark/Data/08_Folkehelse og levek�r/R/")
getwd()

kommune_raw <- read_csv("input/V&T.csv") #Datasett med kommuner
#land <- read_csv("input/V&Tlandgr.csv") #Info om landbakgrunn, men ikke kommune

# Resultatene er samlet i/eksportert til et eget Excel-ark, "Tallgrunnlag tannhelse.xlsx" i FHUS-teamet, "C:\Users\eve1509\Vestfold og Telemark fylkeskommune\OF-Folkehelseunders�kelsen i Vestfold og Telemark - General"

# Ctrl + Shift + M = %>%

# "Group_by" tilsvarer de gruppene (og undergruppene) man �nsker p� x-aksen. Rekkef�lge betyr ikke n�dvendigvis noe.

# -------------------------- Tilf�ye innvandrerstatus til tabell med landbakgrunn ----------------------- #

#land <- land %>% 
#  mutate(Innvandrerstatus = case_when(QFVT_7_8D != "JEG HAR BODD I NORGE HELE LIVET" ~ "Innvandrere",
#                                      QFVT_7_8 == "NEI" | (QFVT_7_8 == "JA" & QFVT_7_8D == "JEG HAR BODD I NORGE HELE LIVET") ~ "Ikke-innvandrere"))

#unique(land$Innvandrerstatus)
#land %>% count(Innvandrerstatus)

#Innvandrere: Er selv, eller har forelder(e) som er f�dt i utlandet, OG har selv ikke bodd i Norge hele livet.

#Ikke-innvandrere: Verken selv eller forelder f�dt i utlandet, og har bodd i Norge hele livet.

## Rename variabler

kommune <- kommune_raw %>% rename(alder = alderkat,
                            kj�nn = Kjonn_Kode,
                            utdanning = utdannelse,
                            trivsel_n�rmilj� = QFVT_1_1,
                            org_aktivitet = QFVT_1_9,
                            annen_aktivitet = QFVT_1_10,
                            egen_helse = QFVT_2_1,
                            egen_tannhelse = QFVT_2_2,
                            tannlegebes�k = QFVT_2_3,
                            kost_gr�nt = QFVT_4_6,
                            skader = QFVT_5_1,
                            forn�yd_livet = QFVT_6_1) %>%
  mutate(
    org_aktivitet_kat = case_when(
      org_aktivitet == "DAGLIG" ~ "MINST �N GANG I UKA",
      org_aktivitet == "UKENTLIG" ~ "MINST �N GANG I UKA",
      org_aktivitet == "1-3 GANGER PER M�NED" ~ "MINDRE ENN �N GANG I UKA",
      org_aktivitet == "SJELDNERE" ~ "MINDRE ENN �N GANG I UKA",
      org_aktivitet == "ALDRI" ~ "MINDRE ENN �N GANG I UKA"
    )
  ) %>%
  mutate(
    annen_aktivitet_kat = case_when(
      annen_aktivitet == "DAGLIG" ~ "MINST �N GANG I UKA",
      annen_aktivitet == "UKENTLIG" ~ "MINST �N GANG I UKA",
      annen_aktivitet == "1-3 GANGER PER M�NED" ~ "MINDRE ENN �N GANG I UKA",
      annen_aktivitet == "SJELDNERE" ~ "MINDRE ENN �N GANG I UKA",
      annen_aktivitet == "ALDRI" ~ "MINDRE ENN �N GANG I UKA"
    )
  ) %>%
  mutate(
    egen_helse_kat = case_when(
      egen_helse == "SV�RT GOD" ~ "GOD ELLER SV�RT GOD",
      egen_helse == "GOD" ~ "GOD ELLER SV�RT GOD",
      egen_helse == "VERKEN GOD ELLER D�RLIG" ~ "MINDRE ENN GOD ELLER SV�RT GOD",
      egen_helse == "D�RLIG" ~ "MINDRE ENN GOD ELLER SV�RT GOD",
      egen_helse == "SV�RT D�RLIG" ~ "MINDRE ENN GOD ELLER SV�RT GOD"
    )
  ) %>%
  mutate(
    kost_gr�nt_kat = case_when(
      kost_gr�nt == "SJELDEN/ALDRI" ~ "Sjeldnere enn daglig",
      kost_gr�nt == "1-3 GANGER PER M�NED" ~ "Sjeldnere enn daglig",
      kost_gr�nt == "1 GANG PER UKE" ~ "Sjeldnere enn daglig",
      kost_gr�nt == "2-3 GANGER PER UKE" ~ "Sjeldnere enn daglig",
      kost_gr�nt == "4-6 GANGER PER UKE" ~ "Sjeldnere enn daglig",
      kost_gr�nt == "1 GANG PER DAG" ~ "Daglig",
      kost_gr�nt == "FLERE GANGER PER DAG" ~ "Daglig"
    )
  ) %>%
  mutate(
    forn�yd_livet_kat = case_when(
      forn�yd_livet == "0 - IKKE FORN�YD I DET HELE TATT" ~ "0",
      forn�yd_livet == "1" ~ "1",
      forn�yd_livet == "2" ~ "2",
      forn�yd_livet == "3" ~ "3",
      forn�yd_livet == "4" ~ "4",
      forn�yd_livet == "5" ~ "5",
      forn�yd_livet == "6" ~ "6",
      forn�yd_livet == "7" ~ "7",
      forn�yd_livet == "8" ~ "8",
      forn�yd_livet == "9" ~ "9",
      forn�yd_livet == "10 - SV�RT FORN�YD" ~ "10",
      forn�yd_livet == "VET IKKE" ~ "VET IKKE"
    )
  ) %>%
  mutate(
    utdanning_kat = case_when(
      utdanning == "H�y(Uni>2)" ~ "H�yere utdanning",
      utdanning == "Vgs/fag/h�y/uni<2" ~ "Videreg�ende skole",
      utdanning == "Grunnskole/tilsv." ~ "Grunnskole"
    )
  ) %>% 
  mutate(
    skader_kat = case_when(
      skader == "JA, EN" ~ "JA",
      skader == "JA, FLERE" ~ "JA",
      skader == "NEI" ~ "NEI"
    )
  ) %>% 
  mutate(
    tannlegebes�k_kat = case_when(
      tannlegebes�k == "0-2 �R SIDEN" ~ "NEI",
      tannlegebes�k == "3-5 �R SIDEN" ~ "JA",
      tannlegebes�k == "MER ENN 5 �R SIDEN" ~ "JA"
    )
  ) %>% 
  mutate(
    trivsel_n�rmilj�_kat = case_when(
      trivsel_n�rmilj� == "I STOR GRAD" ~ "I STOR GRAD",
      trivsel_n�rmilj� == "I NOEN GRAD" ~ "MINDRE ENN STOR GRAD",
      trivsel_n�rmilj� == "I LITEN GRAD" ~ "MINDRE ENN STOR GRAD",
      trivsel_n�rmilj� == "IKKE I DET HELE TATT" ~ "MINDRE ENN STOR GRAD"
    )
  ) %>% 
  mutate(
    egen_tannhelse_kat = case_when(
      egen_tannhelse == "SV�RT GOD" ~ "GOD ELLER SV�RT GOD",
      egen_tannhelse == "GOD" ~ "GOD ELLER SV�RT GOD",
      egen_tannhelse == "VERKEN GOD ELLER D�RLIG" ~ "MINDRE ENN GOD",
      egen_tannhelse == "D�RLIG" ~ "MINDRE ENN GOD",
      egen_tannhelse == "SV�RT D�RLIG" ~ "MINDRE ENN GOD"
    )
  ) %>% 
  mutate(
    kj�nn = case_when(
      kj�nn == "K" ~ "Kvinne",
      kj�nn == "M" ~ "Mann",
    )
  )
 

#Filtrere p� kun relevante variabler

df_kommuner <- kommune %>% select(kommunenr,
                                  alder,
                                  kj�nn,
                                  utdanning_kat,
                                  trivsel_n�rmilj�_kat,
                                  org_aktivitet_kat,
                                  annen_aktivitet_kat,
                                  egen_helse_kat,
                                  egen_tannhelse_kat,
                                  tannlegebes�k_kat,
                                  kost_gr�nt_kat,
                                  skader_kat,
                                  forn�yd_livet_kat)


## Kommunevise datasett

df_vestfold <- df_kommuner %>% filter(kommunenr %in% c("3801", "3802", "3803", "3804", "3805", "3811"))
df_telemark <- df_kommuner %>% filter(kommunenr %in% c("3806","3807","3808","3812","3813","3814","3815","3816","3817","3818","3819","3820","3821","3822","3823","3824","3825"))

dfList <- list(df_vestfold, df_telemark)

##### EGEN HELSE X UTDANNINGSNIV�

egenhelse_utdanning <- lapply(dfList, function(x) {
  egenhelse_utdanning <- x %>% 
    group_by(utdanning_kat, kj�nn, egen_helse_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    group_by(utdanning_kat, kj�nn, egen_helse_kat) %>% 
    summarise(totalt = sum(n)) %>% 
    group_by(utdanning_kat, kj�nn) %>% 
    mutate(andel = totalt/sum(totalt)*100) %>% 
    filter(egen_helse_kat == "GOD ELLER SV�RT GOD") %>% 
    select(-egen_helse_kat, -totalt)
  
  egenhelse_utdanning_pivot <- pivot_wider(egenhelse_utdanning, names_from = kj�nn, values_from = andel)
  })

egenhelse_utdanning_vestfold <- egenhelse_utdanning[[1]]
egenhelse_utdanning_telemark <- egenhelse_utdanning[[2]]

write.table(egenhelse_utdanning_vestfold, "output/egenhelse_utdanning_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(egenhelse_utdanning_telemark, "output/egenhelse_utdanning_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")






#Antall NA
#unique(df_kommuner$utdanning_kat)
#nrow(df_kommuner[is.na(df_kommuner$utdanning_kat),])

egenhelse_utdanning <- df_vestfold %>% 
  group_by(utdanning_kat, kj�nn, egen_helse_kat) %>% 
  summarise(n = n()) %>% 
  na.omit() %>%
  group_by(utdanning_kat, kj�nn, egen_helse_kat) %>% 
  summarise(totalt = sum(n)) %>% 
  group_by(utdanning_kat, kj�nn) %>% 
  mutate(andel = totalt/sum(totalt))

## Renske tabell



#Konverere til (og endre rekkef�lge p�) faktorer
tannhelse_utdanning$god_d�rlig <- as.factor(tannhelse_utdanning$god_d�rlig)
tannhelse_utdanning$utdannelse <- as.factor(tannhelse_utdanning$utdannelse)
tannhelse_utdanning$utdannelse <- factor(tannhelse_utdanning$utdannelse, levels = c("Grunnskole/tilsv.","Vgs/fag/h�y/uni<2", "H�y(Uni>2)"))

#Plotte
ggplot(tannhelse_utdanning, aes(fill=god_d�rlig, y=andel, x=utdannelse)) + 
  geom_bar(position="dodge", stat="identity") +
  geom_text(aes(label=andel), vjust = -0.5, position = position_dodge(.9))

#Pivotere og skrive til .csv
tannhelse_utdanning_pivot <- pivot_wider(tannhelse_utdanning, names_from = utdannelse, values_from = andel)
write.table(tannhelse_utdanning_pivot, "output/tannhelse_utdanning.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")





