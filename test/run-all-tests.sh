#!/bin/bash -e

modules="TagBam2 MergeBam SplitBam ExtractBarcodes TagBam SortByBarcode SortIndexBam Velocyto"

for module_name in $modules
do

    echo "Testing ${module_name}..."
    
    ./run-test.sh -k ~/secrets-aws.json -m ${module_name}

done
