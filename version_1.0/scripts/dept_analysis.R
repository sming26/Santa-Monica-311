dept_analysis = function(request_data, maintopic, start_date, end_date){
  
  library(ggplot2)
  library(reshape2)
  
  if (maintopic == 'all'){
    d = request_data %>% filter(Request.Date>start_date & Request.Date<end_date & !is.na(Days.to.Respond))
  } else {
    d = request_data %>% filter(TopicBig %in% maintopic & Request.Date>start_date & Request.Date<end_date & !is.na(Days.to.Respond))
  }

  d = d %>%
    dplyr::select(Assigned.Department,Days.to.Respond) %>%
    group_by(Assigned.Department) %>%
    summarise("Number of Records" = n(), "Average Respond Time (hour)" = 24*sum(Days.to.Respond)/n())
  
  dm = melt(d,id='Assigned.Department')
  x_order = order(dm[dm$variable=='Number of Records',3],decreasing = T)
  dm2 = dm[c(x_order,length(x_order)+x_order),]
  dm2$Assigned.Department = as.character(dm2$Assigned.Department)
  dm2$Assigned.Department = factor(dm2$Assigned.Department, levels=unique(dm2$Assigned.Department))
  
  ggplot(dm2, aes(x=Assigned.Department, y=value, color=variable, group=variable)) + 
    geom_line(stat='identity',size=1)+
    labs(title='Assigned Department Analysis',x=NULL,y=NULL,fill='') +
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
