library(XML)


url <- "https://www.ryanair.com/gb/en/cheap-flights/?from=TSF&out-from-date=2017-05-11&out-to-date=2017-08-11&in-from-date=2017-05-11&in-to-date=2017-08-11&budget=150&trip-type-category=GLF"
urldata <- getURL(url)
# Parse the XML file


data <- readHTMLTable(urldata,stringsAsFactors = FALSE)


url<-"http://www.edreams.com/offers/flights/airline/W6/wizz-air/"
urldata <- getURL(url)
data <- readHTMLTable(urldata,stringsAsFactors = FALSE)


a<-data[[1]]
