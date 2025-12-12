using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day11
{

    public static class Solve
    {
        static List<List<string>> part2Paths = new();
        static Dictionary<string, long> memo = new();

        public static long Part1(string pathToInput)
        {
            memo.Clear();
            var lines = File.ReadAllLines(pathToInput);
            var graph = new Dictionary<string, string[]>
            {
                { "out", Array.Empty<string>() }
            };
            foreach (var line in lines)
            {
                var parts = line.Split(':');
                var neighbors = parts[1].Split(' ').Where(x=>!string.IsNullOrWhiteSpace(x)).ToArray();
                graph.Add(parts[0], neighbors);
            }

            // Implement DFS to find the number of all possible paths from you to out
            var root = graph.Keys.First(k => k.StartsWith("you"));
            HashSet<string> visited = new HashSet<string>();
            return DFSWithMemo("out",graph, root, visited);
        }
        
        public static long DFSWithMemo(string goal, Dictionary<string, string[]> graph, string node, HashSet<string> visited)
        {
            if (node.StartsWith(goal))
            {
                return 1;
            }
            
            // Can't memoize when visited set matters, but can optimize with early returns
            visited.Add(node);
            
            long pathCount = 0;
            foreach (var neighbor in graph[node])
            {
                if (!visited.Contains(neighbor))
                {
                    pathCount += DFSWithMemo(goal, graph, neighbor, visited);
                }
            }
            
            visited.Remove(node);
            return pathCount;
        }
        
        public static long Part2(string pathToInput)
        {
            part2Paths.Clear();
            memo.Clear();
            
            var lines = File.ReadAllLines(pathToInput);
            var graph = new Dictionary<string, string[]>
            {
                { "out", Array.Empty<string>() }
            };
            foreach (var line in lines)
            {
                var parts = line.Split(':');
                var neighbors = parts[1].Split(' ').Where(x=>!string.IsNullOrWhiteSpace(x)).ToArray();
                graph.Add(parts[0], neighbors);
            }

            var svrToFft = DFSWithMemoization("svr", "fft", graph);
            var svrToDac = DFSWithMemoization("svr", "dac", graph);
            var dacToFft = DFSWithMemoization("dac", "fft", graph);
            var dacToOut = DFSWithMemoization("dac", "out", graph);
            var fftToDac = DFSWithMemoization("fft", "dac", graph);
            var fftToOut = DFSWithMemoization("fft", "out", graph);
            return svrToDac * dacToFft * fftToOut + svrToFft * fftToDac * dacToOut;
        }

        private static long DFSWithMemoization(string from, string to, Dictionary<string, string[]> graph)
        {
            var memo = new Dictionary<string, long>();
            var stack = new Stack<string>();
            stack.Push(from);

            while (stack.Count > 0)
            {
                var node = stack.Peek();
                var checks = false;
                
                if (node == to)
                {
                    memo[node] = 1;
                    checks = true;
                }

                if (!graph.ContainsKey(node))
                {
                    memo[node] = 0;
                    checks = true;
                }
                if (checks || memo.ContainsKey(node))
                {
                    stack.Pop();
                    continue;
                }

                var allNeighborsMemoized = true;
                foreach (var neighbor in graph[node])
                {
                    if (!memo.ContainsKey(neighbor))
                    {
                        stack.Push(neighbor);
                        allNeighborsMemoized = false;
                    }
                }

                if (!allNeighborsMemoized)
                {
                    continue;
                }
                long pathCount = 0;
                foreach (var neighbor in graph[node])
                {
                    pathCount += memo[neighbor];
                }
                memo[node] = pathCount;
                stack.Pop();
            }

            return memo[from];
        }

        // private static long RecursiveSumDacFft(string key, Dictionary<string, string[]> paths, bool passedDac, bool passedFft, Dictionary<(string, bool, bool), long> sumPerKey)
        // {
        //     if (sumPerKey.ContainsKey((key, passedDac, passedFft))) return sumPerKey[(key, passedDac, passedFft)];
        //     if (paths[key][0] == "out")
        //     {
        //         sumPerKey[(key, passedDac, passedFft)] = passedDac && passedFft ? 1 : 0;
        //         return sumPerKey[(key, passedDac, passedFft)];
        //     }
        //     long sum = 0;
        //     foreach (string path in paths[key])
        //     {
        //         if (path == "dac") sum += RecursiveSumDacFft(path, paths, true, passedFft, sumPerKey);
        //         else if (path == "fft") sum += RecursiveSumDacFft(path, paths, passedDac, true, sumPerKey);
        //         else sum += RecursiveSumDacFft(path, paths, passedDac, passedFft, sumPerKey);
        //     }
        //     sumPerKey[(key, passedDac, passedFft)] = sum;
        //     return sum;
        // }
    }
}