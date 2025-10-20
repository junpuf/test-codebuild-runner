#!/bin/bash

set -ex
CONTAINER_NAME=sglang_test
HUGGING_FACE_HUB_TOKEN=$(aws secretsmanager get-secret-value --secret-id HUGGING_FACE_HUB_TOKEN --query SecretString --output text)

docker run --name ${CONTAINER_NAME} \
    -d --gpus=all --entrypoint /bin/bash \
    -v ${HOME}/.cache/huggingface:/root/.cache/huggingface \
    -e "HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN}" \
    152553844057.dkr.ecr.us-west-2.amazonaws.com/sglang:latest \
    -c "python -m sglang.launch_server --model-path Qwen/Qwen3-0.6B --reasoning-parser qwen3"

sleep 60
docker logs ${CONTAINER_NAME}
docker exec ${CONTAINER_NAME} python3 -m sglang.bench_serving \
    --backend sglang \
  	--host 127.0.0.1 --port 30000 \
  	--num-prompts 1000 \
  	--model Qwen/Qwen3-0.6B
docker logs ${CONTAINER_NAME}
docker stop ${CONTAINER_NAME}
docker rm -f ${CONTAINER_NAME}