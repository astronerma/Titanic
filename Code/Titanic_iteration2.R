# -----------------------
# Setting 
library(tree)
require(maptree)
library(randomForest)
setwd("/Users/aszostek/Projects/Kaggle/Titanic")
iteration = 2

# -----------------------
# Read Data
train.org <- read.csv(file="./Data/train.csv")
test.org <- read.csv(file="./Data/test.csv")


# -----------------------
# Data transoformations and feature creation

data.transformation<-function(data)
{  
  # If embarked missing fill with most frequent option which is S
  data[data$embarked=="","embarked"]<-"S"  
  
  # Clean classes of each column
  if(names(data)[[1]]=="survived") data$survived<-as.factor(data$survived)
  data$pclass<-as.factor(data$pclass)
  data$name<-as.character(data$name)
  data$ticket<-as.character(data$ticket)
  data$cabin<-as.character(data$cabin)
  data$embarked<-as.factor(as.character(data$embarked))
  
  # If it is a test set and doesn't have a survived column add one with fake data
  # it is useful to have the same number of columns in training and test set
  if(names(data)[[1]]!="survived") 
  {
    data<-cbind(factor(sample(c(0,1),nrow(data),replace=T),levels=c(0,1)),data)
    names(data)[[1]]<-"survived"
  }
  
  # Fill in missing age
  # This function guesses age based on the title of the passange
  data[is.na(data$age),"age"]<-median(data$age,na.rm=T)  
    
  return(data[,c(-3,-8,-9,-10,-11)])    
}

train <- data.transformation(train.org)
test <- data.transformation(test.org)

# -----------------------
# Modeling

# Train classification tree on a training set
t1<-randomForest(survived~.,data=train,mtry=4)

# ------------------------
# Cross Validate
kfold.rf<-function(data,k)
{
  n<-as.integer(nrow(data)/k)
  err.vect<-rep(NA,k)
  for (i in 1:k)
  {
    subset<-((i-1)*n+1):(i*n)
    train<-data[-subset,]
    test<-data[subset,]
    forestpred<-randomForest(survived~.,data=train)
    err<-sum(test[[1]]==predict(forestpred,newdata=test,type="class"))/nrow(test)    
    err.vect[i]<-err
  }
  return(err.vect)
}

leavoneout.rf<-function(data)
{
  err.vect<-rep(NA,nrow(data))
  for (i in 1:nrow(data))
  {
    train<-data[c(-i),]
    test<-data[i,]
    forestpred<-randomForest(survived~.,data=train)
    err<-sum(test[[1]]==predict(forestpred,newdata=test,type="class"))/nrow(test)    
    err.vect[i]<-err    
  }
  return(err.vect)
}


a<-kfold.rf(train,10)
a
mean(a)

# Be careful very long calculation!
b<-leavoneout.rf(train)
b
mean(b)

# -----------------------
# Submission file

submission = predict(t1,newdata=test,type="class")
test_submission = test
test_submission[[1]] <- submission

# write file
submission_file_name = paste("./Submissions/submission",as.character(iteration),".csv",sep="")
submission_file_name

write.csv(test_submission,file=submission_file_name,row.names=FALSE)






