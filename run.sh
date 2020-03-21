#!/usr/bin/env bash

set -euo pipefail

cd $(dirname $0)

SOURCE=$(pwd)/android
CCACHE=$(pwd)/ccache
CONTAINER=lineageos
REPOSITORY=peque/lineageos
TAG=build

# Build
podman build -t $REPOSITORY:$TAG .

# Create shared folders
mkdir -p $SOURCE
mkdir -p $CCACHE

# With the given name $CONTAINER, reconnect to running container, start
# an existing/stopped container or run a new one if one does not exist.
IS_RUNNING=$(podman inspect -f '{{.State.Running}}' $CONTAINER 2>/dev/null) || true
if [[ $IS_RUNNING == "true" ]]; then
	podman attach $CONTAINER
elif [[ $IS_RUNNING == "false" ]]; then
	podman start -i $CONTAINER
else
	podman run \
	  --privileged \
	  --name $CONTAINER \
	  --hostname $CONTAINER \
	  --interactive \
	  --security-opt label=disable \
	  --security-opt apparmor=unconfined \
	  --security-opt seccomp=unconfined \
	  --tty \
	  -d \
	  --mount=type=bind,src=/sys/fs/selinux,dst=/sys/fs/selinux,ro \
	  --volume /media:/media:rslave \
	  --volume /mnt:/mnt:rslave \
	  --volume /run/media:/run/media:rslave \
	  --volume $SOURCE:/home/build/android:Z \
	  --volume $CCACHE:/srv/ccache:Z \
	  $REPOSITORY:$TAG
fi

exit $?
