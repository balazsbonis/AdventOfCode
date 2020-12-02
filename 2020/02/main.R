library(dplyr)

f <- file("c:\\Work\\Code\\AdventOfCode\\2020\\02\\input.txt", "r")
result <- 0
result2 <- 0
r2 <- "N"
while (TRUE) {
  line <- readLines(f, n = 1)
  if (length(line) == 0) {
    break
  }
  parts <- unlist(strsplit(gsub(":", "", line), "[ ]"))
  pw <- unlist(strsplit(parts[3], ""))
  cnt <- length(which(pw == parts[2]))
  range <- strtoi(unlist(strsplit(parts[1], "-")))
  # PART 1
  if (between(cnt, range[1], range[2])) {
    result <- result + 1
  }
  # PART 2
  if ((pw[range[1]] == parts[2] || pw[range[2]] == parts[2]) &&
      (!(pw[range[1]] == parts[2] && pw[range[2]] == parts[2]))) {
    result2 <- result2 + 1
    r2 <- paste("Y: ", pw[range[1]], pw[range[2]])
  }
  
  print(paste(line, r2))
  r2 <- "N"
}

close(f)
