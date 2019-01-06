#!/bin/bash

# Base Script File (build_and_run.sh)
# Created: dim. 06 janv. 2019 21:07:49 GMT
# Version: 1.0
#
# This Bash script was developped by Cory.
#
# (c) Cory <sgryco@gmail.com>
set -e

docker run --runtime=nvidia --rm -it -p 8888:8888 \
  -v$HOME/.torch:/root/.torch -v $HOME/fastai:/fastai \
  -v $HOME/fastai/data:/fastai/courses/dl1/data \
  sgryco/fastaipip

