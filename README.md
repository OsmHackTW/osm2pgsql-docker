# osm2pgsql docker iamge

## Software version
- Ubuntu 16.04
- osm2pgsql 0.90.0

## Usage

See postgis.sh & run.sh as example. You must run a postgres/postgis server, and name it's alias as pg.

```{r, engine='bash'}
    #!/bin/sh
    # Run a postgres/postgis instance
    POSTGRES_USER=postgres
    POSTGRES_DB=postgres
    POSTGIS_PASSWORD=$(cat /dev/urandom| tr -dc _A-Z-a-z-0-9 | head -c12)
    POSTGIS_INSTANCE="osmdb"

    docker run --name ${POSTGIS_INSTANCE} \
        -e POSTGRES_PASSWORD=${POSTGIS_PASSWORD} \
        -e POSTGRES_USER=${POSTGRES_USER} \
        -e POSTGRES_DB=${POSTGRES_DB} \
        -d osmtw/postgis

    REGION="asia/taiwan"
    DATADIR=/osm
    LOOP=600
    VERSION="0.88.1"
    # run the osm2pgsql instance
    # The osm-importer.sh script will run osmupdate every 600 seconds,
    # to pull latest osm data from
    docker run -t -i --rm \
        --link ${POSTGIS_INSTANCE}:pg \
        -e REGION=$REGION \
        -e DATADIR=$DATADIR \
        -e LOOP=$LOOP \
        -v ${POSTGIS_INSTANCE}-osm2pgsql:$DATADIR \
        --name osm2pgsql \
        osmtw/osm2pgsql:${VERSION}
```
