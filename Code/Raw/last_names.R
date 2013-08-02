data.transformation2<-function(data)
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
  
  # If fare missing, replace with an median value
  data[is.na(data$fare),"fare"]<-median(data$fare,na.rm=T)
  
  
  # Clean the ticket number column
  data$ticket<-sub("^.* ","",data$ticket)
  data$ticket<-sub("LINE","0",data$ticket)
  data$ticket<-as.numeric(data$ticket)
  
  
  # Get rid of some of the columns
  # name, sibsp, parch, cabin
  
  return(data[,c(-10)])    
}

tr1<-data.transformation2(tit)
te1<-data.transformation2(test)

all<-rbind(tr1,te1)
lname<-as.character(all[[3]])

# Extract only Mr, Miss. etc
lname<-sub("^.*, ","",lname)
lname<-sub("\\. .*$","",lname)

all$name<-as.factor(lname)
lname
table(all$name)

all2<-all[!is.na(all$age),]
table(all2$name)

hist(all2[all2$name=="Mrs","age"])
median(all2[all2$name=="Mrs","age"])

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

for(i in 1:nrow(tit))
{
  if (is.na(tit[i,"age"]))
      tit[i,"age"]<-guess.age(title(tit[i,"name"]))  
}


sapply(tit$name,function(x) title(x))

guess.age(title(tit[40,"name"]))

lapply(tit3$age,function(x) if(is.na(x)) guess.age(title())


guess.age("Miss")

# Make new datasets just from a set of columns (ignore columns 3, 8, 10 and 11)
tit3<-tit[,c(-8,-9,-10,-11)]
test3<-test[,c(-8,-9,-10,-11)]
tit3[[3]]<-lname

# train tree on a tit3 set (training set)
t1<-tree(survived~.,data=tit3)
plot(t1)
text(t1,pretty=1)
draw.tree(t1)
1-sum(tit3[[1]]!=predict(t1,tit3,type="class"))/nrow(tit3)


tit[c(107,108,114,115),]

tit[tit$sex=="female" & tit$pclass==3 & tit$age < 30,c(1,3,5,6,7,8)][1:20,]
tit[grep("Asplund",tit$name),c(1,2,3,4,5,6,7,8)]

tit[tit$sibsp==2,c(1,2,3,4,5,6,7,8,11)]
