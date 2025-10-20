FROM sglang:latest
LABEL maintainer="junpufan@gmail.com"


ARG CACHE_BUST_KEY=0
RUN sudo apt-get update \
 && sudo apt-get upgrade -y \
 && sudo apt-get autoremove -y \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*