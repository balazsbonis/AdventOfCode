input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\22\\input.txt",
       character(),
       sep = "\n")

player2_from <- which(input == "Player 2:")
player1 <- strtoi(input[2:(player2_from - 1)])
player2 <- strtoi(input[(player2_from + 1):length(input)])
while (length(player1) > 0 && length(player2) > 0) {
  top1 <- player1[1]
  top2 <- player2[1]
  if (player1[1] > top2) {
    if (length(player2) == 1)
      player2 <- c()
    else
      player2 <- c(player2[2:length(player2)])
    player1 <- c(player1[2:length(player1)], top1, top2)
  } else{
    if (length(player1) == 1)
      player1 <- c()
    else
      player1 <- c(player1[2:length(player1)])
    player2 <- c(player2[2:length(player2)], top2, top1)
    
  }
}

player1<-rev(player1)
part1<-0
for (i in 1:length(player1)){
  part1<-part1+(i*player1[i])
}
