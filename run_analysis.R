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
dedcomb<-redcomb

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