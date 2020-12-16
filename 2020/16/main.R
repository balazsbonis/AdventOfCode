rules <- list(
  departure_location = c(39:715, 734:949),
  departure_station = c(30:152, 160:959),
  departure_platform = c(34:780, 798:955),
  departure_track = c(32:674, 699:952),
  departure_date = c(38:55, 74:952),
  departure_time = c(45:533, 547:970),
  arrival_location = c(27:168, 191:969),
  arrival_station = c(43:585, 599:953),
  arrival_platform = c(40:831, 837:961),
  arrival_track = c(37:293, 301:974),
  class = c(40:89, 112:950),
  duration = c(25:600, 625:970),
  price = c(45:318, 341:954),
  route = c(40:898, 912:968),
  row = c(38:872, 881:958),
  seat = c(37:821, 831:958),
  train = c(26:343, 365:956),
  type = c(37:857, 872:960),
  wagon = c(36:425, 445:972),
  zone = c(44:270, 286:967)
)

lines <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\16\\nearby_tickets.txt",
       what = list(""))[[1]]

tickets <- strsplit(lines, ",")
all_numbers <- strtoi(unlist(tickets))
over <- all_numbers[all_numbers > max(unlist(rules))]
under <- all_numbers[all_numbers < min(unlist(rules))]
part1 <- sum(over) + sum(under)

valid_tickets <- c()
for (l in lines) {
  t <- strtoi(unlist(strsplit(l, ",")))
  if (length(which(strtoi(t) > max(unlist(rules)))) == 0 &&
      length(which(strtoi(t) < min(unlist(rules)))) == 0) {
    valid_tickets <- append(valid_tickets, list(t))
  }
}

ticket_matrix <- t(sapply(valid_tickets, function(i)
  unlist(i)))

found_columns <- c()
found_rules <- c()
rule_counter <- 1

while (length(found_columns) != 20) {
  if (length(found_rules[found_rules == rule_counter]) == 0) {
    matches <- c()
    for (i in 1:20) {
      if (length(found_columns[found_columns == i]) == 0) {
        column <- ticket_matrix[, i]
        if (!any(column %in% rules[[rule_counter]] == FALSE)) {
          matches <- append(matches, i)
        }
      }
    }
    if (length(matches) == 1) {
      found_columns <- append(found_columns, matches)
      found_rules <- append(found_rules, rule_counter)
      print(paste("Found", names(rules[rule_counter]), "is in column", matches))
      rule_counter <- 0
    }
  }
  rule_counter <- rule_counter + 1
}

my_ticket <- c(223,139,211,131,113,197,151,193,127,53,89,167,227,79,163,199,191,83,137,149)
part2 <- prod(my_ticket[16], my_ticket[18], my_ticket[11], my_ticket[15], my_ticket[5], my_ticket[19])
