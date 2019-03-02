library(ghrecipes)
suppressMessages(library(dplyr))
library(tidyr)
library(stringr)

projects_manual <- read.csv("static/project_manual.csv", stringsAsFactors = FALSE)
proj_ignore     <- read.csv("static/proj_ignore.csv", stringsAsFactors = FALSE)

projects_cran_raw <- tools::CRAN_package_db()
projects_cran     <- projects_cran_raw[,!duplicated(names(projects_cran_raw))] %>%
  dplyr::select(Package, Author, Title, URL) %>%
  dplyr::filter(stringr::str_detect(Author, "Stachelek")) %>%
  mutate(tags = "R")

projects_gh_raw <- ghrecipes::get_repos("jsta") %>%
  data.frame()

projects_gh_contrib_raw <- ghrecipes::get_repos_contributed("jsta") %>%
  data.frame()

projects_gh     <-  projects_gh_raw %>%
  mutate(stargazers_count = projects_gh_raw$stargazers_count$totalCount) %>%
  mutate(tags = projects_gh_raw$language$name, 
         bg_color = projects_gh_raw$language$color) %>%
  select(-language) %>%
  arrange(desc(stargazers_count))

projects_gh_contrib     <-  projects_gh_contrib_raw %>%
  mutate(stargazers_count = projects_gh_contrib_raw$stargazers_count$totalCount) %>%
  mutate(tags = projects_gh_contrib_raw$language$name, 
         bg_color = projects_gh_contrib_raw$language$color) %>%
  select(-language) %>%
  arrange(desc(stargazers_count)) %>%
  filter(!(name %in% projects_gh$name))

projects_gh <- bind_rows(projects_gh, projects_gh_contrib)
projects_gh <- projects_gh %>%
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
  filter(!(accnt %in% proj_ignore$accnt)) %>%
  select(names(projects_cran)) %>%
  filter(!duplicated(Package)) %>%
  filter(!stringr::str_detect(Title, "Reviews")) %>%
  filter(!stringr::str_detect(Package, c(".io$"))) %>%
  filter(!stringr::str_detect(Package, c("Notes$"))) %>%
  filter(!(Package %in% proj_ignore$name)) 

write.csv(res, "static/projects.csv", row.names = FALSE)
write(paste0("static/logos/", c(res$Package, projects_manual$name), ".svg"), 
      file.path("static", "projects_names.txt"))
# res <- read.csv("static/projects.csv", stringsAsFactors = FALSE)

