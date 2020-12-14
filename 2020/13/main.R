# this doesn't work for large numbers :(
"input <-
  scan(\"c:\\Work\\Code\\AdventOfCode\\2020\\13\\test.txt\",
       character(),
       sep = \",\")
numbers <- sort(strtoi(input[input != \"x\"]), decreasing = TRUE)
offset <- match(numbers[1], input) - 1
timetable <- seqMpfr(9.999e+14, 1e+15, by = numbers[1]) - offset
for (i in 2:length(numbers)) {
  offset <- match(numbers[i], input) - 1
  t <-
    seqMpfr(timetable[1], 100000000000000, by = numbers[i]) - offset
  timetable <- intersect(t, timetable)
}
print(timetable[1])
"
input <-
  scan("c:\\Work\\Code\\AdventOfCode\\2020\\13\\test.txt",
       character(),
       sep = ",")
numbers <- sort(strtoi(input[input != "x"]), decreasing = TRUE)
offset <- match(numbers[1], input) - 1
stepper <- numbers[1]
cursor <- 0
i<- 2
while (TRUE) {
  cursor <- cursor + offset + stepper
  check_against <- (match(numbers[i], input) - 1)
  meh <- cursor - offset + check_against
  if (meh %% numbers[i] == 0)
  {
    stepper <- meh - check_against
    i<-i+1
    if (i > length(numbers)) {
      break
    }
  }
}
check <- offset + stepper

