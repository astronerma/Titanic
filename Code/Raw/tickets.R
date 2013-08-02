

# select only numerical types of tickets
#numticket<-grep("^[a-zA-Z]",tit$ticket)

# remove all letters from the ticket number
tit3<-tit[,c(-3,-6,-7,-10)]

tit3$ticket<-sub("^.* ","",tit3$ticket)
tit3$ticket<-sub("LINE","0",tit3$ticket)
tit3$ticket<-as.numeric(tit3$ticket)
tit3$ticket


# train tree on a tit3 set (training set)
t1<-tree(survived~.,data=tit3)
plot(t1)
text(t1,pretty=1)
draw.tree(t1)
1-sum(tit3[[1]]!=predict(t1,tit3,type="class"))/nrow(tit3)

ncol(tit3)
head(tit3)