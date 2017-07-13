library(shiny)
library(dplyr)
library(RPostgreSQL)
library(datasets)


source("Potovalni_prirocnik/auth.R")
# conn <- src_postgres(dbname = db, host = host,
#                      user = user, password = password)
# letalisca <- (tbl(conn, "letalisca_koordinate"))
# leti <-(tbl(conn, "leti"))
# slo_mesta <-(tbl(conn, "slo_mesta_koordinate"))
# mesta<-data.frame(slo_mesta)
# Encoding(mesta$mesto) <- "UTF-8"
# let<-data.frame(letalisca)

shinyUI(fluidPage(
  titlePanel("Potovalni priročnik"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId="odhod", label = "od kje boste potovali?", uiOutput("mesta")),
    submitButton(),
      selectInput(inputId="destinacija", label="Kam želite potovati?",let$letalisce),
      submitButton()
    ),
    sidebarPanel(
      sliderInput(inputId="kilometri", label= "Koliko kilometrov ste pripraljeni narediti do letališča?",
                  value = 200, min =0, max = 500)),
    # sidebarPanel(
    #   tableOutput("a")
    #   )
    )

    )
  )
