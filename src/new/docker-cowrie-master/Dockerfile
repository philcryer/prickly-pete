FROM gliderlabs/alpine
MAINTAINER Vlatko Kosturjak kost@kost.im

RUN apk --update add git python py-twisted py-zope-interface py-pip && rm -f /var/cache/apk/*
RUN pip install pyasn1
RUN adduser -D -s /bin/sh cowrie cowrie
USER cowrie
RUN git clone https://github.com/micheloosterhof/cowrie.git /home/cowrie/cowrie
COPY cowrie.cfg /home/cowrie/cowrie/
COPY start-docker.sh /home/cowrie/cowrie/
USER root
RUN chmod 755 /home/cowrie/cowrie/start-docker.sh
USER cowrie
EXPOSE 2222
ENTRYPOINT ["/home/cowrie/cowrie/start-docker.sh"]
