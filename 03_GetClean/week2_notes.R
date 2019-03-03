# 1. mySQL
# Build a mySQL server.
# Nice to have. Save that for its own VM when I get around to it.

# Install package RMySQL
# Ubuntu requires deb: libmariadbclient-dev | libmariadb-client-lgpl-dev (Debian, Ubuntu)
# This appears to require installation of mySQL. You can't just install the R package
# and connect to an existing server.

# Sample code. Connections, querying, etc.
# Do this later when you build an environment to support it.

# Connect to a server and list databases. Remember to disconnect.
ucscDb <- dbConnect(MySQL(),user="genome",
                   host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb,"show databases;"); dbDisconnect(ucscDb);

# Connect to a database and list databases.
hg19 <- dbConnect(MySQL(),user="genome",db="hg19",
                  host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)

allTables(1:5)

# Get dimensions of a particular table.
dbListFields(hg19, "affyU133Plus2")

dbGetQuery(hg19, "select count(*) from affyU133Plus2")

# Read from the table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

# Select a subset
# Stores the result on the server...
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
# Retrieves the results...
affyMis <- fetch(query); quantile(affyMis$misMatches)

# You can look at a small subset of the result stored on the server.
# Here, the top 10. Then clear the result on the server.
affyMisSmall <- fetch(query,n=10); dbClearResult(query);

dim(affyMisSmall)

# Close the connection
dbDisconnect(hg19)

# 2. HDF5
# Hierarchical Data Format
# Large data sets
# Variety of data types
#
# Groups containing zero or more data sets and metadata.
#   Group header with group name and list of attributes.
#   Group symbol table with list of objects in group.
#
# Data sets, multidimensional array of data elements with metadata.
#   Header with name, datatype, dataspace, and storage layout.
#   Data array with the data.
#
# http://www.hdfgroup.org

# Get the R HDF5 package.
# Already installed bioconductor installer, no? Guess not.
# Lecture modeled after:
# http://bioconductor.org/packages/release/bioc/vignettes/rhdf5/inst/doc/rhdf5.pdf
# Try this link:
# http://bioconductor.org/packages/devel/bioc/vignettes/rhdf5/inst/doc/practical_tips.html
# Really the vignette with the package. I was able to install the package, so I could look there.

source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")

library(rhdf5)
file.remove("example.h5")
created <- h5createFile("example.h5")
created # Should equal TRUE

created <- h5createGroup("example.h5", "foo")
created <- h5createGroup("example.h5", "baa")
created <- h5createGroup("example.h5", "foo/foobaa")
h5ls("example.h5")

# Write to groups.
A <- matrix(1:10, nr = 5, nc = 2)
h5write(A, "example.h5", "foo/A")
B <- array(seq(0.1, 2.0, by = 0.1, ), dim = c(5, 2, 2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")

h5ls("example.h5")

# Write a dataset.
df <- data.frame(1L:5L, seq(0, 1, length.out = 5),
                 c("ab", "cde", "fghi", "a", "s"), stringsAsFactors = FALSE)

h5write(df, "example.h5", "df")

h5ls("example.h5")

# Read.
readA <- h5read("example.h5", "foo/A")
readB <- h5read("example.h5", "foo/foobaa/B")
readdf <- h5read("example.h5", "df")

readA
readB
readdf

# Writing and reading in chunks.
h5write(c(12, 13, 14), "example.h5", "foo/A", index = list(1:3, 1))
# This is a READ, not an LS.
# The index for writing can also be used for reading.
h5read("example.h5", "foo/A")

# 2. Web scraping.
# Raw.
con <- url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode <- readLines(con)
close(con)
htmlCode

# Parsed.
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes = TRUE) 

# Nope, Google redirects to HTTPS. Use RCurl.
library(RCurl)
URL.1 <- "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
URL.2 <- getURL(URL.1)

head(URL.2) # That has data in it.

# Use the 2nd step URL. Now it works.
html <- htmlTreeParse(URL.2, useInternalNodes = TRUE)
html

xpathSApply(html, "//title", xmlValue)

# This doesn't work. Page doesn't use ID attributes in <TD> tags now.
pathSApply(html, "//td[@id='col-citedby']", xmlValue)

# Here are some table data tag values.
xpathSApply(html, "//td", xmlValue)

# GET from the httr package.
library(httr); html2 <- GET(url)
content2 <- content(html2, as = "text")
parsedHTML <- htmlParse(content2, asText = TRUE)
xpathSApply(html, "//title", xmlValue)

# Accessing websites with passwords.
pg2 <- GET("http://httpbin.org/basic-auth/user/passwd",
           authenticate("user", "passwd"))
pg2

names(pg2)

# Using handles.
# If you save a handle, you have the authentication cookie and you can use it
# to get to other pages with the authentication you saved.
google <- handle("http://google.com")
pg1 <- GET(handle = google, path = "/")
pg2 <- GET(handle = google, path = "search")
pg1

# References
# Good examples.
# http://www.r-bloggers.com/?s=Web+Scraping
# Help file, more good examples.
# http://cran.r-project.org/web/packages/httr/httr.pdf

# APIs
# Usually use GET requests with specific URLs as arguments.
# Usually need a developer account for the API.

# None of this worked as presented. If I need it, I'll drill into it later.
# Twitter. PnoJai app.
# Consumer API keys
# BvGNFQ077eIUu2jczx7CfQsiA (API key)
# EneR5yjka25OFQgn9e7F8vk7aQukxkC5GNdsgEFZAVW89lKiPw (API secret key)
# 
# Access token & access token secret
# 294633077-ENungp0S0nMw05m74jyqhZDW6ZZEemDBKN4baByj (Access token)
# H0P970NjETukx9vQ5atTmdaliZ0NhpqGozSf6KrQ6E847 (Access token secret)
# Read and write (Access level)
library(httr)
myapp <- oauth_app("twitter",
                  key = "BvGNFQ077eIUu2jczx7CfQsiA", #Consumer Secret Key"
                  secret = "EneR5yjka25OFQgn9e7F8vk7aQukxkC5GNdsgEFZAVW89lKiPw") # Your consumer secret key
sig <- sign_oauth1.0(myapp,
                     token = "294633077-ENungp0S0nMw05m74jyqhZDW6ZZEemDBKN4baByj", # Your token
                     token_secret = "EneR5yjka25OFQgn9e7F8vk7aQukxkC5GNdsgEFZAVW89lKiPw")
2
homeTL <- GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
homeTL

json1 <- content(homeTL)
json1

json2 <- jsonlite::fromJSON(toJSON(json1))
json2[1, 1:4]

# Other data.
# Music
# tuneR on CRAN
# seewave. http://rug.mnhn.fr/seewave/

# Quiz.
# More instruction at quiz, accessing API at GitHub.
# A page of API demos using httr.
# https://github.com/r-lib/httr/tree/master/demo
# Using now examples from the GitHub demo.

library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "82f6ffe8eddf8f9c0870",
                   secret = "9a11c4108199a156045c42fbad58f18c64c02015"
)

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
1 # Unlike my Twitter attempt, this time I selected saving a local file.
  # httr opened my browser and I manually authorized my app.

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/rate_limit", gtoken)
stop_for_status(req)
content(req)

# OR:
req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
stop_for_status(req)
content(req)

# Quiz.

# Question 1.
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
ct <- content(req)

out <- capture.output(str(ct))

cat(out, file = "03_GetClean/Data/ct_str.txt", sep = "\n")

head(ct)

ct[[16]]

# It was a lame fishing expedition, but I found the answer by browsing.

# 2.
# Get the package sqldf.
# Hey, that thing lets me write SQL.
library(sqldf)

file_name <- "03_GetClean/Data/acs_micro_ID2006.csv"
acs <- read.csv(file_name)

sqldf("select * from acs")

# unique(acs$...

# 4. Count characters in HTML lines.
# http://biostat.jhsph.edu/~jleek/contact.html

con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(con)
close(con)
htmlCode

lins <- htmlCode[c(10, 20, 30, 100)]

# I finally understood and was able to use lapply().
lapply(lins, nchar)

# 5. Get this file and report the sum of the 4th of 9 columns
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for

file_name <- "03_GetClean/Data/wksst8110.for"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"

if (!file.exists(file_name)) {
        download.file(fileURL, destfile = file_name)
} else {
        print( paste("File exists, download skipped:", file_name))
}

dateDownloaded <- date()
dateDownloaded # "Sat Feb  2 10:55:16 2019"

# Fixed width.
# What the hell, just try CSV and see what happens.
dat <- read.csv(file_name, header = TRUE, skip = 3)
str(dat)

# That's what I thought. Each line is an entire string. And it's a factor!
# The header names are not unique. And if you do include them, the text makes the
# whole column read as a character vector.
dat <- read.fwf(file = file_name, widths = c(15, 4, 9, 4, 9, 4, 9, 4, 4), header = FALSE, skip = 4,
                stringsAsFactors = FALSE)
str(dat)

sum(dat$V4)
