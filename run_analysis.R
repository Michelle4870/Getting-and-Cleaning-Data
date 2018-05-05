## Load packages
library(dplyr)
library(tidyr)
library(readr)

## Read in the data
subjectrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subjectest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")

## Combine x, y and subject data
xtable <- rbind(xtest,xtrain)
ytable <- rbind(ytest,ytrain)
subtable <- rbind(subjectest,subjectrain)

## Name columns with labels from features text
colnames(xtable) <-as.character(features[,2])


## Select columns with mean and std in their names
selectedmeanstdtable <- xtable[,grepl(("mean|std"),names(xtable))]

## Change activity from numbers to descriptive names
colnames(ytable) <- "activityid"
ytable$activityname <- factor(ytable$activityid, labels = as.character(activity[,2]))
activitynames <- ytable[,-1]

## name column in subject
colnames(subtable) <- "subject"

## Combine all tables together
tablescombined <- cbind(subtable, activitynames, selectedmeanstdtable)

## Arrange data by subject and then activity and calculate the mean of data
tablemean <- tablescombined %>% group_by(subject, activitynames) %>% summarise_all(funs(mean))
write.table(tablemean, file = "UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)



