var part01 = 0;
var part02 = 0;
var arr = new List<List<int>>();
using (var str = File.OpenText("input.txt")){
    while(!str.EndOfStream)
    {
        var line = str.ReadLine().ToCharArray().Select(x => (int) x - 38).Select(x => x > 59 ? x -= 58 : x);
        var first = line.Take(line.Count() / 2);
        part01 += line.Skip(line.Count() / 2).Intersect(first).FirstOrDefault();
        arr.Add(line.ToList());
        if (arr.Count == 3){
            part02 += arr[0].Intersect(arr[1]).Intersect(arr[2]).FirstOrDefault();
            arr = new List<List<int>>();
        }
    }
}
// part 1
Console.WriteLine(part01);
// part 2
Console.WriteLine(part02);
