# server.R

source("C:/Users/jiang_y/Documents/R/Proj_Stock/Function_Strategy.R")
source("helpers.R")
loadUser("yj")

#initDataStr = outputStr()
#status <- list(Pass=TRUE,Msg="Account initialized successfully")

shinyServer(
  function(input, output) {
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

    
#     output$summary <- renderText({
#       input$Go
#       if (input$Go == 0)
#         return(initDataStr)
#       
#       actionStr = isolate({input$Action})
#       itemStr = isolate({input$Item})
#       parentName = isolate({input$selectParentName})
#       newName = isolate({input$NewName})
#       
#       takeAction(action=actionStr,item=itemStr,parent=parentName,name=newName)
#       
#       dataStr = paste(outputStr(),actionStr,itemStr,parentName,newName)
#     })
    
    goAction <- reactive({
      input$Go
      if (input$Go == 0){
        status <- list(Pass=TRUE,Msg="Account initialized successfully")
        return(status)
      }      
      actionStr = isolate({input$Action})
      itemStr = isolate({input$Item})
      parentName = isolate({input$selectParentName})
      newName = isolate({input$NewName})
      status <- takeAction(action=actionStr,item=itemStr,parent=parentName,name=newName)
      return(status)
    })


    output$logInfo <- renderUI({
      status = goAction()
      if(status$Pass==TRUE){
        logStr = paste("PASS: ",status$Msg,sep="")
        tags$div(HTML(paste(tags$span(style="color:green", logStr))))
      }
      else{
        logStr = paste("FAIL: ",status$Msg,sep="")
        tags$div(HTML(paste(tags$span(style="color:red", logStr))))
      }
#       input$Save
#       if (input$Save == 0)
#         return("Running OK")
#       saveUser("yj")
#       dataStr = "Data saved succesfully\n"
    })
    
    output$accountFlowChart <- renderPlot({      
      status = goAction()      
      drawFlowChart()
    })
      
    
  }
)
