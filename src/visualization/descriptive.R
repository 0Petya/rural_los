library(tidyverse)

los <- read_rds("./data/processed/hospitalization.rds")

summary(los$`Length of Stay`)
sd(los$`Length of Stay`)

descriptive_categorical <- function(field) {
  table <- los %>%
    group_by({{field}}) %>%
    summarize(n = n()) %>%
    mutate(freq = n / sum(n)) %>%
    arrange(desc(n))
  
  return(table)
}

descriptive_categorical(Censor)
descriptive_categorical(RUCA)
descriptive_categorical(`Age Group`)
descriptive_categorical(Race)
descriptive_categorical(Ethnicity)
descriptive_categorical(Ethnicity)
descriptive_categorical(`APR Risk of Mortality`)
descriptive_categorical(`APR Severity of Illness Description`)
descriptive_categorical(Insurance)
descriptive_categorical(Gender)
descriptive_categorical(`Type of Admission`)
descriptive_categorical(`APR Medical Surgical Description`)
