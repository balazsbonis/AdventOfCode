let mutable player1Position = 4
let mutable player2Position = 1
let mutable player1Score = 0
let mutable player2Score = 0
let mutable dieValue = 1
let mutable ended = false

let rollDie dieValue position : int =
    let roll = dieValue * 3 + 3
    let mutable newPosition = ((roll % 10) + position) % 10
    if (newPosition = 0) then newPosition <- 10
    newPosition

while (ended = false) do

    player1Position <- rollDie dieValue player1Position
    player1Score <- player1Score + player1Position
    dieValue <- dieValue + 3
    if (player1Score > 999) then ended <- true

    else 
        player2Position <- rollDie dieValue player2Position
        player2Score <- player2Score + player2Position
        dieValue <- dieValue + 3
    if (player2Score > 999) then ended <- true

printfn "%i" ((dieValue - 1) * player2Score)
let l = System.Console.ReadLine()