#!/bin/bash

set -e

docker build -t tmzk-build . 
docker run --name tmzk-build -v $(pwd):/mnt tmzk-build
docker container rm tmzk-build
#scp tmzk-3.4.13-1.deb user@192.168.183.137:
