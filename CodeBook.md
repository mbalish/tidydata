Tidy Data Set
========================================================

We have used the data set:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

###

We have created an R script called run_analysis.R
that does the required:  

-1.Merges the training and the test sets to create one data set.  
-2. Extracts only the measurements on the mean and standard deviation for each measurement.   
-3. Uses descriptive activity names to name the activities in the data set  
-4. Appropriately labels the data set with descriptive variable names.   
-5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.   
-6. stores that as a table tidy.txt  

####  
HERE IS THE CODE:  
...{r run_analysis}  
#make sure the plyr package is loaded  
library(plyr)

#make sure data downloaded and unzipped  
#remember to setwd("UCI HAR Dataset")  

#read data, subject and test type for test set  
testset<-read.table("./test/X_test.txt")  
subjecttest<-read.table("./test/subject_test.txt")  
ytest<-read.table("./test/Y_test.txt")  
#read data, subject and test type for test set  
trainset<-read.table("./train/X_train.txt")  
subjecttrain<-read.table("./train/subject_train.txt")  
ytrain<-read.table("./train/Y_train.txt")  

#combine the test and train sets  
test<-cbind(subjecttest,ytest,testset)  
train<-cbind(subjecttrain,ytrain,trainset)  
allcomb<-rbind(test,train)  

# read in the features for labels and remove some characters  

features<-read.table("features.txt")  
featuresmod<-sub(",","_",features[,2])  
featuresmod<-sub("()","",featuresmod)  
featuresmod<-c("subjext","task",featuresmod)  

#use these as the names of the columns in the combined data set  
names(allcomb)<-featuresmod  

#reduce the number of columns by using grep to find mean and std columns  
redcomb<-allcomb[,grep("*((std)|((m|M)ean)|(std))",featuresmod)]  

#add back and label the important subject and task columns  
redcomb<-cbind(allcomb[,1],allcomb[,2],redcomb)  
names(redcomb)[1]<-"subjects"  
names(redcomb)[2]<-"task"  

# make a copy  

#work on the copy  
#substitute appropriate names intead of numbers for the tasks  
dedcomb[,2]<-sub("1","walking",dedcomb[,2])  
dedcomb[,2]<-sub("2","walking_upstairs",dedcomb[,2])  
dedcomb[,2]<-sub("3","walking_downstairs",dedcomb[,2])  
dedcomb[,2]<-sub("4","sitting",dedcomb[,2])  
dedcomb[,2]<-sub("5","standing",dedcomb[,2])  
dedcomb[,2]<-sub("6","laying",dedcomb[,2])  

#convert the column to factor  
as.factor(dedcomb[,2])  

#use the plyr function ddply to create the means  
poo<-ddply(dedcomb,.(subjects,task),numcolwise(mean))  

#the result is 180 observations of 88 variables  
#write this as a table with a header  
write.table(poo,"tidy.txt")  
...  

The final Variable Names are:  
 [1] "subjects"                            
 [2] "task"                                
 [3] "tBodyAcc.mean...X"                   
 [4] "tBodyAcc.mean...Y"                   
 [5] "tBodyAcc.mean...Z"                   
 [6] "tBodyAcc.std...X"                    
 [7] "tBodyAcc.std...Y"                    
 [8] "tBodyAcc.std...Z"                    
 [9] "tGravityAcc.mean...X"                
[10] "tGravityAcc.mean...Y"                
[11] "tGravityAcc.mean...Z"                
[12] "tGravityAcc.std...X"                 
[13] "tGravityAcc.std...Y"                 
[14] "tGravityAcc.std...Z"                 
[15] "tBodyAccJerk.mean...X"               
[16] "tBodyAccJerk.mean...Y"               
[17] "tBodyAccJerk.mean...Z"               
[18] "tBodyAccJerk.std...X"                
[19] "tBodyAccJerk.std...Y"                
[20] "tBodyAccJerk.std...Z"                
[21] "tBodyGyro.mean...X"                  
[22] "tBodyGyro.mean...Y"                  
[23] "tBodyGyro.mean...Z"                  
[24] "tBodyGyro.std...X"                   
[25] "tBodyGyro.std...Y"                   
[26] "tBodyGyro.std...Z"                   
[27] "tBodyGyroJerk.mean...X"              
[28] "tBodyGyroJerk.mean...Y"              
[29] "tBodyGyroJerk.mean...Z"              
[30] "tBodyGyroJerk.std...X"               
[31] "tBodyGyroJerk.std...Y"               
[32] "tBodyGyroJerk.std...Z"               
[33] "tBodyAccMag.mean.."                  
[34] "tBodyAccMag.std.."                   
[35] "tGravityAccMag.mean.."               
[36] "tGravityAccMag.std.."                
[37] "tBodyAccJerkMag.mean.."              
[38] "tBodyAccJerkMag.std.."               
[39] "tBodyGyroMag.mean.."                 
[40] "tBodyGyroMag.std.."                  
[41] "tBodyGyroJerkMag.mean.."             
[42] "tBodyGyroJerkMag.std.."              
[43] "fBodyAcc.mean...X"                   
[44] "fBodyAcc.mean...Y"                   
[45] "fBodyAcc.mean...Z"                   
[46] "fBodyAcc.std...X"                    
[47] "fBodyAcc.std...Y"                    
[48] "fBodyAcc.std...Z"                    
[49] "fBodyAcc.meanFreq...X"               
[50] "fBodyAcc.meanFreq...Y"               
[51] "fBodyAcc.meanFreq...Z"               
[52] "fBodyAccJerk.mean...X"               
[53] "fBodyAccJerk.mean...Y"               
[54] "fBodyAccJerk.mean...Z"               
[55] "fBodyAccJerk.std...X"                
[56] "fBodyAccJerk.std...Y"                
[57] "fBodyAccJerk.std...Z"                
[58] "fBodyAccJerk.meanFreq...X"           
[59] "fBodyAccJerk.meanFreq...Y"           
[60] "fBodyAccJerk.meanFreq...Z"           
[61] "fBodyGyro.mean...X"                  
[62] "fBodyGyro.mean...Y"                  
[63] "fBodyGyro.mean...Z"                  
[64] "fBodyGyro.std...X"                   
[65] "fBodyGyro.std...Y"                   
[66] "fBodyGyro.std...Z"                   
[67] "fBodyGyro.meanFreq...X"              
[68] "fBodyGyro.meanFreq...Y"              
[69] "fBodyGyro.meanFreq...Z"              
[70] "fBodyAccMag.mean.."                  
[71] "fBodyAccMag.std.."                   
[72] "fBodyAccMag.meanFreq.."              
[73] "fBodyBodyAccJerkMag.mean.."          
[74] "fBodyBodyAccJerkMag.std.."           
[75] "fBodyBodyAccJerkMag.meanFreq.."      
[76] "fBodyBodyGyroMag.mean.."             
[77] "fBodyBodyGyroMag.std.."              
[78] "fBodyBodyGyroMag.meanFreq.."         
[79] "fBodyBodyGyroJerkMag.mean.."         
[80] "fBodyBodyGyroJerkMag.std.."          
[81] "fBodyBodyGyroJerkMag.meanFreq.."     
[82] "angle.tBodyAccMean_gravity."         
[83] "angle.tBodyAccJerkMean._gravityMean."
[84] "angle.tBodyGyroMean_gravityMean."    
[85] "angle.tBodyGyroJerkMean_gravityMean."
[86] "angle.X_gravityMean."                
[87] "angle.Y_gravityMean."                
[88] "angle.Z_gravityMean."      