library(randomForest)
# here I test random forest

# Make new datasets just from a set of columns (ignore columns 3, 8, 10 and 11)
tit3<-tit_new
test3<-test_new
test4<-test_new

t1<-randomForest(survived~.,data=tit3,mtry=3)
1-sum(tit3[[1]]!=predict(t1,tit3,type="response"))/nrow(tit3)
# apply tree to test set
t.randomForest<-predict(t1,newdata=test3,type="response")
test3[[1]]<-t.randomForest

# ------------
t1<-randomForest(survived~.,data=tit3,mtry=4)
1-sum(tit3[[1]]!=predict(t1,tit3,type="response"))/nrow(tit3)
# apply tree to test set
t.randomForest<-predict(t1,newdata=test3,type="response")
test4[[1]]<-t.randomForest

sum(test4[[1]]!=test3[[1]])

# See how accuracy depends on number of trees
btree<-function(x)
{
  y<-as.integer(x)
  t1<-randomForest(survived~.,data=tit3,ntree=y,mtry=4)
  return(1-sum(tit3[[1]]!=predict(t1,tit3,type="response"))/nrow(tit3))
}
n<-20
x<-seq(20,800,length.out=n)
y<-rep(NA,n)
for(i in 1:n) y[i]<-btree(x[i])
plot(x,y,xlab="number of trees",ylab="accuracy",ylim=c(0.95,1),main="Random forest")


# apply tree to test set
t.randomForest<-predict(t1,newdata=test3,type="response")

# merge prediction with test set
test.randomForest<-test
test.randomForest[[1]]<-t.randomForest


# Cross validate
cross.val.randomForest<-function(data,range)
{  
  train<-data[-range,]
  test<-data[range,]
  treepred<-randomForest(survived~.,data=train,ntree=1000,nodesize=10)
  err<-1-sum(test[[1]]!=predict(treepred,newdata=test,type="response"))/nrow(test)
  return(err)
}
#######################
k=5
n<-as.integer(nrow(data)/k)
err.vect<-rep(NA,k)
for (i in 1:k)
{
  subset<-((i-1)*n+1):(i*n)
  err.vect[i]<-cross.val.randomForest(tit3,subset)
}
mean(err.vect)

summary(err.vect)



