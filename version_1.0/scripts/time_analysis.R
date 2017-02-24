time_analysis = function(request_data, maintopic, start_date, end_date){
  
  if (maintopic == 'all'){
    d = request_data %>% filter(Request.Date>start_date & Request.Date<end_date & !is.na(Days.to.Respond))
  } else {
    d = request_data %>% filter(TopicBig %in% maintopic & Request.Date>start_date & Request.Date<end_date & !is.na(Days.to.Respond))
  }
  
  d$request_md = as.factor(paste(year(d$Request.Date),
                                 ifelse(month(d$Request.Date)<10,paste(0,month(d$Request.Date),sep=''),month(d$Request.Date)),sep='-'))
  d = d %>%
    dplyr::select(request_md, Days.to.Respond) %>%
    group_by(request_md) %>%
    summarise("Number of Records" = n(), "Average Respond Time (hour)" = 24*sum(Days.to.Respond)/n())
  
  dm = melt(d,id='request_md')
  
  ggplot(dm, aes(x=request_md, y=value, color=variable, group=variable)) + 
    geom_line(stat='identity',size=1)+
    labs(title='Time Series Analysis',x=NULL,y=NULL,fill='') +
    theme_bw() + 
    theme(panel.border = element_blank(), 
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          plot.title = element_text(face='bold', size=10, hjust=0.45),
          axis.text.x = element_text(size=5,angle=30,hjust=1),
          legend.title = element_blank(),
          legend.text = element_text(size=8),
          legend.position = c(0.75, 0.93))
}