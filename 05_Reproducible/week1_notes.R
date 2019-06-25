##        title       : Structure of a Data Analysis 
## Steps in a data analysis

# * Define the question
# * Define the ideal data set
# * Determine what data you can access
# * Obtain the data
# * Clean the data
# * Exploratory data analysis
# * Statistical prediction/modeling
# * Interpret results
# * Challenge results
# * Synthesize/write up results
# * Create reproducible code

## Our data set
# [http://search.r-project.org/library/kernlab/html/spam.html](http://search.r-project.org/library/kernlab/html/spam.html)

## Subsampling our data set
library(kernlab)
data(spam)
# Perform the subsampling
set.seed(3435)
trainIndicator = rbinom(4601,size=1,prob=0.5)
table(trainIndicator)
trainSpam = spam[trainIndicator==1,]
testSpam = spam[trainIndicator==0,]

## Exploratory data analysis

# * Look at summaries of the data
# * Check for missing data
# * Create exploratory plots
# * Perform exploratory analyses (e.g. clustering)

## Names
names(trainSpam)

## Head
head(trainSpam)

## Summaries
table(trainSpam$type)

## Plots
plot(trainSpam$capitalAve ~ trainSpam$type)

## Plots 
plot(log10(trainSpam$capitalAve + 1) ~ trainSpam$type)

## Relationships between predictors
plot(log10(trainSpam[,1:4]+1))

## Clustering
par(mar=c(0,0,0,0))

hCluster = hclust(dist(t(trainSpam[,1:57])))
plot(hCluster)

## New clustering
hClusterUpdated = hclust(dist(t(log10(trainSpam[,1:55]+1))))
plot(hClusterUpdated)

## Statistical prediction/modeling
# * Should be informed by the results of your exploratory analysis
# * Exact methods depend on the question of interest
# * Transformations/processing should be accounted for when necessary
# * Measures of uncertainty should be reported

## Statistical prediction/modeling
trainSpam$numType = as.numeric(trainSpam$type)-1
costFunction = function(x,y) sum(x!=(y > 0.5)) 
cvError = rep(NA,55)
library(boot)
for(i in 1:55){
        lmFormula = reformulate(names(trainSpam)[i], response = "numType")
        glmFit = glm(lmFormula,family="binomial",data=trainSpam)
        cvError[i] = cv.glm(trainSpam,glmFit,costFunction,2)$delta[2]
}
## Which predictor has minimum cross-validated error?
names(trainSpam)[which.min(cvError)]

## Get a measure of uncertainty
## Use the best model from the group
predictionModel = glm(numType ~ charDollar,family="binomial",data=trainSpam)
## Get predictions on the test set
predictionTest = predict(predictionModel,testSpam)
predictedSpam = rep("nonspam",dim(testSpam)[1])
## Classify as `spam' for those with prob > 0.5
predictedSpam[predictionModel$fitted > 0.5] = "spam"

## Get a measure of uncertainty
## Classification table
table(predictedSpam,testSpam$type)
## Error rate
(61+458)/(1346+458 + 61 + 449)

## Interpret results
# * Use the appropriate language
# * describes 
# * correlates with/associated with
# * leads to/causes
# * predicts
# * Give an explanation
# * Interpret coefficients
# * Interpret measures of uncertainty

## Our example
# * The fraction of characters that are dollar signs can be used to predict if an email is Spam
# * Anything with more than 6.6% dollar signs is classified as Spam
# * More dollar signs always means more Spam under our prediction
# * Our test set error rate was 22.4% 

## Challenge results
# * Challenge all steps:
# * Question
# * Data source
# * Processing 
# * Analysis 
# * Conclusions
# * Challenge measures of uncertainty
# * Challenge choices of terms to include in models
# * Think of potential alternative analyses 

## Synthesize/write-up results
# * Lead with the question
# * Summarize the analyses into the story 
# * Don't include every analysis, include it
# * If it is needed for the story
# * If it is needed to address a challenge
# * Order analyses according to the story, rather than chronologically
# * Include "pretty" figures that contribute to the story 

## In our example
# * Lead with the question
# * Can I use quantitative characteristics of the emails to classify them as SPAM/HAM?
# * Describe the approach
# * Collected data from UCI -> created training/test sets
# * Explored relationships
# * Choose logistic model on training set by cross validation
# * Applied to test, 78% test set accuracy
# * Interpret results
# * Number of dollar signs seems reasonable, e.g. "Make money with Viagra \\$ \\$ \\$ \\$!"
# * Challenge results
# * 78% isn't that great
# * I could use more variables
# * Why logistic regression?
        
## Create reproducible code

## Organizing a Data Analysis
## Further resources
# * Information about a non-reproducible study that led to cancer patients being mistreated: [The Duke Saga Starter Set](http://simplystatistics.org/2012/02/27/the-duke-saga-starter-set/)
# * [Reproducible research and Biostatistics](http://biostatistics.oxfordjournals.org/content/10/3/405.full)
# * [Managing a statistical analysis project guidelines and best practices](http://www.r-statistics.com/2010/09/managing-a-statistical-analysis-project-guidelines-and-best-practices/)
# * [Project template](http://projecttemplate.net/) - a pre-organized set of files for data analysis
