library(dplyr)
library(igraph)

input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\07\\test.txt",
       character(),
       sep = "\n")
parts <- strsplit(gsub("s, ", "", gsub("s contain ", "", input)), " bag")
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
