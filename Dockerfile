FROM stain/jena-fuseki:latest

RUN apk update && \ 
    apk add curl

COPY bin/server/server-init.sh /jena-fuseki/
RUN chmod 755 /jena-fuseki/server-init.sh

COPY src/sensor-ontology.rdf /staging/
COPY src/customer-ontology.rdf /staging/

WORKDIR /jena-fuseki
CMD ["/jena-fuseki/server-init.sh"]
