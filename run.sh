#!/bin/bash
POSTGIS_INSTANCE=${1:-"osmdb"}
REGION=${2:-"asia/taiwan"}
COUNTRY=$(basename $REGION)
[ ! -f osm/${COUNTRY}-latest.osm.pbf ] && mkdir osm && cd osm && http://download.geofabrik.de/${REGION}-latest.osm.pbf && cd -

docker run -i -t --rm --link ${POSTGIS_INSTANCE}:pg -v `pwd`/osm:/osm -e PG_ENV_OSM_DB=postgres -e PG_ENV_OSM_USER=postgres -e COUNTRY=${COUNTRY} osmtw/osm2pgsql -c \
    'PGPASSWORD=$PG_ENV_POSTGRES_PASSWORD osm2pgsql --create --slim --cache 2000 --database $PG_ENV_OSM_DB --username $PG_ENV_OSM_USER --host pg --port $PG_PORT_5432_TCP_PORT /osm/${COUNTRY}-latest.osm.pbf'
