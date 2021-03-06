input <-
  gsub(
    " ",
    "",
    scan(
      "c:\\Work\\Code\\AdventOfCode\\2020\\18\\input.txt",
      character(),
      sep = "\n"
    )
  )

# part 1
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

# part 2
calculate_stupid_order <- function (expr) {
  additions <- which(expr == "+")
  while (length(additions) > 0) {
    op1 <- strtoi(expr[additions[1] - 1])
    op2 <- strtoi(expr[additions[1] + 1])
    if (additions[1] == 2 && length(expr) == 3) {
      expr <- c(op1 + op2)
    } else if (additions[1] == 2) {
      expr <- c(op1 + op2, expr[(additions[1] + 2):length(expr)])
    } else if (additions[1] == length(expr) - 1) {
      expr <-
        c(expr[1:(additions[1] - 2)], op1 + op2)
    } else {
      expr <-
        c(expr[1:(additions[1] - 2)], op1 + op2, expr[(additions[1] +
                                                               2):length(expr)])
    }
    additions <- which(expr == "+")
  }
  return (prod(strtoi(expr[expr != "*"])))
}

evaluate_expression <- function(tokens, start, finish) {
  expr <-
    tokens[(start + 1):(finish - 1)]
  value <- calculate_stupid_order(expr)
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

res <- 0
for (line in input) {
  # check if there are parentheses
  tokens <- strsplit(line, "")[[1]]
  while (any(tokens == "(")) {
    # break them up, find the deepest nested expression
    parenthesis_start <- 1
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
  res <- res + calculate_stupid_order(tokens)
}
