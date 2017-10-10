###
###  Management of the Tool Column Info
###
library(readxl)
source("C:/Users/bgillis/Documents/R/SQL Connections.R")

con <- mssql_con("testing")


#### Get a list of all the appropriate column names from the CSV files?

# load csv tool column info 
csv <- read_excel("~/GitHub/loading-sep2017-reporting/Tool and Column Info.xls", 
                                   sheet = "CSV")

sqlDrop(con,"col_info_csv" )
sqlSave(con, csv, "col_info_csv")
