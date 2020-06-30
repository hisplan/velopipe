version 1.0

task TagBam {

    input {
        File countMatrix
        File inBam
        File inBai
        String outBam
    }

    # .bai should be localized so that tag_bam.py can pick it up
    # otherwise, pysam.fetch will error out (called on bamfile without index)

    String dockerImage = "hisplan/seqc-utils:0.2"
    Float inputSize = size(countMatrix, "GiB") + size(inBam, "GiB")

    command <<<
        set -euo pipefail

        python3 /opt/tag_bam.py \
            --bam-in ~{inBam} \
            --bam-out ~{outBam} \
            --count-matrix ~{countMatrix}
    >>>

    output {
        File outTaggedBam = outBam
    }

    runtime {
        docker: dockerImage
        # disks: "local-disk " + ceil(10 * (if inputSize < 1 then 5 else inputSize)) + " HDD"
        cpu: 1
        memory: "16 GB"
        preemptible: 0
    }
}
