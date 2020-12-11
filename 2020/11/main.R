library(matrixStats)
# Create matrix
input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\11\\input.txt",
       character(),
       sep = "\n")
m_original <-
  matrix(c("."), nrow = length(input) + 2, ncol = nchar(input[1]) +
           2)
for (i in 1:length(input)) {
  m_original[i + 1, 2:(nchar(input[i]) + 1)] <-
    strsplit(input[i], "")[[1]]
}

# Part 1
m <- m_original
while (TRUE) {
  m_copy <- m
  for (i in 2:(nrow(m) - 1)) {
    for (j in 2:(ncol(m) - 1)) {
      mask <- m[(i - 1):(i + 1), (j - 1):(j + 1)]
      if (m[i, j] == "L" && !(any(mask == "#"))) {
        m_copy[i, j] <- "#"
      }
      if (m[i, j] == "#" && length(which(mask == "#")) >= 5) {
        m_copy[i, j] <- "L"
      }
    }
  }
  if (identical(m_copy, m)) {
    break
  }
  #print(m_copy)
  m <- m_copy
}
part1 <- length(which(m == "#"))

# Part 2
m2 <- m_original
while (TRUE) {
  m_copy <- m2
  for (i in 2:(nrow(m2) - 1)) {
    for (j in 2:(ncol(m2) - 1)) {
      if (m2[i, j] != ".") {
        left <- m2[i, max(which(m2[i, 1:(j - 1)] != "."))]
        right <-
          m2[i, (min(which(m2[i, (j + 1):ncol(m2)] != ".")) + j)]
        top <- m2[max(which(m2[1:(i - 1), j] != ".")), j]
        bottom <-
          m2[min(which(m2[(i + 1):nrow(m2), j] != ".")) + i, j]
        
        topleft <- topright <- bottomleft <- bottomright <- NA
        for (k in 1:min(nrow(m2), ncol(m2))) {
          # top-left
          if (is.na(topleft) &&
              i - k > 1 && j - k > 1 && m2[i - k, j - k] != ".") {
            topleft <- m2[i - k, j - k]
          }
          # top-right
          if (is.na(topright) &&
              i + k < nrow(m2) &&
              j - k > 1 && m2[i + k, j - k] != ".") {
            topright <- m2[i + k, j - k]
          }
          # bottom-right
          if (is.na(bottomright) &&
              i + k < nrow(m2) &&
              j + k < ncol(m2) && m2[i + k, j + k] != ".") {
            bottomright <- m2[i + k, j + k]
          }
          # bottom-left
          if (is.na(bottomleft) &&
              i - k > 1 &&
              j + k < ncol(m2) && m2[i - k, j + k] != ".") {
            bottomleft <- m2[i - k, j + k]
          }
        }
        
        if (m2[i, j] == "L") {
          if ((is.na(bottom) || bottom == "L") &&
              (is.na(bottomleft) || bottomleft == "L") &&
              (is.na(bottomright) || bottomright == "L") &&
              (is.na(left) || left == "L") &&
              (is.na(right) || right == "L") &&
              (is.na(top) || top == "L") &&
              (is.na(topleft) || topleft == "L") &&
              (is.na(topright) || topright == "L")) {
            m_copy[i, j] <- "#"
          }
        }
        if (m2[i, j] == "#") {
          count <- 0
          if (!is.na(bottom) && bottom == "#")
            count <- count + 1
          if (!is.na(bottomleft) && bottomleft == "#")
            count <- count + 1
          if (!is.na(bottomright) && bottomright == "#")
            count <- count + 1
          if (!is.na(left) && left == "#")
            count <- count + 1
          if (!is.na(right) && right == "#")
            count <- count + 1
          if (!is.na(top) && top == "#")
            count <- count + 1
          if (!is.na(topleft) && topleft == "#")
            count <- count + 1
          if (!is.na(topright) && topright == "#")
            count <- count + 1
          if (count >= 5) {
            m_copy[i, j] <- "L"
          }
        }
      }
    }
  }
  if (identical(m_copy, m2)) {
    break
  }
  #print(m_copy)
  m2 <- m_copy
}
part2 <- length(which(m_copy == "#"))
