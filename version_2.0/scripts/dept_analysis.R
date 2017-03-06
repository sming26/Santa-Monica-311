dept_analysis = function(maintopic, start_date, end_date){
  
  if (maintopic == 'all'){
    d = sm_full %>% filter(Request.Date>start_date & Request.Date<end_date & !is.na(Days.to.Respond))
  } else {
    d = sm_full %>% filter(TopicBig %in% maintopic & TopicBig %in% maintopic & Request.Date>start_date & Request.Date<end_date & !is.na(Days.to.Respond))
  }

  d = d %>%
    dplyr::select(Assigned.Department,Days.to.Respond) %>%
    group_by(Assigned.Department) %>%
    summarise("Number of Records" = n(), "Average Respond Time" = 24*10*sum(Days.to.Respond)/n())
  
  x_order = order(d$`Number of Records`,decreasing = T)
  d = d[c(x_order,length(x_order)+x_order),]
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
    add_trace(y=~`Average Respond Time`, name = "Average Respond Time (.1 hour)") %>%
    layout(title = "Assigned Department Analysis",
           titlefont = list(size=15),
           xaxis = list(title = '', tickangle = -20, tickfont=list(size=5)),
           yaxis = list(title = '', tickfont=list(size=8)),
           legend = list(x = 0.75, y = 1.05, font=list(size=6)),
           barmode = 'group')
  p
}

    