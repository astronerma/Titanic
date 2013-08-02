# Utilities file
# --------------------------------------------------
# Calculate differences between two submission files (script written first in iteration 4)
# As parameter give number of submission files to compare 
diffsub<-function(s1,s2)
{
  f1 <- paste("./Submissions/submission",as.character(s1),".csv",sep="")
  f2 <- paste("./Submissions/submission",as.character(s2),".csv",sep="")
  sub1 <- read.csv(file=f1)
  sub2 <- read.csv(file=f2)
  ct <- 0
  for (i in 1:nrow(sub1))
  {
    
    if (sub1[i,1] != sub2[i,1])
    {
      ss <- paste("i = ",as.character(i),"   sub1 = ",as.character(sub1[i,1]),"   sub2 = ",as.character(sub2[i,1]),sep="")
      print(ss)
      ct <- ct + 1
    }
  }
  return(ct)  
}
# ----------------------------------------------------------------
# Calculate accuracy of the prediction
modelacc <- function(data,model)
{
  p <- predict(model,newdata=data,type="class")
  return(sum(data[[1]]==p)/nrow(data))
}
