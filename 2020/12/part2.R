f <- file("c:\\Work\\Code\\AdventOfCode\\2020\\12\\test.txt", "r")

# part2
ship <- c(0, 0)
waypoint <- c(10, 1)
direction <- "E"

while (TRUE) {
  line <- readLines(f, n = 1)
  if (length(line) == 0) {
    break
  }
  order <- substring(line, 1, 1)
  measure <- strtoi(substring(line, 2))
  if (order == "N") {
    waypoint[2] <- waypoint[2] + measure
  }
  else if (order == "S") {
    waypoint[2] <- waypoint[2] - measure
  }
  else if (order == "E") {
    waypoint[1] <- waypoint[1] + measure
  }
  else if (order == "W") {
    waypoint[1] <- waypoint[1] - measure
  }
  else if (order == "F") {
    ship[1] <- ship[1] + (waypoint[1] * measure)
    ship[2] <- ship[2] + (waypoint[2] * measure)
  }
  else if (order == "R" || order == "L") {
    angle <- measure * pi / 180
    if (order == "R") angle <- angle * -1
    M <- matrix(c(cos(angle),-sin(angle), sin(angle), cos(angle)), 2, 2)
    waypoint <- waypoint %*% M
  }
}
part1 <- abs(ship[1]) + abs(ship[2])