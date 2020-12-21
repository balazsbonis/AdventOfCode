input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\21\\input.txt",
       character(),
       sep = "\n")

lines <- strsplit(sub(")", "", input), " (contains ", fixed = TRUE)
allergens <- list()

while (length(allergens) < 8) {
  for (i in 1:(length(lines) - 1)) {
    allergen <- strsplit(lines[[i]][2], ", ")[[1]]
    ingredients_original <- strsplit(lines[[i]][1], " ")[[1]]
    for (a in allergen) {
      if (!(a %in% names(allergens))) {
        ingredients <- setdiff(ingredients_original, allergens)
        for (j in (i + 1):length(lines)) {
          if (any(strsplit(lines[[j]][2], ", ")[[1]] == a)) {
            cur <- strsplit(lines[[j]][1], " ")[[1]]
            cur <- setdiff(cur, allergens)
            ingredients <-
              intersect(ingredients, cur)
          }
          if (length(ingredients) == 1) {
            allergens[a] <- ingredients
            break
          }
        }
      }
    }
  }
}

part1 <- 0
for (l in lines) {
  part1 <-
    part1 + length(setdiff(strsplit(l[1], " ")[[1]], allergens))
}

part2 <- paste(allergens[sort(names(allergens))], collapse = ",")