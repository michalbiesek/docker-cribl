FROM cribl/cribl:4.2.1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends g++ gcc libstdc++-9-dev make unzip \
 && curl -Lso /tmp/hoard.zip https://github.com/emeryberger/Hoard/archive/refs/heads/master.zip \
 && cd /tmp && unzip /tmp/hoard.zip \
 && cd /tmp/Hoard-master/src && make \
 && mv libhoard.so /usr/lib \
 && rm /tmp/hoard.zip \
 && rm -rf /tmp/Hoard-master/ \
 && rm -rf /var/lib/apt/lists/*

ENV LD_PRELOAD="/usr/lib/libhoard.so"

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["cribl"]
