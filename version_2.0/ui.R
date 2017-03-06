library(leaflet)
library(leaflet.extras)
source("./scripts/all_data_func.R")

## set drop-down menu options
maintopics = c("all", as.character(unique(sm_full$TopicBig)))
topics = c("all", as.character(unique(sm_full$Topic)))
depts = c("all", as.character(unique(sm_full$Assigned.Department)))

ui <- fluidPage(
  
  titlePanel = 'Santa Monica 311',
  sidebarLayout(position='right',
    sidebarPanel( 
      
      tags$head(
        ## Include our custom CSS
        includeCSS("./plug-in/styles.css"),
        includeScript("./plug-in/gomap.js")),
      
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                    draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                    width = 330, height = "auto",
                    selectInput("maintopic", "Topic groups", maintopics, multiple = F, selectize = T),
                    selectInput("subtopic", "Topics", topics, multiple = F, selectize = T),
                    selectInput("dept", "Assigned departments", depts, multiple = F, selectize = T),
                    dateRangeInput('dates',label = 'Date range',start = Sys.Date() - 365, end = Sys.Date()),
                    actionButton("reset", label = "Reset", style='padding:4px'),
                    tags$style(type='text/css', "#control {position:relative;width:240px;height:300px;top:10px;right:10px;}"))),
    
    mainPanel(id="plots",
      tags$style(type='text/css', "#plots {width:960px;height:680px}"),
      fluidRow(
        column(width=6,
               leafletOutput("heatmap", width = 480, height = 340)),
        column(width=6,
               plotOutput("dept_analysis", width = 480, height = 340))), 
      fluidRow(
        column(width=6,
               leafletOutput("circlemap", width = 480, height = 340)),
        column(width=6,
               plotOutput("time_analysis", width = 480, height = 340)))
    )
  )
)
