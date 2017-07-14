library(shiny)
library(dplyr)
library(RPostgreSQL)
library(datasets)


source("../auth_public.R",encoding='UTF-8')


shinyUI(fluidPage(
  titlePanel("Potovalni priročnik"),
  sidebarPanel(
      uiOutput("mesto")
      # selectInput(inputId="destinacija", label="Kam želite potovati?",let$letalisce),
      # submitButton()
    ),
  sidebarPanel(
      sliderInput(inputId="kilometri", label= "Koliko kilometrov ste pripraljeni narediti do letališča?",
                  value = 200, min =10, max = 500)
    ),
  sidebarPanel(
    uiOutput("izbira")
  ),
  mainPanel(
    tableOutput("mozni.leti")
  ),
  mainPanel(
    tableOutput("link")
  )))