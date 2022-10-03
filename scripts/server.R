#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
print(getwd())
load("../datos/apertura_2011.RData")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({
        colElegida = input$selectorColumna
        print(colElegida)
        p = apertura_2011 %>% 
          group_by(año) %>% 
          #elegir la columna que matchea exactamente el nombre del selector
          summarize(across(matches(paste0("^",colElegida,"$")),sum,.names="columnaElegida")) %>% 
          ggplot(aes(x=año,y=columnaElegida)) + 
          geom_line()+
          theme(text=element_text(size=16))+
          labs(x="Año",y=colElegida,
               title=paste0("Evolución de la apertura en el rubro ",colElegida),
               subtitle="Pesos constantes corregidos por IPC")

        # draw the histogram with the specified number of bins
        show(p)

    })

})
