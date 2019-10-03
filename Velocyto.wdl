version 1.0

workflow Velopipe {

    input {
        File countMatrix
        File bam
        File bai
        File gtf
        File barcodeWhitelist
    }

    call TagBam {
        input:
            countMatrix = countMatrix,
            inBam = bam,
            inBai = bai,
            outBam = basename(bam, ".bam") + ".tagged.bam"
    }

    call SortIndexBam {
        input:
            inBam = TagBam.outTaggedBam
    }

    call Velocyto {
        input:
            bam = SortIndexBam.outSortedBam,
            gtf = gtf,
            barcodeWhitelist = barcodeWhitelist
    }

    output {
        File outBam = SortIndexBam.outSortedBam
        File outBai = SortIndexBam.outSortedBai
        File outLoom = Velocyto.outLoom
    }
}

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
        disks: "local-disk " + ceil(2 * (if inputSize < 1 then 1 else inputSize )) + " HDD"
        cpu: 1
        memory: "16 GB"
        preemptible: 0
    }
}

task SortIndexBam {

    input {
        File inBam
    }

    String dockerImage = "hisplan/cromwell-samtools:1.9"
    Float inputSize = size(inBam, "GiB")
    Int numCores = 8

    String outBam = basename(inBam, ".bam") + ".sorted.bam"

    command <<<
        set -euo pipefail

        samtools sort --threads ~{numCores} -o ~{outBam} ~{inBam}
        samtools index ~{outBam}
    >>>

    output {
        File outSortedBam = outBam
        File outSortedBai = outBam + ".bai"
    }

    runtime {
        docker: dockerImage
        disks: "local-disk " + ceil(2 * (if inputSize < 1 then 1 else inputSize )) + " HDD"
        cpu: numCores
        memory: "16 GB"
        preemptible: 0
    }
}

task Velocyto {

    input {
        File bam
        File gtf
        File barcodeWhitelist
    }

    String dockerImage = "hisplan/cromwell-velocyto:0.17.17"
    Float inputSize = size(bam, "GiB") + size(gtf, "GiB") + size(barcodeWhitelist, "GiB")
    Int numCores = 8

    command <<<
        set -euo pipefail

        velocyto run \
            --bcfile ~{barcodeWhitelist} \
            --outputfolder outs \
            --samtools-threads ~{numCores} \
            -vv \
            ~{bam} \
            ~{gtf}

    >>>

    output {
        File outLoom = glob("./outs/*.loom")[0]
    }

    runtime {
        docker: dockerImage
        disks: "local-disk " + ceil(2 * (if inputSize < 1 then 1 else inputSize )) + " HDD"
        cpu: numCores
        memory: "16 GB"
        preemptible: 0
    }
}
