FROM golang:1.7
MAINTAINER Remind Inc

RUN apt-get update && apt-get install -y patch

# A git tag to apply the patches to.
ARG AMAZON_ECS_AGENT_REV

RUN mkdir -p /go/src/github.com/aws/
RUN cd /go/src/github.com/aws/ && \
      git clone git://github.com/aws/amazon-ecs-agent.git && \
      cd amazon-ecs-agent && \
      git checkout $AMAZON_ECS_AGENT_REV
RUN cd /go/src/github.com/aws/amazon-ecs-agent && \
      git submodule update --init --checkout && \
      mv /go/src/github.com/aws/amazon-ecs-agent/amazon-ecs-cni-plugins /go/src/github.com/aws/amazon-ecs-cni-plugins

WORKDIR /go/src/github.com/aws/amazon-ecs-agent

COPY patches ./patches
RUN for patch in patches/*; do patch -p1 < $patch; done
RUN mkdir /out
RUN ./scripts/build true /out/amazon-ecs-agent
