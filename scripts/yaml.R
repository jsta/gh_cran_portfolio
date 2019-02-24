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
  mutate(tile_tooltip = case_when(nchar(tile_tooltip) > 85 ~ 
                                    paste0(strtrim(tile_tooltip, 85), "..."), 
         TRUE ~ tile_tooltip)) %>%
  # strip emoji
  mutate(tile_tooltip = stringr::str_remove(tile_tooltip, ":[^\\s)](.*):")) %>%
  mutate(tile_tooltip = stringr::str_remove(tile_tooltip, "\\p{So}|\\p{Cn}")) %>%
  filter(!(name %in% proj_ignore$name)) %>%
  mutate(img = paste0("logos/", name, ".svg")) %>%
  select(name, url, img, bg_color, tile_tooltip, tags) %>%
  # group_by(tags) %>% sample_n(1) %>% ungroup() %>%
  mutate(tags = case_when(tags == "R" ~ "rstats", 
                          tags == "Python" ~ "python",
                          tags == "MATLAB" ~ "matlab",
                          tags == "TeX" ~ "tex",
         TRUE ~ tags))

# read custom non-scraped project info from file, append to dt
dt_manual <- read.csv("static/project_manual.csv", stringsAsFactors = FALSE)
dt        <- bind_rows(dt, dt_manual)

# keep dt unless yl_dt tags longer than dt tags
yl_dt   <- dplyr::bind_rows(
  lapply(yl[[1]], data.frame, stringsAsFactors = FALSE)) %>%
  group_by(name) %>%
  add_tally(sort = TRUE, name = "n_tags") %>%
  distinct(name, n_tags)
dt_dups <- dt[dt$name %in% yl_dt$name,]
dt_dups <- dt_dups[dt_dups$name %in% dplyr::filter(yl_dt, n_tags > 1)$name,]
# dt      <- dplyr::filter(dt, !(name %in% dt_dups$name))

# find yl positions and save yl objects to append later 
yl_stash <- which(purrr::map_chr(yl[[1]], "name") %in% dt_dups$name)
yl_stash <- lapply(yl_stash, function(x) yl[[1]][[x]])

res <- as.yaml(dt, column.major = FALSE)
write(res, "data/links.yml")

# append yl_stash tags if yl[[i]]$name matches yl_stash
yl          <- yaml::read_yaml("data/links.yml")
for(i in seq_len(length(yl))){
  if(yl[[i]]$name %in%
     unlist(lapply(yl_stash, function(x) x$name))){
    tags <- yl_stash[[which(
                        unlist(lapply(yl_stash, function(x) x$name)) %in%
                        yl[[i]]$name
                      )]]$tags
  }else{
    tags <- list(yl[[i]]$tags)
  }
  yl[[i]]$tags <- tags
}

write("tiles:", "data/links.yml")
write(as.yaml(yl), "data/links.yml", append = TRUE)
