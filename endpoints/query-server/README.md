# FUI StoreConnect's ontology query server

This directory contains definition about the [FUI StoreConnect](https://www.pole-scs.org/projet/storeconnect)'s ontology query server.

## Prerequisites

- The StoreConnect's ontology query server is based on the [Strabon spatiotemporal RDF store](http://www.strabon.di.uoa.gr/). So before to go, please read documentation carefully.
- The StoreConnect's ontology query server is based on the [StoreConnect's Strabon Docker image](https://github.com/StoreConnect/docker-strabon) and the [Mdillon's Alpine Postgis Docker image](https://github.com/appropriate/docker-postgis/tree/master/9.4-2.4/alpine), and can be executed through the [dedicated Docker composition file](./docker-compose.yml). So before to go, you have to know:
    - [What is Docker](https://docs.docker.com/)
    - [What is a Docker composition](https://docs.docker.com/compose/overview/)

## Content

File/Directory                                  | Description
----------------------------------------------- | -----------
[`docker-compose.yml`](./docker-compose.yml)    | The Docker composition file of the StoreConnect's ontology query server
[`./conf/`](./conf)                             | Associated configuration file to the Docker composition

## How to...

### ... access to the official StoreConnect's ontology query server instance?

The official StoreConnect's ontology query server instance can be reached [here](http://apiontologie.westeurope.cloudapp.azure.com:8890/strabon).

The following SPARQL endpoints are available:

SPARQL Endpoint | Description                                                                       | URL
--------------- | --------------------------------------------------------------------------------- | ---------------------------------------------------------------------
Query           | [SPARQL 1.1 Query Language](https://www.w3.org/TR/sparql11-query/) HTTP endpoint  | http://apiontologie.westeurope.cloudapp.azure.com:8890/strabon/Query
Update          | [SPARQL 1.1 Update](https://www.w3.org/TR/sparql11-update/) HTTP endpoint         | http://apiontologie.westeurope.cloudapp.azure.com:8890/strabon/Update
Store           | To massively load data                                                            | http://apiontologie.westeurope.cloudapp.azure.com:8890/strabon/Store

### ... install its own StoreConnect's ontology query server?

#### Server installation

Docker composition is based on two services `storeconnect-postgis` ([PostgreSQL](https://www.postgresql.org/) with [Postgis](http://postgis.net/) extension) and `storeconnect-strabon` ([Strabon](http://www.strabon.di.uoa.gr/)) which later is dependent to the former. However, the current version of Strabon service does no wait until Postgis is correctly up.
Thus, to correctly install the server you need to:
1. Run the `storeconnect-postgis` service and wait until its initialization process is done by executing:
    ```bash
    $ docker-compose up -d storeconnect-postgis && docker-compose logs -f
    ```
2. Then run the `storeconnect-strabon` service and wait until its initialization process is done
    ```bash
    $ docker-compose up -d storeconnect-strabon && docker-compose logs -f
    ```
    
_Note: The `-d` option starts composition's containers in background mode. Use the `--help` option for more details_

After that, instances can be reached at:
- `<docker host>:8890/strabon` for Strabon
- `<docker host>:1111` for PostgreSQL with Postgis extension

#### Server configuration

When composition is running, associated `storeconnect-strabon` and `storeconnect-postgis` services read configuration from:
- [docker-compose.yml's storeconnect-strabon command](./docker-compose.yml) and [./conf/strabon.env](./conf/strabon.env) for the `storeconnect-strabon` service
- [./conf/postgis.env](./conf/postgis.env) for the `storeconnect-postgis` service.

By default, configuration fits for a standard machine (8GB RAM capacity and SSD disk type). Refer to [this](http://www.strabon.di.uoa.gr/download.html) if you want to customize your instance with a more appropriate configuration.

#### Import a StoreConnect's ontology

When StoreConnect's ontology query server is ran for the first time, the server is empty and no ontology is loaded. To load an ontology:

##### Via cURL

```bash
$ curl <docker host>:8090/strabon/Store \
    --user update:changeit \ 
    --header 'Accept: application/rdf+xml' \
    --data 'graph=http://storeconnect/' \
    --data 'format=<ontology format>' \
    --data 'fromurl=true' \
    --data 'url=<ontology URL>'
```

Where:
- `<docker host>` is the associated Docker host (`localhost` by default if using a native Docker installation)
- `<ontology format>` and `<ontology URL>` is respectively the format and the URL to the StoreConnect's ontology. For instance:
    - `<ontology format>` = `RDF/XML`
    - `<ontology URL>` = `https://raw.githubusercontent.com/StoreConnect/storeconnect-ontologies-api/master/ontologies/storeconnect-main/storeconnect-main.rdf`

**Important: Note the use of the `graph` parameter that defines the graph name where store the ontology. Always `http://storeconnect/`.**

##### Manually

1. Access to the StoreConnect server's web form by browsing to `<docker host>:8090/strabon`, where `<docker host>` is the associated Docker host (`localhost` by default if using a native Docker installation)
2. Access to the `Explore/Modify operations`/`Store` menu
3. Type `http://storeconnect` in the `Graph` input
4. Choose the associated format of your ontology (for instance `RDF/XML`) 
5. Copy/Paste your ontology in the `Direct input` field or precise the URI to your ontology in the `URI Input` field
6. Following the way you define your ontology, click on `Store Input` or `Store from URI`.
7. Type your credentials in the appeared popup (`update/changeit` by default) 

#### Persist changes

By default, composition is using a [Docker volume](https://docs.docker.com/engine/admin/volumes/volumes/) to persist data. Volume is automatically created at the first execution and be mounted to the relative [./data/](./data) directory. 

#### Exposed ports

When composition is running, the `storeconnect-virtuoso` service is up and exposes the following ports:

Port    | Description
------- | --------------------------------------------------
1111    | StoreConnect's ontology query server's SQL access
8090    | StoreConnect's ontology query server's HTTP access
