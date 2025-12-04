using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day03
{
    public static class Solve
    {
        public static long Part1(string pathToInput)
        {
            int result = 0;
            InputReader.ReadLines(pathToInput, (line) =>
            {
                var digits = line.Select(c => int.Parse(c.ToString())).ToArray();
                var highestDigit = digits[0..(digits.Length-1)].Max();
                var posOfHighest = Array.IndexOf(digits, highestDigit);
                var highestFromThere = digits[(posOfHighest+1)..].Max();
                result += (highestDigit*10) + highestFromThere;
            });
            return result;
        }

        public static long Part2(string pathToInput)
        {
            long result = 0;
            InputReader.ReadLines(pathToInput, (line) =>
            {
                var digits = line.Select(c => int.Parse(c.ToString())).ToArray();
                long addToResult = 0;
                for (int i = 11; i >= 0; i--)
                {
                    var highestDigit = digits[0..(digits.Length-i)].Max();
                    var posOfHighest = Array.IndexOf(digits, highestDigit);
                    addToResult = (addToResult * 10) + highestDigit;
                    digits = digits[(posOfHighest+1)..];
                }
                result += addToResult;
            });
            return result;
        }
    }
}