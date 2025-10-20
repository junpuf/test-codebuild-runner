FROM lmsysorg/sglang:latest
LABEL maintainer="junpufan@gmail.com"


ARG CACHE_BUST_KEY=0
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*