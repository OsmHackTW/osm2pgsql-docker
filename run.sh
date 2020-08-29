#!/bin/bash
POSTGIS_INSTANCE=${1:-"osmdb"}
REGION=${2:-"asia/taiwan"}
DATADIR=/osm
LOOP=600
VERSION=${3:-"1.3.0"}

docker run -t -i --rm \
    --link ${POSTGIS_INSTANCE}:pg \
    -e REGION=$REGION \
    -e DATADIR=$DATADIR \
    -e LOOP=$LOOP \
    -v ${POSTGIS_INSTANCE}-volume:$DATADIR \
    --name osm2pgsql \
    osmtw/osm2pgsql:${VERSION}
