using System.Drawing;
using System.Security.Cryptography.X509Certificates;
using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day08
{
    public class Point3D
    {
        public int X { get; set; }
        public int Y { get; set; }
        public int Z { get; set; }

        public Point3D(string input)
        {
            var parts = input.Split(',');
            X = int.Parse(parts[0]);
            Y = int.Parse(parts[1]);
            Z = int.Parse(parts[2]);
        }

        public double DistanceTo(Point3D other)
        {
            long deltaX = other.X - X;
            long deltaY = other.Y - Y;
            long deltaZ = other.Z - Z;
            return Math.Sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);
        }

        public override string ToString()
        {
            return $"({X}, {Y}, {Z})";
        }
    }

    public static class Solve
    {
        public static long Part1(string pathToInput)
        {
            long result = 0;
            var inputRows = File.ReadAllLines(pathToInput).Select(x => new Point3D(x)).ToArray();
            var distances = new Dictionary<(Point3D, Point3D), double>();
            for (int row = 0; row < inputRows.Length; row++)
            {
                var currentLine = inputRows[row];
                for (int next = row+1; next<inputRows.Length; next++)
                {
                    var nextLine = inputRows[next];
                    var distance = currentLine.DistanceTo(nextLine);
                    distances.Add((currentLine, nextLine), distance);
                }
            }
            var usedPoints = new HashSet<HashSet<Point3D>>();
            for (int i = 0; i < 1000; i++)
            {
                var minDistance = distances.Values.Min();
                var minPair = distances.First(kvp => kvp.Value == minDistance).Key;
                Console.WriteLine($"Min pair: {minPair.Item1} <-> {minPair.Item2} = {minDistance}");
                // Check if neither points are used
                if (!usedPoints.Any(set => set.Contains(minPair.Item1) || set.Contains(minPair.Item2)))
                {
                    var newSet = new HashSet<Point3D> { minPair.Item1, minPair.Item2 };
                    usedPoints.Add(newSet);
                    Console.WriteLine($"New set with {minPair.Item1} and {minPair.Item2}");
                } 
                // both are in different sets, merge the sets
                else if (usedPoints.Any(set => set.Contains(minPair.Item1)) && usedPoints.Any(set => set.Contains(minPair.Item2)))
                {
                    var set1 = usedPoints.First(set => set.Contains(minPair.Item1));
                    var set2 = usedPoints.First(set => set.Contains(minPair.Item2));
                    if (set1 != set2)
                    {
                        Console.WriteLine($"Merging sets with {minPair.Item1} and {minPair.Item2}");
                        set1.UnionWith(set2);
                        usedPoints.Remove(set2);
                    }
                    else
                    {
                        Console.WriteLine($"Both points already in same set, skipping");
                    }
                }
                // check if Item1 is in a set, but not Item2. Add Item2 to that set
                else if (usedPoints.Any(set => set.Contains(minPair.Item1) && !set.Contains(minPair.Item2)))
                {
                    var existingSet = usedPoints.First(set => set.Contains(minPair.Item1));
                    existingSet.Add(minPair.Item2);
                    Console.WriteLine($"Added {minPair.Item2} to set with {minPair.Item1}");
                } 
                // check if Item2 is in a set, but not Item1. Add Item1 to that set
                else if (usedPoints.Any(set => set.Contains(minPair.Item2) && !set.Contains(minPair.Item1)))
                {
                    var existingSet = usedPoints.First(set => set.Contains(minPair.Item2));
                    existingSet.Add(minPair.Item1);
                    Console.WriteLine($"Added {minPair.Item1} to set with {minPair.Item2}");
                } 
                distances.Remove(minPair);
            }
            var topThreeSets = usedPoints.OrderByDescending(set => set.Count).ToList().Take(3).Select(x=>x.Count);
            Console.WriteLine($"Top three sets sizes: {string.Join(", ", topThreeSets)}");
            result = topThreeSets.Aggregate(1, (acc, val) => acc * val);
            return result;
        }

        public static long Part2(string pathToInput)
        {
            var inputRows = File.ReadAllLines(pathToInput).Select(x => new Point3D(x)).ToArray();
            var distances = new Dictionary<(Point3D, Point3D), double>();
            for (int row = 0; row < inputRows.Length; row++)
            {
                var currentLine = inputRows[row];
                for (int next = row+1; next<inputRows.Length; next++)
                {
                    var nextLine = inputRows[next];
                    var distance = currentLine.DistanceTo(nextLine);
                    distances.Add((currentLine, nextLine), distance);
                }
            }
            var usedPoints = new HashSet<HashSet<Point3D>>();
            bool mergedAll = false;
            while (!mergedAll && distances.Count > 0)
            {
                var minDistance = distances.Values.Min();
                var minPair = distances.First(kvp => kvp.Value == minDistance).Key;
                Console.WriteLine($"Min pair: {minPair.Item1} <-> {minPair.Item2} = {minDistance}");
                // Check if neither points are used
                if (!usedPoints.Any(set => set.Contains(minPair.Item1) || set.Contains(minPair.Item2)))
                {
                    var newSet = new HashSet<Point3D> { minPair.Item1, minPair.Item2 };
                    usedPoints.Add(newSet);
                    Console.WriteLine($"New set with {minPair.Item1} and {minPair.Item2}");
                } 
                // both are in different sets, merge the sets
                else if (usedPoints.Any(set => set.Contains(minPair.Item1)) && usedPoints.Any(set => set.Contains(minPair.Item2)))
                {
                    var set1 = usedPoints.First(set => set.Contains(minPair.Item1));
                    var set2 = usedPoints.First(set => set.Contains(minPair.Item2));
                    if (set1 != set2)
                    {
                        Console.WriteLine($"Merging sets with {minPair.Item1} and {minPair.Item2}");
                        set1.UnionWith(set2);
                        usedPoints.Remove(set2);
                    }
                    else
                    {
                        Console.WriteLine($"Both points already in same set, skipping");
                    }
                }
                // check if Item1 is in a set, but not Item2. Add Item2 to that set
                else if (usedPoints.Any(set => set.Contains(minPair.Item1) && !set.Contains(minPair.Item2)))
                {
                    var existingSet = usedPoints.First(set => set.Contains(minPair.Item1));
                    existingSet.Add(minPair.Item2);
                    Console.WriteLine($"Added {minPair.Item2} to set with {minPair.Item1}");
                } 
                // check if Item2 is in a set, but not Item1. Add Item1 to that set
                else if (usedPoints.Any(set => set.Contains(minPair.Item2) && !set.Contains(minPair.Item1)))
                {
                    var existingSet = usedPoints.First(set => set.Contains(minPair.Item2));
                    existingSet.Add(minPair.Item1);
                    Console.WriteLine($"Added {minPair.Item1} to set with {minPair.Item2}");
                } 
                distances.Remove(minPair);

                if (usedPoints.Count == 1 && usedPoints.First().Count == inputRows.Length)
                {
                    Console.WriteLine("All points merged into single set!");
                    mergedAll = true;
                    Console.WriteLine($"Final two points merged: {minPair.Item1} and {minPair.Item2}");
                    return minPair.Item1.X * minPair.Item2.X;
                }
            }
            return 0;
        }
    }
}