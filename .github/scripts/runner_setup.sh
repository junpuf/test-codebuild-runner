#!/bin/bash
set -e

curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR="/usr/local/bin" sh
uv self update
uv venv build --python 3.11
uv venv test --python 3.11
uv venv release --python 3.11
docker --version