# -----------------------
# Setting 
library(tree)
require(maptree)
library(randomForest)
setwd("/Users/aszostek/Projects/Kaggle/Titanic")
source("./Utils/submission_utils.R")

iteration = 7

# -----------------------
# Read Data
train.org <- read.csv(file="./Data/train.csv")
test.org <- read.csv(file="./Data/test.csv")


# -----------------------
# Data transoformations and feature creation

# Function to get the title of the passanger
gettitle<-function(name)
{
  lname<-sub("^.*, ","",name)
  lname<-sub("\\. .*$","",lname)
  return(lname)  
}

# Function which calculates an age for a given title Mr, Miss etc
# It uses information from both training and test set
# This function operates on original training set and test set!
age_title<-function()
{
  # take original data
  tr1<-train.org
  te1<-test.org
  # add survivor column to test set
  te1<-cbind(factor(sample(c(0,1),nrow(te1),replace=T),levels=c(0,1)),te1)
  names(te1)[[1]]<-"survived"
  # Combine two tables togethe
  all<-rbind(tr1,te1)
  # select only samples with age provided
  all<-all[!is.na(all$age),]

  # Extract only Mr, Miss. etc
  lname<-as.character(all[[3]])
  lname<-sub("^.*, ","",lname)
  lname<-sub("\\. .*$","",lname)
  
  all$title<-as.factor(lname)
  all<-all[,c("age","title","pclass")]    
  all$pclass <- as.factor(all$pclass)
  fit <- lm(age ~ title+pclass,data=all)  

  return(fit)
}


guess.age<-function(passanger)
{  
  return(predict(age_title(),newdata=passanger)[[1]])
}


data.transformation<-function(data)
{  
  # If embarked missing fill with most frequent option which is S
  data[data$embarked=="","embarked"]<-"S"  

  # calculate title of the passanger
  data$title <- unlist(lapply(as.character(data$name),function(x) gettitle(x)))
  
  
  # Clean classes of each column
  if(names(data)[[1]]=="survived") data$survived<-as.factor(data$survived)
  data$pclass<-as.factor(data$pclass)
  data$name<-as.character(data$name)
  data$ticket<-as.character(data$ticket)
  data$cabin<-as.character(data$cabin)
  data$embarked<-as.factor(as.character(data$embarked))
  data$title<-as.factor(as.character(data$title))
  
  # If it is a test set and doesn't have a survived column add one with fake data
  # it is useful to have the same number of columns in training and test set
  if(names(data)[[1]]!="survived") 
  {
    data<-cbind(factor(sample(c(0,1),nrow(data),replace=T),levels=c(0,1)),data)
    names(data)[[1]]<-"survived"
  }
  
  # Fill in missing age
  # This function guesses age based on the title of the passange

  for(i in 1:nrow(data))
  {
    if (is.na(data[i,"age"]))
      data[i,"age"]<-guess.age(data[i,])
  }
  
  
  return(data[,c(-3,-8,-9,-10,-12)])    
}


train <- data.transformation(train.org)
test <- data.transformation(test.org)

# -----------------------
# Modeling

# Train classification tree on a training set
t1<-tree(survived~.,data=train)
plot(t1)
text(t1)

# ------------------------
# Cross Validate
kfold.tree<-function(data,k)
{
  n<-as.integer(nrow(data)/k)
  err.vect<-rep(NA,k)
  for (i in 1:k)
  {
    subset<-((i-1)*n+1):(i*n)
    train<-data[-subset,]
    test<-data[subset,]
    treepred<-tree(survived~.,data=train)
    err<-sum(test[[1]]==predict(treepred,newdata=test,type="class"))/nrow(test)    
    err.vect[i]<-err
  }
  return(err.vect)
}

leavoneout.tree<-function(data)
{
  err.vect<-rep(NA,nrow(data))
  for (i in 1:nrow(data))
  {
    train<-data[c(-i),]
    test<-data[i,]
    treepred<-tree(survived~.,data=train)
    treepred<-tree(survived~.,data=train)
    err<-sum(test[[1]]==predict(treepred,newdata=test,type="class"))/nrow(test)    
    err.vect[i]<-err    
  }
  return(err.vect)
}


a<-kfold.tree(train,10)
a
mean(a)


b<-leavoneout.tree(train)
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

diffsub(6,7)

