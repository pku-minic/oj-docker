FROM debian:buster-slim

ARG MINIVM_REPO_URL=https://github.com/pku-minic/MiniVM.git
ARG MINIVM_REPO_PATH=/root/MiniVM
ARG SYSYRT_REPO_URL=https://github.com/pku-minic/sysy-runtime-lib.git
ARG SYSYRT_REPO_PATH=/root/sysy-runtime-lib
ARG RISCV32_PATH=/opt/riscv

# change APT sources
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian buster-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list

# install dependencies
RUN apt-get update && apt-get install -y \
    build-essential git flex bison libreadline-dev python3 cmake qemu-user-static curl

# install Rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    mkdir -p ~/.cargo && \
    echo "[source.crates-io]" > ~/.cargo/config && \
    echo "replace-with = 'tuna'" >> ~/.cargo/config && \
    echo "[source.tuna]" >> ~/.cargo/config && \
    echo "registry = \"https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git\"" >> ~/.cargo/config
ENV RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
ENV RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
ENV PATH=/root/.cargo/bin:$PATH

# set GitHub proxy
RUN git config --global url."https://hub.fastgit.org/".insteadOf "https://github.com/" && \
    git config --global protocol.https.allow always

# pull & compile MiniVM
RUN git clone --recursive --shallow-submodules --single-branch --depth 1 \
    ${MINIVM_REPO_URL} ${MINIVM_REPO_PATH}
WORKDIR ${MINIVM_REPO_PATH}/build
RUN cmake .. && make -j`nproc`
ENV PATH=${MINIVM_REPO_PATH}/build:$PATH

# pull SysY runtime library
RUN git clone --recursive --shallow-submodules --single-branch --depth 1 \
    ${SYSYRT_REPO_URL} ${SYSYRT_REPO_PATH}

# copy 32-bit RISC-V GNU toolchain from 'riscv32-toolchain'
COPY --from=maxxing/riscv32-toolchain ${RISCV32_PATH} ${RISCV32_PATH}
ENV RISCV=${RISCV32_PATH}
ENV PATH=$RISCV/bin:$PATH

WORKDIR /root
