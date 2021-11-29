library(sf)

# Import Ecoregions
ecoregions <- sf::st_read("Raw_data/ecoregions/wwf_terr_ecos.shp")
st_crs(ecoregions)

# Remove Unwanted Biomes and Columns
ecoregions_cleaned <-
  ecoregions[ecoregions$BIOME != 99 &
               ecoregions$BIOME != 98, c(5, 6, 8, 18, 4, 7, 17, 15, 16)]
colnames(ecoregions_cleaned) <-
  c(
    "Realm",
    "Biome",
    "Ecoregion_ID",
    "Ecoregion_Code",
    "Ecoregion_Name",
    "Ecoregion_Number",
    "Area(km^2)",
    "Shape_Length",
    "Shape_Area",
    "geometry"
  )

# Save File
write.csv(
  ecoregions_cleaned,
  file = "Derived_Data/Ecoregions.csv",
  sep = ",",
  row.names = FALSE,
  col.names = TRUE
)

# Dataset Count
ecoregions_number <- length(unique(ecoregions_cleaned$Ecoregion_ID))
biomes_number <- length(unique(ecoregions_cleaned$Biome))
realms_number <- length(unique(ecoregions_cleaned$Realm))

# Surface Areas and Frequencies for Ecoregions and Biomes
ecoregions_area <- aggregate(
  ecoregions_cleaned$`Area(km^2)`,
  list(
    ecoregions_cleaned$Biome,
    ecoregions_cleaned$Ecoregion_ID,
    ecoregions_cleaned$Ecoregion_Name
  ),
  sum
)
ecoregions_table <-
  data.frame(table(ecoregions_cleaned$Ecoregion_Name))
ecoregions_table <- cbind(ecoregions_area, ecoregions_table$Freq)
colnames(ecoregions_table) <-
  c("Biome",
    "Ecoregion_ID",
    "Ecoregion_Name",
    "Total_Area(km^2)",
    "Frequency")
rm(ecoregions_area)

biomes_area <- aggregate(ecoregions_cleaned$`Area(km^2)`,
                         list(ecoregions_cleaned$Biome),
                         sum)
biomes_table <- data.frame(table(ecoregions_cleaned$Biome))
biomes_table <- cbind(biomes_area, biomes_table$Freq)
colnames(biomes_table) <- c("Biome", "Total_Area(km^2)", "Frequency")
rm(biomes_area)