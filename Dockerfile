FROM golang:1.7
MAINTAINER Remind Inc

# A git tag to apply the patches to.
ARG AMAZON_ECS_AGENT_REV

RUN mkdir -p /go/src/github.com/aws/
RUN cd /go/src/github.com/aws/ && \
      git clone git://github.com/aws/amazon-ecs-agent.git && \
      cd amazon-ecs-agent && \
      git checkout $AMAZON_ECS_AGENT_REV

WORKDIR /go/src/github.com/aws/amazon-ecs-agent

RUN apt-get update && apt-get install -y patch
COPY patches ./patches
RUN for patch in patches/*; do patch -p1 < $patch; done
RUN ./scripts/build true /agent

EXPOSE 51678 51679
ENTRYPOINT ["/agent"]
