FROM centos:centos7

MAINTAINER Nick Travers <n.e.travers@gmail.com>

ENV JAVA_VERSION 1.8.0
ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.0.1

RUN yum update -y \
  && yum install -y \
    java-${JAVA_VERSION}-openjdk-devel \
    net-tools \
    ruby \
    wget \
  && yum clean all \
  && rm -rf /var/cache/yum

WORKDIR /tmp
RUN wget http://www-us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -O kafka.tgz \
  && tar xzf kafka.tgz \
  && mv kafka_${SCALA_VERSION}-${KAFKA_VERSION}/ /opt/kafka/ \
  && rm kafka.tgz

# Install Kafka
ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

WORKDIR /opt/kafka
ADD server.properties /opt/kafka/server.properties
ADD kafka-config /opt/kafka/kafka-config
ADD kafka-init /opt/kafka/kafka-init

ENTRYPOINT ["/opt/kafka/kafka-init"]
CMD ["--help"]

EXPOSE 9092
