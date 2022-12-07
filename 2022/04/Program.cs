var part01 = 0;
var part02 = 0;
using (var str = File.OpenText("input.txt")){
    while(!str.EndOfStream)
    {
        var line = str.ReadLine().Split(',').Select(x=>x.Split('-').Select(x=>int.Parse(x)).ToArray()).ToArray();
        var first = Enumerable.Range(line[0][0], line[0][1] - line[0][0] + 1);
        var second = Enumerable.Range(line[1][0], line[1][1] - line[1][0] + 1);
        if (first.All(x => second.Contains(x)) || second.All(x => first.Contains(x))){
            part01++;
        }
        if (first.Intersect(second).Any()){
            part02++;
        }
    }
}
// part 1
Console.WriteLine(part01);
// part 2
Console.WriteLine(part02);
