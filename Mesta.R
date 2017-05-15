library(XML)
library(RCurl)
require(dplyr)
require(rvest)
require(gsubfn)
require(ggplot2)
require(dplyr)
require(mgcv)
require(xml2)

#Tabela slovenskih mest
url <- "https://sl.wikipedia.org/wiki/Seznam_mest_v_Sloveniji"
stran <- html_session(url) %>% read_html(fileEncoding = "UTF-8") 
tabela<- stran %>% html_nodes(xpath ="//table")%>%.[[1]]%>% html_table(fill=TRUE)
Encoding(tabela$ime) <- "UTF-8"
mesta<-tabela$ime




