library(leaflet)

## set drop-down menu options
types = c("all", "Tree", "Graf", "Othe", "Wate", "Fenc", "Refu", "Stre", "Sign", "Poli", "Poth", "Pref", "Brok", "Sewe",
          "Park", "Nois", "Leaf", "Home", "Dist", "Pede", "Cont", "Weed", "Cons", "Big ", "Bus ", "Bark", "Libr",
          "Airp", "Ille", "Anim", "Pier", "Subs", "Main", "Stop", "Bicy", "Trip", "Dial", "Misc", "Fare", "Expo",
          "Spee", "Zoni", "Unpe", "Auto", "Equi", "Debr", "Soci", "Bike", "Cabl", "Truc", "Lost", "Empt", "Curb",
          "Even", "Cros", "Deli", "Bays", "Beac", "Publ", "Non-", "Sche", "Gene", "Drug", "Flas", "Urba", "Sust",
          "Farm", "Shor", "Film", "Fibe", "Inve", "Haza", "Gang", "Hour", "Ceme", "Mobi", "Plan", "Loud", "Leas")

depts = c("all", "Public Works", "Planning & Community Development", "City Manager", 
          "Police", "Finance", "Big Blue Bus", "Library", "Community & Cultural Services", 
          "Information Systems Division", "import_no_login", "Unknown", "City Clerk", "Rent Control", 
          "Housing & Economic Development", "City Attorney", "Fire", "Human Resources")

ui <- navbarPage(
  
  "Santa Monica 311 Request Analysis",
  
  fluid = TRUE, 
  
  tabPanel("Interactive map",
           div(class="outer",
               
               tags$head(
                 ## Include our custom CSS
                 includeCSS("./plug-in/styles.css"),
                 includeScript("./plug-in/gomap.js")
               ),
               
               leafletOutput("map", width="100%", height="100%"),
               
               
               ## Shiny versions prior to 0.11 should use class="modal" instead.
               absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                             width = 330, height = "auto",
                             
                             h2("Requests explorer"),
                             
                             selectInput("type", "Request types", types, multiple = T, selectize = T),
                             selectInput("dept", "Assigned departments", depts, multiple = T, selectize = T),
                             dateRangeInput('dates',
                                            label = 'Date range',
                                            start = Sys.Date() - 365, end = Sys.Date()),
                             actionButton("reset", label = "Reset", style='padding:4px'),
                             plotOutput("dept_analysis", height = 200)
                             # Other auxiliary plots
               )
           )
  ))
