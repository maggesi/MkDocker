### ===========================================================================
### Container for running HOL Light.
###
### Nix on Alpine image with OCaml, elpi, dmtcp and other tools installed.
### ===========================================================================

FROM nixos/nix

USER root

# Add user "worker".
RUN addgroup -S workgroup && adduser -S worker -G workgroup

# Install HOL Light and dependencies using Nix
RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs \
 && nix-channel --update \
 && nix-env -iA \
      nixpkgs.ocaml-ng.ocamlPackages_4_07.ocaml \
      nixpkgs.ocaml-ng.ocamlPackages_4_07.camlp5 \
      nixpkgs.ocaml-ng.ocamlPackages_4_07.num \
      nixpkgs.rlwrap nixpkgs.screen nixpkgs.dmtcp \
      nixpkgs.ocaml-ng.ocamlPackages_4_07.hol_light \
 && nix-channel --remove nixpkgs \
 && nix-collect-garbage -d

# Change user and working directory.
USER worker
WORKDIR /home/worker
