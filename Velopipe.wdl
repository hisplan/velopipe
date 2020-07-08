version 1.0

import "modules/ExtractBarcodes.wdl" as ExtractBarcodes
import "modules/TagBam.wdl" as TagBam
import "modules/SortIndexBam.wdl" as SortIndexBam
import "modules/SortByBarcode.wdl" as SortByBarcode
import "modules/Velocyto.wdl" as Velocyto

workflow Velopipe {

    input {
        File countsMatrix
        File bam
        File? bai
        File gtf
        File barcodeWhitelist
        Boolean alreadySortedBam
    }

    call ExtractBarcodes.ExtractBarcodes {
        input:
            countsMatrix = countsMatrix
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
            whitelist = barcodeWhitelist,
            inBam = sortedBam,
            inBai = sortedBai,
            outBam = basename(sortedBam, ".bam") + ".tagged.bam"
    }

    # if the file cellsorted_${ORIGINAL-BAM-NAME} exists,
    # the sorting procedure will be skipped and the file present will be used.
    call SortByBarcode.SortByBarcode as CBSortedTaggedBam {
        input:
            inBam = TagBam.outTaggedBam
    }

    call SortIndexBam.SortIndexBam as PosSortedTaggedBam {
        input:
            inBam = TagBam.outTaggedBam
    }

    call Velocyto.Velocyto {
        input:
            bamCBSorted = CBSortedTaggedBam.outSortedBam,
            bamPosSorted = PosSortedTaggedBam.outSortedBam,
            baiPosSorted = PosSortedTaggedBam.outSortedBai,
            gtf = gtf,
            filteredBarcodeSet = ExtractBarcodes.outFilteredBarcodesACGT
    }

    output {
        File outCBSortedTaggedBam = CBSortedTaggedBam.outSortedBam
        File outPosSortedTaggedBam = PosSortedTaggedBam.outSortedBam
        File outPosSortedTaggedBai = PosSortedTaggedBam.outSortedBai
        File outLoom = Velocyto.outLoom
    }
}
