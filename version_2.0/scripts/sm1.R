library(dplyr)
library(lubridate)

# sm = read.csv('Closed_GovOutreach_Submissions.csv', stringsAsFactors = F)
load('./dataset/sm_full.RData')
sm$Topic = as.character(sm$Topic)
topic_new$TopicSm = as.character(topic_new$TopicSm)
sm_full = left_join(sm,topic_new,by=c("Topic"="TopicSm"))
sm_full$TopicBig = ifelse(is.na(sm_full$TopicBig),'Others',sm_full$TopicBig)

# exclude status and location columns and rows with NA for lat-long
sm_full = sm_full[,-c(4,10)]
sm_full = sm_full[!is.na(sm_full$Days.to.Respond),]
sm_full$Request.Date = mdy(sm_full$Request.Date)
sm_full$Response.Date = mdy(sm_full$Response.Date)
sm_full$Assigned.Department = gsub('\\s+$','',sm_full$Assigned.Department)

# set unknown to missing department and stem first 4 characters for topics for grouping
sm_full$Assigned.Department[sm_full$Assigned.Department==''] = 'Unknown'
sm_full$Assigned.Department = as.factor(sm_full$Assigned.Department)
sm_full$TopicBig = as.factor(sm_full$TopicBig)
sm_full$Topic = as.factor(sm_full$Topic)

save(sm_full,file='sm_full_2.RData')
#load('sm.RData')
