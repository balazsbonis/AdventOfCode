open System
open System.IO
open System.Collections

[<EntryPoint>]
let main argv =
    let input = File.ReadLines("C:\\Work\\Code\\AdventOfCode\\2021\\10\\input.txt") 
                    |> Seq.toList
    let mutable part1score = 0
    let mutable part2scores : List<int> = []
    for line in input do
        let s = new Stack()
        let mutable foundCorruption = false
        let mutable i = 0
        let charray = line.ToCharArray()
        while (foundCorruption = false && i < charray.Length) do
            let c = charray.[i]
            i <- i + 1
            if (c = '(' || c = '[' || c = '{' || c = '<') then s.Push(c)
            else
                let top = s.Pop().ToString().[0]
                if ((top = '(' && c <> ')') || (top = '[' && c <> ']')
                    || (top = '{' && c <> '}')|| (top = '<' && c <> '>')) 
                    then 
                        foundCorruption <- true
                        part1score <- part1score + match c with
                                                    | ')' -> 3
                                                    | ']' -> 57
                                                    | '}' -> 1197
                                                    | _ -> 25137
                        printfn "Expected %c but got %c" top c

        if (foundCorruption = false)
            then
                printfn "Line is incomplete %s" line
                let mutable score = 0
                for i = 0 to s.Count - 1 do
                    let top = s.Pop().ToString().[0]
                    score <- score * 5 + match top with
                                            | '(' -> 1
                                            | '[' -> 2
                                            | '{' -> 3
                                            | _ -> 4
                part2scores <- part2scores @ [score]

    printfn "End part 1 score %i" part1score
    let blah = part2scores |> List.sort
    printfn "End part 2 score %i" (part2scores |> List.sort |> List.skip(part2scores.Length/2) |> List.take 1 |> List.exactlyOne)
    0