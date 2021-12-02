open System
open System.IO
open System.Linq

let readFileToList (filePath:string) = seq {
    use sr = new StreamReader (filePath)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
}

let part01 : int =
    let numbers = (readFileToList "C:\\Work\\Code\\AdventOfCode\\2021\\01\\input.txt").ToList() 
    let mutable counter = 0
    
    for i = 0 to (numbers.Count - 2) do
        counter <- if (int numbers.[i + 1] > int numbers.[i]) then counter + 1 else counter
    
    counter

let part02 : int =
    let numbers = (readFileToList "C:\\Work\\Code\\AdventOfCode\\2021\\01\\input.txt").ToList()
    let mutable counter = 0
    
    for i = 0 to (numbers.Count - 4) do
        let window1 = int numbers.[i] + int numbers.[i+1] + int numbers.[i+2]
        let window2 = int numbers.[i+1] + int numbers.[i+2] + int numbers.[i+3]
        counter <- if (window2 > window1) then counter + 1 else counter
    
    counter

[<EntryPoint>]
let main argv =
    printfn "Part 1 %i" part01 
    printfn "Part 2 %i" part02 
    0