features <- read.table("./UCI HAR Dataset/features.txt")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

Stest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")

Strain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
std <- grep("std", features[,2])
m <- grep("mean", features[,2])
sorted <- sort(union(std, m))

#4. Appropriately labels the data set with descriptive variable names. 
label <- combine("subject", "activity", features[sorted,2])
test <- cbind(Stest, Ytest, Xtest[, sorted])
colnames(test) <- label
train <- cbind(Strain, Ytrain, Xtrain[, sorted])
colnames(train) <- label

#1. Merges the training and the test sets to create one data set.
library(dplyr)
galaxy <- arrange(rbind(test, train), subject)

#3. Uses descriptive activity names to name the activities in the data set
for (i in 1:length(galaxy$activity)){
  act <- galaxy[i,2]
  galaxy[i,2]<- as.character(activity[act, 2])
}

#5. From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject.

samsung <- galaxy %>% group_by(subject, activity) %>% summarise_each(funs(mean))

#Finally, print to a file
write.table(samsung, file = "samsung.txt", row.names = FALSE)
samsung_test <- read.table("samsung.txt")
