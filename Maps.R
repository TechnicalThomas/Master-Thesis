library(ggplot2)
library(maptools)
library(raster)

plot(ecoregions_cleaned[, "Realm"])
plot(falco_shapefile[, "gbifID"], fill = "red", add = T)
plot(falco_shapefile[, "gbifID"], col = "red")

plot(falco_shapefile,main="Falco",max.plot=1,pch=20,add=T,col="red")

-------------

dan_ple=occurrencelist(sciname = 'Danaus plexippus', 
                       coordinatestatus = TRUE, maxresults = 1000, 
                       latlongdf = TRUE, removeZeros = TRUE)

world = map_data("world")
ggplot(world, aes(long, lat)) +
  geom_polygon(aes(group = group), fill = "white", 
               color = "gray40", size = .2) +
  geom_jitter(data = dan_ple,
              aes(decimalLongitude, decimalLatitude), alpha=0.6, 
              size = 4, color = "red") +
  opts(title = "Danaus plexippus")

------------

library("rnaturalearth")
library("rnaturalearthdata")



GMgbif<-occ_search(scientificName="Alliaria petiolata", hasCoordinate=T, limit=200)
gbifLOC<-as.data.frame(GMgbif$data[,grep("decimal",names(GMgbif$data))])
names(gbifLOC)<-c("Lat","Long")

MyMap <- ggplot() + borders("world", colour="grey70", fill="black") + theme_bw()
MyMap <- MyMap + geom_point(aes(x=Long,y=Lat),data=gbifLOC,colour="green",size=2,alpha=0.1)
MyMap

-----------


library(leaflet)
# create style raster layer 
projection = '3857' # projection code
style = 'style=osm-bright' # map style
tileRaster = paste0('https://tile.gbif.org/',projection,'/omt/{z}/{x}/{y}@1x.png?',style)
# create our polygons layer 
prefix = 'https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?'
polygons = 'style=fire.point' # ploygon styles 
taxonKey = 'taxonKey=789' # taxonKey of Odonata (dragonflies and damselflies)
tilePolygons = paste0(prefix,polygons,'&',taxonKey)
# plot the styled map
leaflet() %>%
  setView(lng = 5.4265362, lat = 43.4200248, zoom = 01) %>%
  addTiles(urlTemplate=tileRaster) %>%
  addTiles(urlTemplate=tilePolygons)  

--------


# Create discrete categories of species loss

v <- c(0, sort(unique(plyr::round_any(x = ecoregions_glob_loss_sf$s_glob_loss_j, 100,f = ceiling))))

v <- unique(v)



# Insert number one to have category from 0 to >1

ins <- 1

point <- which(order(c(ins,v))==1)



v <- append(v, ins, point-1)



# Create labels

label_v <- c()

for(r in 1:length(v)){
  
  if (r == length(v)) break()
  
  label_v <- append(label_v, paste0(v[r], "-", paste0(v[r+1])))
  
}



ecoregions_glob_loss_sf$s_glob_loss_j_cut <- cut(ecoregions_glob_loss_sf$s_glob_loss_j,
                                                 
                                                 breaks = c(v),
                                                 
                                                 labels = c(label_v),
                                                 
                                                 right = FALSE)



map_glob_eco <- ggplot(ecoregions_glob_loss_sf) + geom_sf(aes(fill = factor(s_glob_loss_j_cut)), colour = NA) + theme_classic(base_size = 18) +
  
  labs(title = "Global plant species extinction per ecoregion") +
  
  theme(plot.title = element_text(size = 20, hjust = 0.08)) +
  
  guides(fill = guide_legend(title = "Species extinction", reverse = TRUE)) +
  
  scale_fill_viridis(option = "plasma",
                     
                     na.value = "lightgrey",
                     
                     discrete = TRUE,
                     
                     # na.translate = FALSE, # NA areas are not shown in the map
                     
                     breaks = c(label_v))


                     