using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day04
{
    public class MapOfPress
    {
        public char[,] Dots {get;set;}
        public int Width {get;set;}
        public int Height {get;set;}
        public MapOfPress(int width, int height)
        {
            Width = width;
            Height = height;
            Dots = new char[width+2, height+2];
            for (int x = 0; x < width + 2; x++)
            {
                for (int y = 0; y < height + 2; y++)
                {
                    Dots[x, y] = '.';
                }
            }
        }

        public override string ToString()
        {
            var result = "";
            for (int y = 0; y < Height + 2; y++)
            {
                for (int x = 0; x < Width + 2; x++)
                {
                    result += Dots[x, y];
                }
                result += "\n";
            }
            return result;
        }

        public int NumberOfAdjacent(int x, int y)
        {
            int result = 0;
            for (int dx = -1; dx <= 1; dx++)
            {
                for (int dy = -1; dy <= 1; dy++)
                {
                    if (dx == 0 && dy == 0)
                    {
                        continue;
                    }
                    if (Dots[x + dx, y + dy] == '@')
                    {
                        result++;
                    }
                }
            }
            return result;
        }
    }
    public static class Solve
    {
        public static long Part1(string pathToInput)
        {
            var lines = new List<string>();
            InputReader.ReadLines(pathToInput, lines.Add);
            var map = new MapOfPress(lines[0].Length, lines.Count);
            foreach (var v in lines)
            {
                for (int x = 0; x < v.Length; x++)
                {
                    if (v[x] == '@')
                    {
                        map.Dots[x + 1, lines.IndexOf(v) + 1] = '@';
                    }
                }
            }

            //Console.WriteLine(map.ToString());  
            var (mapAfter, newResult) = RemovePaperRolls(lines, map);
            Console.WriteLine(mapAfter.ToString());
            return newResult;
        }

        private static (MapOfPress mapAfter, int result) RemovePaperRolls(List<string> lines, MapOfPress map)
        {
            var mapAfter = new MapOfPress(lines[0].Length, lines.Count);
            Array.Copy(map.Dots, mapAfter.Dots, map.Dots.Length);
            int result = 0;
            for (int i = 0; i < lines[0].Length; i++)
            {
                for (int j = 0; j < lines.Count; j++)
                {
                    if (map.Dots[i + 1, j + 1] == '@')
                    {
                        var numAdj = map.NumberOfAdjacent(i + 1, j + 1);
                        if (numAdj < 4)
                        {
                            mapAfter.Dots[i + 1, j + 1] = '.';
                            result++;
                        }
                    }
                }
            }
            return (mapAfter, result);
        }

        public static long Part2(string pathToInput)
        {
            var lines = new List<string>();
            InputReader.ReadLines(pathToInput, lines.Add);
            var map = new MapOfPress(lines[0].Length, lines.Count);
            foreach (var v in lines)
            {
                for (int x = 0; x < v.Length; x++)
                {
                    if (v[x] == '@')
                    {
                        map.Dots[x + 1, lines.IndexOf(v) + 1] = '@';
                    }
                }
            }
        
            int result = 0;
            var (mapAfter, currResult) = RemovePaperRolls(lines, map);
            while (currResult > 0)
            {
                Console.WriteLine(mapAfter.ToString());
                result += currResult;
                (mapAfter, currResult) = RemovePaperRolls(lines, mapAfter);
            }

            Console.WriteLine(mapAfter.ToString());
            return result;
        }
    }
}