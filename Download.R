library(rgbif)

# Taxon Keys
taxonkeys <-
  c(
    54,
    52,
    42,
    43,
    50,
    105,
    110,
    53,
    5967481,
    108,
    55,
    63,
    91,
    74,
    19,
    75,
    14,
    67,
    5963150,
    51,
    5959089,
    64,
    7190138,
    62,
    5963076,
    22,
    5967457,
    77,
    7663989,
    5967456,
    5967454,
    76
  )

# Create GBIF Download Link
download <- occ_download(
  #pred('occurrenceStatus', "present"),
  #pred_in('taxonKey', taxonkeys),
  pred_in('taxonKey', taxonkeys),
  pred('hasCoordinate', TRUE),
  pred('hasGeospatialIssue', FALSE),
  pred_in(
    'basisOfRecord',
    c(
      "LIVING_SPECIMEN",
      "PRESERVED_SPECIMEN",
      "MATERIAL_SAMPLE",
      "HUMAN_OBSERVATION",
      "MACHINE_OBSERVATION",
      "OBSERVATION"
    )
  ),
  pred_lte('coordinateUncertaintyInMeters', 100000),
  pred_gt('year', 1945),
  user = "technicalthomas",
  email = "technicalthomas90@gmail.com",
  pwd = "RU2021!",
  format = "SIMPLE_CSV"
)

# Check Metadata
status <- occ_download_meta(download)

# Check Download Status
while (status$status != "SUCCEEDED") {
  Sys.sleep(60)
  print(paste("Download not yet ready at", Sys.time()))
  status <- occ_download_meta(download)
}
print(paste("download is ready at", Sys.time()))

# List of Active Downloads
#list <- occ_download_list(user = "technicalthomas", pwd = "RU2021!")

# Cancel Downloads
#occ_download_cancel_staged(user = "technicalthomas", pwd = "RU2021!")

# Save Download
data <- occ_download_get(status$key, path = "./Raw_data/", overwrite = TRUE)
unzip(data, exdir="./Raw_data")

# Citation
citation <- gbif_citation(status)
citation <- citation$download
records <- status$totalRecords

#Import Data
Raw_import <- occ_download_import(data)
unlink(data)
#read.delim(paste("Raw_data/", status$key, ".csv", sep = ""), header = TRUE)

# Clear
rm(list = c("download", "data"))