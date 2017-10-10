# this function loads the data in the format that we are looking for

####################  Start of function  ####################################
# cld for client level data

##### for some testing:  
# dir <-  "C:/Users/bgillis/Documents/GitHub/loading-sep2017-reporting-DATA/CSVs provided by Agencies/"
# files <- list.files(dir)
# f <- files[1]
# s <- 0

load_ind_data <- function(dir, f, s=0) {
  
  library(RODBC)
  library(reshape2)
  library(dplyr)
  library(readr)
  
  con.text <- "DRIVER=SQL Server Native Client 11.0;Database=testing;Server=UWCO-BGILLISLT;Port=1433;UID=bgillis;PWD=sweetness4"
  con <- con <- odbcDriverConnect(con.text)
  
  # We load the data without the names so that we can match the column names up later exactly
  d <- read_csv(paste0(dir,f), skip = s, col_names =F)
  
  # create a crosswalk from current column name (X1, X2, X3...) to the text ("Agency Profile: Org...)
  cnx <- data.frame(xname = names(d), name_text = as.character(d[1,]), stringsAsFactors = F)
  
  # now we can get rid of row1 from d since it is the column headers
  d <- d[-1,]
  
  # add in row id's
  d$row_id <- as.numeric(row.names(d))
  
  
  ########## match with the best id# #################
  
  # get agency program name
  agency <- as.character(d[1,1])
  program <- as.character(d[1,2])
  
  # get the list of id #'s
  ap.id <- sqlFetch(con, "agency_program_id", stringsAsFactors =F)
  names(ap.id) <- tolower(names(ap.id)) # set up names so I don't need to do this
  
  
  dist.test <- adist(paste(ap.id$agency, ap.id$program), paste(agency, program))
  # find the min in the list and the pull that id from the list, add it on to d
  d$ap_id <- rep(ap.id[which(dist.test == min(dist.test)),3],length(d$X1))
  
  # use the first occurrence of the agency and program
  d$agency <- rep(agency, length(d$X1))
  d$program <- rep(program, length(d$X1))
  
  #### we still need a flag for when more than 1 show up as an option
  ####  or a plan to check this after the fact
  
  ####################################################
  

  ################ melt the data #################################
  
  dl <- melt(d, id.vars= c("ap_id", "agency","program","row_id"), stringsAsFactors = F)
  
  # add back in the original names
  
  dl <- dl %>%
    left_join(cnx, by=c("variable"="xname")) %>%
    mutate(
      col_id = gsub('X','',variable),
      val = value
    ) %>%
    select(
      ap_id,
      agency,
      program,
      col_id,
      row_id,
      val,
      name_text
    )
  
  # add the submission name
  dl$submission <- rep(f, length(dl$agency))
  
  # remove NAs
  dl <- dl[is.na(dl$val)==0,]
  
  ################################################################
  
  # note tool should be identified in another location
  

  return(dl)
  
}

####################
####################  End of function  ##########################################
####################
