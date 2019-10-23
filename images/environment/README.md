# Docker images for running HOL Light

There are two images:
- `environment` contains OCaml and other tools but not HOL Light itself.
- `hol-light` contains the HOL Light sources ready to be run.

To use the `environment` image, one can mount a volume with the
HOL Light sources.
To use the `hol-light` image, it is enough to start the container
and run the command `hol_light`.