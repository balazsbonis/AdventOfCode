data <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\05\\input.txt",
       character())

a <- gsub("([FL])", 0, gsub("([BR])", 1, data))

part1 <- max(strtoi(a, base = 2))
