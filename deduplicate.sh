#!/usr/bin/env bash
###############################################################################
# Bash script to take dataset, find duplicates and create
# a copy of the dataset without near code duplicates
#
# Usage: sh deduplicate.sh target/project/path output/folder/path
#   if target/project/path is not specified, script falls
#   back to DEFAULT_TARGET_PROJECT_PATH. Same for output.
###############################################################################
# Change the following values to preprocess a new dataset.
# PATH_TO_TOKENIZER - Path to the tokenizer JAR
# DEFAULT_TARGET_PROJECT_PATH - Path to target project if
#   not specified by parameters
# TOKENIZER_OUTPUT_PATH - Output for the tokenizer
# IDENTIFIER_ONLY - Boolean to specify if tokenizing only
#   identifiers or all possible text in code
#
# DUPLICATE_DETECTOR_PROJECT_PATH - Path to DuplicateCodeDetector project
# DUPLICATE_DETECTOR_PATH - Path to the DuplicateCodeDetector c# entry file
#
# DEDUPLICATE_PROJECT_PATH - Path for the resulting deduplicated project
# DEDUPLICATION_DATA - Path to temporarily save deduplication data as JSON form
#
# JAVA - java 1.8 alias
# DOTNET - dotnet alias
# PYTHON - python3 interpreter alias.
###############################################################################
# Changing DEFAULT_TARGET_PROJECT_PATH or specifing it
# in program argument is enough for most users.
DEFAULT_TARGET_PROJECT_PATH="path/to/project/if/not/specified/in/parameters"
#${nr:-value} used to parse arguments in order of entry or fall back to "value"
TARGET_PROJECT_PATH=${1:-${DEFAULT_TARGET_PROJECT_PATH}}
###############################################################################
PATH_TO_TOKENIZER="tokenizers/java/target/javatokenizer-1.0-SNAPSHOT.jar"
TOKENIZER_OUTPUT_PATH="output/"
IDENTIFIER_ONLY="true"

DUPLICATE_DETECTOR_PROJECT_PATH="DuplicateCodeDetector"
DUPLICATE_DETECTOR_PATH="${DUPLICATE_DETECTOR_PROJECT_PATH}/DuplicateCodeDetector.csproj"

DEFAULT_DEDUPLICATE_PROJECT_PATH="deduplicated_results"
DEDUPLICATE_PROJECT_PATH=${2:-${DEFAULT_DEDUPLICATE_PROJECT_PATH}}
DEDUPLICATION_DATA="${DUPLICATE_DETECTOR_PROJECT_PATH}/DuplicateCodeDetector.csproj.json"

JAVA=java
DOTNET=dotnet
PYTHON=python

rm -rf ${DEDUPLICATE_PROJECT_PATH}

echo "Running tokenizer..."
${JAVA} -jar ${PATH_TO_TOKENIZER} ${TARGET_PROJECT_PATH} ${TOKENIZER_OUTPUT_PATH} ${IDENTIFIER_ONLY}
echo "Tokenizer finished."

echo "Running near duplicate code detection..."
${DOTNET} run ${DUPLICATE_DETECTOR_PATH} --project=${DUPLICATE_DETECTOR_PROJECT_PATH} --dir=${TOKENIZER_OUTPUT_PATH}
echo "Near duplicate code detection finished."

echo "Copying project to ${DEDUPLICATE_PROJECT_PATH}"
cp -r ${TARGET_PROJECT_PATH}/. ${DEDUPLICATE_PROJECT_PATH}
echo "Copying finished"

echo "Removing duplicates from the copy"
${PYTHON} deduplicate.py --project ${DEDUPLICATE_PROJECT_PATH} --duplicates_data ${DEDUPLICATION_DATA}
echo "Finished removing near duplicates"
echo "Untouched project location: ${TARGET_PROJECT_PATH}"
echo "Resulting project with duplicates removed: ${DEDUPLICATE_PROJECT_PATH}"

# If all went well, tokenizer output is not needed anymore
rm -r ${TOKENIZER_OUTPUT_PATH}