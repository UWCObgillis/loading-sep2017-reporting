# this function loads the data in the format that we are looking for

####################  Start of function  ####################################
# cld for client level data

load_cld <- function(dir, f) {
  
  library(RODBC)
  library(reshape2)
  library(dplyr)
  
  con.text <- "DRIVER=SQL Server Native Client 11.0;Database=testing;Server=UWCO-BGILLISLT;Port=1433;UID=bgillis;PWD=sweetness4"
  con <- con <- odbcDriverConnect(con.text)

  d <- read_csv(paste0(dir,f))
  
  # change a couple of the columns around
  names(d)[1] <- "agency"
  names(d)[2] <- "program"
  d$row_id <- row.names(d)
  
  
  ########## match with the best id# #################
  
  ap.id <- sqlFetch(con, "agency_program_id", stringsAsFactors =F)
  names(ap.id) <- tolower(names(ap.id)) # set up names so I don't need to do this
  
  dist.test <- adist(paste(ap.id$agency, ap.id$program), paste(d[1,]$agency, d[1,]$program))
  # find the min in the list and the pull that id from the list, add it on to d
  d$ap_id <- rep(ap.id[which(dist.test == min(dist.test)),3],length(d$agency))
  
  #### we still need a flag for when more than 1 show up as an option
  
  ####################################################
  
  # get the tool number (tool)
  
  tool <- tolower(substr(names(d)[[3]],1,regexpr(":",names(d)[[3]])-1))
  
  ################ melt the data #################################
  
  dl <- melt(d, id.vars= c("ap_id", "agency","program","row_id"))
  dl$variable <- as.character(dl$variable)
  dl$tool <- rep(tool, length(dl$agency))
  dl$submission <- rep(f, length(dl$agency))
  
  ################################################################
  
  # maybe this should just be used to pull in the names?
  
  # import the appropriate fields
  #tci <- sqlQuery(con,  paste0("select * from tool_column_info where tool = '",tool,"'"),
                  #stringsAsFactors =F)

  # x <- dl %>%
  #   left_join(tci, by = c("variable" = "csv_header" )) %>%
  #   select(
  #     submission,
  #     row_id,
  #     col_num,
  #     agency,
  #     program,
  #     display_name,
  #     value
  #   ) 

    # get client id by row and submission (Cid)
    #   I will need to go back in and do this
  
  # I should remove NAs at some point
  
  return(dl)
  
}

####################
####################  End of function  ##########################################
####################

y <- load_cld(dir, f)
