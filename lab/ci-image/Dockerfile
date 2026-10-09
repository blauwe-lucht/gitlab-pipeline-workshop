FROM ubuntu:noble-20260911

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        ccache \
        clang \
        clang-format \
        clang-tidy \
        cmake \
        git \
        ninja-build \
        pipx \
    && rm -rf /var/lib/apt/lists/*

ENV PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/usr/local/bin
# pipx's shared pip is only needed to install; its bundled libraries trigger scanner findings.
RUN pipx install conan==2.33.0 \
    && rm -rf /opt/pipx/shared \
    && conan profile detect
