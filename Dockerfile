FROM fedora:35

RUN mkdir -p /opt/grafana
RUN adduser -m grafana
RUN chown grafana:grafana /opt/grafana

WORKDIR /opt/grafana
USER grafana

RUN curl https://dl.grafana.com/enterprise/release/grafana-enterprise-8.3.2.linux-amd64.tar.gz > grafana.tgz && tar xvfz grafana.tgz && rm grafana.tgz && ln -s grafana-8.3.2 grafana

WORKDIR /opt/grafana/grafana/bin/
CMD /opt/grafana/grafana/bin/grafana-server
ADD defaults.ini /opt/grafana/grafana-8.3.2/conf/defaults.ini
