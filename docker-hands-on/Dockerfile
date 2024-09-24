FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04 as base

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y software-properties-common

RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y \
    wget \
    bzip2 \
    build-essential \
    unzip \
    git \
    git-lfs \
    curl \
    ca-certificates \
    libsndfile1-dev \
    libgl1 \
    python3.9 \
    python3.9-distutils \
    python3-pip

# 必要に応じてpipをインストール
RUN apt-get install -y curl && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 && \
    update-alternatives --set python3 /usr/bin/python3.9 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 && \
    update-alternatives --set python /usr/bin/python3.9

COPY requirements.txt .

RUN pip install --upgrade "pip<24.1" && \
    pip install -r requirements.txt

ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} itoru && \
    useradd -u ${USER_ID} -g itoru -m -s /bin/bash itoru

USER itoru

CMD ["/bin/bash"]
