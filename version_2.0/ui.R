library(leaflet)
library(leaflet.extras)
library(shinydashboard)
source("./scripts/all_data_func.R")

## set drop-down menu options
maintopics = c("all", as.character(unique(sm_full$TopicBig)))
topics = c("all", as.character(unique(sm_full$Topic)))
depts = c("all", as.character(unique(sm_full$Assigned.Department)))


### header
header = dashboardHeader(title="Santa Monica 311")

### sidebar
sidebar = dashboardSidebar(
  tags$style(type='text/css', "button#reset { margin-left: 10.5px; }"),
  selectInput("maintopic", "Topic groups", maintopics, multiple = F, selectize = T),
  selectInput("subtopic", "Topics", topics, multiple = F, selectize = T),
  selectInput("dept", "Assigned departments", depts, multiple = F, selectize = T),
  dateRangeInput('dates',label = 'Date range',start = Sys.Date() - 365, end = Sys.Date()),
  actionButton("reset", label = "Reset")
)

### Body
body = dashboardBody(
  tags$head(tags$style(HTML(".small-box {height: 160px}"))),
  tags$style(type='text/css', '#ten {background-color: rgba(255,255,0,0.40); color: green;}'), 
  fluidRow(
    column(width=3,
           valueBoxOutput("numberOfRequest", width=NULL)),
    column(width=3,
           valueBoxOutput("respondTime", width=NULL)),
    column(width=6,
           verbatimTextOutput("countTop5"),
           verbatimTextOutput("timeBottom5"))
  ),
  fluidRow(
    column(width=6,
           box(width=NULL, leafletOutput("heatmap", height=240)),
           box(width=NULL, leafletOutput("circlemap", height=240))), 
    column(width = 6,
           box(width=NULL, plotlyOutput("dept_analysis", height=240)),
           box(width=NULL, plotlyOutput("time_analysis", height=240)))
  )
)

## overall layout
dashboardPage(
  header,
  sidebar,
  body,
  skin="blue"
)

