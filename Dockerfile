FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

ARG TARGETARCH

ARG CMAKE_VERSION=3.31.11
ARG ARM_GNU_VERSION=14.3.rel1
ARG RENODE_VERSION=1.16.1+20260904git63d4e2dd5

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ninja-build \
    make \
    gcovr \
    git \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    gdb \
    wget \
    curl \
    ca-certificates \
    xz-utils \
    pkg-config \
    file \
    zip \
    unzip \
    libncursesw6 \
    libreadline8 \
    libicu74 \
    libssl3 \
    libatomic1 \
    libc6 \
    libgtk2.0-0 \
    screen \
    policykit-1 \
    uml-utilities \
    protobuf-compiler \
    python3-protobuf \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    case "${TARGETARCH}" in \
    amd64) ARCH=x86_64; RENODE_SUFFIX="" ;; \
    arm64) ARCH=aarch64; RENODE_SUFFIX="-arm64" ;; \
    *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    CMAKE_ARCHIVE="cmake-${CMAKE_VERSION}-linux-${ARCH}.tar.gz"; \
    ARM_GNU_ARCHIVE="arm-gnu-toolchain-${ARM_GNU_VERSION}-${ARCH}-arm-none-eabi.tar.xz"; \
    RENODE_ARCHIVE="renode-${RENODE_VERSION}.linux${RENODE_SUFFIX}-portable.tar.gz"; \
    { \
    echo "export CMAKE_ARCHIVE=${CMAKE_ARCHIVE}"; \
    echo "export CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_ARCHIVE}"; \
    echo "export ARM_GNU_ARCHIVE=${ARM_GNU_ARCHIVE}"; \
    echo "export ARM_GNU_URL=https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_GNU_VERSION}/binrel/${ARM_GNU_ARCHIVE}"; \
    echo "export RENODE_ARCHIVE=${RENODE_ARCHIVE}"; \
    echo "export RENODE_URL=https://builds.renode.io/${RENODE_ARCHIVE}"; \
    } > /etc/build-arch.env

RUN . /etc/build-arch.env && \
    mkdir -p /opt/cmake && \
    wget -qO /tmp/${CMAKE_ARCHIVE} "${CMAKE_URL}" && \
    tar -xzf /tmp/${CMAKE_ARCHIVE} -C /opt/cmake --strip-components=1 && \
    rm -f /tmp/${CMAKE_ARCHIVE}

RUN . /etc/build-arch.env && \
    mkdir -p /opt/arm-gnu-toolchain && \
    wget -qO /tmp/${ARM_GNU_ARCHIVE} "${ARM_GNU_URL}" && \
    tar -xJf /tmp/${ARM_GNU_ARCHIVE} -C /opt/arm-gnu-toolchain --strip-components=1 && \
    rm -f /tmp/${ARM_GNU_ARCHIVE}

RUN . /etc/build-arch.env && \
    mkdir -p /opt/renode && \
    wget -qO /tmp/${RENODE_ARCHIVE} "${RENODE_URL}" && \
    tar -xzf /tmp/${RENODE_ARCHIVE} -C /opt/renode --strip-components=1 && \
    rm -f /tmp/${RENODE_ARCHIVE}

RUN python3 -m pip install \
    --no-cache-dir \
    --break-system-packages \
    -r /opt/renode/tests/requirements.txt

ENV PATH="/opt/cmake/bin:/opt/arm-gnu-toolchain/bin:/opt/renode:${PATH}"

WORKDIR /workspace

CMD ["sleep", "infinity"]
