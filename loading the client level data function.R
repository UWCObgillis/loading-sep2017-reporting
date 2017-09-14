


####################
####################  Start of function  ####################################
####################

load_cld <- function(i) {
  
  library(RODBC)
  library(reshape2)
  library(dplyr)
  
  con.text <- "DRIVER=SQL Server Native Client 11.0;Database=testing;Server=UWCO-BGILLISLT;Port=1433;UID=bgillis;PWD=sweetness4"
  con <- con <- odbcDriverConnect(con.text)
  
  
  f <- files[[i]]
  
  d <- read_csv(paste0("CSVs provided by Agencies/",f))
  
  # change a couple of the columns around
  names(d)[1] <- "agency"
  names(d)[2] <- "program"
  d$row_id <- row.names(d)
  
  # get the tool number (tool)
  
  tool <- tolower(substr(names(d)[[3]],1,regexpr(":",names(d)[[3]])-1))
  
  # melt
  
  dl <- melt(d, id.vars= c("agency","program","row_id"))
  dl$variable <- as.character(dl$variable)
  dl$tool <- rep(tool, length(dl$agency))
  dl$submission <- rep(f, length(dl$agency))
  
  # maybe this should just be used to pull in the names?
  
  # import the appropriate fields
  tci <- sqlQuery(con,  paste0("select * from tool_column_info where tool = '",tool,"'"),
                  stringsAsFactors =F)
  
  


  
  
  x <- dl %>%
    left_join(tci, by = c("variable" = "csv_header" )) %>%
    select(
      submission,
      row_id,
      col_num,
      agency,
      program,
      display_name,
      value
    ) 

    # get client id by row and submission (Cid)
    
    cid <- x %>%
      group_by(submission, row_id) %>%
      summarize(
        client_id = min(case_when(display_name=='client_id' ~ value, TRUE ~ 'ZZZZZ')) # I don't love this
      )
    
  x <- x %>%
    left_join(cid)
  
  return(x)
  
}

####################
####################  End of function  ##########################################
####################


