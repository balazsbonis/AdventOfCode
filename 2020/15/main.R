input <- c(0, 12, 6, 13, 20, 1, 17)
limit <- 3e7
numbers <- rep(0, limit)
numbers[1:length(input)] <- input

for (i in (length(input) + 1):limit) {
  last_no <- numbers[i - 1]
  if (any(numbers[1:(i - 2)] == last_no)) {
    d <- diff(tail(which(numbers[1:(i - 1)] == last_no), 2))
    numbers[i] <- d
  }
}
print(numbers[limit])
