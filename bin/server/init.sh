#!/bin/bash

set -e

echo 'Removing any existing container...'
docker stop sensor-ontology > /dev/null
docker rm sensor-ontology > /dev/null

echo
echo "Building & running image..."
docker build -t storeconnect/sensor-ontology:latest .
docker run --name sensor-ontology -e ADMIN_PASSWORD=admin -p "3030:3030" -d storeconnect/sensor-ontology:latest
echo 'Image is running.'

echo
echo "Use interface to create datasets by browsing http://localhost:3030"
