### ===========================================================================
### Container for running HOL Light.
###
### Nix on Alpine image with OCaml, elpi, dmtcp and other tools installed.
### ===========================================================================

FROM nixos/nix

USER root

# Add normal user "worker" and prepare a directory /home/worker/work
# Then install HOL Light and dependencies using Nix
RUN addgroup -S workgroup \
 && adduser -S worker -G workgroup \
 && mkdir /home/worker/work \
 && nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs \
 && nix-channel --update \
 && nix-env -iA \
      nixpkgs.ocaml-ng.ocamlPackages_4_05.ocaml \
      nixpkgs.ocaml-ng.ocamlPackages_4_05.camlp5 \
      nixpkgs.rlwrap nixpkgs.screen nixpkgs.dmtcp \
 && nix-channel --remove nixpkgs \
 && nix-collect-garbage -d

     #  nixpkgs.ocaml-ng.ocamlPackages_4_05.num \
     #  nixpkgs.ocaml-ng.ocamlPackages_4_05.elpi \

# Change user and working directory.
USER worker
WORKDIR /home/worker
CMD ["ocaml"]
