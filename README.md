Getting-and-Cleaning-Data-Course-Project
========================================

Introduction
------------

This repository contains my project for the Coursera "Getting and Cleaning Data" course, part of the Data Science specialization.


The raw data
------------------

The raw data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The zip file containing the raw data can be found here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The required processing  
-----------------------

Create one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The resulting data set should be stored in a text file named "tidy_file.txt"

The resulted tidy data file
---------------------------
The resulted tidy file is the tidy_file.txt that you can find in this repository

About the Code Book
-------------------
The CodeBook.md file provides details about the implementation of the run_analysis.R script as well as information about the data included in the tidy data file (see above) 
