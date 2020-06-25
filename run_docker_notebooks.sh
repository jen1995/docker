#!/usr/bin/env bash

# Set these to get your notebooks running!
IMAGE_NAME="eelistr:0.0.1"
# COMMON_STORAGE=/mnt/meteo-storage/common
# DOCKER_JUPYTER_PORT=9001
# DOCKER_TENSORBOARD_PORT=9002
# WORKINGDIR=/mnt/meteo-storage/bebop

if [ -z ${DOCKER_JUPYTER_PORT+UNSET} ]; then
	echo "Please set DOCKER_JUPYTER_PORT"
	echo $DOCKER_JUPYTER_PORT
	exit 1;
else
	echo "Will use port $DOCKER_JUPYTER_PORT for jupyter notebooks served from docker";
fi

if [ -z ${DOCKER_TENSORBOARD_PORT+UNSET} ]; then
	echo "Please set DOCKER_TENSORBOARD_PORT"
	echo $DOCKER_TENSORBOARD_PORT
	exit 1;
else
	echo "Will use port $DOCKER_TENSORBOARD_PORT for tensorboard served from docker";
fi

if [ -z ${DOCKER_SSH_PORT+UNSET} ]; then
	echo "Please set DOCKER_SSH_PORT"
	echo $DOCKER_SSH_PORT
	exit 1;
else
	echo "Will use port $DOCKER_SSH_PORT for ssh served from docker";
fi

if [ -z ${WORKINGDIR+UNSET} ]; then
	echo "Please set WORKINGDIR variable"
	exit 1;
else
	echo "Will use $WORKINGDIR as docker /mnt";
fi

if [ ! -d "$WORKINGDIR/notebooks" ]; then
    echo "Creating notebooks in $WORKINGDIR/notebooks"
    mkdir -p "$WORKINGDIR/notebooks"
fi

COMMON_STORAGE=/mnt/meteo-storage/common
docker run --gpus=all -d -t -i \
	-e LOCAL_USER_ID=`id -u $USER` \
	-p $DOCKER_JUPYTER_PORT:8888 \
	-p $DOCKER_TENSORBOARD_PORT:6006 \
        -p $DOCKER_SSH_PORT:22 \
	-v $WORKINGDIR:/mnt \
	-v $COMMON_STORAGE:/mnt/common-storage \
	$IMAGE_NAME