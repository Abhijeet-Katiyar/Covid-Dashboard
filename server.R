#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyverse)


source("DataPreprocessing.R")
data <- read_csv("covid_19_india.csv")
data <- clean(data)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    results <- reactive({
        if(input$condition == "Confirmed") {
            c("daily_confirmed","Confirmed","#b39e69","Daily Confirmed Cases","Cumulative Confirmed Cases")
        }
        else if(input$condition == "Deaths") {
            c("daily_deaths","Deaths","#a81d1d","Daily Deaths","Cumulative Deaths")
        }
        else if(input$condition == "Cured") {
            c("daily_cured","Cured","#69b3a2","Daily Cured","Cumulative Cured")
        }
    })
    
    output$dailyPlot <- renderPlotly({
        ggplotly(
            filter(data,StateAndUnionTerritories == input$state) %>%
                     ggplot(aes_string(x = "Date", y = results()[1], group = "1")) +
                     geom_area(fill=results()[3], alpha=0.5) +
                     geom_line(color=results()[3]) +
                     ylab(results()[4]) +
                     scale_x_date(date_breaks = "1 month", date_labels = "%b-%Y") + 
                     theme(axis.text.x = element_text(angle=90))
            ) 
        
    })
    output$cumulativePlot <- renderPlotly({
        ggplotly(filter(data,StateAndUnionTerritories == input$state) %>%
                     ggplot(aes_string(x = "Date", y = results()[2], group = "1")) +
                     geom_line(color=results()[3]) +
                     ylab(results()[5]) + scale_x_date(date_breaks = "1 months", date_labels = "%b-%Y") + 
                     theme(axis.text.x = element_text(angle=90))
                 )
    })
    
}