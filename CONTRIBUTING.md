# How to contribute

To contribute you'll need to follow the [Angular commit message convention](https://gist.github.com/stephenparish/9941e89d80e2bc58a153), then:

## General instructions

1. Fork our develop branch
2. Create a branch describing your contribution for instance: `git checkout -b feat/updateAttributes`
3. Submit your work as a pull request by **deeply** documenting changes

## Special case for contribution on ontologies

If contributing to ontologies, please also: 

1. Use the [Protégé](https://protege.stanford.edu/) tool for editing
2. Generate both `owl/xml` and `rdf/xml` syntax of your ontology
3. (Optionally) Generate an image of your ontology by:
    1. Generating a raw [Protégé's Ontograf plugin](https://protegewiki.stanford.edu/wiki/OntoGraf) DOT file
    2. Enhance it by using the [enhance-dot-ontograf tool](./tools/dot-ontograf-enhancer)
    3. Finally generate the image via the DOT suite tool (see [enhance-dot-ontograf tool](./tools/dot-ontograf-enhancer) for more details)