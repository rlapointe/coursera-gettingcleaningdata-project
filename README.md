coursera-gettingcleaningdata-project
====================================

This file describes how the file run_analysis.R works, and also gives 
information about the dataset. Please see the script for more details.

In section 1 in my script, I read in all the datasets and name columns
appropriately.

In section 2, I only keep columns that have means or standard deviations.

In section 3, I change the activity labels to more descriptive names.

In section 4, I clean up the variable names so they are more descriptive.

Finally in section 5, I aggregate the data to take the means of each of the
variables, by subject and by activity.

I then output the tidy data set with write.csv to create a comma-separated
text file.