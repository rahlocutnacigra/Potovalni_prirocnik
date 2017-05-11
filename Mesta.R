library(XML)
library(RCurl)
require(dplyr)
require(rvest)
require(gsubfn)
require(ggplot2)
require(dplyr)
require(mgcv)

url <- "https://sl.wikipedia.org/wiki/Seznam_mest_v_Sloveniji"
stran <- html_session(url) %>% read_html(fileEncoding = "UTF-8") 
tabela<- stran %>% html_nodes(xpath ="//table")%>%.[[1]]%>% html_table(fill=TRUE)
Encoding(tabela$ime) <- "UTF-8"
mesta<-tabela$ime

# names(tabela)<-c("0","mesto","regija","st.preb","0","0","0","0","0")
# tabela<-tabela
# tabela<-tabela[-c(5:10)]
# tabela<-tabela[,-1]
# tabela<-tabela[-1,]
# tabela[6,2]<-"obalno-kraška"
# tabela$st.preb <- as.integer(as.numeric(tabela$st.preb)*1000)
