library(tidyverse)

#---leer datos crudos-----
#datos de apertura
apertura_2011 = read.csv("datos/Datos Apertura Presupuestal UdelaR - 2022-2011.csv")
#diccionario de cambio de nombres de servicio
cambio_nombres_servicio = read.csv("datos/cambio de nombres de servicio.csv")
#datos de ipc
ipc = read.csv("datos/ipc.csv",sep=";",dec=",")

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
ipc = ipc %>% 
  separate(mes_año,into = c("mes","año"),sep = "/") %>% 
  filter(mes %in% "01") %>% 
  mutate(año = as.numeric(año)+2000)

ultimo_año_ipc = as.numeric(ipc %>% slice_max(año) %>% pull(año))
ultimo_año_apertura = apertura_2011 %>% slice_max(año,with_ties = F) %>% pull(año)

if (ultimo_año_apertura > ultimo_año_ipc) {
  warning(paste("Es necesario actualizar el IPC!! \n Último año IPC: ",ultimo_año_ipc," \n Último año apertura: ",ultimo_año_apertura))
}

ajusta_IPC <- function(valor,año_origen){
  if (año_origen == ultimo_año_ipc) {
    return(valor)
  }
  else {
    ipc_aplica = ipc %>% filter(año>año_origen,año<=ultimo_año_apertura) %>% pull(acum12meses)
    ajustado = valor*prod(1+ipc_aplica/100)
    return(ajustado)
  }
}

#----------- guardar archivos de datos procesados ----
save(apertura_2011,file="datos/apertura_2011.RData")