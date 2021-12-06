using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;

namespace _04
{
    public class Program
    {
        static void Main(string[] args)
        {
            ReadInput(out List<int> drawNumbers, out List<int[,]> boards);
            Part1(drawNumbers, boards);
            ReadInput(out drawNumbers, out boards);
            Part2(drawNumbers, boards);
        }

        private static void Part2(List<int> drawNumbers, List<int[,]> boards)
        {
            bool end = false;
            var result = 0;
            List<int> boardsWon = new();

            foreach (var draw in drawNumbers)
            {
                for (int k = 0; k < boards.Count; k++)
                {
                    if (boardsWon.Contains(k)) continue;
                    var b = boards[k];
                    for (int i = 0; i < 5; i++)
                    {
                        for (int j = 0; j < 5; j++)
                        {
                            if (b[i, j] == draw)
                            {
                                b[i, j] = -1;
                                var rowTotal = Enumerable.Range(0, 5).Select(x => b[i, x]).Sum();
                                var colTotal = Enumerable.Range(0, 5).Select(x => b[x, j]).Sum();
                                if (rowTotal == -5 || colTotal == -5)
                                {
                                    boardsWon.Add(k);
                                    if (boardsWon.Count == boards.Count)
                                    {
                                        result = CalculateTotalLeftInBoard(b);
                                        result *= draw;
                                        Console.WriteLine($"Part 2 is {result}");
                                    }
                                    end = true;
                                    break;
                                }
                            }
                        }
                        if (end) break;
                    }
                    end = false;
                }
            }
        }

        private static void Part1(List<int> drawNumbers, List<int[,]> boards)
        {
            bool end = false;
            var result = 0;

            foreach (var draw in drawNumbers)
            {
                foreach (var b in boards)
                {
                    for (int i = 0; i < 5; i++)
                    {
                        for (int j = 0; j < 5; j++)
                        {
                            if (b[i, j] == draw)
                            {
                                b[i, j] = -1;
                                var rowTotal = Enumerable.Range(0, 5).Select(x => b[i, x]).Sum();
                                var colTotal = Enumerable.Range(0, 5).Select(x => b[x, j]).Sum();
                                if (rowTotal == -5 || colTotal == -5)
                                {
                                    result = CalculateTotalLeftInBoard(b);
                                    result *= draw;
                                    Console.WriteLine($"Part 1 is {result}");
                                    end = true;
                                    break;
                                }
                            }
                        }
                        if (end) break;
                    }
                    if (end) break;
                }
                if (end) break;
            }
        }

        private static void ReadInput(out List<int> drawNumbers, out List<int[,]> boards)
        {
            var path = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), @"input.txt");
            var files = File.ReadAllLines(path);

            drawNumbers = new();
            boards = new();
            int index = 0;
            int[,] board = new int[5, 5];
            foreach (var line in files)
            {
                if (line.Contains(',')) drawNumbers = files[0].Split(',').Select(x => int.Parse(x)).ToList();
                else if (!string.IsNullOrEmpty(line))
                {
                    var numbers = line.Split(' ').Where(x => x.Trim() != "").Select(x => int.Parse(x)).ToArray();
                    for (int j = 0; j < 5; j++) board[index, j] = numbers[j];
                    index++;
                }
                else if (index > 0)
                {
                    boards.Add(board);
                    board = new int[5, 5];
                    index = 0;
                }
            }
            boards.Add(board);
        }

        private static int CalculateTotalLeftInBoard(int[,] b)
        {
            int result = 0;
            for (int i = 0; i < 5; i++)
            {
                result += Enumerable.Range(0, 5).Select(x => b[i, x]).Where(x => x > 0).Sum();
            }
            return result;
        }
    }
}
