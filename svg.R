# Rscript svg.R my_project https://github.com video 

cmdargs <- commandArgs(trailingOnly = TRUE)

project_name <- cmdargs[1]
project_url  <- cmdargs[2]
project_tag  <- cmdargs[3]
# project_icon <- cmdargs[3]

library(svglite)
library(magrittr)
library(magick)
library(rsvg)

library(reticulate)
toml <- import("toml")
py   <- import_builtins()
pyyaml <- import("yaml")

library(yaml)

# project_name <- "my_project"
outpath <- file.path("static/logos", paste0(project_name, ".svg"))
svglite(outpath)
plot.new()
text(0.5, 0.5, project_name, cex = 10)
dev.off()

image_read_svg(outpath) %>%
  image_trim() %>%
  image_transparent(color = "white") %>%
  image_write(outpath, format = "svg")

# add to toml manually
# config      <- toml$load("config.toml")
# config_list <- config$params$nav
# config_list <- c(config_list, list(list(name = project_name, 
#                                         tag = project_tag, 
#                                         icon = project_icon)))
# config$params$nav <- config_list
# 
# with(py$open("config.toml", "w") %as% file, {
#   toml$dump(config, file)
# })

yl <- yaml::read_yaml("data/links.yml")
purrr::map_chr(yl$tiles, "name")

with(py$open("data/links.yml", "r") %as% file, {
 test <- pyyaml$load(file)
})

test <- pyyaml$load("data/links.yml")

yl <- c(yl$tiles, list(list(
  name = project_name,
  url = project_url,
  img = file.path("logos", basename(outpath)),
  tags = project_tag)))
yaml::write_yaml(yl, "data/links.yml")

# x <- yaml.load("speeds: [10mbps, 100mbps]")
# write_yaml(x, "test.yml")
# 
# yaml.load("- hey\n- hi\n- hello")
# yaml.load("foo: 123\nbar: 456")
# yaml.load("- foo\n- bar\n- 3.14")
# yaml.load("foo: bar\n123: 456", as.named.list = TRUE)
