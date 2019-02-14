# Fixing character vectors - tolower(), toupper()
cameraData <- read.csv("./03_GetClean/Data/cameras.csv")
names(cameraData)

tolower(names(cameraData))
toupper(names(cameraData))

# Fixing character vectors - strsplit()
splitNames <- strsplit(names(cameraData), "\\.")
splitNames[[5]]
splitNames[[6]]

# Quick aside - lists
myList <- list(letters = c("A", "B", "C"), numbers = 1:3, matrix = matrix(1:25, ncol = 5))
head(myList)

myList[1]
myList$letters
myList[[1]]

# Fixing character vectors - sapply()
splitNames[[6]][1]

firstElement <- function(x) {x[1]}
sapply(splitNames, firstElement)

# Peer review data
fileURL1 <- "https://raw.githubusercontent.com/jtleek/dataanalysis/master/week2/007summarizingData/data/reviews.csv"
fileURL2 <- "https://raw.githubusercontent.com/jtleek/dataanalysis/master/week2/007summarizingData/data/solutions.csv"
download.file(fileURL1, "./03_GetClean/Data/reviews.csv")
download.file(fileURL2, "./03_GetClean/Data/solutions.csv")
date()
# Downloaded: "Mon Feb 11 09:20:57 2019"

reviews <- read.csv("./03_GetClean/Data/reviews.csv"); solutions <- read.csv("./03_GetClean/Data/solutions.csv")

head(reviews, 2)
head(solutions, 2) # I still think this is the wrong file.

# Fixing character vectors - sub().
# This stands for substitute, not substring.
names(reviews)
sub("_", "", names(reviews))

# Fixing character vectors - gsub().
# sub() only replaces the first instance.
testName <- "this_is_a_test"
sub("_", "", testName)

gsub("_", "", testName)

# Finding values - grep(), grepl().
# grepl() returns a logical vector.

grep("Alameda", cameraData$intersection)
table(grepl("Alameda", cameraData$intersection))

# Subsetting another way with grepl().
cameraData2 <- cameraData[!grepl("Alameda", cameraData$intersection), ]
nrow(cameraData)
nrow(cameraData2)

# More on grep()
grep("Alameda", cameraData$intersection, value = TRUE)

# This string isn't found.
grep("JeffStreet", cameraData$intersection)
length(grep("JeffStreet", cameraData$intersection))

# More useful string functions.
library(stringr)
nchar("Jai Jeffryes")
substring("Jai Jeffryes", 1, 3)
paste("Jai", "Jeffryes")
paste("Jai", "Jeffryes", sep = "")
paste0("Jai", "Jeffryes")

str_trim("             JAI          ")
str_trim("             JAI          ", side = "left")
str_trim("             JAI          ", side = "right")
str_trim("             JAI          ", side = "both")

# Important points about text in datasets.
# Names of variables should be:
#         All lower case
#         Descriptive (diagnosis vs. Dx)
#         Unique
#         No underscores or periods
# Variables with character values should:
#         Usually be made into factors
#         Should be descriptive(TRUE or FALSE instead of 0/1 and Male/Female vs. 0/1 or M/F)

# Regular expressions.
# We need a way to express:
#   Whitespace word boundaries.
#   Sets of literals.
#   The beginning and end of a line.
#   Alternatives ("war" or "peace").

# Metacharacters
# ^ = Beginning of a line.
# $ = End of a line.

# Character classes
# [Bb][Uu][Ss][Hh]
# Will match "bush", no matter what letters are capitalized.

# Ranges in a character class.
# [a-z]

# In a character class, ^ represents logical negation.
# [^?.]$
# Matches lines that do not end in a question mark or period.

# More metacharacters.
# . stands for one character.
# | is the logical OR operator.
# () can delimit subexpressions.
# ? following an expression indicates it is optional.
#    [Gg]eorge( [Ww\.])? [Bb]ush
# * repeat any number of times, including zero.
# + repeat at least once.
# {} interval quantifier.
#   m,n lower and upper limit of repetitions.
#   m exactly m matches.
#   m, at least m matches.

# Parentheses.
# Besides limiting scope of alternatives, can be used to reference text matched by the
# enclosed subexpression.
# \1 \2 refer to matched text.

# * is greedy, matching the longest string that satisfies the RE.
# The greediness can be turned off with ?

# Working with dates.
d1 <- date()
class(d1)
d2 <- Sys.Date()
class(d2)

# Formatting dates.
# %d = day as number (0-31), %a = abbreviated weekday, %A = unabbreviated weekday,
# %m = month (00-12), %b = abbreviated month, %B = unabbreviated month,
# %y = two-digit year, %Y = four-digit year.
format(d2, "%a %b %d")

# Creating dates.
# Parse text using the date formatting codes.
x <- c("1jan1960", "2jan1960", "31mar1960", "30jul1960"); z <- as.Date(x, "%d%b%Y")
z
z[1] - z[2]
as.numeric(z[1] - z[2])

# Extracting attributes.
weekdays(d2)
months(d2)
julian(d2)

# lubridate.
# Additional date functions.
library(lubridate)

ymd("20140108")
mdy("08/4/2013")
mdy("8/04/2013")
dmy("3/4/2013")

# Dealing with times.
ymd_hms("2011-08-03 10:15:03")
ymd_hms("2011-08-03 10:15:03", tz = "Pacific/Auckland")

Sys.timezone()
?Sys.timezone

# Some functions in lubridate have slightly different syntax.
x <- dmy(x)
x
wday(x[1])
wday(x[1], label = TRUE)

# Notes and more resources.
# Lubridate. http://www.r-statistics.com/2012/03/do-more-with-dates-and-times-in-r-with-lubridate-1-1-0/
# Look up the lubridate vignette.
# Dates and times should be class Date, POSIXct, or POXIClt.

# Data resources.
# United Nations. http://data.un.org/
# U.S. http://www.data.gov/
# United Kingdom. http://data.gov.uk/
# France. http://www.data.gouv.fr/
# Ghana. http://data.gov.gh/
# Australia. http://data.gov.au/
# Germany. https://www.govdata.de/
# Hong Kong. http://www.gov.hk/en/theme/psi/datasets/
# Japan. http://www.data.go.jp/
# Many more. http://www.data.gov/opendatasites/

# Gapminder.
# Health.
# http://www.gapminder.org

# Survey data.
# I even know this one.
# http://www.asdfree.com

# Infochimps marketplace.
# http://www.infochimps.com/marketplace

# Kaggle.
# http://www.kaggle.com

# Collections by data scientists.
# Hillary Mason. https://distlib.blogs.com/distlib/2016/03/recreating-hilary-masons-research-quality-data-sets-bitly-bundle.html
# Jeff Hammerbacher. https://www.quora.com/Jeff-Hammerbacher/Introduction-to-Data-Science-Data-Sets
# Gregory Piatetsky-Shapiro. http://www.kdnuggest.com/gps.html

# More
# Stanford Large Newtork Data
# UCI Machine Learning
# KDD Nuggets Datasets
# CMU Statlib
# Gene expression omnibus
# ArXivData
# Public Data Sets on Amazon Web Services

# Some APIs with R interfaces
# twitter and twitterR packages
# figshare and rfigshare
# PLoS and rplos
# rOpenSci
# Facebook and RFacebook
# Google maps and RGoogleMaps

# Quiz.
# 1
acs_id2006 <- read.csv("./03_GetClean/Data/acs_micro_ID2006.csv")

splitNames <- strsplit(names(acs_id2006), "wgtp")
splitNames[123]

# 2
gdp <- read.csv("./03_GetClean/Data/GDP190.csv", header = FALSE, skip = 5,
                na.strings = "..", nrows = 195 - 5)

# Get rid of whitespace columns
gdp <- gdp[ , c(1,2,4,5)]

# Rename columns
names(gdp) <- c("CountryCode", "Ranking", "Economy", "GDP_dollars")

head(gdp)

head(gsub(",", "", gdp$GDP_dollars))

# Strip commas.
gdp$GDP_dollars <- gsub(",", "", gdp$GDP_dollars)

# Convert to numeric
gdp$GDP_dollars <- as.numeric(gdp$GDP_dollars)
mean(gdp$GDP_dollars)

names(gdp)

grep("^United", gdp$Economy)
gdp$Economy[c(99, 186)]

# 4
library(plyr)
edstats <- read.csv("./03_GetClean/Data/EducationalStats.csv")

str(gdp)
str(edstats)

intersect(names(gdp), names(edstats))

dfList <- list(gdp, edstats)

mergedData <- join_all(dfList)

str(mergedData)

fiscalidx <- grep("[Ff]iscal.*[Jj]une", mergedData$Special.Notes)

mergedData[fiscalidx, "Special.Notes"]

length(fiscalidx)

# 5.
install.packages("quantmod")
library(quantmod)
amzn <- getSymbols("AMZN", auto.assign = FALSE)

head(amzn)
dimnames(amzn)
str(amzn)
class(amzn)
# xts, zoo.

head(amzn["2012"])

nrow(amzn["2012"])

amzn2012 <- amzn["2012"]

nrow(amzn2012)

# zoo class indexes by date. Get those dates and answer questions about them.
amzn2012dates <- index(amzn2012)

length(grep("Monday", weekdays(amzn2012dates)))
