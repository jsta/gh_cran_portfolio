# Data Science Portfolio

## Usage

### Build site

```r
blogdown::build_site() 
blogdown::serve_site() # preview site
```

### Workflow

#### Add categories

_Manually_ via [config.toml](config.toml)

  * Icon codes can be found at: https://fontawesome.io
  
  * Tags must be lower case

#### Add projects and tags to ignore

_Manually_ via [scripts/project_ignore.R](scripts/project_ignore.R)

#### Pull projects from Github and CRAN 

_Automatically_ after setting the Author and Github account in [scripts/scrape.R](scripts/scrape.R)

#### Add projects manually 

via [scripts/projects_manual.R](scripts/projects_manual.R)

#### Build site

`$ make all`

#### Add secondary tags (optional)

_Manually_ via [data/links.yml](data/links.yml)
