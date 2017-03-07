## load datasets
library(curl)
library(dplyr)
library(lubridate)
load('./dataset/topic.RData')
endpoint <- "https://data.smgov.net/resource/tsas-mvez.csv?$limit=50000&$offset="
url <- NULL
sm <- NULL
for (i in seq(0,1500000000000,50000)){
  options("scipen"=20)
  
  url <- append(url,paste(endpoint,i,sep = ""))
  a <- length(url)
  curl_download(url[a],"./dataset/sm2.csv",
               quiet=TRUE,mode="wb",
               handle=new_handle())
  sm_one <- read.csv("./dataset/sm2.csv")
  if (nrow(sm_one)>1){
    sm <- rbind(sm,sm_one)
  }
  else{
    break
  }
}

sm<- sm[,c("Request.ID","Topic","Assigned.Department","Request.Date",
             "Response.Date","Days.to.Respond","Latitude","Longitude")]
sm$Topic = as.character(sm$Topic)
topic_new$TopicSm = as.character(topic_new$TopicSm)
sm_full = left_join(sm,topic_new,by=c("Topic"="TopicSm"))
sm_full$TopicBig = ifelse(is.na(sm_full$TopicBig),'Others',sm_full$TopicBig)

# exclude status and location columns and rows with NA for lat-long
sm_full = sm_full[!is.na(sm_full$Days.to.Respond),]
sm_full$Request.Date = mdy(sm_full$Request.Date)
sm_full$Response.Date = mdy(sm_full$Response.Date)
sm_full$Assigned.Department = gsub('\\s+$','',sm_full$Assigned.Department)

# set unknown to missing department and stem first 4 characters for topics for grouping
sm_full$Assigned.Department[sm_full$Assigned.Department==''] = 'Unknown'
sm_full$Assigned.Department = as.factor(sm_full$Assigned.Department)
sm_full$TopicBig = as.factor(sm_full$TopicBig)
sm_full$Topic = as.factor(sm_full$Topic)


## load functions
source("./scripts/dept_analysis.R")
source("./scripts/time_analysis.R")
source("./scripts/summaries.R")
