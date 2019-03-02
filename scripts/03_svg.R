# Rscript svg.R static/logos/smwrQW

cmdargs      <- commandArgs(trailingOnly = TRUE)
# cmdargs <- NA; cmdargs <- "r-raster-vector-geospatial"
outpath      <- paste0(cmdargs[1], ".svg")

project_name <- strsplit(cmdargs[1], "/")[[1]]
project_name <- project_name[length(project_name)]

dt             <- read.csv("static/projects_clean.csv", stringsAsFactors = FALSE)
project_manual <- read.csv("static/project_manual.csv", 
                           stringsAsFactors = FALSE)

library(svglite)
library(magrittr)
suppressMessages(library(magick))
library(rsvg)
suppressMessages(library(dplyr))
library(gh)
suppressMessages(library(purrr))
library(base64enc)

get_cex <- function(x, base = 10, scale = 4){
  if(x > base){
    base + ((1 / (base / (base - x))) * scale)
  }else{
    base
  }
}

make_svg_base <- function(outpath, project_name, overwrite = FALSE){
  if(!file.exists(outpath) & !overwrite){
    svglite(outpath, bg = "transparent")
    par_original <- par()
    par(bg = NA)
    plot.new()
    text(0.5, 0.5, project_name, cex = get_cex(nchar(project_name), 9.2, 3.8))
    dev.off()
    suppressWarnings(par(par_original))
    
    image_read_svg(outpath) %>%
      image_trim() %>%
      image_write(outpath, format = "svg")
  }
}

# https://gist.github.com/noamross/73944d85cad545ae89efaa4d90b049db
#' Gets a file from a github repo, using the Data API blob endpoint
#'
#' This avoids the 1MB limit of the content API and uses [gh::gh] to deal with
#' authorization and such.  See https://developer.github.com/v3/git/blobs/
#' @param url the URL of the file to download via API, of the form
#'   `:owner/:repo/blob/:path
#' @param ref the reference of a commit: a branch name, tag, or commit SHA
#' @param owner,repo,path,ref alternate way to specify the file.  These will
#'   override values in `url`
#' @param to_disk,destfile write file to disk (default=TRUE)?  If so, use the
#'   name in `destfile`, or the original filename by default
#' @param .token,.api_url,.method,.limit,.send_headers arguments passed on to
#'   [gh::gh]
#' @importFrom gh gh
#' @importFrom stringi stri_match_all_regex
#' @importFrom purrr %||%
#' @importFrom base64enc  base64decode
#' @return Either the local path of the downloaded file (default), or a raw
#'   vector
gh_file <- function(url = NULL, ref=NULL,
                    owner = NULL, repo = NULL, path = NULL,
                    to_disk=TRUE, destfile=NULL,
                    .token = NULL, .api_url= NULL, .method="GET",
                    .limit = NULL, .send_headers = NULL) {
  if (!is.null(url)) {
    matches <- stringi::stri_match_all_regex(
      url,
      "(github\\.com/)?([^\\/]+)/([^\\/]+)/[^\\/]+/([^\\/]+)/([^\\?]+)"
    )
    owner <- owner %||% matches[[1]][3]
    repo <- repo %||% matches[[1]][4]
    ref <- ref %||% matches[[1]][5]
    path <- path %||% matches[[1]][6]
    pathfile <- basename(path)
  }
  pathdir <- dirname(path)
  if(length(grep("/", path)) == 0){
    pathdir <- NULL
  }
  
  blob <- gh(
    paste0("/repos/:owner/:repo/contents/", path),
    owner = owner, repo = repo,
    .token = NULL, .api_url = NULL, .method = "GET",
    .limit = NULL, .send_headers = NULL
  )
  raw <- base64decode(blob[["content"]])
  if (to_disk) {
    destfile <- destfile %||% pathfile
    writeBin(raw, con = destfile)
    return(destfile)
  } else {
    return(raw)
  }
}

# ---- execute ----
if(!file.exists(outpath)){
  make_svg_base(outpath, project_name)
  if(project_name %in% project_manual$name){
    remote_path <- dplyr::filter(project_manual, name == project_name) %>%
      dplyr::select(remote_img) %>% 
      `[[`("remote_img")
    
    if(!is.na(remote_path)){
      dl_path <- paste0("static/logos/", basename(remote_path))
      if(!file.exists(dl_path)){
        download.file(remote_path, dl_path)
      }
      image_read(dl_path) %>%
        image_trim() %>%
        image_write(outpath, format = "svg")
    }
  }
    
  remote_url <- dplyr::filter(dt, name == project_name)$url
  if(length(grep("github", remote_url)) > 0){
    gh_path <- strsplit(remote_url[[1]], "/")[[1]]
    gh_path <- paste0(gh_path[
      (length(gh_path) - 1):length(gh_path)], collapse = "/")
    gh_path <- paste0(gh_path, "/blob/master/man/figures/logo.png")
    logo_path <- paste0("static/logos/", project_name, ".png")
    if(!file.exists(logo_path)){
      tryCatch(
        gh_file(gh_path, destfile = logo_path), 
        error = function(e) message("No Github logo found."))# try logo_small.png
      if(file.exists(logo_path)){
        image_read(logo_path) %>%
          image_trim() %>%
          image_write(outpath, format = "svg")
      }
    }
  }
}
