#!/usr/bin/env bash

java -jar ~/Applications/womtool.jar \
    validate \
    Velopipe2.wdl \
    --inputs ./config/test2.inputs.aws.json
