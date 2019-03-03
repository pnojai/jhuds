# Getting data
data_path <- "./03_GetClean/Data"

if (!dir.exists(data_path)) {
        dir.create(data_path)
}

file_name <- "cameras.csv"
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

if (!file.exists(paste(data_path, file_name, sep = "/"))) {
        download.file(fileURL, destfile = paste(data_path, file_name, sep = "/"))
} else {
        print( paste("File exists, download skipped:", file_name))
}

list.files(data_path)

dateDownloaded <- date()
dateDownloaded # "Sun Jan 20 12:31:40 2019"

# Try Excel.
library(xlsx)
# Get an Excel version.
file_name <- "cameras.xlsx"

# Read it.
cameraData <- read.xlsx(paste(data_path, file_name, sep = "/"), sheetIndex = 1, header = TRUE)

# My installation loads, but produces warnings about an illegal reflective access operation.
# Let's try XLConnect.
library(XLConnect)

cameraData <- loadWorkbook(paste(data_path, "TEST.xlsx", sep = "/"), create = TRUE)

# Fails with an error about no such method. Versions of Java have messed it up. Exactly why I
# snapshot a VM that I can roll back to and eliminate Java.

# That piece of crap run-time is gone from my VM. Let's try a package that doesn't depend on Java.
# Installed openxlsx from the developer page. The stable build on CRAN doesn't work on R v3.5.2.
# Developer website: https://github.com/awalker89/openxlsx
# Installed by loading the devtools library and running: install_github("awalker89/openxlsx")

library(openxlsx)
cameraData <- readWorkbook(paste(data_path, file_name, sep = "/"))
cameraData

# Beautiful. That package works. I can support workflows that include Excel.

# XML
library(XML)
fileURL <- "https://www.w3schools.com/xml/simple.xml"
file_name <- "simple.xml"
doc <- xmlTreeParse(fileURL, useInternalNodes = TRUE) # Doesn't work. Must be junk at the top of the file.

# Junk, yes and no. xmlTreeParse doesn't support the HTTPS protocol, which encrypts the transmission.
# Chiranjib Sardor, on Coursera, found a solution. Use RCurl, which does support HTTPS.
library(RCurl)
xmlURL.1 <- "https://www.w3schools.com/xml/simple.xml"
xmlURL.2 <- getURL(xmlURL.1)

head(xmlURL.2) # That has data in it.

# Use the 2nd step URL. Now it works.
doc <- xmlTreeParse(xmlURL.2, useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

# Before learning about RCurl, I worked around the HTTPS problem by downloading and opening it.
download.file(fileURL, destfile = paste(data_path, file_name, sep = "/"))
doc <- xmlTreeParse(paste(data_path, file_name, sep = "/"), useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

# Programmatically extract parts of the file
xmlSApply(rootNode, xmlValue)

# That got me every value at every level in a string.
# Use XPath to pick off specific data.
# Review XPath. Downloaded his PDF into textbooks directory.
xpathSApply(rootNode, "//name", xmlValue)
xpathSApply(rootNode, "//price", xmlValue)

# Parse an HTML page
fileURL <- "http://www.espn.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileURL, useInternalNodes = TRUE)

rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

# The video looks for the tag <li>, but the data has changed. They're in <div> tags now.
scores <- xpathSApply(doc, "//div[@class='score']", xmlValue)
scores
teams <- xpathSApply(doc, "//div[@class='game-info']", xmlValue)
teams

# Check out JSON
# https://www.r-bloggers.com/new-package-jsonlite-a-smarter-json-encoderdecoder/

# Package: data.table
library(data.table)

df <- data.frame(x=rnorm(9), y=rep(c("a", "b", "c"), each=3), z=rnorm(9))
head(df)

dt <- data.table(x=rnorm(9), y=rep(c("a", "b", "c"), each=3), z=rnorm(9))
head(df)

tables()
dt
dt[2,]
dt[dt$y == "a"]

# Quiz
file_name <- "acs_micro_ID2006.csv"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

if (!file.exists(paste(data_path, file_name, sep = "/"))) {
        download.file(fileURL, destfile = paste(data_path, file_name, sep = "/"))
} else {
        print( paste("File exists, download skipped:", file_name))
}

dateDownloaded <- date()
dateDownloaded # "Sun Jan 20 16:49:53 2019"

file_name <- "acs_micro_codebook.pdf"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
if (!file.exists(paste(data_path, file_name, sep = "/"))) {
        download.file(fileURL, destfile = paste(data_path, file_name, sep = "/"))
} else {
        print( paste("File exists, download skipped:", file_name))
}

dateDownloaded <- date()
dateDownloaded # "Sun Jan 20 16:51:25 2019"

list.files(data_path)

file_name <- "acs_micro_ID2006.csv"
acs_data <- read.csv(paste(data_path, file_name, sep = "/"))
head(acs_data)

# 1. How many properties are worth $1,000,000 or more
# Variable VAL records property value.
# Code 24 indicates $1,000,000 or more

head(acs_data$VAL)

# Your SQL head thinks about SELECT first and filter (WHERE) second.
# In data frame notation, the first index expresses the filter condition,
# the second index expresses the select.
acs_data[acs_data$VAL == 24 & !is.na(acs_data$VAL), "VAL"]

# This result is a vector now, not a data frame.
str(acs_data[acs_data$VAL == 24 & !is.na(acs_data$VAL), "VAL"])

# You see them. Now count them. A vector, so length(), not nrow() like a data frame.
length(acs_data[acs_data$VAL == 24 & !is.na(acs_data$VAL), "VAL"])

# 3 Download Excel spreadsheet.
library(openxlsx)

file_name <- "NaturalGasAcquisitionProgram.xlsx"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

if (!file.exists(paste(data_path, file_name, sep = "/"))) {
        download.file(fileURL, destfile = paste(data_path, file_name, sep = "/"))
} else {
        print( paste("File exists, download skipped:", file_name))
}

dateDownloaded <- date()
dateDownloaded # "Mon Jan 21 11:58:05 2019"

dat <- read.xlsx(paste(data_path, file_name, sep = "/"),
                 rows = 18:23, cols = 7:15)
str(dat)

sum(dat$Zip*dat$Ext,na.rm=T)

# 4 Download XML file.
library(XML)

file_name <- "BaltimoreRestaurants.xml"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

if (!file.exists(paste(data_path, file_name, sep = "/"))) {
        download.file(fileURL, destfile = paste(data_path, file_name, sep = "/"))
} else {
        print( paste("File exists, download skipped:", file_name))
}

dateDownloaded <- date()
dateDownloaded # "Mon Jan 21 12:10:14 2019"

doc <- xmlTreeParse(paste(data_path, file_name, sep = "/"), useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

# How many zipcode values = 21231.
# I solved it by picking off all zipcode values and then summing the matches.
# I'm sure you could filter this in XPath, too.
zipcodes <- xpathSApply(doc, "//zipcode", xmlValue)
sum(zipcodes == "21231")

#5. Performance.
# The download file is not the exact same file as question #1.
library(data.table)

file_name <- "acs_micro_ID2006_2.csv"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

if (!file.exists(paste(data_path, file_name, sep = "/"))) {
        download.file(fileURL, destfile = paste(data_path, file_name, sep = "/"))
} else {
        print( paste("File exists, download skipped:", file_name))
}

dateDownloaded <- date()
dateDownloaded # "Mon Jan 21 12:26:11 2019"

DT <- fread(file = paste(data_path, file_name, sep = "/"))

head(DT)
str(DT)

head(DT$pwgtp15)

# Hmm. I wonder if there is a way to lapply commands.
# cmds <- list("DT[,mean(pwgtp15),by=SEX]")
# lapply(cmds, system.time)

DT[,mean(pwgtp15),by=SEX]
sapply(split(DT$pwgtp15,DT$SEX),mean)
# No good. mean(DT$pwgtp15,by=DT$SEX)
mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
# No good. rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
tapply(DT$pwgtp15,DT$SEX,mean)

print("BEGIN PERFORMANCE TEST")
system.time(DT[,mean(pwgtp15),by=SEX])

system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))

# Apparent winner. But incorrect result.
# system.time(mean(DT$pwgtp15,by=DT$SEX))

system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})

# system.time({rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]})

system.time(tapply(DT$pwgtp15,DT$SEX,mean))

# Try saving the results
test_timings <- system.time(tapply(DT$pwgtp15,DT$SEX,mean))
str(test_timings)

# I'm unsure how useful that is for this assignment. I'm moving on for now.