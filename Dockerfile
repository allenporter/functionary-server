FROM nvcr.io/nvidia/pytorch:24.06-py3

RUN apk add --no-cache git go

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
