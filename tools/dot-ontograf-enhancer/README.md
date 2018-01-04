# Protege's Ontgraf plugin DOT generation enhancer 

Enhance [DOT](https://graphviz.gitlab.io/_pages/doc/info/lang.html) graph produced by the [Protege's OntoGraf plugin](https://protegewiki.stanford.edu/wiki/OntoGraf)

## Prerequisites

- Know what is the [DOT](https://graphviz.gitlab.io/_pages/doc/info/lang.html) language
- Have the [Graphviz](https://graphviz.gitlab.io/) tool suite installed
- Know what is the [Protege's OntoGraf plugin](https://protegewiki.stanford.edu/wiki/OntoGraf)

## Motivation

By default, the [Protege's OntoGraf plugin](https://protegewiki.stanford.edu/wiki/OntoGraf) can generate a DOT file based on the graph is currently displayed. But there is no way to customize its generation (color, distinguish internal and external concepts, ...). That's the aim of the [enhance-dot-ontograf.sh](./enhance-dot-ontograf.sh) tool: to have a way to customize DOT generation by the [Protege's OntoGraf plugin](https://protegewiki.stanford.edu/wiki/OntoGraf).

## Example of use

The following example shows how to generate an enhanced DOT file based on an original one, by defining some external concept and no overriding the existing original DOT file:

    ./enhance-dot-ontograf.sh 
        -o enhanced-ontology.dot
        -e ExternalConcept1
        -e ExternalConcept2
        -e "An other external concept"
        original-ontology.dot

Enhanced DOT file can be rendered as a picture image as any DOT file by using the [dot](https://linux.die.net/man/1/dot) command line:

    dot -Tpng -oenhanced-ontology.png enhanced-ontology.dot