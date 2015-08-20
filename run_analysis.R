## 1. Merges the training and the test sets to create one data set.

A1<-read.table("GCDData/train/X_train.txt")
A2<-read.table("GCDData/train/y_train.txt")
A3<-read.table("GCDData/train/subject_train.txt")
B1<-read.table("GCDData/test/X_test.txt")
B2<-read.table("GCDData/test/y_test.txt")
B3<-read.table("GCDData/test/subject_test.txt")

A<-cbind(A3, A2, A1)
B<-cbind(B3, B2, B1)

Full <- rbind(A, B)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
 
features<-read.table("GCDData/features.txt")
features<-as.character(features$V2)
F<-c("Volunteer", "ActivityLabel", features)
colnames(Full) <- F

Extract1 <- Full[,grep("mean", colnames(Full))]
Extract2 <- Full[,grep("std", colnames(Full))]
ExtractFull <- cbind(Full$Volunteer, Full$ActivityLabel, Extract1, Extract2)
colnames(ExtractFull)[1]<-"Volunteer"
colnames(ExtractFull)[2]<-"ActivityLabel"


## 3. Uses descriptive activity names to name the activities in the data set

ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "1"] <- "Walking"
ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "2"] <- "WalkingUpstairs"
ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "3"] <- "WalkingDownstairs"
ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "4"] <- "Sitting"
ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "5"] <- "Standing"
ExtractFull$ActivityLabel[ExtractFull$ActivityLabel == "6"] <- "Laying"


## 4. Appropriately labels the data set with descriptive variable names. 


## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Averages<-aggregate(ExtractFull, by = list(ExtractFull$Volunteer, ExtractFull$ActivityLabel), FUN = mean)

set(Averages, j = 'Volunteer', value = NULL)
set(Averages, j = 'ActivityLabel', value = NULL)
colnames(Averages)[1] <- "Volunteer"
colnames(Averages)[2] <- "ActivityLabel"

	
write.table(Averages, file = "Averages.txt", row.name=FALSE).
