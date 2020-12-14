f <- file("c:\\Work\\Code\\AdventOfCode\\2020\\14\\input.txt", "r")
mem <- list()
mask <- strrep("x", 36)
while (TRUE) {
  line <- readLines(f, n = 1)
  if (length(line) == 0) {
    break
  }
  l <- strsplit(line, " = ")[[1]]
  if (l[1] == "mask") {
    mask <- l[2]
  } else{
    address <- sub("\\]", "", sub("mem\\[", "", l[1]))
    value <- strtoi(l[2])
    value_bits <- c(0, 0, 0, 0, rev(intToBits(value)))
    mask_bits <- strsplit(mask, split = "")[[1]]
    result <- mask_bits
    for (i in 1:length(mask_bits)) {
      if (mask_bits[i] == "X") {
        result[i] <- value_bits[i]
      }
    }
    mem[address] <- paste(result, collapse = "")
  }
}

part1 <- 0.0
for (m in mem) {
  bits <- strsplit(m, "")[[1]]
  for (i in 1:36) {
    if (bits[i] == "1") {
      part1 <- part1 + (2 ^ (36 - i))
    }
  }
}
print(part1, digits = 15)
