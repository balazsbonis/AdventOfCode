using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day05
{
    public class Bounds
    {
        public long Lower {get;set;}
        public long Upper {get;set;}
        public Bounds(long lower, long upper)
        {
            Lower = lower;
            Upper = upper;
        }

        public bool Contains(long number)
        {
            return number >= Lower && number <= Upper;
        }

        public long Size()
        {
            return Upper - Lower + 1;
        }
    }

    public static class Solve
    {
        public static long Part1(string pathToInput)
        {
            var result = 0;
            var freshSet = new List<Bounds>();
            InputReader.ReadLines(pathToInput, (line) =>
            {
                // parse rules
                if (line.Contains('-'))
                {
                    var bounds = line.Split('-');
                    var lower = long.Parse(bounds[0]);
                    var upper = long.Parse(bounds[1]);
                    freshSet.Add(new Bounds(lower, upper));
                }

                // process numbers
                else if (long.TryParse(line, out var number))
                {
                    if (freshSet.Any(bounds => bounds.Contains(number)))
                    {
                        result++;
                    }
                }
            });

            return result;
        }

        public static long Part2(string pathToInput)
        {
            var freshSet = new List<Bounds>();
            InputReader.ReadLines(pathToInput, (line) =>
            {
                // parse rules
                if (line.Contains('-'))
                {
                    var bounds = line.Split('-');
                    var lower = long.Parse(bounds[0]);
                    var upper = long.Parse(bounds[1]);

                    foreach (var existing in freshSet.ToList())
                    {
                        // Check for overlap and merge
                        if (!(upper < existing.Lower || lower > existing.Upper))
                        {
                            lower = Math.Min(lower, existing.Lower);
                            upper = Math.Max(upper, existing.Upper);
                            freshSet.Remove(existing);
                        }
                    }

                    freshSet.Add(new Bounds(lower, upper));
                }
            });
            
            return freshSet.Sum(b => b.Size());
        }
    }
}