List<List<char>> crates = new List<List<char>> {
    // new List<char> { 'N', 'Z'},
    // new List<char> { 'D', 'C', 'M'},
    // new List<char> { 'P'},
    new List<char> { 'H', 'L', 'R', 'F', 'B', 'C', 'J', 'M'},
    new List<char> { 'D', 'C', 'Z'},
    new List<char> { 'W', 'G', 'N', 'C', 'F', 'J', 'H'},
    new List<char> { 'B', 'S', 'T', 'M', 'D', 'J', 'P'},
    new List<char> { 'J', 'R', 'D', 'C', 'N'},
    new List<char> { 'Z', 'G', 'J', 'P', 'Q', 'D', 'L', 'W'},
    new List<char> { 'H', 'R', 'F', 'T', 'Z', 'P'},
    new List<char> { 'G', 'M', 'V', 'L'},
    new List<char> { 'J', 'R', 'Q', 'F', 'P', 'G', 'B', 'C'}
};
using (var str = File.OpenText("input.txt")){
    while(!str.EndOfStream)
    {
        // parse line
        var l = str.ReadLine().Replace("move", "");
        var p1 = l.Split(" from ");
        var cnt = int.Parse(p1[0]);
        var p2 = p1[1].Split(" to ");
        var frm = int.Parse(p2[0]);
        var to = int.Parse(p2[1]);

        // move
        var move = crates[frm - 1].Take(cnt);//.Reverse(); // Reverse for part 1
        crates[to - 1].InsertRange(0, move);
        crates[frm - 1].RemoveRange(0, cnt);
        
    }
}
// part 1
Console.WriteLine(string.Concat(crates.Select(x => x.First())));
// part 2
