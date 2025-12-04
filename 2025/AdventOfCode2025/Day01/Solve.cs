using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day01
{
    public static class Solve
    {
        public static int Part1(string pathToInput)
        {
            int currentPointer = 50;
            int result = 0;
            InputReader.ReadLines(pathToInput, (line) =>
            {
                var value = int.Parse(line.Substring(1));
                if (line[0] == 'L')
                {
                    currentPointer -= value;
                }
                else if (line[0] == 'R')
                {
                    currentPointer += value;
                }
                
                // Handle wrapping with modulo to support any value
                currentPointer = ((currentPointer % 100) + 100) % 100;
                
                if (currentPointer == 0)
                {
                    result++;
                }
            });
            return result;
        }

        public static int Part2(string pathToInput)
        {
            int result = 0;
            var numbersSeen = Enumerable.Range(50, 1);
            InputReader.ReadLines(pathToInput, (line) =>
            {
                var value = int.Parse(line.Substring(1));
                var currentPosition = numbersSeen.Last();
                
                if (line[0] == 'L')
                {
                    // Turn left: generate steps going down
                    var steps = Enumerable.Range(1, value)
                        .Select(i => ((currentPosition - i) % 100 + 100) % 100);
                    numbersSeen = numbersSeen.Concat(steps);
                }
                else if (line[0] == 'R')
                {
                    // Turn right: generate steps going up
                    var steps = Enumerable.Range(1, value)
                        .Select(i => (currentPosition + i) % 100);
                    numbersSeen = numbersSeen.Concat(steps);
                }
            });
            return numbersSeen.Count(n => n == 0);
        }
    }
}