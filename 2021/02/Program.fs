open System
open System.IO
open System.Linq

let part01 : int =
    let lines = File.ReadLines("C:\\Work\\Code\\AdventOfCode\\2021\\02\\input.txt") |> Seq.map string
    let mutable horizontalPosition = 0
    let mutable depth = 0
    for ll in (lines.ToList()) do
        let spl = ll.Split(' ')
        horizontalPosition <- 
            if (spl.[0] = "forward") then horizontalPosition + int (spl.[1]) else horizontalPosition
        depth <- if (spl.[0] = "down") then depth + int (spl.[1]) elif (spl.[0] = "up") then depth - int (spl.[1]) else depth
    
    horizontalPosition * depth

let part02 : int =
    let lines = File.ReadLines("C:\\Work\\Code\\AdventOfCode\\2021\\02\\input.txt") |> Seq.map string
    let mutable horizontalPosition = 0
    let mutable depth = 0
    let mutable aim = 0
    for ll in (lines.ToList()) do
        let spl = ll.Split(' ')
        aim <- if (spl.[0] = "down") then aim + int (spl.[1]) elif (spl.[0] = "up") then aim - int (spl.[1]) else aim
        horizontalPosition <- 
            if (spl.[0] = "forward") then horizontalPosition + int (spl.[1]) else horizontalPosition
        depth <- if (spl.[0] = "forward") then depth + (int (spl.[1]) * aim) else depth
    
    horizontalPosition * depth

[<EntryPoint>]
let main argv =
    printfn "Part 1 - %i" part01
    printfn "Part 2 - %i" part02
    let endingKeyStroke = Console.ReadLine()
    0 // return an integer exit code