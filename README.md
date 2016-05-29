osm2pgsql docker iamge


[![Join the chat at https://gitter.im/OsmHackTW/osm2pgsql-docker](https://badges.gitter.im/OsmHackTW/osm2pgsql-docker.svg)](https://gitter.im/OsmHackTW/osm2pgsql-docker?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Version
- Ubuntu 16.04
- osm2pgsql 0.90.0

## Usage

See postgis.sh & run.sh as example. You must run a postgres/postgis server, and name it's alias as pg.

    POSTGIS_INSTANCE="osmdb"
    REGION="asia/taiwan"
    DATADIR=/osm
    LOOP=600
    VERSION="0.88.1"
    
    docker run -t -i --rm \
        --link ${POSTGIS_INSTANCE}:pg \
        -e REGION=$REGION \
        -e DATADIR=$DATADIR \
        -e LOOP=$LOOP \
        -v ${POSTGIS_INSTANCE}-volume:$DATADIR \
        --name osm2pgsql \
        osmtw/osm2pgsql:${VERSION}

