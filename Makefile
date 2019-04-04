.PHONY: build

REVISION=v1.26.1
BUILD_IMAGE=remind101/amazon-ecs-agent:${REVISION}
OFFICIAL_IMAGE=amazon/amazon-ecs-agent:${REVISION}

amazon-ecs-agent.tar.gz: amazon-ecs-agent
	tar -czvf $@ amazon-ecs-agent

amazon-ecs-agent: \
	amazon-ecs-agent/amazon-ecs-agent \
	amazon-ecs-agent/plugins \
	amazon-ecs-agent/images

# Copies the statically linked ECS agent built below.
amazon-ecs-agent/amazon-ecs-agent: build
	mkdir -p amazon-ecs-agent
	$(eval ID := $(shell docker create ${BUILD_IMAGE}))
	docker cp ${ID}:/out/amazon-ecs-agent $@
	docker rm ${ID}

# Copies the CNI plugins from the official Docker image.
amazon-ecs-agent/plugins: FORCE
	mkdir -p amazon-ecs-agent
	$(eval ID := $(shell docker create ${OFFICIAL_IMAGE}))
	docker cp ${ID}:/amazon-ecs-cni-plugins $@
	docker rm ${ID}

# Copies the amazon-ecs-pause container image from the official Docker image.
amazon-ecs-agent/images: FORCE
	mkdir -p amazon-ecs-agent
	$(eval ID := $(shell docker create ${OFFICIAL_IMAGE}))
	docker cp ${ID}:/images $@
	docker rm ${ID}

# Builds the ECS agent binary.
build:
	docker pull ${OFFICIAL_IMAGE}
	docker build --build-arg AMAZON_ECS_AGENT_REV=${REVISION} -t ${BUILD_IMAGE} .

clean:
	rm -rf amazon-ecs-agent

FORCE:
