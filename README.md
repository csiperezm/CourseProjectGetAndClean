# CourseProjectGetAndClean
This repository corresponds to the solution for the assigment 1 in the Data Science course Getting &amp; Cleaning Data in Coursera

## This repository corresponds to the solution for the assigment 1 in
the Data Science course Getting & Cleaning Data in Coursera
The objective is to create a tidy data so a data which:
	1. Each variable forms a column
	2. Each observation forms a row
	3. Each table/file stores data about one kinf of observation (e.g. people/hospitals)

The activities to do are following, and those are develop in the run_analysis.R script
in this repository:
	1.	Merges the training and the test sets to create one data set.
	2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
	3.	Uses descriptive activity names to name the activities in the data set
	4.	Appropriately labels the data set with descriptive variable names. 
	5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data supplied for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


## The detailed develop of the tidy data is explained in the supplied run_analysis.R file


Notes:
- Used libraries dplyr and reshape2, so should be installed in the environment
- There is just one script run_analysis.R in which all the process for generate the tidy data is done and explained
in detail



