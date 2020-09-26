# Docker in Docker Swarm

This project's purpose is to make it easy to create a test Docker Swarm using Docker in Docker.

## Basic Usage

`./setup_swarm.sh`

This will use your local Docker engine to set up 4 containers:

* node1: Docker Swarm manager
* node2, node3: Docker Swarm workers
* registry: Docker registry used by all nodes in swarm

The registry uses a persistent volume for storing images and pulls images from Docker Hub when a local version doesn't exist.

This command will also drop you into a new shell on your local machine, set up to use the Docker engine of the Swarm Manager.

When you `exit` the shell, it will shutdown and remove all containers, leaving only the Registry storage volume.

# TODO

* Use a custom prompt that makes it clear we're in a Swarm-enabled shell
