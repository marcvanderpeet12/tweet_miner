positive_words= readLines("positive-words.txt")
negative_words = readLines("negative-words.txt")

tweets_NY = searchTwitter("@realDonaldTrump" , lang = "en", n = 10, resultType = "recent", geocode = geocode_NY)

add_sentiment <- function(df){
  
  df$sentiment <- 0
  tweets <- df$text
  
  for(i in 1:nrow(df)){
    
    tweet <- df$text[i]
    tweet = gsub("[[:punct:]]", "", tweet)    # remove punctuation
    tweet = gsub("[[:cntrl:]]", "", tweet)   # remove control characters
    tweet = gsub('\\d+', '', tweet)
      
    tryTolower = function(x){
      y = NA
      try_error = tryCatch(tolower(x), error=function(e) e)
      if (!inherits(try_error, "error"))
        y = tolower(x)
      return(y)
      }
    tweet = sapply(tweet, tryTolower)
    word_list = str_split(tweet, "\\s+")
    words = unlist(word_list)

    positive_matches = match(words, positive_words)
    negative_matches = match(words, negative_words)
      
    positive_matches = !is.na(positive_matches)
    negative_matches = !is.na(negative_matches)
      
    score = sum(positive_matches) - sum(negative_matches)
    df$sentiment[i] <- score
  }  
  return(df)
}
