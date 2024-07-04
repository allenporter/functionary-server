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
        clinfo \
        && \
    rm -rf /var/lib/apt/lists/*

# ocl-icd-opencl-dev \
# opencl-headers \
# clinfo \
# libclblast-dev \
# libopenblas-dev \

RUN echo "Listing 100 largest packages"
RUN dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -n 100
RUN df -h

# Clone repo
ARG FUNCTIONARY_REPO="MeetKai/functionary"
ARG FUNCTIONARY_VERSION="main"
WORKDIR /workspace
RUN git clone -b $FUNCTIONARY_VERSION https://github.com/$FUNCTIONARY_REPO functionary

WORKDIR /workspace/functionary

# Install requirements
RUN pip3 install -r ./requirements.txt

# Run server
EXPOSE ${PORT}
ENTRYPOINT [ "python3", "-m", "server_vllm.py" ]
