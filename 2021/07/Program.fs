open System
open System.IO

let part01 : int =
    let input = File.ReadLines("C:\\Work\\Code\\AdventOfCode\\2021\\07\\demo.txt") 
                    |> Seq.map (fun r -> r.Split(',')) |> Seq.exactlyOne |> Array.map int |> Array.sort |> Array.toList
    [input.Head .. List.last input]
                        |> List.map(fun i -> input |> List.fold (fun total current -> total + Math.Abs(current - i)) 0)
                        |> List.min


let fuelBurn length : int =
    [ 1..length] |> List.sum

let part02 : int =
    let input = File.ReadLines("C:\\Work\\Code\\AdventOfCode\\2021\\07\\input.txt") 
                    |> Seq.map (fun r -> r.Split(',')) |> Seq.exactlyOne |> Array.map int |> Array.sort |> Array.toList
    [input.Head .. List.last input]
                        |> List.map(fun i -> input |> List.fold (fun total current -> total + fuelBurn (Math.Abs(current - i))) 0)
                        |> List.min


[<EntryPoint>]
let main argv =
    printfn "Part 1 - %i" part01
    printfn "Part 2 - %i" part02
    let endingKeyStroke = Console.ReadLine()
    0 // return an integer exit code 3678 ()