#!/bin/bash

usage()
{
cat << EOF
USAGE: `basename $0` [options]
    -k  service account key (e.g. secrets.json)
    -i  inputs file (e.g. sample.inputs.json)
    -l  labels file (e.g. labels.json)
    -o  options file (e.g. options.json)
EOF
}

while getopts "k:i:l:o:h" OPTION
do
    case $OPTION in
        k) service_account_key=$OPTARG ;;
        i) inputs_file=$OPTARG ;;
        l) labels_file=$OPTARG ;;
        o) options_file=$OPTARG ;;
        h) usage; exit 1 ;;
        *) usage; exit 1 ;;
    esac
done

if [ -z "$service_account_key" ] || [ -z "$inputs_file" ] || [ -z "$labels_file" ] || [ -z "$options_file" ]
then
    usage
    exit 1
fi

rm -rf Velopipe.deps.zip
zip Velopipe.deps.zip modules modules/*

# $ unzip -l Velopipe.deps.zip
# Archive:  Velopipe.deps.zip
#   Length      Date    Time    Name
# ---------  ---------- -----   ----
#         0  10-04-2019 10:37   modules/
#       762  10-04-2019 13:42   modules/SortIndexBam.wdl
#       848  10-04-2019 10:27   modules/TagBam.wdl
#       947  10-07-2019 10:29   modules/Velocyto.wdl
# ---------                     -------
#      2557                     4 files


cromwell-tools submit \
    --secrets-file ${service_account_key} \
    --wdl Velopipe.wdl \
    --deps-file Velopipe.deps.zip \
    --inputs-files ${inputs_file} \
    --label-file ${labels_file} \
    --options-file ${options_file}
