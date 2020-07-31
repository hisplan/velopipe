version 1.0

import "modules/SplitBam.wdl" as SplitBam
import "modules/SortIndexBam.wdl" as SortIndexBam
import "modules/TagBam2.wdl" as TagBam2
import "modules/MergeBam.wdl" as MergeBam

workflow TagBam2 {

    input {
        String sampleName
        File inBam
        Int numOfChunks
        File whitelist
        File cbCorrection
        File umiCorrection
    }

    call SplitBam.SplitBam {
        input:
            inBam = inBam,
            numOfChunks = numOfChunks
    }

    scatter (bam in SplitBam.outBam) {
        call SortIndexBam.SortIndexBam {
            input:
                inBam = bam
        }
    }

    call TagBam2.TagBam2 {
        input:
            inBam = SortIndexBam.outSortedBam,
            inBai = SortIndexBam.outSortedBai,
            whitelist = whitelist,
            cbCorrection = cbCorrection,
            umiCorrection = umiCorrection
    }

    call MergeBam.MergeBam {
        input:
            chunks = TagBam2.outTaggedBam,
            fileName = sampleName + ".tagged.bam"
    }
}
