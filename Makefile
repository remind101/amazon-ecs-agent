.PHONY: build

REVISION=v1.14.0

build:
	docker build --build-arg AMAZON_ECS_AGENT_REV=${REVISION} -t remind101/amazon-ecs-agent:${REVISION} .
