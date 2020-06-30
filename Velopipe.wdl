version 1.0

import "modules/TagBam.wdl" as TagBam
import "modules/SortIndexBam.wdl" as SortIndexBam
import "modules/Velocyto.wdl" as Velocyto

workflow Velopipe {

    input {
        File countMatrix
        File bam
        File? bai
        File gtf
        File barcodeWhitelist
        Boolean alreadySortedBam
    }

    # sort and index if not already
    if (!alreadySortedBam) {
        call SortIndexBam.SortIndexBam as SortIndexUntaggedBam {
            input:
                inBam = bam
        }
    }

    # pick the first non-null bam and bai
    File sortedBam = select_first([SortIndexUntaggedBam.outSortedBam, bam])
    File sortedBai = select_first([SortIndexUntaggedBam.outSortedBai, bai])

    call TagBam.TagBam {
        input:
            countMatrix = countMatrix,
            inBam = sortedBam,
            inBai = sortedBai,
            outBam = basename(sortedBam, ".bam") + ".tagged.bam"
    }

    call SortIndexBam.SortIndexBam as SortIndexTaggedBam {
        input:
            inBam = TagBam.outTaggedBam
    }

    call Velocyto.Velocyto {
        input:
            bam = SortIndexTaggedBam.outSortedBam,
            gtf = gtf,
            barcodeWhitelist = barcodeWhitelist
    }

    output {
        File outBam = SortIndexTaggedBam.outSortedBam
        File outBai = SortIndexTaggedBam.outSortedBai
        File outLoom = Velocyto.outLoom
    }
}
