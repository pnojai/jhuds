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

# myclust example
# https://github.com/DataScienceSpecialization/Exploratory_Data_Analysis/blob/master/clusteringExample/myplclust.R

myplclust <- function( hclust, lab=hclust$labels, lab.col=rep(1,length(hclust$labels)), hang=0.1,...){
        ## modifiction of plclust for plotting hclust objects *in colour*!
        ## Copyright Eva KF Chan 2009
        ## Arguments:
        ##    hclust:    hclust object
        ##    lab:        a character vector of labels of the leaves of the tree
        ##    lab.col:    colour for the labels; NA=default device foreground colour
        ##    hang:     as in hclust & plclust
        ## Side effect:
        ##    A display of hierarchical cluster with coloured leaf labels.
        y <- rep(hclust$height,2)
        x <- as.numeric(hclust$merge)
        y <- y[which(x<0)]
        x <- x[which(x<0)]
        x <- abs(x)
        y <- y[order(x)]
        x <- x[order(x)]
        plot( hclust, labels=FALSE, hang=hang, ... )
        text( x=x, y=y[hclust$order]-(max(hclust$height)*hang), labels=lab[hclust$order], col=lab.col[hclust$order], srt=90, adj=c(1,0.5), xpd=NA, ... )}

# Pretty dendrograms
dataFrame <- data.frame(x=x,y=y)
distxy <- dist(dataFrame)
hClustering <- hclust(distxy)
myplclust(hClustering,lab=rep(1:3,each=4),lab.col=rep(1:3,each=4))

# Even prettier
# Links are broken.

# Merging points
#   Average linkage. Centers of gravity.
#   Complete linkage. Furthest points.

# Heat map
# Visualizing matrix data.
# Large table, large matrix similarly scaled.
# Hierarchical cluster analysis on row and columns.
dataFrame <- data.frame(x=x,y=y)
set.seed(143)
dataMatrix <- as.matrix(dataFrame)[sample(1:12), ]
heatmap(dataMatrix)

## Notes and further resources

# * Gives an idea of the relationships between variables/observations
# * The picture may be unstable
# * Change a few points
# * Have different missing values
# * Pick a different distance
# * Change the merging strategy
# * Change the scale of points for one variable
# * But it is deterministic
# * Choosing where to cut isn't always obvious
# * Should be primarily used for exploration 
# * [Rafa's Distances and Clustering Video](http://www.youtube.com/watch?v=wQhVWUcXM0A)
# * [Elements of statistical learning](http://www-stat.stanford.edu/~tibs/ElemStatLearn/)

# Best use of cluster analysis is exploring, looking for patterns.