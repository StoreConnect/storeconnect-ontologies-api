#!/bin/bash
#
# Enhance DOT graph produced by the Protege's OntoGraf plugin

owlFile=''
owlFileTmp=''

inheritanceConceptColor=chartreuse4
compositionConceptColor=chartreuse3
associationConceptColor=darkolivegreen3
instanciationConceptColor=springgreen4
conceptInteractionColor=orangered4
disabledItemColor=grey75

disabledItems=(SensorRelated Sensor Apisense Beacon Camera SensorData)

# Check options

function checkOwlFilePath {
    if [ -f "$1" ]; then
        owlFile="$1"
        owlFileTmp="$owlFile".tmp
        return 0;
    fi
    return 1; 
}

function checkOptions {
    checkOwlFilePath "$*"
}

function enhanceInheritanceConceptDefinition {
    sed "s/\(.*\)\[label=\"has subclass\"\]/\1 \[dir=back; arrowtail=onormal; color=$inheritanceConceptColor; fontcolor=$inheritanceConceptColor\]/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
}

function enhanceCompositionConceptDefinition {
    sed "s/\(.*\)\[label=\"isComposedOf(Subclass all)\"\]/\1 \[dir=back; arrowtail=odiamond; color=$compositionConceptColor; fontcolor=$compositionConceptColor; label=\"1\"\]/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
    sed "s/\(.*\)\[label=\"isComposedOf(Subclass some)\"\]/\1 \[dir=back; arrowtail=odiamond; color=$compositionConceptColor; fontcolor=$compositionConceptColor; label=\"1..n\"\]/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
}

function enhanceAssociationConceptDefinition {
    sed "s/\(.*\)\[label=\"isAssociatedTo(Subclass all)\"\]/\1 \[color=$associationConceptColor; fontcolor=$associationConceptColor; label=\"1\"\]/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
    sed "s/\(.*\)\[label=\"isAssociatedTo(Subclass some)\"\]/\1 \[color=$associationConceptColor; fontcolor=$associationConceptColor; label=\"1..n\"\]/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
}

function enhanceInstanciationConceptDefinition {
    sed "s/\(.*\)\[label=\"has individual\"\]/\1 \[dir=back; color=$instanciationConceptColor; fontcolor=$instanciationConceptColor; label=\"instanceOf\"\]/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
}

function enhanceConceptDefinition {
    enhanceInheritanceConceptDefinition
    enhanceCompositionConceptDefinition
    enhanceAssociationConceptDefinition
    enhanceInstanciationConceptDefinition
}

function enhanceConceptInteraction {
    sed "s/\(.*\)\[label=\"\(.*\)(Subclass all)\"\]/\1\[color=$conceptInteractionColor; fontcolor=$conceptInteractionColor; label=\"\2 (1)\"\]/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
    sed "s/\(.*\)\[label=\"\(.*\)(Subclass some)\"\]/\1\[color=$conceptInteractionColor; fontcolor=$conceptInteractionColor; label=\"\2 (1..n)\"\]/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
    sed "s/\(.*\)\[label=\"\(.* (.*)\)\"\]/\1\[color=$conceptInteractionColor; fontcolor=$conceptInteractionColor; label=\"\2\"\]/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
}

function enhanceDisabledItems {
    disabledNodes=''
    for disabledItem in ${disabledItems[@]}; do
        disabledNodes="$disabledNodes $disabledItem [color=$disabledItemColor; fontcolor=$disabledItemColor]"
        sed "s/\(.*\"$disabledItem\".*\)/\1 [color=$disabledItemColor; fontcolor=$disabledItemColor]/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
    done

    sed "s/\(\}\)/$disabledNodes \1/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
}

function addLegend {
    legend="subgraph cluster_Legend {
                graph [label=\"Legend\"]
             
                 Inheritance1 [label=\"Concept1\"]
                 Inheritance2 [label=\"Concept2\"]
                 Inheritance1 -> Inheritance2 [arrowhead=onormal; color=$inheritanceConceptColor; fontcolor=$inheritanceConceptColor; label=\"Concept1 extends Concept2\"]
                 
                 Composition1 [label=\"Concept1\"]
                 Composition2 [label=\"Concept2\"]
                 Composition1 -> Composition2 [arrowhead=odiamond; color=$compositionConceptColor; fontcolor=$compositionConceptColor; label=\"Concept2 is composed of Concept1\"]
                 
                 Association1 [label=\"Concept1\"]
                 Association2 [label=\"Concept2\"]
                 Association1 -> Association2 [color=$associationConceptColor; fontcolor=$associationConceptColor; label=\"Concept1 is associated to Concept2\"]
                 
                 Instanciation1 [label=\"Concept1\"]
                 Instanciation2 [label=\"Concept2\"]
                 Instanciation1 -> Instanciation2 [color=$instanciationConceptColor; fontcolor=$instanciationConceptColor; label=\"Concept1 is an intance of Concept2\"]
                 
                 Interaction1 [label=\"Concept1\"]
                 Interaction2 [label=\"Concept2\"]
                 Interaction1 -> Interaction2 [color=$conceptInteractionColor; fontcolor=$conceptInteractionColor; label=\"Concept1 interacts with Concept2\"]
         }
    "
    # Remove new lines for sed
    legend=`echo $legend | tr -d '\n'`

    sed "s/\(\}\)/$legend \1/" "$owlFile" > "$owlFileTmp" && mv "$owlFileTmp" "$owlFile"
}

function enhanceOwlFile {
    enhanceConceptDefinition
    enhanceConceptInteraction
    #enhanceDisabledItems
    addLegend
} 

function main {
    checkOptions "$*"
    if [ $? -ne "0" ]; then
        echo "missing the DOT file path"
        exit 1
    fi
    enhanceOwlFile
}

main "$*"
