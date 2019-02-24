library(ghrecipes)
suppressMessages(library(dplyr))
library(tidyr)
library(stringr)

projects_cran_raw <- tools::CRAN_package_db()
projects_cran     <- projects_cran_raw[,!duplicated(names(projects_cran_raw))] %>%
  dplyr::select(Package, Author, Title, URL) %>%
  dplyr::filter(stringr::str_detect(Author, "Stachelek")) %>%
  mutate(tags = "R")

projects_gh_raw <- ghrecipes::get_repos("jsta") %>%
  data.frame() 
projects_gh     <-  projects_gh_raw %>%
  mutate(stargazers_count = projects_gh_raw$stargazers_count$totalCount) %>%
  mutate(tags = projects_gh_raw$language$name, 
         bg_color = projects_gh_raw$language$color) %>%
  select(-language) %>%
  arrange(desc(stargazers_count)) %>%
  filter(!is_archived) %>%
  filter(!is_private) %>%
  # filter(!is_fork) %>%
  filter(stargazers_count > 0) %>%
  mutate(URL = paste0("https://github.com/", name)) %>%
  rename(Title = description) %>%
  separate(name, c("accnt", "Package"), sep = "/")

projects_cran <- projects_cran %>%
  mutate(bg_color = projects_gh$bg_color[
    projects_gh$tags == "R" & !is.na(projects_gh$tags)][1])

res <- bind_rows(projects_cran, projects_gh) %>%
  select(names(projects_cran)) %>%
  filter(!duplicated(Package)) %>%
  filter(!stringr::str_detect(Title, "Reviews")) %>%
  filter(!stringr::str_detect(Package, c(".io$"))) %>%
  filter(!stringr::str_detect(Package, c("Notes$")))

write.csv(res, "static/projects.csv", row.names = FALSE)
write(paste0("static/logos/", res$Package, ".svg"), 
      file.path("static", "projects_names.txt"))
# res <- read.csv("static/projects.csv", stringsAsFactors = FALSE)

