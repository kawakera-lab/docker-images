#!/bin/bash

# usage ----------------------------------------------
# bash docker.sh build  # build image
# bash docker.sh build:no-cache  # build image (no-cache)
# bash docker.sh shell  # run container as user
# bash docker.sh shell:root  # run container as root
# ----------------------------------------------------

DATASET_DIRS="$HOME/dataset"
DATA_DIRS="$HOME/data"

EXP_NAME="pip"
DOCKERFILE_NAME="Dockerfile.cu111"
TORCH_VERSION="torch-1.9.0"
# cu111 - torch-1.9.0
# cu117 - torch-1.13.0, torch-2.0.0

build()
{
    DOCKER_BUILDKIT=1 docker build . -f docker/$DOCKERFILE_NAME \
                                    --target $TORCH_VERSION \
                                    --build-arg USER_UID=`(id -u)` \
                                    --build-arg USER_GID=`(id -g)` \
                                    -t $TORCH_VERSION:$EXP_NAME
}

build:no-cache()
{
    DOCKER_BUILDKIT=1 docker build . -f docker/$DOCKERFILE_NAME \
                                    --no-cache \
                                    --target $TORCH_VERSION \
                                    --build-arg USER_UID=`(id -u)` \
                                    --build-arg USER_GID=`(id -g)` \
                                    -t $TORCH_VERSION:$EXP_NAME
}

shell()
{
    docker run --name $EXP_NAME \
                --rm -it \
                --gpus all \
                --shm-size=32g \
                -v $(pwd):/app \
                -v $DATASET_DIRS:/dataset \
                -v $DATA_DIRS:/data \
                $TORCH_VERSION:$EXP_NAME /bin/bash
}

shell:root()
{
    docker run --name $EXP_NAME \
                --user 0:0 \
                --rm -it \
                --gpus all \
                --shm-size=32g \
                -v $(pwd):/app \
                -v $DATASET_DIRS:/dataset \
                -v $DATA_DIRS:/data \
                $TORCH_VERSION:$EXP_NAME /bin/bash
}


exec()
{
  docker run --name $EXP_NAME-$(date +%Y%m%d-%H%M%S) \
                --rm -i \
                --gpus all \
                --shm-size=32g \
                -v $(pwd):/app \
                -v $DATASET_DIRS:/dataset \
                -v $DATA_DIRS:/data \
                $TORCH_VERSION:$EXP_NAME "/bin/bash" "-c" "$1"
}

help()
{
    echo "usage: bash docker.sh [build|build:no-cache|shell|shell:root|exec|help]"
}

if [[ $1 == "build" ]]; then
    build
elif [[ $1 == "build:no-cache" ]]; then
    build:no-cache
elif [[ $1 == "shell" ]]; then
    shell
elif [[ $1 == "shell:root" ]]; then
    shell:root
elif [[ $1 == "exec" ]]; then
    exec "$2"
elif [[ $1 == "help" ]]; then
    help
else
    help
fi
