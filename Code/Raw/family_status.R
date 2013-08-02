family_status<-function(age,sibsp,parch)
{
  if (sibsp == 0 && parch == 0)
  {
    status <- "single"
  }
  else if (age <= 10)
  {
    status <- "child"
  }
  else
  {
    status <- NA
  }  
  
  return(status)
}

vstat<-rep(NA,nrow(tit_new))
for(i in 1:nrow(tit_new))
{
  vstat[i]<-family_status(tit_new[i,4],as.numeric(tit_new[i,5]),as.numeric(tit_new[i,6]))
}
    
tit_new$status<-vstat
