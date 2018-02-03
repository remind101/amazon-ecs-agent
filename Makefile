.PHONY: build

REVISION=v1.16.2
BUILD_IMAGE=remind101/amazon-ecs-agent:${REVISION}
OFFICIAL_IMAGE=amazon/amazon-ecs-agent:${REVISION}

amazon-ecs-agent.tar.gz: amazon-ecs-agent
	tar -czvf $@ amazon-ecs-agent

amazon-ecs-agent: \
	amazon-ecs-agent/amazon-ecs-agent \
	amazon-ecs-agent/plugins \
	amazon-ecs-agent/images

amazon-ecs-agent/amazon-ecs-agent: build
	$(eval ID := $(shell docker create ${BUILD_IMAGE}))
	docker cp ${ID}:/out/amazon-ecs-agent $@
	docker rm ${ID}

amazon-ecs-agent/plugins:
	mkdir -p amazon-ecs-agent
	$(eval ID := $(shell docker create ${OFFICIAL_IMAGE}))
	docker cp ${ID}:/amazon-ecs-cni-plugins $@
	docker rm ${ID}

amazon-ecs-agent/images:
	mkdir -p amazon-ecs-agent
	$(eval ID := $(shell docker create ${OFFICIAL_IMAGE}))
	docker cp ${ID}:/images $@
	docker rm ${ID}

build:
	docker build --build-arg AMAZON_ECS_AGENT_REV=${REVISION} -t ${BUILD_IMAGE} .
