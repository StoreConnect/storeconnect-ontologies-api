# StoreConnect's ontology server

This repositoy desribes ontology server used by the StoreConnect project

## Prerequisites

- The StoreConnect's ontology server is based on the [Openlink Virtuoso server (OSS edition)](http://vos.openlinksw.com/owiki/wiki/VOS/).
- The StoreConnect's ontology server is based on the [tenforce's docker-virtuoso Docker image](https://github.com/tenforce/docker-virtuoso), and can be executed through a Docker composition file. So before to go, you have to know:
    - [What is Docker](https://docs.docker.com/)
    - [What is a Docker composition](https://docs.docker.com/compose/overview/)

## Content

File/Directory                                  | Description
----------------------------------------------- | -----------
[`docker-compose.yml`](./docker-compose.yml)    | The Docker composition file of the StoreConnect's ontology server
[`./conf`](./conf)                              | Associated configuration file to the Docker composition

## How to...

### ... install its own StoreConnect's ontology server?

Simply execute from the console:

    docker-compose up -d

_Note: The `-d` option that starts composition's containers in background mode_

### ... configure its own StoreConnect's ontology server?

When compoisition is running, associated `virtuoso` service reads configuration from the [./conf/virtuoso.env](./conf/virtuoso.env) configuration file.

By default, configuration fits for a standard machine (e.g., common RAM capacity). Refer to [this](https://github.com/tenforce/docker-virtuoso#ini-configuration) and [this](http://docs.openlinksw.com/virtuoso/dbadm/#virtini) if you want to customize your instance with specific configuration.

### ... import a StoreConnect's ontology?

When StoreConnect's ontology server is ran for the first time, then server is empty and no ontology is loaded. To load an ontology:

1. Access to the StoreConnect server's web form by browsing to <docker host>:8090
2. Access to the Conductor menu 
3. Type the username/password (dba/dba by default)
4. Access to the LinkedData tab
5. Access to the Quad Store Upload sub-tab
6. Then upload your ontology by using the displayed form
    - StoreConnect's ontologies IRI can be found [from the StoreConnect's ontologies documentation](../ontologies/README.md) 

## Running services / ports

When composition is running, the `virtuoso` service is up with the following associated ports:

Port    | Description
------- | ---------------------------------------------
1111    | StoreConnect's ontology server's SQL access
8090    | StoreConnect's ontology server's HTTP access
