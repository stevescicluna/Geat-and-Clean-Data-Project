ORIGINAL DATASET

The original dataset was downloaded as a single .zip file "getdata_projectfiles_UCI HAR Dataset.zip", comprising the following files when unzippped:

1. activity_labels.txt
2. features.txt
3. features_info.txt
4. README.txt
5. "test" folder containing subject_test.txt, X_test.txt, Y_test.txt, and "Inertial Signals" folder containing several .txt test data files
6. "train" folder containing subject_train.txt, X_train.txt, Y_train.txt, and "Inertial Signals" folder containing several .txt train data files

STRUCTURE

1. Each of the subject_ files contains a single column with an identifier code for the subject (presumably user) being observed.
2. Each of the X_ files contains 561 fields with various measurements, sourced from features.txt
3. Each of the Y_ files contains a single column with an activity number (1 to 6) representing activities sucvh as walking, sitting etc. sourced from activity_labels.txt
4. 70% of the observations were randomly selected into the _train dataset. The remaining 30% went into the _test dataset.

TRANSFORMATIONS

1. activity_labels.txt and features.txt were read into R; "activityNumber" and "ActivityDescription" column headings created manually
2. subject_train.txt, X_train.txt, and Y_train.txt were read into R
3. subject_test.txt, X_test.txt, and Y_test.txt were read into R
4. X_ files read in with column names sourced from features.txt
5. subject_ and Y_ files read in with manually created column names "Subject" and "ActivityNumber" respectively
6. rbind() command used to combine the X_, Y_, and subject_ tables into "xCombine", "yCombine", and "subjectCombine" tables respectively
7. cbind() command used to combine the xCombine, yCombine, and subjectCombine into "hardata" table
8. select() command used to create "harSubject" table containing means and standard deviations for each subject-activity combination
9. merge() command used to organise harSubject rows by ActivityNumber and create "harSubjectMerge" table
10. select() and arrange() commands chained to re-arrange harSubjectMerge columns and rows and create "harSubjectSort" table
11. gather() command used to tidy harSubjectSort table into new "harSubjectTidy" table by selecting Subject, ActivityNumber, ActivityDescription, and features fields first, then mean and standard deviation calculations for the remaining 73 fields
12. group_by(), summarise(), and arrange() commands chained to summarise harSubjectTidy table into "harSubjectSummary" table containing averages of the measured features, grouped by subject, then by activity, then by feature
13. head(), (summarise(), and dim() commands used to print sumamry outputs in R console to enable output tables to be checked
14. write.table() command used to export harSubjectTidy and harSubjectSummary tables to "HAR_tidy_dataset.txt" and "HAR_summary.txt" files respectively, saved in R working directory.

OUTPUT FILES

HAR_tidy_dataset.txt contains the following fields:

1. Subject - numeric ID (1 to 30) for the subject/user being observed
2. ActivityNumber - numeric ID (1 to 6) for the activity being observed
3. ActivityDescription - name of activity corresponding to each ActivityNumber
4. features - selected variables containing the mean or standard deviation of the observed subject-activity combination
5. measurement - measured mean or standard deviation values

HAR_summary.txt contains the following fields:

1. Subject - numeric ID (1 to 30) for the subject/user being observed
2. ActivityDescription - name of activity corresponding to each ActivityNumber
3. features - different observations taken for each subject-activity combination
4. avg_measurement - the average of the range of observation measurements taken for each subject-activity combination
