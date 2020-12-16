input <- c(0, 12, 6, 13, 20, 1, 17)
limit <- 30000000
numbers <- rep(0, limit)
numbers[1:length(input)] <- input
mylist <- rep(0, limit)
mylist[1] <- 1
mylist[13] <- 2
mylist[7] <- 3
mylist[14] <- 4
mylist[21] <- 5
mylist[2] <- 6

for (i in (length(input) + 1):limit) {
  if (i %% 100000 == 0)
    print(i)
  last_no <- numbers[i - 1]
  number_found <- mylist[(last_no + 1)]
  if (number_found == 0) {
    mylist[(last_no + 1)] <- (i - 1)
  } else {
    numbers[i] <- i - 1 - number_found
    mylist[(last_no + 1)] <- (i - 1)
  }
}
print(numbers[limit])
