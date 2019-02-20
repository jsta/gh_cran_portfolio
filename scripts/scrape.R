library(pkgsearch)
library(ghrecipes)
library(dplyr)

r_projects_cran <- pkg_search("Stachelek")

test <- ghrecipes::get_repos("jsta") %>%
  data.frame() %>%
  arrange(test, desc(totalCount))


