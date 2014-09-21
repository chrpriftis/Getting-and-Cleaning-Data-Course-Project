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

In the "Load the activity labels" section , the script loads the activity labels from the corresponding file: features.txt

Next, the test and the train data are loaded and prepared:

In the "Prepare the test data" section, the script performs the following functions:

1. Loads the measurements from the X_test.txt file
2. Loads the Activity ID of each measurement from the y_test.txt file
3. Loads the Subject IDs of each measurement from the subject_test.txt file
4. Assigns the feature names to the columns of the measurements 
5. Keeps only the measurements for the mean and standard deviation
6. Sets the activity labels
7. Binds together all test data data structures into test_data


Next, it performes the exact same steps for the train data

It then Merges the test and the train data 

    data = rbind(test_data, train_data)


and then "melt"s them into a new data structure: m_data

    m_data      = melt(data, id = id_labels, measure.vars = data_labels)

Data structure m_data is then dcast(ed) and function mean is applied on Subject+Activity_ID+Activity_Label

    t_data   = dcast(m_data, Subject + Activity_ID + Activity_Label ~ variable, mean)

The column names of measured variables are then made more readable using the gsub function 

The tidy data set in now ready and is written to the tidy_file.txt
