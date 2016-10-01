library(RSQLite)
library(gWidgets2)
library(gWidgets2tcltk)

setwd("C:\\Path\\To\\Working\\Directory")

df <- read.csv("DATA\\IncData.csv", stringsAsFactors = FALSE,
               col.names = c("RANK", "INC_YEAR", "COMPANY", "THREE_YR_GROWTH",
                             "REVENUE", "INDUSTRY", "YEARS", "METRO_AREA" ))
df$YEARS <- ifelse(is.na(df$YEARS), "", df$YEARS)

mainWindow <- function(makelist){
  win <- gWidgets2::gwindow("Reports Menu", height = 220, width = 400)
  
  tbl <- glayout(cont=win, spacing = 3)
  
  tbl[1,1] <- gimage(filename = "IMG\\IncDataIcon.gif", 
                     dirname = getwd(), container = tbl)
  
  tbl[1,2] <- glabel("        INC 5000 Company Reports        ", container = tbl)
  font(tbl[1,2]) <- list(size=16, family="Arial")
  
  # INDUSTRY
  tbl[2,1] <- glabel("   Industry  ", container = tbl)
  tbl[2,2] <- industrycbo <- gcombobox(c("", sort(unique(df$INDUSTRY))), selected = 1, editable = TRUE, container = tbl)
  font(tbl[2,1]) <- font(tbl[2,2]) <- list(size=14, family="Arial")
  
  # YEAR
  tbl[3,1] <- glabel("   Year", container = tbl)
  tbl[3,2] <- yearcbo <-gcombobox(c("", sort(unique(df$INC_YEAR))), selected = 1, editable = TRUE, container = tbl)
  font(tbl[3,1]) <- font(tbl[3,2]) <-  list(size=14, family="Arial")
  
  # METRO
  tbl[4,1] <- glabel("   Metro", container = tbl)
  tbl[4,2] <- metrocbo <- gcombobox(c("", sort(unique(df$METRO_AREA))), selected = 1, editable = TRUE, container = tbl)
  font(tbl[4,1]) <- font(tbl[4,2]) <- list(size=14, family="Arial")
  
  tbl[5,2] <- btnoutput <- gbutton("Open Table", container = tbl)
  font(tbl[5,2]) <- list(size=10, family="Arial")

  
  addHandlerChanged(btnoutput, handler=function(...){
    filterdf <- (df$COMPANY != "")
      
    if (length(svalue(industrycbo)) > 0) { filterdf <- filterdf & (df$INDUSTRY == svalue(industrycbo)) }
    if (length(svalue(yearcbo)) > 0) { filterdf <- filterdf & (df$INC_YEAR == svalue(yearcbo)) }
    if (length(svalue(metrocbo)) > 0) { filterdf <- filterdf & (df$METRO_AREA == svalue(metrocbo)) }
    
    tempdf <- df[filterdf,]
    
    tblwin <- gWidgets2::gwindow("Output Table", height = 450, width = 1200)
    tab <- gtable(tempdf, chosencol = 2, container=tblwin, expand=TRUE, fill=TRUE)
    
  })
}


mainWindow()
