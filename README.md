# maxit-docker

## Description

[MAXIT](https://sw-tools.rcsb.org/apps/MAXIT/index.html) is a suite of tools to process PDB and PDBx/mmCIF files. One of its great advantages is an advanced converter between the two formats. This repository contains a Dockerfile which builds MAXIT and provides a default entrypoint which makes using the converter easier.

## Building

To build a local Docker image tagged `maxit`:

```
./build.sh
```

## Usage

To convert between formats:

```
docker run -i maxit < input.pdb > output.cif

docker run -i maxit < input.cif > output.pdb
```
