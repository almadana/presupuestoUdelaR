library(tidyverse)

apertura_2011 = read.csv("datos/Datos Apertura Presupuestal UdelaR - 2022-2011.csv")
apertura_2011$Servicio %>% table()

apertura_2011 %>% 
  select(starts_with("Servicio")) %>% 
  distinct() %>% 
  write.csv("datos/cambio_servicio.csv")
