library(RCurl)
library(RJSONIO)
library(plyr)
library(RgoogleMaps)
source("leti.R")

# Uporabimo funkcijo getGeoCode iz knjižnice RgoogleMaps
address <- mesta
locations <- ldply(address, function(x) getGeoCode(paste(x, "Slovenia")))
locations$V5<-mesta
names(locations) <- c("lat","lon","kraj")
kraji_geo <- data.frame(locations$kraj,locations$lat,locations$lon)

#write.csv(kraji_geo,"Koordinate-SLO.csv",row.names=FALSE)


letkoor <- ldply(letalisca, function(x) getGeoCode(x))
letkoor$v3<-letalisca
names(letkoor) <- c("lat","lon","kraj")

rezultati<-c()
letalisca1<-letalisca
for (i in 1:10){
  rezultati<-c()
  letkoor1<-ldply(letalisca1, function(x) getGeoCode(x))
  letkoor1$v3<-letalisca1
  names(letkoor1) <- c("lat","lon","kraj")
  letkoorsk<-merge(letkoor,letkoor1,by="kraj", all.x=TRUE)
  for (i in 1:nrow(letkoorsk)){
      if (is.na(letkoorsk[i,2])){
        letkoorsk[i,2]<-letkoorsk[i,4]
      }
      if (is.na(letkoorsk[i,3])){
        letkoorsk[i,3]<-letkoorsk[i,5]
      }
  }
  letkoor<-data.frame(letkoorsk[,1],letkoorsk[,2],letkoorsk[,3])
  names(letkoor) <- c("kraj","lat","lon")
  for (i in 1:nrow(letkoor)){
    if (is.na(letkoor[i,2])){
      a<-as.vector(letkoor[i,1])
      rezultati<-c(rezultati,a)}
  }
  letalisca1<-rezultati
}

  
# letkoor<-ldply(letalisca, function(x) getGeoCode(x))
# letkoor2<-ldply(letalisca, function(x) getGeoCode(x))
# letkoor$V5<-letalisca
# letkoor2$V5<-letalisca
# #k<-join(letkoor,letkoor2,by=NULL,type="inner") #to nama ne dela
# 
# letkoorsk<-cbind(letkoor,letkoor2)
# 
# for (i in 1:nrow(letkoorsk)){
#   if (is.na(letkoorsk[i,1])){
#     letkoorsk[i,1]<-letkoorsk[i,4]
#   }
#   if (is.na(letkoorsk[i,2])){
#     letkoorsk[i,2]<-letkoorsk[i,5]
#   }
#   i=i+1
# }
# 
# 
# koorleti<-letkoorsk[,c(1,2,3)]
# 
# letkoor3<-ldply(letalisca, function(x) getGeoCode(x, JSON = TRUE))
# letkoor3$V5<-letalisca
# 
# 
# letkoorsk2<-cbind(koorleti,letkoor3)
# 
# for (i in 1:nrow(letkoorsk2)){
#   if (is.na(letkoorsk2[i,1])){
#     letkoorsk2[i,1]<-letkoorsk2[i,4]
#   }
#   if (is.na(letkoorsk2[i,2])){
#     letkoorsk2[i,2]<-letkoorsk2[i,5]
#   }
#   i=i+1
# }
# 
# koorleti2<- letkoorsk2[,c(1,2,3)]
# 
# letkoor4<-ldply(letalisca, function(x) getGeoCode(x, JSON = TRUE))
# letkoor4$V5<-letalisca
# 
# letkoorsk3<-cbind(koorleti2,letkoor4)
# 
# for (i in 1:nrow(letkoorsk3)){
#   if (is.na(letkoorsk3[i,1])){
#     letkoorsk3[i,1]<-letkoorsk3[i,4]
#   }
#   if (is.na(letkoorsk3[i,2])){
#     letkoorsk3[i,2]<-letkoorsk3[i,5]
#   }
#   i=i+1
# }
# 
# 
# koorleti3<- letkoorsk3[,c(1,2,3)]
# koorleti3[142,3]<-"Mugla Dalaman"


#write.csv(koorleti3,"Letalisca-Koordinate.csv",row.names=FALSE)