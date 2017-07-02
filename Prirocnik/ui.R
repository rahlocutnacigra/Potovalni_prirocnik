library(shiny)
library(dplyr)
library(RPostgreSQL)
library(datasets)
shinyUI(fluidPage(
  titlePanel("Potovalni priročnik"),
  sidebarLayout(
    sidebarPanel(
      textInput(inputId="kraj",label = 'Od kje boste potovali?'),
      selectInput(inputId="destiacija", label = "Kam bi radi potovali?", mesta),
      submitButton()
    ),
    sidebarPanel(
      sliderInput(inputId="kilometri", label= "Koliko kilometrov ste pripraljeni narediti do letališča?", 
                  value = 200, min =0, max = 500),
      sliderInput(inputId="cena", label="Kolikšna je navišja cena, ki ste jo pripravljeni plačati?",
                  value = 500, min = 50, max = 4000)
      )
    )
    
    )
  )
