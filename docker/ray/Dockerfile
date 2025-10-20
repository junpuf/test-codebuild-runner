FROM rayproject/ray:2.49.0-py311-gpu
LABEL maintainer="junpufan@gmail.com"
ENV DEBIAN_FRONTEND="noninteractive" \
    # Set LD_LIBRARY_PATH to include the directory with libpython3.10.so.1.0
    LD_LIBRARY_PATH=/home/ray/anaconda3/lib:$LD_LIBRARY_PATH

WORKDIR /home/ray

RUN pip install uv \
 && uv pip install --system \
    vllm[runai]==0.10.2 \
    huggingface_hub==0.34.0 \
    numpy==1.26.4 \
    transformers==4.55.2 \
 && uv clean \
 && pip cache purge \
 && rm -rf ~/.cache/uv

ARG CACHE_BUST_KEY=0
RUN sudo apt-get update \
 && sudo apt-get upgrade -y \
 && sudo apt-get autoremove -y \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*