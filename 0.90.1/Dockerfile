FROM ubuntu:xenial
MAINTAINER Rex Tsai "https://about.me/chihchun"

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -e s%http://archive.ubuntu.com/ubuntu/%mirror://mirrors.ubuntu.com/mirrors.txt% -i /etc/apt/sources.list
RUN apt-get update \
        && apt-get dist-upgrade -y \
        && apt-get install -y vim

RUN apt-get install -y \
        make \
        cmake \
        g++ \
        git-core \
        libboost-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        libexpat1-dev \
        zlib1g-dev \
        libbz2-dev \
        libpq-dev \
        libgeos-dev \
        libgeos++-dev \
        libproj-dev \
        lua5.2 \
        liblua5.2-dev

ENV OSM2PGSQL_VERSION=0.90.1 \
    OSMCTOOLS_VERSION=0.6-1

# osm2pgsql
RUN cd /tmp && git clone --depth 1 --branch $OSM2PGSQL_VERSION https://github.com/openstreetmap/osm2pgsql.git && \
    mkdir -p osm2pgsql/build && \
    cd osm2pgsql/build  && \
    cmake .. && make install

# osmctools && clean up
RUN apt-get install -y osmctools=${OSMCTOOLS_VERSION} postgresql-client-9.5 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# osm replication script
ADD ./osm-importer.sh /usr/local/bin/osm-importer.sh
WORKDIR /osm
CMD ["/bin/bash", "-i", "/usr/local/bin/osm-importer.sh"]
