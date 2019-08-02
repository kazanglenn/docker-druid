FROM openjdk:8u222-jre

# Versions change, will need updating
ENV DRUID_VERSION 0.15.0
ENV ZOOKEEPER_VERSION 3.5.5

RUN apt update
RUN apt install -y perl

# Druid
RUN wget -q -O - http://apache.cp.if.ua/incubator/druid/${DRUID_VERSION}-incubating/apache-druid-${DRUID_VERSION}-incubating-bin.tar.gz | tar -xzf - -C /usr/local \
      && ln -s /usr/local/apache-druid-${DRUID_VERSION}-incubating /usr/local/druid

# Zookeeper
RUN wget -q -O - https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}.tar.gz | tar -xzf - -C /usr/local \
      && ln -s /usr/local/zookeeper-${ZOOKEEPER_VERSION} /usr/local/druid/zk

# Expose ports:
# - 8081: HTTP (coordinator)
# - 8082: HTTP (broker)
# - 8083: HTTP (historical)
# - 8090: HTTP (overlord)
# - 2181 2888 3888: ZooKeeper
EXPOSE 8081
EXPOSE 8082
EXPOSE 8083
EXPOSE 8090
EXPOSE 3306
EXPOSE 2181 2888 3888

VOLUME /usr/local/druid/var

CMD ["/usr/local/druid/bin/supervise", "-c", "/usr/local/druid/quickstart/tutorial/conf/tutorial-cluster.conf"]