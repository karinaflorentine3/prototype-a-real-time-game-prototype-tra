# Prototype a Real-Time Game Prototype Tracker

# Load required libraries
library(shiny)
library(DT)

# Define UI for game tracker
ui <- fluidPage(
  titlePanel("Real-Time Game Prototype Tracker"),
  sidebarLayout(
    sidebarPanel(
      textInput("game_name", "Enter Game Name:"),
      actionButton("add_game", "Add Game"),
      hr(),
      textInput("feature_name", "Enter Feature Name:"),
      actionButton("add_feature", "Add Feature"),
    ),
    mainPanel(
      DT::dataTableOutput("game_table"),
      DT::dataTableOutput("feature_table")
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Create reactive values
  game_list <- reactiveValues(data = data.frame(Game = character(), Features = character()))
  feature_list <- reactiveValues(data = data.frame Feature = character(), Game = character())
  
  # Add game
  observeEvent(input$add_game, {
    new_game <- input$game_name
    if (nrow(game_list$data) == 0 || !new_game %in% game_list$data$Game) {
      game_list$data <- rbind(game_list$data, data.frame(Game = new_game, Features = ""))
    }
  })
  
  # Add feature
  observeEvent(input$add_feature, {
    new_feature <- input$feature_name
    game <- isolate(input$game_name)
    if (nrow(feature_list)data) == 0 || !new_feature %in% feature_list$data$Feature) {
      feature_list$data <- rbind(feature_list$data, data.frame(Feature = new_feature, Game = game))
      game_list$data[game_list$data$Game == game, ]$Features <- paste(game_list$data[game_list$data$Game == game, ]$Features, new_feature, sep = ", ")
    }
  })
  
  # Render game table
  output$game_table <- DT::renderDataTable({
    game_list$data
  })
  
  # Render feature table
  output$feature_table <- DT::renderDataTable({
    feature_list$data
  })
}

# Run the application
shinyApp(ui = ui, server = server)