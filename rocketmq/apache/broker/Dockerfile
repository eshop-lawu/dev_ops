FROM registry.eshop.com/incubator-rocketmq:4.1.0-incubating

ENV ROCKETMQ_HOME /opt/rocketmq

WORKDIR $ROCKETMQ_HOME

COPY runbroker.sh bin

ENTRYPOINT bin/mqbroker -c broker.p