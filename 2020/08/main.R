input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\08\\input.txt",
       character(),
       sep = "\n")

run <- function(input, change) {
  accumulator <- 0
  pointer <- 1
  lines_read <- list()
  terminated <- FALSE
  change_line_counter <- 1
  
  while (TRUE) {
    if (pointer > length(input)) {
      terminated <- TRUE
      print("TERMINATED.")
      break
    }
    line <- unlist(strsplit(input[pointer], " "))
    if (pointer %in% lines_read) {
      print("INFINITE LOOP!")
      break
    }
    lines_read <- append(lines_read, pointer)
    
    if (line[1] == "nop" || line[1] == "jmp"){
      if (change_line_counter == change){
        if (line[1] == "nop") line[1] <- "jmp"
        else if (line[1] == "jmp") line[1] <- "nop"
        change_line_counter <- 0
      }
      else {
        change_line_counter <- change_line_counter + 1
      }
    }
    
    if (line[1] == "nop") {
      pointer <- pointer + 1
    }
    if (line[1] == "acc") {
      accumulator <- accumulator + strtoi(line[2])
      pointer <- pointer + 1
    }
    if (line[1] == "jmp") {
      pointer <- pointer + strtoi(line[2])
    }
  }
  return (c(
    accumulator = accumulator,
    pointer = pointer,
    terminated = terminated
  ))
}

#part1 <- run(input, 0)
#print(part1)

change <- 1
t <- FALSE
while (!t) {
  part2 <- run(input, change)
  if (part2["terminated"] == TRUE) {
    t <- TRUE
  }
  change <- change + 1
}