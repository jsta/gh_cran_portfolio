suppressMessages(library(dplyr))

entries <- list(
  data.frame(name = "smwrQW", tile_tooltip = "Water quality USGS water science R functions.", 
             url = "https://github.com/USGS-R/smwrQW", tags = "rstats", 
             remote_img = "https://owi.usgs.gov/R/img/usgs-r-logo.png", 
             bg_color = "#198CE7", 
             img = "logos/smwrQW.svg", stringsAsFactors = FALSE), 
  data.frame(name = "r-raster-vector-geospatial", 
    tile_tooltip = "Introduction to Geospatial Raster and Vector Data with R.", 
             url = "https://github.com/datacarpentry/r-raster-vector-geospatial", 
             tags = "rstats", remote_img = NA, bg_color = "#198CE7", 
             img = "logos/r-raster-vector-geospatial.svg", 
             stringsAsFactors = FALSE), 
  data.frame(name = "data-packages", 
    tile_tooltip = "The State Of Data On CRAN: Discovering Good Data Packages", 
             url = "https://github.com/ropenscilabs/data-packages", 
             tags = "rstats", remote_img = NA, bg_color = "#e34c26", 
             img = "logos/data-packages.svg", stringsAsFactors = FALSE)
)

res <- bind_rows(entries)

write.csv(res, "static/project_manual.csv", row.names = FALSE)