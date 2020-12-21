f <- file("c:\\Work\\Code\\AdventOfCode\\2020\\14\\input.txt", "r")
mem <- list()
mask <- strrep("x", 36)

generate_addresses <- function(result) {
  result <- strsplit(result, "")[[1]]
  x <- which(result == 'X')[1]
  if (is.na(x))
    return(paste(result, collapse = ""))
  if (x == 1) {
    p1 <- ""
  } else {
    p1 <- paste(result[1:(x - 1)], collapse = "")
  }
  if (x == 36) {
    p2 <- ""
  }
  else {
    p2 <- paste(result[(x + 1):36], collapse = "")
  }
  pp <- paste0(p1, 0:1, p2)
  return(c(generate_addresses(pp[1]), generate_addresses(pp[2])))
}

bitsToLong <- function(bits) {
  result <- 0
  for (i in 1:36) {
    if (bits[i] == "1") {
      result <- result + (2 ^ (36 - i))
    }
  }
  return(result)
}

while (TRUE) {
  line <- readLines(f, n = 1)
  if (length(line) == 0) {
    break
  }
  print(line)
  l <- strsplit(line, " = ")[[1]]
  if (l[1] == "mask") {
    mask <- l[2]
  } else {
    address <- sub("\\]", "", sub("mem\\[", "", l[1]))
    value <- strtoi(l[2])
    address_bits <- c(0, 0, 0, 0, rev(intToBits(address)))
    mask_bits <- strsplit(mask, split = "")[[1]]
    result <- mask_bits
    for (i in 1:length(mask_bits)) {
      if (mask_bits[i] == "0") {
        result[i] <- address_bits[i]
      }
    }
    print("Generating addresses")
    combinations <- generate_addresses(paste(result, collapse = ""))
    print(paste("Saving to", length(combinations), "addresses"))
    for (c in combinations) {
      b <- bitsToLong(strsplit(c, "")[[1]])
      mem[toString(b)] <- value
    }
  }
}
