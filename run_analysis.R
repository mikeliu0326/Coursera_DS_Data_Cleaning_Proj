## Obj 1: Merge training and test sets into one data set
# Read in Feature Names
feature_names = read.table("data/UCI HAR Dataset/features.txt")[,2]

# Read in data for Test and Train
X_test = read.table("data/UCI HAR Dataset/test/X_test.txt")
X_train = read.table("data/UCI HAR Dataset/train/X_train.txt")

## Obj 4: Appropriately label dataset, activity and subject labels come later
# Label features of test and train
names(X_test) = feature_names
names(X_train) = feature_names

# Verify that the two datasets have the same number of rows
#  After verifying, merge the two tables by row using rbind
dim(X_test)[2] == dim(X_train)[2] 
X_total = rbind(X_test, X_train)


## Obj 2: Extract only the measurements on mean and std for each measurement
# Extract the feature names with mean or std, only select those columns in X_total, discarding the rest
extract_ind = grep("[Mm]ean|[Ss]td", feature_names) #This is done early to minimize memory used for X_total
X_total = X_total[,extract_ind]


# Read in Subject Numbers for train and test
sub_test = read.table("data/UCI HAR Dataset/test/subject_test.txt")
sub_train = read.table("data/UCI HAR Dataset/train/subject_train.txt")

# Verify that the two subject vectors have the same number of rows
#  After verifying, merge the two tables by row using rbind
dim(sub_test)[2] == dim(sub_train)[2] 
sub_total = rbind(sub_test, sub_train)  #bind them in the same order in terms of test and train as X

# Set subject label
names(sub_total) = "subject"


## Obj 3: Use descriptive activity names to name activities in labels
# Read in Training and Test labels
y_test = read.table("data/UCI HAR Dataset/test/y_test.txt")
y_train = read.table("data/UCI HAR Dataset/train/y_train.txt")
activity_labels = read.table("data/UCI HAR Dataset/activity_labels.txt")

# Verify that the two label vectors have the same number of rows
#  After verifying, merge the two tables by row using rbind
dim(y_test)[2] == dim(y_train)[2]
y_total = rbind(y_test, y_train)    #bind them in the same order in terms of test and train as X

# Rename the label numbers as activity
names(y_total) = "activity"

# Use the activity labels to map label numbers to their text descriptions
y_total["activity"] = activity_labels$V2[y_total$activity]
head(y_total)


# Verify that sub_total, y_total and x_total have the same number of columns
#  After verifying, merge them using cbind
(dim(sub_total)[1] == dim(y_total)[1]) & (dim(y_total)[1] == dim(X_total)[1])
merged_data = cbind(sub_total, y_total, X_total)
head(merged_data)


## Obj 5: Create independent tidy dataset with avg of each var for each activity/subject
# Use setDT to have melt work properly without importing reshape2
setDT(merged_data)

# Melt merged data down into long and narrow dataset, with subject and activity as key columns
merged_tidy = melt(merged_data, id=c("subject", "activity"))

# Aggregate merged_tidy's value column using mean, by subject, activity, and variable
# Note the difference in syntax between this and the lecture notes. I prefer this as it is more readable.
merged_tidy_avgs = aggregate(merged_tidy$value, 
                        by = list(merged_tidy$subject, merged_tidy$activity, merged_tidy$variable), 
                        FUN = mean)

# Rename columns of merged_tidy_avgs
names(merged_tidy_avgs) = c("Subject", "Activity", "Measured_Variable", "Avg_Val")
head(merged_tidy_avgs)

## Check that the result is expected
merged_tidy_avgs[1,4] == mean(merged_data$`tBodyAcc-mean()-X`
                              [which(merged_data$subject==1 & merged_data$activity=="LAYING")])

## Write the dataset
write.table(merged_tidy_avgs,'data/merged_tidy_avgs_output.txt', row.name=FALSE)
