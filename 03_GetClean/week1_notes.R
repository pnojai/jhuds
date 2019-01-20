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
# Installed openxml from the developer page. The stable build on CRAN doesn't work on R v3.5.2.
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

# Worked when I downloaded it and opened it.
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

head(acs_data$VAL)

# 1. How many properties are worth $1,000,000 or more
# Variable VAL records property value.
# Code 24 indicates $1,000,000 or more


