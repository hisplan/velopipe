version 1.0

task Velocyto {

    input {
        File bamCBSorted
        File bamPosSorted
        File baiPosSorted
        File gtf
        File filteredBarcodeSet
    }

    String dockerImage = "hisplan/cromwell-velocyto:0.17.17"
    Float inputSize = size(bamCBSorted, "GiB") + size(bamPosSorted, "GiB") + size(baiPosSorted, "GiB") + size(gtf, "GiB") + size(filteredBarcodeSet, "GiB")
    Int numCores = 4

    command <<<
        set -euo pipefail

        # velocyto looks for the cell barcode sorted bam file.
        # filename must be "cellsorted_${position-sorted_bam}"
        # internal buggy sorting will be skipped if provided.
        dir_only=`dirname ~{bamPosSorted}`
        filename_only=`basename ~{bamPosSorted}`
        ln -s ~{bamCBSorted} ${dir_only}/cellsorted_${filename_only}

        # the index file is older than the data file
        touch ~{baiPosSorted}

        # total memory / threads
        velocyto run \
            --bcfile ~{filteredBarcodeSet} \
            --outputfolder outs \
            -vv \
            ~{bamPosSorted} \
            ~{gtf}

    >>>

    output {
        File outLoom = glob("./outs/*.loom")[0]
    }

    runtime {
        docker: dockerImage
        # disks: "local-disk " + ceil(10 * (if inputSize < 1 then 5 else inputSize)) + " HDD"
        cpu: numCores
        memory: "32 GB"
        preemptible: 0
    }
}
