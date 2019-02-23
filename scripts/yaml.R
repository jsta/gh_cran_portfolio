library(yaml)
suppressMessages(library(dplyr))

dt_raw      <- read.csv("static/projects.csv", stringsAsFactors = FALSE)
proj_ignore <- read.csv("static/proj_ignore.csv", stringsAsFactors = FALSE)
yl          <- yaml::read_yaml("data/links.yml")

dt <- dt_raw %>% 
  filter(!is.na(tags)) %>%
  filter(!(tags %in% proj_ignore$tags)) %>%
  rename(name = Package, 
  url = URL, 
  tile_tooltip = Title) %>%
  filter(!(name %in% proj_ignore$name)) %>%
  mutate(img = paste0("logos/", name, ".svg")) %>%
  select(name, url, img, bg_color, tile_tooltip, tags) %>%
  # mutate_all(shQuote) %>%
  group_by(tags) %>%
  sample_n(1) %>%
  ungroup() %>%
  mutate(tags = case_when(tags == "R" ~ "rstats", 
                          tags == "Python" ~ "python",
         TRUE ~ tags))

# dt$tags <- purrr::flatten(apply(dt, 1, function(x) list(x["tags"][[1]])))
# dt[1,"tags"][[1]] <- purrr::flatten(list(dt[1,"tags"][[1]], dt[1,"tags"][[1]]))
# dt[1,"tags"] <- I(list(c(dt[1,"tags"][[1]], dt[1,"tags"][[1]]))[[1]])

res <- as.yaml(dt, column.major = FALSE)

# ---- asdf ----
write(res, "data/links.yml")

yl          <- yaml::read_yaml("data/links.yml")
for(i in seq_len(length(yl))){
  yl[[i]]$tags <- list(yl[[i]]$tags)
}

write("tiles:", "data/links.yml")
write(as.yaml(yl), "data/links.yml", append = TRUE)
