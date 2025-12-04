using System;
using System.IO;

namespace AdventOfCode2025.Common
{
    public static class InputReader
    {
        public static void ReadLines(string filePath, Action<string> processLine)
        {
            using var reader = new StreamReader(filePath);
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                processLine(line);
            }
        }
    }
}