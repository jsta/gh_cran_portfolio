library(yaml)
library(dplyr)

dt_raw      <- read.csv("static/projects.csv", stringsAsFactors = FALSE)
proj_ignore <- read.csv("static/proj_ignore.csv", stringsAsFactors = FALSE)
yl          <- yaml::read_yaml("data/links.yml")

# name
# url 
# img
# bg_color
# tile_tooltip
# tags

dt <- dt_raw %>% 
  filter(!is.na(tags)) %>%
  filter(!(tags %in% proj_ignore$tags)) %>%
  rename(name = Package, 
  url = URL, 
  tile_tooltip = Title) %>%
  filter(!(name %in% proj_ignore$name)) %>%
  mutate(img = paste0("logos/", name, ".svg")) %>%
  select(name, url, img, bg_color, tile_tooltip, tags) %>%
  group_by(tags) %>%
  sample_n(1)

dt <- dt[1:2,]
dt_names <- names(dt)
n_proj <- length(unique(dt$name))

test <- as.data.frame(t(dt), stringsAsFactors = FALSE) %>% 
  purrr::flatten() %>%
  setNames(rep(dt_names, n_proj))

identical(test, yl[[1]][[2]])

yaml::write_yaml(dt, "data/links.yml")
