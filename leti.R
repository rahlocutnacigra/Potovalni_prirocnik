library(XML)
library(gsubfn)
#Podatki o letih
naslovi<-c("http://www.edreams.com/offers/flights/airline/FR/ryanair/",
           "http://www.edreams.com/offers/flights/airline/W6/wizz-air/",
           "http://www.edreams.com/offers/flights/airline/EI/aer-lingus/",
           "http://www.edreams.com/offers/flights/airline/U2/easyjet/",
           "http://www.edreams.com/offers/flights/airline/IB/iberia/",
           "http://www.edreams.com/offers/flights/airline/BA/british-airways/",
           "http://www.edreams.com/offers/flights/airline/DY/norwegian-air-shuttle/",
           "http://www.edreams.com/offers/flights/airline/VY/vueling/",
           "http://www.edreams.com/offers/flights/airline/A3/aegean-airlines/",
           "http://www.edreams.com/offers/flights/airline/PC/pegasus-airlines/",
           "http://www.edreams.com/offers/flights/airline/TK/turkish-airlines/",
           "http://www.edreams.com/offers/flights/airline/LH/lufthansa/",
           "http://www.edreams.com/offers/flights/airline/EW/eurowings/",
           "http://www.edreams.com/offers/flights/airline/KL/klm-royal-dutch-airlines/",
           "http://www.edreams.com/offers/flights/airline/BE/flybe/",
           "http://www.edreams.com/offers/flights/airline/UX/air-europa/",
           "http://www.edreams.com/offers/flights/airline/4U/germanwings/",
           "http://www.edreams.com/offers/flights/airline/OS/austrian-airlines/",
           "http://www.edreams.com/offers/flights/airline/OU/croatia-airlines/",
           "http://www.edreams.com/offers/flights/airline/OK/czech-airlines-csa/",
           "http://www.edreams.com/offers/flights/airline/BT/airbaltic/",
           "http://www.edreams.com/offers/flights/airline/PS/ukraine-intl-airlines/",
           "http://www.edreams.com/offers/flights/airline/AY/finnair/",
           "http://www.edreams.com/offers/flights/airline/AK/air-asia/",
           "http://www.edreams.com/offers/flights/airline/SU/aeroflot/",
           "http://www.edreams.com/offers/flights/airline/RO/tarom/",
           "http://www.edreams.com/offers/flights/airline/VJ/vietjet-aviation/",
           "http://www.edreams.com/offers/flights/airline/EK/emirates/",
           "http://www.edreams.com/offers/flights/airline/QS/travel-service/",
           "http://www.edreams.com/offers/flights/airline/AA/american-airlines/",
           "http://www.edreams.com/offers/flights/airline/YM/montenegro-airlines/",
           "http://www.edreams.com/offers/flights/airline/AV/avianca/",
           "http://www.edreams.com/offers/flights/airline/V7/volotea/",
           "http://www.edreams.com/offers/flights/airline/AZ/alitalia/",
           "http://www.edreams.com/offers/flights/airline/TP/tap-portugal/",
           "http://www.edreams.com/offers/flights/airline/AB/air-berlin/",
           "http://www.edreams.com/offers/flights/airline/0B/blue-air/",
           "http://www.edreams.com/offers/flights/airline/KL/klm-royal-dutch-airlines/",
           "http://www.edreams.com/offers/flights/airline/HV/transavia-airlines/",
           "http://www.edreams.com/offers/flights/airline/SN/brussels-airlines/",
           "http://www.edreams.com/offers/flights/airline/LX/swiss-international-air-lines/",
           "http://www.edreams.com/offers/flights/airline/TO/transavia-france/",
           "http://www.edreams.com/offers/flights/airline/SK/scandinavian-airlines/",
           "http://www.edreams.com/offers/flights/airline/JU/air-serbia/",
           "http://www.edreams.com/offers/flights/airline/LO/lot-polish-airlines/",
           "http://www.edreams.com/offers/flights/airline/KM/air-malta/",
           "http://www.edreams.com/offers/flights/airline/LY/el-al-israel-airlines/",
           "http://www.edreams.com/offers/flights/airline/FB/bulgaria-air/",
           "http://www.edreams.com/offers/flights/airline/TB/tui-fly/",
           "http://www.edreams.com/offers/flights/airline/WW/wowair/",
           "http://www.edreams.com/offers/flights/airline/ZB/monarch-airlines/",
           "http://www.edreams.com/offers/flights/airline/QR/qatar-airways/",
           "http://www.edreams.com/offers/flights/airline/V7/volotea/",
           "http://www.edreams.com/offers/flights/airline/JP/adria-airways/",
           "http://www.edreams.com/offers/flights/airline/OA/olympic-air/",
           "http://www.edreams.com/offers/flights/airline/TU/tunisair/",
           "http://www.edreams.com/offers/flights/airline/VN/vietnam-airlines/")
url1<-"http://www.edreams.com/offers/flights/airline/W6/wizz-air/"
urldata1 <- getURL(url1)
data1 <- readHTMLTable(urldata1,stringsAsFactors = FALSE)
a<-data1[[1]]
z <- substr(a[1,1],10,10)

A<-c()
for (url in naslovi){
  urldata <- getURL(url)
  data <- readHTMLTable(urldata,stringsAsFactors = FALSE)
  for (i in data){
   # sk[i]<-c(i$V1,i$V2)  #to ne dela
  #  sk[i]<-na.omit(sk)
   # for (j in sk){
     # j<-gsub(",","",j)
    #  }
    razdeli<- strsplit(url, split = "/")
    n<-length(razdeli[[1]])
    prevoznik<-razdeli[[1]][n]
    b<-paste0(prevoznik,"/",sk)
   # c<-paste0(prevoznik,"/",i$V2)
    A<-c(A,b)
  }
}

mat1 <- A  %>% strapplyc(paste0("^(.*)/(.*) ",z, " (.*)€([0-9]+)")) %>% data.frame() %>% t()




mat1
razdeli<- strsplit("http://www.edreams.com/offers/flights/airline/FR/ryanair/", split = "/")
n<-length(razdeli[[1]])
razdeli[[1]][n]


