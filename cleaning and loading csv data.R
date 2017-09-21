library(RODBC)
library(reshape2)
library(dplyr)
library(readr)

setwd("C:/Users/bgillis/Documents/GitHub/loading-sep2017-reporting")
source("loading the client level data function.R")

con.text <- "DRIVER=SQL Server Native Client 11.0;Database=testing;Server=UWCO-BGILLISLT;Port=1433;UID=bgillis;PWD=sweetness4"
con <- con <- odbcDriverConnect(con.text)

##
##  Still need to set up a way to stop loading the ones I've already loaded
##

# get data files
dir <- "C:/Users/bgillis/Desktop/CSVs provided by Agencies/"
files <- list.files(dir)


# for test
f <- files[1]

# Run the loop
x0 <- data.frame()


for (f in files) {
  y = load_cld(dir, f)
  x0 <- rbind(x0, y)
}


sqlQuery(con, "Drop Table if Exists client_level_data_staging")
sqlSave(con, x0, "client_level_data_staging", rownames = F)







