#!/bin/sh
POSTGRES_USER=postgres
POSTGRES_DB=postgres
POSTGIS_INSTANCE=${1:-"osmdb"}
POSTGIS_PASSWORD=${2:-$(cat /dev/urandom| tr -dc _A-Z-a-z-0-9 | head -c12)}
docker run --name ${POSTGIS_INSTANCE} \
    -e POSTGRES_PASSWORD=${POSTGIS_PASSWORD} \
    -e POSTGRES_USER=${POSTGRES_USER} \
    -e POSTGRES_DB=${POSTGRES_DB} \
    -d osmtw/postgis
