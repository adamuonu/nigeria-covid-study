#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#  Generate chloropleth map
#  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

rm(list = ls())

library(dplyr)
library(geojsonio)
library(ggplot2)
library(ggthemes)
library(ggsci)
library(RColorBrewer)
library(broom)
library(maptiles)

# - Load data  ----------------------------------------------------------------

dta <- readRDS(file = 'data/cleaned/covid_data.rds')
ngr <-geojson_read('data/gis/nga.geojson', what = 'sp')
ngr_sf <-tidy(ngr, region = 'admin1RefN')

data_from <- levels(dta$state)
data_from[5] <- 'FCT'

# nga <- st_read(dsn = 'data/gis/nga/NGA_adm1.shp', quiet = TRUE)
# carto <- get_tiles(x = nga,
#                    provider = 'CartoDB.VoyagerNoLabels',
#                    #provider = 'Stamen.TonerLite',
#                    cachedir = 'data/gis/tiles/',
#                    crop = TRUE,
#                    zoom = 5,
#                    forceDownload = TRUE)
#
# plot_tiles(carto)
# plot(st_geometry(nga), col = NA, add = TRUE)

# ggmap(nga_map)

mapcolors <- c("#EF8A62", "#999999")

# - List of states ------------------------------------------------------------

states <- tibble(
    State_ID = c(1:35, 37, 38),
    State = c(
        'Abia', 'Adamawa', 'Akwa Ibom', 'Anambra', 'Bauchi', 'Bayelsa',
        'Benue', 'Borno', 'Cross River', 'Delta', 'Ebonyi', 'Edo', 'Ekiti',
        'Enugu', 'FCT', 'Gombe', 'Imo', 'Jigawa', 'Kaduna', 'Kano',
        'Katsina', 'Kebbi', 'Kogi', 'Kwara', 'Lagos', 'Nasarawa', 'Niger',
        'Ogun', 'Ondo', 'Osun', 'Oyo', 'Plateau', 'Rivers', 'Sokoto',
        'Taraba', 'Yobe','Zamfara'
    )
)

states <- states %>% mutate(
    data_from = case_when((State %in% data_from) ~ 'Yes', TRUE ~ 'No')
) %>% mutate(
    data_from = factor(data_from, levels = c('Yes', 'No'))
)


ngr_sf$id[ngr_sf$id == 'Federal Capital Territory'] <- 'FCT'

ngr_map <- ngr_sf %>% left_join(. , states, by=c('id'='State'))
state_names <- aggregate(cbind(long, lat) ~ id, data = ngr_map, FUN = function(x) mean(range(x)))

#mapcolors <- c("#0050B3", "#999999")

states_map <-
    ggplot() +
    geom_polygon(data = ngr_map, aes(fill = data_from, x = long, y = lat, group = group),
                 color ='gray95', size =0.3, alpha = 0.7) +
    geom_text(data = state_names, aes(long, lat, label = id), size = 2, colour = 'grey20',
              fontface = 'bold') +
    #  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #  Format and position legend
    #  Remove axis ticks and labels
    #  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #theme_pubr() +
    theme(legend.title    = element_blank(),
          #legend.direction = 'horizontal',
          legend.text     = element_text(size = 9),
          legend.position = c(0.85, 0.15),
          axis.line       = element_blank(),
          axis.text       = element_blank(),
          axis.ticks      = element_blank(),
          axis.title      = element_blank(),
          panel.grid      = element_blank(),
          panel.border    = element_blank()) +
    #theme_void() +
    #scale_fill_brewer(palette = 'Accent', direction = -1, name = 'Data') +
#    scale_fill_discrete(type = mapcolors, name = 'Data') +
    scale_fill_discrete(type = mapcolors, labels = c('data available', 'data not available')) +
    coord_quickmap()

states_map

ggsave(
    filename = 'map.png',
    plot = states_map,
    device = 'png',
    path = 'graphics/',
    width = 7,
    height = 6,
    units = 'in',
    dpi = 320
)

saveRDS(object = states_map, file = 'graphics/map.rds')
