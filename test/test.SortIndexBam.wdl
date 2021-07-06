version 1.0

import "modules/SortIndexBam.wdl" as SortIndexBam

workflow SortIndexBam {

    input {
        File taggedBam

        # docker-related
        String dockerRegistry
    }

    call SortIndexBam.SortIndexBam {
        input:
            inBam = taggedBam,
            dockerRegistry = dockerRegistry
    }
}
