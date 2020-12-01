data <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\01\\input.txt",
       integer())
sortedData <- sort(data)
counters <- c(1, length(sortedData))

repeat {
  curSum <- sortedData[counters[1]] + sortedData[counters[2]]
  if (curSum > 2020) {
    counters[2] <- counters[2] - 1
  }
  if (curSum == 2020) {
    break
  }
  if (curSum < 2020) {
    counters[2] <- length(sortedData)
    counters[1] <- counters[1] + 1
  }
}

print(paste("data[", counters[1], "] + data [", counters[2], "] = 2020; product = ", sortedData[counters[1]] * sortedData[counters[2]]))


counters <- c(1, 2, length(sortedData))
repeat {
  curSum <- sortedData[counters[1]] + sortedData[counters[2]] + sortedData[counters[3]]
  if (curSum > 2020) {
    counters[3] <- counters[3] - 1
  }
  if (curSum == 2020) {
    break
  }
  if (curSum < 2020) {
    counters[3] <- length(sortedData)
    counters[2] <- counters[2] + 1
  }
  if (counters[2] == counters[3]){
    counters[1] <- counters[1] + 1
    counters[2] <- counters[1] + 1
    counters[3] <- length(sortedData)
  }
}

print(paste("data[", counters[1], " + ", counters[2], " + ", counters[3] ,"] = 2020; product = ", sortedData[counters[1]] * sortedData[counters[2]]* sortedData[counters[3]]))
