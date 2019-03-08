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