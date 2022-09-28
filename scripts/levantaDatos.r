library(tidyverse)

apertura_2011 = read.csv("datos/Datos Apertura Presupuestal UdelaR - 2022-2011.csv")
cambio_nombres_servicio = read.csv("datos/cambio de nombres de servicio.csv")

cambiador_nombres = 
  cambio_nombres_servicio  %>% 
    pull(Servicio)

names(cambiador_nombres) = cambio_nombres_servicio$Servicio..codificación.original.

apertura_2011$Servicio= cambiador_nombres[apertura_2011$Servicio]
apertura_2011$programa = as.character(apertura_2011$programa)

apertura_2011 = apertura_2011 %>% mutate(across(where(is.numeric),replace_na,0))

save(apertura_2011,file="datos/apertura_2011.RData")