library(tidyverse)

#---leer datos crudos-----
#datos de apertura
apertura_2011 = read.csv("datos/Datos Apertura Presupuestal UdelaR - 2022-2011.csv")
#diccionario de cambio de nombres de servicio
cambio_nombres_servicio = read.csv("datos/cambio de nombres de servicio.csv")

#---procesar cambio de nombres------
#obtener lista de nombres de servicio nuevos
cambiador_nombres = 
  cambio_nombres_servicio  %>% 
    pull(Servicio)

#nombrar esa lista con los nombres de servicio originales
names(cambiador_nombres) = cambio_nombres_servicio$Servicio..codificación.original.

#realizar el cambio
apertura_2011$Servicio= cambiador_nombres[apertura_2011$Servicio]


#---- ajustes de formato de variables ----------
#convertir número de programa a caracter
apertura_2011$programa = as.character(apertura_2011$programa)

#convertir datos faltantes en 0s en variables numéricas
apertura_2011 = apertura_2011 %>% mutate(across(where(is.numeric),replace_na,0))

#----- convertir valores a pesos constantes ----

# Valores de conversión


#----------- guardar archivos de datos procesados ----
save(apertura_2011,file="datos/apertura_2011.RData")