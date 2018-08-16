library(dplyr)
# getting data from zip file 
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}

# unzip zip file containing data if data directory doesn't already exist
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}

#reading data from zip file
## training data 
trainingSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(dataPath, "train", "y_train.txt"))

##reading test data
testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"))


# read features
features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)

# read activity labels
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")

#1. merge training and test data sets 
  dataTrain <- read.table(file.path(dataDir,"train/X_train.txt"))
  dataTest <- read.table(file.path(dataDir,"test/X_test.txt"))
  
  dataAll <- rbind(dataTrain,dataTest)
  names(dataAll) <- colNames[,2]
  
  #subsetting the dataset to include only columns of mean and std
  
  colMatch <- grep("(mean|std)\\(\\)", names(dataAll))
  dataSet <- dataAll[, colMatch]

# renaming column names
names(dataSet) <- gsub("^f", "frequencyDomain", names(dataSet))
names(dataSet) <- gsub("^t", "timeDomain", names(dataSet))
names(dataSet) <- gsub("Acc", "Accelerometer", names(dataSet))
names(dataSet) <- gsub("Gyro", "Gyroscope", names(dataSet))
names(dataSet) <- gsub("Mag", "Magnitude", names(dataSet))
names(dataSet) <- gsub("Freq", "Frequency", names(dataSet))
names(dataSet) <- gsub("mean", "Mean", names(dataSet))
names(dataSet) <- gsub("std", "StandardDeviation", names(dataSet))

# correct typo
names(dataSet) <- gsub("BodyBody", "Body", names(dataSet))

# use new labels as column names
colnames(dataSet) <- names(dataSet)

#dataTidy
dataTidy <- cbind(Subject= subjectAll,Activity = activityNames, dataSet)

#grouping data by subject and activity 
dataGrouped <- ddply(dataTidy, .(Subject, Activity), function(data){colMeans(data[,-c(1,2)])})
names(dataGrouped)[-c(1,2)] <- paste0("Mean", names(dataGrouped)[-c(1,2)])

#writing the data into a .txt file
  write.table(dataGrouped, "GroupedDataSummarizedByMeans.txt", row.names = FALSE)
  
  #returning the final data
  head(dataGrouped)
 }
