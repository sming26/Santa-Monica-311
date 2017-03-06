summaries = function(maintopic, subtopic, dept, start_date, end_date) {
  
  if (maintopic == 'all' & subtopic == 'all' & dept == 'all') {
    d = sm_full %>% filter(Request.Date>start_date & Request.Date<end_date)
  } else if (maintopic == 'all' & subtopic == 'all') {
    d = sm_full %>% filter(Assigned.Department==dept & Request.Date>start_date & Request.Date<end_date)
  } else if (maintopic == 'all' & dept == 'all') {
    d = sm_full %>% filter(Topic==subtopic & Request.Date>start_date & Request.Date<end_date)
  } else if (subtopic == 'all' & dept == 'all') {
    d = sm_full %>% filter(TopicBig==maintopic & Request.Date>start_date & Request.Date<end_date)
  } else if (maintopic == 'all') {
    d = sm_full %>% filter(Topic==subtopic & Assigned.Department==dept & Request.Date>start_date & Request.Date<end_date)
  } else if (subtopic == 'all') {
    d = sm_full %>% filter(TopicBig==maintopic & Assigned.Department==dept & Request.Date>start_date & Request.Date<end_date)
  } else if (dept == 'all') {
    d = sm_full %>% filter(TopicBig==maintopic & Topic==subtopic & Request.Date>start_date & Request.Date<end_date)
  } else {
    d = sm_full %>% filter(TopicBig==maintopic & Topic==subtopic & Assigned.Department==dept & Request.Date>start_date & Request.Date<end_date)
  }
  
  numberOfRequest = nrow(d)
  
  d1 = d %>% filter(!is.na(Days.to.Respond))
  respondTime = round(sum(d1$Days.to.Respond)/numberOfRequest,2)
  
  d2 = sm_full %>% filter(Request.Date>"2016-01-01" & Request.Date<"2016-12-31")
  ten = d2 %>% dplyr::select(TopicBig, Days.to.Respond) %>% group_by(TopicBig) %>% summarise(count=n(),time=sum(Days.to.Respond)/n())
  countTop5 = as.character(ten$TopicBig[order(ten$count,decreasing=T)][1:5])
  timeBottom5 = as.character(ten$TopicBig[order(ten$time)][1:5])
  
  summaries = list(numberOfRequest,respondTime,countTop5,timeBottom5)
  return(summaries)
}