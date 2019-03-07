# Github CRAN Portfolio

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) [![Docker Build](https://img.shields.io/badge/Docker%20Image-jsta/gh_cran_portfolio-green.svg)](https://cloud.docker.com/repository/docker/jsta/gh_cran_portfolio)

Are pinned 6 pinned Github repositories not enough for you? Do you wish repositories could be tagged with more than one language/framework? 

This hugo based, #rstats blogdown, template lets you create your own sorted dashboard for programming projects and CRAN packages. It leverages the `ghrecipes` package and `tools::CRAN_package_db()` to search for projects (You can also define your own custom projects). The default tile image is an svg of the project name, but you can also define a custom image. The official hex sticker for a package will be used if an image exists in the Github repo linked to the CRAN URL at `man/figures/logo.png`.  

## Dependencies

See [Dockerfile](Dockerfile).

## Usage

### Workflow

1. Add categories(tags) _manually_ via [config.toml](config.toml)

    * Icon codes can be found at: https://fontawesome.io
  
    * Tags must be lower case
  
2. Add projects to include _manually_ via [scripts/00_project_manual.R](scripts/00_project_manual.R)

3. Add projects and tags to ignore _manually_ via [scripts/00_project_ignore.R](scripts/00_project_ignore.R)

4. Set author and Github account in [scripts/01_scrape.R](scripts/01_scrape.R)

5. Scrape CRAN and Github, build site via [Makefile](Makefile)

    * Tags are detected automatically from Github scraping. Add secondary tags _manually_ via [data/links.yml](data/links.yml)

```
make clean # to remove cached projects
```
```
make all
make all
```

6. Preview site 

```r
blogdown::serve_site()
```

## Credit

Modified from the [slate hugo template](https://github.com/gesquive/slate)
