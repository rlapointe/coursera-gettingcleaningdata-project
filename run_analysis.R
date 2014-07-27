## =====================
## 1) Merge the training and the test sets to create one data set.

## Reading in all datasets
activity_labels = read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c('activity_code', 'activity_type'))
feature_labels = read.table("./UCI HAR Dataset/features.txt", col.names = c('feature_code', 'feature_type'))

test_labels = read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c('activity_code')) 
test_subjects = read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c('subject'))
test_data = read.table("./UCI HAR Dataset/test/X_test.txt", col.names = feature_labels$feature_type) 
test_data$activity_label = unlist(test_labels)
test_data$subject_ID = unlist(test_subjects)

training_labels = read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c('activity_code')) 
training_subjects = read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c('subject'))
training_data = read.table("./UCI HAR Dataset/train/X_train.txt", col.names = feature_labels$feature_type) 
training_data$activity_label = unlist(training_labels)
training_data$subject_ID = unlist(training_subjects)

all_data = rbind(test_data, training_data)

## =====================
## 2) Extract only the measurements on the mean and standard deviation for each measurement. 
cols_to_keep = grepl('mean|Mean|std|label|subject', colnames(all_data))
std_and_mean_data = all_data[cols_to_keep]

## =====================
## 3) Uses descriptive activity names to name the activities in the data set
std_and_mean_data[std_and_mean_data$activity_label==1,]$activity_label = "WALKING"
std_and_mean_data[std_and_mean_data$activity_label==2,]$activity_label = "WALKING_UPSTAIRS"
std_and_mean_data[std_and_mean_data$activity_label==3,]$activity_label = "WALKING_DOWNSTAIRS"
std_and_mean_data[std_and_mean_data$activity_label==4,]$activity_label = "SITTING"
std_and_mean_data[std_and_mean_data$activity_label==5,]$activity_label = "STANDING"
std_and_mean_data[std_and_mean_data$activity_label==6,]$activity_label = "LAYING"

## =====================
## 4) Appropriately labels the data set with descriptive variable names. 
## Cleaning up variable names

orig_colnames = colnames(std_and_mean_data) ## storing original column names before modifying
colnames(std_and_mean_data) = gsub('BodyBody', 'Body', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = gsub('...', '_for_', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = gsub('..', '', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = gsub('.', '', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = gsub('Mean', 'mean', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = gsub('Std', 'std', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = gsub('mean', '_mean', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = gsub('std', '_std', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('fBody', 'frequency_body_', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('tBody', 'time_body_', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('tGravity', 'time_gravity_', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('Acc', 'accelerometer_', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('Mag', 'magnitude_', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('Gyro', 'gyroscope_', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('Jerk', 'jerk_', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('angle', 'angle_', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('meangravity', 'mean_gravity', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('meanFreq', 'mean_frequency', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('Xgravity', 'X_gravity', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('Ygravity', 'Y_gravity', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('Zgravity', 'Z_gravity', colnames(std_and_mean_data), fixed=TRUE)
colnames(std_and_mean_data) = sub('__', '_', colnames(std_and_mean_data), fixed=TRUE)

## =====================
## 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
final_data_set <-aggregate(std_and_mean_data[1:86], by=list(std_and_mean_data$subject_ID, 
                                               std_and_mean_data$activity_label), FUN=mean, na.rm=TRUE)

colnames(final_data_set) = sub('Group.1', 'subject_id', colnames(final_data_set), fixed=TRUE)
colnames(final_data_set) = sub('Group.2', 'activity_label', colnames(final_data_set), fixed=TRUE)

## Final tiday data set that I will submit is final_data_set as a comma-delimited_file with extension ".txt":
write.csv(final_data_set, "./data/final_tidy_data.txt")
