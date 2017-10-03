#!/bin/bash
#
# Enhance DOT graph produced by the Protege's OntoGraf plugin
#
# @author Aurelien Bourdon

#######################################
# Variables definition                #
#######################################

# Optional variable definition

sourceFile=''
outputFile=''

disabledItems=()

withoutInheritance='false'
withoutComposition='false'
withoutAssociation='false'
withoutInteraction='false'
withoutInstanciation='false'

# Internal variable definition

APP=`basename $0`

tmpFile=''

inheritanceExists='false'
compositionExists='false'
associationExists='false'
interactionExists='false'
instanciationExists='false'
disabledItemsExists='false'

inheritanceConceptColor=chartreuse4
compositionConceptColor=chartreuse3
associationConceptColor=darkolivegreen3
instanciationConceptColor=springgreen4
conceptInteractionColor=orangered4
disabledItemColor=grey75

#######################################
# Function definitions                #
#######################################

function log {
    level="$1"
    message="$2"
    echo "$APP [$level] $message"
}

function error {
    log "ERROR" "$*"
}

function info {
    log "INFO" "$*"
}

function usage {
    echo "${APP}: Enhance a DOT graph produced bu the Protege's OntoGraf plugin."
    echo "Usage: ${APP} [OPTIONS] SOURCE"
    echo 'OPTIONS:'
    echo '      -o | --output PATH                      Path of the output file. The same as source path by default (so overwrite it).'
    echo '      -d | --disabled-item ITEM               The RDF subject or object to disable (and its associated relation lines).'
    echo '                                              Option can be repeated to define several items to disable. For instance: -d FOO -d BAR, will disable item FOO and BAR and their associated relations lines.'
    echo "      -i | --without-instanciation            If set, enhance OntoGraf's DOT file without including concept's instances."
    echo '      -h | --help                             Display this helper message.'
    exit 0
}

function parseOptions {
    while [[ $# -gt 0 ]]; do
        argument=$1
        case $argument in
            -h|--help)
                usage;
                ;;
            -d|--disabled-item)
                disabledItems+=("$2")
                shift
                ;;
            -i|--without-instanciation)
                withoutInstanciation='true'
                ;;
            -o|--output)
                outputFile="$2"
                shift
                ;;
            *)
                sourceFile="$1"
                ;;
        esac
        shift
    done
}

function checkAndFinalizeSourceFile {
    if [ ! -f "$sourceFile" ]; then
        error "\"$sourceFile\" cannot be read. Exiting"
        exit 1
    fi
    tmpFile="$sourceFile.tmp"
}

function checkAndFinalizeOutputFile {
    if [[ $outputFile == '' ]]; then
        outputFile="$sourceFile"
    fi 
}

function checkAndFinalizeOptions {
    checkAndFinalizeSourceFile
    checkAndFinalizeOutputFile
}

function checkOptions {
    parseOptions $*
    checkAndFinalizeOptions
}

function areFilesDifferents {
    if diff "$1" "$2" > /dev/null; then
        echo 'false'
    else
        echo 'true'
    fi
}

function prepareOutputFile {
    sourceFilePath=$(cd "$(dirname "$sourceFile")"; pwd)/$(basename "$sourceFile")
    outputFilePath=$(cd "$(dirname "$outputFile")"; pwd)/$(basename "$outputFile")
    if [[ "$sourceFilePath" != "$outputFilePath" ]]; then
        cp -f "$sourceFile" "$outputFile"
    fi
}

function enhanceInheritanceConceptDefinition {
    sed "s/\(.*\)\[label=\"has subclass\"\]/\1 \[dir=back; arrowtail=onormal; color=$inheritanceConceptColor; fontcolor=$inheritanceConceptColor\]/" "$outputFile" > "$tmpFile"
    if [[ "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        inheritanceExists='true'
    fi
    mv "$tmpFile" "$outputFile"
}

function enhanceCompositionConceptDefinition {
    sed "s/\(.*\)\[label=\"isComposedOf(Subclass all)\"\]/\1 \[dir=back; arrowtail=odiamond; color=$compositionConceptColor; fontcolor=$compositionConceptColor; label=\"1\"\]/" "$outputFile" > "$tmpFile"
    if [[ "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        compositionExists='true'
    fi
    mv "$tmpFile" "$outputFile"
    sed "s/\(.*\)\[label=\"isComposedOf(Subclass some)\"\]/\1 \[dir=back; arrowtail=odiamond; color=$compositionConceptColor; fontcolor=$compositionConceptColor; label=\"1..n\"\]/" "$outputFile" > "$tmpFile"
    if [[ $compositionExists == 'false' && "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        compositionExists='true'
    fi
    mv "$tmpFile" "$outputFile"
}

function enhanceAssociationConceptDefinition {
    sed "s/\(.*\)\[label=\"isAssociatedTo(Subclass all)\"\]/\1 \[color=$associationConceptColor; fontcolor=$associationConceptColor; label=\"1\"\]/" "$outputFile" > "$tmpFile"
    if [[ "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        associationExists='true'
    fi
    mv "$tmpFile" "$outputFile"
    sed "s/\(.*\)\[label=\"isAssociatedTo(Subclass some)\"\]/\1 \[color=$associationConceptColor; fontcolor=$associationConceptColor; label=\"1..n\"\]/" "$outputFile" > "$tmpFile"
    if [[ $associationExists == 'false' && "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        associationExists='true'
    fi
    mv "$tmpFile" "$outputFile"
}

function enhanceInstanciationConceptDefinition {
    sed "s/\(.*\)\[label=\"has individual\"\]/\1 \[dir=back; color=$instanciationConceptColor; fontcolor=$instanciationConceptColor; label=\"instanceOf\"\]/" "$outputFile" > "$tmpFile"
    if [[ "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        instanciationExists='true'
    fi
    mv "$tmpFile" "$outputFile"
}

function enhanceConceptDefinition {
    enhanceInheritanceConceptDefinition
    enhanceCompositionConceptDefinition
    enhanceAssociationConceptDefinition
    enhanceInstanciationConceptDefinition
}

function enhanceConceptInteraction {
    sed "s/\(.*\)\[label=\"\(.*\)(Subclass all)\"\]/\1\[color=$conceptInteractionColor; fontcolor=$conceptInteractionColor; label=\"\2 (1)\"\]/" "$outputFile" > "$tmpFile"
    if [[ "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        interactionExists='true'
    fi
    mv "$tmpFile" "$outputFile"
    sed "s/\(.*\)\[label=\"\(.*\)(Subclass some)\"\]/\1\[color=$conceptInteractionColor; fontcolor=$conceptInteractionColor; label=\"\2 (1..n)\"\]/" "$outputFile" > "$tmpFile"
    if [[ $interactionExists == 'false' && "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        interactionExists='true'
    fi
    mv "$tmpFile" "$outputFile"
    sed "s/\(.*\)\[label=\"\(.* (.*)\)\"\]/\1\[color=$conceptInteractionColor; fontcolor=$conceptInteractionColor; label=\"\2\"\]/" "$outputFile" > "$tmpFile"
    if [[ $interactionExists == 'false' && "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        interactionExists='true'
    fi
    mv "$tmpFile" "$outputFile"
}

function enhanceDisabledItems {
    if ((${#disabledItems[@]} == 0)); then
        return 0;
    fi

    disabledItemsExists='true'
    disabledNodes=''
    for disabledItem in ${disabledItems[@]}; do
        disabledNodes="$disabledNodes $disabledItem [color=$disabledItemColor; fontcolor=$disabledItemColor]"
        sed "s/\(.*\"$disabledItem\".*\)/\1 [color=$disabledItemColor; fontcolor=$disabledItemColor]/" "$outputFile" > "$tmpFile" && mv "$tmpFile" "$outputFile"
    done

    sed "s/\(\}\)/$disabledNodes \1/" "$outputFile" > "$tmpFile" && mv "$tmpFile" "$outputFile"
}

function addLegend {
    # Dynamically construct legend according to existing elements
    legend="subgraph cluster_Legend {
                graph [label=\"Legend\"]
    "
    if [[ $disabledItemsExists == 'true' ]]; then
        legend="$legend
                 Disable1 [label=\"Concept1\"; color=$disabledItemColor; fontcolor=$disabledItemColor]
                 Disable2 [label=\"Concept2\"; color=$disabledItemColor; fontcolor=$disabledItemColor]
                 Disable1 -> Disable2 [color=$disabledItemColor; fontcolor=$disabledItemColor; label=\"Not stable concepts and\/or integration\"]
        "
    fi
    if [[ $interactionExists == 'true' ]]; then
        legend="$legend
                 Interaction1 [label=\"Concept1\"]
                 Interaction2 [label=\"Concept2\"]
                 Interaction1 -> Interaction2 [color=$conceptInteractionColor; fontcolor=$conceptInteractionColor; label=\"Concept1 interacts with Concept2\"]
        "
    fi
    if [[ $instanciationExists == 'true' ]]; then
        legend="$legend
                 Instanciation1 [label=\"Concept1\"]
                 Instanciation2 [label=\"Concept2\"]
                 Instanciation1 -> Instanciation2 [color=$instanciationConceptColor; fontcolor=$instanciationConceptColor; label=\"Concept1 is an intance of Concept2\"]
        "
    fi
    if [[ $associationExists == 'true' ]]; then
        legend="$legend
                 Association1 [label=\"Concept1\"]
                 Association2 [label=\"Concept2\"]
                 Association1 -> Association2 [color=$associationConceptColor; fontcolor=$associationConceptColor; label=\"Concept1 is associated to Concept2\"]
        "
    fi
    if [[ $compositionExists == 'true' ]]; then
        legend="$legend
                 Composition1 [label=\"Concept1\"]
                 Composition2 [label=\"Concept2\"]
                 Composition1 -> Composition2 [arrowhead=odiamond; color=$compositionConceptColor; fontcolor=$compositionConceptColor; label=\"Concept2 is composed of Concept1\"]
        "
    fi
    if [[ $inheritanceExists == 'true' ]]; then
        legend="$legend
                 Inheritance1 [label=\"Concept1\"]
                 Inheritance2 [label=\"Concept2\"]
                 Inheritance1 -> Inheritance2 [arrowhead=onormal; color=$inheritanceConceptColor; fontcolor=$inheritanceConceptColor; label=\"Concept1 extends Concept2\"]
        "
    fi
    legend="$legend }"
    
    # Transform to a single line for sed
    legend=`echo $legend | tr -d '\n'`

    sed "s/\(\}\)/$legend \1/" "$outputFile" > "$tmpFile" && mv "$tmpFile" "$outputFile"
}

function enhance {
    prepareOutputFile
    enhanceConceptDefinition
    enhanceConceptInteraction
    enhanceDisabledItems
    addLegend
} 

function main {
    checkOptions $*
    enhance
}

#######################################
# Entry point                         #
#######################################

# Fail at any error
set -e

# Execute main entry point
main $*
