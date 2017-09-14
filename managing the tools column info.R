library(RODBC)
library(readxl)


# Create mssql connection

con.text <- "DRIVER=SQL Server Native Client 11.0;Database=testing;Server=UWCO-BGILLISLT;Port=1433;UID=bgillis;PWD=sweetness4"
con <- con <- odbcDriverConnect(con.text)

# load the excel file

tci <- read_excel("C:/Users/bgillis/Desktop/tool column info.xlsx")

# QUESTION:  Should this info be managed in an excel file or is SQL?  Probably in SQL, right?

# move to mssql
sqlQuery(con, "Drop Table if Exists tool_column_info")
sqlSave(con, tci, "tool_column_info")

