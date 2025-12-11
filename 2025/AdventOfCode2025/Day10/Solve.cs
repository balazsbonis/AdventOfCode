using AdventOfCode2025.Common;
using Microsoft.Z3;

namespace AdventOfCode2025.Day10
{
    // TOO SLOW
    public class JoltageNode
    {
        public short[] StateOfJoltages {get;set;}
        public short[] Instructions {get;set;} = [];
        public int Depth {get;set;}
        public List<JoltageNode> Children {get;set;} = new();

        public JoltageNode(short[] initialState, string instructions, int Depth)
        {
            StateOfJoltages = [..initialState];
            this.Depth = Depth;
            if (!string.IsNullOrEmpty(instructions))
            {
                instructions = instructions.Trim('(', ')');
                Instructions = [.. instructions.Split(',').Select(short.Parse)];
                for (int i = 0; i < Instructions.Length; i++)
                {
                    StateOfJoltages[Instructions[i]] = (short)(StateOfJoltages[Instructions[i]] + 1);
                }
            }
        }

        public string GetStateString()
        {
            return string.Join(",", StateOfJoltages);
        }

        public bool IsValidNode(string goalState)
        {
            var goalJoltages = goalState.Split(',').Select(short.Parse).ToArray();
            for (int i = 0; i < goalJoltages.Length; i++)
            {
                if (StateOfJoltages[i] > goalJoltages[i])
                {
                    return false;
                }
            }
            return true;
        }
    }

    public class MachineNode
    {
        public char[] StateOfLights {get;set;}
        public int[] Instructions {get;set;} = [];
        public int Depth {get;set;}
        public List<MachineNode> Children {get;set;} = new();

        public MachineNode(string initialState, string instructions, int Depth)
        {
            StateOfLights = initialState.ToCharArray();
            this.Depth = Depth;
            if (!string.IsNullOrEmpty(instructions))
            {
                instructions = instructions.Trim('(', ')');
                Instructions = [.. instructions.Split(',').Select(int.Parse)];
                for (int i = 0; i < Instructions.Length; i++)
                {
                    StateOfLights[Instructions[i]] = StateOfLights[Instructions[i]] == '.' ? '#' : '.';
                }
            }
        }

        public string GetStateString()
        {
            return new string(StateOfLights);
        }
    }

    public static class Solve
    {
        public static long Part1(string pathToInput)
        {
            long result = 0L;
            InputReader.ReadLines(pathToInput, (line) =>
            {
                // Process each line of input here
                var goalState = line[1..line.IndexOf(']')];
                var rootNode = new MachineNode(new string('.', goalState.Length), "", 0);
                var instructions = line[line.IndexOf('(')..(line.IndexOf('{') - 1)].Split(' ');

                // Implement breadth-first search
                Queue<MachineNode> nodesToExplore = new();
                nodesToExplore.Enqueue(rootNode);
                while (nodesToExplore.Count > 0)
                {
                    var currentNode = nodesToExplore.Dequeue();
                    if (currentNode.GetStateString() == goalState)
                    {
                        result += currentNode.Depth;
                        break; // Found a valid configuration
                    }

                    foreach (var instruction in instructions)
                    {
                        var childNode = new MachineNode(currentNode.GetStateString(), instruction, currentNode.Depth + 1);
                        currentNode.Children.Add(childNode);
                        nodesToExplore.Enqueue(childNode);
                    }
                }
            });
            return result;
        }

        public static long Part2(string pathToInput)
        {
            long result = 0L;
            InputReader.ReadLines(pathToInput, (line) =>
            {
                // Process each line of input here
                var goalState = line[(line.IndexOf('{')+1)..line.IndexOf('}')].Split(',');
                var instructions = line[line.IndexOf('(')..(line.IndexOf('{') - 1)].Split(' ')
                    .Select(instr => instr.Trim('(', ')').Split(',').Select(short.Parse).ToArray()).ToArray();
                using (var context = new Context())
                {
                    var opt = context.MkOptimize();
                    var intExprs = new List<IntExpr>(instructions.Length);

                    // Create integer variables for each instruction
                    for (int i = 0; i < instructions.Length; i++)
                    {
                        intExprs.Add((IntExpr)context.MkIntConst($"x{i}"));
                        opt.Add(context.MkGe(intExprs[i], context.MkInt(0)));
                    }

                    // Add constraints based on goal state
                    for (int j = 0; j < goalState.Length; j++)
                    {
                        var goalValue = short.Parse(goalState[j]);
                        var instructionsWithJ = instructions
                            .Select((instr, idx) => (instr, idx))
                            .Where(t => t.instr.Contains((short)j))
                            .Select(t => intExprs[t.idx])
                            .ToArray();
                        opt.Add(context.MkEq(
                            context.MkAdd(instructionsWithJ),
                            context.MkInt(goalValue)
                        ));
                    }

                    // Minimize the total
                    var total = context.MkAdd(intExprs.ToArray());
                    opt.MkMinimize(total);
                    if (opt.Check() == Status.SATISFIABLE)
                    {
                        var model = opt.Model;
                        var minimalTotal = model.Evaluate(total);
                        Console.WriteLine($"Minimal total for line: {minimalTotal}");
                        result += ((IntNum)minimalTotal).Int;
                    }
                }
            });
            return result;

        }
    }
}