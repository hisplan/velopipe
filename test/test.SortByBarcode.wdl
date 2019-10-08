version 1.0

import "modules/SortByBarcode.wdl" as SortByBarcode

workflow SortByBarcode {

    input {
        File taggedBam
    }

    call SortByBarcode.SortByBarcode {
        input:
            inBam = taggedBam
    }
}
