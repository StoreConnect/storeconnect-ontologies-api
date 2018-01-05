# FUI StoreConnect's static ontology visualization server

This directory contains configuration to statically visualize [StoreConnect's ontologies](../../ontologies).

Statically visualization is based on a static HTML representation of the ontology.

## Prerequisites

- The StoreConnect's static ontology visualization server is based on the [Protégé](https://protege.stanford.edu/)'s [OwlDoc plugin](https://protegewiki.stanford.edu/wiki/OWLDoc)
- The StoreConnect's static ontology visualization server is based on the [Apache's httpd image](https://hub.docker.com/_/httpd/), and can be executed through the [dedicated Docker composition file](./docker-compose.yml). So before to go, you have to know:
    - [What is Apache httpd](https://en.wikipedia.org/wiki/Apache_HTTP_Server)
    - [What is Docker](https://docs.docker.com/)
    - [What is a Docker composition](https://docs.docker.com/compose/overview/)

## Content

File/Directory                                  | Description
----------------------------------------------- | -----------
[`docker-compose.yml`](./docker-compose.yml)    | The Docker composition file of the StoreConnect's static ontology visualization server

## How to...

### ... access to the official StoreConnect's static ontology visualization server instance?

The official StoreConnect's ontology visualization server instance can be reached [here](http://apiontologie.westeurope.cloudapp.azure.com:8080). See [associated ontologies](../../ontologies) for more details

### ... generate the static HTML representation of an ontology 

Static HTML representation of an ontology can be produced by the [Protégé](https://protege.stanford.edu/)'s [OwlDoc plugin](https://protegewiki.stanford.edu/wiki/OWLDoc).

To generate the static HTML representation of an ontology, then:

1. Load your ontology into [Protégé](https://protege.stanford.edu/)
2. Export the HTML representation of your ontology by using the [OwlDoc](https://protegewiki.stanford.edu/wiki/OWLDoc) located at `Tools` -> `Export OWLDoc...`
3. Create a link, named `owldoc`, that links to the directory containing the exported HTML representation

### ... visualize the static representation of an ontology

When static HTML representation has been correctly generated (see [previous section](#-generate-the-static-html-representation-of-an-ontology)), then:

1. Execute from the console

```
    docker-compose up -d
```

_Note: The `-d` option starts composition's containers in background mode. Use the `--help` option for more details_

2. Browse to 

```
    <docker_host>:8080
```
    
Where `<docker_host>` is the associated Docker host (`localhost` by default if using a native Docker installation)

#### Exposed ports

When composition is running, the `storeconnect-owldoc` service is up and exposed the following ports:

Port    | Description
------- | -----------------------------------------------------------------
8080    | StoreConnect's static ontology visualization server's HTTP access
 
