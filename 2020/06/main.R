library(dplyr)

f <- file("c:\\Work\\Code\\AdventOfCode\\2020\\06\\input.txt", "r")

counts <- list()
answers <- 0
a <- c()
part2 <- 0

while (length(line) != 0) {
  line <- readLines(f, n = 1)
  if (nchar(line) == 0 || length(line) == 0) {
    #end of block
    temp <- strsplit(a, "")[[1]]
    counts <- c(counts, length(unique(temp)))
    part2 <- part2 + (data.frame(temp) %>% count(temp) %>% filter(n == answers) %>% count())
    a <- c()
    answers <- 0
    if (length(line) == 0)
      break
  }
  
  if (nchar(line) >= 1) {
    a <- paste(a, line, sep = "")
    answers <- answers + 1
  }
}

part1 <- sum(unlist(counts))
