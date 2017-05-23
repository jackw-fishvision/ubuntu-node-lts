FROM ubuntu:xenial
MAINTAINER Jack Willis-Craig <jackw@fishvision.com>
ENV DEBIAN_FRONTEND noninteractive

# Remove sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Add yarn source
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install packages
RUN apt-get update
RUN apt-get -y install wget \
    curl \
    git \
    zip \
    unzip \
    libxml2-dev \
    build-essential \
    software-properties-common \
    libssl-dev \
    python \
    python-dev \
    python-pip \
    python-virtualenv \
    vim \
    jq \
    coreutils \
    openssh-client \
    yarn \
    libelf1 # Required by flow-bin

# Clean apt
RUN apt-get clean

# Install awscli
RUN pip install awscli

# Install node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash && \
    export NVM_DIR="/root/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install 6 --lts && \
    npm update npm -g
    
# Install node-gyp
RUN yarn global add node-gyp

# Misc
RUN mkdir -p ~/.ssh
RUN [[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
