.PHONY: build

REVISION=v1.14.3
IMAGE=remind101/amazone-ecs-agent:${REVISION}

build:
	docker build --build-arg AMAZON_ECS_AGENT_REV=${REVISION} -t ${IMAGE} .

bin/amazon-ecs-agent: build
	$(eval ID := $(shell docker create ${IMAGE}))
	docker cp ${ID}:/agent bin/amazon-ecs-agent
	docker rm ${ID}
