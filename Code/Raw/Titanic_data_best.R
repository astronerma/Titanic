library(tree)
require(maptree)

setwd("/Users/aszostek/Projects/Kaggle/Titanic")
tit <- read.csv(file="./Data/train.csv")
test <- read.csv(file="./Data/test.csv")

# Function to get the title of the passanger
title<-function(name)
{
  lname<-sub("^.*, ","",name)
  lname<-sub("\\. .*$","",lname)
  return(lname)  
}

# Function which calculates an age for a given title Mr, Miss etc
# It uses information from both training and test set
guess.age<-function(title)
{
  tr1<-tit
  te1<-test
  te1<-cbind(factor(sample(c(0,1),nrow(te1),replace=T),levels=c(0,1)),te1)
  names(te1)[[1]]<-"survived"
  
  all<-rbind(tr1,te1)
  lname<-as.character(all[[3]])
  
  # Extract only Mr, Miss. etc
  lname<-sub("^.*, ","",lname)
  lname<-sub("\\. .*$","",lname)
  
  all$name<-as.factor(lname)
  all2<-all[!is.na(all$age),]
  
  return(median(all2[all2$name==title,"age"]))
  
}

# ----------------------------
# Data transformation function to be added applied to both test and train data
data.transformation<-function(data)
{  
  # If embarked missing fill with most frequent option S
  data[data$embarked=="","embarked"]<-"S"  
  
  # Clean classes of each column
  if(names(data)[[1]]=="survived") data$survived<-as.factor(data$survived)
  data$pclass<-as.factor(data$pclass)
  data$name<-as.character(data$name)
  data$ticket<-as.character(data$ticket)
  data$cabin<-as.character(data$cabin)
  data$embarked<-as.factor(as.character(data$embarked))
  
  # If it is a test set and doesn't have a survived column add one
  if(names(data)[[1]]!="survived") 
  {
    data<-cbind(factor(sample(c(0,1),nrow(data),replace=T),levels=c(0,1)),data)
    names(data)[[1]]<-"survived"
  }
  # Add family column which is the sum of sibsp+parch+1
  data$family<-as.factor(as.numeric(as.character(data$sibsp))+as.numeric(as.character(data$parch))+1)

  # Fill in missing age
  # If age missing, relace with median value for all ages
  #data[is.na(data$age),"age"]<-median(data$age,na.rm=T)
  
  data$title<-sapply(data$name,function(x) title(x))
  
  for(i in 1:nrow(data))
  {
    if (is.na(data[i,"age"]))
      data[i,"age"]<-guess.age(data[i,"title"])
  }

  
  # If fare missing, replace with an median value
  data[is.na(data$fare),"fare"]<-median(data$fare,na.rm=T)

  
  # Clean the ticket number column
  data$ticket<-sub("^.* ","",data$ticket)
  data$ticket<-sub("LINE","0",data$ticket)
  data$ticket<-as.numeric(data$ticket)
  
  
  # Get rid of some of the columns
  # name, sibsp, parch, cabin
 
  return(data[,c(-3,-10,-12,-13)])    
}



tit_new<-data.transformation(tit)
test_new<-data.transformation(test)

