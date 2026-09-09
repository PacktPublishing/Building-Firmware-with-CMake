FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

ARG TARGETARCH

ARG CMAKE_VERSION=3.31.11
ARG ARM_GNU_VERSION=14.3.rel1
ARG RENODE_VERSION=1.16.1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ninja-build \
    make \
    git \
    python3 \
    python3-pip \
    python3-venv \
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
        amd64) CMAKE_ARCH=x86_64 ;; \
        arm64) CMAKE_ARCH=aarch64 ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    CMAKE_ARCHIVE="cmake-${CMAKE_VERSION}-linux-${CMAKE_ARCH}.tar.gz"; \
    mkdir -p /opt/cmake && \
    wget -qO /tmp/${CMAKE_ARCHIVE} "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_ARCHIVE}" && \
    tar -xzf /tmp/${CMAKE_ARCHIVE} -C /opt/cmake --strip-components=1 && \
    rm -f /tmp/${CMAKE_ARCHIVE}

RUN set -eux; \
    case "${TARGETARCH}" in \
        amd64) HOST_ARCH=x86_64 ;; \
        arm64) HOST_ARCH=aarch64 ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    ARM_GNU_ARCHIVE="arm-gnu-toolchain-${ARM_GNU_VERSION}-${HOST_ARCH}-arm-none-eabi.tar.xz"; \
    mkdir -p /opt/arm-gnu-toolchain && \
    wget -qO /tmp/${ARM_GNU_ARCHIVE} "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_GNU_VERSION}/binrel/${ARM_GNU_ARCHIVE}" && \
    tar -xJf /tmp/${ARM_GNU_ARCHIVE} -C /opt/arm-gnu-toolchain --strip-components=1 && \
    rm -f /tmp/${ARM_GNU_ARCHIVE}

RUN set -eux; \
    case "${TARGETARCH}" in \
        amd64) RENODE_ARCHIVE="renode-${RENODE_VERSION}.linux-portable.tar.gz" ;; \
        arm64) RENODE_ARCHIVE="renode-${RENODE_VERSION}.linux-arm64-portable-dotnet.tar.gz" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    mkdir -p /opt/renode && \
    wget -qO /tmp/${RENODE_ARCHIVE} "https://github.com/renode/renode/releases/download/v${RENODE_VERSION}/${RENODE_ARCHIVE}" && \
    tar -xzf /tmp/${RENODE_ARCHIVE} -C /opt/renode --strip-components=1 && \
    rm -f /tmp/${RENODE_ARCHIVE}

ENV PATH="/opt/cmake/bin:/opt/arm-gnu-toolchain/bin:/opt/renode:${PATH}"

WORKDIR /workspace

CMD ["sleep", "infinity"]
