How we get from the raw to the tidy data set (and the tidy_file.txt)
====================================================================

The raw data
------------
Information about the raw data (origin, format, values e.t.c) can be found in README.md. 
Here is a quick link to the file: https://github.com/chrpriftis/Getting-and-Cleaning-Data-Course-Project/blob/master/README.md

The README.md file also includes information about the processing performed on the raw data as well as the requirements for the tidy data

How to execute the run_analysis.R script
----------------------------------------

1. The script expects to find the "UCI HAR Dataset" directory under the current directory
2. The tidy_file.txt is created in the current directory


The inner workings of the run_analysis.R script
-----------------------------------------------

In the "Check for the required libraries. Install the required packages if necessary", the script checks whether the required libraries are installed. If they are not, it shall install the required packages

    if (!require("data.table")) {
        install.packages("data.table")
    }
    
    if (!require("reshape2")) {
        install.packages("reshape2")
    }

    require("data.table")
    require("reshape2")

In the "Load the activity labels" section , the script loads the activity labels from the corresponding file: features.txt

    activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

Next, the features column names of the measurements are loaded

    features <- read.table("./UCI HAR Dataset/features.txt")[,2]
    
The required_features indicates which features include "mean" or "std" into their description

    required_features <- grepl("mean|std", features)

Next, the test and the train data are loaded and prepared:

In the "Prepare the test data" section, the script performs the following functions:

1. Loads the measurements from the X_test.txt file into the `X_test` variable
2. Loads the Activity ID of each measurement from the y_test.txt file into the `y_test` variable
3. Loads the Subject IDs of each measurement from the subject_test.txt file into the `subject_test` variable
4. Assigns the feature names to the columns of the measurements 
5. Keeps only the measurements for the mean and standard deviation
6. Sets the activity labels
7. Binds together all test data data structures into variable `test_data`


Next, it performes the exact same steps for the train data

It then Merges the test and the train data 

    data = rbind(test_data, train_data)


and then "melt"s them into a new data structure: `m_data`

    m_data      = melt(data, id = id_labels, measure.vars = data_labels)

Data structure `m_data` is then dcast(ed) and function mean is applied on `Subject+Activity_ID+Activity_Label`

    t_data   = dcast(m_data, Subject + Activity_ID + Activity_Label ~ variable, mean)

The column names of measured variables are then made more readable using the gsub function 

The tidy data set in now ready and is written to the tidy_file.txt

Mapping of raw data column names into tidy data column names
============================================================

The transformation of the column names is performed using gsub

    () becomes ""
    -std becomes StdDev
    -mean becomes Mean
    what starts with t becomes time
    what starts with f becomes freq
    gravity become Gravity
    BodyBody or Body becomes Body
    gyro becomes Gyro
    AccMag becomes AccMagnitude
    Bodyaccjerkmag becomes BodyAccJerkMagnitude
    JerkMag becomes JerkMagnitude
    GyroMag becomes GyroMagnitude

The raw data column names for the measurement columns (features.txt)
--------------------------------------------------------------------
 [4] "tBodyAcc-mean()-X"               "tBodyAcc-mean()-Y"               "tBodyAcc-mean()-Z"              
 [7] "tBodyAcc-std()-X"                "tBodyAcc-std()-Y"                "tBodyAcc-std()-Z"               
[10] "tGravityAcc-mean()-X"            "tGravityAcc-mean()-Y"            "tGravityAcc-mean()-Z"           
[13] "tGravityAcc-std()-X"             "tGravityAcc-std()-Y"             "tGravityAcc-std()-Z"            
[16] "tBodyAccJerk-mean()-X"           "tBodyAccJerk-mean()-Y"           "tBodyAccJerk-mean()-Z"          
[19] "tBodyAccJerk-std()-X"            "tBodyAccJerk-std()-Y"            "tBodyAccJerk-std()-Z"           
[22] "tBodyGyro-mean()-X"              "tBodyGyro-mean()-Y"              "tBodyGyro-mean()-Z"             
[25] "tBodyGyro-std()-X"               "tBodyGyro-std()-Y"               "tBodyGyro-std()-Z"              
[28] "tBodyGyroJerk-mean()-X"          "tBodyGyroJerk-mean()-Y"          "tBodyGyroJerk-mean()-Z"         
[31] "tBodyGyroJerk-std()-X"           "tBodyGyroJerk-std()-Y"           "tBodyGyroJerk-std()-Z"          
[34] "tBodyAccMag-mean()"              "tBodyAccMag-std()"               "tGravityAccMag-mean()"          
[37] "tGravityAccMag-std()"            "tBodyAccJerkMag-mean()"          "tBodyAccJerkMag-std()"          
[40] "tBodyGyroMag-mean()"             "tBodyGyroMag-std()"              "tBodyGyroJerkMag-mean()"        
[43] "tBodyGyroJerkMag-std()"          "fBodyAcc-mean()-X"               "fBodyAcc-mean()-Y"              
[46] "fBodyAcc-mean()-Z"               "fBodyAcc-std()-X"                "fBodyAcc-std()-Y"               
[49] "fBodyAcc-std()-Z"                "fBodyAcc-meanFreq()-X"           "fBodyAcc-meanFreq()-Y"          
[52] "fBodyAcc-meanFreq()-Z"           "fBodyAccJerk-mean()-X"           "fBodyAccJerk-mean()-Y"          
[55] "fBodyAccJerk-mean()-Z"           "fBodyAccJerk-std()-X"            "fBodyAccJerk-std()-Y"           
[58] "fBodyAccJerk-std()-Z"            "fBodyAccJerk-meanFreq()-X"       "fBodyAccJerk-meanFreq()-Y"      
[61] "fBodyAccJerk-meanFreq()-Z"       "fBodyGyro-mean()-X"              "fBodyGyro-mean()-Y"             
[64] "fBodyGyro-mean()-Z"              "fBodyGyro-std()-X"               "fBodyGyro-std()-Y"              
[67] "fBodyGyro-std()-Z"               "fBodyGyro-meanFreq()-X"          "fBodyGyro-meanFreq()-Y"         
[70] "fBodyGyro-meanFreq()-Z"          "fBodyAccMag-mean()"              "fBodyAccMag-std()"              
[73] "fBodyAccMag-meanFreq()"          "fBodyBodyAccJerkMag-mean()"      "fBodyBodyAccJerkMag-std()"      
[76] "fBodyBodyAccJerkMag-meanFreq()"  "fBodyBodyGyroMag-mean()"         "fBodyBodyGyroMag-std()"         
[79] "fBodyBodyGyroMag-meanFreq()"     "fBodyBodyGyroJerkMag-mean()"     "fBodyBodyGyroJerkMag-std()"     
[82] "fBodyBodyGyroJerkMag-meanFreq()"

The corresponding tidy data measurements column names
-----------------------------------------------------
 [4] "timeBodyAccMean-X"                 "timeBodyAccMean-Y"                 "timeBodyAccMean-Z"                
 [7] "timeBodyAcc-std-X"                 "timeBodyAcc-std-Y"                 "timeBodyAcc-std-Z"                
[10] "timeGravityAccMean-X"              "timeGravityAccMean-Y"              "timeGravityAccMean-Z"             
[13] "timeGravityAcc-std-X"              "timeGravityAcc-std-Y"              "timeGravityAcc-std-Z"             
[16] "timeBodyAccJerkMean-X"             "timeBodyAccJerkMean-Y"             "timeBodyAccJerkMean-Z"            
[19] "timeBodyAccJerk-std-X"             "timeBodyAccJerk-std-Y"             "timeBodyAccJerk-std-Z"            
[22] "timeBodyGyroMean-X"                "timeBodyGyroMean-Y"                "timeBodyGyroMean-Z"               
[25] "timeBodyGyro-std-X"                "timeBodyGyro-std-Y"                "timeBodyGyro-std-Z"               
[28] "timeBodyGyroJerkMean-X"            "timeBodyGyroJerkMean-Y"            "timeBodyGyroJerkMean-Z"           
[31] "timeBodyGyroJerk-std-X"            "timeBodyGyroJerk-std-Y"            "timeBodyGyroJerk-std-Z"           
[34] "timeBodyAccMagnitudeMean"          "timeBodyAccMagnitudeStdDev"        "timeGravityAccMagnitudeMean"      
[37] "timeGravityAccMagnitudeStdDev"     "timeBodyAccJerkMagnitudeMean"      "timeBodyAccJerkMagnitudeStdDev"   
[40] "timeBodyGyroMagnitudeMean"         "timeBodyGyroMagnitudeStdDev"       "timeBodyGyroJerkMagnitudeMean"    
[43] "timeBodyGyroJerkMagnitudeStdDev"   "freqBodyAccMean-X"                 "freqBodyAccMean-Y"                
[46] "freqBodyAccMean-Z"                 "freqBodyAcc-std-X"                 "freqBodyAcc-std-Y"                
[49] "freqBodyAcc-std-Z"                 "freqBodyAccMeanFreq-X"             "freqBodyAccMeanFreq-Y"            
[52] "freqBodyAccMeanFreq-Z"             "freqBodyAccJerkMean-X"             "freqBodyAccJerkMean-Y"            
[55] "freqBodyAccJerkMean-Z"             "freqBodyAccJerk-std-X"             "freqBodyAccJerk-std-Y"            
[58] "freqBodyAccJerk-std-Z"             "freqBodyAccJerkMeanFreq-X"         "freqBodyAccJerkMeanFreq-Y"        
[61] "freqBodyAccJerkMeanFreq-Z"         "freqBodyGyroMean-X"                "freqBodyGyroMean-Y"               
[64] "freqBodyGyroMean-Z"                "freqBodyGyro-std-X"                "freqBodyGyro-std-Y"               
[67] "freqBodyGyro-std-Z"                "freqBodyGyroMeanFreq-X"            "freqBodyGyroMeanFreq-Y"           
[70] "freqBodyGyroMeanFreq-Z"            "freqBodyAccMagnitudeMean"          "freqBodyAccMagnitudeStdDev"       
[73] "freqBodyAccMagnitudeMeanFreq"      "freqBodyAccJerkMagnitudeMean"      "freqBodyAccJerkMagnitudeStdDev"   
[76] "freqBodyAccJerkMagnitudeMeanFreq"  "freqBodyGyroMagnitudeMean"         "freqBodyGyroMagnitudeStdDev"      
[79] "freqBodyGyroMagnitudeMeanFreq"     "freqBodyGyroJerkMagnitudeMean"     "freqBodyGyroJerkMagnitudeStdDev"  
[82] "freqBodyGyroJerkMagnitudeMeanFreq"

Values of tidy data variables
=============================
Column 1: Subject. It is the ID retrieved from the subject_test.txt and the subject_train.txt. Examples: 1,2,3,4,...
Column 2: Activity_ID: It is the activity ID retrieved from the y_test.txt and y_train.txt files. Examples: 1,2,3,4,...
Column 3: Activity_Label: It is the activity description corresponding to the Activity_ID. It is retrieved from the activity_labels.txt file. Examples: WALKING, SITTING,....
Columns 4-82: The mean calculated for the corresponding measurements. Examples: ,   0.314182940150943, -0.992349818113208,....
