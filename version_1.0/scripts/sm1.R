library(dplyr)
library(lubridate)

sm = read.csv('Closed_GovOutreach_Submissions.csv', stringsAsFactors = F)

# exclude status and location columns and rows with NA for lat-long
sm1 = sm[,-c(4,10)]
sm1 = sm1[!(is.na(sm1$Latitude) | is.na(sm1$Longitude) | is.na(sm1$Days.to.Respond)),]
sm1$Request.Date = mdy(sm1$Request.Date)
sm1$Response.Date = mdy(sm1$Response.Date)
sm1$Assigned.Department = gsub('\\s+$','',sm1$Assigned.Department)

# set unknown to missing department and stem first 4 characters for topics for grouping
sm1$Assigned.Department[sm1$Assigned.Department==''] = 'Unknown'
sm1$Type = substr(sm1$Topic,1,4)
sm1$Assigned.Department = as.factor(sm1$Assigned.Department)
sm1$Type = as.factor(sm1$Type)

#save(sm1,file='sm1.RData')
#load('sm1.RData')
