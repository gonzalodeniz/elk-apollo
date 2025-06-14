#!/bin/bash
set -e

# Inicia filebeat en segundo plano
/usr/bin/filebeat -e -c /etc/filebeat/filebeat.yml &
/usr/bin/metricbeat -e -c /etc/metricbeat/metricbeat.yml &

# Ejecuta la aplicación Node.js
exec npm start >> /var/log/apollo-server.log 2>&1
