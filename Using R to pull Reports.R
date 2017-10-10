#### it is not working because you have to login
## I think you might have to add in selenium to do that


# might be helpful info here: https://stackoverflow.com/questions/24723606/scrape-password-protected-website-in-r
# also, this:  https://www.youtube.com/watch?v=GayFRUUtHj4

setwd("C:/Users/bgillis/Documents")

library(rvest)
library(RSelenium)



remDr <- RMDIR$client

url <- "https://www.ctkodm.com/uwcentralohio/"

pjs <- phantom()




x <- html_session(url)
is.session(x)

# get link to report center

y <-read_html(url)

nm <- html_nodes(y, "body")
html_text(nm)

vignette( package="RSelenium")

%>% html_attrs('href')
html_text(y)
