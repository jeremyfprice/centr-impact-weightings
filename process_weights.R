library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(AnthroTools)

# Set the OSF URL for the survey data set
qualtrics_file <- "https://osf.io/s2ajm/download"

# Match factors with components
match_frame <- data.frame(
  component = c(
    rep("Contexts", 4),
    rep("Partnership Processes", 4),
    rep("Interventions and Research", 5),
    rep("Engaged Learning", 4),
    rep("Outcomes", 4)
  ),
  factor = c(
    "Challenge Origin",
    "Diversity",
    "Resources",
    "Trust",
    "Beneficence",
    "Reflection",
    "Decision Making",
    "Tool Construction",
    "Duration",
    "Frequency",
    "Research Questions",
    "Design and Facilitation",
    "Voice",
    "Reciprocity",
    "Civic Learning",
    "Learning Goals",
    "Integration",
    "Goals Met",
    "Outputs Delivered",
    "Capacities and Capabilities Strengthened",
    "Sustainability"
  )
)

# Read and process the survey data set
survey_frame <- read_csv(qualtrics_file, col_names = TRUE, show_col_types = FALSE) %>%
  select(starts_with("Q")) %>%
  filter(!row_number() %in% c(2)) %>%
  t() %>%
  as.data.frame() %>%
  separate_wider_delim(" - ", names = c("factor", "descriptor"), cols = "V1") %>%
  mutate(factor = str_replace_all(factor, "Civic Learning.", "Civic Learning:")) %>%
  mutate(factor = str_replace_all(factor, "Which of the following best describes the nature of the goals achieved in your project?", "Learning Goals: Which of the following best describes the nature of the goals achieved in your project?")) %>%
  mutate(factor = str_split(factor, ": ", simplify = TRUE)[, 1]) %>%
  pivot_longer(!c(factor, descriptor), names_to = "participant_id", values_to = "rank") %>%
  mutate(participant_id = str_remove_all(string = participant_id, pattern = "V")) %>%
  mutate(participant_id = as.numeric(participant_id) - 1) %>%
  mutate(rank = as.numeric(rank)) %>%
  as.data.frame() %>%
  na.omit() %>%
  arrange(participant_id)

# Calculate the Smith's Salience Score
salience_frame <- CalculateSalience(survey_frame,
  Order = "rank",
  Subj = "participant_id",
  CODE = "descriptor",
  GROUPING = "factor"
)

# Clean up salience data and match with appropriate weightings and components
salience_frame <- salience_frame %>%
  distinct(descriptor, .keep_all = TRUE) %>%
  rename("salience" = "Salience") %>%
  mutate(weighting = case_when(
    salience == 1.00 ~ 1.00,
    salience == 0.80 | salience == 0.75 ~ 0.95,
    salience == 0.60 | salience == 0.50 ~ 0.90,
    salience == 0.40 | salience == 0.25 ~ 0.84,
    salience == 0.20 ~ 0.78
  )) %>%
  full_join(y = match_frame, by = "factor") %>%
  select(c(component, factor, descriptor, salience, weighting)) %>%
  mutate(component = factor(component, levels = c(
    "Contexts",
    "Partnership Processes",
    "Interventions and Research",
    "Engaged Learning",
    "Outcomes"
  ))) %>%
  group_by(across(c(component, factor))) %>%
  arrange(by = desc(weighting), .by_group = TRUE) %>%
  ungroup()

# Write results to a file for upload
write_csv(salience_frame, "centr_impact-weightings.csv")
