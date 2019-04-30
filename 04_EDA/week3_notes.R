# Heirarchical clustering

# Create sample data.
set.seed(1234)
par(mar = c(0, 0, 0, 0))
x <- rnorm(12, mean = rep(1:3, 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1, 2, 1), 4), sd = 0.2)
plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

# Compute distances with dist() function.
dataFrame <- data.frame(x = x, y = y)
dataFrame

distxy <- dist(dataFrame)
distxy
hClustering <- hclust(distxy)
hClustering
# You can reset par() by removing all plots.
plot(hClustering)
