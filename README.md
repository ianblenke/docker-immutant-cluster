# Immutant Cluster Docker image

This is an example Dockerfile that deploys an Immutant cluster using JGroups GossipRouter.

This image is built on the [jboss/immutant](https://registry.hub.docker.com/u/jboss/immutant/) docker image.

This image is meant to be used with [jboss/immutant](https://registry.hub.docker.com/u/ianblenke/docker-jboss-gossiprouter/) docker image, more specifically: this should be deployed with the [maestro-ng](https://github.com/signalfuse/maestro-ng) docker orchestration tool.

This could easily be adapted to use any of the other [JBoss dockerfiles](https://github.com/jboss/dockerfiles/), there is nothing here inherently unique to Immutant.

## Usage

    docker run -it -p 8080:8080 ianblenke/docker-immutant-cluster

## Building on your own

You don't need to do this on your own, because there is an [automated build](https://registry.hub.docker.com/u/ianblenke/docker-immutant-cluster/) for this repository, but if you really want:

You will want to install maestro-ng to use this docker image.

Here is an example maestro.yaml file:
```
ships:
  docker-host-1: { ip: 10.0.0.101, docker_port: 4243 }
  docker-host-2: { ip: 10.0.0.102, docker_port: 4243 }
  docker-host-3: { ip: 10.0.0.103, docker_port: 4243 }
services:
  gossiprouter:
    image: ianblenke/docker-jboss-gossiprouter:latest
    instances:
      gossiprouter-1:
        ship: docker-host-1
        ports: {gossiprouter: 12001}
        lifecycle:
          running: [{type: tcp, port: gossiprouter}]
        stop_timeout: 2
        limits:
          memory: 1G
          cpu: 1
      gossiprouter-2:
        ship: docker-host-2
        ports: {gossiprouter: 12001}
        lifecycle:
          running: [{type: tcp, port: gossiprouter}]
        stop_timeout: 2
        limits:
          memory: 1G
          cpu: 1
      gossiprouter-3:
        ship: docker-host-3
        ports: {gossiprouter: 12001}
        lifecycle:
          running: [{type: tcp, port: gossiprouter}]
        stop_timeout: 2
        limits:
          memory: 1G
          cpu: 1
  immutant:
    image: ianblenke/docker-immutant-cluster:latest
    requires: [ gossiprouter ]
    instances:
      immutant-1:
        ship: docker-host-1
        ports: {immutanthttp: 8080}
        lifecycle:
          running: [{type: tcp, port: immutanthttp}]
        stop_timeout: 2
        limits:
          memory: 5G
          cpu: 10
      immutant-2:
        ship: docker-host-2
ev.cf3.us
        ports: {immutanthttp: 8080}
        lifecycle:
          running: [{type: tcp, port: immutanthttp}]
        stop_timeout: 2
        limits:
          memory: 5G
          cpu: 10
      immutant-3:
        ship: docker-host-3
        ports: {immutanthttp: 8080}
        lifecycle:
          running: [{type: tcp, port: immutanthttp}]
        stop_timeout: 2
        limits:
          memory: 5G
          cpu: 10
```

## Source

The source is [available on GitHub](https://github.com/ianblenke/docker-immutant-cluster/).

Please feel free to submit pull requests and/or fork for other JBoss project clusters.

