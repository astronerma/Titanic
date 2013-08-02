# Make new datasets just from a set of columns (ignore columns 3, 8, 10 and 11)
tit3<-tit_new
test3<-test_new


glm(survived~.,family="binomial",)