library(dplyr)
library(tidyr)
library(stringi)

input <- read.table("c:\\Work\\Code\\AdventOfCode\\2020\\02\\input.txt", sep = " ")

input <- input %>% 
  separate(V1, into = c("min", "max"), sep = "-", convert = TRUE) %>% 
  mutate(V2 = substr(V2, 1, 1),
         count_char = stri_count_fixed(V3, V2), 
         valid1 = count_char >= min & count_char <=max, 
         pos1 = substr(V3, min, min) == V2, 
         pos2 = substr(V3, max, max) == V2, 
         valid2 = xor(pos1, pos2))  

sum(input$valid1)
sum(input$valid2)
