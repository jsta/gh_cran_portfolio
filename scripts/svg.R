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
library(ggplot2)

get_cex <- function(x, base = 10, scale = 4){
  if(x > base){
    base + ((1 / (base / (base - x))) * scale)
  }else{
    base
  }
}

make_svg_base <- function(outpath, project_name, overwrite = FALSE){
  if(!file.exists(outpath) & !overwrite){
    svglite(outpath, bg = "transparent")
    par_original <- par()
    par(bg = NA)
    plot.new()
    text(0.5, 0.5, project_name, cex = get_cex(nchar(project_name), 9.2, 3.8))
    dev.off()
    par(par_original)
    
    image_read_svg(outpath) %>%
      image_trim() %>%
      image_write(outpath, format = "svg")
  }
}

make_svg_base(outpath, project_name)

make_svg_ggplot <- function(outpath, project_name){
  # if(!file.exists(outpath)){
    svglite::svglite(outpath)
    ggplot(data = data.frame(x = 0, y = 0, text = project_name)) + 
      geom_text(aes(x = x, y = y, label = text), size = 12) +
      cowplot::theme_nothing()
    dev.off()
    
    image_read_svg(outpath) %>%
       image_trim() %>%
    #   # image_transparent(color = "white") %>%
       image_write(outpath, format = "svg")
  # }
}

# sticker(outpath,
#         package = project_name, h_fill = "#223974",
#         p_size = 7,
#         s_x = 1, s_width = 0.5, filename = outpath)
