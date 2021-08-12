input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\20\\input.txt",
       character(),
       sep = "\n")
tiles <- list()
current_tile <- NA
tile_size <- 10
neighbourhood <- rep(0, 10000)

# parse tiles
for (line in input) {
  if (grepl("Tile", line, fixed = TRUE)) {
    # new tile
    current_tile <- matrix(".", nrow = tile_size, ncol = tile_size)
    tile_number <- strtoi(sub(":", "", strsplit(line, " ")[[1]][2]))
    rowcount <- 1
  } else {
    current_tile[rowcount,] <- strsplit(line, "")[[1]]
    rowcount <- rowcount + 1
    if (rowcount > tile_size) {
      tiles[[toString(tile_number)]] <- current_tile
    }
  }
}

get_sides <- function(tile) {
  sides <-
    list(
      top = tile[1, ],
      toprev = rev(tile[1, ]),
      bot = tile[tile_size, ],
      botrev = rev(tile[tile_size, ]),
      left = tile[, 1],
      leftrev = rev(tile[, 1]),
      right = tile[, tile_size],
      rightrev = rev(tile[, tile_size])
    )
  return(sides)
}

# find neighbours
for (i in 1:(length(tiles) - 1)) {
  sides_i <- get_sides(tiles[[i]])
  for (j in (i + 1):length(tiles)) {
    sides_j <- get_sides(tiles[[j]])
    for (k in 1:length(sides_i)) {
      for (l in 1:length(sides_j)) {
        if (all(sides_i[[k]] == sides_j[[l]])) {
          neighbourhood[strtoi(names(tiles[i]))] <-
            neighbourhood[strtoi(names(tiles[i]))] + 1
          neighbourhood[strtoi(names(tiles[j]))] <-
            neighbourhood[strtoi(names(tiles[j]))] + 1
          #print(paste(names(sides_i[k]), "of", names(tiles[i]), "matches",
            #names(sides_j[l]), "of", names(tiles[j])))
        }
      }
    }
  }
}

# strip out double counts
neighbourhood <- neighbourhood / 2
part1 <- prod(which(neighbourhood == 2))


## Part 2
# get the image and put the first corner in
image_size <- sqrt(length(tiles)) * tile_size
image <- matrix(".", nrow = image_size, ncol = image_size)
first_corner <- tiles[toString(min(which(neighbourhood == 2)))]
image[1:tile_size, 1:tile_size] <- first_corner[[1]]
tiles_left_to_place <- names(tiles)
tiles_left_to_place <- tiles_left_to_place[tiles_left_to_place != first_corner_name]
tiles_placed_this_round <- c(first_corner_name)
while (length(tiles_left_to_place) > 0){
  tiles_placed_now <- c()
  # find right side neighbour
  
}