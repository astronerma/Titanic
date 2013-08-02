setwd("/Users/aszostek/Projects/Kaggle/Titanic")
tit <- read.csv(file="./Data/train.csv")

# Plot % of survivors per class
# The pssangers from first class survived on average 60% while the ones in 3rd only about 25%
surv<-tit[tit$survived==1,]
a<-as.vector(by(surv,surv$pclass,nrow))
b<-as.vector(by(tit,tit$pclass,nrow))
plot(a/b)

# Plot % of survivors per gender
# Female were far more likely to survive than men
# 70% of women and only 20% of men
surv<-tit[tit$survived==1,]
a<-as.vector(by(surv,surv$sex,nrow))
b<-as.vector(by(tit,tit$sex,nrow))
plot(a/b)

# Plot % of survivors per age group
# It seems that older people were more probable to survive, and babies
# But it could be due to small number of very old people
tit2<-tit[complete.cases(tit$age),]
age.gr<-cut(tit2$age,c(0,13.5,30,50,80))
#age.gr<-cut(tit2$age,4)

# Plot % of survivors per sibsp
# It seems that older people were more probable to survive, and babies
# But it could be due to small number of very old people
surv<-tit[tit$survived==1,]
a<-as.vector(by(surv,surv$sibsp,nrow))
b<-as.vector(by(tit,tit$sibsp,nrow))
plot(a/b,ylim=c(0,1))

# Plot % of survivors per parch
# It seems that older people were more probable to survive, and babies
# But it could be due to small number of very old people
surv<-tit[tit$survived==1,]
a<-as.vector(by(surv,surv$parch,nrow))
b<-as.vector(by(tit,tit$parch,nrow))
plot(a/b,ylim=c(0,1))




tit2$age<-age.gr
surv<-tit2[tit2$survived==1,]
a<-as.vector(by(surv,surv$age,nrow))
b<-as.vector(by(tit2,tit2$age,nrow))
plot(a/b)

# Lets see is some variables are skewed and it would be good to take a log of them
hist(tit[[5]])

mean(tit[!is.na(tit$age),c(5)])
sd(tit[!is.na(tit$age),c(5)])
rnorm()
table(age.gr)

# distribution of survival among people with missing age information
tit0 <- read.csv(file="./Data/train.csv")
table(tit0[is.na(tit0$age),1])


# Fare vs class
plot(tit$pclass,log10(tit$fare))
hist(log10(tit$fare))
hist(tit[tit$pclass==3,"fare"])


# What does the fare depend on:
plot(as.numeric(as.character(tit[tit$pclass==3,"sibsp"])),tit[tit$pclass==3,"fare"])

plot(as.factor(as.numeric(as.character(tit[tit$pclass==3,"sibsp"]))+as.numeric(tit[tit$pclass==3,"parch"])),tit[tit$pclass==3,"fare"])

plot(as.numeric(as.character(tit[tit$pclass==3 & tit$survived==0,"sibsp"]))+as.numeric(tit[tit$pclass==3 & tit$survived==0,"parch"]),tit[tit$pclass==3 & tit$survived==0,"fare"],pch=19,col="blue",ylim=c(0,2))

points(as.numeric(as.character(tit[tit$pclass==3 & tit$survived==1,"sibsp"]))+as.numeric(tit[tit$pclass==3 & tit$survived==1,"parch"]),tit[tit$pclass==3 & tit$survived==1,"fare"],pch=19,col="red",ylim=c(0,2))







