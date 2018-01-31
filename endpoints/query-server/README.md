# FUI StoreConnect's ontology query server

This directory contains definition about the [FUI StoreConnect](https://www.pole-scs.org/projet/storeconnect)'s ontology query server.

## Prerequisites

- The StoreConnect's ontology query server is based on the [Openlink Virtuoso server (OSS edition)](http://vos.openlinksw.com/owiki/wiki/VOS/). So before to go, please read documentation carefully.
- The StoreConnect's ontology query server is based on the [tenforce's docker-virtuoso Docker image](https://github.com/tenforce/docker-virtuoso), and can be executed through the [dedicated Docker composition file](./docker-compose.yml). So before to go, you have to know:
    - [What is Docker](https://docs.docker.com/)
    - [What is a Docker composition](https://docs.docker.com/compose/overview/)

## Content

File/Directory                                  | Description
----------------------------------------------- | -----------
[`docker-compose.yml`](./docker-compose.yml)    | The Docker composition file of the StoreConnect's ontology query server
[`./conf/`](./conf)                             | Associated configuration file to the Docker composition

## How to...

### ... access to the official StoreConnect's ontology query server instance?

The official StoreConnect's ontology query server instance can be reached [here](http://apiontologie.westeurope.cloudapp.azure.com:8890/sparql).

### ... install its own StoreConnect's ontology query server?

#### Server installation

Simply execute from the console:

    docker-compose up -d

_Note: The `-d` option starts composition's containers in background mode. Use the `--help` option for more details_

#### Server configuration

When composition is running, associated `storeconnect-virtuoso` service reads configuration from the [./conf/virtuoso.env](./conf/virtuoso.env) configuration file.

By default, configuration fits for a standard machine (e.g., common RAM capacity). Refer to [this](https://github.com/tenforce/docker-virtuoso#ini-configuration) and [this](http://docs.openlinksw.com/virtuoso/dbadm/#virtini) if you want to customize your instance with a more appropriate configuration.

#### Import a StoreConnect's ontology

When StoreConnect's ontology query server is ran for the first time, the server is empty and no ontology is loaded. To load an ontology:

1. Access to the StoreConnect server's web form by browsing to `<docker host>:8090`, where `<docker host>` is the associated Docker host (`localhost` by default if using a native Docker installation)
2. Access to the `Conductor` menu 
3. Type the username/password (`dba`/`dba` by default)
4. Access to the `LinkedData` tab
5. Access to the `Quad Store Upload` sub-tab
6. Then upload your ontology by using the displayed form (StoreConnect's [ontologies](../../ontologies/) IRIs can be found by using the URL provided by the [raw Github version](https://stackoverflow.com/questions/4604663/download-single-files-from-github). 

#### Persist changes

By default, composition is using a [Docker volume](https://docs.docker.com/engine/admin/volumes/volumes/) to persist data. Volume is automatically created at the first execution and be mounted to the relative [./data/](./data) directory. 

#### Exposed ports

When composition is running, the `storeconnect-virtuoso` service is up and exposes the following ports:

Port    | Description
------- | --------------------------------------------------
1111    | StoreConnect's ontology query server's SQL access
8090    | StoreConnect's ontology query server's HTTP access
