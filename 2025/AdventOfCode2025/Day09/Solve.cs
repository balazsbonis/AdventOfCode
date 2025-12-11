using System.Drawing;
using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day09
{
    public static class Solve
    {
        public static long CalculateRectangleArea(Point a, Point b)
        {
            long width = Math.Abs(a.X - b.X) + 1;
            long height = Math.Abs(a.Y - b.Y) + 1;
            return width * height;
        }

        public static long Part1(string pathToInput)
        {
            var points = new List<Point>();
            var lines = File.ReadAllLines(pathToInput).Select(x=>x.Split(','))
                .Select(parts => new Point(int.Parse(parts[0]), int.Parse(parts[1]))).ToArray();
            var areas = new Dictionary<(Point, Point), double>();
            for (int row = 0; row < lines.Length; row++)
            {
                var currentLine = lines[row];
                for (int next = row+1; next<lines.Length; next++)
                {
                    var nextLine = lines[next];
                    areas.Add((currentLine, nextLine), CalculateRectangleArea(currentLine, nextLine));
                }
            }
            return (long)areas.Values.Max(); // 4752484112
        }

        public static long Part2(string pathToInput)
        {
            return 0;
        }
    }
}