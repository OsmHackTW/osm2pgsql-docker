#!/bin/sh
POSTGIS_INSTANCE=${1:-"osm-postgis"}
POSTGIS_PASSWORD=${2:-"mysecretpassword"}
docker run --name ${POSTGIS_INSTANCE} -e POSTGRES_PASSWORD=${POSTGIS_PASSWORD} -d osmtw/postgis
