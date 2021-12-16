using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;

namespace _15
{
    record Tile
    {
        public Point Coords { get; set; }
        public int Distance { get; set; } = int.MaxValue;
        public int Weight { get; set; }
        public bool Visited { get; set; } = false;
        public Tile(int x, int y, int weight)
        {
            Coords = new Point(x, y);
            Weight = weight;
        }
    }

    class Program
    {
        public static Dictionary<Point, Tile> map { get; set; }

        public static List<Tile> Neighbours(Tile current)
        {
            var adjacent = new[] { (-1, 0), (1, 0), (0, -1), (0, 1) };
            var result = new List<Tile>();
            foreach ((int i, int j) in adjacent)
            {
                var key = new Point(current.Coords.X + i, current.Coords.Y + j);
                if (map.ContainsKey(key) && !map[key].Visited)
                {
                    result.Add(map[key]);
                }
            }
            return result;
        }


        public static int Part01()
        {
            map = File.ReadAllLines(Path.Combine(Path.GetDirectoryName(
                Assembly.GetExecutingAssembly().Location), @"input.txt"))
                    .SelectMany((line, y) => line.Select((c, x) => (new Point(x, y), new Tile(x, y, c - 48))))
                    .ToDictionary(t => t.Item1, t => t.Item2);

            var priorityQueue = new PriorityQueue<Tile, int>();
            map[new Point(0, 0)].Distance = 0;
            priorityQueue.Enqueue(map[new Point(0, 0)], 0);
            while (priorityQueue.Count > 0)
            {
                var current = priorityQueue.Dequeue();
                if (current.Visited) continue;
                current.Visited = true;
                if (current == map[new Point(99,99)]) // 100 * 100
                {
                    // found it
                    return current.Distance;
                }
                foreach (var n in Neighbours(current))
                {
                    var dist = current.Distance + n.Weight;
                    if (dist < n.Distance) n.Distance = dist;
                    if (n.Distance != int.MaxValue) priorityQueue.Enqueue(n, n.Distance);
                }
            }

            return 0;
        }

        static void Main(string[] args)
        {
            Console.WriteLine(Part01());
        }
    }
}
