library(dplyr)
data <-
  sort(scan("c:\\Work\\Code\\AdventOfCode\\2020\\10\\input.txt",
       integer()))

upper <- c(data, (max(data) + 3))
lower <- c(min(data), data)
diff <- (upper - lower)
df <- data.frame(lower, upper, diff)
c <-
  df %>% group_by(diff) %>% summarise(count = n())
part1 <- c[3, "count"] * (c[2, "count"] + 1)

# part 2.
counter <- 1
index <- 2
part2 <- 1
while (TRUE) {
  if (diff[index] == 1) {
    counter <- counter + 1
  }
  if (diff[index] == 3) {
    if (counter == 2) {
      part2 <- part2 * 2 # a b c; a c
    }
    if (counter == 3) {
      part2 <- part2 * 4 # a b c d; a b d; a c d; a d
    }
    if (counter == 4) {
      part2 <-
        part2 * 7 # a b c d e; a b c e; a b d e; a c d e; a b e; a c e; a d e
    }
    counter <- 0
  }
  index <- index + 1
  if (index > length(diff)) {
    break
  }
}
