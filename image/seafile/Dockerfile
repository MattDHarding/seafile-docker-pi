ARG BASE_IMAGE=codecutteruk/seafile-base:18.04
FROM $BASE_IMAGE
WORKDIR /opt/seafile

RUN mkdir -p /etc/my_init.d

ARG SEAFILE_VERSION=7.0.4
ENV SEAFILE_VERSION=${SEAFILE_VERSION}
ENV SEAFILE_SERVER=seafile-server

RUN mkdir -p /opt/seafile/ && \
    curl -sSL -o - https://github.com/haiwen/seafile-rpi/releases/download/v${SEAFILE_VERSION}/seafile-server_${SEAFILE_VERSION}_stable_pi.tar.gz \
    | tar xzf - -C /opt/seafile/

ADD scripts/create_data_links.sh /etc/my_init.d/01_create_data_links.sh

COPY scripts /scripts
COPY templates /templates

EXPOSE 80

CMD ["/sbin/my_init", "--", "/scripts/start.py"]
