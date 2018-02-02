.PHONY: build

REVISION=v1.16.2
IMAGE=remind101/amazon-ecs-agent:${REVISION}

amazon-ecs-agent.tar.gz: amazon-ecs-agent
	tar -czvf $@ amazon-ecs-agent

build:
	docker build --build-arg AMAZON_ECS_AGENT_REV=${REVISION} -t ${IMAGE} .

amazon-ecs-agent: build
	$(eval ID := $(shell docker create ${IMAGE}))
	docker cp ${ID}:/out amazon-ecs-agent
	docker rm ${ID}
