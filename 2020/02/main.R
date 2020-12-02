library(dplyr)

f <- file("c:\\Work\\Code\\AdventOfCode\\2020\\02\\input.txt", "r")
result <- 0
while (TRUE) {
  line <- readLines(f, n = 1)
  if (length(line) == 0) {
    break
  }
  parts <- unlist(strsplit(gsub(":", "", line), "[ ]"))
  pw <- unlist(strsplit(parts[3], ""))
  cnt <- length(which(pw == parts[2]))
  range <- strtoi(unlist(strsplit(parts[1], "-")))
  if (between(cnt, range[1], range[2])) {
    result <- result + 1
  }
  print(line)
}

close(f)
