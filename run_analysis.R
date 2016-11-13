## This R script creates a tidy data set for the Getting and Cleaning Data
## course project in the Coursera course offered by Johns Hopkins University.

## Written by Julie Waters
## Last revision:  November 12, 2016

## Load necessary libraries

library(reshape2)
library(plyr)
library(dplyr)

## Store URL for project .zip file containing "messy data"

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Check to see if .zip file is already in your working directory.
## If it's not, download project .zip file from the above URL.

if(!file.exists("UCI HAR Dataset.zip")) {
        download.file(fileUrl,destfile="UCI HAR Dataset.zip",mode="wb")
}

## Unzip the UCI HAR Dataset in your working directory. 
## It will not overwrite existing files if you've previously unzipped.
## (Note - you will get 28 warnings if the files already exist.
## These warnings can be ignored.)

unzip("UCI HAR Dataset.zip", overwrite = FALSE)

## Load all of the data files for the "test" set into data tables

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Load all of the data files for the "train" set into data tables

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## Load the activity labels and features into data tables

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",
                              stringsAsFactors=FALSE)
features <- read.table("./UCI HAR Dataset/features.txt",
                       stringsAsFactors=FALSE)

## Merge the subject identifiers, test labels, and test data 

merged_subj_test <- cbind(subject_test,y_test,x_test)

## Merge the subject identifiers, training labels, and training data 

merged_subj_train <- cbind(subject_train,y_train,x_train)

## Merge the test and training data into one data set
## (This completes Part 1 of the assignment)

merged_data <- rbind(merged_subj_test,merged_subj_train)

## Rename the columns of this data set for clarity

names(merged_data)[1]<-"subject"  #because we put subject_* first in cbind
names(merged_data)[2]<-"activity" #because we put y_* first in cbind 
                                  #(y_* files contain activity IDs)
names(merged_data)[3:563]<-features[,2]  #because the features file includes the
                                         #column names for the x_* files

## Create a subset of this data that includes only the mean and standard
## deviation for each variable.

## Note: To do this, I included anything with "mean" or "std" in the variable
## name. I removed any columns including "Freq"(e.g., -meanFreq). I also did
## not inclue columns with "Mean" in the variable name (#e.g. gravityMean) 
## -- only variables with lowercase "mean" are included

## this step creates a logical vector to identify the columns matching the
## above conditions

column_extract <- (grepl("mean",names(merged_data)) | 
        grepl("std",names(merged_data))) &
        !grepl("Freq",names(merged_data))

## this step adds in the first two columns for subject and activity

column_extract[1]<-TRUE  #include subject column
column_extract[2]<-TRUE  #include activity column

## this step creates a subset of the data with only the subject, activity, 
## and mean/standard deviation columns
## (This completes Part 2 of the assignment)

subset<-merged_data[,which(column_extract)]

## Do some cleanup to the activity labels to make them look nicer

activity_labels$V2<-tolower(activity_labels$V2)
activity_labels$V2<-gsub("_"," ",activity_labels$V2)

## Add descriptive activity labels to subset
## (This completes Part 3 of the assignment)

activityID <-function(x){activity_labels[x,2]}  #create a function to 
                                                #identify activity labels
subset$activity <- activityID(subset$activity) #replace activity ID with
                                               #descritive text for activity

## Do more cleanup - remove unnecessary '()' and '-' in variable names

names(subset)<-gsub("\\(\\)","",names(subset))
names(subset)<-gsub("\\-","",names(subset))

## Use the melt function to create a 'long' form of the data for each
## combination of subject and activity

melt_subset<-melt(subset,id=1:2)  #uses 'subject' and 'activity' columns

## Splits out the three things embedded in the "variable" names, from the
## features file: 
## 1) Create a new column for the domain of the measurement: time, or frequency.
##    Variable names beginning with "t" are in the time domain
##    Variable names beginning with "f" are in the frequency domain

melt_subset$domain <- ifelse(grepl("^t", melt_subset$variable)==TRUE,
                             "time","frequency")

## 2) Rename the "variable" column to be "signal", since the majority of the
##    text content in the values in this column correspond to which signal
##    is being measured (e.g., BodyAcc-X, GravityAcc-Y, etc.)

names(melt_subset)[3]<-"signal"

## 3) Create a new "variable" column containing whether the variable being
##    measured for each signal is "mean" or "standard deviation"
melt_subset$variable <- ifelse(grepl("mean", melt_subset$signal)==TRUE,
                               "mean","standarddeviation")

## Now clean up the "signal" column to remove the info that has been split
## out into other columns (t/f, mean/std)

melt_subset$signal<-gsub("^(t|f)","",melt_subset$signal)
melt_subset$signal<-gsub("mean","",melt_subset$signal)
melt_subset$signal<-gsub("std","",melt_subset$signal)

## Clean up an error in the original signal labels - some have duplicate
## "Body" in name

melt_subset$signal<-gsub("BodyBody","Body",melt_subset$signal)

## Rearrange column order (this completes Part 4 of assignment)
## The descriptive variable names are in the "signal", "domain", and 
## "variable" columns. The CodeBook provides more descriptive information 
## about what each of the "signal" entries mean.

melt_subset<-select(melt_subset,subject,activity,signal,domain,variable,value)

## Create "tidy" data by using summarize function to compute means.

tidydata<-summarize(group_by(melt_subset,subject, activity, signal, domain, 
                             variable), mean(value))
names(tidydata)[6]="variablemean"  ##renames last column to be more intuitive

## I believe this is "tidy" data because I've decomposed feature names like
## "tBodyAcc-mean()-Y" into three distinct parts: domain (time), signal 
## (BodyAccY), and variable (mean). Then I computed the means of the variables 
## (mean/std) by subject and activity -- and also by domain and signal.

## This is a "long" form of the tidy data this is the long form as mentioned in 
## the grading rubric as either long or wide form is acceptable.

## Write the tidy data to a file
write.table(tidydata,file="tidydata.txt")

## If you want to read this file back in and check it:
## (the View() function only works in R Studio)
## data <- read.table("tidydata.txt", header = TRUE) 
## View(data)