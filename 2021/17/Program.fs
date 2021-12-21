let mutable counter = 0
let mutable x = 1 // going up
let mutable y = 146 // going down

let validateTrajectory x y : int =
    let traj = seq 
                { 
                    for i in 0..10 do 
                        ((if (x-i>0) then (x-i) else 0),y-i)
                } |> Seq.toList
    let minX = traj |> List.minBy (fun (curX, curY) -> curX)
    0

let blah = validateTrajectory x y
// For more information see https://aka.ms/fsharp-console-apps
printfn "Hello from F#"
