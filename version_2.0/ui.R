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
  selectInput("maintopic", "Topic groups", maintopics, multiple = F, selectize = T),
  selectInput("subtopic", "Topics", topics, multiple = F, selectize = T),
  selectInput("dept", "Assigned departments", depts, multiple = F, selectize = T),
  dateRangeInput('dates',label = 'Date range',start = Sys.Date() - 365, end = Sys.Date()),
  actionButton("reset", label = "Reset"),
  tags$style(type='text/css', "button#reset { margin-left: 10.5px; }")
)

### 
body = dashboardBody(
  mainPanel(id="plots",
            tags$style(type='text/css', "#plots {width:960px;height:680px}"),
            
            fluidRow(
              valueBoxOutput("numberOfRequest"),
              valueBoxOutput("respondTime"),
              valueBoxOutput("increase")
            ),
            fluidRow(
              column(width=6,
                     box(width = NULL,
                         leafletOutput("heatmap", height = 300)),
                     box(width = NULL,
                            leafletOutput("circlemap", height = 300))), 
              column(width = 6,
                     box(width = NULL,
                         plotOutput("dept_analysis",height = 300)),
                     box(width = NULL,
                         plotOutput("time_analysis", height = 300)))
            )
  )
)

## overall layout
dashboardPage(
  header,
  sidebar,
  body,
  skin="blue"
)

