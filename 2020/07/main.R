library(dplyr)
library(igraph)

input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\07\\input.txt",
       character(),
       sep = "\n")
parts <-
  strsplit(gsub("s, ", "", gsub("s contain ", "", input)), " bag")
sparse <- matrix(
  0,
  nrow = length(parts),
  ncol = length(parts),
  dimnames = list(lapply(parts, `[[`, 1), lapply(parts, `[[`, 1))
)

# parse input
for (line in parts) {
  temp <- gsub("s\\.", ".", gsub("([s,]) ", "", unlist(line)))
  i <- 2
  while (TRUE) {
    if (temp[i] == "no other" || temp[i] == ".")
      break
    else {
      weight <- unlist(strsplit(temp[i], " "))[1]
      dest <- sub(paste(weight, " ", sep = ""), "", temp[i])
      sparse[temp[1], dest] <- strtoi(weight)
      i <- i + 1
    }
  }
}

g <- graph_from_adjacency_matrix(sparse, weighted = TRUE)
d <- distances(g, to = "shiny gold", mode = "out")
# -1 because the distance to shiny gold is 0
part1 <- length(d[is.finite(rowSums(d)),]) - 1

get_bags_count <- function(node_name, multiplier) {
  bag <- sparse[node_name, ]
  res <- multiplier
  for (i in 1:length(parts)) {
    if (bag[i] > 0) {
      res <- res + get_bags_count(i, bag[i] * multiplier)
    }
  }
  return (res)
}

# -1 for shiny gold. 358 is the ordinal number of shiny gold in the input.
part2 <- get_bags_count(358, 1) - 1
