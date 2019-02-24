# Rscript svg.R static/logos/my_project


cmdargs      <- commandArgs(trailingOnly = TRUE)
# cmdargs <- NA; cmdargs <- "static/logos/my_project"
outpath      <- paste0(cmdargs[1], ".svg")

project_name <- strsplit(cmdargs[1], "/")[[1]]
project_name <- project_name[length(project_name)]

library(svglite)
library(magrittr)
suppressMessages(library(magick))
library(rsvg)
library(hexSticker)

get_cex <- function(x, base = 10, scale = 4){
  if(x > base){
    base + ((1 / (base / (base - x))) * scale)
  }else{
    base
  }
}

if(!file.exists(outpath)){
  
  # create svg of project_name
  svglite(outpath)
  plot.new()
  text(0.5, 0.5, project_name, cex = get_cex(nchar(project_name), 9.2, 3.8))
  dev.off()
  
  image_read_svg(outpath) %>%
    image_trim() %>%
    image_transparent(color = "white") %>%
    image_write(outpath, format = "svg")
}

# sticker(outpath,
#         package = project_name, h_fill = "#223974",
#         p_size = 7,
#         s_x = 1, s_width = 0.5, filename = outpath)
