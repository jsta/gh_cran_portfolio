library(dplyr)

ignore_tags <- data.frame(
  tags = c("HTML", "Roff", "Makefile"), 
  stringsAsFactors = FALSE
)

ignore_proj <- data.frame(
  name = c("fabm", "openbugs", "nlmpy", "swatr", "jsta"), 
  stringsAsFactors = FALSE
)

na_vec <- rep(NA, abs(nrow(ignore_proj) - nrow(ignore_tags)))
if(which.min(c(nrow(ignore_proj), nrow(ignore_tags))) == 2){
  ignore_tags <- rbind(ignore_tags, data.frame(tags = na_vec))
}else{
  ignore_proj <- rbind(ignore_proj, data.frame(name = na_vec))
}

res <- bind_cols(ignore_tags, ignore_proj)

write.csv(res, "static/proj_ignore.csv", row.names = FALSE)
