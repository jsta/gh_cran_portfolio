# Data Science Portfolio

## Usage

### Workflow

1. Add categories(tags) _manually_ via [config.toml](config.toml)

    * Icon codes can be found at: https://fontawesome.io
  
    * Tags must be lower case
  
2. Add projects to include _manually_ via [scripts/projects_manual.R](scripts/projects_manual.R)

3. Set author and Github account in [scripts/scrape.R](scripts/scrape.R)

4. Add projects and tags to ignore _manually_ via [scripts/project_ignore.R](scripts/project_ignore.R)

5. Scrape CRAN and Github, build site via [Makefile](Makefile)

    * Tags are detected automatically from Github scraping. Add secondary tags _manually_ via [data/links.yml](data/links.yml)

```
make all
```

6. Preview site 

```r
blogdown::serve_site() # preview site
```
