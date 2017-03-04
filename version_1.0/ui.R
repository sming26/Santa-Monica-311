library(leaflet)
library(leaflet.extras)

## set drop-down menu options
types = c("all", "Environmental Issues - Impacts", "Police", 
          "Others","Big Blue Bus",                 
          "Trees", "Business License",              
          "Parking Issues", "Graffiti",                      
          "Water Services", "Code Enforcement",              
          "Miscellaneous", "Refuse and Recycling",         
          "Streets and Sidewalks", "Traffic Issues",               
          "Beach", "Human Resources",               
          "Parks and Recreation", "Bicycles",                      
          "Streetlights", "Animals",                       
          "Traffic Signals", "Construction",                  
          "Leafblowers", "City Facilities/Locations",     
          "Noise", "EXPO - Light Rail Line",        
          "Housing", "Zoning",                        
          "Cultural & Arts", "Homeless-Related Issues",       
          "ADA Issues", "Planning",                      
          "Taxis", "Customer Service Issues",       
          "Consumer Issues", "Rent Control",                  
          "Fire Department", "City Council",                  
          "Cable TV", "Library",                       
          "Events Permitted by City", "Filming",                       
          "Cemetery", "Fiber Optic Service")

depts = c("all", "Public Works", "Planning & Community Development", "City Manager", 
          "Police", "Finance", "Big Blue Bus", "Library", "Community & Cultural Services", 
          "Information Systems Division", "import_no_login", "Unknown", "City Clerk", "Rent Control", 
          "Housing & Economic Development", "City Attorney", "Fire", "Human Resources")

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
                    selectInput("maintopic", "Topic groups", types, multiple = F, selectize = T),
                    selectInput("subtopic", "Topics", types, multiple = T, selectize = T),
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
