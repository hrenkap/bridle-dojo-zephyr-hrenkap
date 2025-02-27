FROM ubuntu:24.04 AS base
ARG TARGETPLATFORM
ARG ZEPHYR_SDK_VERSION="0.16.9"

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    git cmake ninja-build gperf ccache dfu-util \
    device-tree-compiler wget python3-dev python3-pip \
    python3-setuptools python3-tk python3-wheel \
    xz-utils file make gcc \
    libsdl2-dev libmagic1 vim htop


# arm64-specific stage
FROM base AS build-arm64
RUN echo "This stage is used on arm64"
ARG ZEPHYR_SDK_VERSION

RUN cd /opt && \
    export ZEPHYR_SDK_ARCH="aarch64" && \
    export ZEPHYR_SDK_TARBALL="zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-${ZEPHYR_SDK_ARCH}_minimal.tar.xz" && \
    echo "Downloading ${ZEPHYR_SDK_TARBALL}" && \
    wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/${ZEPHYR_SDK_TARBALL} && \
    tar xvf ${ZEPHYR_SDK_TARBALL} && \
    rm ${ZEPHYR_SDK_TARBALL}

# x86_64-specific stage
FROM base AS build-amd64
RUN echo "This stage is used on x86_64"
ARG ZEPHYR_SDK_VERSION

RUN apt install -y --no-install-recommends gcc-multilib g++-multilib
RUN cd /opt && \
    export ZEPHYR_SDK_ARCH="x86_64" && \
    export ZEPHYR_SDK_TARBALL="zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-${ZEPHYR_SDK_ARCH}_minimal.tar.xz" && \
    echo "Downloading ${ZEPHYR_SDK_TARBALL}" && \
    wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/${ZEPHYR_SDK_TARBALL} && \
    tar xvf ${ZEPHYR_SDK_TARBALL} && \
    rm ${ZEPHYR_SDK_TARBALL}


FROM build-${TARGETARCH} AS build

RUN cd /opt/zephyr-sdk-0.16.9 && \
    ./setup.sh -t arm-zephyr-eabi && \
    ./setup.sh -t x86_64-zephyr-elf && \
    ./setup.sh -h -c


ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN useradd -m ubuntu

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
RUN apt install -y --no-install-recommends python3-venv
USER $USERNAME

RUN mkdir /home/ubuntu/ws

# Launch bash shell by default
CMD ["/bin/bash"]


