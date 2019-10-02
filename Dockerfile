### ===========================================================================
### Container for running HOL Light.
###
### Debian image with OCaml, elpi, dmtcp and other tools installed.
### ===========================================================================

### ---------------------------------------------------------------------------
### Install the needed Debian packages.
### ---------------------------------------------------------------------------

FROM ocaml/opam2:debian-stable

USER root

RUN apt-get update && \
    apt-get -y install build-essential git curl make m4 rlwrap screen tmux

### ---------------------------------------------------------------------------
### Prepare a working directory for the user.
### ---------------------------------------------------------------------------

USER opam

RUN mkdir -p /home/opam/work

### ---------------------------------------------------------------------------
### Install the appropriate OCaml version and related dependencies.
### NB: Create a new switch named hol-4.07.1
### NB: Also install Elpi, as a cheap way to ensure that all required
###     dependencies are already present in this layer.
### ---------------------------------------------------------------------------

WORKDIR /home/opam/opam-repository

RUN git pull && \
    opam update && \
    opam switch create hol-4.07.1 ocaml-base-compiler.4.07.1 && \
    eval `opam config env` && \
    opam install num camlp5 merlin elpi

### ---------------------------------------------------------------------------
### Install Dmtcp.
### Version 2019-04-22
### ---------------------------------------------------------------------------

ARG DMTCP_VERSION=cfe168e2539b60e29bbac27da9a8b78b77add2a6

RUN mkdir -p /home/opam/src/dmtcp && \
    cd /home/opam/src/dmtcp && \
    curl -sL https://github.com/dmtcp/dmtcp/archive/$DMTCP_VERSION.tar.gz | \
    tar xz --strip-components=1 && \
    ./configure --prefix=/usr/local && make -j 2

USER root

WORKDIR /home/opam/src/dmtcp

RUN make install

USER opam

### ---------------------------------------------------------------------------
### Install the development version of Elpi.
### ---------------------------------------------------------------------------

RUN opam pin add elpi git+https://github.com/lpcic/elpi && \
    opam update && \
    opam install elpi

### ---------------------------------------------------------------------------
### Startup configuration.
### ---------------------------------------------------------------------------

WORKDIR /home/opam/work

RUN echo "Hello, Docker!" > hello.txt