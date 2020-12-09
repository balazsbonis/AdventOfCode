input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\09\\input.txt",
       numeric(),
       sep = "\n")

preamble_length <- 25
start_index <- 1
target_number <- 0 # part1

while (TRUE) {
  found_number <- FALSE
  if ((start_index + preamble_length) > length(input)) {
    break
  }
  preamble <- input[start_index:(start_index + preamble_length - 1)]
  number_to_check <- input[start_index + preamble_length]
  m <- outer(preamble, preamble, FUN = "+")
  for (i in 1:(preamble_length - 1))
    for (j in (i + 1):preamble_length) {
      if (m[i, j] == number_to_check) {
        start_index <- start_index + 1
        found_number <- TRUE
      }
    }
  if (found_number == FALSE) {
    print("Found it.")
    target_number <- number_to_check
    break
  }
}




set_size <- 1
part2 <- c(0)
while (part2 == c(0)) {
  set_size <- set_size + 1
  # start from all possible positions
  for (i in 1:(length(input) - set_size)) {
    current_sum <- sum(input[i:(i + set_size - 1)])
    if (current_sum == target_number) {
      print("Found part 2.")
      part2 <- sort(input[i:(i + set_size - 1)])
      print(input[i:(i + set_size)])
      break
    }  
  }  
}
print(min(part2) + max(part2))
