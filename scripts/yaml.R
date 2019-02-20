library(reticulate)
# toml <- import("toml")
py   <- import_builtins()
pyyaml <- import("yaml")
library(yaml)

with(py$open("data/links.yml", "r") %as% file, {
  yl <- pyyaml$load(file)
})

yl <- c(yl$tiles, list(list(
  name = project_name,
  url = project_url,
  img = file.path("logos", basename(outpath)),
  tags = project_tag)))

# TODO need to figure out how to `cat` yaml strings 
writeLines("tiles:", con = "data/links.yml")
system("echo - >> data/links.yml")
lapply(yl, 
       function(x) {
         # x <- yl[[1]]
         # yaml::as.yaml(x)
         cat(
           gsub("\n", "\n\t", paste0("\t", 
                                     yaml::as.yaml(x, 
                                                   handlers = list(character = function(x) quote(x)))
           )), 
           file = "data/links.yml", append = TRUE)
         print(yaml::as.yaml(x))
         system2("echo", "'' >> data/links.yml")
         system2("echo", "'-' >> data/links.yml")
       })

yaml::write_yaml(yl, "data/links.yml")