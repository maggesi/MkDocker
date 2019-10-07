### ===========================================================================
### Container for running HOL Light.
###
### Nix on Alpine image with OCaml, elpi, dmtcp and other tools installed.
### Version with HOL Light installed.
### ===========================================================================

FROM maggesi/hol-light:environment

USER root

# Install HOL Light and dependencies using Nix
RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs \
 && nix-channel --update \
 && nix-env -iA nixpkgs.ocaml-ng.ocamlPackages_4_07.hol_light \
 && nix-channel --remove nixpkgs \
 && nix-collect-garbage -d

# Change user and working directory.
USER worker
WORKDIR /home/worker
CMD ["hol_light"]
