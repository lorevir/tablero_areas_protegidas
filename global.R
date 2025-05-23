library(shiny)
library(tidyverse)
library(DT) #para hacer tablas interactivas
library(sf) #para trabajar con datos geograficos
library(herramientas)
library(lubridate) #para trabajar con fechas
library(shinyWidgets) #trae distintos elementos de ui como el picker
library(comunicacion)
library(leaflet)
library(geoAr)
library(plotly)
library(waiter)

# setup idioma
Sys.setlocale("LC_TIME", "es_AR.UTF-8")

# language en DT::

options(DT.options = list(language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json')))


#se levanta la capa geografica y se le agregan los datos de visitantes del 2022 para mostrar en cada parque

mapa <- read_file_srv("/srv/DataDNMYE/capas_sig/areas_protegidas_nacionales.gpkg")

areas_protegidas_total <- read_file_srv("areas_protegidas/base_shiny/areas_consolidado.rds") %>% 
  mutate(Mes = str_to_sentence(Mes),
    Mes = factor(Mes, levels = c("Enero","Febrero","Marzo","Abril",
                                      "Mayo","Junio","Julio","Agosto",
                                      "Septiembre","Octubre","Noviembre", "Diciembre"), ordered = T))

datos_mapa <- areas_protegidas_total %>% 
  filter(anio == 2024) %>% 
  group_by(area_protegida) %>% 
  summarise(total = sum(total, na.rm = T)) %>% 
  ungroup()

mapa <- left_join(mapa, datos_mapa, by = c("parque_nacional" = "area_protegida")) %>% 
  mutate(color = ifelse(registra == "si", dnmye_colores("purpura"),dnmye_colores("pera")),
         total = ifelse(is.na(total), "Sin registro", as.character(format(total, big.mark = "."))))


# notas <- read_file_srv("/srv/DataDNMYE/areas_protegidas/areas_protegidas_nacionales/notas.xlsx") %>% 
#   mutate(parque = str_to_title(parque),
#          indice_tiempo = ym(indice_tiempo)) %>% 
#   drop_na(notas) %>% 
#   select(1:4)

# areas_protegidas_total <- areas_protegidas_total %>% 
#   left_join(notas, by = c("area_protegida"="parque", "indice_tiempo"))
  
#Opciones de configuración del picker, guardados en un objeto para no pasarlo a cada uno de ellos

opciones_picker <- list(`actions-box` = TRUE,
                        `deselect-all-text` = "Deseleccionar todo",
                        `select-all-text` = "Seleccionar todo",
                        `none-selected-text` = "Sin selección",
                        `live-search`=TRUE,
                        `count-selected-text` = "Todos")

#texto automatizado
mes <- areas_protegidas_total %>% 
  filter(indice_tiempo == max(areas_protegidas_total$indice_tiempo)) %>% 
  pull(Mes) %>% unique()
anio <- areas_protegidas_total %>% 
  filter(anio == max(areas_protegidas_total$anio)) %>% 
  pull(anio) %>% unique()


# Cargo el mensaje de espera. 
loading_screen <- tagList(
  h3("Cargando...", style = "color:gray;"),
  img(src = "https://tableros.yvera.tur.ar/recursos/logo_color.png",
      height = "250px")
)
