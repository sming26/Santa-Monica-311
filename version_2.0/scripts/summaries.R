summaries = function(full_data, start_date, end_date, dept) {
  
  # numberOfRequest
  numberOfRequest = nrow(full_data)
  
  # respondTime
  respondTime = round(ifelse(numberOfRequest!=0,sum(full_data$Days.to.Respond)/numberOfRequest,0),2)
  
  if (dept == 'All'){
    d = sm_full %>% filter(Request.Date>start_date & Request.Date<end_date)
  } else {
    d = sm_full %>% filter(Request.Date>start_date & Request.Date<end_date & Assigned.Department==dept)
  }
  ten = d %>% group_by(TopicBig) %>% summarise(count=n(),time=ifelse(n()!=0,sum(Days.to.Respond)/n(),0))
  
  # countTop5
  countTop5 = as.character(ten$TopicBig[order(ten$count,decreasing=T)][1:5])
  
  # timeBottom5
  timeBottom5 = as.character(ten$TopicBig[order(ten$time)][1:5])
  
  summaries = list(numberOfRequest,respondTime,countTop5,timeBottom5)
  return(summaries)
}