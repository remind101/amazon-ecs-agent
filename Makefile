.PHONY: build test pull

REVISION=v1.50.2
BUILD_IMAGE=remind101/amazon-ecs-agent:${REVISION}
OFFICIAL_IMAGE=amazon/amazon-ecs-agent:${REVISION}

PAUSE_CONTAINER_TAG=0.1.0
PAUSE_CONTAINER_IMAGE=amazon/amazon-ecs-pause

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
amazon-ecs-agent/plugins: pull
	mkdir -p amazon-ecs-agent
	$(eval ID := $(shell docker create ${OFFICIAL_IMAGE}))
	docker cp ${ID}:/amazon-ecs-cni-plugins/. $@
	docker rm ${ID}

# Copies the amazon-ecs-pause container image from the official Docker image.
amazon-ecs-agent/images: pull
	mkdir -p amazon-ecs-agent
	$(eval ID := $(shell docker create ${OFFICIAL_IMAGE}))
	docker cp ${ID}:/images/. $@
	docker rm ${ID}

pull:
	docker pull "${OFFICIAL_IMAGE}"

# Builds the ECS agent binary.
build:
	docker build \
		--pull \
		--build-arg "AMAZON_ECS_AGENT_REV=${REVISION}" \
		--build-arg "LDFLAGS=-X github.com/aws/amazon-ecs-agent/agent/config.DefaultPauseContainerTag=${PAUSE_CONTAINER_TAG} \
			-X github.com/aws/amazon-ecs-agent/agent/config.DefaultPauseContainerImageName=${PAUSE_CONTAINER_IMAGE}" \
		-t "${BUILD_IMAGE}" .

test: build
	docker run -it --rm \
		--net=none --privileged \
		"${BUILD_IMAGE}" \
		make test-silent

clean:
	rm -rf amazon-ecs-agent
