# Sensors Ontologies

This ontology describe the sensors ontology relative to the FUI Project [StoreConnect](https://github.com/StoreConnect).

v1.0: Initial version of the documents

Authors: Julien Duribreux, Romain Rouvoy, Lionel Seinturier (Inria Lille).

## Definition
[Wikipedia](https://fr.wikipedia.org/wiki/Ontologie_(informatique)) defines an ontology as follows:
> "In computer science and information science, an ontology is a formal naming and definition of the types, properties, and interrelationships of the entities that really or fundamentally exist for a particular domain of discourse. It is thus a practical application of philosophical ontology, with a taxonomy.
> An ontology compartmentalizes the variables needed for some set of computations and establishes the relationships between them.
> Contemporary ontologies share many structural similarities, regardless of the language in which they are expressed. As mentioned above, most ontologies describe individuals (instances), classes (concepts), attributes, and relations. In this section each of these components is discussed in turn.
>
> Common [components of ontologies](https://en.wikipedia.org/wiki/Ontology_components) include:
> <dl>
> <dt>Individuals</dt>
> <dd>Instances or objects (the basic or "ground level" objects)</dd>
> <dt>Classes</dt>
> <dd>Sets, collections, concepts, classes in programming, types of objects, or kinds of things</dd>
> <dt>Attributes</dt>
> <dd>Aspects, properties, features, characteristics, or parameters that objects (and classes) can have</dd>
> <dt>Relations</dt>
> <dd>Ways in which classes and individuals can be related to one another</dd>
> <dt>Function terms</dt>
> <dd>Complex structures formed from certain relations that can be used in place of an individual term in a statement</dd>
> <dt>Restrictions</dt>
> <dd>Formally stated descriptions of what must be true in order for some assertion to be accepted as input</dd>
> <dt>Rules</dt>
> <dd>Statements in the form of an if-then (antecedent-consequent) sentence that describe the logical inferences that can be drawn from an assertion in a particular form</dd>
> <dt>Axioms</dt>
> <dd>Assertions (including rules) in a logical form that together comprise the overall theory that the ontology describes in its domain of application. This definition differs from that of "axioms" in generative grammar and formal logic. In those disciplines, axioms include only statements asserted as a priori knowledge. As used here, "axioms" also include the theory derived from axiomatic statements</dd>
> <dt>Events</dt>
> <dd>The changing of attributes or relations</dd>
> </dl>
> Ontologies are commonly encoded using ontology languages."

These ontology languages include [RDF Schema (RDFS)](https://en.wikipedia.org/wiki/RDF_Schema) and [Web Ontology Language (OWL)](https://en.wikipedia.org/wiki/Web_Ontology_Language).

Other definitions
- [Qu'est-ce qu'une ontologie ?](http://www.journaldunet.com/developpeur/tutoriel/theo/070403-ontologie.shtml) - Journal du Net
- [Ontology Development 101: A Guide to Creating Your First Ontology](http://protege.stanford.edu/publications/ontology_development/ontology101.pdf) - Stanford

## Ontology

### Classes

In order to illustrate the components that constitute an ontology, we sketch below the very first draft of what the StoreConnect sensor ontology could be. This example is not meant to the complete (we still have to discuss many points about it), but to illustrate the concepts introduced beneath. This ontology is composed of the three following core classes: __Sensor__, __Sensor_base__, and __Sensor_extra__.

__Sensor__
It's the key node of our ontology. Every available sensor is a `Sensor`. From this node, we can access all properties.</dd>

__Sensor_base__
This node gives access to all the basic properties common to every sensors such as, `battery level`, `current time`, `physical position` etc. Those properties goal is to tag data pushed by sensors or simply control / configure them. Example:

__Sensor_extra__
Contains specifics capacities of sensors, some may have `location`, some `recognition` and others none of them such as RFID.

- Recognition
Matches with the cameras, this node gives access to different concepts such as detecting some groups (size, gender, etc.), some gestures (take, drop, focus on, etc.) or some emotions (happy, neutral, etc.).

- Location
Gives access to concepts such as user tracking.

![Ontology](images/ontology.png)

### Relations

Two kinds of relations are defined between these core classes: plain arrows denote relations of type extension, and dotted arrows denote relations of type constraints.

The idea behind the notion of extension is to allow refining a concept. For example, the class __Sensor__ is extended by __Beacon_sensor__, __Apisense_sensor__, and __Camera_sensor__. The idea is to capture in the class __Sensor__ the characteristics that are common to all sensors, and to provide a subconcept for each kind of different sensors. By the same way, the three core classes __Sensor__, __Sensor_base__, and __Sensor_extra__, extend __Independent_entity__ that is a root, application-independent class, for all ontologies.

Relations of type constraint denote dependencies other than the notion of subconcept. For example, __Sensor_base__ is related to __Sensor__. This relation denotes the idea that every sensor _has_ some basic characteristics whose root class is __Sensor_base__. This class is itself refined into the three subconcepts __Timestamp_base__, __Location_base__, and __Accurary_base__.

### Data representation

The JSON below is an open proposition on the data pushed by sensors API.

```json
{
	"metadata": {
		"timestamp": "1977-04-22T01:00:00-05:00",
		"state": "ENABLED",
		"battery": "42",
		"position": {
			
		}
	},
	"detected": {
		"user": "110e8400-e29b-11d4-a716-446655440000",
		"do": {
			"action": "TAKE",
			"what": "ARTICLE_REF"
		}
	}
}
```

## Queries

One of the goals of the ontology is to be able to serve as a support to answer high-level semantical queries that are related to the sensors of the StoreConnect platform.

The list of queries that we may want to answer follows. This list is not closed and this document will serve as a way to collect them. The purpose is also that these queries serve as requirement to assess the completeness of the ontology.

- What are the sensors that can provide the information about the path taken by a specific, given his name (or id), customer?


## How to contribute

You can contribute to this ontology using [Protégé](http://protege.stanford.edu/) and summit your request within a `pull request` 
following the [contributing](CONTRIBUTING.md) instructions. 
