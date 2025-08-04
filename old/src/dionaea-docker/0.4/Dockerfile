FROM ubuntu:16.04

COPY build.sh /build/bin/

RUN /bin/bash /build/bin/build.sh && \
    groupadd --gid 1000 dionaea && \
    useradd -m --uid 1000 --gid 1000 dionaea && \
    chown -R dionaea:dionaea /opt/dionaea/var && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        p0f \
        supervisor && \
    apt-get clean && \
    rm -rf /opt/dionaea/etc/dionaea && \
    rm -rf /build /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY supervisor/*.conf /etc/supervisor/conf.d/
COPY conf /opt/dionaea/etc/dionaea

EXPOSE 21 42 69/udp 80 135 443 445 1433 1723 1883 1900/udp 3306 5060 5060/udp 5061 11211

CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisor/supervisord.conf"]
