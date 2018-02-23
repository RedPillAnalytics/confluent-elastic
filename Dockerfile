# https://confluentinc.atlassian.net/browse/KSQL-292

ARG DOCKER_UPSTREAM_REGISTRY

FROM ${DOCKER_UPSTREAM_REGISTRY}confluentinc/ksql-clickstream-demo:0.4

EXPOSE 3000

# configurations for Kafka
RUN   apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y vim less \
    && echo "advertised.listeners=PLAINTEXT://localhost:9092" >> /etc/kafka/server.properties \
    && echo "advertised.host.name=localhost" >> /etc/kafka/server.properties \
    && echo "rest.port=18083" >> /etc/schema-registry/connect-avro-standalone.properties

ADD start-ksql.sh /usr/local/bin/
ADD datagen-init.sh /

ENTRYPOINT /etc/init.d/elasticsearch start \
    && /etc/init.d/grafana-server start \
    && confluent start \
    && start-ksql.sh \
    && bash
