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