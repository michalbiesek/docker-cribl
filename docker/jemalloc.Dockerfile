FROM cribl/cribl:4.2.1

ARG JEMALLOC_VERSION=5.3.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends automake g++ gcc libtool make \
 && curl -Lso /tmp/jemalloc-${JEMALLOC_VERSION}.tar.bz2 https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VERSION}/jemalloc-${JEMALLOC_VERSION}.tar.bz2 \
 && cd /tmp && tar -xjf jemalloc-${JEMALLOC_VERSION}.tar.bz2 && cd jemalloc-${JEMALLOC_VERSION}/ \
 && ./configure && make \
 && mv lib/libjemalloc.so.2 /usr/lib \
 && rm /tmp/jemalloc-${JEMALLOC_VERSION}.tar.bz2 \
 && rm -rf /tmp/jemalloc-${JEMALLOC_VERSION} \
 && rm -rf /var/lib/apt/lists/*

ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["cribl"]
