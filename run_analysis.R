
##Creating data directory  if not present
if(!file.exists("./data")){dir.create("./data")}
##downloading the zipped file and unzipping it
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile="./data/data.zip",method="curl")
unzip(zipfile="./data/data.zip",exdir="./data")
fpath <- "./data/UCI HAR Dataset"


##reading Activity file from test and train
Test_Activity_Data <-read.table(file.path(fpath,"test","y_test.txt"),header=FALSE)
Train_Activity_Data <-read.table(file.path(fpath,"train","y_train.txt"),header=FALSE)
##reading Subject file from test and train
Test_Subject_Data <-read.table(file.path(fpath,"test","subject_test.txt"),header=FALSE)
Train_Subject_Data <-read.table(file.path(fpath,"train","subject_train.txt"),header=FALSE)
##reading Feature file from test and train
Test_Feature_Data <-read.table(file.path(fpath,"test","X_test.txt"),header=FALSE)
Train_Feature_Data <-read.table(file.path(fpath,"train","X_train.txt"),header=FALSE)

##Merging train and test data
Activity_Data <-rbind(Test_Activity_Data,Train_Activity_Data)
Subject_Data <-rbind(Test_Subject_Data,Train_Subject_Data)
Feature_Data <-rbind(Test_Feature_Data,Train_Feature_Data)

##setting names
names(Activity_Data) <-c("Activity")
names(Subject_Data) <-c("Subject")
Featurenames <-read.table(file.path(fpath,"features.txt"),header=FALSE)

names(Feature_Data) <-Featurenames$V2

##1.Merges the training and the test sets to create one data set.
Data_Temp <-cbind(Activity_Data,Subject_Data)
Data <-cbind(Feature_Data,Data_Temp)

##2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##Std and mean for each measurement
Mean_STD_Feature_Data <-Featurenames$V2[grep("mean\\(\\)|std\\(\\)",Featurenames$V2)]

selectedNames<-c(as.character(Mean_STD_Feature_Data), "Subject", "Activity")
Data <-subset(Data,select=selectedNames)


##3.Uses descriptive activity names to name the activities in the data set
Activity_Names <-read.table(file.path(fpath,"activity_labels.txt"),header=FALSE)

Data$Activity <- factor(Data$Activity, labels =Activity_Names$V2 )



##4.Appropriately labels the data set with descriptive variable names. 
names(Data) <-sub("^t","time",names(Data))
names(Data) <-sub("^f","Frequency",names(Data))
names(Data) <-sub("Acc","Accelerometer",names(Data))
names(Data) <-sub("Gyro","Gyroscope",names(Data))
names(Data) <-sub("Mag","Magnitude",names(Data))
names(Data) <-sub("BodyBody","Body",names(Data))


##5.creates a second, independent tidy data set with the creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(plyr)
Tidy_Data <-aggregate(. ~Subject + Activity,Data,mean)

## ordering by Subject and then Activity
Tidy_Data <-arrange(Tidy_Data,Subject,Activity)
##head(Tidy_Data)
## writing tidy data to file
write.table(Tidy_Data,file="Get_Clean_Assign.txt",sep=" ",row.names=FALSE)

