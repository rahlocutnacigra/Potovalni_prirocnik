library(shiny)
library(dplyr)
library(RPostgreSQL)
library(datasets)

source("../auth.r")

if ("server.R" %in% dir()) {
  setwd("..")
}
source("auth_public.R",encoding='UTF-8')


shinyServer(function(input,output){
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
