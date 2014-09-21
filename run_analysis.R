##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Christos Priftis
## 21/09/2014
#
# This script performs the following steps on the UCI HAR Dataset  
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.  
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################

#
# Check for the required libraries. Install the required packages if necessary
#
if (!require("data.table")) {
    install.packages("data.table")
}

if (!require("reshape2")) {
    install.packages("reshape2")
}

require("data.table")
require("reshape2")

#
# Load the activity labels
#
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]


#
# Load the features column names 
#
features <- read.table("./UCI HAR Dataset/features.txt")[,2]


# Find the measurements on the mean and standard deviation for each measurement. 
# These measurements include "mean" and "std" in their feature description
required_features <- grepl("mean|std", features)


#
# Prepare the test data
#
# The measurements first
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
# The Activity ID for each measurement
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
# The subject IDs for each measurement
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Assign the feature names to the columns of the measurements
names(X_test) = features

# Extract (keep) only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,required_features]

# Set the activity labels
# Use the first column (it is the activity ID) of y_test as an index to extract the appropriate description from activity_labels
y_test[,2] = activity_labels[y_test[,1]]

# Set the column names for y_test
names(y_test) = c("Activity_ID", "Activity_Label")

# Assign a column name to subject_test
names(subject_test) = "Subject"

# Bind test data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

#
# Prepare the train data
#
# The measurements first
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
# The Activity ID for each measurement
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
# The subject IDs for each measurement
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Assign the feature names to the columns of the measurements
names(X_train) = features

# Extract (keep) only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,required_features]

# Set the activity labels
# Use the first column (it is the activity ID) of y_train as an index to extract the appropriate description from activity_labels
y_train[,2] = activity_labels[y_train[,1]]

# Set the column names for y_train
names(y_train) = c("Activity_ID", "Activity_Label")

# Assign a column name to subject_train
names(subject_train) = "Subject"

# Bind train data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

#
# Merge test and train in variable: data
#
data = rbind(test_data, train_data)

# The following are the only columns that are not measured variables
id_labels   = c("Subject", "Activity_ID", "Activity_Label")
# Lets get the measured variables
data_labels = setdiff(colnames(data), id_labels)

#
# Melt them using id_labels and data_labels
# 
m_data      = melt(data, id = id_labels, measure.vars = data_labels)

#
# Dcast them applying mean on subject+Activity_ID+Activity_Label
#
t_data   = dcast(m_data, Subject + Activity_ID + Activity_Label ~ variable, mean)


#
# Lets make the measured variables column names readable before writing to the tidy file
#
ColumnNames<-colnames(t_data)

for (i in 1:length(ColumnNames)) 
{
    ColumnNames[i] = gsub("\\()","",ColumnNames[i])
    ColumnNames[i] = gsub("-std$","StdDev",ColumnNames[i])
    ColumnNames[i] = gsub("-mean","Mean",ColumnNames[i])
    ColumnNames[i] = gsub("^(t)","time",ColumnNames[i])
    ColumnNames[i] = gsub("^(f)","freq",ColumnNames[i])
    ColumnNames[i] = gsub("([Gg]ravity)","Gravity",ColumnNames[i])
    ColumnNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",ColumnNames[i])
    ColumnNames[i] = gsub("[Gg]yro","Gyro",ColumnNames[i])
    ColumnNames[i] = gsub("AccMag","AccMagnitude",ColumnNames[i])
    ColumnNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",ColumnNames[i])
    ColumnNames[i] = gsub("JerkMag","JerkMagnitude",ColumnNames[i])
    ColumnNames[i] = gsub("GyroMag","GyroMagnitude",ColumnNames[i])
};

colnames(t_data)=ColumnNames

#
# Create the tidy file
#
# with row.name=FALSE as requested in the project course instructions
write.table(t_data, file = "./tidy_data.txt", row.name=FALSE, sep='\t')
