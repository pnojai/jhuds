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
# Two phases: initialize, annotate.
# Calling plot(x, y) or hist(x) launches a graphics device if one is not already open draws a new
# plot on the device.
# Memorize ?par.

library(datasets)
hist(airquality$Ozone) ## Draw a new plot. 1-D
# Scatter plot.
library(datasets)
with(airquality, plot(Wind, Ozone)) # 2-D

# The transform help page discourages its use.
airquality <- transform(airquality, Month = factor(Month))
# Formula notation. Remember, y ~ x. x is a categorigal variable, transformed to a factor here.
par(bg = "linen")
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)")

# Base graphic parameters.
# pch. Plot character. Number input refers to a table of symbols, or you can give it a character.
# lty. Line type.
# lwd. Line width.
# col. Number, string, or hex. colors() lists the choices.
# xlab.
# ylab.

# Global parameters. par().
# You can override many within the plotting function call.
# las. Orientation of axis labels.
# bg. Background color.
par(bg = "linen")
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)")
# mar. Margin size.
# oma. Outer margin (not grandmother).
# mfrow. Number of plots per row, column (plots are filled row-wise).
# mfcol. Number of plots per row, column (plots are filled column-wise).

# Base plotting functions.
# plot. Depends on class of object being plotted.
# lines. Annotation. Adds lines. Give it a vector of x and a vector of y. Connects the dots.
# points. Annotation. Adds points.
# text. Annotation. Adds labels within the plot at given coordinates (x, y).
# title. Annotates axis labels, title, subtitle, outer margin, etc.
# mtext. Text on inner or outer margins.
# axis. Ticks.

with(airquality, plot(Wind, Ozone))
title(main = "Ozone and Wind in New York City")

# You can overwrite and change the color of points.
# Here the main title is brought into the plot function call.
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))

# Base plot with Annotation
# Initialize to null type. Opens the graphic device, but doesn't plot anything yet.
data("airquality")
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", type = "n"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red"))
legend("topright", pch = 1, col = c("blue", "red"), legend = c("May", "Other Months"))

# Base plot with Regression Line
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City",
                      pch = 20))
model <- lm(Ozone ~ Wind, airquality) # Intercept and slope.
abline(model, lwd = 2) # abline can plot intercept and slope.

# Multiple base plots.
# Note braces to block multiple plots.
par(mfrow = c(1, 2))
with(airquality, {
        plot(Wind, Ozone, main = "Ozone and Wind")
        plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
})

# You don't have to enclose the multiple plots in braces, but they save you
# having to code with() twice.
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind"))
with(airquality, plot(Solar.R, Ozone, main = "Ozone and Solar Radiation"))

# Multiple base plots.
# Title in outer margin.
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

with(airquality, {
        plot(Wind, Ozone, main = "Ozone and Wind")
        plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
        plot(Temp, Ozone, main = "Ozone and Solar Radiation")
        mtext("Ozone and Weather in New York City", outer = TRUE)
})

# Base plotting demonstration.
x <- rnorm(100)
hist(x)
y <- rnorm(100)
plot(x, y)
z <- rnorm(100)
plot(x, z)
plot(x, y)
par(mar = c(2, 2, 2, 2))
plot(x, y)
par(mar = c(4, 4, 2, 2))
plot(x, y)
plot(x, y, pch = 20)
plot(x, y, pch = 19)
plot(x, y, pch = 2)
plot(x, y, pch = 3)
plot(x, y, pch = 4)
example(points)

x <- rnorm(100)
y <- rnorm(100)

plot(x, y, pch = 20)
title("Scatter Plot")
text(-2, -2, "label")
legend("topleft", legend = "Data")
legend("topleft", legend = "Data", pch = 20)
fit = lm(y ~ x)
abline(fit)
abline(fit, lwd = 3)
abline(fit, lwd = 3, col = "blue")
plot(x, y, xlab = "Height", ylab = "Weight", main = "Scatter Plot", pch = 20)
legend("topright", legend = "Data", pch = 20)
fit = lm(y ~ x)
abline(fit, lwd = 2, col = "red")

z <- rpois(100, 2)
par(mfrow =c(2, 1))
plot(x, y, pch = 20)
plot(x, z, pch = 19)
par("mar")
par(mar = c(2, 10, 1, 10))
plot(x, y, pch = 20)
plot(x, z, pch = 19)
par(mfrow = c(1, 2))
par(mar = c(4, 4, 2, 2))
plot(x, y, pch = 20)
plot(x, z, pch = 19)

par(mfrow = c(2, 2))
plot(x, y, pch = 20)
plot(x, z, pch = 19)
plot(z, x, pch = 20)
plot(y, x, pch = 19)

par(mfcol = c(2, 2))
plot(x, y, pch = 20)
plot(x, z, pch = 19)
plot(z, x, pch = 20)
plot(y, x, pch = 19)

# Subsetting by a grouping variable is very common in plotting.
# Points function can build up data by group, letting you change properties
# for each group.
par(mfrow = c(1, 1))
x <- rnorm(100)
y <- x + rnorm(100)
g <- gl(2, 50, labels = c("Male", "Female"))
g
str(g)
plot(x, y)

# Open the region, but don't plot yet. Then add by gender.
plot(x, y, type = "n")
points(x[g == "Male"], y[g == "Male"], col = "green")
points(x[g == "Female"], y[g == "Female"], col = "blue", pch = 19)

# Graphics devices in R.
#   A window, to screen.
#   PDF, file device.
#   PNG or JPEG, file device.
#   Scalable vector graphic, SVG, file device.

# Most common is screen.
#   Mac: quartz().
#   Windows: windows().
#   Linux: x11().

# Full list of graphics devices.
?Devices

# Creating a plot.
# You know screen already.
# File devices.
# 1. Launch a graphics device.
# 2. Call plotting function.
# 3. Annotate as needed.
# 4. Explicitly close the graphics device with def.off(). This is very important.

pdf("04_EDA/Data/myplot.pdf")
with(faithful, plot(eruptions, waiting))
title(main = "Old Faithful Geyser Data")
dev.off() # Device off. Now you can view the file.

# I love that!

# Two file devices: vector and bitmap.
# Vector formats:
#   Resize well since they render with vector formats.
#   pdf: useful for line-type graphics, resizes well, usually portable, inefficient if plot has
#        many objects, points.
#   svg: popular for web-based plots, supports animation and interactivity, almost all browsers
#        recognize it, XML-based scalable vector graphics.
#   win.metafile: Only available on Windows.
#   postscript: older format, scales well, usually portable although Windows often lacks a postscript
#               viewer.
# Bitmap formats:
#   Represents plots as a series of pixels. Don't resize.
#   png: Portable Network Graphics, good for line drawings and solid colors, uses lossless compression,
#        like GIF, most browsers can read it, good for plotting many points, does not resize well.
#   jpeg: good for gradient colors, natural images, not great for line drawings as they alias,
#         does not resize well.
#   tiff:
#   bmp: Windows.

# Multiple Open Devices.
# Currently active: dev.cur(). Returns an integer 2+.
# Change device with dev.set().

# Copying Plots.
# You can create a plot on the screen, then send it to a file.
# 1. After you saved code, open the file device, copy and paste the code, close the device.
# 2. Copy it from the screen device to the file device.
#    dev.copy().
#    dev.copy2pdf().

library(datasets)
with(faithful, plot(eruptions, waiting))
title(main = "Old Faithful Geyser Data")
dev.copy(png, file = "04_EDA/Data/geyserplot.png")
dev.off() # Don't forget! (Like you just did)
