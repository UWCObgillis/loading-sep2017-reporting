
library(dplyr)

## now we want to load the reported data
source("C:/Users/bgillis/Documents/R/SQL Connections.R")
source("Ind Data Melting and Cleaning Funcition.R")

con <- mssql_con("testing")

dir = "C:/Users/bgillis/Documents/GitHub/loading-sep2017-reporting-DATA/CTK Report Runs/report_run_2017-10-06/"
files <- list.files(dir)
s = 1
# s is an option to skip a row, reports have a section header but the CSVs don't

# Run the loop
df <- data.frame()

for (f in files) {
  y = load_ind_data(dir, f, s)
  df <- rbind(df, y)
}


# quick test: look at submissions and number of rows
qt <- df %>%
  group_by(submission) %>%
  summarise(rows = max(row_id))

# add in date and source
d$date_uploaded <- as.Date(Sys.Date())
d$date_uploaded <- NULL

############ choose the appropriate data source
#  df$data_source <- rep("CSV", length(df[,1]))
#  df$data_source <- rep("CTK", length(df[,1]))

###### Move to SQL ####################

#  sqlQuery(con, "Drop Table if Exists ind_data_staging")
sqlSave(con, df, "ind_data_staging_ctk", rownames = F)

# next step - how to combine them


