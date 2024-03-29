#Load in packages needed
library(tidyverse)
library(data.table)
library(janitor)
library(gtsummary)

#Load in data and clean variables
input <- read_csv(
  here::here("output", "input.csv"))

cleaned_input <- input %>%
  mutate(imd=factor(imd, levels=c(1,2,3,4,5), labels=c("1 - Most deprived", "2", "3", "4", "5 - Least deprived"))) %>%
  mutate(ethnicity=factor(ethnicity, levels=c(1,2,3,4,5), labels=c("White", "Mixed", "Asian", "Black", "Other"))) %>%
  mutate(ethnicity_16=factor(ethnicity_16, levels=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), 
  labels=c("British or Mixed British",
  "Irish", 
  "Other White", 
  "White and Black Caribbean", 
  "White and Black African", 
  "White and Asian", 
  "Other Mixed", 
  "Indian or British Indian", 
  "Pakistani or British Pakistani", 
  "Bangladeshi or British Bangladeshi", 
  "Other Asian", 
  "Caribbean", 
  "African", 
  "Other Black", 
  "Chinese", 
  "Other"))) %>%
  mutate(died_ons_covid_flag_any=factor(died_ons_covid_flag_any, levels = c(0,1), labels=c("No", "Yes"))) %>%
  mutate(died_ons_covid_flag_underlying=factor(died_ons_covid_flag_underlying, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(died_ons_covidconf_flag_underlying=factor(died_ons_covidconf_flag_underlying, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(covid_admission_date=factor(covid_admission_date, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(cov_vacc_d1=factor(cov_vacc_d1, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(cov_vacc_d2=factor(cov_vacc_d2, levels=c(0,1), labels=c("No", "Yes"))) %>%
  # mutate(shield_dat=factor(shield_dat, levels=c(0,1), labels=c("No", "Yes"))) %>%
  # mutate(nonshield_dat=factor(nonshield_dat, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(smoking_status=factor(smoking_status, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(asthma=factor(asthma, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(chronic_respiratory_disease=factor(chronic_respiratory_disease, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(hypertension=factor(hypertension, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(preg_36wks=factor(preg_36wks, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(chronic_cardiac_disease=factor(chronic_cardiac_disease, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(diabetes=factor(diabetes, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(dementia=factor(dementia, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(cnd=factor(cnd, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(learning_disability=factor(learning_disability, levels=c(0,1), labels=c("No", "Yes"))) %>%
  mutate(immuno_group=factor(immuno_group, levels=c(0,1), labels=c("No", "Yes")))

#Restrict to data needed 
cleaned_df <- cleaned_input %>%
	select(-c(hh_id,hh_size)) %>%
	select(-c(sgss_covid19_any_test)) %>%
	select(-c(sgss_covid19_pos_test,died_date_cpns,died_date_ons)) %>%
	select(-c(patient_index_date,exposure_hospitalisation,covadm1_dat))

##create tables
#Table 1 by 2nd dose vaccination status
table1 <- cleaned_df %>%
  tbl_summary(
    by = cov_vacc_d2,
    statistic = list(all_continuous() ~ "{mean} ({sd})",
                     all_categorical() ~ "{n} / {N} ({p}%)"),
    digits = all_continuous() ~ 2,
    missing_text = "(Missing)"
  )

#Table 1.1 by ethnicity
table11 <- cleaned_df %>%
  tbl_summary(
    by = ethnicity,
    statistic = list(all_continuous() ~ "{mean} ({sd})",
                     all_categorical() ~ "{n} / {N} ({p}%)"),
    digits = all_continuous() ~ 2,
    missing_text = "(Missing)"
  )

#Table 1.2 by LD
table12 <- cleaned_df %>%
  tbl_summary(
    by = learning_disability,
    statistic = list(all_continuous() ~ "{mean} ({sd})",
                     all_categorical() ~ "{n} / {N} ({p}%)"),
    digits = all_continuous() ~ 2,
    missing_text = "(Missing)"
  )

#Table 1.3 by Admission
table13 <- cleaned_df %>%
  tbl_summary(
    by = covid_admission_primary_diagnosis,
    statistic = list(all_continuous() ~ "{mean} ({sd})",
                     all_categorical() ~ "{n} / {N} ({p}%)"),
    digits = all_continuous() ~ 2,
    missing_text = "(Missing)"
  )

#Table 1.4 by Mortality
table14 <- cleaned_df %>%
  tbl_summary(
    by = died_ons_covid_flag_any,
    statistic = list(all_continuous() ~ "{mean} ({sd})",
                     all_categorical() ~ "{n} / {N} ({p}%)"),
    digits = all_continuous() ~ 2,
    missing_text = "(Missing)"
  )

#Table 1.5 by Pregnancy
table15 <- cleaned_df %>%
  tbl_summary(
    by = preg_36wks,
    statistic = list(all_continuous() ~ "{mean} ({sd})",
                     all_categorical() ~ "{n} / {N} ({p}%)"),
    digits = all_continuous() ~ 2,
    missing_text = "(Missing)"
  )

#Read into html files
table1 %>%
  as_gt() %>%
  gt::gtsave(filename = "Table1.html", path=here::here("output"))

table11 %>%
  as_gt() %>%
  gt::gtsave(filename = "Table1-1.html", path=here::here("output"))

table12 %>%
  as_gt() %>%
  gt::gtsave(filename = "Table1-2.html", path=here::here("output"))

table13 %>%
  as_gt() %>%
  gt::gtsave(filename = "Table1-3.html", path=here::here("output"))

table14 %>%
  as_gt() %>%
  gt::gtsave(filename = "Table1-4.html", path=here::here("output"))

table15 %>%
  as_gt() %>%
  gt::gtsave(filename = "Table1-5.html", path=here::here("output"))




