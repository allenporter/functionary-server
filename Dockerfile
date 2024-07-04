FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        python3 \
        python3-pip \
        build-essential \
        git \
        && \
    python3 -m pip install --upgrade pip

# Accellerator specific dependencies
RUN apt-get install -y \
        ocl-icd-opencl-dev \
        opencl-headers \
        clinfo \
        libclblast-dev \
        libopenblas-dev \
        && \
    rm -rf /var/lib/apt/lists/*

# Clone repo
ARG FUNCTIONARY_REPO="MeetKai/functionary"
ARG FUNCTIONARY_VERSION="main"
WORKDIR /workspace
RUN git clone -b $FUNCTIONARY_VERSION https://github.com/$FUNCTIONARY_REPO .

# Install requirements
ENV SRC_DIR=/workspace/$FUNCTIONARY_REPO
RUN pip3 install -r $SRC_DIR/requirements.txt

# Run server
WORKDIR $SRC_DIR
EXPOSE ${PORT}
ENTRYPOINT [ "python3", "-m", "server_vllm.py" ]
