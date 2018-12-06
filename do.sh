#!/usr/bin/env bash

# Output colors
NORMAL="\\033[0;39m"
RED="\\033[1;31m"
BLUE="\\033[1;34m"

# Names to identify IMAGE_NAMEs and containers of this app
IMAGE_NAME=myjenkins
CONTAINER_NAME=jenkins

# Usefull to run commands as non-root user inside containers
USER="jenkins"
HOMEDIR="/home/$USER"
EXECUTE_AS="sudo -u jenkins HOME=$HOME_DIR"


# Logging
log() {
	echo -e "$BLUE > $1 $NORMAL"
}

log_error() {
	echo ""
	echo -e "$RED >>> ERROR - $1$NORMAL"
}

# IMAGE_NAME/container management
bash() {
	log "BASH"
	docker exec -it $CONTAINER_NAME /bin/bash
}

stop() {
	docker stop $CONTAINER_NAME
}

start() {
	docker start $CONTAINER_NAME
}

remove() {
	log "Removing previous container $CONTAINER_NAME" && \
			docker rm -f $CONTAINER_NAME &> /dev/null || true
}

show_log() {
	docker logs $CONTAINER_NAME
}

# Build/run container
build() {
	docker build \
		-t \
		$IMAGE_NAME \
		.
}
run() {
	docker run \
		-d \
		--name=$CONTAINER_NAME \
		-p 8080:8080 \
		-p 50000:50000 \
		$IMAGE_NAME
	ps -a
	[ $? != 0 ] && \
		log_error "Docker $IMAGE_NAME build failed !" && exit 100
}

# Help
help() {
	echo "-----------------------------------------------------------------------"
	echo "                      Available commands                              -"
	echo "-----------------------------------------------------------------------"
	echo -e -n "$BLUE"
	echo "	 > run - To run a new instance of $IMAGE_NAME"
	echo "	 > bash - Log you into container $CONTAINER_NAME"
	echo "	 > stop - To stop $CONTAINER_NAME container"
	echo "	 > start - To start $CONTAINER_NAME container"
	echo "	 > remove - Remove $CONTAINER_NAME container"
	echo "	 > help - Display this help"
	echo -e -n "$NORMAL"
	echo "-----------------------------------------------------------------------"
}

$*
