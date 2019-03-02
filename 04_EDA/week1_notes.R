# Pollution example from the class.
DLurl <- "https://raw.githubusercontent.com/DataScienceSpecialization/courses/master/04_ExploratoryAnalysis/exploratoryGraphs/data/avgpm25.csv"
DLfile <- "04_EDA/Data/avgpm25.csv"
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

pollution <- read.csv("./04_EDA/Data/avgpm25.csv", colClasses = c("numeric", "character",
                                                                  "factor", "numeric", "numeric"))
head(pollution)

# Underlying question is do any counties exceed the EPA standard of 12 micrograms/m^3.
# You want to start with some kind of a question, even if it's a vague one.

# #1. 5-Number Summary (+ Mean)
summary(pollution$pm25)

# Median is under the standard.
# Maximum is over, so some counties violate the standard.

# #2. Boxplot.
boxplot(pollution$pm25, col = "blue")

# #3. Histogram.
hist(pollution$pm25, col = "green")
rug(pollution$pm25) # Rug is a cool new thing I didn't know.

# Play with the breaks until you like the histogram.
hist(pollution$pm25, col = "green", breaks = 100)
rug(pollution$pm25) # Rug is a cool new thing I didn't know.

# Overlaying features.
# Here, include the EPA standard maximum of 12.
boxplot(pollution$pm25, col = "blue")
abline(h = 12)

# Here add a vertical line at 12 to see the EPA max.
# Add another line at the median, since a histogram doesn't have
# that feature.
hist(pollution$pm25, col = "green")
abline(v = 12, lwd = 2)
abline(v = median(pollution$pm25), col = "magenta", lwd = 4)

# #4. Bar plot.
# Categorical data. Remember the distinction, which you *forgot*.
# A histogram buckets a numerical variable, a bar plot counts frequency of
# a categorical variable.
# Note the contingency table passed in the 1st argument to obtain frequency.
barplot(table(pollution$region), col = "wheat", main = "Number of Counties in Each Region")
