library(shiny)
library(dplyr)
library(RPostgreSQL)
library(datasets)
library(chron)




source("../auth_public.R",encoding='UTF-8')


shinyServer(function(input,output){
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  letalisca <- (tbl(conn, "letalisca_koordinate"))
  leti <-(tbl(conn, "leti"))
  slo_mesta <-(tbl(conn, "slo_mesta_koordinate"))
  mesta <- slo_mesta %>% select(mesto) %>% data.frame()
  Encoding(mesta$mesto) <- "UTF-8"
  output$mesto<-renderUI({selectInput(inputId="odhod", label = "od kje boste potovali?",mesta$mesto)})
  
  pretvornik<-function(km){
    Lat <-  km/110.54
    Lon <- km/(111.320*cos(Lat))
    c(Lat, Lon)
  }
  dobi_omejitve<-function(kraj,km){
    a<-slo_mesta %>% filter(mesto == kraj) %>% data.frame()
    lat<-c(a$sirina + pretvornik(km)[1],a$sirina - pretvornik(km)[1])
    lon<-c(a$dolzina + pretvornik(km)[2],a$dolzina - pretvornik(km)[2])
    c(lat,lon)
  }
  primerna_letalisca<-function(kraj,km){
    b<-max(dobi_omejitve(kraj,km)[1],dobi_omejitve(kraj,km)[2])
    c<-min(dobi_omejitve(kraj,km)[1],dobi_omejitve(kraj,km)[2])
    d<-max(dobi_omejitve(kraj,km)[3],dobi_omejitve(kraj,km)[4])
    e<-min(dobi_omejitve(kraj,km)[3],dobi_omejitve(kraj,km)[4])
    a<-letalisca %>% filter(sirina < b
                            & sirina > c
                            & dolzina < d
                            & dolzina > e) %>%data.frame()
  }
  mozne_destinacije<-function(kraj,km){
    a<-primerna_letalisca(kraj,km)$letalisce
    pr.leti<-subset(data.frame(leti), data.frame(leti)$odhod %in% a)
  }
  output$izbira<-renderUI({selectInput(inputId="destinacija", label="Izberi destinacijo",unique(mozne_destinacije(input$odhod,input$kilometri)$prihod))})
  poisci_let<-function(kraj,km,destinacija){
    a<-mozne_destinacije(kraj,km) %>% filter(prihod == destinacija)
  }
  output$mozni.leti<-renderTable({poisci_let(input$odhod, input$kilometri, input$destinacija)})
  })


