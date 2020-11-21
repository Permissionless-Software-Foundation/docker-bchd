# docker-bchd
Wraps BCHD inside an Ubuntu-based Docker container.

This Docker container runs [James Cramer's fork of BCHD](https://github.com/simpleledgerinc/bchd) that includes an SLP indexer. It wraps that code inside a Docker container and runs BCHD.

# Installation and Usage
- It's assumed that you are starting with a fresh installation of Ubuntu 18.04
LTS on a 64-bit machine. It's also assumed that you are installing as
a [non-root user with sudo privileges](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04).

- Install Docker on the host
system. [This tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04) shows
how to install Docker on a Ubuntu system. It's specifically targeted to Digital
Ocean's cloud servers, but should work for any Ubuntnu system.

- Install Docker Compose too. [This tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04)
shows how to do so on a Ubuntu system.

- Clone this repository in your home directory with the following command:

`git clone https://github.com/christroutner/docker-bchd`

- Create a two directories in the same directory as `docker-bchd`. These will be
used to store configuration data and blockchain data. Call them:
  - `config`
  - `bchd-data`

- Copy the [run-script.sh](run-script.sh) file
into the `config` directory you just created. Customize the run-script.sh file for
your own full node.

- Enter the `docker-bchd` directory and start the container with this command:

`docker-compose up -d`


# License
[MIT License](LICENSE.md)
