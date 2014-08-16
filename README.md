# Immutant Cluster Docker image

This is an example Dockerfile that deploys an Immutant cluster using JGroups GossipRouter.

This image is built on the [jboss/immutant](https://registry.hub.docker.com/u/jboss/immutant/) docker image.

This image is meant to be used with [jboss/immutant](https://registry.hub.docker.com/u/ianblenke/docker-jboss-gossiprouter/) docker image, more specifically: this should be deployed with the [maestro-ng](https://github.com/signalfuse/maestro-ng) docker orchestration tool.

This could easily be adapted to use any of the other [JBoss dockerfiles](https://github.com/jboss/dockerfiles/), there is nothing here inherently unique to Immutant.

## Usage

    docker run -it -p 8080:8080 ianblenke/docker-immutant-cluster

## Building on your own

You don't need to do this on your own, because there is an [automated build](https://registry.hub.docker.com/u/ianblenke/docker-immutant-cluster/) for this repository, but if you really want:

    docker build --rm=true --tag=ianblenke/docker-immutant-cluster .

## Source

The source is [available on GitHub](https://github.com/ianblenke/docker-immutant-cluster/).

Please feel free to submit pull requests and/or fork for other JBoss project clusters.

