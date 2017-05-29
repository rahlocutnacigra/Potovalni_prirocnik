
##UBISTVU NEVEM ČE JE KEJ OD TEGA SPODI SPLOH OK..

library(dplyr)
library(RPostgreSQL)
library(shiny)


source("leti.R") #kaj je source??


delete_table <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    
    #Če tabela obstaja jo zbrišemo, ter najprej zbrišemo tiste, 
    #ki se navezujejo na druge
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS slo_mesta_koordinate"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS leti"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS letalisca_koordinate"))
    
    
  }, finally = {
    dbDisconnect(conn)
    
  })
}

create_table <- function(){

  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    
    dbSendQuery(conn, paste("GRANT CONNECT ON DATABASE", db,
                            "TO javnost"))
    dbSendQuery(conn, paste("GRANT CONNECT ON DATABASE", db, "TO rahlocutnacigra"))
    
    
    #Glavne tabele
    slo_mesta_koordinate <- dbSendQuery(conn,build_sql("CREATE TABLE slo_mesta_koordinate (
                                             mesto SERIAL PRIMARY KEY,
                                             širina double NOT NULL,
                                             dolžina double NOT NULL

    )"))
    dbSendQuery(conn, build_sql("GRANT SELECT ON slo_mesta_koordinate TO javnost"))
    
    
    dbSendQuery(conn, build_sql("GRANT ALL ON ALL TABLES IN SCHEMA public TO laraluckmann"))
    dbSendQuery(conn, build_sql("GRANT ALL ON ALL TABLES IN SCHEMA public TO rahlocutnacigra"))
    dbSendQuery(conn, build_sql("GRANT SELECT ON ALL TABLES IN SCHEMA public TO javnost"))
    
  }, finally = {
    dbDisconnect(conn) #PREKINEMO POVEZAVO
   
  })
}

slo_mesta_koordinate<-read.csv2("Koordinate-SLO.csv",fileEncoding = "Windows-1250")



insert_data <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    
    dbWriteTable(conn, name="slo_mesta_koordinate",slo_mesta_koordinate,append=T, row.names=FALSE)
    con <- src_postgres(dbname = db, host = host,
                        user = user, password = password)
    tbl.slo_mesta_koordinate <- tbl(con, "slo_mesta_koordinate")
    
    
  }, finally = {
    dbDisconnect(conn) 
    
  })
}

    

