#! /bin/bash
docker build --target standalone -t maxit .
docker build --target server -t maxit-arpeggio .
