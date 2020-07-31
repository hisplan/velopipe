version 1.0

import "modules/MergeBam.wdl" as MergeBam

workflow MergeBam {

    input {
        Array[File] chunks
        String fileName
    }

    parameter_meta {
        chunks: "list of chunked BAM files to be merged"
        fileName: "name of the merged BAM file *without* extension .bam"
    }

    call MergeBam.MergeBam {
        input:
            chunks = chunks,
            fileName = fileName
    }
}
