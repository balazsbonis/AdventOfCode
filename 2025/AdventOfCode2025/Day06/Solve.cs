using System.Globalization;
using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day06
{
    public static class Solve
    {
        public static long Part1(string pathToInput)
        {
            return 0;
        }

        public static long Part2(string pathToInput)
        {
            var result = 0L;
            var lines = File.ReadAllLines(pathToInput).ToList();
            List<int> nums = new List<int>();
            char operand = ' ';
            for (int i = 0; i < lines[0].Length; i++)
            {
                Console.WriteLine($"Processing column {lines[0][i].ToString() + lines[1][i] + lines[2][i] + lines[3][i] + lines[4][i]}");
                if (lines[4][i] != ' ')
                {
                    operand = lines[4][i];
                }
                // check if all characters in the same pos are empty
                if (lines.All(line => line[i] == ' '))
                {
                    // do the calc
                    if (operand == '+')
                    {
                        Console.WriteLine($"Adding {string.Join(", ", nums)}");
                        result += nums.Sum();
                    }
                    else if (operand == '*')
                    {
                        Console.WriteLine($"Multiplying {string.Join(", ", nums)}");
                        result += nums.Aggregate(1, (acc, val) => acc * val);
                    }

                    // reset numbers
                    nums.Clear();
                }
                else
                {
                    string num = lines[0][i].ToString() + lines[1][i] + lines[2][i] + lines[3][i];
                    nums.Add(int.Parse(num.Trim()));
                }
            }
            return result;
        }
    }
}

//8635691976 too low!