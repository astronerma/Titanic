plot(as.numeric(as.character(tit_new$pclass)),tit_new$fare/as.numeric(as.character(tit_new$family)),ylim=c(-10,550))

plot(as.numeric(as.character(tit_new$pclass)),tit_new$fare,ylim=c(-10,550))

by(as.numeric(as.character(tit_new$fare))/as.numeric(as.character(tit_new$family)),tit_new$pclass,summary)
a<-tit_new[tit_new$pclass==2,"fare"]
a[order(tit_new[tit_new$pclass==2,"fare"])]
hist(a[order(tit_new[tit_new$pclass==2,"fare"])],breaks=20)

a<-tit[tit$fare<=5,]

median(tit[tit$pclass==1,"fare"])
median(test[test$pclass==1,"fare"])

median(tit[tit$pclass==2,"fare"])
median(tit[tit$pclass==3,"fare"])
\
\
data<-test
data$fare/as.numeric(as.character(data$family))
