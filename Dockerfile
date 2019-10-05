### ===========================================================================
### Container for running HOL Light.
###
### Alpine image with OCaml, elpi, dmtcp and other tools installed.
### ===========================================================================

### ---------------------------------------------------------------------------
### Install the needed Debian packages.
### ---------------------------------------------------------------------------

FROM ocaml/opam2:alpine-3.8-ocaml-4.07

USER root

RUN apk install curl rlwrap screen

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

RUN eval `opam config env` \
 && opam install num camlp5 merlin elpi

### ---------------------------------------------------------------------------
### Install Dmtcp.
### Version 2019-09-21
### ---------------------------------------------------------------------------

ARG DMTCP_VERSION=8c20abe3d8b90c22a5145c4364fac4094d10d9cf

RUN mkdir -p /home/opam/src/dmtcp \
 && cd /home/opam/src/dmtcp \
 && curl -sL https://github.com/dmtcp/dmtcp/archive/$DMTCP_VERSION.tar.gz | \
    tar xz --strip-components=1 \
 && ./configure --prefix=/usr/local \
 && make -j 2 \
 && sudo make install \
 && cd /home/opam \
 && rm -rf src

### ---------------------------------------------------------------------------
### Install HOL Light.
### Version 2019-09-30
### ---------------------------------------------------------------------------

ARG HOL_LIGHT_VERSION=d3f8f474ff1cb4f549d51bed902700598d9c4274

RUN mkdir -p /home/opam/src/hol-light \
 && cd /home/opam/src/hol-light \
 && curl -sL https://github.com/jrh13/hol-light/archive/$HOL_LIGHT_VERSION.tar.gz | \
    tar xz --strip-components=1 \
 && eval `opam config env` \
 && make

### ---------------------------------------------------------------------------
### Startup configuration.
### ---------------------------------------------------------------------------

WORKDIR /home/opam/work
