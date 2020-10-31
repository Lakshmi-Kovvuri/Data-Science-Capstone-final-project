suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
shinyUI(navbarPage("Coursera's Data Science Capstone: Final Project",
                   tabPanel("Next Word Predictor",
                            HTML("<strong>Author: Lakshmi Kovvuri </strong>"),
                            br(),
                            img(src = "headers.png"),
                            # Sidebar
                            sidebarLayout(
                              sidebarPanel(
                                textInput("inputString", "Type here and click on the 'Predict' button",value = ""),
                                submitButton('Predict'),
                                br(),
                                br()
                              ),
                              mainPanel(
                                h2("The suggested next word for your text input is"),
                                verbatimTextOutput("prediction"),
                                strong("You entered the following word or phrase as Input to the application:"),
                                tags$style(type='text/css', '#text1 {background-color: rgba(0,255,0,0.4 ); color: blue;}'), 
                                textOutput('text1')
                              )
                            )
                            
                   ),
                   tabPanel("Overview",
                            mainPanel(
                              img(src = "./headers.png"),
                              #includeMarkdown("Overview.md")
                            ) ),
                   
                   tabPanel("Instructions",
                   mainPanel(
                     #includeMarkdown("README.md")
                   )
)
                   
)
                   
                   
                   
)
) 
