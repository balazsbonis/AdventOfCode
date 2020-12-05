data <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\05\\input.txt",
       character())

a <- sort(strtoi(gsub("([FL])", 0, gsub("([BR])", 1, data)), base = 2))
part1 <- max(a)
part2 <- setdiff(seq(min(b), part1), a)

