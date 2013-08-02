# Make new datasets just from a set of columns (ignore columns 3, 8, 10 and 11)
tit3<-tit_new
test3<-test_new

# train tree on a tit3 set (training set)
t1<-tree(survived~.,data=tit3)
plot(t1)
text(t1,pretty=1)

# accuracy rate
1-sum(tit3[[1]]!=predict(t1,tit3,type="class"))/nrow(tit3)

#draw.tree(t1)
#################################

# apply tree to test set
t2<-prune.tree(t1,best=6)
t3<-predict(t1,newdata=test3,type="class")

# merge prediction with test set
test3[[1]]<-t3

# Go to write results
# results_v1.csv

# ---------------------------
# CV tree
cv<-cv.tree(t1,FUN=prune.tree,method="misclass")
plot(cv)

pt1 <- prune.tree(t1,best=9)
misclass.tree(pt1)
summary(pt1)
#pdf(file="./figures/pruned_tree.pdf",height=5,width=5)
plot(pt1)
text(pt1)






