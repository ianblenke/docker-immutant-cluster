#!/usr/bin/env python

# Start script for a JBOSS cluster node.

import logging
import os
import sys

from maestro.guestutils import get_container_name, \
    get_container_host_address, \
    get_environment_name, \
    get_node_list, \
    get_port, \
    get_service_name

# Setup logging
logging.basicConfig(stream=sys.stdout, level=logging.INFO)

os.chdir(os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    '..'))

GOSSIPROUTER_LIST = ','.join(["%s[%s]" % (host_port.split(':')[0], host_port.split(':')[1]) for host_port in get_node_list('gossiprouter', ports=['gossiprouter'])])
GOSSIPROUTER_COUNT = len(get_node_list('gossiprouter', ports=['gossiprouter']))

# Setup the JMX Java agent and various JVM options.
jvm_opts = [
    '-server',
    '-showversion',
    '-Dvisualvm.display.name="{}/{}"'.format(
        get_environment_name(), get_container_name()),
]

jmx_port = get_port('jmx', -1)
if jmx_port != -1:
    os.environ['JMX_PORT'] = str(jmx_port)
    jvm_opts += [
        '-Djava.rmi.server.hostname={}'.format(get_container_host_address()),
        '-Dcom.sun.management.jmxremote.port={}'.format(jmx_port),
        '-Dcom.sun.management.jmxremote.rmi.port={}'.format(jmx_port),
        '-Dcom.sun.management.jmxremote.authenticate=false',
        '-Dcom.sun.management.jmxremote.local.only=false',
        '-Dcom.sun.management.jmxremote.ssl=false',
    ]

jvm_opts += [
    '-Djboss.messaging.cluster.password={}'.format(os.environ['HORNETQ_PASSWORD']),
    '-Djboss.node.name={}'.format(get_container_name()),
    '-Djboss.default.jgroups.stack=tcpgossip',
    '-Ddocker.gossiprouter.hosts={}'.format(GOSSIPROUTER_LIST),
    '-Ddocker.gossiprouter.count={}'.format(GOSSIPROUTER_COUNT)
]

os.environ['JBOSS_OPTS'] = ' '.join(jvm_opts) + os.environ.get('JVM_OPTS', '')

os.execl('jboss/bin/standalone.sh','-server-config','/opt/immutant/jboss/standalone/configuration/standalone-ha-docker.xml')
