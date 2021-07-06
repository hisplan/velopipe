#!/usr/bin/env bash

java -jar ~/Applications/womtool.jar \
    validate \
    Velopipe.old.wdl \
    --inputs ./config/test.old.inputs.aws.json
