# maxit-docker

## Description

[MAXIT](https://sw-tools.rcsb.org/apps/MAXIT/index.html) is a suite of tools to process PDB and PDBx/mmCIF files. One of its great advantages is an advanced converter between the two formats. This repository contains a Dockerfile that builds MAXIT and provides a default entrypoint which makes using the converter easier.

## Building

To build local Docker images:

```
./build.sh
```

## Usage

### CLI

To convert between formats:

```
docker run -i maxit < input.pdb > output.cif

docker run -i maxit < input.cif > output.pdb
```

### REST

Start the conversion service:

```
docker run -p 8080:8080 maxit-server
```

Submit conversion tasks:

```
curl -X POST -H 'Content-Type: text/plain' --data-binary @input.pdb http://localhost:8080

curl -X POST -H 'Content-Type: text/plain' --data-binary @input.cif http://localhost:8080
```
# maxit-arpeggio
