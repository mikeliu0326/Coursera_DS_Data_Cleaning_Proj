# Summary
Reads in and cleans data from the Human Activity Recognition Using Smartphones Dataset by Smartlab.
Outputs a tidied dataset composed of the subject labels, activity names, measurement names, and average measurements as merged_tidy_avgs_output.txt.

# Process
1. Reads in training and test data, as well as feature names, which is used to rename the columns of the data.
2. Veryify that both datasets have the same number of columns, then merge them by column. 
3. Drop any columns not associated with mean or std. 
4. Read in subject training and text data, merge them and rename. 
5. Read in activity labels for training and test data, merge them and map their numeric labels to the appropriate activity description in activity_labels.txt. 
6. Merge the main dataset with the subject and activity vectors by row. 
7. Melt the merged dataset by subject and activity to produce a thin and long dataset composed of the subject, activity, measurement name, and measurement. Call this tidy.
8. Aggregate any data in the tidy dataset sharing the same subject, activity, and measurement name by average.
9. Verify that at least one result is expected, write the aggregated tidy dataset as a text file.
