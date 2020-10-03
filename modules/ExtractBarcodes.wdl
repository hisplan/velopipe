version 1.0

task ExtractBarcodes {

    input {
        File countsMatrix
    }

    String dockerImage = "hisplan/seqc-utils:0.4.9-beta.5"
    Float inputSize = size(countsMatrix, "GiB")

    command <<<
        set -euo pipefail

        # get the error-corrected barcodes from the counts matrix
        python3 /opt/extract_barcodes.py \
            --matrix ~{countsMatrix} \
            --outdir results
    >>>

    output {
        File outFilteredBarcodesACGT = "results/barcodes.acgt.txt"
        File outFilteredBarcodes1234 = "results/barcodes.1234.txt"
    }

    runtime {
        docker: dockerImage
        # disks: "local-disk " + ceil(10 * (if inputSize < 1 then 5 else inputSize)) + " HDD"
        cpu: 1
        memory: "16 GB"
        preemptible: 0
    }
}
