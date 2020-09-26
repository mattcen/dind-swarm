#!/bin/bash

nodes=(node{1,2,3})

cleanup(){
  unset DOCKER_TLS_VERIFY DOCKER_CERT_PATH DOCKER_HOST
  destroy_swarm "${nodes[@]}"
  docker-compose down -v
}
trap 'cleanup' 0 INT TERM QUIT

create_swarm()
{
  join_cmd=($(docker-compose exec "$1" docker swarm init | grep '^    docker swarm join ' | tr -d '\r'))
  shift
  for node
  do
    docker-compose exec "$node" "${join_cmd[@]}" | grep -v 'This node joined a swarm as a worker.'
  done
}

destroy_swarm()
{
  manager=$1
  shift
  for node
  do
    docker-compose exec "$node" docker swarm leave | grep -v 'Node left the swarm.'
  done
  docker-compose exec "$manager" docker swarm leave --force | grep -v 'Node left the swarm.'
}

#echo docker context create dind --description "Docker-in-Docker" --docker "host=tcp://localhost:12376,ca=$PWD/certs/ca/cert.pem,cert=$PWD/certs/client/cert.pem,key=$PWD/certs/client/key.pem"
#docker_args=(--tlsverify --tlscacert="$PWD/certs/ca/cert.pem" --tlscert="$PWD/certs/client/cert.pem" --tlskey="$PWD/certs/client/key.pem" -H=localhost:12376)
#export docker(){ command docker "${docker_args[@]}" "$@"; }

docker-compose up -d
sleep 5
create_swarm "${nodes[@]}"
#ln -sf ca/cert.pem certs/ca.pem
#ln -sf client/cert.pem certs/cert.pem
#ln -sf client/key.pem certs/key.pem
export DOCKER_TLS_VERIFY=yes
export DOCKER_CERT_PATH=$PWD/certs
export DOCKER_HOST=tcp://localhost:12376
bash
