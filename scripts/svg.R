# Rscript svg.R my_project https://github.com video 

cmdargs <- commandArgs(trailingOnly = TRUE)

project_name <- cmdargs[1] 
project_url  <- cmdargs[2]  
# project_tag  <- cmdargs[3]  
# project_name <- "my_project"; project_url <- "https://github.com/"; project_tag <- "video"
outpath <- file.path("../static/logos", paste0(project_name, ".svg"))

library(svglite)
library(magrittr)
library(magick)
library(rsvg)
library(hexSticker)

svglite(outpath)
plot.new()
text(0.5, 0.5, project_name, cex = 10)
dev.off()

image_read_svg(outpath) %>%
  image_trim() %>%
  image_transparent(color = "white") %>%
  image_write(outpath, format = "svg")

sticker(outpath, 
        package = project_name, h_fill = "#223974", 
        p_size = 7, 
        s_x = 1, s_width = 0.5, filename = outpath)
