FROM fedora:36

RUN mkdir -p /opt/grafana
RUN adduser -m grafana
RUN chown grafana:grafana /opt/grafana

WORKDIR /opt/grafana
USER grafana

RUN curl https://dl.grafana.com/enterprise/release/grafana-enterprise-9.2.1.linux-amd64.tar.gz > grafana.tgz && tar xvfz grafana.tgz && rm grafana.tgz && ln -s grafana-9.2.1 grafana

WORKDIR /opt/grafana/grafana/bin/
CMD /opt/grafana/grafana/bin/grafana-server
ADD defaults.ini /opt/grafana/grafana-9.2.1/conf/defaults.ini
