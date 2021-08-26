FROM golang:bullseye

ARG DEBIAN_FRONTEND=noninteractive

ENV PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig/
ENV GOOS=linux
ENV GOARCH=arm64
ENV CC='aarch64-linux-gnu-gcc'

RUN apt-get update && apt-get install -y curl git pkg-config libc6-arm64-cross libc6-dev-arm64-cross binutils-aarch64-linux-gnu libncurses5-dev build-essential bison flex libssl-dev bc gcc-aarch64-linux-gnu
#RUN curl -sL http://ports.ubuntu.com/pool/main/libs/libseccomp/libseccomp-dev_2.5.1-1ubuntu1~20.04.1_arm64.deb -o libseccomp-dev_arm64.deb && dpkg --force-all -i libseccomp-dev_arm64.deb && rm -f libseccomp-dev_arm64.deb
RUN dpkg --add-architecture arm64 && apt-get update && apt-get install -y libseccomp-dev:arm64 libglib2.0-dev:arm64

RUN git clone https://github.com/risdenk/udm-podman
WORKDIR udm-podman
RUN git clone --depth 1 --single-branch --branch v3.3.0 https://github.com/containers/podman && patch -p1 podman/Makefile build/podman-Makefile.patch && make -C podman vendor local-cross && cp ./podman/bin/podman.cross.linux.arm64 /podman-arm64 && rm -rf podman
RUN git clone --depth 1 --single-branch --branch v1.0.2 https://github.com/opencontainers/runc && patch -p1 runc/Makefile build/runc-Makefile.patch && make -C runc vendor localcross && cp ./runc/runc-arm64 /runc-arm64 && rm -rf runc
RUN git clone --depth 1 --single-branch --branch v2.0.29 https://github.com/containers/conmon && make -C conmon vendor bin/conmon && cp ./conmon/bin/conmon /conmon-arm64 && rm -rf conmon

