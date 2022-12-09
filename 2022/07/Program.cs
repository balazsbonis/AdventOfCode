namespace AoC202207
{
    class TreeNode
    {
        public List<TreeNode> Children {get;set;}
        public string Name {get;set;}
        public int Size {get;set;}
        public TreeNode Parent {get;set;}
        public bool IsFile => Size > 0;
        public TreeNode() => Children = new List<TreeNode>();
        
        public override string ToString()
        {
            if (this.Size != 0) // file
            {
                return $"File: {Name} - {Size}";
            }
            else
            {
                return $"Dir: {Name}";
            }
        }

        public int TotalSize()
        {
            if (IsFile) return Size;
            var size = 0;
            foreach (var c in Children)
            {
                size += c.TotalSize();
            }
            return size;
        }
    }

    class Program
    {
        public static int Part01(TreeNode tree, int result = 0)
        {
            foreach (var c in tree.Children.Where(x => !x.IsFile))
            {
                result += Part01(c);
            }
            var size = tree.TotalSize();
            if (size <= 100000) return result + size;
            return result;
        }

        public static int Part02(TreeNode root, int needed, int current = int.MaxValue)
        {
            foreach (var c in root.Children.Where(x => !x.IsFile))
            {
                current = Part02(c, needed, current);
            }
            var size = root.TotalSize();
            if (size < current && size > needed) return size;
            return current;
        }

        public static void Main()
        {
            var root = new TreeNode();
            var pointer = root;
            using (var str = File.OpenText("input.txt"))
            {
                while(!str.EndOfStream)
                {
                    var l = str.ReadLine();
                    var parts = l.Split(' ');
                    if (parts[0] == "$"){
                        if (parts[1] == "cd")
                        {
                            if (parts[2] == ".."){
                                pointer = pointer.Parent;
                            }
                            else {
                                pointer = pointer.Children.FirstOrDefault(x=>x.Name == parts[2]);
                            }
                        }
                    }
                    else 
                    {
                        if (parts[0] == "dir")
                        {
                            pointer.Children.Add(new TreeNode() { Name = parts[1], Parent = pointer });
                        }
                        else
                        {
                            pointer.Children.Add(new TreeNode() { Size = int.Parse(parts[0]), Name = parts[1], Parent = pointer});
                        }
                    }
                }
            }
            //Console.WriteLine(root.TotalSize());

            // part01 
            var part01 = Part01(root);
            Console.WriteLine(part01);

            // part02
            var totalDiskSize = 70000000;
            var totalUsedSpace = root.TotalSize();
            var totalUnusedSpace = totalDiskSize - totalUsedSpace;
            var needed = 30000000 - totalUnusedSpace;
            var part02 = Part02(root, needed);
            Console.WriteLine(part02);
        }

    }
}