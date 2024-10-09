# 1. ベースとなるimage（docker hubで公開されている）
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04 as base

# 2. ARGでホストからUSER_IDとGROUP_IDを受け取れるようにする
ARG USER_ID
ARG GROUP_ID

# USER_IDとGROUP_IDが渡されなかった場合にエラーを出す
RUN if [ -z "${USER_ID}" ] || [ -z "${GROUP_ID}" ]; then \
        echo "Error: USER_ID and GROUP_ID must be provided"; \
        exit 1; \
    fi

# 受け取ったUSER_IDとGROUP_IDでユーザーとグループを作成
RUN groupadd -g ${GROUP_ID} user && \
    useradd -u ${USER_ID} -g user -m -s /bin/bash user

# 3. コンテナ起動後はここで指定したディレクトリがホームディレクトリとなる
# コンテナ起動後に "cd /" を入力してルートディレクトリを確認してみてください
WORKDIR /home/user

# パッケージのインストールの際に y/n の入力が要らなくなる
ENV DEBIAN_FRONTEND=noninteractive

# 4. パッケージのインストール
# パッケージのアップデートとソフトウェアレポジトリの管理に使われるツールをインストール
RUN apt update && \
    apt install -y software-properties-common

# deadsnakesを利用してpython3.9をインストール
# あとその他のパッケージもインストール
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

# pipをインストール
RUN apt-get install -y curl && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9

# Python 3.9をデフォルトのPythonに設定
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 && \
    update-alternatives --set python3 /usr/bin/python3.9 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 && \
    update-alternatives --set python /usr/bin/python3.9

# ホストマシンにあるrequirements.txtをコピーする
# /app 直下にコピーされる
COPY requirements.txt .

# pipのupgradeとrequirement.txtを使ったpythonライブラリのインストール
RUN pip install --upgrade "pip<24.1" && \
    pip install -r requirements.txt

# 5. 作業ユーザを切り替える
# 作業ユーザーをホストのIDに基づくユーザーに切り替える
USER user

# 6. コンテナを立ち上げたときにシェルが起動する
CMD ["/bin/bash"]
