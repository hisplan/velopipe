#!/usr/bin/env bash

java -jar ~/Applications/womtool.jar \
    validate \
    Velopipe.wdl \
    --inputs Velopipe.inputs.json
