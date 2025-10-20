#!/bin/bash

set -e
CONTAINER_NAME=sglang_test
HUGGING_FACE_HUB_TOKEN=$(aws secretsmanager get-secret-value --secret-id HUGGING_FACE_HUB_TOKEN --query SecretString --output text)

docker run --name ${CONTAINER_NAME} \
    -d --gpus=all --entrypoint /bin/bash \
    -v ${HOME}/.cache/huggingface:/root/.cache/huggingface \
    -e "HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN}" \
    152553844057.dkr.ecr.us-west-2.amazonaws.com/sglang:latest \
    -c "python -m sglang.launch_server --model-path Qwen/Qwen3-0.6B --reasoning-parser qwen3"

sleep 60

docker stop ${CONTAINER_NAME}
docker rm ${CONTAINER_NAME}

# docker kill $(docker ps -q) || true
# docker rm -f $(docker ps -a -q)