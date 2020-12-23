input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\22\\input.txt",
       character(),
       sep = "\n")

player2_from <- which(input == "Player 2:")
player1 <- strtoi(input[2:(player2_from - 1)])
player2 <- strtoi(input[(player2_from + 1):length(input)])

recursive_combat <- function(player1, player2) {
  memory <- list()
  player1_count <- length(player1)
  player2_count <- length(player2)
  
  temp1 <-
    temp2 <- rep(0, (player1_count + player2_count))
  temp1[1:player1_count] <- player1
  temp2[1:player2_count] <- player2
  
  while (player1_count > 0 && player2_count > 0) {
    current_state <- paste(toString(temp1), "|", toString(temp2))
    print("------------- ROUND")
    print(paste("Player 1:", toString(temp1)))
    print(paste("Player 2:", toString(temp2)))
    if (any(memory == current_state)) {
      # player 1 wins
      return(list(winner = "Player 1", cards = temp1))
    }
    memory <- append(memory, current_state)
    
    top1 <- temp1[1]
    if (player1_count > 0)
      temp1[1:(player1_count - 1)] <- temp1[2:player1_count]
    temp1[player1_count] <- 0
    player1_count <- player1_count - 1
    
    top2 <- temp2[1]
    if (player2_count > 0)
      temp2[1:(player2_count - 1)] <- temp2[2:player2_count]
    temp2[player2_count] <- 0
    player2_count <- player2_count - 1
    print(paste(top1, "VS", top2))
    
    if ((top1 <= player1_count) &&
        (top2 <= player2_count)) {
      # recursive combat
      print("------ ENTERING Recursive")
      # shortcut courtesy of AdroMine. Works without it too, just takes A LOT longer
      if (max(temp1[1:top1]) > max(temp2[1:top2])) {
        winner <- list(winner = "Player 1", cards = temp1)
      } else {
        winner <- recursive_combat(temp1[1:top1], temp2[1:top2])
      }
    } else {
      if (top1 > top2) {
        winner <- list(winner = "Player 1", cards = temp1)
      } else{
        winner <- list(winner = "Player 2", cards = temp2)
      }
    }
    
    if (winner$winner == "Player 1") {
      temp1[(player1_count + 1):(player1_count + 2)] <-
        c(top1, top2)
      player1_count <- player1_count + 2
    } else {
      temp2[(player2_count + 1):(player2_count + 2)] <-
        c(top2, top1)
      player2_count <- player2_count + 2
    }
  }
  if (player2_count > 0) {
    return(list(winner = "Player 2", cards = temp2))
  } else
    return(list(winner = "Player 1", cards = temp1))
}

result <- recursive_combat(player1, player2)

cards <- rev(result$cards)
part2 <- 0
for (i in 1:length(cards)) {
  part2 <- part2 + (i * cards[i])
}