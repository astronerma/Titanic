cross.val.tree<-function(data,range,size)
{  
  # Define datasets
  train<-data[-range,]
  test<-data[range,]
  # Train the tree
  treepred<-tree(survived~.,data=train)
  # Prune the tree
  pt1<-prune.tree(treepred,best=size)
  # Use pruned tree on the test set
  err<-sum(test[[1]]==predict(pt1,newdata=test,type="class"))/nrow(test)
  return(err)
}
#######################
k=5
n<-as.integer(nrow(tit3)/k)
err.vect<-rep(NA,k)
for (i in 1:k)
{
  subset<-((i-1)*n+1):(i*n)
  err.vect[i]<-cross.val.tree(tit3,subset,6)
}
mean(err.vect)
summary(err.vect)
############

