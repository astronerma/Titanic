# In this classification tree: when age is available I use it 
# And calculate a second tree for data without age information!!

setwd("/Users/aszostek/Projects/Kaggle/Titanic")
tit <- read.csv(file="./Data/train.csv")
test <- read.csv(file="./Data/test.csv")
test<-cbind(rep(0,nrow(test)),test)
names(test)[1]<-"survived"

# -----------------
# Adjust classes of data
#tit$survived<-as.factor(as.character(tit$survived))
tit$survived<-as.factor(tit$survived)
tit$pclass<-as.factor(tit$pclass)
tit$name<-as.character(tit$name)
tit$sibsp<-as.integer(tit$sibsp)
tit$parch<-as.factor(tit$parch)
tit$ticket<-as.character(tit$ticket)
tit$cabin<-as.character(tit$cabin)
tit$embarked<-as.factor(tit$embarked)

# Same for test set
test$pclass<-as.factor(test$pclass)
test$name<-as.character(test$name)
test$sibsp<-as.integer(test$sibsp)
test$parch<-as.factor(test$parch)
test$ticket<-as.character(test$ticket)
test$cabin<-as.character(test$cabin)
test$embarked<-as.factor(test$embarked)

# divide data into age and no age
titAGE<-tit[!is.na(tit$age),c(-3,-8,-10,-11,-9)]
titNOAGE<-tit[is.na(tit$age),c(-3,-8,-10,-11,-5,-9)]

# train tree on a titAGE set (training set)
t1<-tree(survived~.,data=titAGE)
plot(t1)
text(t1,pretty=1)
draw.tree(t1)
1-sum(titAGE[[1]]!=predict(t1,titAGE,type="class"))/nrow(titAGE)

# train tree on a titNOAGE set (training set)
t1<-tree(survived~.,data=titNOAGE)
plot(t1)
text(t1,pretty=1)
draw.tree(t1)
1-sum(titNOAGE[[1]]!=predict(t1,titNOAGE,type="class"))/nrow(titNOAGE)



# apply tree to test set
t2<-predict(t1,newdata=test3,type="class")

# merge prediction with test set
test_new<-test
test_new[[1]]<-t2

# Go to write results
# results_v1.csv