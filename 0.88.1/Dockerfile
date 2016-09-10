FROM ubuntu:xenial
MAINTAINER Rex Tsai "https://about.me/chihchun"

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -e s%http://archive.ubuntu.com/ubuntu/%mirror://mirrors.ubuntu.com/mirrors.txt% -i /etc/apt/sources.list
RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y vim

ENV OSM2PGSQL_VERSION=0.88.1-1 \
    OSMCTOOLS_VERSION=0.6-1

RUN apt-get install -y osm2pgsql=${OSM2PGSQL_VERSION} osmctools=${OSMCTOOLS_VERSION} \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# osm replication script
ADD ./osm-importer.sh /usr/local/bin/osm-importer.sh
WORKDIR /osm
CMD ["/bin/bash", "-i", "/usr/local/bin/osm-importer.sh"]
