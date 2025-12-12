using System.Drawing;
using AdventOfCode2025.Common;

namespace AdventOfCode2025.Day09
{
    public static class Solve
    {
        public static long CalculateRectangleArea(Point a, Point b)
        {
            long width = Math.Abs(a.X - b.X) + 1;
            long height = Math.Abs(a.Y - b.Y) + 1;
            return width * height;
        }

        public static long Part1(string pathToInput)
        {
            var points = new List<Point>();
            var lines = File.ReadAllLines(pathToInput).Select(x=>x.Split(','))
                .Select(parts => new Point(int.Parse(parts[0]), int.Parse(parts[1]))).ToArray();
            var areas = new Dictionary<(Point, Point), double>();
            for (int row = 0; row < lines.Length; row++)
            {
                var currentLine = lines[row];
                for (int next = row+1; next<lines.Length; next++)
                {
                    var nextLine = lines[next];
                    areas.Add((currentLine, nextLine), CalculateRectangleArea(currentLine, nextLine));
                }
            }
            Console.WriteLine($"Part 1 solution: {(long)areas.Values.Max()}");

            var maxInside = 0d;
            foreach (var kvp in areas.OrderByDescending(x => x.Value))
            {
                var a = kvp.Key.Item1;
                var b = kvp.Key.Item2;
                var area = kvp.Value;
                
                // Get all four corners of the rectangle
                var minX = Math.Min(a.X, b.X);
                var maxX = Math.Max(a.X, b.X);
                var minY = Math.Min(a.Y, b.Y);
                var maxY = Math.Max(a.Y, b.Y);
                
                var corners = new[]
                {
                    new Point(minX, minY),
                    new Point(minX, maxY),
                    new Point(maxX, minY),
                    new Point(maxX, maxY)
                };
                
                // Check if all corners are inside the polygon
                bool allCornersInside = corners.All(corner => IsPointInPolygon(corner, lines));
                
                if (!allCornersInside)
                    continue;
                
                // Check if any polygon edge intersects any rectangle edge
                bool hasIntersection = false;
                
                // Define the 4 edges of the rectangle
                var rectEdges = new[]
                {
                    (new Point(minX, minY), new Point(maxX, minY)), // bottom
                    (new Point(maxX, minY), new Point(maxX, maxY)), // right
                    (new Point(maxX, maxY), new Point(minX, maxY)), // top
                    (new Point(minX, maxY), new Point(minX, minY))  // left
                };
                
                // Check each polygon edge against each rectangle edge
                for (int i = 0; i < lines.Length && !hasIntersection; i++)
                {
                    int j = (i + 1) % lines.Length;
                    var polyEdge = (lines[i], lines[j]);
                    
                    foreach (var rectEdge in rectEdges)
                    {
                        if (LineSegmentsIntersect(polyEdge.Item1, polyEdge.Item2, rectEdge.Item1, rectEdge.Item2))
                        {
                            hasIntersection = true;
                            break;
                        }
                    }
                }
                
                if (!hasIntersection)
                {
                    maxInside = area;
                    Console.WriteLine($"Found valid rectangle: ({minX},{minY}) to ({maxX},{maxY}), area: {area}");
                    break;
                }
            }

            return (long)maxInside;
        }
        
        // Check if two line segments intersect (excluding endpoints touching)
        public static bool LineSegmentsIntersect(Point p1, Point p2, Point p3, Point p4)
        {
            // Calculate direction vectors
            long d1x = p2.X - p1.X;
            long d1y = p2.Y - p1.Y;
            long d2x = p4.X - p3.X;
            long d2y = p4.Y - p3.Y;
            
            // Calculate cross product
            long cross = d1x * d2y - d1y * d2x;
            
            if (cross == 0) return false; // Parallel or collinear
            
            // Calculate parameters
            long dx = p3.X - p1.X;
            long dy = p3.Y - p1.Y;
            
            double t = (double)(dx * d2y - dy * d2x) / cross;
            double u = (double)(dx * d1y - dy * d1x) / cross;
            
            // Check if intersection is strictly within both segments (not at endpoints)
            return t > 0 && t < 1 && u > 0 && u < 1;
        }
        
        // Point-in-polygon test using ray casting algorithm
        public static bool IsPointInPolygon(Point point, Point[] polygon)
        {
            bool inside = false;
            int j = polygon.Length - 1;
            
            for (int i = 0; i < polygon.Length; i++)
            {
                if ((polygon[i].Y > point.Y) != (polygon[j].Y > point.Y) &&
                    point.X < (polygon[j].X - polygon[i].X) * (point.Y - polygon[i].Y) / (polygon[j].Y - polygon[i].Y) + polygon[i].X)
                {
                    inside = !inside;
                }
                j = i;
            }
            
            return inside;
        }

        public static long Part2(string pathToInput)
        {
            // 4534328125 too high
            return 0;
        }
    }
}