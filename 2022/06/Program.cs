// var input = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".ToCharArray();
var input = File.OpenText("input.txt").ReadToEnd().ToCharArray();

for (int i = 0; i< input.Count() - 14; i++){
    var window = input.Skip(i).Take(14);
    if (window.Distinct().Count() == 14){
        Console.WriteLine(i + 14);
        break;
    }
}

// change 14 to 4 for part1.