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

# Connect to a databas and list databases.
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