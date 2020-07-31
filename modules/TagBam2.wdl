version 1.0

task TagBam2 {

    input {
        Array[File] inBam
        Array[File] inBai
        File whitelist
        File cbCorrection
        File umiCorrection
    }

    # .bai should be localized so that tag_bam.py can pick it up
    # otherwise, pysam.fetch will error out (called on bamfile without index)

    String dockerImage = "hisplan/seqc-utils:0.4.5"
    Float inputSize = size(inBam, "GiB") + size(inBai, "GiB") + size(whitelist, "GiB") + size(cbCorrection, "GiB") + size(umiCorrection, "GiB")

    command <<<
        set -euo pipefail

        # chunks must be in all in the same directory
        mkdir -p data

        # move *.bam to ./data/
        for file in ~{sep=' ' inBam}
        do
            mv ${file} data/
        done

        # move *.bai to ./data/
        for file in ~{sep=' ' inBai}
        do
            # refresh the index file
            # to avoid the warning the index file is older than the data file:)
            touch ${file}

            mv ${file} data/
        done

        python3 /opt/tag_bam2.py \
            --chunks data/ \
            --whitelist ~{whitelist} \
            --cb-correction ~{cbCorrection} \
            --umi-correction ~{umiCorrection}

        find data/
    >>>

    output {
        Array[File] outTaggedBam = glob("data/*.tagged.bam")
        File outLog = "tag_bam.log"
    }

    runtime {
        docker: dockerImage
        # disks: "local-disk " + ceil(10 * (if inputSize < 1 then 5 else inputSize)) + " HDD"
        cpu: 16
        memory: "64 GB"
        preemptible: 0
    }
}
