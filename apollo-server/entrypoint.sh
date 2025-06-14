#!/bin/bash
set -e

# Inicia filebeat en segundo plano
/usr/bin/filebeat -e -c /etc/filebeat/filebeat.yml &

# Ejecuta la aplicación Node.js
exec npm start
