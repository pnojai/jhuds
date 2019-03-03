# EXPLORATORY GRAPHS

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

# One-diminsional summaries

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

# Two-dimensional summaries.
# Multiple overlaid 1-D plots (Lattice/ggplot2).
# Scatter plots.
# Smooth scatter plots.

# Greater than two dimensions.
# 3-D. Not that useful.
# Spinning plots.
# Overlaid, multiple 2-D plots. So you can look at 3rd or 4th variable.
# Color, size, and shape of plotting symbols to add dimensions.

# Two dimensions
boxplot(pm25 ~ region, data = pollution, col = "red")

# Multiple histograms
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
hist(subset(pollution, region == "east")$pm25, col = "green")
hist(subset(pollution, region == "west")$pm25, col = "green")

# Scatter plot
# Is there a north-south trend? Plot latitude.
with(pollution, plot(latitude, pm25))
abline(h = 12, lwd = 2, lty = 2)

# Scatter plot with color.
# Add another dimension.
with(pollution, plot(latitude, pm25, col = region))
abline(h = 12, lwd = 2, lty = 2)

# Multiple scatter plots
par(mfrow = c(1, 2), mar = c(5, 4, 2, 1))
with(subset(pollution, region == "west"), plot(latitude, pm25, main = "West"))
with(subset(pollution, region == "east"), plot(latitude, pm25, main = "East"))

# Resources.
# https://www.r-graph-gallery.com
# https://www.r-bloggers.com/

# PLOTTING SYSTEMS
# 1. Base.
# 2. Lattice.
# 3. ggplot2.

# Base.
# Artist's palette. Blank canvas, add things one by one.
# Start with plot function, use annotations to add or modify text, lines, points, axes.
# Can't go back to adjust. This comment I don't understand; difficult to translate, no graphical language.

# Base plot
library(datasets)
data(cars)
with(cars, plot(speed, dist))

# Lattice.
# Very different from Base. Instead of piecing together, plot made from one command.
# Most common command is xyplot. Also, bwplot.
# Most useful for co-plots, conditioning types of plot, looking at how y changes with x across levels of z.
# Sometimes called panel plots, looking at the same thing in every panel but for a different level of a 3rd variable.
# You can even combine variables so you can look at multiple factors
# Good for putting many plots on a screen, so long as you follow this conditioning model.

# Down sides of Lattice.
# Sometimes awkward to put everything in one function call.
# Annotation is unintuitive.
# Use of panels and subscripts is hard.

library(lattice)
state <- data.frame(state.x77, region = state.region)
xyplot(Life.Exp ~ Income | region, data = state, layout = c(4, 1))

# ggplot2.
# Uses Grammar of Graphics.
# Splits difference between Base and Lattice. You can build incrementally like Base, but a lot of aesthetic calculations
# are done for you (spacings and labels in the right place) like Lattice.
# ggplot2 is useful for coplots.

# ggplot2 Plot.
library(ggplot2)
data(mpg)
qplot(displ, hwy, data = mpg)

# BASE PLOTTING SYSTEM IN R.

# Where will the plot be made? On the screen, or sent to a file.
# How will the plot be used
#  Viewing on the screen temporarily.
#  Viewd in a web browser.
#  Printing it in a paper.
#  Is it going to be publication quality, or in a slideshow or presentation.
# Is there a large amount of data in this plot? Or just a few points?
# Is it an image? Or is it a line drawing?
# Do you want to dynamically resize the graphic. You may want to use something like a vector format
# if you are sending it to a file rather than a bit map format. 

# We're focusing on Base to plot to the Screen.
