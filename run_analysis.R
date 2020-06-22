library(dplyr)

features<-read.table("/Users/HP/Documents/Rstudio/UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities<-read.table("/Users/HP/Documents/Rstudio/UCI HAR Dataset/activity_labels.txt", col.names = c("code","activity"))
subject_test<-read.table("/Users/HP/Documents/Rstudio/UCI HAR Dataset/test/subject_test.txt")
subject_test<-read.table("/Users/HP/Documents/Rstudio/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
X_test<-read.table("/Users/HP/Documents/Rstudio/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
Y_test<-read.table("/Users/HP/Documents/Rstudio/UCI HAR Dataset/test/Y_test.txt", col.names = "code")
subject_train<-read.table("/Users/HP/Documents/Rstudio/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
X_train<-read.table("/Users/HP/Documents/Rstudio/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
Y_train<-read.table("/Users/HP/Documents/Rstudio/UCI HAR Dataset/train/Y_train.txt", col.names = "code")

X<-rbind(X_train, X_test)
Y<-rbind(Y_train, Y_test)
subject<-rbind(subject_train, subject_test)
whole_data<-cbind(subject, X, Y)

mean_std<-select(whole_data, subject, code, contains("mean"), contains("std"))

mean_std$code<-activities[mean_std$code, 2]

names(mean_std)[1]<-"Subject"
names(mean_std)[2]<-"Activity"
names(mean_std)<-gsub("Acc", "Accelerometer", names(mean_std))
names(mean_std)<-gsub("Gyro", "Gyroscope", names(mean_std))
names(mean_std)<-gsub("Mag", "Magnitude", names(mean_std))
names(mean_std)<-gsub("BodyBody", "Body", names(mean_std))
names(mean_std)<-gsub("tBody", "TimeBody", names(mean_std))
names(mean_std)<-gsub("^t", "Time", names(mean_std))
names(mean_std)<-gsub("^f", "Frequency", names(mean_std))
names(mean_std)<-gsub("^a", "A", names(mean_std))
names(mean_std)<-gsub("gravity", "Gravity", names(mean_std))
names(mean_std)<-gsub("mean()", "Mean", names(mean_std))
names(mean_std)<-gsub("std()", "STD", names(mean_std))

TidyData <- mean_std %>%
  group_by(Subject, Activity) %>%
  summarise_all(funs(mean))

write.table(TidyData, "/Users/HP/Documents/Rstudio/TidyData.txt")
