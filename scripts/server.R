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
shinyServer(function(input, output,session) {
  
  output$filtroServicio = renderUI({
    selectInput(inputId = "servicioSelector",
                label="Seleccionar servicio",
                choices=c("Todos",unique(apertura_2011$Servicio))
    )
  })
  
  output$distPlot <- renderPlot({
    colElegida = input$selectorColumna
      p = apertura_2011 %>%
      filter(programa %in% getFilter_programa(),Servicio %in% getFilter_servicio()) %>% 
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
  
  observeEvent(input$checkPrograma, {
    if ("Todos" %in% input$checkPrograma) {
      updateCheckboxGroupInput(session,"checkPrograma",selected="Todos")
      selectedRows_programa=c("347","348","349","350","351","352","353")
    }
    else {
      selectedRows_programa=input$checkPrograma
    }
  })
  
  getFilter_programa = function()   {
    if ("Todos" %in% input$checkPrograma) {
      return(c("347","348","349","350","351","352","353"))
    }
    else {
      return(input$checkPrograma)
    }
  }
  
  getFilter_servicio = function()   {
    if ("Todos" %in% input$servicioSelector) {
      return(unique(apertura_2011$Servicio))
    }
    else {
      return(input$servicioSelector)
    }
  }
  
})


