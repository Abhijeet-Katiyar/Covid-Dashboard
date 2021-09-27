#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(tidyverse)
library(ggplot2)
library(scales)

source("DataPreprocessing.R")
data <- read_csv("covid_19_india.csv")
data <- clean(data)
library(shinythemes)


ui <- fluidPage(theme = shinytheme("cerulean"),
  titlePanel("Covid-19 cases in India"),
  fluidRow(
    column(4,
           selectInput("state","Select State or Union Territories", unique(data$StateAndUnionTerritories))),
    column(4,
           selectInput("condition","Select Filter", choices = c("Confirmed", "Deaths", "Cured"))
    ),
    column(12,
           plotlyOutput("dailyPlot", width = "auto", height="365")
    ),
    column(12,
           plotlyOutput("cumulativePlot", width = "auto", height = "365")
    )
  )
)