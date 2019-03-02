suppressMessages(library(dplyr))

dt_raw      <- read.csv("static/projects.csv", stringsAsFactors = FALSE)
proj_ignore <- read.csv("static/proj_ignore.csv", stringsAsFactors = FALSE)

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
dt_manual <- read.csv("static/project_manual.csv", stringsAsFactors = FALSE) %>%
  dplyr::select(-remote_img)
dt        <- dplyr::filter(dt, !(name %in% dt_manual$name))
dt        <- bind_rows(dt, dt_manual)

write.csv(dt, "static/projects_clean.csv", row.names = FALSE)
