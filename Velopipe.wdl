version 1.0

import "modules/TagBam.wdl" as TagBam
import "modules/SortIndexBam.wdl" as SortIndexBam
import "modules/Velocyto.wdl" as Velocyto

workflow Velopipe {

    input {
        File countMatrix
        File bam
        File bai
        File gtf
        File barcodeWhitelist
    }

    call TagBam.TagBam {
        input:
            countMatrix = countMatrix,
            inBam = bam,
            inBai = bai,
            outBam = basename(bam, ".bam") + ".tagged.bam"
    }

    call SortIndexBam.SortIndexBam {
        input:
            inBam = TagBam.outTaggedBam
    }

    call Velocyto.Velocyto {
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
