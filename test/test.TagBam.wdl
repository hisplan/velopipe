version 1.0

import "modules/TagBam.wdl" as TagBam

workflow TagBam {

    input {
        File whitelist
        File bam
        File bai

        # docker-related
        String dockerRegistry
    }

    call TagBam.TagBam {
        input:
            whitelist = whitelist,
            inBam = bam,
            inBai = bai,
            outBam = basename(bam, ".bam") + ".tagged.bam",
            dockerRegistry = dockerRegistry
    }
}
