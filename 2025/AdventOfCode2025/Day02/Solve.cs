using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day02
{
    public static class Solve
    {
        public static long Part1(string pathToInput)
        {
            long result = 0;
            var input = System.IO.File.ReadAllLines(pathToInput);
            var ranges = input[0].Split(',');
            foreach (var range in ranges)
            {
                var bounds = range.Split('-').Select(long.Parse).ToArray();
                var lowerBound = bounds[0];
                var upperBound = bounds[1];
                for (var number = lowerBound; number <= upperBound; number++)
                {
                    var numberStr = number.ToString();
                    if (numberStr.Length % 2 == 0)
                    {
                        var mid = numberStr.Length / 2;
                        var leftPart = numberStr.Substring(0, mid);
                        var rightPart = numberStr.Substring(mid);
                        if (string.Equals(leftPart, rightPart))
                        {
                            Console.WriteLine($"Found matching number: {number}");
                            result+=number;
                        }
                    }
                }
            }
            return result;
        }

        public static long Part2(string pathToInput)
        {
            long result = 0;
            var input = System.IO.File.ReadAllLines(pathToInput);
            var ranges = input[0].Split(',');
            foreach (var range in ranges)
            {
                var bounds = range.Split('-').Select(long.Parse).ToArray();
                var lowerBound = bounds[0];
                var upperBound = bounds[1];
                for (var number = lowerBound; number <= upperBound; number++)
                {
                    var numberStr = number.ToString();
                    var doubleUp = numberStr + numberStr;
                    var isItIn = doubleUp.IndexOf(numberStr, 1);
                    if (isItIn != -1 && isItIn < numberStr.Length)
                    {
                        Console.WriteLine($"Found matching number: {number}");
                        result+=number;
                    }
                }
            }
            return result;

        }
    }
}