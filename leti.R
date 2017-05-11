library(XML)
library(gsubfn)

url<-"http://www.edreams.com/offers/flights/airline/W6/wizz-air/"
urldata <- getURL(url)
data <- readHTMLTable(urldata,stringsAsFactors = FALSE)
z <- substr(a[1,1],10,10)
A<-c()
for (i in data){
  A<-c(A,i$V1,i$V2)
}

mat1 <- A %>% na.omit() %>% strapplyc(paste0("^(.*) ", z, " (.*)€([0-9]+)")) %>% data.frame() %>% t()

A<-c(a$V1,a$V2)
a<-data[[1]]
