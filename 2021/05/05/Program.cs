using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;

namespace _05
{
    public record Vent(int fromX, int fromY, int toX, int toY);

    class Program
    {
        private const int floorSize = 1000;

        static void Main(string[] args)
        {
            bool part2 = true;
            var path = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), @"input.txt");
            var vents = new List<Vent>();
            foreach (var f in File.ReadAllLines(path))
            {
                var line = f.Split(" -> ").Select(x => x.Split(",").Select(y => int.Parse(y)).ToArray())
                    .ToArray();
                vents.Add(new Vent(line[0][0], line[0][1], line[1][0], line[1][1]));
            }

            int[,] floor = new int[floorSize, floorSize];
            foreach (var vent in vents)
            {
                if (vent.fromX == vent.toX)
                {
                    int minY = vent.fromY > vent.toY ? vent.toY : vent.fromY;
                    int maxY = vent.fromY > vent.toY ? vent.fromY : vent.toY;
                    for (int i = minY; i <= maxY; i++) floor[i, vent.fromX]++;
                }
                if (vent.fromY == vent.toY)
                {
                    int minX = vent.fromX > vent.toX ? vent.toX : vent.fromX;
                    int maxX = vent.fromX > vent.toX ? vent.fromX : vent.toX;
                    for (int i = minX; i <= maxX; i++) floor[vent.fromY, i]++;
                }
                if (part2)
                {
                    // diagonals
                    if (Math.Abs(vent.fromX - vent.toX) == Math.Abs(vent.fromY - vent.toY))
                    {
                        var dirX = Math.Sign(vent.toX - vent.fromX);
                        var dirY = Math.Sign(vent.toY - vent.fromY);
                        for (int i = vent.fromX, j = vent.fromY; i != vent.toX + dirX || j != vent.toY + dirY; i+=dirX, j += dirY)
                        {
                            floor[j, i]++;
                        }
                    }
                }
            }

            var count = 0;
            for (int i = 0; i < floorSize; i++)
            {
                for (int j = 0; j < floorSize; j++)
                {
                    //Console.Write(floor[i, j]);
                    if (floor[i, j] > 1) count++;
                }
                //Console.WriteLine();
            }
            Console.WriteLine($"Result is {count}");
        }
    }
}
