library(e1071)

# Make new datasets just from a set of columns (ignore columns 3, 8, 10 and 11)
tit3<-tit_new
test3<-test_new

nb1<-naiveBayes(survived ~.,data=tit3)

1-sum(tit3[[1]]!=predict(nb1,tit3,type="class"))/nrow(tit3)


