FROM jboss/immutant
MAINTAINER ian@blenke.com

# Expose the ports we're interested in
EXPOSE 8080 

# Run everything below as the immutant user
USER immutant

# Set the default command to run on boot
# This will boot Immutant in the standalone mode and bind to all interfaces
ADD standalone-ha-docker.xml /opt/immutant/jboss/standalone/configuration/
ADD run.py /opt/immutant/.docker/

# Change the owner of the /opt/immutant directory
RUN chown -R immutant:immutant /opt/immutant/*

VOLUME /opt/immutant/jboss/standalone/deployments/

WORKDIR /opt/immutant
CMD ["python", "/opt/immutant/.docker/run.py"]
