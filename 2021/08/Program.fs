open System
open System.IO


[<EntryPoint>]
let main argv =
    let result = File.ReadLines("C:\\Work\\Code\\AdventOfCode\\2021\\08\\input.txt") 
                    |> Seq.map(fun r -> r.Split(" | ")) |> Seq.map(fun r -> r.[1].Split(" "))
                    |> Seq.concat |> Seq.filter(fun f -> f.Length = 2 || f.Length = 3 || f.Length = 4 || f.Length = 7)
                    |> Seq.length
    result