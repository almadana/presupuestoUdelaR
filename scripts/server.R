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

        p = apertura_2011 %>% 
          group_by(año) %>% 
          summarize(total = sum(TOTAL)) %>% 
          ggplot(aes(x=año,y=total)) + 
          geom_line()

        # draw the histogram with the specified number of bins
        show(p)

    })

})
