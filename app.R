## My First Shiny App ##

# Loading packages
if (!require(pacman)) {
  install.packages("pacman")
}

pacman::p_load(shiny, ggplot2, dplyr, tidyr)

# Building App

# User interface
ui <- fluidPage(
  h1("My First Shiny App"), # Title
  p("This is my first Shiny app! Here I'm using the Iris dataset."), # Paragraph
  plotOutput("graph_1") # Plotting output: graph
)

# Server (where the R processing happens)
server <- function(input, output, session) {
  output$graph_1 <- renderPlot(
    iris %>%
      group_by(Species) %>%
      summarise(across(everything(), 
                       mean)) %>%
      pivot_longer(!Species, 
                   names_to = "attribute", 
                   values_to = "mean", 
                   names_transform = list(attribute = factor)) %>%
      ggplot(aes(x = attribute, y = mean, fill = Species)) +
      geom_bar(position = "dodge", stat = "identity") +
      labs(title = "Species attributes means",
           x = "Attributes",
           y = "Mean") +
      theme_minimal()
  )
}

# Rendering the app
shinyApp(ui, server)