# Development Quorum Network
This repo sets up a devlopment quorum network with QBFT consensus. Default number of nodes are 5, but they can be customized

## Prerequisite are
1. [Node version 1 or later](https://nodejs.org/en/download/)
2. [GoQuorum](https://consensys.net/docs/goquorum/en/latest/deploy/install/binaries/#release-binaries)
3. [Quorum Genesis Tool](https://www.npmjs.com/package/quorum-genesis-tool). In general Quorum Genesis tool is installed along with GoQuorum
4. [Tessera](https://docs.tessera.consensys.net/en/stable/HowTo/Get-started/Install/Distribution/)
5. [GCC](https://linuxize.com/post/how-to-install-gcc-compiler-on-ubuntu-18-04/)

## How to Deploy the betwork
run ```source ~/.bashrc ~/.bash_profile ~/.profile``` to access latest version of node and geth 
run ```./byfn.sh```
5-node network with geth attached to Node-0 should start.

