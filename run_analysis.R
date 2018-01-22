# Download and Unzip dataSet to /data directory

if(!file.exists("./data")){
  dir.create("./data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Reading trainings tables

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector

features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels

activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Assigning column names

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# Merging all data in one set

merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(merge_train, merge_test)

# Extracting the mean and standard deviation of each measurement

colNames <- colnames(setAllInOne)

meanAndStddev <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

setForMeanAndStddev <- setAllInOne[ , meanAndStddev == TRUE]

# Using descriptive activity to name the activities of the data set

setWithActivityNames <- merge(setForMeanAndStddev, activityLabels,
                              by='activityId',
                              all.x=TRUE)

# Creating a second, independent tidy data set
# with the average of each variable for each activity and each subject

secondTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secondTidySet <- secondTidySet[order(secondTidySet$subjectId, secondTidySet$activityId),]

write.table(secondTidySet, "TidySet.txt", row.name=FALSE)