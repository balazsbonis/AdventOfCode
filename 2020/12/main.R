f <- file("c:\\Work\\Code\\AdventOfCode\\2020\\12\\input.txt", "r")

# part1
x <- y <- 0
direction <- "E"
while (TRUE) {
  line <- readLines(f, n = 1)
  if (length(line) == 0) {
    break
  }
  order <- substring(line, 1, 1)
  measure <- strtoi(substring(line, 2))
  if (order == "F") {
    order <- direction
  }
  if (order == "N") {
    y <- y + measure
  }
  if (order == "S") {
    y <- y - measure
  }
  if (order == "E") {
    x <- x + measure
  }
  if (order == "W") {
    x <- x - measure
  }
  if (order == "R" || order == "L") {
    if (measure == 180) {
      if (direction == "E")
        direction <- "W"
      else if (direction == "W")
        direction <- "E"
      else if (direction == "S")
        direction <- "N"
      else if (direction == "N")
        direction <- "S"
    }
    if ((order == "R" &&
         measure == 90) || (order == "L" && measure == 270)) {
      if (direction == "E")
        direction <- "S"
      else if (direction == "S")
        direction <- "W"
      else if (direction == "W")
        direction <- "N"
      else if (direction == "N")
        direction <- "E"
    }
    if ((order == "L" &&
         measure == 90) || (order == "R" && measure == 270)) {
      if (direction == "E")
        direction <- "N"
      else if (direction == "S")
        direction <- "E"
      else if (direction == "W")
        direction <- "S"
      else if (direction == "N")
        direction <- "W"
    }
  }
}
part1 <- abs(x) + abs(y)
