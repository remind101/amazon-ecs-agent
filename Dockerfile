FROM golang:1.15.4
MAINTAINER Remind Inc

RUN apt-get update && apt-get install -y patch

# A git tag to apply the patches to.
ARG AMAZON_ECS_AGENT_REV

# make sure we pass the build flags from the Makefile.
ARG LDFLAGS

RUN mkdir -p /go/src/github.com/aws/
RUN cd /go/src/github.com/aws/ && \
      git clone \
		--recursive \
		--depth 1 \
		--branch "$AMAZON_ECS_AGENT_REV" \
		git://github.com/aws/amazon-ecs-agent.git

WORKDIR /go/src/github.com/aws/amazon-ecs-agent

COPY patches ./patches
RUN for patch in patches/*; do patch -p1 < $patch; done
RUN mkdir /out
RUN ./scripts/build true /out/amazon-ecs-agent
