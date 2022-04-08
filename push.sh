#! /bin/bash
docker tag maxit:latest tzok/maxit:latest
docker tag maxit-server:latest tzok/maxit:server

docker push tzok/maxit:latest
docker push tzok/maxit:server

