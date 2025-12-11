using System.Net;
using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day07
{
    public static class Solve
    {
        public static long Part1(string pathToInput)
        {
            var result = 0;
            var beamColumns = new List<int>();
            InputReader.ReadLines(pathToInput, (line) =>
            {
                if (line.Contains('S'))
                {
                    beamColumns.Add(line.IndexOf('S'));
                }
                else
                {
                    var newBeamCols = new List<int>(beamColumns);
                    foreach (var col in beamColumns)
                    {
                        if (line[col] == '^')
                        {
                            newBeamCols.Remove(col);
                            if (col > -1 && !newBeamCols.Contains(col-1))
                            {
                                newBeamCols.Add(col-1);
                            }
                            if (col < line.Length - 1 && !newBeamCols.Contains(col+1))
                            {
                                newBeamCols.Add(col+1);
                            }
                            result++;
                        }
                    }
                    beamColumns = newBeamCols;
                }
            });
            return result;
        }

        public static long Part2(string pathToInput)
        {
            Dictionary<int, long> currentPathCounts = new(); // col -> path count at current row
            
            InputReader.ReadLines(pathToInput, (line) =>
            {
                if (line.Contains('S'))
                {
                    currentPathCounts[line.IndexOf('S')] = 1;
                }
                else
                {
                    var nextPathCounts = new Dictionary<int, long>();
                    
                    foreach (var kvp in currentPathCounts)
                    {
                        var col = kvp.Key;
                        var paths = kvp.Value;
                        
                        if (line[col] == '^')
                        {
                            // Split: propagate path count to both children
                            if (col > 0)
                            {
                                nextPathCounts[col - 1] = nextPathCounts.GetValueOrDefault(col - 1, 0) + paths;
                            }
                            if (col < line.Length - 1)
                            {
                                nextPathCounts[col + 1] = nextPathCounts.GetValueOrDefault(col + 1, 0) + paths;
                            }
                        }
                        else
                        {
                            // Continue straight: propagate path count
                            nextPathCounts[col] = nextPathCounts.GetValueOrDefault(col, 0) + paths;
                        }
                    }
                    
                    currentPathCounts = nextPathCounts;
                }
            });

            // Sum all paths at the final row
            return currentPathCounts.Values.Sum();
        }
    }
}