
##UBISTVU NEVEM ČE JE KEJ OD TEGA SPODI SPLOH OK..
library(DBI)
library(dplyr)
library(RPostgreSQL)
library(shiny)

source("auth.R")
source("leti.R")

drv<-dbDriver("PostgreSQL")
# delete_table <- function(){
#   tryCatch({
#     conn <- dbConnect(drv, dbname = 'sem2017_mancac', host = 'baza.fmf.uni-lj.si',
#                       user = 'mancac', password = '0oyf9bs0')
#     
#     #Če tabela obstaja jo zbrišemo, ter najprej zbrišemo tiste, 
#     #ki se navezujejo na druge
#     dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS slo_mesta_koordinate"))
#     dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS leti"))
#     dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS letalisca_koordinate"))
#     
#     
#   }, finally = {
#     dbDisconnect(conn)
#     
#   })
# }
# 
# create_table <- function(){
# 
#   tryCatch({
#     conn <- dbConnect(drv, dbname = db, host = host,
#                       user = user, password = password)
#     
#     dbSendQuery(conn, paste("GRANT CONNECT ON DATABASE", db,
#                             "TO javnost"))
#     dbSendQuery(conn, paste("GRANT CONNECT ON DATABASE", db, "TO rahlocutnacigra"))
#     
#     
#     #Glavne tabele
#     slo_mesta_koordinate <- dbSendQuery(conn,build_sql("CREATE TABLE slo_mesta_koordinate (
#                                              mesto SERIAL PRIMARY KEY,
#                                              širina double NOT NULL,
#                                              dolžina double NOT NULL
# 
#     )"))
#     dbSendQuery(conn, build_sql("GRANT SELECT ON slo_mesta_koordinate TO javnost"))
#     
#     
#     dbSendQuery(conn, build_sql("GRANT ALL ON ALL TABLES IN SCHEMA public TO laraluckmann"))
#     dbSendQuery(conn, build_sql("GRANT ALL ON ALL TABLES IN SCHEMA public TO rahlocutnacigra"))
#     dbSendQuery(conn, build_sql("GRANT SELECT ON ALL TABLES IN SCHEMA public TO javnost"))
#     
#   }, finally = {
#     dbDisconnect(conn) #PREKINEMO POVEZAVO
#    
#   })
# }
# 
# slo_mesta_koordinate<-read.csv2("Koordinate-SLO.csv",fileEncoding = "Windows-1250", sep=",")
# 
# 
# 
# insert_data <- function(){
#   tryCatch({
#     conn <- dbConnect(drv, dbname = 'sem2017_mancac', host = 'baza.fmf.uni-lj.si',
#                       user = 'mancac', password = '0oyf9bs0')
#     
#     dbWriteTable(conn, name="slo_mesta_koordinate",slo_mesta_koordinate,append=T, row.names=FALSE)
#     con <- src_postgres(dbname = db, host = host,
#                         user = user, password = password)
#     tbl.slo_mesta_koordinate <- tbl(con, "slo_mesta_koordinate")
#     
#     
#   }, finally = {
#     dbDisconnect(conn) 
#     
#   })
# }
# 
#     
# 
delete_table <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    
    #Ce tabela obstaja jo zbrisemo, ter najprej zbrisemo tiste, 
    #ki se navezujejo na druge
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS slo_mesta_koordinate"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS leti"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS letalisca_koordinate"))
    
    
  }, finally = {
    dbDisconnect(conn)
    
  })
}


#Funkcija, ki ustvari tabele
create_table <- function(){
  # Uporabimo tryCatch,(da se povezemo in bazo in odvezemo)
  # da prisilimo prekinitev povezave v primeru napake
  tryCatch({
    # Vzpostavimo povezavo
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    
    #Glavne tabele:
    
    slo_mesta_koordinate <- dbSendQuery(conn,build_sql("CREATE TABLE slo_mesta_koordinate (
                                             mesto TEXT PRIMARY KEY,
                                             sirina NUMERIC NOT NULL,
                                             dolzina NUMERIC NOT NULL)"))

   leti<-dbSendQuery(conn,build_sql("CREATE TABLE leti (

                                    Ponudnik TEXT NOT NULL,
                                    Odhod TEXT NOT NULL,
                                    Prihod TEXT NOT NULL,
                                    Cena NUMERIC NOT NULL)"))
    
    dbSendQuery(conn, build_sql('GRANT SELECT ON ALL TABLES IN SCHEMA public TO javnost'))
    
  }, finally = {
    # Na koncu nujno prekinemo povezavo z bazo,
    # saj prevec odprtih povezav ne smemo imeti
    dbDisconnect(conn) #PREKINEMO POVEZAVO
    # Koda v finally bloku se izvede, preden program konca z napako
  })
}


#Uvoz podatkov:
slo_mesta_koordinate<-read.csv2("Koordinate-SLO.csv",fileEncoding = "Windows-1250", sep=",")
#glasbeniki <-read.csv("Podatki/glasbeniki.csv",fileEncoding = "Windows-1252")
#pesmi <-read.csv("Podatki/pesmi.csv",fileEncoding = "Windows-1252")
#ranks <-read.csv("Podatki/ranks.csv",fileEncoding = "Windows-1252")
#billboard <- read.csv("Podatki/lestvica.csv",fileEncoding = "Windows-1252")

#Funcija, ki vstavi podatke
insert_data <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    
    dbWriteTable(conn, name="slo_mesta_koordinate",slo_mesta_koordinate,append=T, row.names=FALSE)
    dbWriteTable(conn, name="leti",tab_let,append=T, row.names=FALSE)
    
  }, finally = {
    dbDisconnect(conn) 
    
  })
}

pravice <- function() {
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    
    dbSendQuery(conn, paste("GRANT CONNECT ON DATABASE", db, "TO mancac"))
    dbSendQuery(conn, "GRANT CONNECT ON DATABASE sem2017_mancac TO laral")
    dbSendQuery(conn, "GRANT ALL ON ALL TABLES IN SCHEMA public TO laral")
    dbSendQuery(conn, "GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO laral")
    dbSendQuery(conn, "GRANT CREATE ON SCHEMA public TO mancac")
    dbSendQuery(conn, "GRANT CREATE ON SCHEMA public TO laral")
    
  }, finally = {
    dbDisconnect(conn) 
    
  })
}

delete_table()
create_table()
insert_data()

con <- src_postgres(dbname = db, host = host, user = user, password = password)