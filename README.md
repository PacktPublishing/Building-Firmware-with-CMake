# Building-Firmware-with-CMake

This repository contains the code examples for **Building Firmware with CMake: A Practical Guide to Automating Embedded Builds, Tests, and Release Artifacts**, published by Packt.

The book is aimed at embedded developers who want to replace ad-hoc and IDE-generated builds with modern, target-based CMake. It covers cross-compilation, code generation, host-based and on-target testing, presets, pinned toolchains, multi-MCU builds, and release packaging, using STM32 microcontrollers as the running example.

All examples run in [Renode](https://renode.io/), so no physical hardware is required.

- [Amazon](https://www.amazon.com/Building-Firmware-CMake-practical-automating-ebook/dp/B0HGB2YRW3)
- [Packt](https://www.packtpub.com/en-br/product/building-firmware-with-cmake-9781807307431)

## Development environment

The repository ships a `Dockerfile` and a Dev Container configuration. The image is based on Ubuntu 24.04 and includes:

- CMake 3.31.11
- Arm GNU Toolchain 14.3.rel1 (`arm-none-eabi`)
- Renode 1.16.1
- Ninja, GCC, gcovr, protobuf-compiler, and Python 3

Both x86_64 and aarch64 hosts are supported.

### VS Code Dev Container

1. Install [Docker](https://docs.docker.com/get-docker/) and the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.
2. Clone the repository and open it in VS Code.
3. Run **Dev Containers: Reopen in Container**.

The repository is mounted at `/workspace`.

## Chapters

| Chapter | Topics |
|---|---|
| [Chapter 1](Chapter01) | A First Build with CMake in Docker |
| [Chapter 2](Chapter02) | Build and run Hello World on STM32 target in Renode simulator |
| [Chapter 3](Chapter03) | Your first CMake library |
| [Chapter 4](Chapter04) | Working with third-party CMake enabled projects (nanopb) |
| [Chapter 5](Chapter05) | Host-to-Firmware Data Contract with Protocol Buffers |
| [Chapter 6](Chapter06) | Running End-to-End Firmware Tests in Renode with CppUTest and CTest |
| [Chapter 7](Chapter07) | CMake Presets for Host and Target Builds |
| [Chapter 8](Chapter08) | Pinned Toolchains and Reproducible Builds |
| [Chapter 9](Chapter09) | Building Firmware for Multiple MCUs |
| [Chapter 10](Chapter10) | Wrap-up: Project Structure and Workflows |

## Shared components

| Directory | Description |
|---|---|
| [STM32F0xx_HAL](STM32F0xx_HAL) | STM32F0 HAL as an in-tree CMake library |
| [STM32F0xx_HAL_Fetched](STM32F0xx_HAL_Fetched) | STM32F0 HAL consumed with FetchContent |
| [STM32F0xx_HAL_Fetched_Toolchain](STM32F0xx_HAL_Fetched_Toolchain) | STM32F0 HAL with architecture flags moved to the toolchain file |
| [STM32F4xx_HAL_Fetched_Toolchain](STM32F4xx_HAL_Fetched_Toolchain) | STM32F4 HAL for the multi-MCU examples |
| [nanopb](nanopb) | nanopb fetched at a pinned commit, with code generation support |
| [CppUTest](CppUTest) | CppUTest configured for host and bare-metal targets |