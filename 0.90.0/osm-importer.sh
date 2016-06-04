#!/bin/bash
# Rex Tsai <rex.cc.tsai@gmail.com>

echo REGION=${REGION:="asia/taiwan"}
echo COUNTRY=${COUNTRY:=$(basename $REGION)}
echo DATADIR=${DATADIR:="/osm"}
echo PBF=${PBF:=$DATADIR/${COUNTRY}-latest.osm.pbf}
echo LOOP=${LOOP:=600}
HOST=download.geofabrik.de

[ -d $DATADIR ] || (echo "$DATADIR not found" && exit -1)

if [ -z $PG_ENV_POSTGRES_PASSWORD ] \
    || [ -z $PG_ENV_POSTGRES_DB ] \
    || [ -z $PG_ENV_POSTGRES_USER ] \
    || [ -z $PG_PORT_5432_TCP_ADDR ] \
    || [ -z $PG_PORT_5432_TCP_PORT ] ; then
        echo "missing Progress settings"

cat <<EOF
PG_PORT_5432_TCP_ADDR=$PG_PORT_5432_TCP_ADDR
PG_PORT_5432_TCP_PORT=$PG_PORT_5432_TCP_PORT
PG_ENV_POSTGRES_DB=$PG_ENV_POSTGRES_DB
PG_ENV_POSTGRES_USER=$PG_ENV_POSTGRES_USER
PG_ENV_POSTGRES_PASSWORD=$PG_ENV_POSTGRES_PASSWORD
EOF
exit 1
fi

function importosm () {
    # ping database.
    echo "SELECT 1;" | PGPASSWORD=$PG_ENV_POSTGRES_PASSWORD \
        psql --no-password \
        -h $PG_PORT_5432_TCP_ADDR -p $PG_PORT_5432_TCP_PORT \
        -U $PG_ENV_POSTGRES_USER $PG_ENV_POSTGRES_DB \
    || return $?

    UPDATEPBF=$(mktemp -p $DATADIR XXX.pbf)
    if [ ! -f ${PBF} ] ; then
        wget -O "${UPDATEPBF}" http://$HOST/${REGION}-latest.osm.pbf \
            || return $?
    else
        osmupdate -v --base-url=$HOST/${REGION}-updates "$PBF" "$UPDATEPBF" \
            || return $?
    fi
    trap "Importing in progress, ignored SIGINT & SIGTERM." SIGINT SIGTERM
    PGPASSWORD=$PG_ENV_POSTGRES_PASSWORD \
        osm2pgsql --create --slim --cache 2000 \
        --host $PG_PORT_5432_TCP_ADDR \
        --database $PG_ENV_POSTGRES_DB \
        --username $PG_ENV_POSTGRES_USER \
        --port $PG_PORT_5432_TCP_PORT \
        $UPDATEPBF && mv -v $UPDATEPBF $PBF
}

while : ; do
    importosm
    [ $LOOP -eq 0 ] && exit $?
    sleep $LOOP || exit
done
