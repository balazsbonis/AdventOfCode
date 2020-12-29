card_key <- 5099500
door_key <- 7648211
loop_size <- 10e7

find_public_key <- function(target, subject_number) {
  i <- 1
  temp <- 1
  while (i < loop_size) {
    temp <- (temp * subject_number) %% 20201227
    if (temp == target) {
      break
    }
    i <- i + 1
  }
  return(i)
}

#card_loop <- find_public_key(card_key, 7)
print(card_loop)
#door_loop <- find_public_key(door_key, 7)
print(door_loop)

answer <- 1
for (j in 1:door_loop) {
  answer <- (answer * card_key) %% 20201227
}

print(answer)
