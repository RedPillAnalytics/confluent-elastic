# https://confluentinc.atlassian.net/browse/KSQL-292

ARG DOCKER_UPSTREAM_REGISTRY

FROM ${DOCKER_UPSTREAM_REGISTRY}confluentinc/ksql-clickstream-demo:0.4

EXPOSE 3000

RUN   apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y vim less \
    && echo "advertised.listeners=PLAINTEXT://localhost:9092" >> /etc/kafka/server.properties \
    && echo "advertised.host.name=localhost" >> /etc/kafka/server.properties \
    && echo "rest.port=18083" >> /etc/schema-registry/connect-avro-standalone.properties

#ADD start-mysql.sh /usr/local/bin/
#ADD start-maxwell.sh /usr/local/bin/
ADD start-ksql.sh /usr/local/bin/
#ADD my-maxwell.cnf /etc/mysql/conf.d/
#ADD mysql-maxwell-init.sql /tmp/
#ADD users.csv /var/lib/mysql-files/
#ADD db-setup.sql /var/lib/mysql-files/
#ADD db-inserts.sh /
#ADD mysql-users.properties /etc/kafka-connect-jdbc/
#ADD dashboard.json /usr/share/doc/ksql-clickstream-demo/
#ADD orders-to-grafana.sh /usr/share/doc/ksql-clickstream-demo/
ADD datagen-init.sh /

ENTRYPOINT /etc/init.d/elasticsearch start \
    && /etc/init.d/grafana-server start \
    && confluent start \
    #&& start-maxwell.sh \
    && start-ksql.sh \
    #&& ln -s /usr/share/java/mysql.jar /share/java/kafka-connect-jdbc/ \
    && bash
