library(shiny)
library(shinyjs)
library(shinydashboard)
library(twitteR)

UI <- fluidPage(
  
     actionButton("get_tweets", "Connect to the twitter API"),
     numericInput("tweet_amount", "Set the amount of Tweets", 10, min = 10, max = 1000),
     selectInput("tweet_name", "Select the tweeter", selected = NULL, choices = c("@RealDonaldTrump")),
     
     #Set hidden buttons
     hidden(
       div(id="status_update",
           verbatimTextOutput("status")
           )
     ),
     
     hidden(
       div(id = "tweet_fetcher",
           uiOutput("status2")
           )
     ),
     tableOutput("table_output_trump")
)

Server <- function(input, output){
  
  #scrape_tweets <- reactive({
    
  #  S = 200, N = input$tweet_amount, lats_NY <- c(40.7), long_NY <- c(-73.9)
  #  geocode_NY <- paste(lats_NY[1], long_NY[1], paste0(S, "mil="), sep =",")
    
  #  tweets_NY <- searchTwitter(input$tweet_name, lang = "en", n = N, resultType = "recent", geocode = geocode_NY)
  #  return(N)
  #})
  
  observeEvent(input$get_tweets, {
    #Connect to the API
    consumer_key <- "BlVcLSJaMPIq72IN8oQPig9qR"
    consumer_secret <- "LHoITtaFPu80eF2ppG14ElqEnXNVbH0wMz3THzQHSqh9HDETiw"
    access_token <- "926479201414385668-gtFFvJNriVbsHbPwBLXJjGWuIbY8Oz3"
    access_secret <- "ozUPCDKpiw4eWhJcNOE7rh7c7a4KmcNXQGwKTYjMhCiQv"
    setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret) 
    
    toggle("status_update")
    output$status <- renderText({"You're now connected to the API"})
    toggle("tweet_fetcher")
    output$status2 <- renderUI(actionButton("status2", "Scrape tweets"))
  })
  
  observeEvent(input$status2, {
  
    S = 200 
    N = 2
    
    lats_NY <- c(40.7)
    long_NY <- c(-73.9)
    geocode_NY <- paste(lats_NY[1], long_NY[1], paste0(S, "mi"), sep = ",")
    
    tweets_NY = searchTwitter(input$tweet_name , lang = "en", n = input$tweet_amount, resultType = "recent", geocode = geocode_NY)
    
    donaldtext <- sapply(tweets_NY, function(x) x$getText())
    donaldtext = unlist(donaldtext)
    df = data.frame(text = donaldtext)
    
    #output$status <- renderText({as.character(length(tweets_NY))}) 
    output$table_output_trump <- renderTable(
      df
    )
    
  })
  

}

shinyApp(ui = UI, server = Server)
