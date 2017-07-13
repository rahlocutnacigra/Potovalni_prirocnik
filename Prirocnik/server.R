library(shiny)
library(dplyr)
library(RPostgreSQL)
library(datasets)
library(chron)


source("../auth_public.R", encoding='UTF-8')


source("../auth_public.R",encoding='UTF-8')


shinyServer(function(input,output){
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  letalisca <- (tbl(conn, "letalisca_koordinate"))
  leti <-(tbl(conn, "leti"))
  slo_mesta <-(tbl(conn, "slo_mesta_koordinate"))
  mesta<-data.frame(slo_mesta)
  Encoding(mesta$mesto) <- "UTF-8"
  output$mesta<-renderUI(mesta)
  pretvornik<-function(km){
    Lat <-  km/110.54
    Lon <- km/(111.320*cos(Lat))
    c(Lat, Lon)
  }
  # pretvornik(input$kilometri)
  
  })


