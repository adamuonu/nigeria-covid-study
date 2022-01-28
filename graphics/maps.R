library(dplyr)
library(RColorBrewer)
library(geojsonio)
library(sf)
library(ggplot2)
library(ggthemes)
library(ggmap)
library(broom)

# nga <- readOGR(dsn = 'data/gis/nga/NGA_adm1.shp', verbose = FALSE)
dta <- readRDS(file = 'data/cleaned/covid_data.rds')

#nga$NAME_1[nga$NAME_1 == "Federal Capital Territory"] <- "FCT"

data_from <- levels(dta$state)

#   List of states ----

states <- tibble(
    State_ID = c(1:35, 37, 38),
    State = c(
        'Abia',
        'Adamawa',
        'Akwa Ibom',
        'Anambra',
        'Bauchi',
        'Bayelsa',
        'Benue',
        'Borno',
        'Cross River',
        'Delta',
        'Ebonyi',
        'Edo',
        'Ekiti',
        'Enugu',
        'FCT',
        'Gombe',
        'Imo',
        'Jigawa',
        'Kaduna',
        'Kano',
        'Katsina',
        'Kebbi',
        'Kogi',
        'Kwara',
        'Lagos',
        'Nasarawa',
        'Niger',
        'Ogun',
        'Ondo',
        'Osun',
        'Oyo',
        'Plateau',
        'Rivers',
        'Sokoto',
        'Taraba',
        'Yobe',
        'Zamfara'
    )
)

states <- states %>% mutate(
    data_from = case_when((State %in% data_from) ~ 'Yes', TRUE ~ 'No')
) %>% mutate(
    data_from = factor(data_from)
)

mapcolors <- c("#999999", "#EF8A62")

nga.states <- merge(
    nga,
    states,
    by.x = 'ID_1',
    by.y = 'State_ID',
    all.x = FALSE
)

# map.palette <- colorFactor(palette = mapcolors, levels = levels(nga.states$data_from))


ngr <-geojson_read('data/gis/nga.geojson', what = 'sp')
ngr_sf <-tidy(ngr, region = 'admin1RefN')
ngr_sf$id[ngr_sf$id == 'Federal Capital Territory'] <- 'FCT'

ngr_map <- ngr_sf %>% left_join(. , states, by=c('id'='State'))
state_names <- aggregate(cbind(long, lat) ~ id, data = ngr_map, FUN = function(x) mean(range(x)))

ggplot() +
    geom_polygon(data = ngr_map, aes(fill = data_from, x = long, y = lat, group = group),
                 color ='black', alpha = 0.33) +
    geom_text(data = state_names, aes(long, lat, label = id), size = 2, fontface = 'bold',
              colour = 'grey') +
    theme_void() +
    scale_fill_brewer(palette = 'BrBG', direction = -1, name = 'Data') +
    coord_map()



# datamap <- leaflet(data = nga.states) %>%
#     addProviderTiles('CartoDB.Voyager') %>%
#     #addProviderTiles('CartoDB.Positron') %>%
#     #addProviderTiles('Esri.WorldStreetMap') %>%
#     #addBootstrapDependency() %>%
#     setView( lat=8.68, lng=7.58 , zoom=6.2) %>%
#     #fitBounds(lng1 = 2.32, lat1 = 3.3, lng2 = 12.35, lat2 = 14) %>%
#     addPolygons(
#         fillColor = ~map.palette(`data_from`),
#         stroke=TRUE,
#         dashArray = "2",
#         fillOpacity = 0.55,
#         smoothFactor = 0.5,
#         color='#808080',
#         weight=1.5,
#         highlight = highlightOptions(
#             weight = 2,
#             color = "#555",
#             fillOpacity = 0.6,
#             bringToFront = TRUE),
#         label = ~ State,
#         labelOptions = labelOptions(
#             noHide = TRUE,textOnly = TRUE,
#             style = list("font-weight" = "bold"),
#             textsize = "11px",
#             direction = "center"
#         )
#     ) %>%
#     addLegend( pal=map.palette, values= ~ `data_from`, opacity=0.4,
#                title = "Data available",
#                position = "bottomright" )


saveRDS(object = datamap, file = 'graphics/nigeria_map.rds')

datamap
