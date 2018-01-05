# FUI StoreConnect's dynamic ontology visualization server

This directory contains configuration to dynamically visualize [StoreConnect's ontologies](../../ontologies). Visualization is done by using the [VisualDataWeb's WebOWL tool](http://vowl.visualdataweb.org/webvowl.html).

## Prerequisites

- The StoreConnect's dynamic ontology visualization server is based on the [VisualDataWxeb's VOWL tool](http://vowl.visualdataweb.org/webvowl.html). So before to go, please read documentation carefully.
- The StoreConnect's dynamic ontology visualization server is based on the [abourdon's WebVOWL image](https://hub.docker.com/r/abourdon/webvowl/), and can be executed through the [dedicated Docker composition file](./docker-compose.yml). So before to go, you have to know:
    - [What is Docker](https://docs.docker.com/)
    - [What is a Docker composition](https://docs.docker.com/compose/overview/)

## Content

File/Directory                                  | Description
----------------------------------------------- | -----------
[`docker-compose.yml`](./docker-compose.yml)    | The Docker composition file of the StoreConnect's ontology server
[`./conf/`](./conf)                             | Associated configuration file to the Docker composition

## How to...

### ... access to the official StoreConnect's ontology visualization server instance?

The official StoreConnect's ontology visualization server instance can be reached [here](http://apiontologie.westeurope.cloudapp.azure.com:8081/webvowl).

### ... install its own StoreConnect's ontology visualization server?

#### Server installation

Simply execute from the console:

    docker-compose up -d

_Note: The `-d` option that starts composition's containers in background mode. Use the `--help` option for more details_

#### Visualize a StoreConnect's ontology

To visualize a StoreConnect's ontology, please import it and customize its visualization as described below.

##### Import ontology

1. Access to the VisualDataWeb's VOWL interface by browsing to `<docker host>:8080/webvowl`
2. Get the StoreConnect's ontology IRI by using the URL provided by the [raw Github version](https://stackoverflow.com/questions/4604663/download-single-files-from-github) of your ontology
3. Mouse hover to the `Ontology` menu
4. Paste the StoreConnect's ontology IRI into the dedicated `Enter ontology IRI` field
5. Click on the `Visualize` button

Then ontology is loading and finally visualized into the web interface.

##### Customize visualization

By default, some filters are applied so some elements are hidden. To fully visualize ontology, please apply the next configuration by playing with the WebVOWL menu:

- `Filter` -> `Class disjointness` = _unchecked_
- `Filter` -> `Degree of collapsing` = 0

Finally, to better visualize the different ontologies involved, we suggest to use the Multicolor option by using:

- `Modes` -> `Color external` -> `Multicolor` = _pressed_

Now you can navigate to the ontology by zooming in/out, drag and drop and searching elements by using the dedicated `Search` field.

#### Running services / ports

When composition is running, the `storeconnect-webowl` service is up with the following associated ports:

Port    | Description
------- | ------------------------------------------------------------------
8081    | StoreConnect's dynamic ontology visualization server's HTTP access
 