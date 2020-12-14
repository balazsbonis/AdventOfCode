input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\13\\test.txt",
       character(),
       sep = ",")
numbers <- sort(strtoi(input[input != "x"]), decreasing = TRUE)
offset <- match(numbers[1], input) - 1
timetable <- seq.int(0, 100000, by = numbers[1]) - offset
for (i in 2:length(numbers)) {
  offset <- match(numbers[i], input) - 1
  t <- seq.int(0, 100000, by = numbers[i]) - offset
  timetable <- intersect(t, timetable)
}
print(timetable[1])
