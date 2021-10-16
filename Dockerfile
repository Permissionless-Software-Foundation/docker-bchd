FROM ubuntu:20.10
# FROM ubuntu:18.04
MAINTAINER Chris Troutner <chris.troutner@gmail.com>

# Update the OS and install any OS packages needed.
RUN apt-get update
RUN apt-get install -y sudo git curl nano gnupg wget

# Install Node and NPM
# (used for debugging)
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs build-essential

# Startup script that will copy in config settings at startup.
WORKDIR /root

# Install Go
RUN wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.15.5.linux-amd64.tar.gz
RUN rm go1.15.5.linux-amd64.tar.gz
ENV PATH "$PATH:/usr/local/go/bin"

# Install BCHD
RUN go get github.com/gcash/bchd
WORKDIR /root/go/src/github.com/gcash/bchd
RUN go install .
RUN go install ./cmd/bchctl

# Set up the proxy
WORKDIR /root/go/src/github.com/simpleledgerinc/bchd/bchrpc/proxy

ENV PATH="/usr/local/go/bin:${PATH}"

RUN /usr/local/go/bin/go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway
RUN /usr/local/go/bin/go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2
RUN /usr/local/go/bin/go install github.com/golang/protobuf/protoc-gen-go
RUN /usr/local/go/bin/go install google.golang.org/grpc/cmd/protoc-gen-go-grpc

RUN make

# Symlink the config to /root/.bchd/bchd.conf
# so bchctl requires fewer flags.
RUN mkdir -p /root/.bchd
RUN ln -s /data/bchd.conf /root/.bchd/bchd.conf

# Create the data volume for storing blockchain data.
VOLUME ["/data"]

# Make persistant config directory
RUN mkdir /root/config
VOLUME /root/config

# Execute the startup script.
WORKDIR /root
COPY startup-script.sh startup-script.sh
CMD ["./startup-script.sh"]

# Used for debugging.
# COPY dummyapp.js dummyapp.js
# CMD ["node", "dummyapp.js"]
