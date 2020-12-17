input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\17\\test.txt",
       character(),
       sep = "\n")

# set scene
playground <- array(".", dim = c(50, 50, 50, 50))
for (i in 1:length(input)) {
  cubes <- unlist(strsplit(input[i], ""))
  for (j in 1:length(cubes)) {
    if (cubes[j] == "#") {
      playground[25 + i, 25 + j, 25, 25] <- "#"
    }
  }
}

generate_next_round <- function() {
  result <- playground
  active_cube_locations <- which(playground == "#", arr.ind = TRUE)
  min_extent <- min(active_cube_locations) - 1
  max_extent <- max(active_cube_locations) + 1
  for (i in min_extent:max_extent) {
    for (j in min_extent:max_extent) {
      for (k in min_extent:max_extent) {
        for (l in min_extent:max_extent) {
          field <-
            playground[(i - 1):(i + 1), (j - 1):(j + 1), (k - 1):(k + 1), (l-1):(l+1)]
          if (playground[i, j, k, l] == "." &&
              length(field[field == "#"]) == 3) {
            result[i, j, k, l] <- "#"
          } else if (playground[i, j, k, l] == "#") {
            if (length(field[field == "#"]) < 3 ||
                length(field[field == "#"]) > 4) {
              result[i, j, k, l] <- "."
            }
          }
        }
      }
    }
  }
  return(result)
}

for (i in 1:6) {
  playground <- generate_next_round()
}
part2 <- length(playground[playground == "#"])
