#!/bin/bash

# Base Script File (build_and_run.sh)
# Created: dim. 06 janv. 2019 21:07:49 GMT
# Version: 1.0
#
# This Bash script was developped by Cory.
#
# (c) Cory <sgryco@gmail.com>
set -e
docker build . -t sgryco/fastaipip
