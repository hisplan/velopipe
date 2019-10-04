version 1.0

import "modules/TagBam.wdl" as TagBam

workflow TagBam {

    input {
        File countMatrix
        File bam
        File bai
    }

    call TagBam.TagBam {
        input:
            countMatrix = countMatrix,
            inBam = bam,
            inBai = bai,
            outBam = basename(bam, ".bam") + ".tagged.bam"
    }
}
