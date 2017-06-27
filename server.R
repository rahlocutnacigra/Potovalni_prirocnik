library(shiny)
library(dplyr)
library(RPostgreSQL)
library(datasets)


source("../auth_public.R")

shinyServer(function(input, output) {
  # Vzpostavimo povezavo
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  # Pripravimo tabelo
  tbl.slo_mesta_koordinate <- tbl(conn, "slo_mesta_koordinate")
  tbl.leti <- tbl(conn, "leti")
  tbl.letalisca_koordinate <- tbl(conn, "letalisca_koordinate")
  
 #ideja
  #input1 je slovensko mesto
  #input2 je sprejemljivo št km. do letališča (privzeta vrednost npr 200km)
  #S pomočjo funkcije v stopinje v bazi pogleda katera letališča so v radiju input2
  #input3 je željena destinacija
  #v bazi pogleda če obstaja let med letališči v radiju input2 in željeno destinacijo (+/- neka oddaljenost - lahko je to input4)
  #če obstaja vrne top 3lete z najnižjo ceno 