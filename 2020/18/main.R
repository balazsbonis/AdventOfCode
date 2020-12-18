input <-
  gsub(
    " ",
    "",
    scan(
      "c:\\Work\\Code\\AdventOfCode\\2020\\18\\test.txt",
      character(),
      sep = "\n"
    )
  )

calculate_left_to_right <- function (expr) {
  operation <- "+"
  value <- 0
  for (operand in expr) {
    if (operand == "*" || operand == "+")
      operation <- operand
    else if (operation == "+") {
      value <- value + strtoi(operand)
    } else {
      value <- value * strtoi(operand)
    }
  }
  return(value)
}

evaluate_expression <- function(tokens, start, finish) {
  expr <-
    tokens[(start + 1):(finish - 1)]
  calculate_left_to_right(expr)
  # avoid NAs when the first or last character is ( or )
  if (parenthesis_end == length(tokens)) {
    return(c(tokens[1:(start - 1)], value))
  } else if (parenthesis_start == 1) {
    return(c(value, tokens[(finish + 1):length(tokens)]))
  }
  else {
    return(c(tokens[1:(start - 1)], value, tokens[(finish + 1):length(tokens)]))
  }
}


for (line in input) {
  # check if there are parentheses
  tokens <- strsplit(line, "")[[1]]
  while (any(tokens == "(")) {
    # break them up, find the deepest nested expression
    parenthesis_start <- 0
    parenthesis_end <- 0
    for (i in 1:length(tokens)) {
      if (tokens[i] == "(") {
        parenthesis_start <- i
      }
      if (tokens[i] == ")") {
        parenthesis_end <- i
      }
      if (parenthesis_end > 0) {
        # evaluate
        tokens <-
          evaluate_expression(tokens, parenthesis_start, parenthesis_end)
        break
      }
    }
  }
  result <- calculate_left_to_right(tokens)
}