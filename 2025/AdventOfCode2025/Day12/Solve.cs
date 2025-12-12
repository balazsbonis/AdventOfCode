using System.Net;
using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day12
{
    public static class Solve
    {
        public static long Part1(string pathToInput)
        {
            var definitelyPossible = 0;
            InputReader.ReadLines(pathToInput, (line) =>
            {
                if (line.Contains("x"))
                {
                    var parts = line.Split(':');
                    var totalNumberOfBoxes = parts[1].Trim().Split(' ').Sum(x=>int.Parse(x));
                    var size = parts[0].Trim().Split('x').Select(x=>int.Parse(x)).ToArray();
                    if (((size[0] / 3) * (size[1] / 3)) >= totalNumberOfBoxes)
                    {
                        definitelyPossible++;
                        Console.WriteLine($"{totalNumberOfBoxes} boxes fit in {size[0]}x{size[1]}");
                    }
                    else
                    {
                        
                    }
                }
            });
            return definitelyPossible; // LOL WHAT THE FUCK
        }


        public static long Part2(string pathToInput)
        {
            return 0;
        }
    }
}