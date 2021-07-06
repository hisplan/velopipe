version 1.0

import "modules/SortByBarcode.wdl" as SortByBarcode

workflow SortByBarcode {

    input {
        File taggedBam

        # docker-related
        String dockerRegistry
    }

    call SortByBarcode.SortByBarcode {
        input:
            inBam = taggedBam,
            dockerRegistry = dockerRegistry
    }
}
