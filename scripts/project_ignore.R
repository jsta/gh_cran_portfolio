suppressMessages(library(dplyr))

ignore_tags <- data.frame(
  tags = c("HTML", "Roff", "Makefile"), 
  stringsAsFactors = FALSE
)

ignore_proj <- data.frame(
  name = c("fabm", "openbugs", "nlmpy", "swatr", "jsta", "ReScience-submission", 
           "sfpolymorph", "sparrow", "software-review"), 
  stringsAsFactors = FALSE
)

ignore_accnt <- data.frame(
  accnt = c("carpentries", "GLEON", "openjournals"), 
  stringsAsFactors = FALSE
)

max_length <- c(nrow(ignore_tags), nrow(ignore_proj), nrow(ignore_accnt))[
  which.max(c(nrow(ignore_tags), nrow(ignore_proj), nrow(ignore_accnt)))]

append_na <- function(dt, max_length, name){
  names(dt) <- "name"
  na_vec <- rep(NA, abs(max_length - nrow(dt)))
  if(length(na_vec) > 0){
    dt <- rbind(dt, data.frame(name = na_vec))
  }
  setNames(dt, name)
}

ignore_accnt <- append_na(ignore_accnt, max_length, "accnt")
ignore_proj  <- append_na(ignore_proj, max_length, "name")
ignore_tags  <- append_na(ignore_tags, max_length, "tags")

res <- bind_cols(ignore_tags, ignore_proj, ignore_accnt)

write.csv(res, "static/proj_ignore.csv", row.names = FALSE)
