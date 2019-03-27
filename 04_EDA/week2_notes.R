# Lattice graphing.
library(lattice)
library(datasets)

# Lattice functions:
# xyplot
# bwplot. Box and whiskers, boxplot.
# histogram
# stripplot. Like a boxplot, but with points.
# dotplot. Dots on a violin string.
# splom. Scatter plot matrix. Like pairs in base system.
# levelplot, contourplot. Image data.

# 1st argument generally an R formula.
# xyplot(y ~ x | f * g, data)
# Left of tilde is the y-axis, right, x-axis.
# f, g are conditioning variables. Categorical variables.
# Here, I want to look at the scatter plot of y vs. x on every level of f and g.

xyplot(Ozone ~ Wind, data = airquality)

# Multiple levels

## Convert "Month" to a factor variable.
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5, 1))

# This is nice in Lattice because the levels report from just one line of code. Base would
# have taken more code.

# Sidebar. Lattice functions don't plot, they save to an object of class "trellis" which R
# then autoprints.
p <- xyplot(Ozone ~ Wind, data = airquality)
print(p)

# Lattice panel functions.
# Each panel gets a subset defined by the conditioning variable.

# Generate some random data to look at this.
set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2, 1))

# Custom panel function.
xyplot(y ~ x | f, panel = function(x, y, ...) {
        panel.xyplot(x, y, ...) # First, call the default panel function for xyplot.
        panel.abline(h = median(y), lty = 2) # Add a horizontal line at the median.
                
})

# Custom panel function. Add a regression line.
xyplot(y ~ x | f, panel = function(x, y, ...) {
        panel.xyplot(x, y, ...) # First, call the default panel function for xyplot.
        panel.lmline(x, y, col = 2) # Add a regression line.
})

# ggplot2
# Grammar of Graphics says that a statistical graphic is a mapping from data to aesthetic
# attributes (color, shape, size) of geometric objects (points, lines, bars). The plot may also
# contain statistical transformations of the data and is drawn on a specific coordinate system.

# Basics: qplot. (Quick Plot). Analagous to base system plot().
# Data: always in a data frame.
# Plots made up of aesthetics and geoms.

# Factors are important for indicating subsets. They should be labelled. For example, gender.

# qplot hides details, which is often useful.
# ggplot is the core function and very flexible for doing things qplot cannot.

library(ggplot2)
str(mpg)

qplot(displ, hwy, data = mpg)

# Modifying aesthetics.

qplot(displ, hwy, data = mpg, color = drv)

# Add a statistic. Adding a geom.
# A smoother, or loess.
# The grey region is the 95% confidence interval.
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"))

# qplot plots a histogram if you only provide one variable.
qplot(hwy, data = mpg, fill = drv)

# Facets. Like panels in lattice.
# Takes a formula type parameter. Left of the tilde is number of rows of facets,
# right is number of columns
qplot(displ, hwy, data = mpg, facets = . ~ drv)
qplot(hwy, data = mpg, facets = drv ~ ., binwidth = 2)

# Mouse allergen and asthma cohort study.
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3889705/
# The course has some sample data.
# An R Data file doesn't get assigned to a variable. The variable is in the file, and the
# file gets loaded into the environment.
load(file = "./04_EDA/Data/maacs.Rda")
str(maacs)
# eno: Exhaled Nitric Oxide.
head(maacs)

qplot(log(eno), data = maacs)
qplot(log(eno), data = maacs, fill = mopos)
qplot(log(eno), data = maacs, geom = "density")
qplot(log(eno), data = maacs, geom = "density", color = mopos)

# Is exhaled nitric oxide related to fine particulate matter in the home.
qplot(log(pm25), log(eno), data = maacs)

# Separate the allergic
qplot(log(pm25), log(eno), data = maacs, shape = mopos)
qplot(log(pm25), log(eno), data = maacs, color = mopos)

# Get a linear model in there.
qplot(log(pm25), log(eno), data = maacs, color = mopos) + geom_smooth(method = "lm")

# Let's split them out with facets.
qplot(log(pm25), log(eno), data = maacs, facets = . ~ mopos) + geom_smooth(method = "lm")

# Basic components of a ggplot2 plot.
# Data frame.
# Aesthetic mapping.
# geoms.
# facets. For conditional plots.
# stats.
# scales.
# coordinate system.

# Building plot.
# "Artist's palette."
# Built up in layers.
#   Plot the data.
#   Add a summary.
#   Metadata or annotation.

str(maacs)

# Back to the MAACS.
# This data sample doesn't have bmicat.
qplot(log(pm25), NocturnalSympt, data = maacs, facets = . ~ bmicat,
      geom = c("point", "smooth"), method = "lm")

g <- ggplot(maacs, aes(logpm25, NocturnalSympt)) # initial call to ggplot

summary(g) # you can do this. (If you have real data.)

# No plot yet. 
p <- g + geom_point() # This will print.
# or
g + geom_point()
