library(dplyr)

entries <- list(
  data.frame(name = "smwrQW", tile_tooltip = "Water quality USGS water science R functions.", 
       url = "https://github.com/USGS-R/smwrQW", tags = "rstats", 
       img = "https://owi.usgs.gov/R/img/usgs-r-logo.png", bg_color = "#198CE7", stringsAsFactors = FALSE), 
  data.frame(name = "r-raster-vector-geospatial", tile_tooltip = "Introduction to Geospatial Raster and Vector Data with R.", 
             url = "https://github.com/datacarpentry/r-raster-vector-geospatial", tags = "rstats", 
             img = NA, bg_color = "#198CE7", stringsAsFactors = FALSE)
)

res <- bind_rows(entries)

write.csv(res, "static/project_manual.csv", row.names = FALSE)