library(shiny)
library(shinyjs)
library(shinydashboard)

UI <- fluidPage(
     actionButton("get_tweets", "Fetch tweets"),
     numericInput("tweet_amount", "Set the amount of Tweets", 10, min = 10, max = 1000),
     selectInput("tweet_name", "Select the tweeter", selected = NULL, choices = c("@RealDonaldTrump")),
     
     #Set hidden buttons
     hidden(
       div(id="status_update",
           verbatimTextOutput("status")
           )
     )
)

Server <- function(input, output){
  
  #get_connected <- reactive({
    #connect
  #})
  
  #scrape_tweets <- reactive({
    
  #  S = 200, N = input$tweet_amount, lats_NY <- c(40.7), long_NY <- c(-73.9)
  #  geocode_NY <- paste(lats_NY[1], long_NY[1], paste0(S, "mil="), sep =",")
    
  #  tweets_NY <- searchTwitter(input$tweet_name, lang = "en", n = N, resultType = "recent", geocode = geocode_NY)
  #  return(N)
  #})
  
  observeEvent(input$get_tweets, {
    #Connect to the API
    toggle("status_update")
    output$status <- renderText({"You're now connected to the API"})
  })
  
}

shinyApp(ui = UI, server = Server)
