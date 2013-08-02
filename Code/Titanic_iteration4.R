# -----------------------
# Setting 
library(tree)
require(maptree)
library(randomForest)
setwd("/Users/aszostek/Projects/Kaggle/Titanic")
iteration = 4

# -----------------------
# Read Data
train.org <- read.csv(file="./Data/train.csv")
test.org <- read.csv(file="./Data/test.csv")

# -----------------------
# Data transoformations and feature creation

# Function to get the title of the passanger
title<-function(name)
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
  all<-all[,c("age","title")]    
  return(by(all[[1]],all[[2]],mean))
}
a<-age_title()

guess.age<-function(title)
{
  return(age_title()[title][[1]])
}


data.transformation<-function(data)
{  
  # If embarked missing fill with most frequent option which is S
  data[data$embarked=="","embarked"]<-"S"  

  # calculate title of the passanger
  data$title <- unlist(lapply(as.character(data$name),function(x) title(x)))
  
  
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
  
  #for(i in 1:nrow(data))
  #{
  #  if (is.na(data[i,"age"]))
      #data[i,"age"]<-guess.age(data[i,"title"])
  #}
  
  
  return(data[,c(-3,-8,-9,-10,-12)])    
}

train <- data.transformation(train.org)
test <- data.transformation(test.org)
trainf <- train[train$sex=="female",]
trainm <- train[train$sex=="male",]


# -----------------------
# Modeling

# Train classification tree on a training set
t1<-tree(survived~.,data=trainf)
plot(t1)
text(t1)

p1 <- predict(t1,newdata=trainf,type="class")
sum(trainf[[1]]==p1)/nrow(trainf)


t2<-tree(survived~.,data=trainm)
plot(t2)
text(t2)
p2 <- predict(t2,newdata=trainm,type="class")
sum(trainm[[1]]==p2)/nrow(trainm)


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

plot(cv.tree(t1))
plot(cv.tree(t2))

a<-kfold.tree(trainf,4)
a
mean(a)


t1.p<-prune.tree(t1,best=4)
plot(t1.p)
text(t1.p)
plot(t1)
text(t1)


a<-kfold.tree(train,4)
a
mean(a)


b<-leavoneout.tree(train)
b
mean(b)

# -----------------------
# Submission file

# prediction based on decision tree model separate for genders
predtree <- function(testdata,modelf,modelm)
{
  predvect <- factor(rep(NA,nrow(testdata)),levels=c(0,1))
  for (i in 1:nrow(testdata))
  {
    p <- testdata[i,]
    if(p$sex=="female")
    {
      predvect[i] <- predict(modelf,newdata=p,type="class")
    }
    else
    {
      predvect[i] <- predict(modelm,newdata=p,type="class")
    }
  }
  return (predvect)
}

# Train pruned trees
t1<-tree(survived~.,data=trainf)
t2<-tree(survived~.,data=trainm)
t1.p <- prune.tree(t1,best=4)
t2.p <- prune.tree(t2,best=5)

# This is prediction test for training set only
p1 <- predtree(train,t1.p,t2.p)
sum(p1 == train[[1]])/nrow(train)


# -------------------------------
# Submission
submission = predtree(test,t1.p,t2.p)
test_submission = test
test_submission[[1]] <- submission

# write file
submission_file_name = paste("./Submissions/submission",as.character(iteration),".csv",sep="")
submission_file_name

write.csv(test_submission,file=submission_file_name,row.names=FALSE)


# ----------------------------------
# Calculate differences between two submission files
diffsub<-function(s1,s2)
{
  f1 <- paste("./Submissions/submission",as.character(s1),".csv",sep="")
  f2 <- paste("./Submissions/submission",as.character(s2),".csv",sep="")
  sub1 <- read.csv(file=f1)
  sub2 <- read.csv(file=f2)
  ct <- 0
  for (i in 1:nrow(sub1))
  {
   
    if (sub1[i,1] != sub2[i,1])
    {
      ss <- paste("i = ",as.character(i),"   sub1 = ",as.character(sub1[i,1]),"   sub2 = ",as.character(sub2[i,1]),sep="")
      print(ss)
      ct <- ct + 1
    }
  }
  return(ct)  
}

diffsub(3,4)



