library(RCurl)
library(RJSONIO)
library(plyr)
library(RgoogleMaps)
source("leti.R")

##naredi tabelo, ki slovenskim mestom doda stolpca s koordinatami

# Uporabimo funkcijo getGeoCode iz knjižnice RgoogleMaps
# address <- mesta
# locations <- ldply(address, function(x) getGeoCode(paste(x, "Slovenia")))
# locations$V5<-mesta
# names(locations) <- c("lat","lon","kraj")
# kraji_geo <- data.frame(locations$kraj,locations$lat,locations$lon)

#write.csv(kraji_geo,"Koordinate-SLO.csv",row.names=FALSE)

##tabela ki letališčem doda koordinate
letkoor <- ldply(letalisca, function(x) getGeoCode(x))
letkoor$v3<-letalisca
names(letkoor) <- c("lat","lon","kraj")


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
koor_leti <- letkoor[ !(is.na(letkoor$lat)),]
tab_let<-tab_let[ !(tab_let$Odhod) %in% rezultati,]
tab_let<-tab_let[ !(tab_let$Prihod) %in% rezultati,]
  