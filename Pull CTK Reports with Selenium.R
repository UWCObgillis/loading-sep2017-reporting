#install.packages("RSelenium")

library(RSelenium)
library(readr)
library(reshape2)
library(readxl)
library(dplyr)

### First, we want to get a list of the reports we will need
# I will likely change the table this exists in
r <- read_excel("~/GitHub/loading-sep2017-reporting/Tool Info General.xlsx")
report.num <- as.character(r$ctk_num)

#### Add in a section that checks and moves all the other analysis files

RMDIR <- RSelenium::rsDriver(,browser = 'chrome')

############################
### Get Logged in
############################

remDr <- RMDIR$client
remDr$navigate("https://www.ctkodm.com/uwcentralohio/")

webElem <- remDr$findElement(using = "css", "#LoginName")
webElem$sendKeysToElement(list("bgillis"))

webElem <- remDr$findElement(using = "css", "#Password")
webElem$sendKeysToElement(list("Sweetness1"))

webElem <- remDr$findElement(using = "css", 'input.cusLPLoginBoxButton:nth-child(6)')
webElem$clickElement()

#####################################################################

for (i in report.num){
  
remDr$navigate("https://www.ctkodm.com/uwcentralohio/")
  
# go to report center
webElem <- remDr$findElement(using = "css", 'a.cusSBMenuItem:nth-child(7)')
webElem$clickElement()

# select the analysis reports  
  webElem <- remDr$findElement(using = "css", '#selectOpts > fieldset:nth-child(2) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > select:nth-child(1) > option:nth-child(3)')
  webElem$clickElement()

report = paste0("[value='",i, "']")

# choose report
webElem <- remDr$findElement(using = "css", report)
webElem$clickElement()

webElem <- remDr$findElement(using = "css", '#exportImage')
webElem$clickElement()

}


##
## FOR NOW load BC531 Manually
##

####################################################################
##################  Now we can move the folders we downloaded #####

# add in a way to move those files into another location
old.dir <- "C:/Users/bgillis/Downloads/"
new.dir <- "C:/Users/bgillis/Documents/GitHub/loading-sep2017-reporting-DATA/CTK Report Runs/"

today <- as.character(Sys.Date())
# create a new folder 
dir.create(paste0(new.dir,"report_run_",today))

files <- list.files("C:/Users/bgillis/Downloads")
files <- files[grep("_Analysis_", files)]

for (f in files) {
  file.rename(paste0(old.dir,f), paste0(new.dir,"report_run_", today,"/",f))
}

