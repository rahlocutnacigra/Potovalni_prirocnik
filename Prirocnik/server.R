library(shiny)
library(dplyr)
library(RPostgreSQL)
library(datasets)
#library(chron)




source("../auth_public.R",encoding='UTF-8')


shinyServer(function(input,output){
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  letalisca <- (tbl(conn, "letalisca_koordinate"))
  url_tabela <- (tbl(conn, "url_tabela"))
  leti <-(tbl(conn, "leti"))
  slo_mesta <-(tbl(conn, "slo_mesta_koordinate"))
  mesta <- slo_mesta %>% select(mesto)
  #
  query <- "SELECT a.*, b.url FROM leti a, url_tabela b where a.ponudnik=b.prevoznik"
  dsub <- tbl(conn, sql(query))
  
  #dsub$url <- paste0("<a href='",dsub$url,"'>",dsub$url,"</a>")
  
  ###tabela_test<-dbGetQuery(conn, "SELECT a.*, b.ponudnik FROM leti a, url_tabela b where a.prevoznik=b.ponudnik"))
  output$mesto<-renderUI({
    a <- data.frame(mesta)
    Encoding(a$mesto) <- "UTF-8"
    selectInput(inputId="odhod", label = "od kje boste potovali?", a$mesto)
  })
  #
  #output$dsub<-renderTable({dsub})

  pretvornik<-function(km){
    Lat <-  km/110.54
    Lon <- km/(111.320*cos(Lat))
    c(Lat, Lon)
  }
  dobi_omejitve<-function(kraj,km){
    pkm <- pretvornik(km)
    slo_mesta %>% filter(mesto == kraj) %>%
      transmute(maxsirina = sirina + pkm[1],
                minsirina = sirina - pkm[1],
                maxdolzina = dolzina + pkm[2],
                mindolzina = dolzina - pkm[2]) %>% data.frame()
  }
  primerna_letalisca<-function(kraj,km){
    omejitve <- dobi_omejitve(kraj,km)
    b<-max(omejitve$maxsirina,omejitve$minsirina)
    c<-min(omejitve$maxsirina,omejitve$minsirina)
    d<-max(omejitve$maxdolzina,omejitve$mindolzina)
    e<-min(omejitve$maxdolzina,omejitve$mindolzina)
    a<-letalisca %>% filter(sirina < b
                            & sirina > c
                            & dolzina < d
                            & dolzina > e)
  }
  mozne_destinacije<-reactive({
    #pr.leti<-subset(data.frame(leti), data.frame(leti)$odhod %in% a)
    pr.leti <- semi_join(dsub, primerna_letalisca(input$odhod,input$kilometri), by = c("odhod" = "letalisce"))
  })

  output$izbira<-renderUI({
    if(input$goButton){
      selectInput(inputId="destinacija", label="Izberi destinacijo",
                  mozne_destinacije() %>% distinct() %>% arrange(prihod) %>% data.frame() %>% .$prihod)}})

  poisci_let<-reactive({
    validate(need(!is.null(input$destinacija), ""))
    a<-mozne_destinacije() %>% filter(prihod == input$destinacija)
  })
  najugodnejsi.let<-reactive({
    poisci_let() %>% arrange(cena) %>% head(1) %>% data.frame()
  })
  poisci.povezavo<-reactive({
    a<-najugodnejsi.let()$ponudnik
    b<-filter(url_tabela, prevoznik==a) %>% data.frame() %>% .$url
  })
  izbira<-function(){
    neki<-switch(input$ponudnik, najcenejsi = TRUE, ostali = FALSE)
  }

 # output$mozni.leti<-renderTable({if(input$goButton & izbira()==FALSE){poisci_let(input$odhod, input$kilometri, input$destinacija)}})
  output$dsub<-DT::renderDataTable({
    if(input$goButton & izbira()==FALSE){
      a <- poisci_let() %>% data.frame()
      a$url <- paste0("<a href='",a$url,"'>",a$url,"</a>")
      a
    }
  }, escape = FALSE)


   output$naslov<-renderUI({HTML(if(input$goButton & izbira()){"<b> <body bgcolor='#cce6ff'> <h2> <font color='#660033'> Najcenejši let: </font> </h2> </body> </b>"})})
   output$cena<-renderUI({if(input$goButton & izbira()){HTML(paste0("<body bgcolor='#cce6ff'><b>Cena:  </b>", najugodnejsi.let()$cena[1]," €</body>"))}})
   output$krajodhoda<-renderUI({if(input$goButton & izbira()){HTML(paste0("<b>Kraj odhoda:  </b>", najugodnejsi.let()$odhod[1]))}})
   output$ponudnik<-renderUI({if(input$goButton & izbira()){HTML(paste0("<b>Ponudnik:  </b>", najugodnejsi.let()$ponudnik[1]))}})
   output$povezava<-renderUI({if(input$goButton & izbira()){HTML(paste0("<b>Povezava do ponudnika: </b> <a href='",
                                          poisci.povezavo(),
                                          "'>",poisci.povezavo(), "</a>"))}})

})


