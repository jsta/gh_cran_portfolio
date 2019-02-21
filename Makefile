PROJECTNAMES_PATH := static/projects_names.txt
PROJECTNAMES := $(shell cat ${PROJECTNAMES_PATH})

all: static/projects.csv

svgs: $(PROJECTNAMES)
	echo svgs rendered
	
static/logos/%.svg: scripts/svg.R
	Rscript $< $(basename $@)

static/projects.csv: scripts/scrape.R
	Rscript $<