
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Interest Calculation"),
  
  # Sidebar with a slider input for interest pa. 
  sidebarLayout(
    sidebarPanel(
      radioButtons("currFormat", "Select the currency",  c("Indian Rupees - Rs." = "Rs.","US Dollars - USD" = "USD","British Pounds - GPB" = "GPB","Euros - EUR"="EUR")),
      sliderInput("principal",
                  "Principal Amount:",
                  min = 1,
                  max = 500000,
                  value = 100000),
       sliderInput("int",
                   "Interest (PA):",
                   min = 1,
                   max = 15,
                   value = 5),
       
      sliderInput("tenure",
                  "Tenure (Years):",
                  min = 1,
                  max = 15,
                  value = 5),
      
       #checkboxInput("outliers", "Show BoxPlot's outliers", FALSE),
      radioButtons("intType", "Select the type of interest",
                   c("Simple","Compound"), "Simple", TRUE),
      
      selectInput("compounding", "Compounding Frequency", c("Monthly","Quarterly","Half-Yearly","Yearly"),
                  "Yearly", FALSE, FALSE, width='100%',
                  1)
      
      ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       tableOutput("intTable")
       #dataTableOutput("intTable")
    )
  )
))
