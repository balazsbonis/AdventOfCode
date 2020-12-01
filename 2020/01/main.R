data <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\01\\input.txt",
       integer())
sortedData <- sort(data)

grid1 <- expand.grid(sortedData, sortedData)
sums1 <- rowSums(grid1)
idx1 <- which(sums1 == 2020)
print(paste("index:", idx1[1], "; product:", prod(grid1[idx1[1], ])))

grid2 <- expand.grid(sortedData, sortedData, sortedData)
sums2 <- rowSums(grid2)
idx2 <- which(sums2 == 2020)
print(paste("index:", idx2[1], "; product:", prod(grid2[idx2[1], ])))
