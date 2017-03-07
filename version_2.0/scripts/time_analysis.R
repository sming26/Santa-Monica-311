time_analysis = function(full_data){
  
  d = full_data %>% filter(!is.na(Days.to.Respond))
  
  d$request_md = as.factor(paste(year(d$Request.Date),
                                 ifelse(month(d$Request.Date)<10,paste(0,month(d$Request.Date),sep=''),month(d$Request.Date)),sep='-'))
  d = d %>%
    dplyr::select(request_md, Days.to.Respond) %>%
    group_by(request_md) %>%
    summarise("Number of Records" = n(), "Average Respond Time" = ifelse(n()!=0,sum(24*Days.to.Respond)/n(),0))
  
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
    add_trace(y=~round(`Average Respond Time`, 2), name="Average Respond Time", mode='lines+markers') %>%
    layout(title = "Time Series Analysis",
           titlefont = list(size=15),
           xaxis = list(title = '', tickangle = -60, tickfont=list(size=8)),
           yaxis = list(title = '', tickfont=list(size=10)),
           legend = list(x = 0.69, y = 1.25, font=list(size=6)))
  
  p
}