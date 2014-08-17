FROM jboss/immutant
MAINTAINER ian@blenke.com

# Expose the ports we're interested in
EXPOSE 8080 

# This cluster is orchestrated using maestro-ng
USER root
RUN yum -y install python-pip
RUN yum groupinstall "Development Tools" "Development Libraries"
RUN pip install maestro

# Run everything below as the immutant user
USER immutant

# Set the default command to run on boot
# This will boot Immutant in the standalone mode and bind to all interfaces
ADD standalone-ha-docker.xml /opt/immutant/jboss/standalone/configuration/
ADD run.py /opt/immutant/.docker/

VOLUME /opt/immutant/jboss/standalone/deployments/

WORKDIR /opt/immutant
CMD ["python", "/opt/immutant/.docker/run.py"]
