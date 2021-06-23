#!/usr/bin/env bash

java -jar ~/Applications/womtool.jar \
    validate \
    Velopipe.wdl \
    --inputs ./config/test.inputs.aws.json
