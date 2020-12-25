input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\24\\input.txt",
       character(),
       sep = "\n")

# set scene
grid_size <- 250
playground <- array(FALSE, dim = c(grid_size, grid_size))

get_axial_coordinates <- function(line) {
  line <- unlist(strsplit(line, ""))
  i <- 1
  q <- r <- grid_size / 2
  while (i <= length(line)) {
    if (line[i] == "s") {
      r <- r + 1
      if (line[(i + 1)] == "w")
        q <- q - 1
      i <- i + 1
    } else if (line[i] == "n") {
      r <- r - 1
      if (line[(i + 1)] == "e")
        q <- q + 1
      i <- i + 1
    } else if (line[i] == "e") {
      q <- q + 1
    } else if (line[i] == "w") {
      q <- q - 1
    }
    i <- i + 1
  }
  return(c(q, r))
}

get_hex_neighbours <- function(q, r, m) {
  return(c(m[q, (r - 1)],
           m[(q + 1), (r - 1)],
           m[(q + 1), r],
           m[q, (r + 1)],
           m[(q - 1), (r + 1)],
           m[(q - 1), r]))
}

generate_next_round <- function(playground) {
  result <- playground
  active_tile_locations <- which(playground == TRUE, arr.ind = TRUE)
  min_extent <- min(active_tile_locations) - 1
  max_extent <- max(active_tile_locations) + 1
  for (i in min_extent:max_extent) {
    for (j in min_extent:max_extent) {
      neighbours <- get_hex_neighbours(i, j, playground)
      if (playground[i, j]) {
        black_count <- length(neighbours[neighbours])
        result[i,j] <- !(black_count == 0 || black_count > 2)
      } else {
        black_count <- length(neighbours[neighbours])
        result[i,j] <- black_count == 2
      }
    }
  }
  return(result)
}

#draw initial state
for (line in input) {
  result <- get_axial_coordinates(line)
  playground[result[1], result[2]] <-
    !playground[result[1], result[2]]
}

# part 1
part1 <- length(playground[playground])
print(part1)

# part 2
for (i in 1:100) {
  playground <- generate_next_round(playground)
  print(paste(i,length(playground[playground])))
}