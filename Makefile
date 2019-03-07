PROJECTNAMES_PATH := static/projects_names.txt
PROJECTNAMES := $(shell cat ${PROJECTNAMES_PATH})

all: docs/index.html

clean:
	-rm data/links.yml

static/proj_ignore.csv: scripts/00_project_ignore.R
	Rscript $<

static/project_manual.csv: scripts/00_project_manual.R
	Rscript $<

static/projects_names.txt: scripts/01_scrape.R static/project_manual.csv static/proj_ignore.csv
	Rscript $<

static/projects.csv: scripts/01_scrape.R static/project_manual.csv static/proj_ignore.csv
	Rscript $<

static/projects_clean.csv: scripts/02_clean.R static/proj_ignore.csv static/projects.csv
	Rscript $<

svgs: $(PROJECTNAMES)
	echo svgs rendered

static/logos/%.svg: scripts/03_svg.R static/projects_names.txt static/proj_ignore.csv static/project_manual.csv static/projects_clean.csv
	Rscript $< $(basename $@)

data/links.yml: scripts/04_yaml.R static/proj_ignore.csv static/projects.csv static/projects_clean.csv
	Rscript $<

docs/index.html: data/links.yml config.toml svgs
	Rscript -e "blogdown::build_site()"
