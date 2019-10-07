version 1.0

import "modules/SortIndexBam.wdl" as SortIndexBam

workflow SortIndexBam {

    input {
        File taggedBam
    }

    call SortIndexBam.SortIndexBam {
        input:
            inBam = taggedBam
    }
}
