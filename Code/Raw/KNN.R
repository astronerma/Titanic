# Make new datasets just from a set of columns (ignore columns 3, 8, 10 and 11)
tit3<-tit[,c(-3,-8,-10,-11)]
test3<-test[,c(-3,-8,-10,-11)]


cross.val.KNN<-function(data,range)
{ 
  train<-data[-range,]
  test<-data[range,]
  cl<-train[[1]]
  cl0<-test[[1]]
  train<-train[,-1]
  test<-test[,-1]
  val<-knn(train,test,cl,k=3)
  err<-sum(cl0[[1]]==val)/nrow(test)
  return(err)
}
#######################
k=10
n<-as.integer(nrow(data)/k)
err.vect<-rep(NA,k)
for (i in 1:k)
{
  subset<-((i-1)*n+1):(i*n)
  err.vect[i]<-cross.val.KNN(tit4[,-3],subset)
}
mean(err.vect)


i=4
subset<-((i-1)*n+1):(i*n)
err.vect[i]<-cross.val.KNN(tit4[,-3],subset)


tit3[[3]]<-as.numeric(tit3[[3]])
tit4<-data.frame(apply(tit3,2,as.numeric))
head(tit4)
class(as.numeric(tit3[[3]]))

t1<-randomForest(survived~.,data=tit3,ntree=100)



1-sum(tit3[[1]]!=predict(t1,tit3,type="response"))/nrow(tit3)
