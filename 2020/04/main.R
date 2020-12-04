library(dplyr)

is_hgt_correct <- function(x) {
  if (is.na(x))
    return (FALSE)
  else {
    hgtmeasure <- substr(x, nchar(x) - 1, nchar(x))
    hgtsize <- strtoi(sub("in", "", sub("cm", "", x)))
    if ((hgtmeasure == "in" &&
         hgtsize >= 59 &&
         hgtsize <= 76) ||
        (hgtmeasure == "cm" &&
         hgtsize >= 150 && hgtsize <= 193))
      return (TRUE)
    else
      return (FALSE)
  }
}

f <- file("c:\\Work\\Code\\AdventOfCode\\2020\\04\\input.txt", "r")
byr <- iyr <- eyr <- hgt <- hcl <- ecl <- pid <- cid <- c(NA)
hgtcorrect <- c(NA)
ID <- c(1)
i <- 1
while (length(line) != 0) {
  line <- readLines(f, n = 1)
  if (length(line) == 0) {
    hgtcorrect[i] <- is_hgt_correct(hgt[i])
    break
  }
  if (nchar(line) == 0) {
    # calculate fields
    hgtcorrect[i] <- is_hgt_correct(hgt[i])
    # assign new row
    i <- i + 1
    byr[i] = iyr[i] = eyr[i] = hgt[i] = hcl[i] = ecl[i] = pid[i] = cid[i] = NA
    ID[i] <- i
  }
  if (nchar(line) > 1) {
    props <- strsplit(strsplit(line, " ")[[1]], ":")
    for (p in props) {
      assign(p[1], `[<-`(get(p[1]), i, p[2]))
    }
  }
}

byr <- strtoi(byr)
cid <- strtoi(cid)
eyr <- strtoi(eyr)
iyr <- strtoi(iyr)
pidlength <- nchar(pid)
DF <-
  data.frame(ID, byr, iyr, eyr, hgt, hcl, ecl, pid, pidlength, hgtcorrect)
# Part 1
part1 <- filter(
  DF,!is.na(byr),!is.na(ecl),!is.na(eyr),!is.na(hcl),!is.na(hgt),!is.na(iyr),!is.na(pid)
)
print(nrow(part1))

# Part 2
part2 <- (
  filter(
    part1,
    byr >= 1920,
    byr <= 2002,
    iyr >= 2010,
    iyr <= 2020,
    eyr >= 2020,
    eyr <= 2030,
    pidlength == 9,
    hgtcorrect == TRUE,
    ecl %in% c("amb","blu","brn","gry","grn","hzl","oth"),
    grepl("^#([a-f0-9]{6})$", hcl)
  )
)
