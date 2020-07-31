version 1.0

import "modules/SplitBam.wdl" as SplitBam

workflow SplitBam {

    input {
        File inBam
        Int numOfChunks
    }

    call SplitBam.SplitBam {
        input:
            inBam = inBam,
            numOfChunks = numOfChunks
    }
}
