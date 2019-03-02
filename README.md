# Data Science Portfolio

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
make all
```

6. Preview site 

```r
blogdown::serve_site()
```

## Credit

Modified from the [slate hugo template](https://github.com/gesquive/slate)
