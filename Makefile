PROJECTNAMES_PATH := static/projects_names.txt
PROJECTNAMES := $(shell cat ${PROJECTNAMES_PATH})

all: docs/index.html

svgs: $(PROJECTNAMES)
	echo svgs rendered
	
static/logos/%.svg: scripts/svg.R
	Rscript $< $(basename $@)

static/projects.csv: scripts/scrape.R
	Rscript $<
	
data/links.yml: scripts/yaml.R
	Rscript $<

docs/index.html: data/links.yml config.toml static/projects.csv svgs
	Rscript -e "blogdown::build_site()"
	