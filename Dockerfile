FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl git pkg-config libc6-arm64-cross libc6-dev-arm64-cross binutils-aarch64-linux-gnu libncurses5-dev build-essential bison flex libssl-dev bc gcc-aarch64-linux-gnu
RUN curl -sL http://ports.ubuntu.com/pool/main/libs/libseccomp/libseccomp-dev_2.5.1-1ubuntu1~20.04.1_arm64.deb -o libseccomp-dev_arm64.deb && dpkg --force-all -i libseccomp-dev_arm64.deb && rm -f libseccomp-dev_arm64.deb
RUN curl -sL https://golang.org/dl/go1.16.5.linux-amd64.tar.gz -o go-amd64.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf go-amd64.tar.gz && rm -f go-amd64.tar.gz
ENV PATH="${PATH}:/usr/local/go/bin"
RUN git clone https://github.com/risdenk/udm-podman
WORKDIR udm-podman
RUN git clone https://github.com/containers/podman
RUN patch -p1 podman/Makefile build/Makefile.patch
RUN make -C podman CC='aarch64-linux-gnu-gcc' GOOS=linux GOARCH=arm PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig/ local-cross

