## Read Me
This file describes the content of my getting-cleaning-data-course-project repo for my submission for the JHU Getting and Cleaning Data course on Coursera.

run_analysis.R is an R script that will generate a tidy data set from the "Human Activity Recognition using Smartphones" (HAR) dataset hosted on the UC-Irvine (UCI) website. When this R script is run, it will download the UCI HAR Dataset into your working directory, unzip it into your working directory, and then execute a series of steps to generate a tidy data set per the course project instructions. The details about how the code works are in the CodeBook.md file. 

tidydata.txt is the output of run_analysis.R. The file can be read into R using read.table(tidydata.txt, header=TRUE).

CodeBook.md is a code book that describes the tidydata.txt file and the the data, and the transformations or work that I performed to clean up the data.

More information about the UCI HAR Dataset is available at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

And in the following publication:

* Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


