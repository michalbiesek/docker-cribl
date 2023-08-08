FROM cribl/cribl:4.2.1

ARG MIMALLOC_VERSION=2.1.2
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends cmake g++ gcc make \
 && curl -Lso /tmp/mimalloc-${MIMALLOC_VERSION}.tar.gz https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.2.tar.gz \
 && cd /tmp && tar -xzf mimalloc-${MIMALLOC_VERSION}.tar.gz && cd mimalloc-${MIMALLOC_VERSION}/ && mkdir -p out/release \
 && cd out/release && cmake ../.. && make \
 && mv libmimalloc.so.2.1 /usr/lib \
 && rm /tmp/mimalloc-${MIMALLOC_VERSION}.tar.gz \
 && rm -rf /tmp/mimalloc-${MIMALLOC_VERSION} \
 && rm -rf /var/lib/apt/lists/*

ENV LD_PRELOAD="/usr/lib/libmimalloc.so.2.1"

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["cribl"]
