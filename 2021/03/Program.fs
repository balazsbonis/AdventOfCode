open System
open System.IO

let part01 : int =
    let lines = File.ReadLines("C:\\Work\\Code\\AdventOfCode\\2021\\03\\input.txt") 
                |> Seq.toList
    let totalLength = lines.Length
    let mutable arr = Array.zeroCreate (lines.[0].ToCharArray().Length)
    for ll in lines do
        let line = ll.ToCharArray() |> Array.map (fun x -> int x - 48)
        for i = 0 to line.Length - 1 do
            arr.[i] <- arr.[i] + line.[i]

    let mutable gamma = 0
    let mutable epsilon = 0
    let mutable currentBitPower = 1
    for i = arr.Length - 1 downto 0 do
        gamma <- if (arr.[i] > totalLength / 2) then gamma + currentBitPower else gamma
        epsilon <- if (arr.[i] < totalLength / 2) then epsilon + currentBitPower else epsilon
        currentBitPower <- currentBitPower * 2
    gamma * epsilon

let part02 : int =
    let lines = File.ReadLines("C:\\Work\\Code\\AdventOfCode\\2021\\03\\input.txt") 
                |> Seq.toList
    let height = lines.Length
    let width = lines.[0].Length
    let mutable filteredLines = lines
    let mutable oxygen = ""
    let mutable co2 = ""

    for i = 0 to width - 1 do
        let cnt = filteredLines |> List.filter(fun x -> x.[i] = '1') |> List.length
        let moreOrLess = double cnt >= double filteredLines.Length / 2.0
        filteredLines <- filteredLines |> List.filter(fun x -> x.[i] = (if moreOrLess then '1' else '0'))
        oxygen <- if filteredLines.Length = 1 then filteredLines.[0] else oxygen

    filteredLines <- lines
    for i = 0 to width - 1 do
        let cnt = filteredLines |> List.filter(fun x -> x.[i] = '0') |> List.length
        let moreOrLess = double cnt <= double filteredLines.Length / 2.0
        filteredLines <- filteredLines |> List.filter(fun x -> x.[i] = (if moreOrLess then '0' else '1'))
        co2 <- if filteredLines.Length = 1 then filteredLines.[0] else co2

    printfn "O: %s CO2: %s" oxygen co2
    0

[<EntryPoint>]
let main argv =
    //printfn "Part 1 - %i" part01
    printfn "Part 2 - %i" part02
    let endingKeyStroke = Console.ReadLine()
    0 // return an integer exit code 3678 ()