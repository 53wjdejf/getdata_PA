# Getting and Cleaning Data Peer Assessment

## First, Reading

I downloaded data in my working directory manually, and read the data 
```{r}
#Set the URL
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download and unzip the file
download.file(fileUrl, destfile = "UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip")

features <- read.table("./UCI HAR Dataset/features.txt")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

Stest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")

Strain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
```

And I did the following steps given by the manual. (not in given sequence)

##2. Extracts only the measurements on the mean and standard deviation for each measurement.

First, I used 'grep' function to find the word "mean" and "std" (including "meanFreq()").
I applied 'grep' respectively, combind them to "sorted". And used 'sort' function to array in increasing order.
```{r}
std <- grep("std", features[,2])
m <- grep("mean", features[,2])
sorted <- sort(union(std, m))
```

##4. Appropriately labels the data set with descriptive variable names.

I made "label" to be used as column names of processed(column binded) data.
I added "subject" and "activity" since first two names are missing in 'features' data.
```{r}
library(dplyr)
label <- combine("subject", "activity", features[sorted,2])
```

Combinding the data, used subset to reduce the dimension. 
Replaced the column names of 'test', and 'train' data into 'label'
```{r}
test <- cbind(Stest, Ytest, Xtest[, sorted])
colnames(test) <- label
train <- cbind(Strain, Ytrain, Xtrain[, sorted])
colnames(train) <- label
```

##1. Merges the training and the test sets to create one data set.

Using 'arrange' function, 'test' and 'train' are merged and arranged by subject number simultaneously.
'galaxy' is the merged data.
```{r}
galaxy <- arrange(rbind(test, train), subject)
```

##3. Uses descriptive activity names to name the activities in the data set

For all activity column, I replace the number into activity names. I'll take some time to execute.
By that, 'galaxy' is adjusted.
```{r}
for (i in 1:length(galaxy$activity)){
  act <- galaxy[i,2]
  galaxy[i,2]<- as.character(activity[act, 2])
}
```

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

I grouped the 'galaxy' by subject and activity. (based on all combination of 'subject' and 'activity')
and summarise all the variables(into average) by summarise_each function.
```{r}
samsung <- galaxy %>% group_by(subject, activity) %>% summarise_each(funs(mean))
```

##Finally, printing to a file

row.names = FALSE, but col.names=TRUE (by default)
'samsung_test' is test file.
```{r}
write.table(samsung, file = "samsung.txt", row.names = FALSE)
samsung_test <- read.table("samsung.txt")
```
