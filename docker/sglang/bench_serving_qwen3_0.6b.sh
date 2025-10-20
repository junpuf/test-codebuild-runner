#!/bin/bash
set -e
CONTAINER_NAME=sglang_test
IMAGE_URI="152553844057.dkr.ecr.us-west-2.amazonaws.com/sglang:latest"
HUGGING_FACE_HUB_TOKEN=$(aws secretsmanager get-secret-value --secret-id HUGGING_FACE_HUB_TOKEN --query SecretString --output text)
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 152553844057.dkr.ecr.us-west-2.amazonaws.com
docker pull ${IMAGE_URI}
docker run --name ${CONTAINER_NAME} \
    -d --gpus=all --entrypoint /bin/bash \
    -v ${HOME}/.cache/huggingface:/root/.cache/huggingface \
    -p 30000:30000 \
    -e "HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN}" \
    ${IMAGE_URI} \
    -c "python -m sglang.launch_server --model-path Qwen/Qwen3-0.6B --reasoning-parser qwen3"
sleep 60
set -x
docker logs ${CONTAINER_NAME}
docker exec ${CONTAINER_NAME} python3 -m sglang.bench_serving \
    --backend sglang \
  	--host 127.0.0.1 --port 30000 \
  	--num-prompts 1000 \
  	--model Qwen/Qwen3-0.6B
docker stop ${CONTAINER_NAME}
docker rm -f ${CONTAINER_NAME}