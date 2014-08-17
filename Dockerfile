FROM jboss/immutant
MAINTAINER ian@blenke.com

# Expose the ports we're interested in
EXPOSE 8080 

# This cluster is orchestrated using maestro-ng
USER root
RUN yum -y install python-pip yum-utils make automake gcc gcc-c++ kernel-devel git libaio
RUN yum-builddep -y python-pip
RUN pip install git+git://github.com/signalfuse/maestro-ng

# Run everything below as the immutant user
USER immutant

WORKDIR /opt/immutant

# Set the default command to run on boot
# This will boot Immutant in the standalone mode and bind to all interfaces
ADD standalone-ha-docker.xml /opt/immutant/jboss/standalone/configuration/
ADD run.py /opt/immutant/.docker/

VOLUME /opt/immutant/jboss/standalone/data/
VOLUME /opt/immutant/jboss/standalone/deployments/

RUN mkdir -p /opt/immutant/jboss/standalone/data/content

CMD ["python", "/opt/immutant/.docker/run.py"]
