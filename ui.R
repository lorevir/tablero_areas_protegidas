shinyUI(
  
  navbarPage(title = div(  #### NavBar #####
                           div(
                             id = "img-id",
                             tags$a(img(src = "https://tableros.yvera.tur.ar/recursos/logo_sinta.png",
                                        width = 100),href="https://www.yvera.tur.ar/sinta/",target = '_blank'
                             )),
                           icon("tree"),"ÁREAS PROTEGIDAS", id = "title", class = "navbar1"),
             id="navbar",
             position = "fixed-top",
             windowTitle = "Visitas en Áreas Protegidas Nacionales y Provinciales", 
             collapsible = TRUE,
             header = includeCSS("styles.css"), 
             
             tabPanel("RESUMEN",
                      
                      tags$head(includeHTML("/srv/DataDNMYE/login_shiny/areas-protegidas.html")),
                      
                      useWaiter(),
                      waiter_show_on_load(html = loading_screen, color = "white"),
                      
                      div(id="container-info",
                          
                      h4(tags$p("El tablero de ÁREAS PROTEGIDAS presenta información de visitas en parques nacionales y provinciales según condición de residencia en Argentina. Para conocer detalles por Área Protegida, ingresá a la pestaña ", tags$b("TABLERO"), "; para más información sobre las fuentes de datos ingresa a la pestaña ",tags$b("METODOLOGIA."))),
                      
                      
                      fluidRow(
                        column(width = 6, h5(tags$p("Evolución mensual de las Visitas en Parques Nacionales según condición de residencia."))),
                        column(width = 6,  h5(tags$p("Áreas Protegidas Nacionales según registro de visitas. Año 2024")))    
                               ),
                      
                      fluidRow(
                        column(width = 6,  plotlyOutput("graficoPN")), 
                        column(width = 6,  leafletOutput("mapaPN"))
                      ),br(),
                      
                      fluidRow(width = 12,
                               tags$p(style="font-size: 14px; text-align: center;", tags$b('Fuentes de datos:'),(' La información fue elaborada por la Dirección de Mercados y Estadísticas, Dirección Nacional de Calidad Turística, en base a datos aportados por la Dirección Nacional de Uso Público de la Administración de Parques Nacionales (APN). El mapa fue elaborado en base a la capa de información geoespacial del Instituto Geográfico Nacional.'))
                               
                      )
                      
                      )
                      
                      
             ),
                      
             
             
             tabPanel("TABLERO",
                      
                      div(id="container-info",
                          
                          h4(tags$p("Los siguientes comandos permiten filtrar los datos")),
                          
                          h5(tags$p(paste("*Datos hasta", mes, anio, sep = " ")),br(),
                          
                          
                          fluidRow(
                            
                            column(4,pickerInput(inputId = "selectAnio", multiple = TRUE,
                                                 label = "Año:",
                                                 choices = sort(unique(areas_protegidas_total$anio)),
                                                 selected = max(sort(unique(areas_protegidas_total$anio))),
                                                 options = c(opciones_picker,
                                                             `selected-text-format` = paste0("count > ",  n_distinct(areas_protegidas_total$anio)-1)),
                                                 width = "100%")),
                            
                            
                            
                            column(4, pickerInput(inputId = "selectMes", 
                                                  label = "Mes:",
                                                  choices = sort(unique(as.character(areas_protegidas_total$Mes))),
                                                  multiple = T,
                                                  options = c(opciones_picker,
                                                              `selected-text-format` = paste0("count > ", 11)),
                                                  selected = sort(unique(areas_protegidas_total$Mes)),
                                                  width = "100%")),
                            
                            column(4, pickerInput(inputId = "selectCategoria", 
                                                  label = "Categoría Área Protegida:",
                                                  choices = unique(areas_protegidas_total$categoria),
                                                  multiple = F,
                                                  options = opciones_picker,
                                                  selected = "Nacional",
                                                  width = "100%"))
                            
                          ),
                          
                          
                          
                          fluidRow(
                            
                            column(4,pickerInput(inputId = "selectRegion", multiple = TRUE,
                                                 label = "Región:",
                                                 choices = unique(areas_protegidas_total$region),
                                                 options = opciones_picker,
                                                 selected = unique(areas_protegidas_total$region),
                                                 width = "100%")
                            ),
                            
                            
                            column(4, pickerInput(inputId = "selectProvincia", 
                                                  label = "Provincia:",
                                                  choices = sort(unique(areas_protegidas_total$provincia)),
                                                  multiple = T,
                                                  options = c(opciones_picker,
                                                              `selected-text-format` = paste0("count > ", 23)),
                                                  selected = sort(unique(areas_protegidas_total$provincia)),
                                                  width = "100%")),
                            
                            column(4, pickerInput(inputId = "selectAreaProtegida", 
                                                  label = "Área Protegida:",
                                                  choices = unique(areas_protegidas_total$area_protegida),
                                                  multiple = T,
                                                  options = opciones_picker,
                                                  selected = sort(unique(areas_protegidas_total$area_protegida)),
                                                  width = "100%"))
                          ),br(),
                          
                          
                          h5(tags$p("Selecciona el nivel de apertura con que se visualizan los datos. Escriba varios términos en el buscador para mostrar más de una variable.")),
                          
                         
                          fluidRow(
                          column(4, selectInput(inputId = "selectAgrupamiento",
                                                label = "Mostrar por", 
                                                choices = c(
                                                  "Año" = "anio",
                                                  "Mes" = "Mes",
                                                  "Región" = "region",
                                                  "Provincia" = "provincia", 
                                                  "Áreas Protegidas" = "area_protegida"),
                                                multiple = T,
                                                selected = "anio",
                                                width = "100%"
                          )),
                          
                          column(2, br(),
                                 downloadButton("notasDescarga", label = "*Descargar notas"),
                                 h6(tags$p("*Disponible desde el año 2021 al presente.")),      
                                 offset = 6)
                          
                          
                          ),
                          
                          
                          dataTableOutput(outputId = "tablaAreas"),
                          
                          fluidRow(downloadButton("downloadExcel","Descargar en excel"),
                                   downloadButton("downloadCSV","Descargar en csv")),
                          
                          br(),
                          
                          fluidRow(width = 12,
                                   tags$p(style="font-size: 14px; text-align: center;", tags$b('Fuentes de datos:'),(' La información fue elaborada por la Dirección de Mercados y Estadísticas, Dirección Nacional de Calidad Turística, en base a datos aportados por la Dirección de Mercadeo de la Administración de Parques Nacionales (APN), el Departamento Observatorio Turístico del Chubut, el Parque Provincial Ischigualasto y la Dirección de Estudios y Mercados del Ministerio de Turismo de Misiones.')),
                                   
                                   br(), 
                                   h5("   Aquí puede acceder al último ", 
                                      tags$a(href=" https://tableros.yvera.tur.ar/areas_protegidas.html", 
                                             target = '_blank', 
                                             "reporte, "),
                                      tags$a(href="https://www.yvera.tur.ar/sinta/informe/info/areas-protegidas", 
                                             target = '_blank', 
                                             "informe mensual,"), 
                                      tags$a(href="https://datos.yvera.gob.ar/dataset?groups=turismo-naturaleza", 
                                             target = '_blank',
                                             "y datos abiertos"),
                                      "de Áreas Protegidas")
                          
                      ))
                      )
                      
                  ),
             
             #Metodologia#
             
             tabPanel("METODOLOGÍA",
                      
                      div(id="container-info",
                      h5(tags$p("Los datos presentados en este tablero surgen de los registros administrativos de la Dirección 
                                         Nacional de Uso Público de la Administración de Parques Nacionales, del Departamento Observatorio
                                         Turístico del Chubut, del Parque Provincial Isghigualasto, la Dirección de Parques de la Provincia de Corrientes, Intendencia Parque Iberá y la Dirección de Mercados y Estadística del 
                                         Ministerio de Turismo de Misiones, encargados de recopilar y procesar
                                         los datos de visitas.")),
                      h5(tags$p("La información suministrada permite la clasificación de las visitas en residentes y 
                                         no residentes en 42 Parques Nacionales, en 6 Áreas Naturales Protegidas del Chubut, 1 Parque Provincial en San Juan, 1 Parque en Corrientes y 8 Parques Provinciales en Misiones, con información hasta diciembre 2024 (la actualización de las visitas tendrá una frecuencia trimestral).")),
                      h5(tags$p("En enero 2024 se incorporó el registro de visitas en el Parque Nacional Ansenuza y en julio 2024 el Parque Nacional Islas de Santa Fe.")),
                      
                          br(),
                          
                          h3(tags$p("Definiciones y conceptos")),
                          
                          tags$ul(
                            tags$li(style = "color: black", tags$b("Visita:"), " entrada a un parque nacional con cualquier finalidad principal (ocio,negocios u otro motivo personal) y que no deba ser empleado por el parque nacional (cada vez que se cruza la frontera del área protegida, se genera una visita."),br(),
                            tags$li(style = "color: black", tags$b("Unidades de observación:"), "Visitantes."),br(),
                            tags$li(style = "color: black", tags$b("Unidades de análisis:"), "Nacionales: 42 áreas protegidas que producen información estadística de un total de 55 áreas nacionales (Parques Nacionales, Monumentos Naturales y Reservas Nacionales, Reservas Naturales, Reserva Natural Estricta y Reserva Natural Educativa). Provinciales: 5 Áreas Naturales Protegidas del Chubut, 1 Parque Provincial de San Juan, 1 Provincial en Corrientes y 8 Parques Provinciales en Misiones."),br(),
                            tags$li(style = "color: black", tags$b("Forma de colecta:"), "Las áreas protegidas contabilizan las visitas en base a la venta de boletos o al registro de visitantes en los diferentes portales de ingresos (pueden presentar más de un portal de acceso."),br(),     
                            tags$li(style = "color: black", tags$b("Período de referencia del dato:"), "Mensual."),br(), 
                            tags$li(style = "color: black", tags$b("Variables de estudio:"), "Cantidad de visitas realizadas de cada área protegida y condición de residencia en Áreas Protegidas Nacionales, del Chubut y San Juan; total de visitas en el Gran Parque Iberá, Parque Provincial Moconá, Parque Provincial Salto Encantado, Reducciones Jesuíticas (incluye el acceso a San Ignacio, Santa Ana, Loreto y Santa María la Mayor) y el Espectáculo de Imagen y Sonido."),br(),
                            tags$li(style = "color: black", tags$b("Cobertura geográfica de las Áreas protegidas nacionales:"), "6 regiones turísticas compuestas por los siguientes Parques Nacionales:"),
                            tags$b("1. Región Buenos Aires:"), "Ciervo de los Pantanos.",br(),
                            tags$b("2. Región Córdoba:"), "Quebrada del Condorito, Traslasierra.",br(),
                            tags$b("3. Región Cuyo:"), "Sierra de las Quijadas, El Leoncito, San Guillermo.",br(),
                            tags$b("4. Región Litoral:"), "Iguazú, El Palmar, Predelta, Río Pilcomayo, Chaco, Mburucuyá, Iberá, El Impenetrable, Colonia Benítez, Formosa, Campo San Juan, Islas de Santa Fe.", br(),
                            tags$b("5. Región Norte:"), "Talampaya, Los Cardones, Calilegua, Aconquija, El Rey, Baritú,Copo, Laguna de los Pozuelos, El Nogalar de los Toldos, Pizarro.", br(),
                            tags$b("6. Región Patagonia:"), "Los Glaciares, Nahuel Huapi, Tierra del Fuego, Los Alerces,Lago Puelo, Lanín, Laguna Blanca, Lihué Calel, Monte León, Perito Moreno, Bosques Petrificados, Los Arrayanes, Isla Pingüino, Patagonia.",br(),br(),
                            tags$li(style = "color: black", tags$b("Cobertura geográfica de las Áreas protegidas provinciales:"), "3 regiones turísticas compuestas por las siguientes áreas protegidas:"),
                            tags$b("3. Región Cuyo:"), "Parque Provincial Ischigualasto.",br(),
                            tags$b("4. Región Litoral:"), "Gran Parque Iberá (Prov. Corrientes).",br(),
                            tags$b("4. Región Litoral:"), "Parque Provincial Moconá, Parque Provincial Salto Emcantado, Reducciones Jesuíticas (San Ignacio, Santa Ana, Loreto y Santa María la Mayor) y el Espectáculo de Imagen y Sonido (Prov. Misiones).",br(),
                            tags$b("6. Región Patagonia:"), "Penísula Valdés, Punta Marqués, Bosque Petrificado Sarmiento, Punta Loma, Punta Tombo.",br(),br(),
                            tags$li(style = "color: black", tags$b("Cobertura temporal - Áreas Protegidas Nacionales:"),"a partir del año 2008."),br(),
                            tags$li(style = "color: black", tags$b("Cobertura temporal - Áreas Protegidas Provinciales:"),"Chubut: a partir del año 2000 (excepto Punta Marques, a partir del 2012). San Juan: a partir del año 2000. Corrientes: a partir del año 2015. Misiones: a partir del año 2015 (excepto el Parque Provincial Moconá, a partir del 2016)"),br(),
                            tags$li(style = "color: black", tags$b("*Notas:"),"A partir del 2021, se pueden descargar las notas que se presentan en los informes mensuales de visitas en áreas protegidas en un archivo .xlsx en la solapa", tags$b("Tablero"), ". Refieren a una serie de eventos o situaciones particulares que impactaron en el movimiento de visitas al área protegida o incidieron sobre el registro de las mismas.")
                            ),
                          
                      br(),
                      h3(tags$p("Fuentes de información:")),
                          
                          tags$ul(
                            tags$li(style = "color: black", tags$b("SIAPN:"), "Sistema de Administración de Parques Nacionales"), 
                            tags$li(style = "color: black", tags$b("Chubut:"), "Departamento Observatorio Turístico del Chubut"), 
                            tags$li(style = "color: black", tags$b("San Juan:"), "Parque Provincial Ischigualasto"),
                            tags$li(style = "color: black", tags$b("Corrientes:"), "Departamento Técnico del Comité Iberá"),
                            tags$li(style = "color: black", tags$b("Misiones:"), "Dirección de Mercados y Estadística del Ministerio de Turismo de Misiones")),
                      br()
                          
                      
                      )
               ) ,  footer = includeHTML("/srv/shiny-server/recursos/shiny_footer.html") #descomentariar al pushear
  )

)
 
             
  


