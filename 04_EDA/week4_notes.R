# Clustering case study.
# Samsung smart phone

## Samsung Galaxy S3
## Samsung Data
# [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
## Slightly processed data
#[Samsung data file]("https://dl.dropboxusercontent.com/u/7710864/courseraPublic/samsungData.rda")
#
# Got this from the course website on GitHub and copied into my directory.

load("./04_EDA/data/samsungData.rda")
names(samsungData)[1:12]
table(samsungData$activity)

library(dplyr)

select(samsungData)
has_dupe_col <- grep("fBodyAcc\\-bandsEnergy\\(\\)\\-1,8", names(samsungData))
names(samsungData)[has_dupe_col]

names_freq <- as.data.frame(table(names(samsungData)))
names_freq[names_freq$Freq > 1, ]

## Plotting average acceleration for first subject
par(mfrow=c(1, 2), mar = c(5, 4, 1, 1))
samsungData <- transform(samsungData, activity = factor(activity))
sub1 <- subset(samsungData, subject == 1)
plot(sub1[, 1], col = sub1$activity, ylab = names(sub1)[1])
plot(sub1[, 2], col = sub1$activity, ylab = names(sub1)[2])
legend("bottomright",legend=unique(sub1$activity),col=unique(sub1$activity), pch = 1)

        ## Clustering based just on average acceleration
        
        <!-- ## source("http://dl.dropbox.com/u/7710864/courseraPublic/myplclust.R")  -->
        
        
        ```{r dependson="processData",fig.height=5,fig.width=8}
source("myplclust.R")
distanceMatrix <- dist(sub1[,1:3])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering, lab.col = unclass(sub1$activity))
```


---
        
        ## Plotting max acceleration for the first subject
        
        ```{r ,dependson="processData",fig.height=5,fig.width=10}
par(mfrow=c(1,2))
plot(sub1[,10],pch=19,col=sub1$activity,ylab=names(sub1)[10])
plot(sub1[,11],pch=19,col = sub1$activity,ylab=names(sub1)[11])
```

---
        
        ## Clustering based on maximum acceleration
        
        ```{r dependson="processData",fig.height=5,fig.width=10}
source("myplclust.R")
distanceMatrix <- dist(sub1[,10:12])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering,lab.col=unclass(sub1$activity))
```



---
        
        ## Singular Value Decomposition
        
        ```{r svdChunk,dependson="processData",fig.height=5,fig.width=10,cache=TRUE,tidy=TRUE}
svd1 = svd(scale(sub1[,-c(562,563)]))
par(mfrow=c(1,2))
plot(svd1$u[,1],col=sub1$activity,pch=19)
plot(svd1$u[,2],col=sub1$activity,pch=19)
```

---
        
        ## Find maximum contributor
        
        ```{r dependson="svdChunk",fig.height=5,fig.width=6,cache=TRUE,tidy=TRUE}
plot(svd1$v[,2],pch=19)
```


---
        
        ##  New clustering with maximum contributer
        
        ```{r dependson="svdChunk",fig.height=5,fig.width=8,cache=TRUE,tidy=TRUE}
maxContrib <- which.max(svd1$v[,2])
distanceMatrix <- dist(sub1[, c(10:12,maxContrib)])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering,lab.col=unclass(sub1$activity))                             
```


---
        
        ##  New clustering with maximum contributer
        
        ```{r dependson="svdChunk",fig.height=4.5,fig.width=4.5,cache=TRUE}
names(samsungData)[maxContrib]                          
```

---
        
        ##  K-means clustering (nstart=1, first try)
        
        ```{r kmeans1,dependson="processData",fig.height=4,fig.width=4}
kClust <- kmeans(sub1[,-c(562,563)],centers=6)
table(kClust$cluster,sub1$activity)
```



---
        
        ##  K-means clustering (nstart=1, second try)
        
        ```{r dependson="kmeans1",fig.height=4,fig.width=4,cache=TRUE,tidy=TRUE}
kClust <- kmeans(sub1[,-c(562,563)],centers=6,nstart=1)
table(kClust$cluster,sub1$activity)
```


---
        
        ##  K-means clustering (nstart=100, first try)
        
        ```{r dependson="kmeans1",fig.height=4,fig.width=4,cache=TRUE}
kClust <- kmeans(sub1[,-c(562,563)],centers=6,nstart=100)
table(kClust$cluster,sub1$activity)
```



---
        
        ##  K-means clustering (nstart=100, second try)
        
        ```{r kmeans100,dependson="kmeans1",fig.height=4,fig.width=4,cache=TRUE,tidy=TRUE}
kClust <- kmeans(sub1[,-c(562,563)],centers=6,nstart=100)
table(kClust$cluster,sub1$activity)
```

---
        
        ##  Cluster 1 Variable Centers (Laying)
        
        ```{r dependson="kmeans100",fig.height=4,fig.width=8,cache=FALSE,tidy=TRUE}
plot(kClust$center[1,1:10],pch=19,ylab="Cluster Center",xlab="")
```


---
        
        ##  Cluster 2 Variable Centers (Walking)
        
        ```{r dependson="kmeans100",fig.height=4,fig.width=8,cache=FALSE}
plot(kClust$center[4,1:10],pch=19,ylab="Cluster Center",xlab="")
```

# Air pollution case study
setwd("/media/sf_Computing/DataScience/Coursera/JohnsHopkins/jhuds/04_EDA/Data/pm25_data")
# EPA website
# Moved around. Use the course website, which I also cloned.
# https://github.com/DataScienceSpecialization/courses/tree/master/04_ExploratoryAnalysis/CaseStudy

## Has fine particle pollution in the U.S. decreased from 1999 to
## 2012?

## Read in data from 1999

pm0 <- read.table("RD_501_88101_1999-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "")
dim(pm0)
head(pm0)
cnames <- readLines("RD_501_88101_1999-0.txt", 1)
print(cnames)
cnames <- strsplit(cnames, "|", fixed = TRUE)
print(cnames)
names(pm0) <- make.names(cnames[[1]])
head(pm0)
x0 <- pm0$Sample.Value
class(x0)
str(x0)
summary(x0)
mean(is.na(x0))  ## Are missing values important here?

## Read in data from 2012

pm1 <- read.table("RD_501_88101_2012-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "", nrow = 1304290)
names(pm1) <- make.names(cnames[[1]])
head(pm1)
dim(pm1)
x1 <- pm1$Sample.Value
class(x1)

## Five number summaries for both periods
summary(x1)
summary(x0)
mean(is.na(x1))  ## Are missing values important here?

## Make a boxplot of both 1999 and 2012
boxplot(x0, x1)
boxplot(log10(x0), log10(x1))

## Check negative values in 'x1'
summary(x1)
negative <- x1 < 0
sum(negative, na.rm = T)
mean(negative, na.rm = T)
dates <- pm1$Date
str(dates)
dates <- as.Date(as.character(dates), "%Y%m%d")
str(dates)
hist(dates, "month")  ## Check what's going on in months 1--6
hist(dates[negative], "month")

## Plot a subset for one monitor at both times

## Find a monitor for New York State that exists in both datasets
site0 <- unique(subset(pm0, State.Code == 36, c(County.Code, Site.ID)))
site1 <- unique(subset(pm1, State.Code == 36, c(County.Code, Site.ID)))
site0 <- paste(site0[,1], site0[,2], sep = ".")
site1 <- paste(site1[,1], site1[,2], sep = ".")
str(site0)
str(site1)
both <- intersect(site0, site1)
print(both)

## Find how many observations available at each monitor
pm0$county.site <- with(pm0, paste(County.Code, Site.ID, sep = "."))
pm1$county.site <- with(pm1, paste(County.Code, Site.ID, sep = "."))
cnt0 <- subset(pm0, State.Code == 36 & county.site %in% both)
cnt1 <- subset(pm1, State.Code == 36 & county.site %in% both)
head(cnt0)
class(split(cnt0, cnt0$county.site))
str(split(cnt0, cnt0$county.site))

sapply(split(cnt0, cnt0$county.site), nrow)
sapply(split(cnt1, cnt1$county.site), nrow)

## Choose county 63 and side ID 2008
pm1sub <- subset(pm1, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
pm0sub <- subset(pm0, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
dim(pm1sub)
dim(pm0sub)

## Plot data for 2012
dates1 <- pm1sub$Date
x1sub <- pm1sub$Sample.Value
plot(dates1, x1sub)
dates1 <- as.Date(as.character(dates1), "%Y%m%d")
str(dates1)
plot(dates1, x1sub)

## Plot data for 1999
dates0 <- pm0sub$Date
dates0 <- as.Date(as.character(dates0), "%Y%m%d")
x0sub <- pm0sub$Sample.Value
plot(dates0, x0sub)

## Plot data for both years in same panel
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
plot(dates0, x0sub, pch = 20)
abline(h = median(x0sub, na.rm = T))
plot(dates1, x1sub, pch = 20)  ## Whoa! Different ranges
abline(h = median(x1sub, na.rm = T))

## Find global range
rng <- range(x0sub, x1sub, na.rm = T)
rng
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
plot(dates0, x0sub, pch = 20, ylim = rng)
abline(h = median(x0sub, na.rm = T))
plot(dates1, x1sub, pch = 20, ylim = rng)
abline(h = median(x1sub, na.rm = T))

## Show state-wide means and make a plot showing trend
head(pm0)
mn0 <- with(pm0, tapply(Sample.Value, State.Code, mean, na.rm = T))
str(mn0)
summary(mn0)
mn1 <- with(pm1, tapply(Sample.Value, State.Code, mean, na.rm = T))
summary(mn1)
str(mn1)

## Make separate data frames for states / years
d0 <- data.frame(state = names(mn0), mean = mn0)
d1 <- data.frame(state = names(mn1), mean = mn1)
mrg <- merge(d0, d1, by = "state")
dim(mrg)
head(mrg)

## Connect lines
par(mfrow = c(1, 1))
with(mrg, plot(rep(1, 52), mrg[, 2], xlim = c(.5, 2.5)))
with(mrg, points(rep(2, 52), mrg[, 3]))
segments(rep(1, 52), mrg[, 2], rep(2, 52), mrg[, 3])
