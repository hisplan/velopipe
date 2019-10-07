#!/bin/bash

usage()
{
cat << EOF
USAGE: `basename $0` [options]
    -k  service account key (e.g. secrets.json)
    -c  input JSON file
EOF
}

while getopts "k:c:h" OPTION
do
    case $OPTION in
        k) service_account_key=$OPTARG ;;
        c) config_json=$OPTARG ;;
        h) usage; exit 1 ;;
        *) usage; exit 1 ;;
    esac
done

if [ -z "$service_account_key" ] || [ ! -r "$config_json" ]
then
    usage
    exit 1
fi

# generating label
# t1b.inputs.json --> t1b
label=`basename ${config_json} | awk -F'.' '{ print $1 }'`

path_label="./config/${label}.labels.json"

cat > ${path_label} <<FILE
{
    "comment": "${label}"
}
FILE

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

# subtmit
cromwell-tools submit \
    --secrets-file ${service_account_key} \
    --wdl Velopipe.wdl \
    --inputs-files ${config_json} \
    --deps-file Velopipe.deps.zip \
    --label-file ${path_label}
