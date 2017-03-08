dept_analysis = function(maintopic, start_date, end_date){
  
  ## set the data for department analysis
  if (maintopic == 'All'){
    d = sm_full %>% filter(Request.Date>start_date & Request.Date<end_date)
  } else {
    d = sm_full %>% filter(TopicBig %in% maintopic & TopicBig %in% maintopic & Request.Date>start_date & Request.Date<end_date)
  }

  ## create the two metrics
  d = d %>%
    dplyr::select(Assigned.Department,Days.to.Respond) %>%
    group_by(Assigned.Department) %>%
    summarise("Number of Records" = n(), "Average Respond Time" = ifelse(n()!=0,24*sum(Days.to.Respond)/n(),0))
  
  ## order the x axis to decreasing order of count
  x_order = order(d$`Number of Records`,decreasing = T)
  d = d[x_order,]
  d$Assigned.Department = as.character(d$Assigned.Department)
  d$Assigned.Department = factor(d$Assigned.Department, levels=unique(d$Assigned.Department))
  # dm = melt(d,id='Assigned.Department')
  # x_order = order(dm[dm$variable=='Number of Records',3],decreasing = T)
  # dm2 = dm[c(x_order,length(x_order)+x_order),]
  # dm2$Assigned.Department = as.character(dm2$Assigned.Department)
  # dm2$Assigned.Department = factor(dm2$Assigned.Department, levels=unique(dm2$Assigned.Department))
  # 
#   ggplot(dm2, aes(x=Assigned.Department, y=value, fill=variable, group=variable)) + 
#     geom_bar(stat='identity', position = 'dodge') +
#     labs(title='Assigned Department Analysis',x=NULL,y=NULL,fill='') +
#     theme_bw() + 
#     theme(panel.border = element_blank(), 
#           panel.grid.major = element_blank(),
#           panel.grid.minor = element_blank(),
#           plot.title = element_text(face='bold', size=10, hjust=0.45),
#           axis.text.x = element_text(size=5,angle=30,hjust=1),
#           legend.title = element_blank(),
#           legend.text = element_text(size=8),
#           legend.position = c(0.85, 0.93),
#           legend.key = element_rect(fill = alpha("white", 0.0)))
# }
  p <- plot_ly(d, x=~Assigned.Department, y=~`Number of Records`, type='bar', name='Number of Records') %>%
    add_trace(y=~round(`Average Respond Time`,2), name = "Average Respond Hours") %>%
    layout(title = paste0(maintopic, " Topics Assigned Department Analysis"),
           titlefont = list(size=15),
           xaxis = list(title = '', tickangle = -25, tickfont=list(size=8)),
           yaxis = list(title = '', tickfont=list(size=10)),
           legend = list(x = 0.7, y = 1.05, font=list(size=6)),
           barmode = 'group')
  p
}

    