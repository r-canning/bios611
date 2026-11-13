#!/bin/bash

docker build . -t bios611

MSYS_NO_PATHCONV=1 docker run -it \
  -p 8787:8787 \
  -v "$(pwd):/home/rstudio/work" \
  -e PASSWORD=lab \
  bios611
  
