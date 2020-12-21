input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\19\\input.txt",
       character(),
       sep = "\n")

rules <- c()
messages <- c()
for (line in input) {
  if (length(grep(":", line)) > 0) {
    rules <- append(rules, line)
  }
  else{
    messages <- append(messages, line)
  }
}

target <- ""
pp <- rep("", length(rules))
for (p in strsplit(rules, ": ")) {
  index <- strtoi(p[1])
  if (index == 0)
    target <- p[2]
  pp[strtoi(p[1])] <- gsub("\"", "", p[2])
}

replace_rules <- function(parts) {
  if (parts == "a" || parts == "b")
    return(parts)
  tokens <- unlist(strsplit(parts, " "))
  result <- ""
  add_parenthesis <- FALSE
  for (t in tokens) {
    if (t != "|") {
      result <- paste(result, replace_rules(pp[strtoi(t)]), sep = "")
    } else {
      add_parenthesis <- TRUE
      result <- paste("(", result, "|", sep = "")
    }
  }
  if (add_parenthesis) {
    result <- paste(result, ")", sep = "")
  }
  return(result)
}

r <- paste("^", replace_rules(target), "$", sep = "")

part1 <- 0
for (m in messages) {
  if (regexpr(r, m) == 1) {
    part1 <- part1 + 1
  }
}

part2 <- 0
r2_42 <- replace_rules(pp[42])
r2_31 <- replace_rules(pp[31])
r2 <-
  paste("^(", r2_42, "+)((?P<mennyiiiii>", r2_42, "(?&mennyiiiii)?", r2_31, "))$", sep = "")
for (m in messages) {
  if (regexpr(r2, m, perl= TRUE) == 1) {
    part2 <- part2 + 1
  }
}
