library('e1071')

tit3<-tit_new
test3<-test_new

# train tree on a tit3 set (training set)
t1<-svm(survived~.,data=tit3,scale=T,type="C",kernel="polynomial",degree=2)
1-sum(tit3[[1]]!=predict(t1,tit3,type="class"))/nrow(tit3)

# Cross validaton showed that I should be getting similar results

# apply tree to test set
t2<-predict(t1,newdata=test3,type="class")

# merge prediction with test set
test_new<-test
test_new[[1]]<-t2

# Go to write results
# results_v2.csv


