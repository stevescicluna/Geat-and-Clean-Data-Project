# 1. Load dplyr and tidyr libraries

library(dplyr)
library (tidyr)

# 2. Read in activity_labels and features files

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt"
                              , header = FALSE, col.names = c("ActivityNumber", "ActivityDescription"))
features <- read.table("./data/UCI HAR Dataset/features.txt"
                       , header = FALSE, col.names = c("FeatureNumber","FeatureDescription"))

# 3. Read in subject_train, X_train, and y_train files

subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "Subject")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE, col.names = features$FeatureDescription)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", sep = " ", header = FALSE, col.names = "ActivityNumber")

# 4. Read in subject_test, X_test, and y_test files

subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "Subject")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE, col.names = features$FeatureDescription)
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE, col.names = "ActivityNumber")

# 5. Combine the test and training data sets

xCombine <- rbind(x_train, x_test)
yCombine <- rbind(y_train, y_test)
subjectCombine <- rbind(subject_train, subject_test)

# 6. Combine xCombine, yCombine and subjectCombine to create a new data frame 'hardata' (Human Activity Recognition) dataset

hardata <- cbind(subjectCombine, yCombine, xCombine)

# 7. Create a data frame with only mean and stdev for each measurement

harSubject <- select(hardata, Subject, ActivityNumber, contains("mean"), contains("std"), -contains("meanFreq"))

# 8. Apply descriptive names for the activity variable. Rearrange and sort columns.

harSubjectMerge <- merge(harSubject, activity_labels, by = "ActivityNumber")

harSubjectSort <- harSubjectMerge %>% 
  select(2, 1, 76, 3:75) %>% 
  arrange(Subject, ActivityNumber, ActivityDescription)

harSubjectSort$Subject <- as.factor(harSubjectSort$Subject)
harSubjectSort$ActivityNumber <- as.factor(harSubjectSort$ActivityNumber)

# 9. Create a tidy dataset

harSubjectTidy <- harSubjectSort %>% 
  gather("features", "measurement", 4:76)

# 10. Summarise the tidy dataset

harSubjectSummary <- harSubjectTidy %>% 
  group_by(Subject, ActivityDescription, features) %>% 
  summarise(avg_measurement = mean(measurement)) %>% ungroup() %>% ungroup() %>% 
  arrange(Subject, ActivityDescription, features)

# 11. Check outputs

head(harSubjectTidy)
dim(harSubjectTidy)
summary(harSubjectTidy)
head(harSubjectSummary)
dim(harSubjectSummary)
summary(harSubjectSummary)

# 12. Write outputs to text files

write.table(harSubjectTidy, file = "harSubjectTidy.txt", quote = FALSE, sep = " ", row.names = FALSE, col.names = TRUE)

write.table(harSubjectSummary, file = "harSubjectSummary.txt", quote = FALSE, sep = " ", row.names = FALSE, col.names = TRUE)