# Exploratory Data Analysis.
# Week 1 Project.
# Plot 1.

# Download the dataset.
DLurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
DLfile <- "04_EDA/Data/household_power_consumption.zip"
Logfile <- "04_EDA/Data/Download.log"
Overwrite <- FALSE

if (!file.exists(DLfile) | Overwrite == TRUE) {
        download.file(DLurl, DLfile)
        DLdate <- date()
        
        DLfileMsg <- paste0("Download file: ", DLfile)
        DLurlMsg <- paste0("URL: ", DLurl)
        DLdateMsg <- paste0("Download date: ", DLdate)
        
        cat(paste(" ", DLfileMsg, DLurlMsg, DLdateMsg, sep = "\n"),
            file = Logfile, sep = "\n", append = TRUE)
} else {
        print("File exists. Download skipped.")
}

# Extract it from the archive.
if (!file.exists("04_EDA/Data/household_power_consumption.txt")) {
        unzip(DLfile, exdir = "04_EDA/Data/")
}

# Data file
power_file <- "./04_EDA/Data/household_power_consumption.txt"

# How many lines in the dataset.
# Line count.
library(stringi)
cmd <- "wc"
line_count <- system(paste(cmd, power_file), intern = TRUE)
line_count <- as.numeric(stri_extract_first(line_count, regex = "\\d+"))
line_count # 2,075,260

# Look at the top of the file.
# Has a header.
initial <-  read.table(power_file, sep = ";", header = TRUE, nrows = 100, na.strings = "?")
initial
classes
# When you read the whole table you can use this for the argument colClasses.
classes <- gsub("factor", "character", sapply(initial, class))

# Read lines of the input file. Pick off the dataset we want by catting those
# lines to a new file.
# Input is power_file.
# This will be the filtered file.
power_file_filter <- "./04_EDA/Data/household_power_consumption_filter.txt"

theInput <- readLines(power_file, n = -1) # Change to n = -1 for whole file.
minDate <- as.Date("2007-02-01")
maxDate <- as.Date("2007-02-02")

# Send header to out.
cat(theInput[1], file = power_file_filter, sep = "\n", append = TRUE)

# Continue with line 2.
theResult <- lapply(theInput[-1], function(x) {
        inLine <- strsplit(x[[1]], ";")
        inDate <- as.Date(inLine[[1]][1], "%d/%m/%Y")
        
        if (inDate >= minDate & inDate <= maxDate) { # send the line to the new file.
                cat(x, file = power_file_filter, sep = "\n", append = TRUE)
                catCount <- catCount + 1
        }
})

# Count the lines in the filtered file.
cmd <- "wc"
power_filter_line_count <- system(paste(cmd, power_file_filter), intern = TRUE)
power_filter_line_count <- as.numeric(stri_extract_first(power_filter_line_count, regex = "\\d+"))
power_filter_line_count # 2881

print(paste0("Power file line count, ", power_file, ": ", line_count))
print(paste0("Power filtered file line count", power_file_filter, ": ", power_filter_line_count))

# strptime

#  <- read.table("datatable.txt",
#                      colClasses = classes)

# Add a line estimate for fast reading.
n_rows <- 1.1 * power_filter_line_count

power_consumption <-  read.table(power_file_filter, sep = ";", header = TRUE, nrows = n_rows,
                                 na.strings = "?", colClasses = classes)

# Convert date and time.
power_consumption$DateTime <- strptime(paste(power_consumption$Date, power_consumption$Time),
                                       "%d/%m/%Y %T")

head(power_consumption)
str(power_consumption)
