# Subsetting - Quick Review
set.seed(13435)
X <- data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
X <- X[sample(1:5), ]; X$var2[c(1,3)] = NA

X

# Subset 1st column.
X[ , 1]

# Subset 1st column by its name.
X[ , "var1"]

# Subset columns and rows
X[1:2, "var2"]

# Subset by logicals
X[X$var1 <= 3 & X$var3 > 11, ]

X[X$var1 <= 3 | X$var3 > 15, ]

X

# This shows missing values.
X[X$var2 > 8, ]

# This removes them.
X[which(X$var2 > 8), ]

# Sort
sort(X$var1)

sort(X$var1, decreasing = TRUE)

sort(X$var2, na.last = TRUE)

# Order
X[sort(X$var1), ]
X[order(X$var1), ]

# Order returns indexes, so it is useful inside square brackets.
sort(X$var1)
order(X$var1)

# Ordering with plyr.
library(plyr)
# Notice the $ is unnecessary.
arrange(X, var1)

arrange(X, desc(var1))

# Adding rows and columns
X$var4 <- rnorm(5)
X

Y <- cbind(X, rnorm(5))
Y

# Summarizing Data.

# Get data from the web.
if (!file.exists("./03_GetClean/Data")) {dir.create("./03_GetClean/Data")}
fileURL <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./03_GetClean/Data/restaurants.csv")

dateDownloaded <- date()
dateDownloaded # "Sun Feb 10 08:24:16 2019"

restData <- read.csv("./03_GetClean/Data/restaurants.csv")

# Examine
head(restData)
tail(restData)

# Summary will start the data quality analysis. What should be quantitative variables and what
# should be qualitative. Factors are counted. That zip code shouldn't have been negative.
summary(restData)
str(restData)

# Quantiles of quantitative variables.
quantile(restData$councilDistrict, na.rm = TRUE)

# Or look at different percentiles.
quantile(restData$councilDistrict, probs = c(0.5, 0.75, 0.9))



# Make table
# Contingency table. By default, omits NAs. Should count those, too.
table(restData$zipCode, useNA = "ifany")

# Can use table to count in two dimensions to observe relationships
# between multiple qualitative variables.
table(restData$zipCode, restData$councilDistrict, useNA = "ifany")
table(restData$councilDistrict, restData$zipCode, useNA = "ifany")

# Check for missing values
sum(is.na(restData$councilDistrict))

# Same test but a little less "hacky," more self-documenting.
any(is.na(restData$councilDistrict))

# Like SQL EXISTS.
any(restData$zipCode < 0)

# This isn't a missing value test. Tests range.
all(restData$zipCode > 0)

# Column sums
# These are great tricks for finding missing values anywhere. USE THESE.
colSums(is.na(restData))

# Same test. Summarizes global.
all(colSums(is.na(restData)) == 0)

# Values with specific characteristics.
table(restData$zipCode == "21212")
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212", "21213"))

# Subsetting.
# Once you have created a logical variable, you can pass it to the row
# subsetting component of the dataset.
# This is FILTERING, the equivalent of the SQL WHERE clause.
restData[restData$zipCode %in% c("21212", "21213"), ]

# Cross tabs.
data(UCBAdmissions)
DF <- as.data.frame(UCBAdmissions)
summary(DF)

head(DF)
tail(DF)

# Left side of formula (Freq here) is the variable in the table.
# Right side of formula (Gender and Admit here) are the pivots.
xt <- xtabs(Freq ~ Gender + Admit, data = DF)
xt

xt <- xtabs(Freq ~ Admit + Gender, data = DF)
xt

# Flat tables
# warpbreaks is a built in dataset.
# Add a variable for illustration.
warpbreaks$replicate <- rep(1:9, len = 54)
warpbreaks

str(warpbreaks)

xt <- xtabs(breaks ~., data = warpbreaks)
xt

# Summarize in a compact form. It's like an Excel pivot table
# with multiple variables in the rows. Very good.
ftable(xt)

# Size of a dataset.
fakeData <- rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData), units = "Mb")

# Creating new variables.
# Might need them as predictors.
# Common variables to create.
#   Missingness indicators.
#   Cutting up quantitative variables.
#   Transformations. Dealing with data with strange distributions.

restData <- read.csv("./03_GetClean/Data/restaurants.csv")

# Creating sequences.
# Sequences often used to create an index.
s1 <- seq(1, 10, by = 2); s1
s2 <- seq(1, 10, length.out = 3); s2
x <- c(1, 3, 8, 25, 100); seq(along.with = x)
seq_along(x)

# Subsetting variables.
restData$NearMe <- restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$NearMe)

# Creating binary variables.
restData$zipWrong <- ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong)

# This doesn't make sense because it is redundant.
table(restData$zipWrong, restData$zipCode < 0)

# Creating categorical variables.
restData$zipGroups <- cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroups)

table(restData$zipGroups, restData$zipCode)

# Another way.
library(Hmisc)
# g paramenter is the the number of quantile groups.
# cut2 produces factor variables
restData$zipGroups <- cut2(restData$zipCode, g = 4)

table(restData$zipGroups)

class(restData$zipGroups)

# Creating factor variables.
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]
class(restData$zcf)

# Levels of factor variables.
yesno <- sample(c("yes", "no"), size = 10, replace = TRUE)
yesnofac <- factor(yesno, levels = c("yes", "no"))
yesnofac
as.numeric(yesnofac)
relevel(yesnofac, ref = "yes")
as.numeric(yesnofac)

# Using the mutate function.
# Comes from plyr.
library(Hmisc); library(plyr)
restData2 <- mutate(restData, zipGroups = cut2(zipCode, g = 4))
str(restData2)
table(restData2$zipGroups)

# Common transformations.
# abs(x)
# sqrt(x)
# ceiling(x)
# floor(x)
# round(x, digits = n)
# signif(x, digits = n)
# cos(x), sin(x), etc.
# log(x)
# log2(x)
# log10(x)
# exp(x)
# 
# http://statmethods.net/management/functions.html

# plyr tutorial.
# http://plyr.had.co.nz/09-user/

# Reshaping data.
# Tidy data.
# 1. Each variable forms a column.
# 2. Each observation forms a row.
# 3. Each table or file stores data about one kind of observation (e.g. people or hospitals).

# Start with reshaping.
library(reshape2)
head(mtcars)

# Melting data frames.
# Tall, skinny dataset.
rownames(mtcars)

mtcars$carname <- rownames(mtcars)
head(mtcars)

carmelt <- melt(mtcars, id = c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp"))
head(carmelt)
tail(carmelt, n = 3)

# Casting data frames.
cylData <- dcast(carmelt, cyl ~ variable)
cylData

cylData <- dcast(carmelt, cyl ~ variable, mean)
cylData

# Averaging values
head(InsectSprays)

# That's not an average.
tapply(InsectSprays$count, InsectSprays$spray, sum)

# Another way. Split, apply, combine.
# Another way - split.
spIns <- split(InsectSprays$count, InsectSprays$spray)
spIns

# Another way - apply.
# Split produced a list.
sprCount <- lapply(spIns, sum)
sprCount

# Another way - combine.
unlist(sprCount)

# You can go from the list, applying and combining at once.
sapply(spIns, sum)

# Another way - plyr package.
ddply(InsectSprays, .(spray), summarize, sum = sum(count))

spraySums <- ddply(InsectSprays, .(spray), summarize, sum = ave(count, FUN = sum))
dim(spraySums)
head(spraySums)

# More information
# Reshape tutorial. http://www.slideshare.net/jeffreybreen/reshaping-data-in-r
# A good plyr primer. http://www.r-bloggers.com/a-quick-primer-on-split-apply-combine-problems/

# See functions:
#  acast - for casting as multi-dimensional arrays.
#  arrange - for faster reordering without using order() commands.
#  mutate - adding new variables.

# dplyr.
# Verbs:
#   arrange
#   filter
#   select
#   mutate
#   rename
#   summarize

# dplyr properties.
#  1st argument is a data frame.
#  2nd, what to do with it. Can refer to the variables by name without the $ operator.
#  Result is a data frame.
#  Data frames must be properly formatted and annotated. For example, factor levels annotated,
#  and all the variable names are there.

library(dplyr)

# Downloaded file from:
# https://github.com/DataScienceSpecialization/courses/blob/master/03_GettingData/dplyr/chicago.rds
# To: 03_GetClean/Data.chicago.rds
# Downloaded  "Sun Feb 10 19:39:25 2019"
# date()

chicago <- readRDS("03_GetClean/Data/chicago.rds")
dim(chicago)
str(chicago)

head(chicago)
names(chicago)

# Range of columns.
head(select(chicago, city:dptp))

# Omit columns.
head(select(chicago, -(city:dptp)))

# Regular R is less readable.
i <- match("city", names(chicago))
j <- match("dptp", names(chicago))

head(chicago[ , i:j])
head(chicago[ , -(i:j)])

# Filtering
chic.f <- filter(chicago, pm25tmean2 > 30)
head(chic.f, n=10)

chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
head(chic.f, n = 10)

# Arrange
chicago <- arrange(chicago, date)
head(chicago)
tail(chicago)

# Descending
chicago <- arrange(chicago, desc(date))
head(chicago)
tail(chicago)

# Rename
chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp)
str(chicago)

# Mutate
# Centering a variable by subtracting the mean.
chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(select(chicago, pm25, pm25detrend))

# Group by
chicago <- mutate(chicago, tempcat = factor(1 * (tmpd > 80), labels = c("cold", "hot")))
head(chicago)

hotcold <- group_by(chicago, tempcat)
head(hotcold)
head(chicago)

str(hotcold)
str(chicago)

summarize(hotcold, pm25 = mean(pm25), o3 = max(o3tmean2), no2 = median(no2tmean2))
summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# Group by year

chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years <- group_by(chicago, year)
summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# Pipeline operator
chicago %>% 
        mutate(month = as.POSIXlt(date)$mon + 1) %>%
        group_by(month) %>%
        summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# dplyr can work with other data frame back ends.
# data.table for large, fast tables.
# SQL interface for relational databases via the DBI package.

# Merging data.

# Peer review data.
if (!file.exists("./03_GetClean/Data")) {dir.create("./03_GetClean/Data")}
fileURL1 ="http://www.sharecsv.com/dl/e70e9c289adc4b87c900fdf69093f996/reviews.csv"
fileURL2 ="http://www.sharecsv.com/dl/0863fd2414355555be0260f46dbe937b/solutions.csv"
download.file(fileURL1, destfile = "./03_GetClean/Data/reviews.csv")
download.file(fileURL1, destfile = "./03_GetClean/Data/solutions.csv")
date()
# Date downloaded:  "Sun Feb 10 20:44:24 2019"
# Thanks to Chee Loong Lian on the discussion board for reposting the files.

reviews <- read.csv("./03_GetClean/Data/reviews.csv")
solutions <- read.csv("./03_GetClean/Data/solutions.csv")

head(reviews, 2)
head(solutions, 2)

# I think Chee Loong uploaded the same file twice.

# Take notes on the code anyway.

# Merging data - merge()
# Merges data frames.
# x, y are data frames.
# by, by.x, by.y. all. Which columns to merge by. Default is to merge all columns with common names.

# all = TRUE is like an OUTER JOIN.
mergedData = merge(reviews, solutions, by.x = "solution_id", by.y = "id", all = TRUE)

# Default - merge all common column names.
intersect(names(solutions), names(reviews))

# If you have extra common columns you get Cartesion joins.

# Using join in the plyr package.
# Faster, but less features. You can only join on common column names.
df1 <- data.frame(id = sample(1:10), x = rnorm(10))
df2 <- data.frame(id = sample(1:10), y = rnorm(10))

head(df1, 2)
head(df2, 2)

arrange(join(df1, df2), id)

# Though less features than merge(), if you have the same column names,
# it's convenient to join multiple data frames.
df1 <- data.frame(id = sample(1:10), x = rnorm(10))
df2 <- data.frame(id = sample(1:10), y = rnorm(10))
df3 <- data.frame(id = sample(1:10), z = rnorm(10))
dfList <- list(df1, df2, df3)
join_all(dfList)

# More on merging data.
# The quick R data merging page. http://www.statmethods.net/management/merging.html
# plyr information. http://plyr.had.co.nz

# Quiz
# 1. Load ACS 2006 microdata.
acs2006 <- read.csv("./03_GetClean/Data/acs_micro_ID2006.csv")

# Greater than 10 acres.
# Column: ACR
# Code: 3

# Sold more than $10000 of agricultural products.
# Column: AGS
# Code: 6

head(select(acs2006, c("ACR", "AGS")))

# restData[restData$zipCode %in% c("21212", "21213"), ]

agriculturalLogical <- acs2006$ACR == 3 & acs2006$AGS == 6 #filter(acs2006, ACR == 3 & AGS == 6)

which(agriculturalLogical)

# 2. Picture

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileURL, destfile = "./03_GetClean/Data/jeff.jpg")
date()
# Downloaded: "Sun Feb 10 21:27:42 2019"

library(jpeg)

jeff <- readJPEG("./03_GetClean/Data/jeff.jpg", native = TRUE)

str(jeff)
class(jeff)

quantile(jeff, probs = c(0.3, 0.8))
quantile(jeff, probs = c(0.3, 0.8))[1]
quantile(jeff, probs = c(0.3, 0.8))[1] + c(-638, 638)

# 3. GDP

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileURL, destfile = "./03_GetClean/Data/GDP190.csv")
date()
# Downloaded: "Sun Feb 10 21:37:30 2019"

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileURL, destfile = "./03_GetClean/Data/EducationalStats.csv")
date()
# Downloaded: "Sun Feb 10 21:38:41 2019"

# Non-header whitespace at top. Multiple tables
# On the page. Just get the rankings in lines 6:195.
gdp <- read.csv("./03_GetClean/Data/GDP190.csv", header = FALSE, skip = 5,
                na.strings = "..", nrows = 195 - 5)
edstats <- read.csv("./03_GetClean/Data/EducationalStats.csv")

head(gdp, 2)
tail(gdp, 2)
str(gdp)

# Get rid of whitespace columns
gdp <- gdp[ , c(1,2,4,5)]

str(gdp)
# Rename columns
names(gdp) <- c("CountryCode", "Ranking", "Economy", "GDP_dollars")


head(edstats, 2)

intersect(names(gdp), names(edstats))

mergedData = merge(gdp, edstats, by.x = "CountryCode", by.y = "CountryCode", all = FALSE)

head(mergedData)

str(gdp)

nrow(mergedData)
library(tidyverse)
mergedData <- arrange(mergedData, desc(Ranking))

mergedData[ , 1:3]

str(mergedData)

# 4. Average ranking by income group.
table(mergedData$Income.Group)

# Split, apply, combine.

spRankIncGroup <- split(mergedData$Ranking, mergedData$Income.Group)

spRankIncGroup

spMeanRank <- lapply(spRankIncGroup, mean)
spMeanRank

# Another way - combine.
unlist(spMeanRank)

# 5.
library(Hmisc)

head(mergedData)
# g paramenter is the the number of quantile groups.
# cut2 produces factor variables
mergedData$RankingGroups <- cut2(mergedData$Ranking, g = 5)

table(mergedData$RankingGroups, mergedData$Income.Group)

class(restData$zipGroups)
