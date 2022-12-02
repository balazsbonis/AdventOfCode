List<int> elves = new List<int>() {0};
using (var str = File.OpenText("input.txt")){
    while(!str.EndOfStream)
    {
        var l = str.ReadLine();
        if (!string.IsNullOrEmpty(l)){
            elves[elves.Count-1] += int.Parse(l);
        } else{
            elves.Add(0);
        }
    }
}
// part 1
Console.WriteLine(elves.Max());
// part 2
Console.WriteLine(elves.OrderByDescending(x=>x).Take(3).Sum());
