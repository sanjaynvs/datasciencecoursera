#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(formattable)
#Define Simple interest
calcSimpleInt <- function(p,r,t=1){
  r <- r/100
  round(p*(1+r/t),2)
}

#Define Compound interest
calcCmpdInt <- function(p,r,t=1,n="Yearly"){
  compIntBreaks <- c(12,4,2,1)
  names(compIntBreaks) <- c("Monthly","Quarterly","Half-Yearly","Yearly")
  r <- r/100
  nt<-compIntBreaks[n]
  round(p*((1+r/nt)^(nt*t)),2)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  output$distPlot <- renderPlot({
  totAmt <- 0;

    if(input$intType=="Simple")
      totAmt<-calcSimpleInt(input$principal, input$int, input$tenure)
    else
      totAmt<-calcCmpdInt(input$principal, input$int, input$tenure, input$compounding)
    
    # draw the pie chart
    pie(x=c(input$principal,totAmt-input$principal), labels = c("Principal","Interest"), main = "Interest Calculations - Overall amount and interest", col = c("red","blue"))
  })
  
  output$intTable <- renderTable({
    totAmt <- 0
    
    if(input$intType=="Simple")
      totAmt<-calcSimpleInt(input$principal, input$int, input$tenure)
    else
      totAmt<-calcCmpdInt(input$principal, input$int, input$tenure, input$compounding)
    
    prVal = as.character(currency(input$principal, symbol = input$currFormat))
    intVal = as.character(currency(totAmt - input$principal, symbol = input$currFormat))
    totalVal = as.character(currency(totAmt, symbol = input$currFormat))
     opDF = data.frame(Principal = prVal,
                      Interest = intVal,
                      Total = totalVal)
    opDF
    
  }
  )
      
  # for dynamically adding compound interest
  observeEvent(input$intType, {
    if(input$intType=="Compound"){
    insertUI(
      selector = "#intType",
      where = "afterEnd",
      ui = selectInput("compounding", "Compounding Frequency", c("Monthly","Quarterly","Half-Yearly","Yearly"),
                       "Yearly", FALSE, FALSE, width='100%',
                       1)
    )
    }else{
       updateSelectInput(session, "compounding", "")
      #This update Select is put for workaround for removing the label
       removeUI(
         selector = "#compounding"
            )
      
    }
    
  } 
  )
})
