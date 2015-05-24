## This script corresponds to the solution for the assigment 1 in
## the Data Science course Getting & Cleaning Data in Coursera
## The objective is to create a tidy data so a data which:
##      1. Each variable forms a column
##      2. Each observation forms a row
##      3. Each table/file stores data about one kinf of observation
## (e.g. people/hospitals)

################################################################################
## For a best performance is verified if data.table packet is installed in order 
## to use data.table functions to get the data in a fast way than read.table
useDataTable <- FALSE
if("data.table" %in% rownames(installed.packages()) == TRUE) useDataTable <- TRUE;

## if data.table is installed, load library
if (useDataTable)
        library(data.table)

################################################################################
################################################################################
## 1.Merging the training and the test sets to create one data set.
# Loading and preprocessing the data (The OS used is Windows 7)
# Getting the data from the web location indicated
# If you have some trouble with the download.file command, please download the 
# file from the internet by hand, unzip the getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# in your working dirtectory and comment next four lines & the lines starting 
# with unzip & unlink (they are already commented in this release as I had 
# performance issues when downloaded so uncomment lines if you want to download 
# from the internet by code)
#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#temp <- tempfile()
#download.file(fileUrl,temp)
#unzip(temp,"test/x_test.txt", list = FALSE, overwrite = TRUE)

# The file separator is blank, so as it is the default,  no sep parameter is used
# header = FALSE -> To not handle colnames
################################################################################
# Taking the test data
if (!useDataTable){
        subjectTestTable <- read.table("test/subject_test.txt", header=FALSE)
        #unzip(temp,"test/subject_test.txt", list = FALSE, overwrite = TRUE)
        xTestTable <- read.table("test/X_test.txt", header=FALSE)
        #unzip(temp,"test/Y_test.txt", list = FALSE, overwrite = TRUE)
        yTestTable <- read.table("test/y_test.txt", header=FALSE)
} else {
##Doing a sustituion of blank with sed so can be read using fread for fast performance        
        subjectTestTable <- fread(paste("sed", "'s/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g'" 
                                  ,"test/subject_test.txt"), header=FALSE)        #unzip(temp,"test/subject_test.txt", list = FALSE, overwrite = TRUE)
        xTestTable <- fread(paste("sed", "'s/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g'" 
                                ,"test/X_test.txt"), header=FALSE)        #unzip(temp,"test/Y_test.txt", list = FALSE, overwrite = TRUE)
        yTestTable <- fread(paste("sed", "'s/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g'" 
                                  ,"test/y_test.txt"), header=FALSE)
}
# Changing colnames for the xTestTable so when added labels are ok
# so add two (2) to the xTestTable column names, and changed
# the yTrainTable colName too to value V2
labelsForX <- paste0("V", c(as.numeric(substring(colnames(xTestTable), 2, 
                       last =length(colnames(xTestTable)))) +2))
colnames(xTestTable) =  labelsForX
colnames(yTestTable) =  c("V2")

# Binding the columns of test data
testData <- cbind(subjectTestTable, yTestTable, xTestTable)

################################################################################
# Taking the train data (same ways as for test data)
if (!useDataTable){
        subjectTrainTable <- read.table("train/subject_train.txt", header=FALSE)
        #unzip(temp,"train/subject_train.txt", list = FALSE, overwrite = TRUE)
        xTrainTable <- read.table("train/X_train.txt", header=FALSE)
        #unzip(temp,"train/Y_test.txt", list = FALSE, overwrite = TRUE)
        yTrainTable <- read.table("train/y_train.txt", header=FALSE)
}else{
##Doing a sustituion of blank with sed so can be read using fread for fast performance        
        subjectTrainTable <- fread(paste("sed", "'s/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g'" 
                                        ,"train/subject_train.txt"), header=FALSE)        #unzip(temp,"test/subject_test.txt", list = FALSE, overwrite = TRUE)
        xTrainTable <- fread(paste("sed", "'s/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g'" 
                                  ,"train/X_train.txt"), header=FALSE)        #unzip(temp,"test/Y_test.txt", list = FALSE, overwrite = TRUE)
        yTrainTable <- fread(paste("sed", "'s/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g'" 
                                  ,"train/y_train.txt"), header=FALSE)
}        
# Changing colnames for the xTrainTable so when added labels are ok
# so add two (2) to the xTrainTable column names, adn changed 
# the yTrainTable colName too to value V2
labelsForX <- paste0("V", c(as.numeric(substring(colnames(xTrainTable), 2, 
                                                 last =length(colnames(xTrainTable)))) +2))
colnames(xTrainTable) =  labelsForX
colnames(yTrainTable) =  c("V2")
# Binding the columns of train  data
trainData <- cbind(subjectTrainTable, yTrainTable, xTrainTable)

# Now are merged the rows of the train & test data created
testPlusTrainDataMerged <- rbind(testData, trainData)

# To verify show the dims of partial data & final data merged
dim(testData)
dim(trainData)
dim(testPlusTrainDataMerged)

# So it is verified that final data set has all the rows merged 
# (2947 + 7352 = 10299)  and the correspondant number of columns (563)

################################################################################
# Release temp file
#unlink(temp)

################################################################################
################################################################################
# 2.Extracting only the measurements on the mean and standard deviation 
#for each measurement. 
## Here is obtained all the information from the features to get  
## from it which estimated variables mean and std take for the whole 
## merged data
if (!useDataTable){
        featuresInfo <- read.table("features.txt", header=FALSE)
}else{
        featuresInfo <- fread(paste("sed", "'s/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/;/g'" 
            ,"features.txt"), header=FALSE)
}

# Now is obtained just the data which corresponds to mean (mean() function 
# and std (std() function)
condition <- (featuresInfo$V2 %like% "mean()" |  featuresInfo$V2 %like% "std()")
featuresMeanAndStd <- featuresInfo [,featuresInfo[condition == TRUE]]
                                    
#Deleting the meanFreq() entries from the above data set
condition <- featuresMeanAndStd$V2 %like% "meanFreq()"
featuresMeanAndStd <- featuresMeanAndStd [,featuresMeanAndStd[condition == FALSE]]

#To verify show the quantity of info get by calling dim
dim(featuresMeanAndStd)
                       
# So, it is obtained 66 rows with mean and std and the column 1 of obtained 
# featuresMeanAndStd contains the corresponding colum for the X_train or X_table 
# txt file. As the final data set merged (testPlusTrainDataMerged) contains in 
# the first two columns the columns of the subject_test or subjec_train data info 
# txt files, must be added 2 to the values in  the obtained column 1 (V1) in 
# featuresMeanAndStd to get the rights columns for mean and std. So it is 
# obtained by doing the following

library(dplyr)
meandAndStdData <- select(testPlusTrainDataMerged,c(1,2,featuresMeanAndStd$V1 + 2))

################################################################################
################################################################################
# 3.Uses descriptive activity names to name the activities in the data set
# The descriptive activity names are located in the activity_labels.txt
# file in the order indicated by the y_xxxx.txt file as indicated in Readme.txt
# of the data used. So it will be changed the numbers in column2 of the 
# data merged generated, both just mean and the whole with the correct names
# Changing second column of merged data to the label names indicated 

# Taking the info for the labels from the activity_labels.txt file 
labelValues <- read.table("activity_labels.txt", header=FALSE)

# Creating function to do the replacement of labels in column 2 as they are are 
# numbers
replacelabels <- function(labels,dataframe) { 
        for (n in 1:nrow(labels)) {                
                dataframe[[2]][dataframe[[2]]== labels[n,1]] <- as.character(labels[n,2])
        }
        return (dataframe)
}

# Changing second column of mean and std data to the label names indicated 
# using the replace function created
suppressWarnings(meandAndStdData <- replacelabels(labelValues, meandAndStdData))

# Changing also for the complete merged data
suppressWarnings(testPlusTrainDataMerged <- replacelabels(labelValues, testPlusTrainDataMerged))

################################################################################
################################################################################
# 4.Appropriately labels the data set with descriptive variable names. 

# In this case the labels are in the features.txt so it is used to 
# take the labels values using the previous load. Variable featuresMeanAndStd 
# contains the labels to use so usw it

labelValues <-  featuresMeanAndStd$V2

# Changing colNames
suppressWarnings(colnames(meandAndStdData) <-  c("subjectID","activityDone",featuresMeanAndStd$V2))

################################################################################
################################################################################
# 5.From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

# Using melt and dcat to obtain the tidy data required reshaped
library(reshape2)
suppressWarnings(meltData <- melt(meandAndStdData, id.vars=c("subjectID", "activityDone")))

suppressWarnings(meansData <- dcast(meltData , subjectID + activityDone ~ variable, mean))

write.table(meansData, "meansData.txt")
