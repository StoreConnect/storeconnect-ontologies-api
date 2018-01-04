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

externalClasses=()

withoutConceptInheritance='false'
withoutConceptInstanciation='false'

# Internal variable definition

APP=`basename $0`

tmpFile=''

conceptInheritanceExists='false'
conceptInstanciationExists='false'
conceptRestrictionExists='false'
externalClassExists='false'

conceptInheritanceColor=chartreuse4
conceptInstanciationColor=darkolivegreen3
conceptRestrictionColor=springgreen4
externalClassColor=grey50

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
    echo '      -e | --external-class CLASS             The OWL class to mark as external and so display it with a different color as the internal default ones.'
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
            -e|--external-class)
                externalClasses+=("$2")
                shift
                ;;
            -i|--without-instanciation)
                withoutConceptInstanciation='true'
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
    parseOptions "$@"
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

function enhanceConceptInheritances {
    sed "s/\(.*\)\[label=\"has subclass\"\]/\1 \[dir=back; arrowtail=onormal; color=$conceptInheritanceColor; fontcolor=$conceptInheritanceColor\]/" "$outputFile" > "$tmpFile"
    if [[ "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        conceptInheritanceExists='true'
    fi
    mv "$tmpFile" "$outputFile"
}

function enhanceConceptInstanciations {
    sed "s/\(.*\)\[label=\"has individual\"\]/\1 \[dir=back; arrowtail=onormal; color=$conceptInstanciationColor; fontcolor=$conceptInstanciationColor\]/" "$outputFile" > "$tmpFile"
    if [[ "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        conceptInstanciationExists='true'
    fi
    mv "$tmpFile" "$outputFile"
}

function enhanceConceptRestrictions {
    sed "s/\(.*\)\[label=\"\(.*\)(Subclass all)\"\]/\1\[color=$conceptRestrictionColor; fontcolor=$conceptRestrictionColor; label=\"\2 (1)\"\]/" "$outputFile" > "$tmpFile"
    if [[ "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        conceptRestrictionExists='true'
    fi
    mv "$tmpFile" "$outputFile"
    sed "s/\(.*\)\[label=\"\(.*\)(Subclass some)\"\]/\1\[color=$conceptRestrictionColor; fontcolor=$conceptRestrictionColor; label=\"\2 (1..n)\"\]/" "$outputFile" > "$tmpFile"
    if [[ $conceptRestrictionExists == 'false' && "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        conceptRestrictionExists='true'
    fi
    mv "$tmpFile" "$outputFile"
    sed "s/\(.*\)\[label=\"\(.* (.*)\)\"\]/\1\[color=$conceptRestrictionColor; fontcolor=$conceptRestrictionColor; label=\"\2\"\]/" "$outputFile" > "$tmpFile"
    if [[ $conceptRestrictionExists == 'false' && "$(areFilesDifferents $outputFile $tmpFile)" == 'true' ]]; then
        conceptRestrictionExists='true'
    fi
    mv "$tmpFile" "$outputFile"
}

function enhanceConcepts {
    enhanceConceptInheritances
    enhanceConceptInstanciations
    enhanceConceptRestrictions
}

function enhanceExternalClasses {
    if ((${#externalClasses[@]} == 0)); then
        return 0;
    fi

    externalClassesExists='true'
    externalNodes=''
    for ((i = 0; i < ${#externalClasses[@]}; i++)); do
        externalNodes="$externalNodes \"${externalClasses[$i]}\" [color=$externalClassColor; fontcolor=$externalClassColor]"
    done

    sed "s/\(\}\)/$externalNodes \1/" "$outputFile" > "$tmpFile" && mv "$tmpFile" "$outputFile"
}

function addLegend {
    # Dynamically construct legend according to existing elements
    legend="subgraph cluster_Legend {
                graph [label=\"Legend\"]
    "
    if [[ $externalClassesExists == 'true' ]]; then
        legend="$legend
                 External1 [label=\"External concept\"; color=$externalClassColor; fontcolor=$externalClassColor]
        "
    fi
    if [[ $conceptRestrictionExists == 'true' ]]; then
        legend="$legend
                 Restriction1 [label=\"Concept1\"]
                 Restriction2 [label=\"Concept2\"]
                 Restriction1 -> Restriction2 [color=$conceptRestrictionColor; fontcolor=$conceptRestrictionColor; label=\"Restriction from Concept1 to Concept2\"]
        "
    fi
    if [[ $conceptInstanciationExists == 'true' ]]; then
        legend="$legend
                 Instanciation1 [label=\"Concept1\"]
                 Instanciation2 [label=\"Concept2\"]
                 Instanciation1 -> Instanciation2 [color=$conceptInstanciationColor; fontcolor=$conceptInstanciationColor; label=\"Concept1 is an intance of Concept2\"]
        "
    fi
    if [[ $conceptInheritanceExists == 'true' ]]; then
        legend="$legend
                 Inheritance1 [label=\"Concept1\"]
                 Inheritance2 [label=\"Concept2\"]
                 Inheritance1 -> Inheritance2 [arrowhead=onormal; color=$conceptInheritanceColor; fontcolor=$conceptInheritanceColor; label=\"Concept1 extends Concept2\"]
        "
    fi
    legend="$legend }"
    
    # Transform to a single line for sed
    legend=`echo $legend | tr -d '\n'`

    sed "s/\(\}\)/$legend \1/" "$outputFile" > "$tmpFile" && mv "$tmpFile" "$outputFile"
}

function enhance {
    prepareOutputFile
    enhanceConcepts
    enhanceExternalClasses
    addLegend
} 

function main {
    checkOptions "$@"
    enhance
}

#######################################
# Entry point                         #
#######################################

# Fail at any error
set -e

# Execute main entry point
main "$@"
