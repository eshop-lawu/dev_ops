#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Start from a Java image.
FROM java:8

# Rocketmq version
ENV ROCKETMQ_VERSION 4.1.0-incubating

# Rocketmq home
ENV ROCKETMQ_HOME  /opt/rocketmq

ENV JAVA_OPT=" -Duser.home=/opt"

WORKDIR  ${ROCKETMQ_HOME}

RUN mkdir -p \
        /opt/logs \
        /opt/store

#online
ADD http://mirror.bit.edu.cn/apache/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip .

#offline
#COPY rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip .

RUN unzip rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip \
          && mv rocketmq-all-${ROCKETMQ_VERSION}/* . \
          && rmdir rocketmq-all-${ROCKETMQ_VERSION}  \
          && rm rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip


RUN cd bin && chmod +x mqadmin mqbroker mqfiltersrv mqnamesrv mqshutdown