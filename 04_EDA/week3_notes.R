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

## K-means clustering

# * A partioning approach
# * Fix a number of clusters
# * Get "centroids" of each cluster
# * Assign things to closest centroid
# * Reclaculate centroids
# * Requires
# * A defined distance metric
# * A number of clusters
# * An initial guess as to cluster centroids
# * Produces
# * Final estimate of cluster centroids
# * An assignment of each point to clusters

## K-means clustering -  example

set.seed(1234); par(mar=c(0,0,0,0))
x <- rnorm(12,mean=rep(1:3,each=4),sd=0.2)
y <- rnorm(12,mean=rep(c(1,2,1),each=4),sd=0.2)
plot(x,y,col="blue",pch=19,cex=2)
text(x+0.05,y+0.05,labels=as.character(1:12))

## K-means clustering -  starting centroids
par(mar=rep(0.2,4))
plot(x,y,col="blue",pch=19,cex=2)
text(x+0.05,y+0.05,labels=as.character(1:12))
cx <- c(1,1.8,2.5)
cy <- c(2,1,1.5)
points(cx,cy,col=c("red","orange","purple"),pch=3,cex=2,lwd=2)

## K-means clustering -  assign to closest centroid
par(mar=rep(0.2,4))
plot(x,y,col="blue",pch=19,cex=2)
cols1 <- c("red","orange","purple")
text(x+0.05,y+0.05,labels=as.character(1:12))
cx <- c(1,1.8,2.5)
cy <- c(2,1,1.5)
points(cx,cy,col=cols1,pch=3,cex=2,lwd=2)

## Find the closest centroid
distTmp <- matrix(NA,nrow=3,ncol=12)
distTmp[1,] <- (x-cx[1])^2 + (y-cy[1])^2
distTmp[2,] <- (x-cx[2])^2 + (y-cy[2])^2
distTmp[3,] <- (x-cx[3])^2 + (y-cy[3])^2
newClust <- apply(distTmp,2,which.min)
points(x,y,pch=19,cex=2,col=cols1[newClust])

## K-means clustering -  recalculate centroids
par(mar=rep(0.2,4))
plot(x,y,col="blue",pch=19,cex=2)
cols1 <- c("red","orange","purple")
text(x+0.05,y+0.05,labels=as.character(1:12))

## Find the closest centroid
distTmp <- matrix(NA,nrow=3,ncol=12)
distTmp[1,] <- (x-cx[1])^2 + (y-cy[1])^2
distTmp[2,] <- (x-cx[2])^2 + (y-cy[2])^2
distTmp[3,] <- (x-cx[3])^2 + (y-cy[3])^2
newClust <- apply(distTmp,2,which.min)
points(x,y,pch=19,cex=2,col=cols1[newClust])
newCx <- tapply(x,newClust,mean)
newCy <- tapply(y,newClust,mean)

## Old centroids
cx <- c(1,1.8,2.5)
cy <- c(2,1,1.5)
points(newCx,newCy,col=cols1,pch=3,cex=2,lwd=2)

## K-means clustering -  reassign values
par(mar=rep(0.2,4))
plot(x,y,col="blue",pch=19,cex=2)
cols1 <- c("red","orange","purple")
text(x+0.05,y+0.05,labels=as.character(1:12))
cx <- c(1,1.8,2.5)
cy <- c(2,1,1.5)

## Find the closest centroid
distTmp <- matrix(NA,nrow=3,ncol=12)
distTmp[1,] <- (x-cx[1])^2 + (y-cy[1])^2
distTmp[2,] <- (x-cx[2])^2 + (y-cy[2])^2
distTmp[3,] <- (x-cx[3])^2 + (y-cy[3])^2
newClust <- apply(distTmp,2,which.min)
newCx <- tapply(x,newClust,mean)
newCy <- tapply(y,newClust,mean)

## Old centroids
points(newCx,newCy,col=cols1,pch=3,cex=2,lwd=2)
## Iteration 2
distTmp <- matrix(NA,nrow=3,ncol=12)
distTmp[1,] <- (x-newCx[1])^2 + (y-newCy[1])^2
distTmp[2,] <- (x-newCx[2])^2 + (y-newCy[2])^2
distTmp[3,] <- (x-newCx[3])^2 + (y-newCy[3])^2
newClust2 <- apply(distTmp,2,which.min)
points(x,y,pch=19,cex=2,col=cols1[newClust2])

## K-means clustering -  update centroids
par(mar=rep(0.2,4))
plot(x,y,col="blue",pch=19,cex=2)
cols1 <- c("red","orange","purple")
text(x+0.05,y+0.05,labels=as.character(1:12))
cx <- c(1,1.8,2.5)
cy <- c(2,1,1.5)

## Find the closest centroid
distTmp <- matrix(NA,nrow=3,ncol=12)
distTmp[1,] <- (x-cx[1])^2 + (y-cy[1])^2
distTmp[2,] <- (x-cx[2])^2 + (y-cy[2])^2
distTmp[3,] <- (x-cx[3])^2 + (y-cy[3])^2
newClust <- apply(distTmp,2,which.min)
newCx <- tapply(x,newClust,mean)
newCy <- tapply(y,newClust,mean)

## Iteration 2
distTmp <- matrix(NA,nrow=3,ncol=12)
distTmp[1,] <- (x-newCx[1])^2 + (y-newCy[1])^2
distTmp[2,] <- (x-newCx[2])^2 + (y-newCy[2])^2
distTmp[3,] <- (x-newCx[3])^2 + (y-newCy[3])^2
finalClust <- apply(distTmp,2,which.min)

## Final centroids
finalCx <- tapply(x,finalClust,mean)
finalCy <- tapply(y,finalClust,mean)
points(finalCx,finalCy,col=cols1,pch=3,cex=2,lwd=2)
points(x,y,pch=19,cex=2,col=cols1[finalClust])

## `kmeans()`

# * Important parameters: _x_, _centers_, _iter.max_, _nstart_
dataFrame <- data.frame(x,y)
kmeansObj <- kmeans(dataFrame,centers=3)
names(kmeansObj)
kmeansObj$cluster

## `kmeans()`
par(mar=rep(0.2,4))
plot(x,y,col=kmeansObj$cluster,pch=19,cex=2)
points(kmeansObj$centers,col=1:3,pch=3,cex=3,lwd=3)

## Heatmaps

set.seed(1234)
dataMatrix <- as.matrix(dataFrame)[sample(1:12),]
kmeansObj <- kmeans(dataMatrix,centers=3)
par(mfrow=c(1,2), mar = c(2, 4, 0.1, 0.1))
image(t(dataMatrix)[,nrow(dataMatrix):1],yaxt="n")
image(t(dataMatrix)[,order(kmeansObj$cluster)],yaxt="n")

## Heatmaps
set.seed(1234)
dataMatrix <- as.matrix(dataFrame)[sample(1:12),]
kmeansObj <- kmeans(dataMatrix,centers=3)
par(mfrow=c(1,2), mar = c(2, 4, 0.1, 0.1))
image(t(dataMatrix)[,nrow(dataMatrix):1],yaxt="n")
image(t(dataMatrix)[,order(kmeansObj$cluster)],yaxt="n")

## Notes and further resources

# * K-means requires a number of clusters
# * Pick by eye/intuition
# * Pick by cross validation/information theory, etc.
# * [Determining the number of clusters](http://en.wikipedia.org/wiki/Determining_the_number_of_clusters_in_a_data_set)
# * K-means is not deterministic
# * Different # of clusters 
# * Different number of iterations
# * [Rafael Irizarry's Distances and Clustering Video](http://www.youtube.com/watch?v=wQhVWUcXM0A)
# * [Elements of statistical learning](http://www-stat.stanford.edu/~tibs/ElemStatLearn/)

# Principal Components Analysis and Dimension Reduction

## Matrix data 

set.seed(12345); par(mar=rep(0.2,4))
dataMatrix <- matrix(rnorm(400),nrow=40)
image(1:10,1:40,t(dataMatrix)[,nrow(dataMatrix):1])


## Cluster the data 
par(mar=rep(0.2,4))
heatmap(dataMatrix)

## What if we add a pattern?
set.seed(678910)
for(i in 1:40){
        # flip a coin
        coinFlip <- rbinom(1,size=1,prob=0.5)
        # if coin is heads add a common pattern to that row
        if(coinFlip){
                dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,3),each=5)
        }
}

## What if we add a pattern? - the data
par(mar=rep(0.2,4))
image(1:10,1:40,t(dataMatrix)[,nrow(dataMatrix):1])

## What if we add a pattern? - the clustered data
par(mar=rep(0.2,4))
heatmap(dataMatrix)

## Patterns in rows and columns
hh <- hclust(dist(dataMatrix)); dataMatrixOrdered <- dataMatrix[hh$order,]
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(rowMeans(dataMatrixOrdered),40:1,,xlab="Row Mean",ylab="Row",pch=19)
plot(colMeans(dataMatrixOrdered),xlab="Column",ylab="Column Mean",pch=19)

## Related problems

# You have multivariate variables $X_1,\ldots,X_n$ so $X_1 = (X_{11},\ldots,X_{1m})$
#         
#         * Find a new set of multivariate variables that are uncorrelated and explain as much variance as possible.
# * If you put all the variables together in one matrix, find the best matrix created with fewer variables (lower rank) that explains the original data.
# 
# 
# The first goal is <font color="#330066">statistical</font> and the second goal is <font color="#993300">data compression</font>.


## Related solutions - PCA/SVD
# __SVD__
# 
# If $X$ is a matrix with each variable in a column and each observation in a row then the SVD is a "matrix decomposition"
# 
# $$ X = UDV^T$$
#         
#         where the columns of $U$ are orthogonal (left singular vectors), the columns of $V$ are orthogonal (right singular vectors) and $D$ is a diagonal matrix (singular values). 
# 
# __PCA__
# 
# The principal components are equal to the right singular values if you first scale (subtract the mean, divide by the standard deviation) the variables.

## Components of the SVD - $u$ and $v$

```{r dependson ="oChunk",fig.height=4,fig.width=12}
svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(svd1$u[,1],40:1,,xlab="Row",ylab="First left singular vector",pch=19)
plot(svd1$v[,1],xlab="Column",ylab="First right singular vector",pch=19)
```



## Components of the SVD - Variance explained

```{r dependson ="oChunk",fig.height=5,fig.width=10}
par(mfrow=c(1,2))
plot(svd1$d,xlab="Column",ylab="Singular value",pch=19)
plot(svd1$d^2/sum(svd1$d^2),xlab="Column",ylab="Prop. of variance explained",pch=19)
```



## Relationship to principal components

```{r dependson ="oChunk",fig.height=5,fig.width=5}
svd1 <- svd(scale(dataMatrixOrdered))
pca1 <- prcomp(dataMatrixOrdered,scale=TRUE)
plot(pca1$rotation[,1],svd1$v[,1],pch=19,xlab="Principal Component 1",ylab="Right Singular Vector 1")
abline(c(0,1))
```


## Components of the SVD - variance explained

```{r dependson ="oChunk",fig.height=4,fig.width=12,tidy=FALSE}
constantMatrix <- dataMatrixOrdered*0
for(i in 1:dim(dataMatrixOrdered)[1]){constantMatrix[i,] <- rep(c(0,1),each=5)}
svd1 <- svd(constantMatrix)
par(mfrow=c(1,3))
image(t(constantMatrix)[,nrow(constantMatrix):1])
plot(svd1$d,xlab="Column",ylab="Singular value",pch=19)
plot(svd1$d^2/sum(svd1$d^2),xlab="Column",ylab="Prop. of variance explained",pch=19)
```



## What if we add a second pattern?

```{r twoPattern, dependson ="randomData",fig.height=4,fig.width=3}
set.seed(678910)
for(i in 1:40){
        # flip a coin
        coinFlip1 <- rbinom(1,size=1,prob=0.5)
        coinFlip2 <- rbinom(1,size=1,prob=0.5)
        # if coin is heads add a common pattern to that row
        if(coinFlip1){
                dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,5),each=5)
        }
        if(coinFlip2){
                dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,5),5)
        }
}
hh <- hclust(dist(dataMatrix)); dataMatrixOrdered <- dataMatrix[hh$order,]
```


## Singular value decomposition - true patterns 

```{r  dependson ="twoPattern",fig.height=4.5,fig.width=12}
svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(rep(c(0,1),each=5),pch=19,xlab="Column",ylab="Pattern 1")
plot(rep(c(0,1),5),pch=19,xlab="Column",ylab="Pattern 2")
```


##  $v$ and patterns of variance in rows

```{r  dependson ="twoPattern",fig.height=4.5,fig.width=12}
svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(svd2$v[,1],pch=19,xlab="Column",ylab="First right singular vector")
plot(svd2$v[,2],pch=19,xlab="Column",ylab="Second right singular vector")
```



##  $d$ and variance explained

```{r dependson ="twoPattern",fig.height=4,fig.width=8}
svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,2))
plot(svd1$d,xlab="Column",ylab="Singular value",pch=19)
plot(svd1$d^2/sum(svd1$d^2),xlab="Column",ylab="Percent of variance explained",pch=19)
```


## Missing values

```{r,dependson="twoPattern",error=TRUE}
dataMatrix2 <- dataMatrixOrdered
## Randomly insert some missing data
dataMatrix2[sample(1:100,size=40,replace=FALSE)] <- NA
svd1 <- svd(scale(dataMatrix2))  ## Doesn't work!
```



## Imputing {impute}

```{r,dependson="twoPattern",fig.height=4,fig.width=8,tidy=FALSE}
library(impute)  ## Available from http://bioconductor.org
dataMatrix2 <- dataMatrixOrdered
dataMatrix2[sample(1:100,size=40,replace=FALSE)] <- NA
dataMatrix2 <- impute.knn(dataMatrix2)$data
svd1 <- svd(scale(dataMatrixOrdered)); svd2 <- svd(scale(dataMatrix2))
par(mfrow=c(1,2)); plot(svd1$v[,1],pch=19); plot(svd2$v[,1],pch=19)
```




## Face example

<!-- ## source("http://dl.dropbox.com/u/7710864/courseraPublic/myplclust.R") -->
        
        ```{r loadFaceData ,fig.height=6,fig.width=6}
load("data/face.rda")
image(t(faceData)[,nrow(faceData):1])
```



## Face example - variance explained

```{r,dependson="loadFaceData",fig.height=5,fig.width=6}
svd1 <- svd(scale(faceData))
plot(svd1$d^2/sum(svd1$d^2),pch=19,xlab="Singular vector",ylab="Variance explained")
```


## Face example - create approximations

```{r approximations,dependson="loadFaceData",fig.height=4,fig.width=4}
svd1 <- svd(scale(faceData))
## Note that %*% is matrix multiplication
# Here svd1$d[1] is a constant
approx1 <- svd1$u[,1] %*% t(svd1$v[,1]) * svd1$d[1]
# In these examples we need to make the diagonal matrix out of d
approx5 <- svd1$u[,1:5] %*% diag(svd1$d[1:5])%*% t(svd1$v[,1:5]) 
approx10 <- svd1$u[,1:10] %*% diag(svd1$d[1:10])%*% t(svd1$v[,1:10]) 
```


## Face example - plot approximations
```{r dependson="approximations",fig.height=4,fig.width=14}
par(mfrow=c(1,4))
image(t(approx1)[,nrow(approx1):1], main = "(a)")
image(t(approx5)[,nrow(approx5):1], main = "(b)")
image(t(approx10)[,nrow(approx10):1], main = "(c)")
image(t(faceData)[,nrow(faceData):1], main = "(d)")  ## Original data
```



## Notes and further resources

* Scale matters
* PC's/SV's may mix real patterns
* Can be computationally intensive
* [Advanced data analysis from an elementary point of view](http://www.stat.cmu.edu/~cshalizi/ADAfaEPoV/ADAfaEPoV.pdf)
* [Elements of statistical learning](http://www-stat.stanford.edu/~tibs/ElemStatLearn/)
* Alternatives
* [Factor analysis](http://en.wikipedia.org/wiki/Factor_analysis)
* [Independent components analysis](http://en.wikipedia.org/wiki/Independent_component_analysis)
* [Latent semantic analysis](http://en.wikipedia.org/wiki/Latent_semantic_analysis)

# Color
## Plotting and Color
# - The default color schemes for most plots in R are horrendous
# - I don’t have good taste and even I know that
# - Recently there have been developments to improve the handling/specifica1on of colors in plots/graphs/etc.
# - There are functions in R and in external packages that are very handy


## Colors 1, 2, and 3

# ![graph1.png](../assets/img/graph1.png)


## Default Image Plots in R

# ![graph2.png](../assets/img/graph2.png)


## Color U1li1es in R

# - The `grDevices` package has two functions 
# - `colorRamp`
# - `colorRampPalette`
# - These functions take palettes of colors and help to interpolate between the colors
# - The function colors() lists the names of colors you can use in any plotting function


## Color Palette Utilities in R

# - `colorRamp`: Take a palette of colors and return a function that takes valeus between 0 and 1, indicating the extremes of the color palette (e.g. see the 'gray' function)
# - `colorRampPalette`: Take a palette of colors and return a function that takes integer arguments and returns a vector of colors interpolating the palette (like `heat.colors` or `topo.colors`)


## colorRamp

# `[,1] [,2] [,3]` corresponds to `[Red] [Blue] [Green]`

pal <- colorRamp(c("red", "blue"))
pal(0)
pal(1)
pal(0.5)

## colorRamp
pal(seq(0, 1, len = 10))

## colorRampPalette
pal <- colorRampPalette(c("red", "yellow"))
pal(2)
pal(10)

## RColorBrewer Package
# -  One package on CRAN that contains interes1ng/useful color palettes
# - There are 3 types of palettes
# - Sequential
# - Diverging
# - Qualitative
# - Palette informa1on can be used in conjunction with the `colorRamp()` and `colorRampPalette()`
# ![color.png](../assets/img/color.png)

## RColorBrewer and colorRampPalette
library(RColorBrewer)
cols <- brewer.pal(3, "BuGn")
cols
pal <- colorRampPalette(cols)
image(volcano, col = pal(20))

## RColorBrewer and colorRampPalette
# ![color2.png](../assets/img/color2.png)

## The smoothScatter function
# ![color3.png](../assets/img/color3.png)

## Some other plotting notes
# - The `rgb` function can be used to produce any color via red, green, blue proportions
# - Color transparency can be added via the `alpha` parameter to `rgb`
# - The `colorspace` package can be used for a different control over colors

## Scatterplot with no transparency
# ![scatter1.png](../assets/img/scatter1.png)

## Scatterplot with transparency
# ![scatter2.png](../assets/img/scatter2.png)

## Summary
# - Careful use of colors in plots/maps/etc. can make it easier for the reader to get what you're trying to say (why make it harder?)
# - The `RColorBrewer` package is an R package that provides color palettes for sequential, categorical, and diverging data
# - The `colorRamp` and `colorRampPalette` functions can be used in conjunction with color palettes to connect data to colors
# - Transparency can sometimes be used to clarify plots with many points