library(dplyr)
library(tidyverse)
library(readxl)
library(janitor)
library(stringr)
library(zoo)

df <- read_excel("placeholder_df.xlsx", sheet = 1)
row <- names(df)
names(df) <- df[1, ]
df[1, 1] <- row[1]
df <- df[, 1:31]

df %>%
  mutate(zip_code = str_extract(Hospital, pattern ='\\d{4}')) %>%
  mutate(Hospital = str_sub(Hospital, 6, -5)) %>%
  mutate(date = ifelse(str_length(AGR) < 4, NA, AGR)) %>%
  `colnames<-`(replace(colnames(.), colnames(.) == "AGR", "id")) %>%
  mutate(date = as.Date(as.numeric(date), origin = "1899-12-30")) %>%
  fill(date, .direction = "down") %>%
  select(date, zip_code, everything()) %>%
  filter(!is.na(zip_code)) -> dataset

dataset <- clean_names(dataset)

View(dataset)
