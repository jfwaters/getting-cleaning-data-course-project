## Code Book for UCI HAR Dataset

###Background:

(modified from UCI HAR Dataset ReadMe file)
"Human Activity Recognition using Smartphones"" experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz. The experiments were video-recorded to label the data manually. The original UCI HAR dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features (such as mean and standard deviation) was obtained by calculating variables from the time and frequency domain. 

For each record, the UCI HAR Dataset provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The tidydata.txt file is a tidy data version of the UCI HAR Dataset which focuses on only the mean and standard deviation of the acceleration and angular velocity of the smartphone, by providing a summary average of the mean and standard deviation estimates across all experiments for a given subject, activity, signal, and domain. More info about the process to generate the tidydata.txt flat file is provided at the end of this markdown file.

###Data Dictionary:

The tidydata.txt file contains the following columns:

* subject:  Contains an identifier for the subject who performed the activity for each window sample. Its range is from 1 to 30. 

* activity:  Contains descriptive language for the activity the subject was performing while the raw data was sampled. There are 6 types of activities:

        + walking
        + walking upstairs
        + walking downstairs
        + sitting
        + standing
        + laying
        
* signal: Describes the type of sensor signal recorded during the activity. The list below provides the short-hand notation for the different signal types contained in the data file, plus longer descriptions:

        + BodyAccJerkMag: Magnitude of the Jerk of the body on the phone
        (derived from linear acceleration; magnitude calculated using Euclidian norm)
        + BodyAccJerkX: Jerk of the body on the x axis of the phone (derived from linear acceleration) 
        + BodyAccJerkY: Jerk of the body on the y axis of the phone (derived from linear acceleration)   
        + BodyAccJerkZ: Jerk of the body on the z axis of the phone (derived from linear acceleration)
        + BodyAccMag: Magnitude of the linear acceleration of the body on the phone 
        (calculated using the Euclidian norm)     
        + BodyAccX: Linear acceleration of the body on the x axis of the phone       
        + BodyAccY: Linear acceleration of the body on the y axis of the phone       
        + BodyAccZ: Linear acceleration of the body on the z axis of the phone       
        + BodyGyroJerkMag: Magnitude of the Jerk of the body on the phone 
        (derived from angular velocity; magnitude calculated using Euclidian norm)
        + BodyGyroJerkX: Jerk of the body on the x axis of the phone (derived from angular velocity)  
        + BodyGyroJerkY: Jerk of the body on the y axis of the phone (derived from angular velocity)  
        + BodyGyroJerkZ: Jerk of the body on the z axis of the phone (derived from angular velocity)  
        + BodyGyroMag: Magnitude of the angular velocity of the body on the phone 
        (calculated using the Euclidian norm)    
        + BodyGyroX: angular velocity of the body on the x axis of the phone      
        + BodyGyroY: angular velocity of the body on the y axis of the phone      
        + BodyGyroZ: angular velocity of the body on the z axis of the phone      
        + GravityAccMag: magnitude of the gravity acceleration on the phone 
        (calculated using Euclidian norm)  
        + GravityAccX: gravity acceleration on the x axis of the phone    
        + GravityAccY: gravity acceleration on the y axis of the phone    
        + GravityAccZ: gravity acceleration on the z axis of the phone
        
* domain: describes the domain of the signals. There are 2 options:

        + time: raw signals, captured at a rate of 50 Hz
        + frequency:  a Fast Fourier Transform (FFT) was applied to the raw time signal
        
* variable: describes the variables that were estimated from the signals. There are 2 options:

        + mean
        + standarddeviation
        
* variablemean: this column contains the mean of the variable from all the experiments run for the given subject & activity, for the specified signal and domain. In other words, this is the mean of mean estimates, or the mean of standard deviation estimates, for the given domain from the signals captured from each experiment by the given subject during the given activity. 
        + Units: variablemean is dimensionless; it is a mean of variable
        estimates that were normalized between [-1,1].

###Methodology for Creating tidydata.txt File

The run_analysis.R file in this repo carries out the following steps to turn "messy data" into "tidydata":

1. Downloads the UCI HAR Dataset .zip file from the URL provided in the course, and saves in your working directory

2. Unzips the file into your working directory

3. Loads all of the relevant data files into data tables

        + Includes all the test, training, labels and features files

4. Merges the subject identifiers, test labels, and test data using cbind

5. Merges the subject identifiers, training labels, and training data using cbind

6. Merges the test and training data into one data set using rbind. The original dataset was split into test and training data files, but we were told to merge these together for the assignment. I did not keep the test/training information for future processing steps because it didn't seem necessary. 

7. Renames the columns of this merged dataset to reflect that the columns correspond to the subject, activity, and features vector (the latter has 561 elements)

8. Creates a subset of this data that includes only the mean and standard deviation estimate for each variable, by creating a logical vector of column names that match those descriptions and subsetting.

        + To do this, I included anything with "mean" or "std" in the variable name. 
        + I removed any columns including "Freq"(e.g., -meanFreq). 
        + I also did not inclue columns with "Mean" in the variable name (#e.g. gravityMean) 
        + only variables with lowercase "mean" and "std" are included

9. Cleans up activity labels originally provided in the activity_labels.txt file -- makes them all lower case, with no underscores. Then replaces the activity identifiers (integers) in the subset data with these descriptors. These are my "descriptive activity labels" requested in the assignment.

10. Cleans up variable names further, removing unnecessary '()' and '-' in variable names

11. Uses the melt function to create a 'long' form of the data for each combination of subject and activity

12. Splits out the three things embedded in the "variable" names, from the features file.  The end result is to have a column for "signal", "domain", and "variable" -- this is how I implemented "descriptive variable names". More descriptive detail is in the data dictionary above.

        + Creates a new column for the domain of the measurement: time, or frequency.
        + Renames the "variable" column to be "signal".
        The majority of the text content in the values in this column
        correspond to which signal is being measured 
        (e.g., BodyAcc-X, GravityAcc-Y, etc.)
        + Creates a new "variable" column containing whether the variable
        being measured for each signal is "mean" or "standard deviation"
        + Now clean up the "signal" column to remove the info that has been
        split out into other columns (t/f, mean/std)
        + Clean up an error in the original signal labels - some have
        duplicate "Body" in name

13. Rearranges the melted data column order into subject, activity, signal, domain, variable, value

14. Creates "tidy" data by using the summarize function to compute means of the mean and standard deviation estimates. 

15. Writes the tidy data set to the tidydata.txt file.

I believe this is "tidy" data because I've decomposed feature names like "tBodyAcc-mean()-Y" into three distinct parts: domain (time), signal (BodyAccY), and variable (mean). Then I computed the means of the variables (mean/std) by subject and activity -- and also by domain and signal. This is a "long" form of the tidy data this is the long form as mentioned in the grading rubric as either long or wide form is acceptable.


If you want to read this file back in and check it:
(the View() function only works in R Studio)

```{r}
data <- read.table("tidydata.txt", header = TRUE) 
View(data)
```

