FROM jwiii/arm-java:8

MAINTAINER jw3

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
 	unzip wget curl jq coreutils nano ca-certificates iptables init-system-helpers libapparmor1 net-tools \
 && curl -o /tmp/docker.deb https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_1.12.2-0~jessie_armhf.deb \
 && dpkg -i /tmp/docker.deb \
 && apt-get clean \
 && rm -rf /tmp/* \
 && rm -rf /var/lib/apt/lists/*

ENV KAFKA_VERSION="0.10.0.1" SCALA_VERSION="2.11"
ADD download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
ADD create-topics.sh /usr/bin/create-topics.sh

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
