FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libx11-dev \
    libxft-dev \
    libxext-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxrender-dev \
    libxfixes-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    pkg-config \
    libfltk1.3-dev \
    fluid \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY main.cpp CMakeLists.txt ./
RUN mkdir build && cd build && \
    cmake .. && \
    make
CMD ["./build/fltk_demo"]