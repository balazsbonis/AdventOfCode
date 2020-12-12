f <- file("c:\\Work\\Code\\AdventOfCode\\2020\\12\\input.txt", "r")

# part2
ship <- c(0, 0)
waypoint <- c(10, 1)
movements <- list(
  E = c(1, 0),
  S = c(0,-1),
  W = c(-1, 0),
  N = c(0, 1)
)
while (TRUE) {
  line <- readLines(f, n = 1)
  if (length(line) == 0) {
    break
  }
  order <- substring(line, 1, 1)
  measure <- strtoi(substring(line, 2))
  if (order == "N" || order == "E" || order == "S" || order == "W") {
    waypoint <- waypoint + (measure * movements[order][[1]])
  }
  else if (order == "F") {
    ship <- ship + (waypoint * measure)
  }
  else if (order == "R" || order == "L") {
    angle <- measure * pi / 180
    if (order == "R")
      angle <- angle * -1
    M <-
      matrix(c(cos(angle),-sin(angle), sin(angle), cos(angle)), 2, 2)
    waypoint <- waypoint %*% M
  }
}
part2 <- abs(ship[1]) + abs(ship[2])