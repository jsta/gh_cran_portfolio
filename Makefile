PROJECTNAMES_PATH := static/projects_names.txt
PROJECTNAMES := $(shell cat ${PROJECTNAMES_PATH})

all: docs/index.html

static/proj_ignore.csv: scripts/project_ignore.R
	Rscript $<

static/projects_names.txt: scripts/scrape.R static/project_manual.csv
	Rscript $<

static/projects.csv: scripts/scrape.R static/project_manual.csv
	Rscript $<
	
svgs: $(PROJECTNAMES)
	echo svgs rendered
	
static/logos/%.svg: scripts/svg.R static/projects_names.txt static/proj_ignore.csv
	Rscript $< $(basename $@)
	
data/links.yml: scripts/yaml.R static/proj_ignore.csv static/projects.csv
	Rscript $<

docs/index.html: data/links.yml config.toml svgs
	Rscript -e "blogdown::build_site()"
	