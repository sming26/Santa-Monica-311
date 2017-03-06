time_analysis = function(maintopic, subtopic, dept, start_date, end_date){
  
  d = sm_full %>% filter(!is.na(Days.to.Respond))
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
  
  d$request_md = as.factor(paste(year(d$Request.Date),
                                 ifelse(month(d$Request.Date)<10,paste(0,month(d$Request.Date),sep=''),month(d$Request.Date)),sep='-'))
  d = d %>%
    dplyr::select(request_md, Days.to.Respond) %>%
    group_by(request_md) %>%
    summarise("Number of Records" = n(), "Average Respond Time" = 24*sum(Days.to.Respond)/n())
  
  # dm = melt(d,id='request_md')
  # 
  # ggplot(dm, aes(x=request_md, y=value, color=variable, group=variable)) + 
  #   geom_line(stat='identity',size=1)+
  #   labs(title='Time Series Analysis',x=NULL,y=NULL,fill='') +
  #   theme_bw() + 
  #   theme(panel.border = element_blank(), 
  #         panel.grid.major = element_blank(),
  #         panel.grid.minor = element_blank(),
  #         plot.title = element_text(face='bold', size=10, hjust=0.45),
  #         axis.text.x = element_text(size=5,angle=60,hjust=1),
  #         legend.title = element_blank(),
  #         legend.text = element_text(size=8),
  #         legend.position = c(0.85, 1),
  #         legend.key = element_rect(fill = alpha("white", 0.0)))
  p = plot_ly(d,x=~request_md, y=~`Number of Records`, name="Number of Records", type='scatter', mode='lines+markers') %>%
    add_trace(y=~`Average Respond Time`, name="Average Respond Time", mode='lines+markers') %>%
    layout(title = "Time Series Analysis",
           titlefont = list(size=15),
           xaxis = list(title = '', tickangle = -60, tickfont=list(size=6)),
           yaxis = list(title = '', tickfont=list(size=8)),
           legend = list(x = 0.7, y = 1.2, font=list(size=6)))
  
  p
}