# server.R

source("C:/Users/jiang_y/Documents/R/Proj_Stock/Function_Strategy.R")
source("helpers.R")
loadUser("yj")

shinyServer(
  function(input, output) {
    
    # Create a reactiveValues object to show current status
    # The status info will be passed to loginfo output
    status <- reactiveValues()
    status$LastAction <- "Start"
    status$Pass <- TRUE
    status$Msg <- "Account initialized successfully!"

    observe({
      if (input$Save != 0) {
        status$LastAction <- 'Save'
        saveUser("yj")
        status$Pass <- TRUE
        status$Msg <- "Save account successfully!"
      }
    })
    
    observe({
      if (input$Load != 0) {
        status$LastAction <- 'Load'
        loadUser("yj")
        status$Pass <- TRUE
        status$Msg <- "Load account successfully!"
      }
    })

    observe({
      if (input$Reset != 0) {
        status$LastAction <- 'Reset'
        loadUser("yj")
        status$Pass <- TRUE
        status$Msg <- "Reset account successfully!"
      }
    })
    
    observe({
      if (input$Go != 0) {
        status$LastAction <- 'Go'
        
        actionStr = isolate({input$Action})
        itemStr = isolate({input$Item})
        parentName = isolate({input$selectParentName})
        newName = isolate({input$NewName})
        status0 <- takeAction(action=actionStr,item=itemStr,parent=parentName,name=newName)
        
        status$Pass <- status0$Pass
        status$Msg <- status0$Msg
      }
    })
                  
    output$selectParent <- renderUI({
      choiceList = switch(input$Item,
                          "Account"="yj",
                          "Portfolio"=acctList(),
                          "Stock"=potfList())
        
      selectInput("selectParentName", 
                  label = NULL, 
                  choices = choiceList, selected = 1)
      
    })
    
    output$inputNewName <- renderUI({
      newDefaultName = switch(input$Item,
                       "Account"="myA",
                       "Portfolio"="myP",
                       "Stock"="myS")
      textInput("NewName", 
                label = NULL, 
                value = newDefaultName)
      
    })

  


    output$logInfo <- renderUI({
      
      if (status$Pass == TRUE){
        logStr = paste("PASS",status$Msg,sep=": ")
        return(tags$div(HTML(paste(tags$span(style="color:green", logStr)))))
      } 
      else{
        logStr = paste("FAIL",status$Msg,sep=": ")
        return(tags$div(HTML(paste(tags$span(style="color:red", logStr)))))
      }  
    })
    
    output$accountFlowChart <- renderPlot({
      if ((input$Go==0)){drawFlowChart()}
      if ((input$Go!=0)){drawFlowChart()}
      if ((input$Save!=0)){drawFlowChart()}
      if ((input$Load!=0)){drawFlowChart()}
      if ((input$Reset!=0)){drawFlowChart()}            
    })
      
    
  }
)
