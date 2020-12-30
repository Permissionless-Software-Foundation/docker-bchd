FROM ubuntu:18.04
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
RUN export PATH=$PATH:/usr/local/go/bin
RUN rm go1.15.5.linux-amd64.tar.gz

# Install BCHD
RUN /usr/local/go/bin/go get github.com/simpleledgerinc/bchd || echo 1
WORKDIR /root/go/src/github.com/simpleledgerinc/bchd
RUN /usr/local/go/bin/go install .
RUN /usr/local/go/bin/go install ./cmd/bchctl

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
#COPY dummyapp.js dummyapp.js
#CMD ["node", "dummyapp.js"]
