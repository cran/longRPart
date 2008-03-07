library(nlme)
# performing an lme timing test: Need to run this at home
# using the cd4 data
dat = read.table("aidsData.csv",sep=',')

#5036 observations, going to use samples of 
#50, 100, 200, 400, 800, 1600, 3200, 5036 to 
#test the computation time for lme
x = c(100,200,400,800,1600,3200,5036)
ind = 1:(dim(dat)[1])
times = list()
for(j in 1:10){
  order = sample(x,length(x),replace=F)
  times[[j]] = matrix(nrow=8,ncol=2)
  for(i in order){	
    d = dat[sample(ind,i,replace=F),]
    t = proc.time()[3]
    m = try(lme(cd4~Week,dat=d,random=~1|Subject,correlation=corExp(form=~W)),silent=T)
    times[[j]][x==i,1] = i
    if(class(m)=='lme'){
      times[[j]][x==i,2] = proc.time()[3]-t
    }
    else{
      times[[j]][x==i,2] = NA
    }
  }
}