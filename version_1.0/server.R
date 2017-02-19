library(shiny)
library(dplyr)

source("./scripts/all_data_func.R")

departs = c("Public Works", "Planning & Community Development", "City Manager", 
            "Police", "Finance", "Big Blue Bus", "Library", "Community & Cultural Services", 
            "Information Systems Division", "import_no_login", "Unknown", "City Clerk", "Rent Control", 
            "Housing & Economic Development", "City Attorney", "Fire", "Human Resources")

server <- function(input, output, session) {
  
  #### initialize the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -118.45, lat = 34.02, zoom = 12)
  })
  
  # A reactive expression that returns the set of requests that are in bounds right now
  # requestsInBounds <- reactive({
  #   if (is.null(input$map_bounds))
  #     return(sm1[FALSE,])
  #   bounds <- input$map_bounds
  #   latRng <- range(bounds$north, bounds$south)
  #   lngRng <- range(bounds$east, bounds$west)
  # 
  #   subset(sm1,
  #          Latitude >= latRng[1] & Latitude <= latRng[2] &
  #            Longitude >= lngRng[1] & Longitude <= lngRng[2])
  # })
  
  #### reset all the circles and auxiliary plots
  observeEvent(input$reset, {
    leafletProxy('map') %>% clearShapes() %>% clearControls()
    updateSelectInput(session, 'type', selected = character(0))
    updateSelectInput(session, 'dept', selected = character(0))
    updateDateRangeInput(session, 'dateRange', start = Sys.Date(), end = Sys.Date())
    output$dept_analysis = renderPlot({})
    # more plots
  }) 
  
  #### draw the circles and auxiliary plots
  observe({
    ## select the circle data
    if (length(input$type)==0 || length(input$dept)==0) {
      output$dept_analysis = renderPlot({})
      # more plots
    } else if ('all' %in% input$type & 'all' %in% input$dept) {
      circle_data = sm1 %>% filter(Request.Date>input$dates[1] & Request.Date<input$dates[2])
      updateSelectInput(session, 'type', selected = 'all')
      updateSelectInput(session, 'dept', selected = 'all')
    } else if ('all' %in% input$type) {
      circle_data = sm1 %>% filter(Assigned.Department %in% input$dept & Request.Date>input$dates[1] & Request.Date<input$dates[2])
      updateSelectInput(session, 'type', selected = 'all')
    } else if ('all' %in% input$dept) {
      circle_data = sm1 %>% filter(Type %in% input$type & Request.Date>input$dates[1] & Request.Date<input$dates[2])
      updateSelectInput(session, 'dept', selected = 'all')
    } else {
      circle_data = sm1 %>% filter(Assigned.Department %in% input$dept & Type %in% input$type & Request.Date>input$dates[1] & Request.Date<input$dates[2])
    }
    
    ## Color and palette are set by the departments
    if (length(input$type)==0 || length(input$dept)==0) {
      leafletProxy('map') %>% clearShapes() %>% clearControls()
    } else {
      colorData <- circle_data$Assigned.Department
      pal <- colorFactor(palette = palette(rainbow(12)),
                         domain=departs)
      
      ## radius are set by response time for the data point divided by max rsponse time multiply 100
      max_size <- max(circle_data$Days.to.Respond)
      
      ## set layerId as request ID to ensure all circles shown on the map
      leafletProxy("map", data = circle_data) %>%
        addCircles(~Longitude, ~Latitude, radius=~Days.to.Respond/max_size*100, layerId=~Request.ID,
                   stroke=FALSE, fillOpacity=0.6, fillColor=pal(colorData), group='circles') %>%
        addLegend("bottomleft", pal=pal, values=colorData, title='Departments', layerId="colorLegend") 
      
      ## auxiliary plots
      output$dept_analysis <- renderPlot({
        # If no requests are in view, don't plot
        # if (nrow(requestsInBounds()) == 0)
        #   return(NULL)
        dept_analysis(input$dates[1],input$dates[2])
      })
      # more plots
    }
  })
  
  #### Show a pop-up for selected request
  showRequestPopup <- function(layer, lat, lng) {
    selectedRequest <- sm1[sm1$Request.ID == layer,]
    content <- as.character(tagList(
      sprintf("Request ID: %s", selectedRequest$Request.ID), tags$br(),
      sprintf("Request type: %s", selectedRequest$Topic), tags$br(),
      sprintf("Request date: %s", selectedRequest$Request.Date), tags$br(),
      sprintf("Response date: %s", selectedRequest$Response.Date), tags$br(),
      sprintf("Days to respond: %s", selectedRequest$Days.to.Respond), tags$br()
    ))
    
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = layer)
  }
  
  #### When map is clicked, clear pop-up
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showRequestPopup(event$id, event$lat, event$lng)
    })
  })
}

