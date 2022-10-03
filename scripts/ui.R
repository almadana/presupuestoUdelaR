#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Visualizador de datos de presupuesto - UdelaR"),

    # Sidebar with a slider input for number of bins
    fluidRow(
        column(4,
          selectInput("selectorColumna","Rubro",
                      c("Sueldos docentes"="SUELDOS.DOCENTES","Sueldos no docentes"="SUELDOS.NO.DOCENTES","Sueldos otros"="OTROS","Sueldos total"="TOTAL.SUELDOS",
                        "Gastos"="GASTOS","Suministros"="SUMINISTROS","Inversiones"="INVERSIONES","Total"="TOTAL"
                        ),
                      selected = "TOTAL")
        ),

        # Show a plot of the generated distribution
        fluidRow(
          column(8,
            plotOutput("distPlot")
          )
        )
    )
))
