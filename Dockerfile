FROM rocker/tidyverse:latest

MAINTAINER "Joseph Stachelek" stachel2@msu.edu

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libmagick++-dev \
  imagemagick \
  libjq-dev \
  && install2.r --error \
    blogdown \
    yaml \
    magick \
    svglite \
    gh \
    base64enc

RUN Rscript -e "devtools::install_github('jsta/ghrecipes')"






