## My First Shiny App ##

# Loading packages
if (!require(pacman)) {
  install.packages("pacman")
}

pacman::p_load(shiny, ggplot2, dplyr, tidyr)

# Building App
ui <- fluidPage(
  h1("My First Shiny App"),
  p("This is my first Shiny app! Here I'm using the Iris dataset."),
  plotOutput("graph_1")
)

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

shinyApp(ui, server)