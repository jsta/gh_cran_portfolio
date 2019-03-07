FROM rocker/tidyverse:latest

MAINTAINER "Joseph Stachelek" stachel2@msu.edu

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libmagick++-dev \
  imagemagick \
  libjq-dev \
  vim \
  && install2.r --error \
    blogdown \
    yaml \
    magick \
    svglite \
    gh \
    base64enc

RUN installGithub.r \
  jsta/ghrecipes \
  tidyverse/dplyr

RUN git clone https://github.com/jsta/gh_cran_portfolio.git

RUN Rscript -e "blogdown::install_hugo()"

WORKDIR gh_cran_portfolio
