# Getting and Cleaning Data Course Project

## You should create one R script called run_analysis.R that does the following:

Make sure the documents are in the correct working directory. I renamed my directories and folders as follows:
Working directory = WD
Directory containing data within WD = GCDData


## 1. Merges the training and the test sets to create one data set.
Start by reading the files into R using the read.table() command.

A1<-read.table("GCDData/train/X_train.txt")
A2<-read.table("GCDData/train/y_train.txt")
A3<-read.table("GCDData/train/subject_train.txt")
B1<-read.table("GCDData/test/X_test.txt")
B2<-read.table("GCDData/test/y_test.txt")
B3<-read.table("GCDData/test/subject_test.txt")

Then we attach the columns containing the subject id and the activity to the relevant data.

A<-cbind(A3, A2, A1)
B<-cbind(B3, B2, B1)

Lastly, we can combine the two data.frames.

Full <- rbind(A, B)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

First, I inserted all of the column labels as listed in the features.txt (replacing the automated V# labels).
To do this I first had to: 
1) read the labels into R; 
2) select only the second column containg the character labels from features.txt; 
3)add two labels representing the two added columns, volunteers and activity labels; and 
4) substitute the auto-generated labels.

features<-read.table("GCDData/features.txt")
features<-as.character(features$V2)
F<-c("Volunteer", "ActivityLabel", features)
colnames(Full) <- F

With the variable names attached, we can now extract and subset the columns measuring the mean and standard deviation of the other data. 

Extract1 <- Full[,grep("mean", colnames(Full))]
Extract2 <- Full[,grep("std", colnames(Full))]
ExtractFull <- cbind(Full$Volunteer, Full$ActivityLabel, Extract1, Extract2)
colnames(ExtractFull)[1]<-"Volunteer"
colnames(ExtractFull)[2]<-"ActivityLabel"


## 3. Uses descriptive activity names to name the activities in the data set

We have a list of descriptive names given to us in the file activity_labels.txt. 
We can then replace the numeric code ActivityLabel code with the descriptive names.

ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "1"] <- "Walking"
ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "2"] <- "WalkingUpstairs"
ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "3"] <- "WalkingDownstairs"
ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "4"] <- "Sitting"
ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "5"] <- "Standing"
ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "6"] <- "Laying"


## 4. Appropriately labels the data set with descriptive variable names. 

The variables already have the descriptive name labels we substituted in the beginning of part 2.
We can use colnames(ExtractFull) <- c(list) if we wanted to substitute different names. 
If we wanted to change a particular label, we can use colnames(ExtractFull)[x] <- "Label"


## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Using the labels we can apply the aggregate function to output a data.frame with the mean of the sublabeled data.


Averages<-aggregate(ExtractFull, by = list(ExtractFull$Volunteer, ExtractFull$ActivityLabel), FUN = mean)

Unfortunately the Averages data.frame also returns NAs in an additional column containing the activity labels. It also contains a repeated column with the volunteer names.
The groupings have been inserted as the first two columns in the Averages data.frame.
We can simply remove the surplus Volunteer and ActivityLabel columns and then relabel the first two columns as "Volunteer" and "Activity Label".

set(Averages, j = 'Volunteer', value = NULL)
set(Averages, j = 'ActivityLabel', value = NULL)
colnames(Averages)[1] <- "Volunteer"
colnames(Averages)[2] <- "ActivityLabel"


And lastly we can save this new data set as a text file (in this case, Averages.txt) using: 
	
write.table(Averages, file = "Averages.txt", row.name=FALSE).