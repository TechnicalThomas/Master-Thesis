library(sf)

# Convert to Sf
dataset_sf <-
  st_as_sf(
    dataset,
    coords = c("Longitude", "Latitude"),
    na.fail = FALSE ,
    dim = "XYZ"
  )

# Set Coordinates to the Same System
dataset_sf <-
  st_set_crs(dataset_sf, st_crs(ecoregions_cleaned))
st_crs(dataset_sf)

# Intersect Shapefiles
sf_use_s2(FALSE)
dataset_intersect <-
  st_intersection(dataset_sf, ecoregions_cleaned)

# Calculate Species Count per Ecoregion
ecoregions_list <- unique(ecoregions_cleaned$Ecoregion_ID)
species_total <-
  data.frame(
    Ecoregion_ID = ecoregions_list,
    Ecoregion_Name = unique(ecoregions_cleaned$Ecoregion_Name),
    Species_Count = 0
  )

for (i in 1:ecoregions_number) {
  dataset2 <-
    dataset_intersect[ecoregions_cleaned[which(ecoregions_cleaned$Ecoregion_ID == ecoregions_list[i]),],]
  
  if (nrow(dataset2) > 0) {
    species_total$Species_Count[i] <-
      length(unique(dataset2$Taxon_Key))
    
  }
  
}

species_total <- subset(species_total, Species_Count > 0)
rm(dataset2)

# See in Which Ecoregion a Specific Species Occurs
taxonkey <- 2436351
ss <- subset(dataset_intersect, Taxon_Key == taxonkey)

species_specific <-
  data.frame(
    Ecoregion_ID = ecoregions_list,
    Ecoregion_Name = unique(ecoregions_cleaned$Ecoregion_Name),
    Occurrences = 0
  )

for (i in 1:ecoregions_number) {
  ss2 <-
    ss[ecoregions_cleaned[which(ecoregions_cleaned$Ecoregion_ID == ecoregions_list[i]),],]
  
  if (nrow(ss2) > 0) {
    species_specific$Occurrences[i] <-
      nrow(ss2)
    
  }
  
}

species_specific <- subset(species_specific, Occurrences > 0)
rm(list = c("ss", "ss2"))