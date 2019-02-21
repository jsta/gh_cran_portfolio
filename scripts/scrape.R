library(ghrecipes)
library(dplyr)
library(tidyr)
library(stringr)

projects_cran_raw <- tools::CRAN_package_db()
projects_cran     <- projects_cran_raw[,!duplicated(names(projects_cran_raw))] %>%
  dplyr::select(Package, Author, Title, URL) %>%
  dplyr::filter(stringr::str_detect(Author, "Stachelek"))

projects_gh_raw <- ghrecipes::get_repos("jsta") %>%
  data.frame() 
projects_gh     <-  projects_gh_raw %>%
  mutate(stargazers_count = projects_gh_raw$stargazers_count$totalCount) %>%
  arrange(desc(stargazers_count)) %>%
  filter(!is_archived) %>%
  filter(!is_fork) %>%
  filter(stargazers_count > 0) %>%
  mutate(URL = paste0("https://github.com/", name)) %>%
  rename(Title = description) %>%
  separate(name, c("accnt", "Package"), sep = "/")

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

