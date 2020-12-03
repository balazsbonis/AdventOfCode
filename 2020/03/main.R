i <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\03\\input.txt",
       character())
input <- strsplit(strrep(i, 100), "")
cnt <- 1
trees <- c(0, 0, 0, 0, 0)
while (cnt <= length(input)) {
  # 1-1
  if (unlist(input[cnt])[cnt] == "#") {
    trees[1] <- trees[1] + 1
  }
  # 3-1
  if (unlist(input[cnt])[(cnt - 1) * 3 + 1] == "#") {
    trees[2] <- trees[2] + 1
  }
  # 5-1
  if (unlist(input[cnt])[(cnt - 1) * 5 + 1] == "#") {
    trees[3] <- trees[3] + 1
  }
  # 7-1
  if (unlist(input[cnt])[(cnt - 1) * 7 + 1] == "#") {
    trees[4] <- trees[4] + 1
  }
  # 1-2
  if (cnt %% 2 == 1) {
    if (unlist(input[cnt])[(cnt / 2) + 1] == "#") {
      trees[5] <- trees[5] + 1
    }
  }
  cnt <- cnt + 1
}

print(trees)
print(prod(trees))
