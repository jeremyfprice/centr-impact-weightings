library(readr)
library(dplyr)
library(tidyr)
library(stringr)
#library(e1071)
#library(npmlreg)
library(glue)
library(AnthroTools)

qualtrics_file <- "https://osf.io/kxbmc/download"

initial_frame <- read_csv(qualtrics_file, col_names = TRUE, show_col_types = FALSE) %>%
  select(starts_with("Q")) %>%
  filter(!row_number() %in% c(2)) %>%
  t() %>%
  as.data.frame() %>%
  separate_wider_delim(" - ", names = c("factor", "prompt"), cols = "V1") %>%
  mutate(factor = str_replace_all(factor, "Civic Learning.", "Civic Learning:")) %>%
  mutate(factor = str_replace_all(factor, "Which of the following best describes the nature of the goals achieved in your project?", "Nature of Goals: Which of the following best describes the nature of the goals achieved in your project?")) %>%
  mutate(factor = str_split(factor, ": ", simplify = TRUE)[, 1]) %>%
  pivot_longer(!c(factor, prompt), names_to = "participant_id", values_to = "rank") %>%
  mutate(participant_id = str_remove_all(string = participant_id, pattern = "V")) %>%
  mutate(participant_id = as.numeric(participant_id) - 1) %>%
  mutate(rank = as.numeric(rank)) %>%
  as.data.frame() %>%
  #na.omit() %>%
  arrange(participant_id)

salience_frame <- CalculateSalience(initial_frame,
  Order = "rank",
  Subj = "participant_id",
  CODE = "prompt",
  GROUPING = "factor"
)

salience_frame <- salience_frame %>%
  na.omit() %>%
  distinct(prompt, .keep_all = TRUE) %>%
  select(-c(participant_id, rank)) %>%
  rename("salience" = "Salience") %>%
  mutate(weighting = case_when(salience == 1.00 ~ 1.00,
                               salience == 0.80 ~ 0.95,
                               salience == 0.60 ~ 0.90,
                               salience == 0.40 ~ 0.84,
                               salience == 0.20 ~ 0.78))

write_csv(salience_frame, "centr_impact-weightings.csv")
