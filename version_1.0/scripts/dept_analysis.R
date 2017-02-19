dept_analysis = function(start_date, end_date){
  
  library(ggplot2)
  library(reshape2)
  
  d = sm1 %>%
    filter(Request.Date>start_date & Request.Date<end_date) %>%
    select(Assigned.Department,Days.to.Respond) %>%
    group_by(Assigned.Department) %>%
    summarise("Number of Records" = n(), "Average Respond Time (0.5 hours)" = 48*sum(Days.to.Respond)/n())
  
  dm = melt(d,id='Assigned.Department')
  
  ggplot(dm, aes(x=reorder(Assigned.Department,-value), y=value, color=variable, group=variable)) + 
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
