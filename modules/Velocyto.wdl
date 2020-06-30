version 1.0

task Velocyto {

    input {
        File bam
        File gtf
        File barcodeWhitelist
    }

    String dockerImage = "hisplan/cromwell-velocyto:0.17.17"
    Float inputSize = size(bam, "GiB") + size(gtf, "GiB") + size(barcodeWhitelist, "GiB")
    Int numCores = 4

    command <<<
        set -euo pipefail

        velocyto run \
            --bcfile ~{barcodeWhitelist} \
            --outputfolder outs \
            --samtools-threads ~{numCores} \
            --samtools-memory 6144 \
            -vv \
            ~{bam} \
            ~{gtf}

    >>>

    output {
        File outLoom = glob("./outs/*.loom")[0]
    }

    # velocyto runs samtools internally.
    # 2GB per core is not enough and will fail.
    runtime {
        docker: dockerImage
        # disks: "local-disk " + ceil(10 * (if inputSize < 1 then 5 else inputSize)) + " HDD"
        cpu: numCores
        memory: "32 GB"
        preemptible: 0
    }
}
