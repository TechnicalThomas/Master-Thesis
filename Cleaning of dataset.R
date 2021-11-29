library("CoordinateCleaner")

# Check for Presence of Coordinates
dataset <-
  Raw_import[!is.na(Raw_import$decimalLatitude) &
               !is.na(Raw_import$decimalLongitude), ]

# Exclude Records without Taxonomic Match
dataset <- dataset[dataset$taxonRank == "SPECIES",]

# Clean Dataset
dataset <- dataset[, c(34, 1, 4:10, 16, 19, 20, 22:23)]
colnames(dataset) <-
  c(
    "Taxon_Key",
    "GBIF_ID",
    "Kingdom",
    "Phylum",
    "Class",
    "Order",
    "Family",
    "Genus",
    "Species",
    "Country_Code",
    "Occurence_Status",
    "Individual_Count",
    "Latitude",
    "Longitude"
  )

# Save File
write.csv(
  dataset,
  file = paste("Derived_Data/Dataset ", Sys.Date(), ".csv", sep = ""),
  sep = ",",
  row.names = FALSE,
  col.names = TRUE
)