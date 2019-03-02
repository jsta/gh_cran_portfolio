library(yaml)
suppressMessages(library(dplyr))

dt <- read.csv("static/projects_clean.csv", stringsAsFactors = FALSE)
yl <- yaml::read_yaml("data/links.yml")

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
