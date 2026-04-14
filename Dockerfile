FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

ARG CMAKE_VERSION=3.31.11
ARG CMAKE_ARCHIVE=cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_ARCHIVE}

ARG ARM_GNU_VERSION=14.3.rel1
ARG ARM_GNU_ARCHIVE=arm-gnu-toolchain-${ARM_GNU_VERSION}-x86_64-arm-none-eabi.tar.xz
ARG ARM_GNU_URL=https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_GNU_VERSION}/binrel/${ARM_GNU_ARCHIVE}

ARG RENODE_VERSION=1.16.1
ARG RENODE_ARCHIVE=renode-${RENODE_VERSION}.linux-portable.tar.gz
ARG RENODE_URL=https://github.com/renode/renode/releases/download/v${RENODE_VERSION}/${RENODE_ARCHIVE}

ARG USERNAME=constexpr

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
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/cmake && \
    wget -qO /tmp/${CMAKE_ARCHIVE} "${CMAKE_URL}" && \
    tar -xzf /tmp/${CMAKE_ARCHIVE} -C /opt/cmake --strip-components=1 && \
    rm -f /tmp/${CMAKE_ARCHIVE}

RUN mkdir -p /opt/arm-gnu-toolchain && \
    wget -qO /tmp/${ARM_GNU_ARCHIVE} "${ARM_GNU_URL}" && \
    tar -xJf /tmp/${ARM_GNU_ARCHIVE} -C /opt/arm-gnu-toolchain --strip-components=1 && \
    rm -f /tmp/${ARM_GNU_ARCHIVE}

RUN mkdir -p /opt/renode && \
    wget -qO /tmp/${RENODE_ARCHIVE} "${RENODE_URL}" && \
    tar -xzf /tmp/${RENODE_ARCHIVE} -C /opt/renode --strip-components=1 && \
    rm -f /tmp/${RENODE_ARCHIVE}

ENV PATH="/opt/cmake/bin:/opt/arm-gnu-toolchain/bin:/opt/renode:${PATH}"

RUN if ! id -u ${USERNAME} >/dev/null 2>&1; then \
        useradd -m -s /bin/bash ${USERNAME}; \
    fi && \
    mkdir -p /workspace && \
    chown -R ${USERNAME}:${USERNAME} /workspace

WORKDIR /workspace
USER ${USERNAME}

CMD ["sleep", "infinity"]