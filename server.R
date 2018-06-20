options(shiny.trace=TRUE)
library(shiny)
library(tabplot)
library(jsonlite)

library("RevoScaleR")
shinyServer(function(input, output) {
  
  USER <- reactiveValues(Logged = FALSE)
  
  output$uiLogin <- renderUI({
    if (USER$Logged == FALSE) {
      wellPanel(
        textInput("connection", "connection"),
        br(),
        actionButton("Login", "Log in")
      )
    }
  })

  output$pass <- renderText({
    cat(file=stderr(), "trying login", input$connection,"\n")
    if (USER$Logged == FALSE) {
      if (input$Login > 0) {
        connection <- input$connection
        if(connection != "")
        {
          USER$con <- NULL
          USER$Logged <- TRUE
          "Login Succeeded"
        }else
        {
          "All fields are required"
        }
      }
    }
  })
  
  
  output$ConnectdUI <- renderUI({
    if(USER$Logged == TRUE)
    {
      
    }
  })
  
})


## oracle implementation. Later switch with shinyApp or other kind of polymorphism
# library(ROracle)
# shinyServer(function(input, output) {
#   output$Tabellen = renderUI({
#     selectInput('tabellen2', 'Tabellen', tabledata()$TABLE_NAME)
#   })
#   output$Kolommen = renderUI({
#     columndata <- dbGetQuery(USER$con,"SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = :1 ORDER BY COLUMN_NAME",data = data.frame(table_name = input$tabellen2))
#     checkboxGroupInput('kolommen2', 'Kolommen', columndata$COLUMN_NAME)
#   })
#   
#   
#   tabledata <- reactive({dbGetQuery(USER$con,"SELECT table_name FROM user_tables ORDER BY table_name")})
#   
#   USER <- reactiveValues(Logged = FALSE)
#   
#   output$uiLogin <- renderUI({
#     if (USER$Logged == FALSE) {
#       wellPanel(
#         textInput("user", "username"),
#         passwordInput("pass", "password"),
#         textInput("tns", "tnsname"),
#         br(),
#         actionButton("Login", "Log in")
#       )
#     }
#   })
#   
#   output$pass <- renderText({
#     cat(file=stderr(), "trying login", input$user, input$pass, input$tns,"\n")
#     if (USER$Logged == FALSE) {
#       if (input$Login > 0) {
#         user <- input$user
#         pass <- input$pass
#         tnsname <- input$tns 
#         if(user != "" && pass != "" && tnsname != "")
#         {
#           drv <- dbDriver("Oracle")
#           USER$con <- dbConnect(drv, user, pass, tnsname )
#           USER$Logged <- TRUE
#           "Login Succeeded"
#         }else
#         {
#           "All fields are required"
#         }
#       } 
#     }
#   })
#   
#   output$ConnectdUI <- renderUI({
#     if(USER$Logged == TRUE)
#     {
#       # Sidebar
#       sidebarLayout(
#         sidebarPanel(
#           uiOutput('Tabellen'),
#           uiOutput('Kolommen'),
#           textInput("where", "Where")
#         ),
#         # Show a plot of the generated distribution
#         mainPanel(
#           tabsetPanel(
#             tabPanel("Plot",plotOutput("tableplot")),
#             tabPanel("Summary", verbatimTextOutput("summary")),
#             tabPanel("Table", dataTableOutput('mytable')),
#             tabPanel("JSON", verbatimTextOutput("jeeson"))
#           )
#         )
#       )
#     }
#   })
#   
#   dataInput <- reactive({
#     d <- data.frame()
#     if(length(input$kolommen2) > 1)
#     {
#       cols = paste(input$kolommen2, collapse = ', ')
#       query = paste("SELECT",cols,"FROM",input$tabellen2,sep = " ")
#       if(input$where == "" || is.null(input$where))
#       {
#         d <- dbGetQuery(USER$con,query)
#       }
#       else
#       {
#         d <- dbGetQuery(USER$con,paste(query,"WHERE",input$where,sep = " "))
#       }
#     }
#     else
#     {
#       if(input$where == "" || is.null(input$where))
#       {
#         d <- dbReadTable(USER$con, input$tabellen2)
#       }
#       else
#       {
#         d <- dbGetQuery(USER$con,paste("SELECT * FROM",input$tabellen2,"WHERE",input$where,sep = " "))
#       }
#     }
#     is.char <- sapply(d, is.character)
#     d[is.char] <- lapply(d[is.char], factor)
#     d
#   })
#   
#   
#   output$tableplot = renderPlot(
#     {
#       d <- dataInput()
#       if(nrow(d)>1)
#       {
#         tableplot(d)
#       }
#     }
#   )
#   output$mytable = renderDataTable({
#     dataInput()
#   })
#   
#   output$summary = renderPrint({ summary(dataInput() )})
#   
#   
#   output$jeeson = renderPrint({ prettify(toJSON(dataInput() )) })
#   
# })
