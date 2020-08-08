#cleaning and merging data

#############################################################################

make sure you save files in the same working directory you are working in.

#############################################################################

#firstly,install dplyr package
library(dplyr)

#load zip file into a variable
file1 <- "Coursera_DS3_Final.zip"

#if zip file doesnt exist
if (!file.exists(file1))
{
  loading fileURL
  fileURL <-"getdata_projectfiles_UCI HAR Dataset"
  
  #download file
  download.file(fileURL, file1, method="curl")
}

#if zip file exists
if (!file.exists("UCI HAR Dataset")) 
{ 
  #unzip file
  unzip(file1) 
}

#reading features table
features <- read.table("UCI HAR Dataset/features.txt", 
                       col.names = c("n","functions"))

#reading activities table
activities <- read.table("UCI HAR Dataset/activity_labels.txt", 
                         col.names = c("code", "activity"))
                         
#reading subject test                         
subject_test <- read.table("subject_test.txt", col.names = "subject")
#reading test
x_test <- read.table("test/X_test.txt", col.names = features$functions
y_test <- read.table("test/y_test.txt", col.names = "code")

#reading subject train
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
#reading train
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

#row binding the read files
a<- rbind(x_train, x_test)
b<- rbind(y_train, y_test)
doc<- rbind(subject_train, subject_test)

#column binding the resulted row bind
Merged_Data <- cbind(doc, b, a)

#extracts data contains mean and std
TidyData <- Merged_Data %>% select(doc, code, 
                                   contains("mean"), contains("std"))
#naming activity
TidyData$code <- activities[TidyData$code, 2]

#avarage of activity and subject
FinalData <- TidyData %>% group_by(subject, activity) %>% summarise_all(funs(mean))

#capturing the output of final data
finaldoc<- capture.output(FinalData)

#copying it to the required file
cat("merged",file="tidydata.txt,apend=T)

#end
