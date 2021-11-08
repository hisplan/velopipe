# velopipe

RNA Velocity for SEQC

## Setup

The pipeline is a part of SCING (Single-Cell pIpeliNe Garden; pronounced as "sing" /siŋ/). For setup, please refer to [this page](https://github.com/hisplan/scing). All the instructions below is given under the assumption that you have already configured SCING in your environment.

## Create Job Files

You need two files to compute RNA velocity - one inputs file and one labels file. Use the following example files to help you create your configuration file:

- `config/template.inputs.json`
- `config/template.labels.json`

For more information, please refer to [this page](docs/velopipe2-how-to-create-job-file.md):

## Submit Your Job

```bash
conda activate scing

./submit.sh \
    -k ~/keys/cromwell-secrets.json \
    -i config/your-sample.inputs.json \
    -l config/your-sample.labels.json \
    -o Velopipe.options.aws.json
```
\