FROM nvidia/cuda:12.6.3-devel-ubuntu24.04

WORKDIR /root 

# RUN apt update && apt install -y wget
# RUN wget https://repo.radeon.com/amdgpu-install/6.4.1/ubuntu/noble/amdgpu-install_6.4.60401-1_all.deb
# RUN apt install -y ./amdgpu-install_6.4.60401-1_all.deb
# RUN apt update && apt install -y python3-setuptools python3-wheel && \
#     rm -rf /var/lib/apt/lists/*
# RUN usermod -a -G render,video
# RUN apt update && apt install -y rocm libdrm-dev && \
#     rm -rf /var/lib/apt/lists/*

# Install llvm build dependencies.
RUN apt update && \
     apt install -y --no-install-recommends ca-certificates cmake 2to3 python-is-python3 \
         subversion ninja-build python3-yaml git && \
     rm -rf /var/lib/apt/lists/*

ADD https://github.com/llvm/llvm-project.git /llvm-project

RUN mkdir /llvm-project/build

WORKDIR /llvm-project/build

RUN cmake ../llvm -G Ninja                  \
   -C ../offload/cmake/caches/Offload.cmake \
   -DCMAKE_BUILD_TYPE=Release               \
   -DCMAKE_INSTALL_PREFIX=/usr/local/llvm   \
   -DLLVM_TARGETS_TO_BUILD="X86;AMDGPU;NVPTX"

RUN ninja install

ENV PATH="$PATH:/usr/local/llvm/bin"
