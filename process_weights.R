library(tidyr)
library(stringr)
library(osfr)

qualtrics_file <- "test_weightings.csv"
initial_frame <- read_csv(qualtrics_file, col_names = TRUE, show_col_types = FALSE) %>%
  select(starts_with("Q")) %>%
  filter(!row_number() %in% c(2)) %>%
  t() %>%
  as.data.frame() %>%
  separate_wider_delim(" - ", names = c("A", "B"), cols = "V1") %>%
  mutate(A = str_replace_all(A, "Civic Learning.", "Civic Learning:")) %>%
  mutate(A = str_replace_all(A, "Which of the following best describes the nature of the goals achieved in your project?", "Nature of Goals: Which of the following best describes the nature of the goals achieved in your project?")) %>%
  mutate(A = str_split(initial_frame$A, ": ", simplify = TRUE)[,1])

reduced_prompt <- str_split(initial_frame$A, ": ", simplify = TRUE)[,1]

initial_frame$A <- reduced_prompt                       
