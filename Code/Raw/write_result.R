# This submission gave me 202 place with correct rate of 0.794 :)
#write.csv(test_new,file="./Data/result_v1.csv",row.names=FALSE,quote=c(3))
# This original tree gives the best result I ever got!

# New classification tree, pruned and with other variables included
write.csv(test3,file="./Data/result_v3.csv",row.names=FALSE,quote=c(3))


# Pure Random forest
write.csv(test3,file="./Data/result_v2.csv",row.names=FALSE,quote=c(3))

# also random forest but with different m parameter = 4
write.csv(test4,file="./Data/result_v4.csv",row.names=FALSE,quote=c(3))


# Normal classification tree
# Best result!!!! - saved in Titanic_data_best
# with normal unprunned classification tree!
write.csv(test3,file="./Data/result_v7.csv",row.names=FALSE,quote=c(3))

# Normal classification tree
# with normal unprunned classification tree!
# new fare and age and no family inclided in tree
write.csv(test3,file="./Data/result_v8.csv",row.names=FALSE,quote=c(3))


#```{r}
#randomForest.prediction<-t2
#test_new[[1]]<-randomForest.prediction
#write.csv(test_new,file="/Users/aszostek/Projects/Kaggle/Titanic/Data/result_v5.csv",row.names=FALSE,quote=c(3))
```
